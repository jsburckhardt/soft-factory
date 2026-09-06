# CORE-COMPONENT-260906-foreman-orchestration: Foreman Orchestration

## Status

Adopted

## Purpose

Keep mission ownership, worker isolation, and scheduling consistent across the
Foreman agent, command interface, and RPIV workers.

## Scope

The repository-level control plane. Foreman does not perform issue Research,
detailed Plan, production coding, worker validation, or edits to worker files.

## Definition

### Rules
- Record a mission objective, observable outcome conditions, unresolved
  decisions, and repository identity before decomposition. Vague intent is
  permitted; unresolved requirements are not silently treated as satisfied.
- Maintain `.foreman/context/{vision,repository,architecture,constraints}.md`
  with source paths, observed commit/date, uncertainties, and refresh triggers.
  Refresh affected entries after changes; do not reread everything per tick.
- Persist one active `.foreman/mission.json` and `.foreman/registry.json`.
  V1 uses GitHub Issues, not another backlog system.
- Reuse relevant issues. New nodes go through issue-generator and its
  rubber-duck review before creation. Record the proposed node and its issue
  URL after creation; reconcile an uncertain creation result before retrying.
- A node is independently deliverable and maps to a real issue. Dependencies
  gate delivery; optional parent links organize work but do not gate readiness.
- Validate missing references, duplicate IDs, self-dependencies, cycles,
  positive integer capacity, and outcome references before scheduling.
- Ready nodes are queued, have no blockers, and have integrated dependencies.
  Order by ascending priority then issue number. Count every non-retired
  registry entry against capacity, including starting, blocked, and waiting
  workers. Reserve a worker before allocating resources.
- Use `.trees/issue-N`, `feat/N-work`, and `rpiv-N` as the default worktree,
  issue branch, and worker/window identities. Preserve a matching existing
  issue branch when explicitly reconciled; never commandeer another checkout.
- Use a dedicated default-socket tmux session `foreman`, separate from the
  devcontainer's shared `soft-factory` session/socket. Reserve window zero.
- Reconcile ownership, attempt, branch, worktree, and tmux window before
  restarting. Retain ambiguous reservations and stop; do not guess or delete.
- Normal interactive permissions are the default. `permission_mode: yolo`
  requires explicit mission or launch approval and is shown before launch.
- A completed RPIV run means a verified PR was delivered, not merged. Only a
  confirmed merged PR whose merge commit is an ancestor of the refreshed base
  may mark a node integrated. A new dependent worktree starts from that base.
- Graph changes carry a revision/reason and preserve mission outcome links.
  Pause affected active workers cooperatively before changing their scope or
  prerequisites. Never mutate a worker's plan/files to make the graph fit.
- `pause` stops new launches and requests a safe-boundary pause from workers;
  `resume` requires explicit resolution. A missing heartbeat is a reconciliation
  problem, not permission to create another worker.
- Re-evaluate each original outcome against integrated evidence before mission
  completion. No workers, a closed issue, or an open PR is insufficient.

### Interfaces

`mission.json` version 1 contains `id`, `objective`, `base_ref`, `max_workers`,
`permission_mode`, `paused`, `revision`, `revision_reason`, `conditions`, and
`nodes`. Each condition has `id`, `description`, and `evidence` (initially empty).
Each node has `issue`, `depends_on`, `outcomes`, `priority`, `status`, `blockers`,
and optional `parent`. Node statuses are `queued`, `running`, `delivered`,
`integrated`, `blocked`, `failed`, and `cancelled`. Cancellation is explicit,
never satisfies a dependency, and must explain its outcome disposition.
Integration adds `pr`, `merge_commit`, and `base_commit` evidence.

`registry.json` maps issue numbers to worker identity, attempt UUID, branch,
absolute worktree, base commit, permission mode, and reservation state. It is a
resource ledger, not issue acceptance evidence.

`send(worker, message)` durably appends a typed JSON command to that worker's
controller-owned inbox and signals tmux. `receive(event)` reads ordered RPIV
events/state and reconciles identity/attempt/sequence before updating the graph.
Wakeups are hints; durable files are authoritative and polling handles lost
wakeups. Commands are `pause`, `resume`, `cancel`, and `refresh`; none execute
arbitrary text. Workers acknowledge command IDs with a `PROGRESS` event.

### Expectations

| Failure | Owner | Automatic recovery |
|---------|-------|--------------------|
| Transient process/tool failure | Foreman | At most one restart after reconciling ownership and preserving work |
| Code/test/documentation validation | RPIV Implement | Existing single correction cycle, then failed |
| Dependency blocker | Foreman | No blind retry; await integration or revise graph |
| Bad decomposition/scope | Foreman and RPIV Plan | Pause, revise issue/graph, then rerun downstream stages |
| Architecture conflict | RPIV Plan | No automatic override; ADR/core-component change required |
| Human/product/permission decision | User via Foreman | No automatic retry or resume |

Independent workers continue when another fails. A controller stops scheduling
on invalid graph or inconsistent state and reports actionable evidence.

## Rationale

The agent reasons about outcomes while deterministic helpers enforce identity,
ordering, capacity, and safe persistence. This keeps Foreman from becoming RPIV.

## Usage Examples

```text
A and B integrated -> C ready
A delivered PR, B integrated -> C blocked on A
4 reserved workers, max_workers=4 -> no new launches
All nodes integrated, one outcome lacks evidence -> mission incomplete
```

## Integration Guidelines

- Use `just foreman-start`, `just foreman-status`, and the recipes documented in
  `docs/foreman.md`; do not reproduce raw operating commands in agents.
- Review proposed issue changes before creating new nodes.
- Keep registry and graph updates serialized; V1 has one controller.
- Keep local context/event history free of secrets and unnecessary raw output.
- Retire workers only after their console/process is stopped and work is
  preserved. Worktree removal is never automatic.

## Exceptions

- Standalone RPIV does not need a Foreman mission or tmux session.
- Different transports/trackers require a future ADR, not ad hoc worker changes.

## Enforcement

- [x] Automated checks
- [x] Code review checklist
- [x] Test coverage requirements

## Related ADRs

- [ADR-260906-foreman-control-plane](../ADR/ADR-260906-foreman-control-plane.md)
