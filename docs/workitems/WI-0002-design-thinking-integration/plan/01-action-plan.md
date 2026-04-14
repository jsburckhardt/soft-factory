# Action Plan: Design Thinking Integration

## Feature
- **ID:** WI-0002-design-thinking-integration
- **Research Brief:** docs/workitems/WI-0002-design-thinking-integration/research/00-research.md

## ADRs Created
- [ADR-0002: Adopt HVE Design Thinking as an Optional Pre-Research Stage](../../../architecture/ADR/ADR-0002-adopt-hve-design-thinking.md) — Defines DT as optional pre-Research activity, trigger conditions, exit-point-to-Research mapping, handoff contract, Verify≠Review distinction, and content strategy (Option C: selective extract + adapt).
- [ADR-0003: Hybrid Artifact Storage for Design Thinking Sessions](../../../architecture/ADR/ADR-0003-dt-artifact-storage.md) — Separates transient session state (`.copilot-tracking/dt/<WI-ID>/`) from durable handoff artifacts (`docs/workitems/<WI-ID>/artifacts/dt-handoff.md`).

## Core-Components Created
- [CORE-COMPONENT-0002: Confidence Markers](../../../architecture/core-components/CORE-COMPONENT-0002-confidence-markers.md) — Defines the `validated/assumed/unknown/conflicting` schema, per-agent behavioral expectations, inline and table syntax, and enforcement mechanisms.

## Implementation Tasks

The implementation follows the research brief's prescribed extraction order, with architecture artifacts (ADRs + core-component) already committed in the Plan stage. The remaining tasks are documentation extraction/adaptation and agent creation:

1. **Task 1: Create DT README** — Extract and adapt the DT framework overview from hve-core as `docs/design-thinking/README.md`. This is the navigation hub and entry point for all DT documentation.

2. **Task 2: Create why-design-thinking.md** — Extract and adapt `why-design-thinking.md` with RPIV terminology. Defines trigger conditions and skip conditions.

3. **Task 3: Create dt-coach.md guide** — Extract and adapt the DT Coach reference guide with soft-factory agent references and pipeline terminology.

4. **Task 4: Create dt-rpiv-integration.md** — Extract and adapt the DT-to-RPIV integration contract. Full rename from `dt-rpi-integration.md`; adapt all agent names, pipeline labels, artifact paths, and Verify≠Review distinction.

5. **Task 5: Create tutorial-handoff-to-rpiv.md** — Extract and adapt the handoff tutorial with soft-factory agent invocation patterns and workitem paths.

6. **Task 6: Create dt-rpiv-mapping.md** — New file (no hve-core equivalent). Authoritative RPIV-specific mapping: terminology translation table, trigger conditions, exit-point contract with examples, return-path protocol.

7. **Task 7: Create DT Coach agent** — Adapt `dt-coach.agent.md` for soft-factory. Self-contained (no external `.github/instructions/` dependencies). Embed coaching philosophy, method list, state management protocol. Use paths from ADR-0003.

8. **Task 8: Update AGENTS.md** — Add `dt-coach` entry to the AGENTS constants block with file, purpose, tools, read_paths, write_paths, and guardrails. Follow existing agent entry format exactly.

9. **Task 9: Cross-reference and link validation** — Verify all internal links between DT docs, agent files, and architecture artifacts. Ensure zero broken links and zero "RPI" references without "V" suffix.
