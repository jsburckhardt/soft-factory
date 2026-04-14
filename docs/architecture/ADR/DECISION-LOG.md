# Decision Log

This file is the single registry of all architectural decisions and core-components in the project. Every new or modified ADR or core-component **must** be recorded here.

## ADRs

| ID | Title | Status | Date |
|----|-------|--------|------|
| ADR-0002 | Adopt HVE Design Thinking as an Optional Pre-Research Stage | Accepted | 2026-04-14 |
| ADR-0003 | Hybrid Artifact Storage for Design Thinking Sessions | Accepted | 2026-04-14 |

## Core-Components

| ID | Title | Status | Date |
|----|-------|--------|------|
| CORE-COMPONENT-0002 | Confidence Markers | Active | 2026-04-14 |

## Decisions

Short, actionable statements derived from ADRs and core-components. More than one decision can originate from a single source.

| # | Decision | Source | Date |
|---|----------|--------|------|
| 1 | Adopt HVE Design Thinking as an optional pre-Research stage in the RPIV pipeline | ADR-0002 | 2026-04-14 |
| 2 | Require all DT exits to enter RPIV at the Research stage regardless of exit point | ADR-0002 | 2026-04-14 |
| 3 | Use selective extract + adapt (Option C) for DT content from hve-core | ADR-0002 | 2026-04-14 |
| 4 | Distinguish Verify from Review — Verify runs tests and opens PR, not coaching assessment | ADR-0002 | 2026-04-14 |
| 5 | Store DT session state in `.copilot-tracking/dt/<WI-ID>/coaching-state.md` (gitignored) | ADR-0003 | 2026-04-14 |
| 6 | Commit DT handoff artifacts to `docs/workitems/<WI-ID>/artifacts/dt-handoff.md` | ADR-0003 | 2026-04-14 |
| 7 | Require every factual claim in research briefs to carry a confidence marker | CORE-COMPONENT-0002 | 2026-04-14 |
| 8 | Enforce escalation of `conflicting` markers before creating dependent tasks | CORE-COMPONENT-0002 | 2026-04-14 |
| 9 | Use only four confidence markers: validated, assumed, unknown, conflicting | CORE-COMPONENT-0002 | 2026-04-14 |
