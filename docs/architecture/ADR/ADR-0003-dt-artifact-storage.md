# ADR-0003: Hybrid Artifact Storage for Design Thinking Sessions

## Status

Accepted

## Context

The HVE Design Thinking framework (adopted in ADR-0002) produces two categories of artifacts during a DT session:

1. **Session state** — transient coaching state (current method, progress, scratchpad notes) managed by the DT Coach agent during an active session. This state is updated frequently and may be discarded after the session completes.
2. **Handoff artifact** — the durable output of a completed DT exit point, containing the structured findings, confidence markers, and scope boundaries that the Research agent needs to begin RPIV work.

The hve-core convention stores all DT artifacts in `.copilot-tracking/dt/{project-slug}/coaching-state.md` — a hidden directory that is typically gitignored for transient agent state. soft-factory's convention stores durable workitem artifacts in `docs/workitems/<WI-ID>/`, which is committed to the repository and visible in documentation.

The question is: where should each category of DT artifact live in soft-factory?

Key constraints:

- Session state is transient and updated frequently — it should not pollute the commit history.
- The handoff artifact is a durable input to the Research stage — it must be committed, traceable, and associated with a specific workitem.
- The DT Coach agent needs a predictable path for session state management.
- The Research agent needs a predictable path for reading the handoff artifact.

## Decision

Adopt a **hybrid storage convention** that separates transient session state from durable handoff artifacts:

1. **Session state** is stored in `.copilot-tracking/dt/<WI-ID>/coaching-state.md` during active DT work.
   - This path follows the hve-core convention (adapted to use `<WI-ID>` instead of `{project-slug}`).
   - The `.copilot-tracking/` directory should be gitignored — session state is not committed.
   - The DT Coach agent owns this file and updates it as the session progresses.

2. **Handoff artifact** is committed to `docs/workitems/<WI-ID>/artifacts/dt-handoff.md` when DT reaches an exit point.
   - This path follows soft-factory's workitem convention — artifacts are committed and traceable.
   - The DT Coach agent produces this file as the final step before handing off to the Research agent.
   - The Research agent reads this file as its primary DT input.

3. **Path contract:**

   | Artifact Type | Path | Committed? | Owner |
   |---------------|------|------------|-------|
   | Session state | `.copilot-tracking/dt/<WI-ID>/coaching-state.md` | No (gitignored) | DT Coach agent |
   | Handoff artifact | `docs/workitems/<WI-ID>/artifacts/dt-handoff.md` | Yes | DT Coach agent (write), Research agent (read) |

4. **Lifecycle:**
   - When the DT Coach agent starts a session, it creates or resumes `.copilot-tracking/dt/<WI-ID>/coaching-state.md`.
   - When the session reaches a DT exit point, the DT Coach agent writes `docs/workitems/<WI-ID>/artifacts/dt-handoff.md`.
   - The transient session state in `.copilot-tracking/` may be cleaned up after the handoff is complete.
   - If DT is re-entered from RPIV (return path), the session state is re-created in `.copilot-tracking/`.

## Alternatives

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|--------------|
| hve-core convention only (`.copilot-tracking/dt/` for everything) | Simple; one location | Handoff artifacts are not committed; not traceable to workitem; Research agent has no durable input | Breaks soft-factory's artifact traceability requirement |
| Workitem subfolder only (`docs/workitems/<WI-ID>/dt-artifacts/`) | Everything committed; fully traceable | Transient session state pollutes commit history; frequent updates create noise | Session state updates are too frequent for version control |
| Separate `docs/design-thinking/sessions/` directory | DT-specific namespace | Not associated with workitems; breaks the `<WI-ID>`-based organization | Violates the workitem-centric artifact convention |

## Consequences

### Positive
- Session state does not pollute the git history — only the final handoff artifact is committed.
- Handoff artifacts are traceable to their workitem and visible in the documentation tree.
- The DT Coach agent has a predictable, consistent path for session management across all workitems.
- The Research agent has a predictable, committed path for reading DT output.

### Negative
- Two artifact locations must be understood by agents and documented clearly.
- `.copilot-tracking/` must be gitignored — if it is not, session state will be committed unintentionally.

### Neutral
- The hybrid approach is consistent with how other tools (e.g., IDE state files, agent caches) separate transient state from committed artifacts.
- Existing workitems without DT sessions are unaffected — the `artifacts/` directory already exists in the workitem scaffold.

## Related Workitems

- [WI-0002-design-thinking-integration](../../workitems/WI-0002-design-thinking-integration/)

## References

- [ADR-0002: Adopt HVE Design Thinking](ADR-0002-adopt-hve-design-thinking.md)
- [microsoft/hve-core DT Coach agent](https://github.com/microsoft/hve-core/blob/main/.github/agents/design-thinking/dt-coach.agent.md)
