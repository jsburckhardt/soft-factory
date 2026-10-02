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
- Managed events also carry `assignment_revision` and `assignment_sha256` and must match the
  bootstrap assignment's issue, criteria, and authorized worktree. Research
  resolves the canonical work-item directory as usual; the assignment does
  not replace the GitHub issue, work-item path, or four stage handoffs.
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
- Standalone `COMPLETED` requires Verify's accepted commit and PR URL. Managed
  delivery first publishes `PROGRESS` in `verify/waiting` with
  `evidence.activity: "pr-review"`, PR identity, verified implementation commit,
  final pushed `head_sha`, and finding dispositions. Managed `COMPLETED` also
  requires `review-accepted` for that exact current head. Neither means merged
  integration or mission completion.
- `review-feedback` and `review-accepted` are consumed only at this managed
  Verify boundary. Validate PR/repository/worker/attempt/head/round and stable
  review IDs, and ignore identical acknowledged replays. A stale or conflicting
  message is explicitly reported without applying it.
- Acknowledge feedback with `PROGRESS` evidence carrying command/review IDs and
  the accepted correction round before dispatching fixes. Persist the payload
  reference, finding IDs, chosen owner, and last completed correction stage so
  interruption after acknowledgement cannot lose the outstanding work.
- Every correction phase/handoff preserves that pending review context.
  Re-delivery marks the correction round complete and clears pending execution
  while retaining finding dispositions; the prior acknowledged feedback must
  not start another fix cycle against the new head.
- Code/test/documentation findings return to Implement; coverage/scope/
  architecture findings return to Plan, then Implement and Verify. This is a
  correction within RPIV, not a fifth stage. New scope needs agreed issue/graph
  revision instead of silently expanding the worker's mandate.
- Resuming a review-waiting worker first reloads pending review state and inbox.
  Without a valid decision it remains waiting and does not recreate the PR.
  The coordinator can return a waiting result for a bounded CLI process;
  Foreman must signal a live process or resume its owned stopped console.
- Exceptional evidence includes `category` and `owner`: transient -> foreman,
  validation -> implement, dependency -> foreman, decomposition -> foreman,
  architecture -> plan, human -> user.
- Same-attempt continuation requires an explicit resolution and revalidated
  saved handoffs. Terminal attempts are immutable; an authorized restart uses
  a new unique attempt ID and retains earlier event directories.
- Every status, blocked, failed, or completed event carries a typed worker
  result in `evidence.worker_result`. Missing or invalid result fields are a
  protocol error, never evidence of success. Workers report observed facts;
  they never edit Foreman's mission or registry.
- Runtime files are Git-ignored. Human-readable Research/Plan/Implement/Verify
  artifacts remain tracked and clean-tree handoffs remain meaningful.

### Interfaces

Managed bootstrap fields are `ISSUE_NUMBER`, `WORKER_ID`, `ATTEMPT_ID`,
`WORKTREE`, `FOREMAN_ROOT`, `ASSIGNMENT_PATH`, and optional `RESUME`. Standalone RPIV derives the
issue and checkout, creates a unique attempt, and has no Foreman root.
The assignment is a versioned JSON file in Foreman's root; RPIV reads it
before starting and rejects issue/worker/attempt/checkout/revision mismatches or a contract
that omits the issue's acceptance criteria. It does not rewrite the assignment.

The worker-result object is embedded in immutable event evidence so the
event cursor provides one authoritative ordered communication channel:

```json
{
  "work_item": 21,
  "status": "complete",
  "summary": "Refund API accepted for bounded delivery",
  "changed_files": ["src/payments/refunds/api.ts"],
  "acceptance_evidence": {
    "AC-1": {"status": "passed", "evidence": ["just verify"]}
  },
  "blockers": [],
  "discovered_dependencies": [],
  "risks": [],
  "notes": []
}
```

`evidence.worker_result` conforms to this JSON Schema. Neither a worker nor
Foreman may treat mere field presence as type validation:

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "type": "object",
  "required": ["work_item", "status", "summary", "changed_files", "acceptance_evidence", "blockers", "discovered_dependencies", "risks", "notes"],
  "additionalProperties": false,
  "properties": {
    "work_item": {"type": "integer", "minimum": 1},
    "status": {"enum": ["running", "blocked", "failed", "complete"]},
    "summary": {"type": "string", "minLength": 1},
    "changed_files": {"type": "array", "items": {"type": "string", "minLength": 1}, "uniqueItems": true},
    "acceptance_evidence": {
      "type": "object",
      "patternProperties": {
        "^AC-[1-9][0-9]*$": {
          "type": "object",
          "required": ["status", "evidence"],
          "additionalProperties": false,
          "properties": {
            "status": {"enum": ["pending", "failed", "passed"]},
            "evidence": {"type": "array", "items": {"type": "string", "minLength": 1}}
          }
        }
      },
      "additionalProperties": false
    },
    "blockers": {"type": "array", "items": {"type": "string", "minLength": 1}},
    "discovered_dependencies": {
      "type": "array",
      "items": {
        "type": "object",
        "required": ["description"],
        "additionalProperties": false,
        "properties": {
          "description": {"type": "string", "minLength": 1},
          "suggested_id": {"type": "string", "minLength": 1}
        }
      }
    },
    "risks": {"type": "array", "items": {"type": "string", "minLength": 1}},
    "notes": {"type": "array", "items": {"type": "string", "minLength": 1}}
  }
}
```

For nonterminal events, `changed_files` and `acceptance_evidence` may be empty
or partial. `blockers`, `risks`, and `notes` are descriptive strings;
`discovered_dependencies` contains proposals, not commands or graph edits.
A blocker or failure also records
its reason and owner in the event. The final changed-file list includes tracked
RPIV artifacts and application changes, and is checked against the full PR
diff rather than asserted by a terminal message alone.
Statuses are `running`, `blocked`, `failed`, and `complete`, corresponding
to `PROGRESS`, `BLOCKED`, `FAILED`, and `COMPLETED` events. A managed
`verify/waiting` PR-review `PROGRESS` event also reports `status: running`;
it is not `complete`. Every AC in the assignment must appear in a completed
result with passing, concrete evidence, and Foreman independently checks it
against the PR and Verify handoff. Blocked/failed results explain their
reason and owner in event evidence. A `NEEDS_DECISION` question uses
`status: blocked` with a human owner; an answered clarification is a running
`PROGRESS` event. The event's issue/worker/attempt must match its reservation,
and the `work_item` equals the event issue. Foreman validates the schema,
event-to-result status pairing, and correlation before advancing its cursor.
No event means no inferred completion.

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
  "assignment_revision": 2,
  "assignment_sha256": "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
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
Commands contain ID, issue, worker, attempt, command (`status`, `pause`,
`resume`, `cancel`, `clarify`, `update`, `refresh`, `review-feedback`,
`review-accepted`), reason, and timestamp. `clarify` carries `question`,
`update` carries `information`; neither is executable code. Review
commands also contain the fields below. The coordinator reads them at safe boundaries,
rejects malformed identities, and acknowledges IDs in `PROGRESS` evidence.
Standalone workers do not poll a Foreman inbox.
For an unanswered `clarify`, `NEEDS_DECISION` acknowledges the ID and records
the human owner; it is not simultaneously reported as running. On managed
resume, RPIV re-reads the GitHub issue and Foreman's registry and compares the
assignment bytes' SHA-256 digest to the digest reserved at dispatch. A changed
issue, reservation, or same-revision contract fails the handoff explicitly.

```json
{
  "id": "command-21-review-1",
  "issue": 21,
  "worker": "rpiv-21",
  "attempt": "unique-execution-id",
  "command": "review-feedback",
  "reason": "Membership removal does not meet the agreed outcome",
  "created_at": "2026-09-11T02:00:00Z",
  "review_id": "review-21-1",
  "round": 1,
  "pr_number": 45,
  "pr_url": "https://github.com/example/service/pull/45",
  "head_sha": "0123456789abcdef0123456789abcdef01234567",
  "decision": "changes-requested",
  "findings": [
    {
      "id": "F-1",
      "ac_ids": ["AC-2"],
      "outcome_ids": ["OUT-1"],
      "expected": "Removing a member revokes access",
      "observed": "The existing membership check still permits access",
      "evidence": ["PR diff: membership handler", "Missing revocation evidence"],
      "return_stage": "implement"
    }
  ]
}
```

`review-accepted` uses `decision: "accepted"` and an empty unresolved `findings`
list for the current head. `round` is the feedback iteration (0 for acceptance
without corrections); feedback increments it once, acceptance echoes the last
round. `review_id` and command IDs are unique and persisted. Feedback for a
round already processed cannot cause a duplicate fix cycle. Original finding
IDs remain stable across rounds, with fixed/disputed evidence on the next
delivery.

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
verify/waiting + PR/head -> Foreman feedback -> implement -> verify/waiting
verify/waiting + matching review-accepted -> verify/done -> integration evidence
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
