# ADR-260906-foreman-control-plane: Foreman Control Plane

## Status

Accepted

## Context

RPIV delivers one issue. A product mission can span dependent issues, concurrent
workers, architectural constraints, and integration decisions. The repository
template needs a persistent engineering lead without expanding RPIV into a
project scheduler.

## Decision

Add an APS-managed Foreman agent above RPIV. Foreman owns mission understanding,
repository context, issue decomposition, a live dependency graph, scheduling,
recovery, and mission-level acceptance. Each issue still follows exactly
Research -> Plan -> Implement -> Verify. Validation and PR delivery are Verify
activities, not additional stages.

V1 represents work with GitHub Issues and runs independent Copilot CLI sessions
in `.trees/issue-<number>` worktrees. The dedicated tmux session `foreman` has a
control window at index zero and a named `rpiv-<number>` window per worker.
Independent CLI sessions avoid relying on nested subagent delegation: RPIV is
the primary coordinator in each worker session and its stages are leaf agents.

Repository context, graph, and worker registry live under `.foreman/`. Runtime
state is local and ignored by Git. RPIV independently exposes `state.json` and
an append-only event history beside its canonical work item. JSON files carry
messages; tmux notifications wake consumers. Terminal text is never parsed as
state and messages are never injected as shell input.

Root `justfile` recipes own operating commands. A standard-library Python
module implements data validation, atomic state publication, and deterministic
ready-set calculation; the Foreman agent makes product/coordination decisions.
No external graph framework, autonomous merge policy, or unattended permission
bypass is introduced.

## Alternatives

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|--------------|
| Expand RPIV into a mission agent | Fewer entrypoints | Mixes issue execution and mission ownership | Breaks the single-issue boundary |
| Launch subagents in one working tree | Simple startup | Concurrent changes and undocumented nested delegation | Insufficient isolation |
| Scrape tmux output or inject message keystrokes | Minimal transport | Ambiguous state; idle shells can execute text | Unsafe and not machine-readable |
| Adopt Herd/HERDR immediately | Potential richer coordination | No evaluated dependency or migration contract | Defer comparison; keep transport replaceable |
| Implement another issue tracker or UI now | Broader surface | Unnecessary V1 scope | GitHub and structured files suffice |

## Consequences

### Positive
- Strategic context survives worker and controller restarts.
- Workers remain independently usable and retain clear ownership.
- Dependency readiness and mission completion require integrated evidence.

### Negative
- V1 requires a POSIX environment, Python 3, tmux, Git, just, and Copilot CLI.
- Local runtime state must be retained or backed up to resume a mission.
- Interactive permission or product decisions can require human attention.

### Neutral
- Foreman does not merge PRs automatically.
- GitHub/Copilot authentication is required when running workers, not when
  editing this template or executing its inert local checks.

## Related Issues

- Direct repository-template update requested by the user; no GitHub issue.

## References

- [Foreman contract](../core-components/CORE-COMPONENT-260906-foreman-orchestration.md)
- [RPIV observability](../core-components/CORE-COMPONENT-260906-rpiv-observability.md)
- [APS CLI adapter](../../../.github/skills/agnostic-prompt-standard/platforms/copilot-cli/adaptor.md)
