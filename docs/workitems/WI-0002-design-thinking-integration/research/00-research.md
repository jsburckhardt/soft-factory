# Research Brief: Design Thinking Integration

## Title
Integrate HVE Design Thinking Framework as an Optional Pre-Research Stage in the RPIV Pipeline

## Idea Summary

Extract and adapt the Design Thinking (DT) framework from `microsoft/hve-core` and incorporate it
into the soft-factory repository. The integration adds a structured, human-centered discovery layer
that runs **before** the Research stage for workitems where requirements are unclear, stakeholders
are in conflict, or user adoption is a critical success factor. DT exits gracefully into the
existing RPIV pipeline at three defined handoff points, preserving the pipeline's mandatory
four-stage structure for all other work.

## Scope Type

```
scope_type: workitem
```

> **Why workitem and not architecture_decision or core_component?**
> The primary deliverable is reference documentation and an agent file — concrete artifacts added
> to the repo, not a structural change to the pipeline execution model. However, this workitem
> **triggers two downstream ADRs and one core-component** (see sections below), which the Planner
> must create before implementation begins.

## Related Workitem
WI-0002-design-thinking-integration

## Existing Repo Context

- Repository is the soft-factory template itself: no application code, no existing ADRs, no existing core-components.
- Pipeline is RPIV: Research → Plan → Implement → Verify.
- Agent roster (`.github/agents/`): `research.agent.md`, `planner.agent.md`, `implementer.agent.md`, `verifier.agent.md`, `onboard-repo.agent.md`, `bootstrap.agent.md`, `excali.agent.md`, `aps-v1.2.1.agent.md`, `justdoit.agent.md`.
- No Design Thinking artifacts, agents, or documentation exist in the repo.
- The pipeline mandates `scope_type` classification; DT work produces pre-classified workitem input.

## Source Material

| Asset | Location | Access |
|-------|----------|--------|
| DT README (9-method, 3-space overview) | `microsoft/hve-core` · `docs/design-thinking/README.md` | Public GitHub |
| Why Design Thinking | `microsoft/hve-core` · `docs/design-thinking/why-design-thinking.md` | Public GitHub |
| DT Coach guide | `microsoft/hve-core` · `docs/design-thinking/dt-coach.md` | Public GitHub |
| DT-to-RPI integration contract | `microsoft/hve-core` · `docs/design-thinking/dt-rpi-integration.md` | Public GitHub |
| Handoff tutorial | `microsoft/hve-core` · `docs/design-thinking/tutorial-handoff-to-rpi.md` | Public GitHub |
| Method guides (01–09) | `microsoft/hve-core` · `docs/design-thinking/method-*.md` | Public GitHub |
| DT Coach agent | `microsoft/hve-core` · `.github/agents/design-thinking/dt-coach.agent.md` | Public GitHub |
| DT Learning Tutor agent | `microsoft/hve-core` · `.github/agents/design-thinking/dt-learning-tutor.agent.md` | Public GitHub |

---

## Framework Analysis: HVE Design Thinking

### The Three-Space, Nine-Method Model

The framework divides human-centered discovery into three sequential spaces. Quality expectations
are **deliberately different** per space — polish is an anti-pattern in the Problem and Solution
spaces.

```
┌─────────────────────────────┐   ┌─────────────────────────────┐   ┌─────────────────────────────┐
│   PROBLEM SPACE (rough)     │   │  SOLUTION SPACE (scrappy)   │   │ VALIDATION SPACE (rigorous) │
│                             │   │                             │   │                             │
│  M1 · Scope Conversations   │──▶│  M4 · Brainstorming         │──▶│  M7 · Hi-Fi Prototypes      │
│  M2 · Design Research       │   │  M5 · User Concepts         │   │  M8 · User Testing          │
│  M3 · Input Synthesis       │   │  M6 · Lo-Fi Prototypes      │   │  M9 · Iteration at Scale    │
└──────────┬──────────────────┘   └──────────┬──────────────────┘   └──────────┬──────────────────┘
           │ Exit 1                           │ Exit 2                           │ Exit 3
           │ Problem statement                │ Validated concept                │ Implementation spec
           ▼                                  ▼                                  ▼
    ┌──────────────────────────────────────────────────────────────────────────────────────┐
    │                              soft-factory RPIV Pipeline                              │
    │  Research ──▶ Plan ──▶ Implement ──▶ Verify                                          │
    └──────────────────────────────────────────────────────────────────────────────────────┘
```

### The DT Coach Agent (hve-core)

The `dt-coach.agent.md` agent:
- Implements a **Think/Speak/Empower** coaching philosophy (observe → share → offer choices).
- Manages session state in `.copilot-tracking/dt/{project-slug}/coaching-state.md`.
- Enforces space-appropriate fidelity constraints (rough/scrappy/functional).
- Routes between methods non-linearly based on exit signals, not arbitrary timelines.
- Prepares structured handoff artifacts when the team reaches an exit point.
- Supports hat-switching: same coaching identity, method-specific domain techniques.
- Uses a **progressive hint engine** (4-level escalation) to avoid giving answers prematurely.

### Confidence Markers

Every DT handoff artifact tags its contents with one of four confidence markers:

| Marker | Meaning | Downstream Treatment |
|--------|---------|---------------------|
| `validated` | Confirmed through multi-source evidence | Treat as reliable; no re-investigation |
| `assumed` | Believed true but unverified | Verification target in Research stage |
| `unknown` | Identified gap not yet investigated | Primary research target |
| `conflicting` | Evidence points in multiple directions | Must resolve before proceeding |

These markers propagate through the entire RPIV pipeline and affect how each agent calibrates its work.

---

## Pipeline Mapping: DT + RPIV

### Terminology Translation

| hve-core (RPI) | soft-factory (RPIV) | Notes |
|---------------|---------------------|-------|
| Task Researcher | `research` agent | Single entry point for all DT handoffs |
| Task Planner | `planner` agent | Receives DT context via research brief |
| Task Implementor | `implementer` agent | Inherits fidelity constraints from DT space |
| Task Reviewer | `verifier` agent | Equivalent stage; different name only |
| RPI pipeline | RPIV pipeline | Verify ≠ Review: Verify runs tests + opens PR |

> **Critical distinction**: hve-core's "Review" stage focuses on coaching quality and method
> fidelity assessment. soft-factory's "Verify" stage focuses on running the test suite, creating
> commits, and opening a PR. DT artifacts are validated **within** the pipeline stages, not in a
> dedicated review stage.

### DT as Optional Pre-Research Stage

DT is **not** a mandatory fifth stage. It is a discoverable upstream activity that:

1. Runs when the trigger conditions are met (see below).
2. Exits into the `research` agent at one of three defined handoff points.
3. Does not interrupt or replace RPIV — it feeds into it.

**Trigger conditions for using DT (from hve-core's why-design-thinking.md):**

- Requirements are unclear: stakeholders describe solutions, not problems.
- Multiple stakeholders disagree or have conflicting needs.
- The problem spans organizational boundaries, user roles, or technical systems.
- User adoption is a critical success factor.

**When to skip DT and go straight to RPIV:**

- Requirements are well understood and agreed upon.
- The task is purely technical with no user-facing ambiguity.
- A prior DT session already produced a validated handoff artifact for this scope.

### Exit Point to RPIV Mapping

| DT Exit Point | DT Output | RPIV Entry Point | Research Agent Behavior |
|---------------|-----------|-----------------|------------------------|
| Exit 1 (Methods 1–3) | Validated problem statement | `research` agent | Scopes technical research around stakeholder-validated needs; treats `assumed` as verification targets, `unknown` as primary targets |
| Exit 2 (Methods 4–6) | Validated concept + constraints | `research` agent | Narrows scope to tested directions; resolves constraint gaps; assesses feasibility of narrowed concepts |
| Exit 3 (Methods 7–9) | Functional spec + test evidence | `research` agent | Investigates production readiness, scaling gaps, integration concerns; research scope is significantly narrowed |

### Return Path (RPIV → DT)

The integration is bidirectional. The `research` agent may recommend returning to DT coaching when:

- The problem statement from DT needs revision due to new technical evidence.
- Fundamental DT assumptions are invalidated during research.
- Unrepresented stakeholder groups emerge during technical investigation.

This is designed behavior, not failure. It is recorded in the workitem research brief as a
`conflicting` confidence marker escalation.

---

## Options Considered

| Option | Description | Pros | Cons |
|--------|-------------|------|------|
| **A. Full extract** | Copy all hve-core DT docs verbatim into `docs/design-thinking/` | Complete, self-contained | Drift risk; duplicates 3,000+ lines; no attribution |
| **B. Reference only** | Add a link to hve-core DT docs in the README | Zero maintenance | No offline access; no soft-factory adaptation |
| **C. Selective extract + adapt** *(recommended)* | Extract the framework overview, integration contract, confidence markers, and agent; adapt RPIV terminology; reference hve-core for method deep-dives | Balanced; adapted to soft-factory context; low duplication | Requires upfront adaptation work |
| **D. Method guides as stubs** | Extract headers and key outputs only; link to hve-core for details | Lightweight | Insufficient for self-contained use |

### Recommendation

**Option C — Selective extract + adapt.** The framework overview, DT-to-RPIV integration contract,
and confidence markers schema are the highest-value artifacts for soft-factory users. The nine
method deep-dives are best served by referencing hve-core directly (they are context-specific and
update frequently). The DT Coach agent must be adapted, not copied verbatim, because it references
RPI terminology, session paths, and handoff targets that do not match soft-factory's conventions.

---

## Content Extraction Plan

### Extract and Adapt (produce new files in soft-factory)

| Source File (hve-core) | Target File (soft-factory) | Adaptation Required |
|------------------------|---------------------------|---------------------|
| `docs/design-thinking/README.md` | `docs/design-thinking/README.md` | Update exit-point diagram targets from "Task Researcher" → "Research Agent"; update pipeline label from "RPI" → "RPIV" |
| `docs/design-thinking/why-design-thinking.md` | `docs/design-thinking/why-design-thinking.md` | Replace all "RPI" references with "RPIV"; update agent names |
| `docs/design-thinking/dt-rpi-integration.md` | `docs/design-thinking/dt-rpiv-integration.md` | Full rename + adapt: all agent names, pipeline labels, artifact paths (`.copilot-tracking/dt/` → `docs/workitems/<WI-ID>/dt-artifacts/`), Verify≠Review distinction |
| `docs/design-thinking/tutorial-handoff-to-rpi.md` | `docs/design-thinking/tutorial-handoff-to-rpiv.md` | Adapt tutorial steps for soft-factory agent invocation patterns; update paths |
| `docs/design-thinking/dt-coach.md` | `docs/design-thinking/dt-coach.md` | Minor: update pipeline and agent references |
| `.github/agents/design-thinking/dt-coach.agent.md` | `.github/agents/dt-coach.agent.md` | Adapt handoff target → `research` agent; adapt artifact paths → workitem convention; update pipeline name |

### Reference Only (link to hve-core, do not copy)

| hve-core Document | Rationale for Reference |
|-------------------|------------------------|
| `docs/design-thinking/method-01-scope-conversations.md` through `method-09-iteration-at-scale.md` | Method deep-dives are context-specific; hve-core is authoritative; copying risks drift |
| `docs/design-thinking/dt-learning-tutor.md` | Learning tutor agent is hve-core-specific infrastructure |
| `docs/design-thinking/using-together.md` | End-to-end walkthrough references hve-core-specific scenarios |

### New Files (produce in soft-factory, no direct hve-core equivalent)

| New File | Purpose |
|---------|---------|
| `docs/design-thinking/dt-rpiv-mapping.md` | Authoritative RPIV-specific mapping document: terminology translation, trigger conditions, exit-point contract, return-path protocol |
| `docs/design-thinking/README.md` (index) | Navigation hub linking all DT docs + method references to hve-core |

---

## Required ADRs

### ADR-0002: Adopt HVE Design Thinking as an Optional Pre-Research Stage

**Decision prompt**: Should soft-factory incorporate the HVE Design Thinking framework, and if so,
how does it fit into the RPIV pipeline?

**Key considerations for the ADR**:
- DT is **optional**, not mandatory — pipeline integrity is preserved.
- Entry into RPIV always occurs through the `research` agent, regardless of exit point.
- The ADR must define trigger conditions (when to use DT vs. when to skip it).
- The ADR must define the handoff contract: what the `research` agent receives, in what format.
- The ADR must address the Verify≠Review distinction and its implications for DT artifact review.
- Alternatives to address: (1) no DT at all; (2) DT as a mandatory first stage; (3) DT integrated into the Research agent's own instructions.

**Proposed decision**: DT is adopted as an optional pre-RPIV activity. All DT exits enter RPIV at
the `research` stage. Confidence markers (`validated/assumed/unknown/conflicting`) are adopted as
a soft-factory standard for research brief content, regardless of whether DT was used.

### ADR-0003: Artifact Storage Convention for DT Sessions

**Decision prompt**: Where should DT session artifacts be stored — in `.copilot-tracking/dt/`
(hve-core convention) or in `docs/workitems/<WI-ID>/dt-artifacts/` (soft-factory workitem convention)?

**Key considerations for the ADR**:
- hve-core uses `.copilot-tracking/dt/{project-slug}/` for transient session state.
- soft-factory uses `docs/workitems/<WI-ID>/` as the durable artifact location.
- DT artifacts should be traceable to a specific workitem for pipeline integrity.
- The session state file (`coaching-state.md`) may be transient; the handoff artifact must be durable.
- Alternatives: (1) hve-core convention (`.copilot-tracking/`); (2) workitem subfolder (`dt-artifacts/`); (3) hybrid (session state in `.copilot-tracking/`, handoff artifact committed to workitem folder).

**Proposed decision**: Hybrid approach — session state lives in `.copilot-tracking/dt/<WI-ID>/`
during active DT work; the final handoff artifact is copied to
`docs/workitems/<WI-ID>/artifacts/dt-handoff.md` before the `research` agent is invoked.

---

## Required Core-Components

### CORE-COMPONENT-0002: Confidence Markers

**Purpose**: The `validated / assumed / unknown / conflicting` schema is a cross-cutting quality
standard that applies to every research brief in the RPIV pipeline — not just those that went
through DT. Any research finding carries an implicit confidence level; making it explicit improves
downstream planning and implementation accuracy.

**Scope**: Affects the `research` agent's output format, the `planner` agent's acceptance criteria
formulation, and the `verifier` agent's PR review checklist.

**Rules (to be formalized in the core-component)**:
- Every factual claim in a `00-research.md` brief that is not directly verifiable from source code
  or documentation MUST carry a confidence marker.
- The `planner` agent MUST escalate `conflicting` items before creating tasks that depend on them.
- The `implementer` agent MUST flag `unknown` items in implementation notes.
- Returning to a prior stage is the correct response when a `conflicting` item cannot be resolved.

**Why a core-component (not just ADR guidance)**: The confidence marker schema has specific rules,
interface expectations, and enforcement mechanisms that apply across multiple agents and stages. An
ADR captures the decision to adopt it; the core-component defines how it is used.

---

## Risks & Unknowns

| Risk / Unknown | Confidence | Mitigation |
|----------------|------------|------------|
| hve-core method guide content may change after extraction | `assumed` | Reference hve-core rather than copying method guides; pin links to a specific commit if needed |
| Verify stage's test-focus may not adequately check DT artifact quality | `unknown` | ADR-0002 must explicitly address what "verification" means for DT-originated workitems |
| The dt-coach agent's tiered instruction loading system depends on `.github/instructions/` files that are not public in hve-core | `assumed` | Implement a simplified, self-contained agent without the tiered instruction dependency; document this as a known reduction in capability |
| `.copilot-tracking/` may not be standard in all soft-factory deployments | `unknown` | ADR-0003 resolves this via the hybrid storage convention |
| Confidence markers may conflict with existing research brief format | `conflicting` | Existing format (WI-0001-example) does not use markers; CORE-COMPONENT-0002 must define backward-compatible adoption |

---

## Verification Strategy

- All extracted and adapted documentation files render correctly as Markdown (no broken links, correct headings).
- The DT Coach agent file (`dt-coach.agent.md`) passes AGENTS.md structural conventions (name, description, tools, purpose, guardrails).
- The `dt-rpiv-integration.md` document contains zero references to "RPI" without the "V" suffix (automated grep check).
- The `dt-rpiv-mapping.md` document covers all three exit points with concrete examples.
- Both ADRs (ADR-0002 and ADR-0003) are recorded in `DECISION-LOG.md`.
- `CORE-COMPONENT-0002` is recorded in `DECISION-LOG.md`.
- Cross-references between all new DT docs are internally consistent (no 404 links).
- The `AGENTS.md` constants block is updated to include the `dt-coach` agent definition.

---

## Architect Handoff Notes

1. **Create ADR-0002 first** — all implementation decisions about DT placement in the pipeline are
   blocked on this ADR. The Planner must not create any DT documentation before ADR-0002 is
   accepted.

2. **Create ADR-0003 second** — the artifact storage decision governs paths used by the agent,
   the integration tutorial, and the handoff docs. All file paths in adapted documentation depend
   on this decision.

3. **Create CORE-COMPONENT-0002 third** — confidence markers must be defined before any adapted
   documentation is written, since they appear throughout the research brief format.

4. **Documentation extraction order**: README → why-design-thinking → dt-coach guide →
   dt-rpiv-integration → tutorial → dt-rpiv-mapping (new) → dt-coach agent.

5. **Agent adaptation is not a copy-paste job.** The hve-core `dt-coach.agent.md` references
   `.github/instructions/design-thinking/` files that are not being ported. The soft-factory
   adaptation must be self-contained: embed the essential coaching philosophy, method list, and
   state management protocol directly in the agent file without external instruction dependencies.

6. **Do not create a DT Learning Tutor agent.** The learning tutor is hve-core-specific
   infrastructure tied to that platform's curriculum system. Reference the hve-core version instead.

7. **AGENTS.md update required.** The `AGENTS` constants block must add a `dt-coach` entry with
   `file`, `purpose`, `tools`, `read_paths`, `write_paths`, and `guardrails`. Follow the existing
   agent entry format exactly.

8. **Naming note.** The pipeline in hve-core is called "RPI" (Research, Plan, Implement, Review).
   soft-factory calls it "RPIV" (Research, Plan, Implement, Verify). Every adapted document must
   use "RPIV" consistently and must distinguish Verify from Review where behaviorally relevant.

---

## External References

- [microsoft/hve-core Design Thinking Guide](https://github.com/microsoft/hve-core/blob/main/docs/design-thinking/README.md)
- [microsoft/hve-core DT-to-RPI Integration](https://github.com/microsoft/hve-core/blob/main/docs/design-thinking/dt-rpi-integration.md)
- [microsoft/hve-core DT Coach agent](https://github.com/microsoft/hve-core/blob/main/.github/agents/design-thinking/dt-coach.agent.md)
- [microsoft/hve-core Why Design Thinking](https://github.com/microsoft/hve-core/blob/main/docs/design-thinking/why-design-thinking.md)
- [microsoft/hve-core Handoff Tutorial](https://github.com/microsoft/hve-core/blob/main/docs/design-thinking/tutorial-handoff-to-rpi.md)
