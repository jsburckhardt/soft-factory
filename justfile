set shell := ["bash", "-eu", "-o", "pipefail", "-c"]

verify-focused:
    git diff --check

verify:
    git diff --check "$(git merge-base HEAD origin/main)"
