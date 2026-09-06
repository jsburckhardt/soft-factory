# Foreman

Foreman converts product intent into a live dependency graph of deliverable
GitHub issues. It retains repository understanding and coordinates isolated
RPIV workers until integrated results satisfy the mission. It does not code,
run issue tests, edit worker files, or micromanage RPIV stages.

| Plane | Owns |
|-------|------|
| Control | Foreman, strategic context, graph, scheduling, registry, recovery |
| Execution | Independent Copilot CLI sessions, issue worktrees, four-stage RPIV |
| Observability | Work-item state, ordered events, typed messages, tmux consoles |

## Prerequisites and scope

V1 targets POSIX/Linux with Git, just, Python 3.9+, tmux, and Copilot CLI. The
devcontainer supplies Git, just, tmux, and Copilot, and explicitly installs
Python 3. GitHub/Copilot access is needed to create issues or execute
workers, **not to edit the template or run local contract checks**.

The Foreman/RPIV/issue-generator agents use the installed APS framework revision
1.2.2 and CLI adapter. Their tool names target Copilot CLI rather than VS Code's
namespaced tools. The bootstrap/onboarding and unrelated agents retain their
existing editor integrations. An editor-only host needs an APS platform
adaptation; it must not assume nested worker delegation is portable.

No process starts when this template is cloned. No UI, alternate tracker, Herd
dependency, automatic merge, or unattended permission bypass is included.
Herd/HERDR is a future transport evaluation, not an assumed implementation.

## Intake and startup

Select the `foreman` agent and give it a PRD or a statement such as "add
collaborative editing." It inspects product behavior, source, documentation,
architecture records, constraints, conventions, and existing work. It records
the objective, measurable outcomes, essential unresolved decisions, and sourced
context under `.foreman/context/`.

Foreman creates `.foreman/mission.json` using the schema below. For an initial
mission, `nodes` may be empty while decomposition is pending. Once the mission
is recorded, start the controller explicitly:

```text
just foreman-validate .foreman/mission.json
just foreman-start
just foreman-attach
```

The default tmux socket hosts session `foreman`, with controller window zero.
This is intentionally separate from the devcontainer's `soft-factory` session
on its custom socket. An existing session is reused only when its ownership
marker matches this checkout. An unrelated same-name session is an error.

The controller remains an interactive Copilot session. RPIV workers are bounded
programmatic CLI processes that exit after their outcome, allowing dead
consoles to be retired and capacity to be reused. Configured CLI permissions
remain in force; a worker lacking approval reports a permission failure for
human resolution rather than silently adding broad permissions. Returning a
waiting report does not discard mission context; attach and request resume
after the recorded prerequisite is resolved.

## Mission and graph schema

```json
{
  "version": 1,
  "id": "organization-support",
  "objective": "Allow users to manage organizations and membership",
  "base_ref": "origin/main",
  "max_workers": 4,
  "permission_mode": "interactive",
  "paused": false,
  "revision": 1,
  "revision_reason": "Initial mission decomposition",
  "conditions": [
    {
      "id": "OUT-1",
      "description": "Organization membership behavior is delivered with observable evidence",
      "evidence": []
    }
  ],
  "nodes": [
    {
      "issue": 21,
      "depends_on": [],
      "outcomes": ["OUT-1"],
      "priority": 0,
      "status": "queued",
      "blockers": []
    },
    {
      "issue": 22,
      "depends_on": [],
      "outcomes": ["OUT-1"],
      "priority": 0,
      "status": "queued",
      "blockers": []
    },
    {
      "issue": 23,
      "depends_on": [21],
      "outcomes": ["OUT-1"],
      "priority": 1,
      "status": "queued",
      "blockers": []
    }
  ]
}
```

Issue numbers above are illustrative: substitute real issues produced/reused by
the reviewed issue-generation flow. Optional `parent` describes hierarchy, not
a delivery dependency. `outcomes` links every node back to the mission.

The ready set is sorted by priority (lower first), then issue number. Queued
nodes without blockers may run only after all dependencies are `integrated`.
Reservations count against `max_workers`, even when a worker is waiting,
blocked, or partially launched. Invalid capacity, references, cycles, identity,
or evidence causes an explicit error instead of permissive scheduling.

The controller owns graph edits. Record a revision/reason when changing scope,
dependencies, or outcome mappings. Never erase active work to simplify the
graph. Cancellation needs `cancellation_reason` explaining outcome disposition
and does not satisfy dependencies.

New nodes use `.foreman/issue-request.json` with a stable `request_id`,
`mission_id`, and `candidates` array. Each candidate has `id`, `problem`, and
`outcomes`; it becomes a separate reviewed issue, not one combined mission
ticket. Foreman uses
`just foreman-issues .foreman/issue-request.json` to open a **primary**
issue-generator CLI session in `backlog`. That agent performs rubber-duck
review and records `.foreman/issue-result.json`, including partial successes.
The result contains `request_id`, `mission_id`, an `issues` array with candidate
IDs, numbers, URLs, outcomes, and review dispositions, and an `errors` array.
Correlate both request and candidate IDs and reconcile existing issues before
retries. The bounded backlog process exits after its batch. This avoids nested
Foreman -> issue-generator -> reviewer subagents.

## Worker launch and isolation

```text
just foreman-status
just foreman-launch 21
just foreman-resources
```

The launch recipe checks tools/access, owned session, clean controller checkout,
graph readiness, permission mode, branch/window conflicts, and dependency
ancestry. It fetches the configured base, reserves capacity, creates the
worktree, and opens the worker console.

| Identity | Issue 21 |
|----------|----------|
| Worktree | `.trees/issue-21` |
| Default branch | `feat/21-work` |
| Worker/window | `rpiv-21` |
| Execution attempt | Generated UUID, preserved for the running attempt |
| Worker agent | `rpiv` in a separate primary Copilot CLI session |

Bootstrap supplies `ISSUE_NUMBER`, `WORKER_ID`, `ATTEMPT_ID`, `WORKTREE`, and
`FOREMAN_ROOT`; the environment carries `RPIV_WORKER`, `RPIV_ATTEMPT`, and
`FOREMAN_ROOT`. The worker receives its normal RPIV mandate and communication
contract. Its four stage agents remain leaf workers.

The `.trees` checkout is not a container/security sandbox; Git's object database
and host resources are shared. Do not run untrusted code merely because it is
in another worktree.

Interactive permissions are the default. After explicit user approval, set
the mission's `permission_mode` to `yolo` and explicitly pass `yolo` to the
launch recipe. The recipe requires these modes to agree and displays the mode
before creating resources. Agents must never infer this approval from a
general request to deliver a feature.

## State and communication

Research resolves exactly one canonical work-item directory, preserving its
name after title changes. It initializes state there. Before that point,
Foreman's reservation reports `starting`; there is no fabricated issue path.

```text
project/work-items/21-add-organization-model/
  state.json
  events.jsonl
  .attempts/
  research/
  plan/
  implementation/
  verify/
```

Runtime files are Git-ignored so they cannot dirty Implement/Verify commit
handoffs. Keep them locally for resume. `state.json` is the last accepted event;
`events.jsonl` is append-only for the current attempt. Old attempts are archived.

The coordinator creates `.event-request.json` in its work-item directory and
uses the recipe below; state identity and sequence are generated by the helper.
Reuse `request_id` only for an identical retry.

```json
{
  "request_id": "implement-entry-1",
  "event": "PHASE_CHANGED",
  "phase": "implement",
  "status": "running",
  "reason": "",
  "evidence": {}
}
```

```text
just rpiv-state 21 project/work-items/21-add-organization-model/.event-request.json
just rpiv-inbox
```

The first event is `WORKER_STARTED` in `research/running`. Phase values remain
`research`, `plan`, `implement`, and `verify`. Status separately describes
running/waiting/blocked/failed/needs-human/replanning/done. The coordinator
publishes stage transitions and validated handoffs; leaf workers return their
progress rather than writing concurrently.

Events include `WORKER_STARTED`, `PHASE_CHANGED`, `PROGRESS`, `BLOCKED`,
`NEEDS_DECISION`, `FAILED`, and `COMPLETED`. Completion requires phase `verify`,
status `done`, and evidence containing `commit` and `pr_url`. Failure/blocker
events require a reason. Logs correlate issue, worker, attempt, sequence,
branch, worktree, and timestamp.
Exceptional events also carry `evidence.category` and `evidence.owner` using the
failure-routing table below (for example `dependency` / `foreman`). This makes
recovery ownership observable without parsing an arbitrary explanation.

`send(worker, message)` uses a JSON file, for example:

```json
{"command": "pause", "reason": "Resolve the authorization prerequisite"}
```

```text
just foreman-send 21 .foreman/pause-request.json
just foreman-observe
just foreman-wait
```

Supported commands are `pause`, `resume`, `cancel`, and `refresh`. The inbox
assigns a command ID and binds it to the current attempt. Workers read commands
at safe stage boundaries, ignore already-acknowledged IDs, and acknowledge
using `PROGRESS` evidence. A pause/cancel is cooperative, not a forced process
termination. Foreman waits for acknowledgements before revising affected work.

Payloads remain in JSON files; tmux `wait-for` notifications only wake
consumers. No `send-keys`, shell evaluation, or scrollback parsing is used.
Consumers reread durable history after a bounded wait, so missed wakeups cannot
lose messages. Malformed or conflicting history is a reconciliation error.

## Delivery, adaptation, and completion

RPIV `COMPLETED` means Verify delivered an accepted PR. Foreman marks the node
`delivered`, then independently gathers integration evidence:

```text
just foreman-delivery 21 45
```

Here 45 is the actual PR number. The recipe requires a merged PR linked to the
issue and verifies its merge commit is in the refreshed configured base.
Foreman records `delivery: {pr, merge_commit, base_commit}` before marking the
node `integrated`. Launch checks dependency ancestry again against the exact
new worktree base. An unmerged PR, closed issue, success message, or process
exit cannot unblock dependents.

Research findings may reveal new prerequisite work or bad decomposition.
Foreman pauses affected workers, records the finding, requests reviewed issue
nodes, revises the graph, and routes issue-level changes back to Plan. It never
patches a worker's plan or bypasses an ADR.

Before declaring the mission complete, Foreman re-evaluates each original
condition, records concrete integrated evidence, and checks its outcome links.
All workers exiting is not enough. An unmet/inconclusive condition remains a
reported gap even if every PR was delivered.

## Pause, restart, and recovery

`just foreman-pause` closes the scheduling gate; it does not interrupt live
workers. Send typed pause requests to each affected worker and wait for
acknowledgements. Resolve the reason before `just foreman-resume` and matching
worker `resume` messages.
If a cooperatively paused programmatic worker has already exited, use
`just foreman-continue 21` after sending the resume message. This respawns only
the owned dead console in the same worktree/attempt. RPIV validates its saved
handoffs and continues the first unfinished stage; it does not recreate the
branch or mistake its existing artifacts for unrelated changes.

On restart, reconcile mission, registry, tmux ownership/attempt markers,
worktree/branch identity, and state/history. Existing matching resources are
retained; unrelated resources are never overwritten. Repeating launch for a
reserved issue is rejected, not duplicated. Reattach to the existing console
to continue. A partial launch retains its reservation until its resources are
explicitly reconciled.

After a worker process is stopped, `just foreman-retire 21` closes only an owned
dead console and releases its reservation. It leaves the branch and worktree
intact. If a reservation has no console after a partial failure, inspect
`just foreman-resources` and the ledger and resolve it explicitly; do not guess
that missing state implies completion. A new attempt must preserve old work
and history and use an explicit restart request, not overwrite an active log.

| Failure class | Owner and action |
|---------------|------------------|
| Transient execution | Foreman; at most one reconciled restart, then escalate |
| Validation failure | RPIV Implement; normal correction cycle, then fail |
| Dependency blocker | Foreman; await integration or revise graph, no blind retry |
| Decomposition/scope | Foreman + Plan; pause, revise issue/graph, rerun downstream |
| Architecture conflict | Plan; ADR/core-component decision required |
| Human/permission decision | User via Foreman; no automatic retry/resume |

Other independent workers can continue. Foreman does not auto-merge or delete
worktrees. Keep `.foreman/` and ignored work-item runtime files for resumability;
they are local state, not a remote backup.

## Template maintenance

`just verify-focused` and `just verify` run inert standard-library fixtures and
agent contract checks. They do not authenticate, create GitHub issues, launch
Copilot sessions, or manipulate an existing tmux session. Raw operating commands
live in the root `justfile`; `scripts/foreman.py` handles data contracts.

Bootstrap/onboarding must preserve these recipes, ignores, agent identities,
and shared contracts. Upgrading the APS skill also requires updating the
README badge and `APS_BADGE`; this change does not upgrade APS.
