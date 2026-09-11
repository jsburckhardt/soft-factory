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
    cd -- "$2"
    printf 'Managed agent: %s; directory: %s; permissions: --yolo\n' "$1" "$PWD"
    if [[ "$1" == foreman ]]; then
        exec copilot --agent "$1" --yolo -i "$prompt"
    fi
    exec copilot --agent "$1" --yolo -p "$prompt"

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
