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
- A worker may propose a discovered dependency in its typed result. Foreman
  records and evaluates the proposal, reuses an existing issue or requests a
  reviewed new issue, and pauses affected work before revising the graph.
  Rejected proposals carry a reason; no worker rewrites graph dependencies.
- Each node MUST identify an independently deliverable issue, its mission
  outcomes, dependencies, blockers, priority, and status. Optional parent links
  describe hierarchy and MUST NOT imply delivery dependencies.
- Before dispatch, Foreman MUST write a bounded JSON assignment for the issue
  and validate it against the issue and graph. It identifies the objective,
  issue acceptance criteria, dependencies, read/write/forbidden scope, context,
  and expected outputs. It describes WHAT to deliver, not HOW. Missing scope
  or contradictory boundaries block dispatch; the worker does not edit it.
- Before scheduling, Foreman MUST reject duplicate/missing references, cycles,
  invalid capacity, inconsistent worker identities, and unsubstantiated
  integration. It MUST reason over the recorded graph explicitly, not treat a
  recipe exit code as a readiness decision.
- Ready nodes are queued, have no blockers, and have integrated dependencies.
  Select by ascending priority then issue number, up to available capacity.
  Count every reserved or still-live worker, including blocked/waiting workers.
- The single active Foreman controller MUST persist a reservation before asking
  the host to create resources. Reconcile partial launches before retrying.
- Foreman owns node transitions: queued -> ready -> reserved -> running ->
  review-pending -> integrated, with blocked, failed, and cancelled exceptions.
  "Ready" is derived from current graph evidence, never a worker-written state.
  A worker completion is not an integrated node or a completed mission.
- For the enabled CLI/tmux adapter, use `.trees/issue-N`, worker/window `rpiv-N`,
  and a branch following the consuming project's convention. Reserve window
  zero of the owned `foreman` session for the controller. Preserve unrelated
  sessions, worktrees, branches, and user changes.
- Every Foreman-managed Copilot session MUST use `--yolo`, including the
  controller, issue-generator, workers, and resumed sessions. Enabling managed
  execution records approval once in the project profile; do not ask again for
  each tool or silently fall back to another mode. Use the thin `copilot-session`
  recipe or a project equivalent with the same flag and working-directory
  contract. No credentials or explicit host restrictions are bypassed.
- Foreman MUST review the exact delivered PR head against mission outcomes,
  issue ACs, the full diff, relevant documentation/architecture, and Verify's
  evidence. Missing or inconclusive evidence is not approval.
- Persist each review under `.foreman/reviews/<issue>/<review-id>.json` with
  PR identity, head SHA, round, decision, and concrete evidence. Publish a
  correlated PR comment so humans can see the findings, without relying on
  GitHub permitting a reviewer to formally approve their own PR.
- Reconcile persisted review IDs with PR comments and inbox commands after
  interruption. Reuse existing publications rather than duplicate feedback or
  consume another correction round for an identical delivery.
- Feedback MUST identify stable finding IDs, affected AC/outcome IDs, the
  expected versus observed behavior, evidence/file references, and `plan` or
  `implement` ownership. Foreman requests corrections, not worker-file edits.
- Send `review-feedback` to the same issue/worker/attempt and preserve its
  branch/worktree/PR. RPIV acknowledges, routes fixes, independently re-verifies,
  and reports the new PR head and each finding's disposition. A disputed
  finding is explicit, not silently dismissed.
- Foreman MUST re-read the current head before publishing `review-accepted`;
  any new commit invalidates the prior acceptance. No changes-requested,
  pending, or stale-head review may satisfy delivery/integration gates.
- Managed workers wait in Verify after PR delivery and remain reserved while
  feedback is possible. A stopped console is resumed for the same attempt,
  not replaced with a duplicate worker. Do not retire workers pending review.
- Bound automatic PR correction to `workers.max_review_rounds` (default 3)
  persisted across resumes. Exhaustion or unresolved disagreement requires a
  human decision; it never converts rejection into success.
- Pause/resume/cancel are agent decisions and typed messages, not forced edits
  to a worker's files. Wait for a safe-boundary acknowledgement before changing
  active scope or prerequisites.
- Status queries use the graph and observation cursor first; ask a live worker
  for status only if necessary. Detect a missing owned tmux window while the
  registry claims it is live; record the discrepancy and reconcile before
  retrying. Never infer success from terminal history or a vanished window.
- Run the configured integration verification over the integrated base only
  after every required node has integrated. Record its command, base commit,
  result, and top-level condition evidence; failed or unavailable integration
  verification keeps the mission incomplete.
- A Foreman-accepted PR does not satisfy a dependency until its integration is
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

`.foreman/contracts/issue-N-revision-R.json` is the immutable-for-an-attempt assignment
referenced by the registry and passed by absolute path in the worker bootstrap.
Foreman records its SHA-256 digest in the reservation; RPIV checks the digest
and issue criteria on launch and resume. A file with the same path/revision
and different contents is an error, not an updated assignment.
On a revised assignment, pause and acknowledge the affected worker, increment
the graph revision, then write a new version; never silently replace an active
worker's scope. For example:

```json
{
  "version": 1,
  "revision": 2,
  "issue": 21,
  "worker": "rpiv-21",
  "attempt": "unique-execution-id",
  "worktree": "/repo/.trees/issue-21",
  "title": "Refund API",
  "objective": "Deliver the issue's refund API outcome",
  "acceptance_criteria": [{"id": "AC-1", "text": "A refund can be created"}],
  "dependencies": [18],
  "scope": {"read": ["src/payments/**"], "write": ["src/payments/refunds/**", "tests/payments/refunds/**", "project/work-items/21-*/**"], "forbidden": ["src/auth/**"]},
  "context": {"specs": ["docs/payments.md"], "decisions": [], "contracts": []},
  "expected_outputs": ["implementation", "tests", "verification evidence"]
}
```

Paths are repository-relative globs; `forbidden` takes precedence over `write`.
The write scope must include the issue's RPIV artifact directory and any
global ADR/core-component files a Plan decision explicitly authorizes; adding
an unexpected global architecture artifact requires a paused scope revision.
Foreman compares the delivered PR's changed paths against the assignment and
escalates unexpected changes rather than silently accepting them. GitHub issue
criteria remain authoritative; an assignment cannot weaken or replace them.
Derive stable AC-1, AC-2, etc. in issue order before dispatch (ignoring whether
the issue checkbox is checked); RPIV Plan uses those same IDs.
The `revision`, `issue`, `worker`, `attempt`, and absolute `worktree` fields
must agree with the filename, reservation, and bootstrap. Changing the
assignment requires a new revision and a reconciled worker attempt; a worker
cannot silently switch contracts during resume.

The host adapter exposes primitive operations: `prepare`, `launch`, `inspect`,
`status`, `list`, `signal`, `wait`, `resume`, `retire`, `issues`, `review`, `review-comment`,
`delivery`, and `integration-checkout`. `review` returns stable-head PR metadata,
diff, discussions, and check results, not an acceptance decision. `review-comment` publishes the agent's
correlated review body. Its recipe
signatures and outputs are recorded in the profile. Launch receives
`ISSUE_NUMBER`, `WORKER_ID`, `ATTEMPT_ID`, `WORKTREE`, `FOREMAN_ROOT`,
`ASSIGNMENT_PATH`, and optional `RESUME` as the exact RPIV bootstrap fields.
The assignment path identifies the recorded digest; it does not grant workers
permission to alter their scope.

`send(worker, message)` creates a uniquely identified JSON command in
`.foreman/inbox/rpiv-N/<command-id>.json`, bound to issue/worker/attempt, then
optionally signals the configured transport. `receive(event)` reads immutable
RPIV events, compares identity/attempt/sequence with its persisted cursor, and
applies each event at most once. Messages are data, never shell input.

Typed command names `status`, `cancel`, `resume`, `clarify`, and `update` express
STATUS, STOP, CONTINUE, CLARIFY, and UPDATE respectively. Existing `pause`,
`refresh`, and PR review commands remain valid. `clarify` contains a question;
`update` contains information, not executable instructions. Workers answer
with `PROGRESS` (status), `NEEDS_DECISION` (question), `BLOCKED`, `FAILED`, or
`COMPLETED`, including a correlated command ID where applicable. Foreman
validates replies before moving the graph.

An enabled tmux adapter may provide `launch`, `inspect`, `status`, `signal`,
`retire`, and `list` with the root justfile's thin `tmux-worker-*` recipes.
No CLI keystroke injection or terminal scraping is needed for the protocol:
`signal` wakes a
reader, and the files carry the payload. Foreman can request cooperative
cancellation and retire a stopped window; it must not kill a running worker
as a substitute for its acknowledgement. The controller owns window 0.
The project maps `integration-checkout` to an ownership-checked operation
on its configured base checkout. It confirms the current branch and clean
tree, refreshes only that checkout after integration is proven, and returns
the exact revision for full verification. A fast-forward of the already merged
base is not an instruction to merge a PR.

Enabled CLI profiles use `workers.permission_mode: "yolo"`,
`workers.permission_approved: true`, and a positive `workers.max_review_rounds`.
Profile approval represents the user's explicit opt-in, not a value an agent
may invent. A disabled profile may describe the policy without approval.

Review messages extend the observability command schema with `review_id`,
`round`, `pr_number`, `pr_url`, `head_sha`, `decision`, and `findings`. They
remain controller-to-coordinator data; only RPIV dispatches correction stages.

### Expectations

| Failure | Owner | Recovery limit |
|---------|-------|----------------|
| Transient execution | Foreman | At most one restart after ownership reconciliation |
| Code/test/documentation validation | RPIV Implement | Existing correction cycle, then fail |
| Dependency blocker | Foreman | No blind retry; await integration or revise graph |
| Decomposition/scope | Foreman and Plan | Pause, revise issue/graph, rerun downstream |
| Architecture conflict | Plan | No override; ADR/core-component decision required |
| PR review findings | RPIV Plan or Implement, then Verify; Foreman re-reviews | Default 3 correction rounds, then escalate |
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
Delivered PR -> Foreman review -> feedback -> RPIV correction -> re-review
Accepted exact PR head -> confirmed integration -> dependency available
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
