# Test Plan: WI-0002-design-thinking-integration

## Test T1: DT README Markdown Rendering and Structure

- **Type:** Manual / Automated
- **Task:** Task 1
- **Priority:** High

### Setup
- All files from Task 1 have been created.

### Steps
1. Open `docs/design-thinking/README.md` in a Markdown previewer.
2. Verify heading hierarchy (single H1, proper nesting).
3. Verify the ASCII exit-point diagram renders correctly.
4. Verify all internal links (click each one or use a link checker).
5. Verify all external links to hve-core method guides (01–09) resolve.
6. Run: `grep -rn 'RPI[^V]' docs/design-thinking/README.md` — expect zero matches.

### Expected Result
- Document renders without broken syntax or malformed headings.
- All internal links resolve to existing files.
- All external links point to valid hve-core URLs.
- No standalone "RPI" references exist (only "RPIV").

---

## Test T2: why-design-thinking.md Terminology Check

- **Type:** Automated
- **Task:** Task 2
- **Priority:** High

### Setup
- File `docs/design-thinking/why-design-thinking.md` exists.

### Steps
1. Run: `grep -rn 'RPI[^V]' docs/design-thinking/why-design-thinking.md`
2. Run: `grep -rn 'Task Researcher\|Task Planner\|Task Implementor\|Task Reviewer' docs/design-thinking/why-design-thinking.md`
3. Verify trigger conditions section is present and matches ADR-0002.
4. Verify skip conditions section is present and matches ADR-0002.

### Expected Result
- Both grep commands return zero matches.
- Trigger conditions list four items (unclear requirements, stakeholder conflict, cross-boundary, user adoption).
- Skip conditions list three items (understood requirements, purely technical, prior DT session).

---

## Test T3: DT Coach Guide Content Validation

- **Type:** Manual
- **Task:** Task 3
- **Priority:** Medium

### Setup
- File `docs/design-thinking/dt-coach.md` exists.

### Steps
1. Verify Think/Speak/Empower philosophy is documented.
2. Verify progressive hint engine (4 levels) is described.
3. Verify session state path is `.copilot-tracking/dt/<WI-ID>/coaching-state.md`.
4. Verify confidence markers are referenced with link to CORE-COMPONENT-0002.
5. Run: `grep -rn 'RPI[^V]' docs/design-thinking/dt-coach.md` — expect zero matches.

### Expected Result
- All three coaching philosophy pillars (Think, Speak, Empower) are present.
- Four hint escalation levels are described.
- Session state path uses `<WI-ID>` placeholder (not `{project-slug}`).
- CORE-COMPONENT-0002 link resolves.

---

## Test T4: DT-RPIV Integration Contract Completeness

- **Type:** Manual / Automated
- **Task:** Task 4
- **Priority:** Critical

### Setup
- File `docs/design-thinking/dt-rpiv-integration.md` exists.

### Steps
1. Verify all three exit points are documented with DT output and Research agent behavior.
2. Verify return path protocol (RPIV → DT) is documented.
3. Verify Verify≠Review distinction is explicitly stated.
4. Verify artifact paths match ADR-0003:
   - Session state: `.copilot-tracking/dt/<WI-ID>/coaching-state.md`
   - Handoff: `docs/workitems/<WI-ID>/artifacts/dt-handoff.md`
5. Run: `grep -rn 'RPI[^V]' docs/design-thinking/dt-rpiv-integration.md` — expect zero matches.
6. Run: `grep -rn 'Task Researcher\|Task Planner\|Task Implementor\|Task Reviewer' docs/design-thinking/dt-rpiv-integration.md` — expect zero matches.

### Expected Result
- Three exit points with clear mapping tables.
- Return path conditions documented (revised problem statement, invalidated assumptions, new stakeholders).
- Explicit statement that Verify runs tests + opens PR, not coaching assessment.
- Artifact paths are ADR-0003 compliant.
- Zero RPI-without-V and zero hve-core agent name matches.

---

## Test T5: Handoff Tutorial Example Validation

- **Type:** Manual
- **Task:** Task 5
- **Priority:** Medium

### Setup
- File `docs/design-thinking/tutorial-handoff-to-rpiv.md` exists.

### Steps
1. Verify at least one exit point handoff is demonstrated step-by-step.
2. Verify the tutorial uses soft-factory agent invocation patterns.
3. Verify the example handoff artifact contains confidence markers.
4. Verify confidence markers use only valid values: `validated`, `assumed`, `unknown`, `conflicting`.
5. Verify artifact paths match ADR-0003.
6. Run: `grep -rn 'RPI[^V]' docs/design-thinking/tutorial-handoff-to-rpiv.md` — expect zero matches.

### Expected Result
- At least one complete walkthrough from DT exit to Research agent input.
- Example handoff artifact demonstrates all four confidence marker types.
- All paths and agent names match soft-factory conventions.

---

## Test T6: DT-RPIV Mapping Document Completeness

- **Type:** Manual
- **Task:** Task 6
- **Priority:** High

### Setup
- File `docs/design-thinking/dt-rpiv-mapping.md` exists.

### Steps
1. Verify terminology translation table covers all four hve-core agent names → soft-factory names.
2. Verify trigger conditions are listed and consistent with ADR-0002.
3. Verify all three exit-point contracts are documented.
4. Verify each exit point has at least one concrete example.
5. Verify return-path protocol is documented.
6. Verify all internal links resolve.

### Expected Result
- Translation table has entries for: Task Researcher → research, Task Planner → planner, Task Implementor → implementer, Task Reviewer → verifier.
- Trigger and skip conditions match ADR-0002 exactly.
- Three exit points, each with a concrete example scenario.
- Return-path protocol with conditions and process.

---

## Test T7: DT Coach Agent Structural Validation

- **Type:** Automated / Manual
- **Task:** Task 7
- **Priority:** Critical

### Setup
- File `.github/agents/dt-coach.agent.md` exists.

### Steps
1. Verify the file contains required structural sections: purpose, tools, read_paths, write_paths, guardrails.
2. Verify agent is self-contained:
   - Run: `grep -rn '\.github/instructions/' .github/agents/dt-coach.agent.md` — expect zero matches.
3. Verify Think/Speak/Empower philosophy is embedded.
4. Verify all nine methods are listed with space assignments.
5. Verify session state path matches ADR-0003: `.copilot-tracking/dt/<WI-ID>/coaching-state.md`.
6. Verify handoff artifact path matches ADR-0003: `docs/workitems/<WI-ID>/artifacts/dt-handoff.md`.
7. Verify handoff target is the `research` agent.
8. Run: `grep -rn 'RPI[^V]' .github/agents/dt-coach.agent.md` — expect zero matches.

### Expected Result
- All structural sections present and non-empty.
- Zero external instruction dependencies.
- Nine methods listed (M1–M9) with correct space labels.
- Paths match ADR-0003.
- RPIV terminology used consistently.

---

## Test T8: AGENTS.md dt-coach Entry Validation

- **Type:** Automated / Manual
- **Task:** Task 8
- **Priority:** Critical

### Setup
- `AGENTS.md` has been updated with the `dt-coach` entry.

### Steps
1. Verify `dt-coach:` key exists in the AGENTS YAML constants block.
2. Verify all required fields are present: `file`, `purpose`, `tools`, `read_paths`, `write_paths`, `guardrails`.
3. Verify `file` value is `.github/agents/dt-coach.agent.md`.
4. Verify `read_paths` and `write_paths` include ADR-0003-compliant paths.
5. Verify no existing agent entries (research, planner, implementer, verifier, onboard-repo, bootstrap) have been modified.
6. Verify the YAML block syntax is valid (proper indentation, no stray characters).

### Expected Result
- `dt-coach` entry is present with all six required fields.
- `file` points to `.github/agents/dt-coach.agent.md`.
- Existing agent entries are byte-identical to their pre-edit state.
- YAML constants block parses without errors.

---

## Test T9: Global RPI→RPIV Terminology Sweep

- **Type:** Automated
- **Task:** Task 9
- **Priority:** Critical

### Setup
- All tasks (1–8) are complete.

### Steps
1. Run: `grep -rn 'RPI[^V]' docs/design-thinking/` — expect zero matches.
2. Run: `grep -rn 'RPI[^V]' .github/agents/dt-coach.agent.md` — expect zero matches.
3. Run: `grep -rn 'Task Researcher\|Task Planner\|Task Implementor\|Task Reviewer' docs/design-thinking/` — expect zero matches.
4. Run: `grep -rn 'Task Researcher\|Task Planner\|Task Implementor\|Task Reviewer' .github/agents/dt-coach.agent.md` — expect zero matches.
5. Run: `grep -rn '\.copilot-tracking/dt/{project-slug}' docs/design-thinking/` — expect zero matches (should use `<WI-ID>`).

### Expected Result
- All five grep commands return zero matches.
- Every adapted file uses RPIV terminology and soft-factory agent names exclusively.

---

## Test T10: Cross-Reference Link Consistency

- **Type:** Manual / Automated
- **Task:** Task 9
- **Priority:** High

### Setup
- All tasks (1–8) are complete.

### Steps
1. Extract all internal Markdown links from files in `docs/design-thinking/`.
2. Verify each link target exists as a file in the repository.
3. Extract all links from `.github/agents/dt-coach.agent.md`.
4. Verify each link target exists.
5. Verify links from DT docs to ADR-0002, ADR-0003, and CORE-COMPONENT-0002 resolve correctly.
6. Verify links from CORE-COMPONENT-0002 back to ADR-0002 resolve.

### Expected Result
- Zero broken internal links across all DT documentation and agent files.
- All cross-references between DT docs, ADRs, and core-components are bidirectionally valid.

---

## Test T11: Confidence Marker Syntax Validation

- **Type:** Automated
- **Task:** Task 9
- **Priority:** Medium

### Setup
- All tasks (1–8) are complete.

### Steps
1. In all files under `docs/design-thinking/` that contain confidence markers, verify that only valid markers are used: `[validated]`, `[assumed]`, `[unknown]`, `[conflicting]`.
2. Run: `grep -rn '\[validated\]\|\[assumed\]\|\[unknown\]\|\[conflicting\]' docs/design-thinking/` — verify matches exist.
3. Check for any marker-like patterns that are not one of the four valid markers (e.g., `[unvalidated]`, `[maybe]`, `[uncertain]`).

### Expected Result
- At least one file in `docs/design-thinking/` uses confidence markers.
- All markers used are one of the four valid types defined in CORE-COMPONENT-0002.
- No invalid or non-standard marker patterns exist.

---

## Test T12: ADR and Core-Component Decision Log Validation

- **Type:** Manual
- **Task:** Task 9
- **Priority:** High

### Setup
- `docs/architecture/ADR/DECISION-LOG.md` has been updated.

### Steps
1. Verify ADR-0002 is listed in the ADRs table with status "Accepted" and date 2026-04-14.
2. Verify ADR-0003 is listed in the ADRs table with status "Accepted" and date 2026-04-14.
3. Verify CORE-COMPONENT-0002 is listed in the Core-Components table with status "Active" and date 2026-04-14.
4. Verify at least one decision record exists for each of ADR-0002, ADR-0003, and CORE-COMPONENT-0002 in the Decisions table.
5. Verify each decision record starts with an imperative verb.
6. Verify each decision record is ≤15 words.

### Expected Result
- Three artifacts listed in their respective tables.
- At least 3 decision records total (minimum one per source artifact).
- All decision records are actionable, imperative-verb-led statements.
