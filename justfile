set shell := ["bash", "-eu", "-o", "pipefail", "-c"]

# Bootstrap replaces these starter checks with the consuming project's checks.
verify-focused:
    git diff --check

verify:
    git diff --check "$(git merge-base HEAD origin/main)"

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
