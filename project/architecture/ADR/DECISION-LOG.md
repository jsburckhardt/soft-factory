# Decision Log

This file is the single registry of all architectural decisions and core-components in the project. Every new or modified ADR or core-component **must** be recorded here.

## ADRs

| ID | Title | Status | Date |
|----|-------|--------|------|
| _No ADRs yet. Copy `ADR-0001-template.md` in this directory and rename it._ | | | |

## Core-Components

| ID | Title | Status | Date |
|----|-------|--------|------|
| CORE-COMPONENT-0002 | Commit Standards | Adopted | 2026-05-05 |
| CORE-COMPONENT-0003 | RPIV Stage Contract | Adopted | 2026-08-06 |
| CORE-COMPONENT-0004 | Project Command Interface | Adopted | 2026-08-06 |
| CORE-COMPONENT-0005 | Agent-Executable Acceptance Criteria | Adopted | 2026-08-06 |

## Decisions

Short, actionable statements derived from ADRs and core-components. More than one decision can originate from a single source.

| # | Decision | Source | Date |
|---|----------|--------|------|
| 1 | Enforce Conventional Commits v1.0.0 on every commit message | CORE-COMPONENT-0002 | 2026-05-05 |
| 2 | Require Conventional Commits format on PR titles | CORE-COMPONENT-0002 | 2026-05-05 |
| 3 | Require Co-authored-by trailer on all AI-authored commits | CORE-COMPONENT-0002 | 2026-05-05 |
| 4 | Require the RPIV implementer to commit implementation before verification | CORE-COMPONENT-0002 | 2026-08-06 |
| 5 | Create the issue feature branch before RPIV Research starts | CORE-COMPONENT-0003 | 2026-08-06 |
| 6 | Assign stable AC IDs and prove task, validation, and evidence coverage | CORE-COMPONENT-0003 | 2026-08-06 |
| 7 | Use the harness contract for Implement and Verify validation | CORE-COMPONENT-0003 | 2026-08-06 |
| 8 | Restrict Verify to acceptance decisions, GitHub updates, push, and PR creation | CORE-COMPONENT-0003 | 2026-08-06 |
| 9 | Route verification defects to Implement or Plan by ownership | CORE-COMPONENT-0003 | 2026-08-06 |
| 10 | Define project operating commands as root justfile recipes | CORE-COMPONENT-0004 | 2026-08-06 |
| 11 | Expose project commands through the repo-local harness | CORE-COMPONENT-0004 | 2026-08-06 |
| 12 | Provide the just command runner in project development environments | CORE-COMPONENT-0004 | 2026-08-06 |
| 13 | Remove the legacy verification config after harness migration | CORE-COMPONENT-0004 | 2026-08-06 |
| 14 | Read friction before and record friction after every RPIV stage | CORE-COMPONENT-0003 | 2026-08-06 |
| 15 | Require phase-aware JSON friction commands in the harness | CORE-COMPONENT-0004 | 2026-08-06 |
| 16 | Require acceptance criteria to be bounded, observable, and executable by configured agents | CORE-COMPONENT-0005 | 2026-08-06 |
| 17 | Require acceptance evidence to use safe, repeatable repository or harness capabilities | CORE-COMPONENT-0005 | 2026-08-06 |
| 18 | Identify unavailable human or external prerequisites instead of encoding impossible agent tasks | CORE-COMPONENT-0005 | 2026-08-06 |
