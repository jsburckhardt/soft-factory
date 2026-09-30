# Action plan: #42

**Scope type:** issue
**Research:** [00-research.md](../research/00-research.md)
**Architecture:** `ADR-260906-foreman-control-plane`, `CORE-COMPONENT-260906-foreman-orchestration`, `CORE-COMPONENT-260906-rpiv-observability`, `CORE-COMPONENT-260806-rpiv-stage-contract`

This is a review-correction plan for the existing PR, not a claim that the
initial feature commit followed this plan. The accepted ADR keeps scheduling
in APS and host operations in thin, opt-in root-justfile recipes; no new ADR
or application runtime is required. Updated core-component contracts require
an accompanying decision-log update.

| Criterion | Implementation task | Validation | Expected evidence |
|-----------|---------------------|------------|-------------------|
| AC-1 | T-1 | V-1 | Versioned assignment includes identity, scope, dependencies, ACs, and immutable digest |
| AC-2 | T-1 | V-1 | Initial/resume issue, registry, and assignment checks; pause and revision gate |
| AC-3 | T-1 | V-1 | Typed result schema and event-to-result validation |
| AC-4 | T-1 | V-1 | Current-head review compares assigned paths and all criterion evidence |
| AC-5 | T-1 | V-1 | Correlated command handling, answered/unanswered clarification states |
| AC-6 | T-1 | V-1 | Graph, integration, capacity, and reservation guards |
| AC-7 | T-2 | V-2 | Checked-out merged base revision followed by full `verify` |
| AC-8 | T-2, T-3 | V-2, V-3 | Owned worktree/window checks and inert rejection cases |
| AC-9 | T-1, T-3 | V-1, V-3 | Missing window and unacknowledged pause block scheduling; proposals remain Foreman-owned |
| AC-10 | T-3 | V-3 | `just verify-focused` and `just verify` evidence |

Tasks are ordered T-1 -> T-2 -> T-3; Verify independently inspects the final
commit and PR. The template has no approved consuming-project worker profile,
so live worker execution is not a valid acceptance proxy.
