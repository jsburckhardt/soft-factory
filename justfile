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
