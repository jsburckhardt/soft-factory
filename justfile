set shell := ["bash", "-eu", "-o", "pipefail", "-c"]

# Bootstrap replaces these starter checks with the consuming project's checks.
verify-focused:
    git diff --check
    bash tests/foreman-contract.sh

verify:
    git diff --check "$(git merge-base HEAD origin/main)"
    bash tests/foreman-contract.sh

# Read titles as data, never as interpolated shell commands.
[positional-arguments]
issue-create title_file body_file:
    gh issue create --title "$(< "$1")" --body-file "$2"

[positional-arguments]
rpiv-create-pr title_file body_file:
    gh pr create --title "$(< "$1")" --body-file "$2"

[positional-arguments]
rpiv-update-issue issue body_file:
    #!/usr/bin/env bash
    set -euo pipefail
    [[ "$1" =~ ^[1-9][0-9]*$ ]] || { echo "Invalid issue number" >&2; exit 1; }
    gh issue edit "$1" --body-file "$2"

# Managed sessions only: project opt-in approves this policy before invocation.
[positional-arguments]
copilot-session agent worktree bootstrap_file:
    #!/usr/bin/env bash
    set -euo pipefail
    case "$1" in foreman|rpiv|issue-generator) ;; *) echo "Unsupported managed agent" >&2; exit 1 ;; esac
    test -r "$3" || { echo "Worker bootstrap file is not readable" >&2; exit 1; }
    prompt="$(< "$3")"
    test -n "$prompt" || { echo "Worker bootstrap file is empty" >&2; exit 1; }
    controller_root="$PWD"
    cd -- "$2"
    printf 'Managed agent: %s; directory: %s; permissions: --yolo\n' "$1" "$PWD"
    if [[ "$1" == foreman ]]; then
        exec copilot --agent "$1" --yolo -i "$prompt"
    fi
    if [[ "$1" == rpiv ]]; then
        exec copilot --agent "$1" --yolo --add-dir "$controller_root" -p "$prompt"
    fi
    exec copilot --agent "$1" --yolo -p "$prompt"

# Host primitives only. Foreman may invoke these after project opt-in and
# profile/ownership checks; they do not decide scheduling or acceptance.
[positional-arguments]
tmux-foreman-launch bootstrap_file:
    #!/usr/bin/env bash
    set -euo pipefail
    test -r "$1" || { echo "Controller bootstrap is not readable" >&2; exit 1; }
    if tmux has-session -t '=foreman' 2>/dev/null; then
        echo "Foreman session already exists; reconcile ownership" >&2; exit 1
    fi
    printf -v launch 'exec just --justfile %q copilot-session foreman %q %q' "$PWD/justfile" "$PWD" "$(realpath -e -- "$1")"
    tmux new-session -d -s foreman -n foreman
    tmux set-option -t '=foreman' base-index 0
    if [[ "$(tmux display-message -p -t 'foreman:foreman' '#{window_index}')" != 0 ]]; then
        tmux move-window -s 'foreman:foreman' -t 'foreman:0'
    fi
    tmux set-option -w -t 'foreman:foreman' remain-on-exit on
    tmux respawn-window -k -t 'foreman:foreman' "$launch"

[positional-arguments]
tmux-worker-launch issue worktree bootstrap_file:
    #!/usr/bin/env bash
    set -euo pipefail
    [[ "$1" =~ ^[1-9][0-9]*$ ]] || { echo "Invalid issue number" >&2; exit 1; }
    worktree="$(realpath -e -- "$2")"
    root="$(realpath -e -- "$(git rev-parse --show-toplevel)")"
    [[ "$(realpath -e -- "$PWD")" == "$root" && "$worktree" == "$root/.trees/issue-$1" ]] ||
        { echo "Worktree is outside the owning repository or does not match the issue" >&2; exit 1; }
    [[ "$(realpath -e -- "$(git -C "$worktree" rev-parse --show-toplevel)")" == "$worktree" ]] ||
        { echo "Worker checkout is not a Git worktree" >&2; exit 1; }
    root_common="$(realpath -e -- "$(git rev-parse --git-common-dir)")"
    worker_common="$(cd -- "$worktree" && realpath -e -- "$(git rev-parse --git-common-dir)")"
    [[ "$root_common" == "$worker_common" ]] ||
        { echo "Worker checkout belongs to another repository" >&2; exit 1; }
    test -r "$3" || { echo "Worker bootstrap is not readable" >&2; exit 1; }
    tmux has-session -t '=foreman' || { echo "Foreman session is missing" >&2; exit 1; }
    tmux list-windows -t '=foreman' -F '#{window_name}' | grep -Fxq -- foreman ||
        { echo "Foreman controller window is missing" >&2; exit 1; }
    if tmux list-windows -t '=foreman' -F '#{window_name}' | grep -Fxq -- "rpiv-$1"; then
        echo "Worker window already exists; reconcile ownership" >&2; exit 1
    fi
    printf -v launch 'exec just --justfile %q copilot-session rpiv %q %q' "$PWD/justfile" "$worktree" "$(realpath -e -- "$3")"
    tmux new-window -d -t 'foreman:' -n "rpiv-$1"
    tmux set-option -w -t "foreman:rpiv-$1" remain-on-exit on
    tmux respawn-window -k -t "foreman:rpiv-$1" "$launch"

[positional-arguments]
tmux-worker-list:
    tmux list-windows -t '=foreman' -F '#{window_index}:#{window_name}:#{window_id}'

[positional-arguments]
tmux-worker-inspect issue:
    #!/usr/bin/env bash
    set -euo pipefail
    [[ "$1" =~ ^[1-9][0-9]*$ ]] || { echo "Invalid issue number" >&2; exit 1; }
    tmux list-panes -t "foreman:rpiv-$1" -F '#{window_name}:#{pane_pid}:#{pane_dead}:#{pane_current_path}'

[positional-arguments]
tmux-worker-status issue:
    #!/usr/bin/env bash
    set -euo pipefail
    [[ "$1" =~ ^[1-9][0-9]*$ ]] || { echo "Invalid issue number" >&2; exit 1; }
    tmux list-panes -t "foreman:rpiv-$1" -F '#{pane_dead}'

[positional-arguments]
tmux-worker-signal issue:
    #!/usr/bin/env bash
    set -euo pipefail
    [[ "$1" =~ ^[1-9][0-9]*$ ]] || { echo "Invalid issue number" >&2; exit 1; }
    tmux list-panes -t "foreman:rpiv-$1" -F '#{pane_id}' >/dev/null
    tmux wait-for -S "foreman-rpiv-$1"

[positional-arguments]
tmux-worker-retire issue:
    #!/usr/bin/env bash
    set -euo pipefail
    [[ "$1" =~ ^[1-9][0-9]*$ ]] || { echo "Invalid issue number" >&2; exit 1; }
    test "$(tmux list-panes -t "foreman:rpiv-$1" -F '#{pane_dead}')" = 1 ||
        { echo "Worker is still running; request cooperative cancellation first" >&2; exit 1; }
    tmux kill-window -t "foreman:rpiv-$1"

# Refresh only an owned, clean checkout already on the configured base branch.
# This fast-forwards a local branch after integration; it never merges a PR.
[positional-arguments]
integration-sync remote base_branch:
    #!/usr/bin/env bash
    set -euo pipefail
    [[ "$1" =~ ^[a-zA-Z0-9._-]+$ ]] || { echo "Invalid remote name" >&2; exit 1; }
    git check-ref-format --branch "$2" >/dev/null ||
        { echo "Invalid base branch" >&2; exit 1; }
    [[ "$(realpath -e -- "$PWD")" == "$(realpath -e -- "$(git rev-parse --show-toplevel)")" ]] ||
        { echo "Run from the owned base checkout root" >&2; exit 1; }
    [[ "$(git branch --show-current)" == "$2" ]] ||
        { echo "Checkout is not on the configured base branch" >&2; exit 1; }
    [[ -z "$(git status --porcelain)" ]] ||
        { echo "Base checkout is not clean" >&2; exit 1; }
    git remote get-url "$1" >/dev/null
    git fetch -- "$1" "refs/heads/$2:refs/remotes/$1/$2"
    git merge --ff-only "$1/$2"
    git rev-parse HEAD

# Read evidence only; Foreman, not this recipe, decides review acceptance.
[positional-arguments]
pr-inspect repository pr:
    #!/usr/bin/env bash
    set -euo pipefail
    [[ "$2" =~ ^[1-9][0-9]*$ ]] || { echo "Invalid PR number" >&2; exit 1; }
    head="$(gh pr view "$2" --repo "$1" --json headRefOid --jq '.headRefOid')"
    gh pr view "$2" --repo "$1" --json number,url,state,baseRefName,headRefName,headRefOid,body,comments,reviews,statusCheckRollup,closingIssuesReferences
    gh pr diff "$2" --repo "$1"
    current="$(gh pr view "$2" --repo "$1" --json headRefOid --jq '.headRefOid')"
    test -n "$head" && test "$head" = "$current" || { echo "PR head changed or is missing; review must be repeated" >&2; exit 1; }
    printf 'Inspected head: %s\n' "$head"

[positional-arguments]
pr-comment repository pr body_file:
    #!/usr/bin/env bash
    set -euo pipefail
    [[ "$2" =~ ^[1-9][0-9]*$ ]] || { echo "Invalid PR number" >&2; exit 1; }
    gh pr comment "$2" --repo "$1" --body-file "$3"

[positional-arguments]
rpiv-edit-pr pr title_file body_file:
    #!/usr/bin/env bash
    set -euo pipefail
    [[ "$1" =~ ^[1-9][0-9]*$ ]] || { echo "Invalid PR number" >&2; exit 1; }
    gh pr edit "$1" --title "$(< "$2")" --body-file "$3"

[positional-arguments]
rpiv-find-pr branch:
    gh pr list --head "$1" --state all --json number,url,state,headRefName,headRefOid,baseRefName,body

[positional-arguments]
pr-resolve-thread thread_id:
    gh api graphql -f query='mutation($id: ID!) { resolveReviewThread(input: {threadId: $id}) { thread { id isResolved } } }' -f id="$1"
