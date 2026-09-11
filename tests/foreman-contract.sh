#!/usr/bin/env bash
set -euo pipefail

root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd -- "$root"
fixture="$(mktemp -d)"
cleanup() {
    rm -f -- "$fixture/bin/copilot" "$fixture/bin/gh" "$fixture/bootstrap.txt" \
        "$fixture/actual" "$fixture/expected" "$fixture/head-count"
    rmdir -- "$fixture/bin" "$fixture/work tree" "$fixture"
}
trap cleanup EXIT
mkdir -- "$fixture/bin" "$fixture/work tree"
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
chmod +x "$fixture/bin/copilot" "$fixture/bin/gh"
printf '%s\n' 'Bootstrap with "quotes"; $(not-a-command)' > "$fixture/bootstrap.txt"
prompt="$(< "$fixture/bootstrap.txt")"

for agent in foreman rpiv issue-generator; do
    mode=-p
    if [[ "$agent" == foreman ]]; then mode=-i; fi
    just copilot-session "$agent" "$fixture/work tree" "$fixture/bootstrap.txt" >/dev/null
    printf '%s\n' "$fixture/work tree" --agent "$agent" --yolo "$mode" "$prompt" > "$fixture/expected"
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

grep -Fq 'RUN `review-delivery`' .github/agents/foreman.agent.md
grep -Fq 'operation="review-comment"' .github/agents/foreman.agent.md
grep -Fq 'RUN `await-review`' .github/agents/rpiv.agent.md
grep -Fq 'head_sha' project/architecture/core-components/CORE-COMPONENT-260906-rpiv-observability.md
grep -Fq 'rpiv-edit-pr' .github/agents/rpiv-verifier.agent.md || \
    grep -Fq 'RPIV_EDIT_PR_RECIPE' .github/agents/rpiv-verifier.agent.md
printf '%s\n' "Managed launch and PR primitive contracts passed (inert CLI substitutes)."
