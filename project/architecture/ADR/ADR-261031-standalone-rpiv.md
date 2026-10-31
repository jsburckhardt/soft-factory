# ADR-261031-standalone-rpiv: Standalone RPIV without Foreman or tmux

## Status

Accepted. Supersedes [ADR-260906-foreman-control-plane](ADR-260906-foreman-control-plane.md).

## Context

ADR-260906-foreman-control-plane added Foreman, a mission coordinator above
RPIV that scheduled isolated Copilot CLI workers in tmux windows. Its behavior
was specified as prompt rules plus file-based state (mission graph, worker
registry, versioned assignments, inbox commands, immutable RPIV lifecycle
events) that agents had to keep consistent by hand. Worker execution was
disabled by default, required a per-project profile and fourteen host
operations, and never ran end to end. Its managed-mode rules also made
standalone RPIV heavier. tmux was only needed as Foreman's worker transport
and for a shared devcontainer session.

## Decision

- Remove the Foreman agent, its documentation, `.foreman/` data, contract test,
  and its tmux/integration/review host recipes.
- Retire CORE-COMPONENT-260906-foreman-orchestration and
  CORE-COMPONENT-260906-rpiv-observability. RPIV no longer writes `state.json`
  or lifecycle event files; the markdown work-item artifacts are its record.
- RPIV runs standalone: Research -> Plan -> Implement -> Verify for one issue,
  with Verify delivering and updating a single PR.
- Remove tmux from the devcontainer (feature, configuration, attach and
  post-start scripts) and from all recipes.
- Multi-issue coordination is out of scope here; a later ADR may introduce a
  simpler coordinator built on native Copilot CLI capabilities.

## Alternatives

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|--------------|
| Keep Foreman disabled by default | No deletion | Dead rules keep burdening every agent and run | Not used, never worked end to end |
| Restore the Python scheduler | Enforced state | Imposes a runtime on every consumer, still tmux-bound | Same complexity, wrong layer |

## Consequences

### Positive
- Smaller, standalone agent instructions that weaker models can follow.
- Devcontainer no longer installs or configures tmux.

### Negative
- No mission-level coordination of parallel issues until a replacement exists.

### Neutral
- Historical work item 42 remains as a record of the removed design.

## Related Issues

- [#44](https://github.com/jsburckhardt/soft-factory/issues/44)

## References

- [ADR-260906-foreman-control-plane](ADR-260906-foreman-control-plane.md)
