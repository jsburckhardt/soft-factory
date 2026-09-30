# Research brief: #42

**Scope type:** issue
**Issue:** [#42](https://github.com/jsburckhardt/soft-factory/issues/42)
**Canonical work item:** `project/work-items/42-feat-foreman-bound-managed-rpiv-workers-and-verify-integrated-delivery/`

## Repository findings

- The branch already contained an initial implementation (`bdced3a`) when issue #42 was created. This brief records findings for review corrections; it does not claim that the original implementation followed this stage order.
- Foreman is an APS coordinator, not a bundled scheduler. The consuming-project profile is absent in this template, so worker execution is disabled.
- The root `justfile` provides optional tmux/GitHub primitives and `verify-focused`/`verify`; `tests/foreman-contract.sh` uses inert CLI substitutes.
- The RPIV coordinator persists events under a stable issue-number work-item path. No existing `42-*` directory was present before this brief.

## Relevant architecture and constraints

- `project/architecture/ADR/ADR-260906-foreman-control-plane.md`: Foreman owns graph, review, and mission outcomes; RPIV owns issue delivery.
- `project/architecture/core-components/CORE-COMPONENT-260906-foreman-orchestration.md`: configuration and permission opt-in, isolated worktrees, typed commands, PR review, integrated delivery gate.
- `project/architecture/core-components/CORE-COMPONENT-260906-rpiv-observability.md`: immutable events, state snapshots, identity correlation, standalone/managed operation.
- `project/architecture/core-components/CORE-COMPONENT-260806-rpiv-stage-contract.md`: four ordered stages, tracked evidence, and root-justfile validation.
- The installed APS grammar limits a placeholder to 64 characters and `SET` targets to uppercase symbols. New or changed agents use the Copilot CLI adapter and the installed APS skill.

## Acceptance criteria (issue order)

1. Before managed dispatch, each worker receives a versioned, bounded assignment consistent with every criterion of its GitHub issue and current graph dependencies; it identifies the objective, relevant context, expected outputs, and allowed read, allowed write, and forbidden scope, and cannot change silently during an active attempt.
2. Dispatch and managed RPIV reject missing, stale, or conflicting assignments, including mismatched issue criteria, revision, worker identity, checkout, or scope; changing active scope requires a worker-acknowledged pause and a new assignment version.
3. Managed progress, blocker, failure, and completion events carry attempt-correlated structured results identifying the issue, status, summary, changed paths, per-criterion evidence, blockers, discovered dependencies, risks, and notes; progress may be partial, but completion requires concrete passing evidence for every assigned criterion, and blockers or failures identify a reason and owner.
4. Foreman compares a delivered worker result, assignment boundaries, and the exact current PR-head diff before acceptance; out-of-scope changes or missing criterion evidence block acceptance, and any correction is reviewed on the same worker and PR at its updated head rather than treating an unmerged PR as integrated.
5. Status, stop, continue, clarification, and update requests have typed, attempt-correlated replies and safe-boundary acknowledgements; stale or replayed requests and events do not cause duplicate actions, and message text is never executed or injected into a terminal.
6. Foreman rejects invalid dependencies, invalid capacity, and duplicate worker reservations; it schedules only unblocked queued issues with integrated, available dependencies, orders eligible work by priority then issue number, and counts reserved, active, blocked, and review-waiting workers toward capacity.
7. Mission completion requires every required delivery integrated on the configured base, successful configured full project verification on that integrated revision, and recorded evidence for each original mission condition; absent or failed verification leaves it incomplete.
8. Optional host operations retain an owned controller session and named per-issue worker windows in matching isolated worktrees; without project opt-in and confirmed host capabilities execution stays disabled, while duplicate windows, mismatched issue worktrees, and retirement of a live worker are rejected without disturbing ownership.
9. A missing window for a registered active worker or an unacknowledged pause preserves its reservation and requires reconciliation rather than a duplicate launch or success claim; newly reported dependencies are decided by Foreman after affected work is paused, never written into the global graph by a worker.
10. The repository's repeatable verification exits successfully and includes inert success and rejection checks for managed host operations; inspectable agent and documentation contracts cover assignment, result, scheduling, and integrated-verification gates without requiring a live worker fleet.

## Risks and open constraints

- A stubbed tmux/CLI check does not demonstrate a live fleet. This template has no approved project worker profile or application stack.
- A merged PR can advance the remote base without updating a controller's local checkout; verification on that stale checkout is not mission evidence.
- The issue and initial code predate these stage artifacts. Record correction evidence honestly; do not fabricate an earlier pipeline run.
