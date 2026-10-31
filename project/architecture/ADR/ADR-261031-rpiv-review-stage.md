# ADR-261031-rpiv-review-stage: Independent Review Stage in RPIV

## Status

Accepted

## Context

With Foreman removed ([ADR-261031-standalone-rpiv](ADR-261031-standalone-rpiv.md)),
nothing reviewed code quality. Verify inspects the diff for scope, architecture
compliance, acceptance evidence, and documentation, but not for defects,
security problems, or weak tests, and it works from the same plan context as
Implement, so it is not independent.

## Decision

- Add a Review stage between Implement and Verify: Research -> Plan ->
  Implement -> Review -> Verify. The pipeline keeps the RPIV name.
- `rpiv-reviewer` runs as a fresh leaf task that receives only the issue,
  branch, implementation commit, work-item path, and round, never Implement's
  reasoning. It is read-only for code, tests, and docs.
- It writes `review/00-review.md` with at most 15 findings (ID, severity
  blocker/major/minor/nit, file:line, problem, suggested fix, owner
  implement/plan) and a pass/fail verdict, and commits only that file.
- Any unresolved blocker or major fails the review. The coordinator returns
  findings to the owning stage and reruns Implement and Review once (round 2
  checks the earlier findings and reports only new blockers or majors). A
  second failure stops the pipeline.
- Verify refuses delivery unless the review passed for the exact
  implementation commit, and reports the verdict and dispositions in the PR.

## Alternatives

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|--------------|
| Extend Verify to review code | No new agent | Same context as the plan; mixes acceptance and review | Not independent |
| Only rely on human PR review | No agent cost | Defects reach the user; reviewer burden | User wants agents to catch issues first |
| Unbounded review rounds | Thorough | Loops and churn | Two rounds catch most issues |

## Consequences

### Positive
- Every PR has an independent, recorded code review before acceptance.

### Negative
- One or two extra agent runs per issue.

### Neutral
- Users may additionally run Copilot CLI `/review` or `/security-review`; they do not replace the recorded stage.

## Related Issues

- [#46](https://github.com/jsburckhardt/soft-factory/issues/46)

## References

- [CORE-COMPONENT-260806-rpiv-stage-contract](../core-components/CORE-COMPONENT-260806-rpiv-stage-contract.md)
