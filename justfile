set shell := ["bash", "-eu", "-o", "pipefail", "-c"]

verify-focused:
    git diff --check
    python3 -m unittest discover -s tests -p 'test_foreman*.py'

verify:
    git diff --check "$(git merge-base HEAD origin/main)"
    python3 -m unittest discover -s tests -p 'test_foreman*.py'

# Inspect local contracts without contacting GitHub or starting a worker.
[positional-arguments]
foreman-validate file:
    python3 scripts/foreman.py validate --file "$1"

foreman-status:
    python3 scripts/foreman.py status

# Create the controller only on explicit operator invocation.
foreman-start:
    #!/usr/bin/env bash
    set -euo pipefail
    for tool in git just python3 tmux copilot timeout; do command -v "$tool" >/dev/null; done
    root="$(git rev-parse --show-toplevel)"
    python3 scripts/foreman.py status
    if tmux has-session -t '=foreman' 2>/dev/null; then
        test "$(tmux show-options -qv -t '=foreman' @foreman_root)" = "$root" || { echo "Conflicting foreman session; leave it untouched." >&2; exit 1; }
        echo "Existing Foreman session; use just foreman-attach to resume."
        exit 0
    fi
    tmux new-session -d -s foreman -n foreman -c "$root" 'just foreman-control'
    tmux set-option -t '=foreman' @foreman_root "$root"
    if [[ "$(tmux display-message -p -t foreman:foreman '#{window_index}')" != 0 ]]; then
        tmux move-window -s foreman:foreman -t foreman:0
    fi
    tmux set-option -t '=foreman' base-index 0
    tmux set-option -t '=foreman' renumber-windows off

foreman-control:
    copilot --agent foreman -i "Read .foreman/mission.json and reconcile the existing mission before scheduling. Follow the Foreman agent and its contracts."

foreman-attach:
    tmux attach-session -t '=foreman'

foreman-pause:
    python3 scripts/foreman.py pause

foreman-resume:
    python3 scripts/foreman.py resume

# Wakeups carry no executable text; every consumer rereads durable files.
foreman-wait:
    #!/usr/bin/env bash
    set -euo pipefail
    result=0
    timeout 30 tmux wait-for foreman-events || result=$?
    if [[ "$result" != 0 && "$result" != 124 ]]; then exit "$result"; fi

foreman-resources:
    git worktree list --porcelain
    tmux list-windows -t '=foreman' -F '#{window_index} #{window_name} #{pane_dead} #{pane_current_path} #{@foreman_attempt}'

foreman-observe:
    python3 scripts/foreman.py observe

foreman-context:
    git rev-parse HEAD
    git --no-pager log -5 --oneline
    git --no-pager status --short

foreman-backlog:
    gh issue list --state open --limit 100 --json number,title,body,url

# Backlog drafting is another primary session so rubber-duck is a leaf worker.
[positional-arguments]
foreman-issues file:
    #!/usr/bin/env bash
    set -euo pipefail
    root="$(git rev-parse --show-toplevel)"
    test "$(tmux show-options -qv -t '=foreman' @foreman_root)" = "$root" || { echo "Start the owned Foreman session first" >&2; exit 1; }
    test "$1" = .foreman/issue-request.json || { echo "Use the canonical issue request path" >&2; exit 1; }
    test -f "$1"
    if tmux list-windows -t '=foreman' -F '#{window_name}' | grep -Fxq backlog; then echo "Existing backlog console: reconcile its result before retrying." >&2; exit 1; fi
    tmux new-window -d -t foreman: -n backlog -c "$root" 'just foreman-issue-worker'

foreman-issue-worker:
    copilot --agent issue-generator -p "Read .foreman/issue-request.json. Act as the primary issue-generator session, create a separately reviewed issue for each candidate, use your rubber-duck review, reconcile already-created issues by request and candidate id, and persist each correlated result to .foreman/issue-result.json. Do not run RPIV."

# A reservation is retained on partial failure: reconcile, never blindly retry.
[positional-arguments]
foreman-launch issue permission="interactive":
    #!/usr/bin/env bash
    set -euo pipefail
    issue="$1"; permission="$2"
    [[ "$issue" =~ ^[1-9][0-9]*$ ]] || { echo "Invalid issue" >&2; exit 1; }
    [[ "$permission" == interactive || "$permission" == yolo ]] || { echo "Invalid permission mode" >&2; exit 1; }
    for tool in git just python3 tmux copilot gh; do command -v "$tool" >/dev/null; done
    root="$(git rev-parse --show-toplevel)"
    test "$(tmux show-options -qv -t '=foreman' @foreman_root)" = "$root" || { echo "No owned Foreman session" >&2; exit 1; }
    test -z "$(git status --porcelain)" || { echo "Controller checkout must be clean" >&2; exit 1; }
    gh auth status >/dev/null
    gh issue view "$issue" --json number >/dev/null
    mode="$(python3 -c 'import json; print(json.load(open(".foreman/mission.json"))["permission_mode"])')"
    test "$mode" = "$permission" || { echo "Requested permission mode differs from approved mission" >&2; exit 1; }
    echo "Launching rpiv-$issue with permission mode: $permission"
    base="$(python3 -c 'import json; print(json.load(open(".foreman/mission.json"))["base_ref"])')"
    python3 scripts/foreman.py status >/dev/null
    git fetch origin
    commit="$(git rev-parse --verify "$base^{commit}")"
    dependencies="$(python3 -c 'import json,sys; m=json.load(open(".foreman/mission.json")); n={n["issue"]:n for n in m["nodes"]}; print("\n".join(n[d]["delivery"]["merge_commit"] for d in n[int(sys.argv[1])]["depends_on"]))' "$issue")"
    while IFS= read -r dependency; do
        [[ -n "$dependency" ]] || continue
        git merge-base --is-ancestor "$dependency" "$commit" || { echo "Dependency is not available in worker base" >&2; exit 1; }
    done <<< "$dependencies"
    branch="feat/$issue-work"
    ! git show-ref --verify --quiet "refs/heads/$branch" || { echo "Existing branch requires reconciliation" >&2; exit 1; }
    if tmux list-windows -t '=foreman' -F '#{window_name}' | grep -Fxq "rpiv-$issue"; then echo "Existing window requires reconciliation" >&2; exit 1; fi
    python3 scripts/foreman.py reserve --issue "$issue" --base "$commit"
    git worktree add -b "$branch" "$root/.trees/issue-$issue" "$commit"
    attempt="$(python3 scripts/foreman.py worker --issue "$issue" | python3 -c 'import json,sys; print(json.load(sys.stdin)["attempt"])')"
    # tmux receives a fixed command plus a validated numeric identity.
    tmux new-window -d -t foreman: -n "rpiv-$issue" -c "$root" "just foreman-worker $issue"
    tmux set-option -w -t "foreman:rpiv-$issue" @foreman_attempt "$attempt"
    tmux set-option -w -t "foreman:rpiv-$issue" remain-on-exit on

[positional-arguments]
foreman-worker issue:
    #!/usr/bin/env bash
    set -euo pipefail
    issue="$1"
    [[ "$issue" =~ ^[1-9][0-9]*$ ]] || exit 1
    export FOREMAN_ROOT="$(git rev-parse --show-toplevel)"
    worker="$(python3 scripts/foreman.py worker --issue "$issue")"
    export RPIV_ATTEMPT="$(printf '%s' "$worker" | python3 -c 'import json,sys; print(json.load(sys.stdin)["attempt"])')"
    export RPIV_WORKER="rpiv-$issue"
    prompt="$(python3 scripts/foreman.py prompt --issue "$issue")"
    mode="$(printf '%s' "$worker" | python3 -c 'import json,sys; print(json.load(sys.stdin)["permission_mode"])')"
    expected="$(printf '%s' "$worker" | python3 -c 'import json,sys; print(json.load(sys.stdin)["branch"])')"
    cd "$FOREMAN_ROOT/.trees/issue-$issue"
    test "$(git branch --show-current)" = "$expected" || { echo "Worker branch mismatch" >&2; exit 1; }
    args=(--agent rpiv --add-dir "$FOREMAN_ROOT/.foreman" -p "$prompt")
    if [[ "$mode" == yolo ]]; then args+=(--yolo); fi
    exec copilot "${args[@]}"

[positional-arguments]
foreman-send issue file:
    #!/usr/bin/env bash
    set -euo pipefail
    [[ "$1" =~ ^[1-9][0-9]*$ ]] || exit 1
    python3 scripts/foreman.py send --issue "$1" --file "$2"
    tmux wait-for -S "rpiv-$1-inbox"

# Print evidence; Foreman records it in the graph only after inspecting it.
[positional-arguments]
foreman-delivery issue pr:
    #!/usr/bin/env bash
    set -euo pipefail
    [[ "$1" =~ ^[1-9][0-9]*$ && "$2" =~ ^[1-9][0-9]*$ ]] || exit 1
    python3 scripts/foreman.py status >/dev/null
    info="$(gh pr view "$2" --json state,mergeCommit,baseRefName,closingIssuesReferences,url)"
    merge="$(printf '%s' "$info" | python3 -c 'import json,sys; p=json.load(sys.stdin); assert p["state"]=="MERGED", "PR not merged"; assert int(sys.argv[1]) in [i["number"] for i in p["closingIssuesReferences"]], "PR does not close this issue"; print(p["mergeCommit"]["oid"])' "$1")"
    base="$(python3 -c 'import json; print(json.load(open(".foreman/mission.json"))["base_ref"])')"
    git fetch origin
    commit="$(git rev-parse --verify "$base^{commit}")"
    git merge-base --is-ancestor "$merge" "$commit"
    printf 'issue=%s pr=%s merge_commit=%s base_commit=%s\n' "$1" "$2" "$merge" "$commit"

# Close dead consoles only; preserve branches/worktrees and uncommitted work.
[positional-arguments]
foreman-retire issue:
    #!/usr/bin/env bash
    set -euo pipefail
    [[ "$1" =~ ^[1-9][0-9]*$ ]] || exit 1
    root="$(git rev-parse --show-toplevel)"
    test "$(tmux show-options -qv -t '=foreman' @foreman_root)" = "$root" || exit 1
    worker="$(python3 scripts/foreman.py worker --issue "$1")"
    attempt="$(printf '%s' "$worker" | python3 -c 'import json,sys; print(json.load(sys.stdin)["attempt"])')"
    test "$(tmux show-options -wqv -t "foreman:rpiv-$1" @foreman_attempt)" = "$attempt" || { echo "Worker ownership mismatch" >&2; exit 1; }
    test "$(tmux display-message -p -t "foreman:rpiv-$1" '#{pane_dead}')" = 1 || { echo "Stop the worker console before retiring it" >&2; exit 1; }
    tmux kill-window -t "foreman:rpiv-$1"
    python3 scripts/foreman.py retire --issue "$1"

# Continue a cooperatively paused process in its existing branch and attempt.
[positional-arguments]
foreman-continue issue:
    #!/usr/bin/env bash
    set -euo pipefail
    [[ "$1" =~ ^[1-9][0-9]*$ ]] || exit 1
    root="$(git rev-parse --show-toplevel)"
    test "$(tmux show-options -qv -t '=foreman' @foreman_root)" = "$root" || exit 1
    attempt="$(python3 scripts/foreman.py worker --issue "$1" | python3 -c 'import json,sys; print(json.load(sys.stdin)["attempt"])')"
    test "$(tmux show-options -wqv -t "foreman:rpiv-$1" @foreman_attempt)" = "$attempt" || { echo "Worker ownership mismatch" >&2; exit 1; }
    test "$(tmux display-message -p -t "foreman:rpiv-$1" '#{pane_dead}')" = 1 || { echo "Worker is still alive; send a resume message instead" >&2; exit 1; }
    python3 scripts/foreman.py continue --issue "$1"
    tmux respawn-window -t "foreman:rpiv-$1" -c "$root" "just foreman-worker $1"

[positional-arguments]
rpiv-state issue file:
    #!/usr/bin/env bash
    set -euo pipefail
    [[ "$1" =~ ^[1-9][0-9]*$ ]] || exit 1
    python3 scripts/foreman.py state --issue "$1" --branch "$(git branch --show-current)" --file "$2"
    if [[ -n "${FOREMAN_ROOT:-}" ]]; then tmux wait-for -S foreman-events; fi

rpiv-inbox:
    python3 scripts/foreman.py inbox

[positional-arguments]
rpiv-snapshot issue:
    python3 scripts/foreman.py snapshot --issue "$1"

# Titles and bodies are subprocess arguments, never interpolated shell code.
[positional-arguments]
issue-create file:
    python3 -c 'import json,subprocess,sys; p=json.load(open(sys.argv[1])); subprocess.run(["gh","issue","create","--title",p["title"],"--body",p["body"]],check=True)' "$1"

[positional-arguments]
rpiv-create-pr file:
    python3 -c 'import json,subprocess,sys; p=json.load(open(sys.argv[1])); subprocess.run(["gh","pr","create","--title",p["title"],"--body",p["body"]],check=True)' "$1"

[positional-arguments]
rpiv-update-issue issue file:
    #!/usr/bin/env bash
    set -euo pipefail
    [[ "$1" =~ ^[1-9][0-9]*$ ]] || exit 1
    gh issue edit "$1" --body-file "$2"
