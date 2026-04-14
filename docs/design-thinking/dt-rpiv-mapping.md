# DT-RPIV Mapping

> Authoritative reference for Design Thinking ↔ RPIV pipeline terminology, contracts, and protocols in soft-factory.

This document is the single source of truth for how Design Thinking maps to the RPIV pipeline. It translates hve-core conventions to soft-factory conventions and defines the contracts governing their interaction.

## Terminology Translation

The [microsoft/hve-core](https://github.com/microsoft/hve-core) framework uses different terminology than soft-factory. This table provides the authoritative mapping:

### Agent Names

The hve-core framework prefixes role names with "Task" (e.g., the researcher role is called "Task + Researcher"). soft-factory uses simple agent names without the "Task" prefix:

| hve-core Role | soft-factory Agent | Agent File |
|---------------|-------------------|------------|
| Researcher | `research` agent | `.github/agents/research.agent.md` |
| Planner | `planner` agent | `.github/agents/planner.agent.md` |
| Implementor | `implementer` agent | `.github/agents/implementer.agent.md` |
| Reviewer | `verifier` agent | `.github/agents/verifier.agent.md` |
| DT Coach | `dt-coach` agent | `.github/agents/dt-coach.agent.md` |

### Pipeline and Concept Names

| hve-core Term | soft-factory Term | Notes |
|---------------|-------------------|-------|
| Three-stage pipeline (Research, Plan, Implement) | RPIV Pipeline (Research, Plan, Implement, Verify) | soft-factory adds a Verify stage (test, commit, PR) |
| `dt-rpi-integration.md` | `dt-rpiv-integration.md` | Filename updated to reflect RPIV |
| `tutorial-handoff-to-rpi.md` | `tutorial-handoff-to-rpiv.md` | Filename updated to reflect RPIV |
| Project slug (hve-core uses curly-brace placeholders) | Workitem ID / `<WI-ID>` | e.g., `WI-0042-delivery-tracking` |
| DT session artifacts | Session state + Handoff artifact | Split per [ADR-0003](../architecture/ADR/ADR-0003-dt-artifact-storage.md) |
| Session tracking (hve-core: single directory with project slug) | `.copilot-tracking/dt/<WI-ID>/` | Transient; gitignored |
| (no equivalent) | `docs/workitems/<WI-ID>/artifacts/dt-handoff.md` | Durable; committed |

## Trigger Conditions for DT

Per [ADR-0002](../architecture/ADR/ADR-0002-adopt-hve-design-thinking.md), DT is triggered when any of these conditions are present:

### When to Use DT

| # | Condition | Signal |
|---|-----------|--------|
| 1 | Requirements are unclear | Stakeholders describe solutions, not problems |
| 2 | Stakeholder conflict | Multiple stakeholders disagree on priorities or success criteria |
| 3 | Cross-boundary problem | Problem spans organizational boundaries, user roles, or technical systems |
| 4 | User adoption is critical | Success depends on users changing their behavior |

### When to Skip DT

| # | Condition | Signal |
|---|-----------|--------|
| 1 | Requirements are well understood | Problem and solution are agreed upon with clear acceptance criteria |
| 2 | Purely technical task | Refactoring, dependency upgrade, bug fix — no user-facing ambiguity |
| 3 | Prior DT session exists | A validated handoff artifact already covers this scope |

## Exit Point Contracts

Each exit point defines what DT produces and how the Research agent consumes it.

### Exit Point 1: Problem Statement Complete

**Trigger:** Methods 1–3 complete. Problem is framed, stakeholders are aligned.

**Contract:**

| Field | Value |
|-------|-------|
| DT methods completed | 1 (Scope Conversations), 2 (Observations & Interviews), 3 (Problem Framing) |
| Minimum handoff content | Validated problem statement, stakeholder map, "How Might We" questions |
| Confidence markers required | Yes — on all findings |
| Research scope | Broad — explore solution approaches, validate needs technically |
| Handoff artifact path | `docs/workitems/<WI-ID>/artifacts/dt-handoff.md` |

**Concrete Example:**

> **Workitem:** WI-0015-employee-onboarding
>
> **DT finding:** "New employees take 3 weeks to become productive because onboarding materials are scattered across 7 different systems" `[validated]` — confirmed via interviews with 12 recent hires.
>
> **Research agent action:** Investigate the 7 systems, assess integration feasibility, explore consolidation approaches. The problem statement is trusted (`validated`); research focuses on solution space.

### Exit Point 2: Concept Validated

**Trigger:** Methods 1–6 complete. Solution concepts have been tested with users.

**Contract:**

| Field | Value |
|-------|-------|
| DT methods completed | 1–6 (through Concept Testing) |
| Minimum handoff content | Everything from Exit 1, plus: tested concepts, assumption map with results, constraint list |
| Confidence markers required | Yes — on all findings and test results |
| Research scope | Medium — focus on validated concept direction, resolve constraints |
| Handoff artifact path | `docs/workitems/<WI-ID>/artifacts/dt-handoff.md` |

**Concrete Example:**

> **Workitem:** WI-0023-patient-scheduling
>
> **DT finding:** "Tested a unified scheduling concept with 8 clinic staff. Staff strongly preferred a single-view calendar over the current 3-system workflow" `[validated]`. "Calendar should support drag-and-drop rescheduling" `[assumed]` — staff mentioned it but it wasn't tested directly.
>
> **Research agent action:** Investigate calendar UI frameworks that support drag-and-drop. The single-view approach is trusted (`validated`); drag-and-drop is a verification target (`assumed`). Don't re-investigate the 3-system problem — it's been validated.

### Exit Point 3: Implementation Spec Ready

**Trigger:** Methods 1–9 complete. Functional prototype tested, implementation spec written.

**Contract:**

| Field | Value |
|-------|-------|
| DT methods completed | 1–9 (through Implementation Spec) |
| Minimum handoff content | Everything from Exit 2, plus: functional specification, user testing evidence, implementation constraints |
| Confidence markers required | Yes — on all findings, test results, and spec items |
| Research scope | Narrow — production readiness, scaling, integration concerns |
| Handoff artifact path | `docs/workitems/<WI-ID>/artifacts/dt-handoff.md` |

**Concrete Example:**

> **Workitem:** WI-0031-warehouse-automation
>
> **DT finding:** "Prototype barcode scanning workflow tested with 15 warehouse workers across 3 shifts. Task completion time reduced from 45s to 12s" `[validated]`. "System must handle 500+ scans/hour during peak" `[assumed]` — based on current volume data, not stress-tested. "Integration with legacy WMS via REST API" `[unknown]` — WMS API docs not available.
>
> **Research agent action:** Focus narrowly on production concerns. Verify the 500 scans/hour requirement through load analysis. Investigate WMS API integration (the primary `unknown`). The scanning workflow itself is trusted.

## Return Path Protocol

When the `research` agent discovers that DT assumptions need revision, the RPIV pipeline returns to DT coaching.

### Return Conditions

| Condition | Example | Return Target |
|-----------|---------|---------------|
| Problem statement needs revision | Research reveals the problem is fundamentally different from what DT concluded | Method 3 (Problem Framing) |
| Core assumptions invalidated | Technical investigation proves a key DT assumption wrong | Method 5 (Assumption Mapping) |
| Missing stakeholders discovered | Research identifies affected user groups not included in DT | Method 1 (Scope Conversations) |

### Return Process

1. The `research` agent marks the affected finding as `conflicting` in its research brief.
2. The `research` agent documents the reason for return and recommends a specific DT method to revisit.
3. The `dt-coach` agent resumes the session, reading both the original session state (`.copilot-tracking/dt/<WI-ID>/coaching-state.md`) and the new research findings.
4. The DT session continues from the recommended method, incorporating the new evidence.
5. When DT reaches a new exit point, an updated handoff artifact is produced at `docs/workitems/<WI-ID>/artifacts/dt-handoff.md`.
6. The `research` agent resumes with the updated handoff.

### Return Path Example

```
DT Session (Exit 1):
  "Problem: operators need a new dashboard" [validated]

Research Agent:
  Discovers operators don't use the existing dashboard at all → [conflicting]
  Recommends return to DT Method 2 (Observations & Interviews)

DT Session (resumed at Method 2):
  Observes operators using paper checklists instead of the dashboard
  Reframes problem: "operators need checklist digitization, not a dashboard"
  Exits at Exit 1 with updated handoff

Research Agent (resumed):
  Researches checklist digitization approaches with updated problem framing
```

## Confidence Marker Propagation

Confidence markers from [CORE-COMPONENT-0002](../architecture/core-components/CORE-COMPONENT-0002-confidence-markers.md) propagate across the DT → RPIV boundary:

| Stage | Marker Behavior |
|-------|----------------|
| **DT Coach** | Assigns initial markers to all findings in the handoff artifact |
| **Research agent** | Inherits DT markers; may upgrade (`assumed` → `validated`), downgrade (`assumed` → `conflicting`), or resolve (`unknown` → `validated`) |
| **Planner agent** | Reads markers from research brief; escalates `conflicting` items before creating dependent tasks |
| **Implementer agent** | Flags `unknown` items in implementation notes; documents risks for `assumed` items |
| **Verifier agent** | Checks that no `conflicting` items remain unresolved before approving PR |

Only the four standard markers are valid: `validated`, `assumed`, `unknown`, `conflicting`. No custom markers are permitted.

## Related Documents

- [DT-RPIV Integration](dt-rpiv-integration.md) — Full integration contract with per-agent mapping
- [Design Thinking Guide](README.md) — Framework overview
- [Why Design Thinking?](why-design-thinking.md) — Trigger and skip conditions
- [Tutorial: Handoff to RPIV](tutorial-handoff-to-rpiv.md) — Step-by-step walkthrough
- [ADR-0002](../architecture/ADR/ADR-0002-adopt-hve-design-thinking.md) — Adoption decision
- [ADR-0003](../architecture/ADR/ADR-0003-dt-artifact-storage.md) — Artifact storage convention
- [CORE-COMPONENT-0002](../architecture/core-components/CORE-COMPONENT-0002-confidence-markers.md) — Confidence marker specification

---

*Adapted from [microsoft/hve-core](https://github.com/microsoft/hve-core) Design Thinking framework. Terminology translations and exit-point contracts are authoritative for soft-factory.*
