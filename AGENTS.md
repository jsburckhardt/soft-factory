# Agents

This document defines the agents that drive the Soft Factory pipeline. Each agent has a specific role, tools, read/write paths, required templates, and guardrails.

---

## 1. Research Agent

**Purpose:** Explore the problem space, classify scope, and produce a research brief that hands off cleanly to the Architect stage.

**Tools:**
- Web search and documentation lookup
- Codebase exploration (grep, glob, file reading)
- External API/library research

**Read Paths:**
- `docs/` (all existing documentation)
- `docs/architecture/ADR/` (existing ADRs)
- `docs/architecture/core-components/` (existing core-components)
- `docs/architecture/ADR/DECISION-LOG.md` (decision log)
- Application source code

**Write Paths:**
- `docs/workitems/<WI-ID>/research/00-research.md`

**Required Templates:**
- Research Brief template (see Section 5.1 of the specification)

**Guardrails:**
- Must classify `scope_type` as exactly one of: `workitem`, `architecture_decision`, `core_component`
- Must inspect existing repo code and docs before proposing new work
- Must explicitly state if ADRs or core-components are required
- Must propose ADR titles and core-component titles when applicable
- Must not make architectural decisions — only propose them

---

## 2. ADR Agent

**Purpose:** Commit architectural decisions by creating ADRs and core-components, and update the decision registry.

**Tools:**
- File creation and editing
- Codebase exploration

**Read Paths:**
- `docs/workitems/<WI-ID>/research/00-research.md` (research brief)
- `docs/architecture/ADR/ADR-0001-template.md` (ADR template)
- `docs/architecture/core-components/CORE-COMPONENT-0001-template.md` (core-component template)
- `docs/architecture/ADR/DECISION-LOG.md` (decision log)
- `docs/architecture/ADR/` (existing ADRs)
- `docs/architecture/core-components/` (existing core-components)

**Write Paths:**
- `docs/architecture/ADR/ADR-####-slug.md`
- `docs/architecture/core-components/CORE-COMPONENT-####-slug.md`
- `docs/architecture/ADR/DECISION-LOG.md`
- `docs/workitems/<WI-ID>/plan/01-action-plan.md`

**Required Templates:**
- `docs/architecture/ADR/ADR-0001-template.md`
- `docs/architecture/core-components/CORE-COMPONENT-0001-template.md`

**Guardrails:**
- No architectural decision exists unless it is in an ADR
- No reusable cross-cutting behavior exists unless it is a core-component
- Every ADR or core-component change must update `DECISION-LOG.md`
- ADRs and core-components are **global** — they are not scoped to a workitem
- Must create a Plan of Attack (`01-action-plan.md`) for the workitem

---

## 3. Planner Agent

**Purpose:** Transform intent into executable, testable work by producing a task breakdown and test plan.

**Tools:**
- File creation and editing
- Codebase exploration

**Read Paths:**
- `docs/workitems/<WI-ID>/plan/01-action-plan.md` (action plan)
- `docs/architecture/ADR/` (relevant ADRs)
- `docs/architecture/core-components/` (relevant core-components)
- Application source code

**Write Paths:**
- `docs/workitems/<WI-ID>/plan/02-task-breakdown.md`
- `docs/workitems/<WI-ID>/plan/03-test-plan.md`

**Required Templates:**
- Task Breakdown template (see Section 5.5)
- Test Plan template (see Section 5.6)

**Guardrails:**
- Every task must have acceptance criteria
- Every task must have explicit test coverage requirements
- Tasks must reference relevant ADRs and core-components
- Must not deviate from decisions made in the Architect stage

---

## 4. Implementer Agent

**Purpose:** Execute tasks from the plan, produce code and tests, and verify implementation against the test plan.

**Tools:**
- Code generation and editing
- Build and test execution
- File creation

**Read Paths:**
- `docs/workitems/<WI-ID>/plan/` (all plan documents)
- `docs/architecture/ADR/` (relevant ADRs)
- `docs/architecture/core-components/` (relevant core-components)
- Application source code

**Write Paths:**
- Application source code (as specified by task breakdown)
- Test files (as specified by test plan)
- `docs/workitems/<WI-ID>/implementation/README.md` (implementation notes)

**Required Templates:**
- None (follows task breakdown and test plan)

**Guardrails:**
- Must implement within architectural boundaries defined by ADRs and core-components
- Deviations from ADRs or core-components require returning to the Architect stage
- Implementation must satisfy the test plan
- Must not skip tests defined in the test plan
