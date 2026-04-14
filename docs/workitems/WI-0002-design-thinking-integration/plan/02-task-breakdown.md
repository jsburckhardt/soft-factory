# Task Breakdown: WI-0002-design-thinking-integration

## Task 1: Create DT Framework README

- **Status:** Not Started
- **Complexity:** Medium
- **Dependencies:** None (ADR-0002, ADR-0003, CORE-COMPONENT-0002 already committed)
- **Related ADRs:** ADR-0002
- **Related Core-Components:** CORE-COMPONENT-0002

### Description
Create `docs/design-thinking/README.md` as the navigation hub and entry point for all Design Thinking documentation in soft-factory. Extract and adapt the three-space, nine-method overview from hve-core's `docs/design-thinking/README.md`. Update the exit-point diagram targets from "Task Researcher" to "Research Agent", update the pipeline label from "RPI" to "RPIV", and add links to all other DT documents in this workitem. Include links to hve-core method guides (01–09) as external references rather than copied content (per Option C strategy).

### Acceptance Criteria
- File exists at `docs/design-thinking/README.md`.
- Contains the three-space, nine-method model overview with ASCII diagram.
- Exit-point diagram targets use "Research Agent" (not "Task Researcher").
- Pipeline label is "RPIV" throughout (zero occurrences of standalone "RPI").
- Links to all other DT docs created in this workitem (`why-design-thinking.md`, `dt-coach.md`, `dt-rpiv-integration.md`, `tutorial-handoff-to-rpiv.md`, `dt-rpiv-mapping.md`).
- Links to hve-core method guides (01–09) as external references.
- Mentions confidence markers with a link to CORE-COMPONENT-0002.

### Test Coverage
- Markdown renders without errors (heading hierarchy, no broken syntax).
- All internal links resolve to existing files.
- All external links point to valid hve-core URLs.
- `grep -r "RPI[^V]" docs/design-thinking/README.md` returns zero matches (excluding "RPIV").

---

## Task 2: Create why-design-thinking.md

- **Status:** Not Started
- **Complexity:** Low
- **Dependencies:** Task 1
- **Related ADRs:** ADR-0002
- **Related Core-Components:** None

### Description
Create `docs/design-thinking/why-design-thinking.md` by extracting and adapting hve-core's `docs/design-thinking/why-design-thinking.md`. Replace all "RPI" references with "RPIV". Update agent name references to match soft-factory conventions. Include the trigger conditions and skip conditions from ADR-0002 for when to use DT vs. when to go straight to RPIV.

### Acceptance Criteria
- File exists at `docs/design-thinking/why-design-thinking.md`.
- Contains clear trigger conditions for when to use DT (requirements unclear, stakeholder conflict, cross-boundary problems, user adoption critical).
- Contains clear skip conditions (requirements understood, purely technical, prior DT session exists).
- All "RPI" references replaced with "RPIV".
- Agent names match soft-factory conventions (research, planner, implementer, verifier, dt-coach).
- Cross-references to `README.md` and `dt-rpiv-integration.md` within `docs/design-thinking/`.

### Test Coverage
- Markdown renders without errors.
- `grep -rn "RPI[^V]" docs/design-thinking/why-design-thinking.md` returns zero matches.
- All internal links resolve to existing files.

---

## Task 3: Create DT Coach Guide

- **Status:** Not Started
- **Complexity:** Medium
- **Dependencies:** Task 1
- **Related ADRs:** ADR-0002
- **Related Core-Components:** CORE-COMPONENT-0002

### Description
Create `docs/design-thinking/dt-coach.md` by extracting and adapting hve-core's `docs/design-thinking/dt-coach.md`. Update pipeline and agent references to soft-factory conventions. Document the Think/Speak/Empower coaching philosophy, the progressive hint engine, and how the DT Coach agent manages sessions. Reference confidence markers (CORE-COMPONENT-0002) in the context of handoff artifact creation.

### Acceptance Criteria
- File exists at `docs/design-thinking/dt-coach.md`.
- Documents the Think/Speak/Empower coaching philosophy.
- Describes the progressive hint engine (4-level escalation).
- Describes session state management with paths from ADR-0003 (`.copilot-tracking/dt/<WI-ID>/coaching-state.md`).
- References confidence markers and links to CORE-COMPONENT-0002.
- All pipeline references use "RPIV"; all agent names match soft-factory conventions.

### Test Coverage
- Markdown renders without errors.
- `grep -rn "RPI[^V]" docs/design-thinking/dt-coach.md` returns zero matches.
- All internal links resolve to existing files.
- Paths reference `.copilot-tracking/dt/<WI-ID>/` (not `{project-slug}`).

---

## Task 4: Create DT-RPIV Integration Contract

- **Status:** Not Started
- **Complexity:** High
- **Dependencies:** Task 1, Task 3
- **Related ADRs:** ADR-0002, ADR-0003
- **Related Core-Components:** CORE-COMPONENT-0002

### Description
Create `docs/design-thinking/dt-rpiv-integration.md` by extracting and adapting hve-core's `docs/design-thinking/dt-rpi-integration.md`. This is the most adaptation-intensive document: rename from "RPI" to "RPIV" throughout, adapt all agent names, update pipeline labels, update artifact paths to match ADR-0003, and add the Verify≠Review distinction from ADR-0002. Document the three exit points and their mapping to Research agent behavior. Include confidence marker propagation rules from CORE-COMPONENT-0002.

### Acceptance Criteria
- File exists at `docs/design-thinking/dt-rpiv-integration.md` (note: filename uses "rpiv", not "rpi").
- Contains the three exit points with their DT output and Research agent behavior mapping.
- Contains the return path protocol (RPIV → DT).
- Documents the Verify≠Review distinction explicitly.
- Artifact paths match ADR-0003: session state in `.copilot-tracking/dt/<WI-ID>/`, handoff in `docs/workitems/<WI-ID>/artifacts/dt-handoff.md`.
- Confidence marker propagation rules documented per CORE-COMPONENT-0002.
- All agent names match soft-factory conventions.
- Zero occurrences of standalone "RPI" (only "RPIV").

### Test Coverage
- Markdown renders without errors.
- `grep -rn "RPI[^V]" docs/design-thinking/dt-rpiv-integration.md` returns zero matches.
- `grep -rn "Task Researcher\|Task Planner\|Task Implementor\|Task Reviewer" docs/design-thinking/dt-rpiv-integration.md` returns zero matches (hve-core agent names eliminated).
- All internal links resolve to existing files.
- Artifact paths are consistent with ADR-0003.

---

## Task 5: Create Handoff Tutorial

- **Status:** Not Started
- **Complexity:** Medium
- **Dependencies:** Task 4
- **Related ADRs:** ADR-0002, ADR-0003
- **Related Core-Components:** CORE-COMPONENT-0002

### Description
Create `docs/design-thinking/tutorial-handoff-to-rpiv.md` by extracting and adapting hve-core's `docs/design-thinking/tutorial-handoff-to-rpi.md`. Adapt tutorial steps for soft-factory agent invocation patterns. Update all paths to match ADR-0003. Walk through a concrete example of a DT session reaching an exit point and handing off to the Research agent with confidence-marked findings.

### Acceptance Criteria
- File exists at `docs/design-thinking/tutorial-handoff-to-rpiv.md` (note: filename uses "rpiv").
- Contains step-by-step tutorial for at least one exit point handoff.
- Uses soft-factory agent invocation patterns (not hve-core patterns).
- Artifact paths match ADR-0003.
- Includes a concrete example of a handoff artifact with confidence markers.
- Cross-references `dt-rpiv-integration.md` and `dt-rpiv-mapping.md`.
- Zero occurrences of standalone "RPI".

### Test Coverage
- Markdown renders without errors.
- `grep -rn "RPI[^V]" docs/design-thinking/tutorial-handoff-to-rpiv.md` returns zero matches.
- All internal links resolve to existing files.
- Example handoff artifact uses valid confidence markers from CORE-COMPONENT-0002.

---

## Task 6: Create DT-RPIV Mapping Document

- **Status:** Not Started
- **Complexity:** Medium
- **Dependencies:** Task 4
- **Related ADRs:** ADR-0002
- **Related Core-Components:** CORE-COMPONENT-0002

### Description
Create `docs/design-thinking/dt-rpiv-mapping.md` — a new file with no direct hve-core equivalent. This is the authoritative RPIV-specific mapping document containing: terminology translation table (hve-core RPI → soft-factory RPIV), trigger conditions, all three exit-point contracts with concrete examples, and the return-path protocol. This document serves as the single source of truth for how DT and RPIV interact.

### Acceptance Criteria
- File exists at `docs/design-thinking/dt-rpiv-mapping.md`.
- Contains terminology translation table (hve-core agent names → soft-factory agent names, RPI → RPIV).
- Contains trigger conditions and skip conditions (consistent with ADR-0002).
- Contains all three exit-point contracts with concrete examples for each.
- Contains return-path protocol (RPIV → DT) with conditions and process.
- Cross-references ADR-0002 and `dt-rpiv-integration.md`.
- Covers confidence marker propagation across exit points.

### Test Coverage
- Markdown renders without errors.
- All internal links resolve to existing files.
- Terminology translation table covers all four hve-core agent names.
- Each of the three exit points has at least one concrete example.

---

## Task 7: Create DT Coach Agent

- **Status:** Not Started
- **Complexity:** High
- **Dependencies:** Task 3, Task 4, Task 6
- **Related ADRs:** ADR-0002, ADR-0003
- **Related Core-Components:** CORE-COMPONENT-0002

### Description
Create `.github/agents/dt-coach.agent.md` by adapting hve-core's `.github/agents/design-thinking/dt-coach.agent.md`. The soft-factory version must be **self-contained** — no external `.github/instructions/` dependencies. Embed the essential coaching philosophy (Think/Speak/Empower), the nine-method list with space assignments, the state management protocol (using ADR-0003 paths), and the handoff procedure (producing `dt-handoff.md` with confidence markers per CORE-COMPONENT-0002). Adapt handoff targets to the `research` agent. Use RPIV terminology throughout.

### Acceptance Criteria
- File exists at `.github/agents/dt-coach.agent.md`.
- Agent is self-contained — no references to `.github/instructions/` files.
- Embeds Think/Speak/Empower coaching philosophy.
- Lists all nine methods with their space assignments (Problem/Solution/Validation).
- Session state path is `.copilot-tracking/dt/<WI-ID>/coaching-state.md` (per ADR-0003).
- Handoff artifact path is `docs/workitems/<WI-ID>/artifacts/dt-handoff.md` (per ADR-0003).
- Handoff artifacts include confidence markers (per CORE-COMPONENT-0002).
- Handoff target is the `research` agent (not "Task Researcher").
- Uses RPIV terminology throughout; zero standalone "RPI" references.
- Includes guardrails section consistent with AGENTS.md conventions.
- Includes purpose, tools, read_paths, write_paths fields.

### Test Coverage
- File exists and is valid Markdown.
- `grep -rn "RPI[^V]" .github/agents/dt-coach.agent.md` returns zero matches.
- `grep -rn "\.github/instructions/" .github/agents/dt-coach.agent.md` returns zero matches (no external instruction dependencies).
- Contains required structural sections: purpose, tools, read_paths, write_paths, guardrails.
- Paths are consistent with ADR-0003.

---

## Task 8: Update AGENTS.md

- **Status:** Not Started
- **Complexity:** Medium
- **Dependencies:** Task 7
- **Related ADRs:** ADR-0002
- **Related Core-Components:** None

### Description
Update `AGENTS.md` to add a `dt-coach` entry in the `AGENTS` constants block. The entry must follow the exact format of existing agent entries (e.g., `research`, `planner`, `implementer`, `verifier`) and include: `file`, `purpose`, `tools`, `read_paths`, `write_paths`, and `guardrails`. The entry must reference the DT Coach agent file created in Task 7 and use paths consistent with ADR-0003.

### Acceptance Criteria
- `AGENTS.md` contains a `dt-coach` entry in the `AGENTS` YAML constants block.
- Entry includes all required fields: `file`, `purpose`, `tools`, `read_paths`, `write_paths`, `guardrails`.
- `file` field points to `.github/agents/dt-coach.agent.md`.
- `read_paths` and `write_paths` are consistent with ADR-0003 artifact paths.
- Entry format matches existing agent entries exactly (indentation, field order, style).
- No other existing agent entries are modified.
- AGENTS.md remains valid after the edit (no broken YAML in the constants block).

### Test Coverage
- `AGENTS.md` contains the string `dt-coach:` in the AGENTS block.
- The `dt-coach` entry contains all required fields: file, purpose, tools, read_paths, write_paths, guardrails.
- `file` value is `.github/agents/dt-coach.agent.md`.
- No existing agent entries are modified (diff check).
- YAML block is syntactically valid.

---

## Task 9: Cross-Reference and Link Validation

- **Status:** Not Started
- **Complexity:** Low
- **Dependencies:** Task 1, Task 2, Task 3, Task 4, Task 5, Task 6, Task 7, Task 8
- **Related ADRs:** ADR-0002, ADR-0003
- **Related Core-Components:** CORE-COMPONENT-0002

### Description
Final validation pass across all files created or modified in this workitem. Verify that all internal links between DT documentation files, agent files, ADRs, and core-components resolve correctly. Verify that no hve-core "RPI" terminology (without "V" suffix) remains in any adapted document. Verify that artifact paths are consistent with ADR-0003 across all files. Verify that confidence marker references are consistent with CORE-COMPONENT-0002.

### Acceptance Criteria
- All internal links in `docs/design-thinking/*.md` resolve to existing files.
- All internal links in `.github/agents/dt-coach.agent.md` resolve to existing files.
- All links from DT docs to ADR-0002, ADR-0003, and CORE-COMPONENT-0002 resolve correctly.
- Zero occurrences of standalone "RPI" (without "V") in any file under `docs/design-thinking/`.
- Zero occurrences of hve-core agent names ("Task Researcher", "Task Planner", "Task Implementor", "Task Reviewer") in any adapted file.
- All artifact paths reference ADR-0003 conventions consistently.
- All confidence marker references use the four valid markers from CORE-COMPONENT-0002.

### Test Coverage
- `grep -rn "RPI[^V]" docs/design-thinking/` returns zero matches.
- `grep -rn "Task Researcher\|Task Planner\|Task Implementor\|Task Reviewer" docs/design-thinking/` returns zero matches.
- Link checker validates all internal cross-references (manual or automated).
- `grep -rn "\.copilot-tracking/dt/{project-slug}" docs/design-thinking/` returns zero matches (should use `<WI-ID>`).
- All confidence marker inline syntax uses one of: `[validated]`, `[assumed]`, `[unknown]`, `[conflicting]`.
