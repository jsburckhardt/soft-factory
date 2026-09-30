#!/usr/bin/env bash
set -euo pipefail

root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd -- "$root"
fixture="$(mktemp -d)"
cleanup() {
    rm -f -- "$fixture/bin/copilot" "$fixture/bin/gh" "$fixture/bin/tmux" "$fixture/bin/git" \
        "$fixture/bootstrap.txt" "$fixture/actual" "$fixture/expected" \
        "$fixture/head-count" "$fixture/tmux-log" "$fixture/git-log"
    rmdir -- "$fixture/bin" "$fixture/work tree" "$fixture/gitroot/.git" \
        "$fixture/gitroot/.trees/issue-21" "$fixture/gitroot/.trees" \
        "$fixture/gitroot" "$fixture/foreign/.trees/issue-21" \
        "$fixture/foreign/.trees" "$fixture/foreign" "$fixture"
}
trap cleanup EXIT
mkdir -p -- "$fixture/bin" "$fixture/work tree" "$fixture/gitroot/.git" \
    "$fixture/gitroot/.trees/issue-21" "$fixture/foreign/.trees/issue-21"
export FOREMAN_FIXTURE="$fixture"
export PATH="$fixture/bin:$PATH"
cat > "$fixture/bin/copilot" <<'STUB'
#!/usr/bin/env bash
printf '%s\n' "$PWD" "$@" > "$FOREMAN_FIXTURE/actual"
STUB
cat > "$fixture/bin/gh" <<'STUB'
#!/usr/bin/env bash
set -euo pipefail
printf '%s\n' "$@" > "$FOREMAN_FIXTURE/actual"
if [[ "$1 $2" == 'pr view' && "$*" == *--jq* ]]; then
    count=0
    if [[ -f "$FOREMAN_FIXTURE/head-count" ]]; then count="$(< "$FOREMAN_FIXTURE/head-count")"; fi
    count=$((count + 1))
    printf '%s' "$count" > "$FOREMAN_FIXTURE/head-count"
    if [[ "${CHANGE_HEAD:-false}" == true && "$count" == 2 ]]; then
        printf '%s\n' bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
    else
        printf '%s\n' aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
    fi
elif [[ "$1 $2" == 'pr diff' ]]; then
    printf '%s\n' 'diff --git a/example b/example'
else
    printf '%s\n' '{"number":45,"headRefOid":"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"}'
fi
STUB
cat > "$fixture/bin/tmux" <<'STUB'
#!/usr/bin/env bash
set -euo pipefail
case "$1" in
    has-session) [[ "${TMUX_SESSION:-false}" == true ]] ;;
    display-message) printf '%s\n' "${TMUX_BASE_INDEX:-0}" ;;
    list-windows)
        printf '%s\n' foreman
        if [[ "${TMUX_DUPLICATE:-false}" == true ]]; then printf '%s\n' rpiv-21; fi
        ;;
    list-panes)
        case "$*" in
            *pane_dead*) printf '%s\n' "${TMUX_PANE_DEAD:-0}" ;;
            *) printf '%s\n' pane-fixture ;;
        esac
        ;;
    new-session|new-window|respawn-window|set-option|move-window|wait-for|kill-window)
        printf '%s\n' "$*" >> "$FOREMAN_FIXTURE/tmux-log"
        ;;
    *) echo "Unexpected tmux operation: $*" >&2; exit 1 ;;
esac
STUB
chmod +x "$fixture/bin/copilot" "$fixture/bin/gh" "$fixture/bin/tmux"
printf '%s\n' 'Bootstrap with "quotes"; $(not-a-command)' > "$fixture/bootstrap.txt"
prompt="$(< "$fixture/bootstrap.txt")"

for agent in foreman rpiv issue-generator; do
    mode=-p
    if [[ "$agent" == foreman ]]; then mode=-i; fi
    just copilot-session "$agent" "$fixture/work tree" "$fixture/bootstrap.txt" >/dev/null
    if [[ "$agent" == rpiv ]]; then
        printf '%s\n' "$fixture/work tree" --agent "$agent" --yolo --add-dir "$root" "$mode" "$prompt" > "$fixture/expected"
    else
        printf '%s\n' "$fixture/work tree" --agent "$agent" --yolo "$mode" "$prompt" > "$fixture/expected"
    fi
    diff -u "$fixture/expected" "$fixture/actual"
done
if just copilot-session unknown "$fixture/work tree" "$fixture/bootstrap.txt" >/dev/null 2>&1; then
    echo "Unknown managed agent was accepted" >&2; exit 1
fi
if just copilot-session rpiv "$fixture/missing" "$fixture/bootstrap.txt" >/dev/null 2>&1; then
    echo "Missing working directory was accepted" >&2; exit 1
fi
if just copilot-session rpiv "$fixture/work tree" "$fixture/missing" >/dev/null 2>&1; then
    echo "Missing bootstrap was accepted" >&2; exit 1
fi

just pr-inspect example/service 45 >/dev/null
rm -- "$fixture/head-count"
if CHANGE_HEAD=true just pr-inspect example/service 45 >/dev/null 2>&1; then
    echo "Changed PR head was treated as stable evidence" >&2; exit 1
fi
just pr-comment example/service 45 "$fixture/bootstrap.txt" >/dev/null
printf '%s\n' pr comment 45 --repo example/service --body-file "$fixture/bootstrap.txt" > "$fixture/expected"
diff -u "$fixture/expected" "$fixture/actual"
just rpiv-edit-pr 45 "$fixture/bootstrap.txt" "$fixture/bootstrap.txt" >/dev/null
printf '%s\n' pr edit 45 --title "$prompt" --body-file "$fixture/bootstrap.txt" > "$fixture/expected"
diff -u "$fixture/expected" "$fixture/actual"
just rpiv-find-pr 'feat/21-work' >/dev/null
printf '%s\n' pr list --head 'feat/21-work' --state all --json \
    number,url,state,headRefName,headRefOid,baseRefName,body > "$fixture/expected"
diff -u "$fixture/expected" "$fixture/actual"
just pr-resolve-thread 'PRRT_fixture' >/dev/null
printf '%s\n' api graphql -f \
    'query=mutation($id: ID!) { resolveReviewThread(input: {threadId: $id}) { thread { id isResolved } } }' \
    -f id=PRRT_fixture > "$fixture/expected"
diff -u "$fixture/expected" "$fixture/actual"
if just rpiv-edit-pr '45; unexpected' "$fixture/bootstrap.txt" "$fixture/bootstrap.txt" >/dev/null 2>&1; then
    echo "Invalid PR identifier was accepted" >&2; exit 1
fi

cat > "$fixture/bin/git" <<'STUB'
#!/usr/bin/env bash
set -euo pipefail
if [[ "$1" == -C ]]; then
    [[ "$2" == "$FOREMAN_FIXTURE/gitroot/.trees/issue-21" ]] || exit 1
    shift 2
    case "$*" in
        'rev-parse --show-toplevel') printf '%s\n' "$FOREMAN_FIXTURE/gitroot/.trees/issue-21" ;;
        *) exit 1 ;;
    esac
else
    case "$*" in
        'rev-parse --show-toplevel') printf '%s\n' "$FOREMAN_FIXTURE/gitroot" ;;
        'rev-parse --git-common-dir')
            if [[ "${GIT_FOREIGN_COMMON:-false}" == true && "$PWD" == "$FOREMAN_FIXTURE/gitroot/.trees/issue-21" ]]; then
                printf '%s\n' "$FOREMAN_FIXTURE/foreign"
            else
                printf '%s\n' "$FOREMAN_FIXTURE/gitroot/.git"
            fi ;;
        'check-ref-format --branch main') printf '%s\n' main ;;
        'branch --show-current') printf '%s\n' "${GIT_BRANCH:-main}" ;;
        'status --porcelain')
            if [[ "${GIT_DIRTY:-false}" == true ]]; then printf '%s\n' ' M file'; fi ;;
        'remote get-url origin') printf '%s\n' 'https://example.test/repo' ;;
        'fetch -- origin refs/heads/main:refs/remotes/origin/main')
            [[ "${GIT_FETCH_FAIL:-false}" == false ]] || exit 1
            printf '%s\n' "$*" >> "$FOREMAN_FIXTURE/git-log" ;;
        'merge --ff-only origin/main')
            printf '%s\n' "$*" >> "$FOREMAN_FIXTURE/git-log" ;;
        'rev-parse HEAD') printf '%s\n' aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa ;;
        *) echo "Unexpected git operation: $*" >&2; exit 1 ;;
    esac
fi
STUB
chmod +x "$fixture/bin/git"
host_just() {
    just --justfile "$root/justfile" --working-directory "$fixture/gitroot" "$@"
}

host_just tmux-foreman-launch "$fixture/bootstrap.txt"
grep -Fq 'new-session -d -s foreman -n foreman' "$fixture/tmux-log"
grep -Fq 'set-option -t =foreman base-index 0' "$fixture/tmux-log"
grep -Fq 'set-option -w -t foreman:foreman remain-on-exit on' "$fixture/tmux-log"
grep -Fq 'respawn-window -k -t foreman:foreman' "$fixture/tmux-log"
TMUX_BASE_INDEX=1 host_just tmux-foreman-launch "$fixture/bootstrap.txt"
grep -Fq 'move-window -s foreman:foreman -t foreman:0' "$fixture/tmux-log"
if TMUX_SESSION=true host_just tmux-foreman-launch "$fixture/bootstrap.txt" >/dev/null 2>&1; then
    echo "Duplicate controller session was accepted" >&2; exit 1
fi
TMUX_SESSION=true host_just tmux-worker-launch 21 "$fixture/gitroot/.trees/issue-21" "$fixture/bootstrap.txt"
grep -Fq 'new-window -d -t foreman: -n rpiv-21' "$fixture/tmux-log"
grep -Fq 'set-option -w -t foreman:rpiv-21 remain-on-exit on' "$fixture/tmux-log"
grep -Fq 'respawn-window -k -t foreman:rpiv-21' "$fixture/tmux-log"
grep -Fq 'copilot-session rpiv' "$fixture/tmux-log"
if host_just tmux-worker-launch 21 "$fixture/gitroot/.trees/issue-21" "$fixture/bootstrap.txt" >/dev/null 2>&1; then
    echo "Worker launched without the owned controller session" >&2; exit 1
fi
if TMUX_SESSION=true TMUX_DUPLICATE=true host_just tmux-worker-launch 21 "$fixture/gitroot/.trees/issue-21" "$fixture/bootstrap.txt" >/dev/null 2>&1; then
    echo "Duplicate worker window was accepted" >&2; exit 1
fi
if TMUX_SESSION=true host_just tmux-worker-launch 22 "$fixture/gitroot/.trees/issue-21" "$fixture/bootstrap.txt" >/dev/null 2>&1; then
    echo "Mismatched worktree was accepted" >&2; exit 1
fi
if TMUX_SESSION=true host_just tmux-worker-launch 21 "$fixture/foreign/.trees/issue-21" "$fixture/bootstrap.txt" >/dev/null 2>&1; then
    echo "Foreign repository with matching suffix was accepted" >&2; exit 1
fi
if TMUX_SESSION=true GIT_FOREIGN_COMMON=true host_just tmux-worker-launch 21 "$fixture/gitroot/.trees/issue-21" "$fixture/bootstrap.txt" >/dev/null 2>&1; then
    echo "Unrelated Git worktree was accepted" >&2; exit 1
fi
host_just tmux-worker-list >/dev/null
host_just tmux-worker-inspect 21 >/dev/null
host_just tmux-worker-status 21 >/dev/null
host_just tmux-worker-signal 21
grep -Fq 'wait-for -S foreman-rpiv-21' "$fixture/tmux-log"
if host_just tmux-worker-retire 21 >/dev/null 2>&1; then
    echo "Running worker was retired" >&2; exit 1
fi
TMUX_PANE_DEAD=1 host_just tmux-worker-retire 21
grep -Fq 'kill-window -t foreman:rpiv-21' "$fixture/tmux-log"
if host_just tmux-worker-signal '21; unexpected' >/dev/null 2>&1; then
    echo "Invalid worker identifier was accepted" >&2; exit 1
fi
host_just integration-sync origin main >/dev/null
grep -Fq 'fetch -- origin refs/heads/main:refs/remotes/origin/main' "$fixture/git-log"
grep -Fq 'merge --ff-only origin/main' "$fixture/git-log"
if GIT_DIRTY=true host_just integration-sync origin main >/dev/null 2>&1; then
    echo "Dirty integration checkout was accepted" >&2; exit 1
fi
if GIT_BRANCH=feature host_just integration-sync origin main >/dev/null 2>&1; then
    echo "Integration verification was allowed on a feature branch" >&2; exit 1
fi
if GIT_FETCH_FAIL=true host_just integration-sync origin main >/dev/null 2>&1; then
    echo "Failed base synchronization was treated as success" >&2; exit 1
fi
if host_just integration-sync 'origin;unexpected' main >/dev/null 2>&1; then
    echo "Invalid integration remote was accepted" >&2; exit 1
fi

for agent in .github/agents/foreman.agent.md .github/agents/rpiv.agent.md; do
    grep -oEh '<[A-Z][A-Z0-9_]+>' "$agent" |
        awk 'length($0)>66 {print "Overlong APS placeholder: " $0 > "/dev/stderr"; bad=1} END {exit bad}'
    awk '/^[[:space:]]*SET / && ($2 !~ /^[A-Z][A-Z0-9_]*$/ || length($2)>24) {
        print "Invalid APS SET target at " FNR ": " $2 > "/dev/stderr"; bad=1
    } END {exit bad}' "$agent"
done

grep -Fq 'RUN `review-delivery`' .github/agents/foreman.agent.md
grep -Fq 'operation="review-comment"' .github/agents/foreman.agent.md
grep -Fq 'RUN `await-review`' .github/agents/rpiv.agent.md
grep -Fq 'head_sha' project/architecture/core-components/CORE-COMPONENT-260906-rpiv-observability.md
grep -Fq 'ASSIGNMENT_PATH' .github/agents/rpiv.agent.md
test "$(grep -Fc 'RUN `validate-assignment`' .github/agents/rpiv.agent.md)" -eq 2
grep -Fq 'operation="integration-checkout"' .github/agents/foreman.agent.md
grep -Fq '"worker": "rpiv-21"' project/architecture/core-components/CORE-COMPONENT-260906-foreman-orchestration.md
grep -Fq '"attempt": "unique-execution-id"' project/architecture/core-components/CORE-COMPONENT-260906-foreman-orchestration.md
grep -Fq 'evidence.worker_result' project/architecture/core-components/CORE-COMPONENT-260906-rpiv-observability.md
grep -Fq '"assignment_sha256":' project/architecture/core-components/CORE-COMPONENT-260906-rpiv-observability.md
grep -Fq 'RUN `verify-integration`' .github/agents/foreman.agent.md
grep -Fq 'rpiv-edit-pr' .github/agents/rpiv-verifier.agent.md || \
    grep -Fq 'RPIV_EDIT_PR_RECIPE' .github/agents/rpiv-verifier.agent.md
printf '%s\n' "Managed launch, tmux, and PR primitive contracts passed (inert CLI substitutes)."
