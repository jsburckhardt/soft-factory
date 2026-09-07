# ADR-260906-foreman-control-plane: Foreman Control Plane

## Status

Accepted

## Context

RPIV delivers one issue. A product mission can span dependent issues,
concurrent workers, and integration decisions. Soft Factory is a template for
many projects, not an application that should impose an orchestration service
or implementation language on every consumer.

## Decision

Foreman is an APS agent above RPIV. It owns repository understanding, mission
decomposition, the work graph, readiness and capacity decisions, worker
coordination, recovery, and mission completion. Those behaviors stay in its
prompt and shared contracts, not in a Python scheduler or equivalent runtime.

The template ships the agents, contracts, documentation, and a minimal root
`justfile`. When a project starts, bootstrap selects its actual stack and
commands with the user; onboarding discovers and preserves an existing stack.
Both can record a project profile and, with explicit approval, add thin
worker-operation recipes appropriate to that project. Foreman can understand
and plan a mission without enabling worker execution.

V1 uses GitHub Issues as deliverables. A project opting into the Copilot
CLI/tmux adapter uses one `foreman` session, `rpiv-N` worker identities, and
isolated `.trees/issue-N` worktrees. RPIV is the primary coordinator in each
worker CLI session; its four stages are leaf agents. Research -> Plan ->
Implement -> Verify is unchanged.

The agent owns `.foreman/mission.json` and `.foreman/registry.json` as data.
The consuming project's non-secret `.foreman/project.json` records configured
commands and capabilities. RPIV writes a current state snapshot and immutable
event files using its host file tools. Typed message files carry communication;
an enabled tmux adapter may signal that new data is available. Notifications
and terminal output are not authoritative state.

Command recipes perform concrete operations such as creating a worktree,
opening a console, launching Copilot, and inspecting GitHub delivery. They do
not parse the graph, calculate readiness, mutate the mission, or decide
acceptance. A project may later adopt a small persistence helper if a proven
need justifies it through its own architecture process.

This amends the initial implementation choice: remove the Python control
runtime and its dependency rather than translate that runtime into Bash or
another language.

## Alternatives

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|--------------|
| Ship a Python scheduler and state engine | Deterministic mechanics | Imposes a runtime and splits APS ownership | Too much infrastructure for a reusable template |
| Port the same engine to shell or JavaScript | Different dependency profile | Still duplicates agent orchestration | Does not solve the ownership problem |
| Expand RPIV into a mission agent | Fewer entrypoints | Mixes issue delivery and project coordination | Breaks the issue boundary |
| Enable workers when the template is cloned | Immediate activity | No project-specific commands, scope, or permission agreement | Unsafe default |
| Require a different tracker or Herd/HERDR | Potential richer operations | Unevaluated dependency and integration cost | Defer; keep contracts transport-independent |

## Consequences

### Positive
- Consumers choose their own language, package manager, and operating commands.
- Foreman behavior has one owner: the APS agent.
- Repositories may use standalone RPIV or enable Foreman workers when ready.

### Negative
- Prompt-level reconciliation is not an automatic transactional storage engine.
- Worker execution needs explicitly configured project recipes and permissions.
- Interrupted or inconsistent data requires reconciliation, not guessed success.

### Neutral
- Foreman does not automatically merge PRs, delete worktrees, or bypass permissions.
- GitHub and Copilot access are required for the operations that use them, not
  for editing the template or recording local context.

## Related Issues

- Direct user-requested template update and simplification; no separate issue.

## References

- [Foreman contract](../core-components/CORE-COMPONENT-260906-foreman-orchestration.md)
- [RPIV observability](../core-components/CORE-COMPONENT-260906-rpiv-observability.md)
- [Project command interface](../core-components/CORE-COMPONENT-260806-project-command-interface.md)
