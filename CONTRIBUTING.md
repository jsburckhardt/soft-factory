# Contributing to This Project

This project uses a staged pipeline to move from idea to production code. Every contribution follows the same flow.

## Pipeline Overview

```
Research → Architect → Plan → Implement
```

Each stage has clear inputs, outputs, and artifact locations. No stage may be skipped.

## How to Start a Workitem

1. **Create a workitem folder** using the naming convention `WI-####-short-slug`:
   ```
   docs/workitems/WI-0002-your-feature/
   ```

2. **Create the subfolder structure**:
   ```
   research/
   plan/
   implementation/
   artifacts/
   ```

3. **Run the pipeline** by completing each stage in order.

## Stage 1 — Research

- Write `research/00-research.md` using the research template fields
- Classify the `scope_type` as one of: `workitem`, `architecture_decision`, `core_component`
- Identify whether ADRs or core-components are needed
- Reference existing ADRs and core-components

## Stage 2 — Architect

- Create ADRs in `docs/architecture/ADR/` using the ADR template
- Create core-components in `docs/architecture/core-components/` using the core-component template
- Update `docs/architecture/ADR/DECISION-LOG.md` with every new ADR or core-component
- Write `plan/01-action-plan.md` with the chosen approach

## Stage 3 — Plan

- Write `plan/02-task-breakdown.md` with acceptance criteria for every task
- Write `plan/03-test-plan.md` with full test coverage requirements
- Reference relevant ADRs and core-components in every task

## Stage 4 — Implement

- Execute tasks from the task breakdown
- Write tests as specified in the test plan
- Document implementation notes in `implementation/README.md`
- Deviations from ADRs or core-components require returning to the Architect stage

## Where Artifacts Belong

| Artifact | Location |
|----------|----------|
| Research briefs | `docs/workitems/<WI-ID>/research/` |
| Action plans | `docs/workitems/<WI-ID>/plan/01-action-plan.md` |
| Task breakdowns | `docs/workitems/<WI-ID>/plan/02-task-breakdown.md` |
| Test plans | `docs/workitems/<WI-ID>/plan/03-test-plan.md` |
| ADRs | `docs/architecture/ADR/` |
| Core-Components | `docs/architecture/core-components/` |
| Decision log | `docs/architecture/ADR/DECISION-LOG.md` |
| Implementation notes | `docs/workitems/<WI-ID>/implementation/` |

## How to Propose ADRs and Core-Components

- **ADRs** capture architectural decisions. Copy the template from `docs/architecture/ADR/ADR-0001-template.md` and create the new ADR in the same `docs/architecture/ADR/` directory.
- **Core-Components** capture reusable cross-cutting behavior. Copy the template from `docs/architecture/core-components/CORE-COMPONENT-0001-template.md` and create in the same `docs/architecture/core-components/` directory.
- Always update `docs/architecture/ADR/DECISION-LOG.md` when adding or modifying an ADR or core-component.

## PR Expectations

- Every PR must reference the workitem it belongs to
- ADRs and core-components must be reviewed before implementation begins
- All tests from the test plan must pass
- Implementation must not deviate from approved ADRs or core-components without going back through the Architect stage
