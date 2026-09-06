# CORE-COMPONENT-260906-rpiv-observability: RPIV Observability

## Status

Adopted

## Purpose

Expose issue execution to humans, Foreman, and future UIs without terminal
scraping or coupling standalone RPIV to a controller.

## Scope

The RPIV coordinator and four leaf stages, canonical work-item runtime files,
and the Foreman communication boundary.

## Definition

### Rules
- Research alone resolves/creates the canonical work-item directory. Once it
  has done so, initialize `state.json` and `events.jsonl` there. Before that,
  Foreman's registry may show queued/starting; do not invent a second path.
- The RPIV coordinator is the single lifecycle writer. Leaf stages return
  structured progress/blocker information and never concurrently mutate state.
  Research may initialize the stream on the coordinator's behalf at entry.
- Standalone workers use the same state/event format without tmux or a mission.
- Use exactly `research`, `plan`, `implement`, and `verify` as phase values.
  Separate status (`running`, `waiting`, `blocked`, `failed`, `needs-human`,
  `replanning`, `done`) from phase. Validation/delivery are Verify activities.
- Identify every record by version, issue, worker, attempt UUID, monotonically
  increasing sequence, UTC timestamp, branch, and absolute worktree.
- Persist `WORKER_STARTED`, `PHASE_CHANGED`, `PROGRESS`, `BLOCKED`,
  `NEEDS_DECISION`, `FAILED`, and `COMPLETED`. Exceptional events include a
  reason/owner; `COMPLETED` includes the verified commit and PR URL.
- Exceptional event evidence includes `category` and `owner`: transient ->
  foreman, validation -> implement, dependency -> foreman, decomposition ->
  foreman, architecture -> plan, human -> user.
- Append the event before atomically replacing `state.json`. A snapshot lagging
  the valid event log can be rebuilt from its last record. A ahead-of-log,
  malformed, conflicting, truncated, or mismatched stream requires explicit
  reconciliation; never infer success from an exit code.
- Reject events from another issue/worker/attempt, sequence gaps, and invalid
  phase transitions. Identical replay is idempotent, not another state change.
- Normal transitions are Research -> Plan -> Implement -> Verify. A correction
  may enter `replanning` in Plan from Implement or Verify, or return from
  Verify to Implement. Record the reason, then rerun downstream stages.
- Terminal attempts are immutable. A restart uses a new attempt, preserves
  the previous event stream, and does not imply acceptance of previous work.
- `done` means Verify delivered its accepted PR, not integration or mission
  completion. Only Foreman checks integration evidence.
- Runtime files are ignored by Git so progress cannot invalidate clean-tree
  commit handoffs. Human-readable research/plan/evidence/summary stay tracked.

### Interfaces

Input to a managed RPIV session is `ISSUE_NUMBER`, `WORKER_ID`, `ATTEMPT_ID`,
`WORKTREE`, `FOREMAN_ROOT`; the last four may be supplied by the launch
environment. Standalone RPIV generates a fresh attempt/identity, uses the
current checkout, and leaves `FOREMAN_ROOT` empty.

Each event is a JSON object:

```json
{
  "version": 1,
  "issue": 123,
  "worker": "rpiv-123",
  "attempt": "a UUID generated per execution",
  "sequence": 3,
  "updated_at": "2026-09-06T12:00:00+00:00",
  "branch": "feat/123-work",
  "worktree": "/repo/.trees/issue-123",
  "event": "PHASE_CHANGED",
  "phase": "implement",
  "status": "running",
  "reason": "",
  "evidence": {}
}
```

`state.json` is the last accepted event. `events.jsonl` is the ordered history
for the current attempt; `.attempts/<attempt>/events.jsonl` retains older
attempts. `just rpiv-state` writes an event request from a JSON file.
`just rpiv-inbox` reads managed commands; standalone use returns an empty list.
An explicit `RESUME: true` input continues the same paused attempt only after
saved identity and handoffs are validated. Terminal attempts require a new UUID
and a `WORKER_STARTED` request with `restart: true`.

### Expectations

At entry, stage completion, failure, correction, and final delivery, the
coordinator updates state. While a leaf stage is running, its phase remains
observable; leaf results can carry progress but do not write a competing log.
Workers poll commands at safe stage boundaries, acknowledge command IDs, and
pause without allowing the controller to edit their files.

## Rationale

A durable single-writer log gives restartable observability and allows a future
UI independently of tmux. Keeping phase and status separate preserves RPIV.

## Usage Examples

```text
research/running -> plan/running -> implement/running -> verify/running
verify/running -> implement/running (reason: correction)
verify/running -> plan/replanning (reason: architecture conflict)
verify/done + PR URL -> Foreman delivered node -> merge evidence -> integrated
```

## Integration Guidelines

- Stage inputs retain their existing RPIV artifact/handoff fields and receive
  worker identity as additional context, not an instruction to change scope.
- Reject malformed commands; never evaluate message content or type it into a
  tmux shell. Notify via `tmux wait-for`, then read files.
- Keep unacknowledged messages visible across controller and worker restarts.

## Exceptions

- A failure before Research creates the work item is reported in the worker
  registry/console; no canonical work-item state exists yet.

## Enforcement

- [x] Automated checks
- [x] Code review checklist
- [x] Test coverage requirements

## Related ADRs

- [ADR-260906-foreman-control-plane](../ADR/ADR-260906-foreman-control-plane.md)
