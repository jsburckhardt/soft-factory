# CORE-COMPONENT-260906-rpiv-observability: RPIV Observability

## Status

Adopted

## Purpose

Expose standalone and managed issue execution as structured files without a
required persistence service, parser, or language-specific helper.

## Scope

The RPIV coordinator, four leaf stages, work-item state/events, and Foreman's
observation and communication boundary.

## Definition

### Rules
- Research alone resolves/creates the canonical work-item directory, preserving
  its established name. It initializes observability on the coordinator's
  behalf after resolution; no second work-item path is invented.
- The coordinator is the single lifecycle writer after initialization. Leaf
  stages report progress/blockers in their results instead of racing to write.
- Use host file tools to create immutable event files, then update `state.json`.
  No `rpiv-state` program or language-specific runtime is required.
- Use phase values `research`, `plan`, `implement`, and `verify`. Keep status
  separate: `running`, `waiting`, `blocked`, `failed`, `needs-human`,
  `replanning`, or `done`. Validation/delivery remain Verify activities.
- Each event identifies version, issue, worker, attempt, sequence, UTC timestamp,
  branch, worktree, request ID, event name, phase/status, reason, and evidence.
- Event names are `WORKER_STARTED`, `PHASE_CHANGED`, `PROGRESS`, `BLOCKED`,
  `NEEDS_DECISION`, `FAILED`, and `COMPLETED`.
- Store events as `events/<attempt>/<zero-padded-sequence>.json`. The file content
  is one complete JSON object. Never overwrite a prior event with different
  data; identical request replay is a no-op, not a new sequence.
- Read back the event before updating the snapshot. Reconcile a lagging
  snapshot from valid history. Reject malformed, ahead-of-history, conflicting,
  mismatched-identity, or out-of-order state instead of inferring success.
- This is a single-writer agent protocol, not a claim of atomic multi-file
  transactions. Interrupted writes require explicit reconciliation.
- Normal phase order is Research -> Plan -> Implement -> Verify. Corrections
  may return to Plan with `replanning`, or from Verify to Implement; record the
  reason and rerun downstream stages.
- `COMPLETED` requires Verify's accepted commit and PR URL. It means delivered
  for review, not merged integration or mission completion.
- Exceptional evidence includes `category` and `owner`: transient -> foreman,
  validation -> implement, dependency -> foreman, decomposition -> foreman,
  architecture -> plan, human -> user.
- Same-attempt continuation requires an explicit resolution and revalidated
  saved handoffs. Terminal attempts are immutable; an authorized restart uses
  a new unique attempt ID and retains earlier event directories.
- Runtime files are Git-ignored. Human-readable Research/Plan/Implement/Verify
  artifacts remain tracked and clean-tree handoffs remain meaningful.

### Interfaces

Managed bootstrap fields are `ISSUE_NUMBER`, `WORKER_ID`, `ATTEMPT_ID`,
`WORKTREE`, `FOREMAN_ROOT`, and optional `RESUME`. Standalone RPIV derives the
issue and checkout, creates a unique attempt, and has no Foreman root.

```json
{
  "version": 1,
  "issue": 123,
  "worker": "rpiv-123",
  "attempt": "unique-execution-id",
  "sequence": 3,
  "updated_at": "2026-09-06T12:00:00Z",
  "branch": "feat/123-organizations",
  "worktree": "/repo/.trees/issue-123",
  "request_id": "implement-entry-1",
  "event": "PHASE_CHANGED",
  "phase": "implement",
  "status": "running",
  "reason": "",
  "evidence": {}
}
```

`state.json` contains the last accepted event. Every immutable event is readable
independently; order is determined by validated attempt/sequence, not terminal
output. The coordinator uses file reads to resume or inspect its history.

Managed commands live in `<FOREMAN_ROOT>/.foreman/inbox/<WORKER_ID>/`.
Commands contain ID, issue, worker, attempt, command (`pause`, `resume`, `cancel`,
`refresh`), reason, and timestamp. The coordinator reads them at safe boundaries,
rejects malformed identities, and acknowledges IDs in `PROGRESS` evidence.
Standalone workers do not poll a Foreman inbox.

### Expectations

Publish lifecycle changes at entry, dispatch, valid handoff, correction,
exception, and completion. Foreman reads files and persists an observation
cursor; optional tmux signals only wake readers. No message text is executed.

## Rationale

Immutable small event files and a single writer provide inspectable history
using ordinary agent tools. A consuming project can later justify a stronger
persistence implementation without making it a template prerequisite.

## Usage Examples

```text
research/running -> plan/running -> implement/running -> verify/running
verify/running -> plan/replanning -> implement/running -> verify/running
verify/done + PR URL -> Foreman delivered node -> integration evidence
```

## Integration Guidelines

- Retain normal RPIV artifact and handoff fields alongside worker identity.
- Keep snapshots/events local and free of secrets.
- Earlier experimental `events.jsonl` files are not silently converted or
  deleted. Retain them and reconcile explicitly before resuming that attempt.
- Missing or inconsistent state is a visible blocker, never an acceptance signal.

## Exceptions

- Before Research resolves a work-item directory, report startup failure to the
  caller/controller without creating an invented artifact path.

## Enforcement

- [x] Agent contract review
- [x] Single-writer ownership and read-back before publication
- [x] Independent consumers reject inconsistent state

## Related ADRs

- [ADR-260906-foreman-control-plane](../ADR/ADR-260906-foreman-control-plane.md)
