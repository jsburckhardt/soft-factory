# CORE-COMPONENT-260906-foreman-orchestration: Foreman Orchestration

## Status

Adopted

## Purpose

Define a portable, agent-owned mission workflow without turning the repository
template into a scheduler application.

## Scope

Foreman, project initialization, its project profile and mission data, and the
boundary to isolated single-issue RPIV workers.

## Definition

### Rules
- Foreman MUST own mission understanding, decomposition, graph validation,
  readiness, capacity accounting, coordination, recovery, and outcome decisions
  in APS. A helper or justfile MUST NOT become another owner of those decisions.
- Bootstrap MUST select the new project's stack, commands, and development
  environment with the user. Onboarding MUST discover and preserve the existing
  project's equivalents. Neither MUST introduce Python or another language
  solely to operate Foreman.
- Initialization MUST offer Foreman as an optional capability and record the
  choice in `.foreman/project.json`. Missing configuration means execution is
  disabled, not an invitation to generate or run an unapproved runtime.
- Approved worker-operation recipes MUST live in the root justfile, remain
  thin, and reflect the actual project environment. No worker may launch until
  its configured recipes and required tools/access have been confirmed.
- Foreman MUST record an objective, observable outcome conditions, assumptions,
  and unresolved decisions before decomposing deliverables.
- Repository context MUST retain sources, observed commit/date, uncertainties,
  and refresh triggers. Refresh changed information rather than the entire
  repository at every scheduling decision.
- Reuse relevant GitHub issues. New nodes MUST pass through issue-generator and
  its rubber-duck review. Preserve request/candidate correlations across partial
  creation failures instead of retrying blindly.
- Each node MUST identify an independently deliverable issue, its mission
  outcomes, dependencies, blockers, priority, and status. Optional parent links
  describe hierarchy and MUST NOT imply delivery dependencies.
- Before scheduling, Foreman MUST reject duplicate/missing references, cycles,
  invalid capacity, inconsistent worker identities, and unsubstantiated
  integration. It MUST reason over the recorded graph explicitly, not treat a
  recipe exit code as a readiness decision.
- Ready nodes are queued, have no blockers, and have integrated dependencies.
  Select by ascending priority then issue number, up to available capacity.
  Count every reserved or still-live worker, including blocked/waiting workers.
- The single active Foreman controller MUST persist a reservation before asking
  the host to create resources. Reconcile partial launches before retrying.
- For the enabled CLI/tmux adapter, use `.trees/issue-N`, worker/window `rpiv-N`,
  and a branch following the consuming project's convention. Reserve window
  zero of the owned `foreman` session for the controller. Preserve unrelated
  sessions, worktrees, branches, and user changes.
- Keep normal configured permissions unless the user explicitly approves a
  broader mode. Show the permission mode before each launch.
- Pause/resume/cancel are agent decisions and typed messages, not forced edits
  to a worker's files. Wait for a safe-boundary acknowledgement before changing
  active scope or prerequisites.
- A delivered PR does not satisfy a dependency until its integration is
  confirmed and available in the dependent worker's base. A process exit, issue
  closure, prose claim, or unmerged PR is insufficient.
- Preserve graph revisions and outcome links when adding, cancelling, or
  replanning nodes. Re-evaluate every original mission condition against
  integrated evidence before declaring completion.
- Foreman MUST NOT code, perform issue Research or detailed Plan, run worker
  tests, edit worker-owned files, or merge/remove resources automatically.

### Interfaces

`.foreman/project.json` is the consuming project's committed, non-secret
profile. It records repository/base branch, stack, setup/validation recipe
names, and whether worker execution is enabled. Enabled execution also records
the host adapter, session/worktree conventions, capacity, permission mode,
and operation-to-recipe mappings. Values describe configuration; they are not
executable shell fragments. See `docs/foreman.md` for the initialization example.

`.foreman/context/{vision,repository,architecture,constraints}.md` contains
long-lived strategic context. `.foreman/mission.json` records objective,
conditions, graph, pause state, and revisions. `.foreman/registry.json` records
reserved issue, worker, attempt, branch, worktree, console, and launch outcome.
These local files are maintained through agent file tools, not a runtime API.

The host adapter exposes primitive operations: `prepare`, `launch`, `inspect`,
`signal`, `wait`, `resume`, `retire`, `issues`, and `delivery`. Its recipe
signatures and outputs are recorded in the profile. Launch receives
`ISSUE_NUMBER`, `WORKER_ID`, `ATTEMPT_ID`, `WORKTREE`, `FOREMAN_ROOT`, and optional
`RESUME` as the exact RPIV bootstrap fields.

`send(worker, message)` creates a uniquely identified JSON command in
`.foreman/inbox/rpiv-N/<command-id>.json`, bound to issue/worker/attempt, then
optionally signals the configured transport. `receive(event)` reads immutable
RPIV events, compares identity/attempt/sequence with its persisted cursor, and
applies each event at most once. Messages are data, never shell input.

### Expectations

| Failure | Owner | Recovery limit |
|---------|-------|----------------|
| Transient execution | Foreman | At most one restart after ownership reconciliation |
| Code/test/documentation validation | RPIV Implement | Existing correction cycle, then fail |
| Dependency blocker | Foreman | No blind retry; await integration or revise graph |
| Decomposition/scope | Foreman and Plan | Pause, revise issue/graph, rerun downstream |
| Architecture conflict | Plan | No override; ADR/core-component decision required |
| Human or permission decision | User via Foreman | No automatic retry or resume |

Independent work can continue when another node is blocked. An invalid graph,
ambiguous ownership, or inconsistent history closes the scheduling gate.

## Rationale

The template establishes responsibilities and contracts. Each consuming project
supplies its actual operating environment instead of inheriting a control-plane
application and its dependencies.

## Usage Examples

```text
New project -> choose stack -> confirm commands -> optionally enable workers
Existing project -> discover capabilities -> preserve commands -> opt in
Mission -> context -> reviewed issues -> ready set -> isolated RPIV outcomes
Delivered PR -> confirmed integration -> dependency available -> next worker
```

## Integration Guidelines

- Bootstrap/onboarding write the project profile only from confirmed choices.
- Record a completed project-initialization marker; inherited template ADRs or
  core-components alone are not evidence that a consumer is already initialized.
- Projects enabling Foreman later may explicitly configure the profile and
  primitive recipes without rerunning application scaffolding.
- Keep configuration non-secret; resolve credentials through the existing host.
- Additional persistence automation requires demonstrated need and a project
  architecture decision, not a new template-wide runtime.

## Exceptions

- Standalone RPIV does not need Foreman configuration or tmux.
- Mission intake and context maintenance may run while worker execution is disabled.

## Enforcement

- [x] Agent contract review
- [x] Project-specific command validation before enabling execution
- [x] Evidence-based reconciliation by the owning agent

## Related ADRs

- [ADR-260906-foreman-control-plane](../ADR/ADR-260906-foreman-control-plane.md)
