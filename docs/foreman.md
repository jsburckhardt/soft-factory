# Foreman: an APS agent for each consuming project

**Foreman is the agent, not a Python application.** It understands a mission,
maintains repository context and an issue graph, decides what can run, and
coordinates RPIV outcomes. The template supplies that workflow and its
contracts; each consuming project supplies its actual tools and commands.

| Owner | Responsibility |
|-------|----------------|
| Foreman APS agent | Context, mission, decomposition, graph, scheduling, recovery, outcomes |
| RPIV agents | Deliver one issue through Research -> Plan -> Implement -> Verify |
| Project `justfile` | Thin, explicitly configured operating commands |
| JSON/Markdown files | Persistent data read and written through agent file tools |

There is no Foreman scheduler package, daemon, state CLI, or template-wide
language dependency. The installed APS framework remains revision 1.2.2.

## When a project starts

1. **Choose the entrypoint.** Use `bootstrap` for a new project or `onboard-repo`
   for an existing application. Inherited Foreman ADRs and agent files do not
   mean the consuming project has already been initialized.
2. **Establish the actual environment.** Bootstrap gathers the product goal,
   language, framework, package manager, and development conventions. Onboarding
   discovers those from the existing source and documentation.
3. **Confirm project commands.** Generate or preserve setup, run, build, and
   applicable quality commands in the root justfile. `verify-focused` and
   `verify` must run the consuming project's real checks, not merely the
   template's starter whitespace commands.
4. **Choose whether to enable Foreman workers.** The default is disabled.
   Enabling them requires approval of the host adapter, thin operation recipes,
   capacity, repository/base branch, and permission mode.
5. **Record capabilities.** Write the non-secret `.foreman/project.json` profile
   and completed-initialization marker after setup succeeds. Keep product
   architecture decisions in the usual global ADR/core-component documents.
6. **Start work.** Use standalone RPIV for one issue, or give Foreman a PRD or
   vague product direction. No mission, worktree, or worker starts just because
   a project was created from the template.

For example, one consumer can use Go modules and Go commands; another can use
Node and pnpm; a third can choose Python and uv. None needs Python **for
Foreman**. Development-container features are selected for the project itself.

An already-initialized project can request `bootstrap` in explicit
`foreman-setup` mode to configure only the profile and approved host recipes.
That mode preserves the existing application and does not rerun scaffolding,
create a first issue, or launch workers.

## Project profile

This is an example of what initialization writes for a Go consumer, not a
configuration shipped pre-enabled by this template:

```json
{
  "version": 1,
  "initialization": {"complete": true, "mode": "bootstrap"},
  "project": "example-service",
  "repository": "example/example-service",
  "base_ref": "origin/main",
  "stack": {"languages": ["go"], "package_manager": "go"},
  "recipes": {
    "setup": "setup",
    "verify_focused": "verify-focused",
    "verify": "verify"
  },
  "workers": {
    "enabled": false,
    "adapter": "copilot-cli-tmux",
    "max_workers": 4,
    "permission_mode": "configured",
    "session": "foreman",
    "worktree_root": ".trees",
    "operations": {}
  }
}
```

The recipe names must exist in that project's justfile. An enabled operation
entry records its recipe, ordered argument names, and expected output.
Configuration contains data, not raw shell fragments or credentials.
Missing configuration means worker execution is unavailable; Foreman may still
understand the mission and retain its context.

## Thin host operations, not another scheduler

When workers are enabled, bootstrap/onboarding configures these operations
using the chosen host's existing tools. They are **not implemented by a bundled
Foreman runtime**, and no particular recipe names beyond the profile mappings
are assumed by the agent.

| Operation | Primitive responsibility |
|-----------|--------------------------|
| `prepare` | Create or explicitly reuse the assigned issue branch/worktree from the agreed base |
| `launch` | Start the named Copilot CLI session in that worktree using a bootstrap file |
| `inspect` | Report actual worktree, branch, console, and process identities |
| `signal`, `wait` | Notify a reader and wait for a bounded interval; carry no executable message text |
| `resume` | Continue an explicitly paused, matching attempt without overwriting work |
| `retire` | Close an owned, stopped console; do not remove its worktree or branch |
| `issues` | Run a primary issue-generator session and collect its correlated results |
| `delivery` | Obtain GitHub PR and Git ancestry evidence for the configured repository/base |

Recipes must quote input data, surface errors, protect existing resources, and
avoid implicit permission escalation. They must not parse the mission graph,
calculate readiness, manage a second worker registry, or decide acceptance.
Foreman performs those responsibilities in APS before and after each operation.

For the CLI/tmux adapter, the expected layout is:

```text
tmux session: foreman
  0: foreman
  1: rpiv-21 -> .trees/issue-21 -> primary Copilot CLI -> RPIV
  2: rpiv-22 -> .trees/issue-22 -> primary Copilot CLI -> RPIV
```

Use the project's branch naming convention rather than an imposed application
branch name. The dedicated `foreman` session does not commandeer the
devcontainer's existing shared `soft-factory` session/socket.

Normal configured CLI permissions remain in force. `--yolo` is never inferred
from a request to deliver a feature; it requires explicit approval and an
observable launch mode. The profile maps a bounded worker process and its
inputs; RPIV is a primary coordinator and its stages are leaf workers, avoiding
undocumented nested delegation.

## Persistent context and graph

Foreman maintains `.foreman/context/{vision,repository,architecture,constraints}.md`
with source paths, observed commit/date, uncertainties, and refresh triggers.
Its strategic context outlives individual work items.

`.foreman/mission.json` records mission identity, objective, observable
conditions, assumptions, pause state, graph revision/reason, and issue nodes.
Nodes include `issue`, `depends_on`, `outcomes`, `priority`, `status`, and
`blockers`; optional `parent` is organizational, not a delivery dependency.

The agent checks references and cycles and computes the ready set itself.
Queued, unblocked nodes whose prerequisites are integrated are ordered by
priority then issue number, within the agreed capacity. Every reserved or
still-live worker counts, including blocked/waiting workers.

`.foreman/registry.json` is the agent's resource ledger. It records issue,
worker, attempt, branch, worktree, console, reservation, and launch outcome.
There is one active controller. It records a reservation before launch and
reconciles partial failures rather than creating duplicate workers.

New deliverables pass through issue-generator and rubber-duck review.
`.foreman/issue-request.json` carries request/mission IDs and candidate IDs,
problem descriptions, and outcome links. `.foreman/issue-result.json` preserves
created/reused issue identities, review dispositions, and partial failures.
Foreman does not combine an entire mission into one oversized issue or repeat
an uncertain creation without checking the correlation.

## RPIV state and communication

Research resolves the stable work-item directory before initializing state:

```text
project/work-items/21-add-organizations/
  state.json
  events/<attempt>/000000000001.json
  events/<attempt>/000000000002.json
  research/
  plan/
  implementation/
  verify/
```

Research initializes the first event on the coordinator's behalf; the
coordinator is the single writer thereafter. It creates one immutable JSON
event with host file tools, reads it back, then updates `state.json`. No
language-specific state command is required. The
[observability contract](../project/architecture/core-components/CORE-COMPONENT-260906-rpiv-observability.md)
defines fields, transitions, replay, interruption recovery, and error ownership.

Managed bootstrap inputs are `ISSUE_NUMBER`, `WORKER_ID`, `ATTEMPT_ID`,
`WORKTREE`, `FOREMAN_ROOT`, and optional `RESUME`. Standalone RPIV uses the
current checkout and the same state/event protocol without a Foreman profile.

`send(worker, message)` creates a uniquely identified command file under
`.foreman/inbox/rpiv-N/`, bound to issue/worker/attempt. The optional transport
signal is only a wakeup hint. `receive(event)` reads event files and advances
the agent's persisted cursor only after checking identity and sequence.
Commands are `pause`, `resume`, `cancel`, and `refresh`; workers acknowledge IDs
in `PROGRESS` evidence at safe stage boundaries. Messages are never shell input.

Immutable events preserve history, but this is not an automatic transactional
storage engine. A malformed event, interrupted snapshot update, or identity
conflict requires explicit reconciliation. Earlier experimental `events.jsonl`
files are not silently converted or discarded.

## Delivery, recovery, and completion

RPIV completion means Verify delivered an accepted PR. Foreman independently
requires merged/integrated prerequisite evidence available in the dependent
worker's base. Neither an open PR nor a process exit satisfies that gate.

Worker findings can cause new reviewed nodes, graph revisions, or cooperative
pauses. Scope and architecture corrections return to Plan; code/documentation
corrections return to Implement. Transient failures have at most one reconciled
restart; dependency and human decisions do not trigger blind retries.

After all relevant work is integrated, Foreman re-evaluates each original
mission condition. Missing or inconclusive outcome evidence keeps the mission
incomplete. It does not auto-merge PRs or remove worktrees.

## Template versus project files

The profile is committed, non-secret project configuration. Context, mission,
registry, inbox, and work-item runtime files are local and Git-ignored.
Application docs and human-readable RPIV artifacts remain tracked.

The starter justfile contains generic validation entrypoints and small safe
GitHub publication wrappers. Project initialization replaces starter validation
with actual stack-specific commands and adds worker primitives only on opt-in.
If stronger persistence or another transport later becomes necessary, adopt it
in the consuming project's architecture rather than impose it on every template
consumer.
