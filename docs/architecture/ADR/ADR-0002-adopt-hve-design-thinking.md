# ADR-0002: Adopt HVE Design Thinking as an Optional Pre-Research Stage

## Status

Accepted

## Context

The soft-factory RPIV pipeline (Research → Plan → Implement → Verify) assumes that the problem to be solved is sufficiently understood at the time a workitem enters the Research stage. However, many real-world workitems begin with unclear requirements, conflicting stakeholder needs, or ambiguity about user adoption. The [microsoft/hve-core](https://github.com/microsoft/hve-core) repository contains a mature Design Thinking (DT) framework — a three-space, nine-method model (Problem Space → Solution Space → Validation Space) — that provides structured human-centered discovery for exactly these situations.

The question is: should soft-factory adopt this framework, and if so, how does it integrate with the mandatory RPIV pipeline without breaking the four-stage contract?

Key considerations:

- The RPIV pipeline is mandatory for all work — no stage may be skipped.
- DT is valuable only when requirements are unclear or stakeholder alignment is needed.
- The hve-core framework uses "RPI" (Research, Plan, Implement) terminology; soft-factory uses "RPIV" (Research, Plan, Implement, **Verify**). Verify ≠ Review: soft-factory's Verify stage runs the test suite, creates commits, and opens a PR — it does not perform coaching quality assessment.
- DT sessions produce handoff artifacts with confidence markers (`validated/assumed/unknown/conflicting`) that the Research agent must interpret.
- The framework has three natural exit points (after Problem Space, Solution Space, or Validation Space), each producing progressively more refined input for the Research stage.

## Decision

Adopt the HVE Design Thinking framework as an **optional pre-Research activity** in the soft-factory pipeline. Specifically:

1. **DT is optional, not mandatory.** The four-stage RPIV pipeline remains the only mandatory workflow. DT is a discoverable upstream activity that feeds into RPIV — it does not replace or extend the pipeline.

2. **Trigger conditions for DT engagement:**
   - Requirements are unclear: stakeholders describe solutions, not problems.
   - Multiple stakeholders disagree or have conflicting needs.
   - The problem spans organizational boundaries, user roles, or technical systems.
   - User adoption is a critical success factor.

3. **When to skip DT and go straight to RPIV:**
   - Requirements are well understood and agreed upon.
   - The task is purely technical with no user-facing ambiguity.
   - A prior DT session already produced a validated handoff artifact for this scope.

4. **All DT exits enter RPIV at the Research stage.** Regardless of which DT exit point is reached (Exit 1 after Problem Space, Exit 2 after Solution Space, Exit 3 after Validation Space), the handoff always goes to the `research` agent. The research agent adjusts its scope based on the exit point:

   | DT Exit Point | DT Output | Research Agent Behavior |
   |---------------|-----------|------------------------|
   | Exit 1 (Methods 1–3) | Validated problem statement | Scopes technical research around stakeholder-validated needs; treats `assumed` items as verification targets, `unknown` items as primary research targets |
   | Exit 2 (Methods 4–6) | Validated concept + constraints | Narrows research scope to tested directions; resolves constraint gaps; assesses feasibility |
   | Exit 3 (Methods 7–9) | Functional spec + test evidence | Investigates production readiness, scaling gaps, integration concerns; research scope is significantly narrowed |

5. **Handoff contract.** The DT Coach agent produces a structured handoff artifact (`dt-handoff.md`) that includes:
   - The DT exit point reached (1, 2, or 3).
   - A summary of findings tagged with confidence markers (`validated/assumed/unknown/conflicting`).
   - Explicit scope boundaries for the Research stage.
   - Unresolved questions and known risks.

6. **Return path (RPIV → DT).** The `research` agent may recommend returning to DT coaching when:
   - The problem statement from DT needs revision due to new technical evidence.
   - Fundamental DT assumptions are invalidated during research.
   - Unrepresented stakeholder groups emerge during technical investigation.
   This return is recorded in the research brief as a `conflicting` confidence marker escalation.

7. **Verify ≠ Review.** soft-factory's Verify stage runs tests and opens a PR — it does not perform DT-style coaching quality assessment. DT artifact quality is validated within pipeline stages (Research validates handoff completeness; Plan validates actionability), not in a dedicated review stage.

8. **Content strategy: Selective extract + adapt (Option C).** Framework overview, integration contract, confidence markers, and the DT Coach agent are extracted and adapted to soft-factory conventions. The nine method deep-dives are referenced from hve-core (not copied) to avoid content drift.

## Alternatives

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|--------------|
| No DT at all | Simplest; no integration work | No structured discovery for ambiguous requirements; users left to ad-hoc methods | Does not address the core problem of unclear requirements entering the pipeline |
| DT as a mandatory fifth stage | Ensures every workitem gets discovery | Adds overhead to well-understood work; violates the RPIV four-stage contract | Breaks pipeline integrity; most workitems do not need DT |
| DT integrated into the Research agent's own instructions | No separate agent; single entry point | Overloads the Research agent; DT coaching philosophy conflicts with technical research posture | Mixing coaching and research creates role confusion; agent instructions become unwieldy |
| Full extract of all hve-core DT docs (Option A) | Complete, self-contained | Drift risk; duplicates 3,000+ lines; no attribution | High maintenance burden; method guides update frequently in hve-core |

## Consequences

### Positive
- Workitems with unclear requirements get structured discovery before entering the pipeline.
- The pipeline's four-stage integrity is preserved — DT is additive, not structural.
- Confidence markers from DT handoffs improve downstream planning accuracy.
- The return path (RPIV → DT) allows graceful handling of invalidated assumptions.

### Negative
- Adds a new agent (`dt-coach`) and documentation set to maintain.
- Teams must learn when to invoke DT vs. when to skip it (trigger conditions help but require judgment).
- Referenced hve-core method guides may change; pinned links mitigate but do not eliminate this risk.

### Neutral
- The DT Coach agent is a new role but follows existing agent conventions (file location, AGENTS.md entry, guardrails pattern).
- Existing workitems that never use DT are unaffected — no changes to their workflow.

## Related Workitems

- [WI-0002-design-thinking-integration](../../workitems/WI-0002-design-thinking-integration/)

## References

- [microsoft/hve-core Design Thinking Guide](https://github.com/microsoft/hve-core/blob/main/docs/design-thinking/README.md)
- [microsoft/hve-core DT-to-RPI Integration](https://github.com/microsoft/hve-core/blob/main/docs/design-thinking/dt-rpi-integration.md)
- [microsoft/hve-core Why Design Thinking](https://github.com/microsoft/hve-core/blob/main/docs/design-thinking/why-design-thinking.md)
- [microsoft/hve-core DT Coach agent](https://github.com/microsoft/hve-core/blob/main/.github/agents/design-thinking/dt-coach.agent.md)
