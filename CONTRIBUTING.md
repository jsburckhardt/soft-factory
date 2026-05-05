# Contributing to This Project

This project uses a staged pipeline to move from idea to production code. Every contribution follows the same flow.

## Pipeline Overview (RPIV)

```
Research → Plan → Implement → Verify
```

Each stage has clear inputs, outputs, and artifact locations. No stage may be skipped.

## How to Start Work on an Issue

1. **Create a GitHub Issue** describing the work to be done.
2. **Run the pipeline** — agents handle each stage in order, starting from the issue number. Agents create the documentation structure automatically under `docs/issues/<ISSUE_NUMBER>/`.

## Stage 1 — Research

- The research agent fetches the GitHub Issue via `gh issue view`
- Produces `docs/issues/<ISSUE_NUMBER>/research/00-research.md`
- Classifies `scope_type` as one of: `issue`, `architecture_decision`, `core_component`
- Identifies whether ADRs or core-components are needed
- References existing ADRs and core-components

## Stage 2 — Plan

- Reads the research brief before creating any architectural artifacts
- Creates ADRs in `docs/architecture/ADR/` using the ADR template
- Creates core-components in `docs/architecture/core-components/` using the core-component template
- Updates `docs/architecture/ADR/DECISION-LOG.md` with every new ADR or core-component
- Produces `docs/issues/<ISSUE_NUMBER>/plan/01-action-plan.md` with the chosen approach
- Produces `docs/issues/<ISSUE_NUMBER>/plan/02-task-breakdown.md` with acceptance criteria for every task
- Produces `docs/issues/<ISSUE_NUMBER>/plan/03-test-plan.md` with full test coverage requirements
- References relevant ADRs and core-components in every task

## Stage 3 — Implement

- Executes tasks from the task breakdown
- Writes tests as specified in the test plan
- Documents implementation notes in `docs/issues/<ISSUE_NUMBER>/implementation/README.md`
- Deviations from ADRs or core-components require returning to the Plan stage

## Stage 4 — Verify

- Runs the full test suite and confirms all tests pass
- Creates logical, atomic commits following [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/)
- Pushes to a feature branch (`<type>/<ISSUE_NUMBER>-<short-slug>`)
- Opens a pull request with `Closes #<ISSUE_NUMBER>` in the body
- Assigns the PR to Copilot for review

## Where Artifacts Belong

| Artifact | Location |
|----------|----------|
| Research briefs | `docs/issues/<ISSUE_NUMBER>/research/00-research.md` |
| Action plans | `docs/issues/<ISSUE_NUMBER>/plan/01-action-plan.md` |
| Task breakdowns | `docs/issues/<ISSUE_NUMBER>/plan/02-task-breakdown.md` |
| Test plans | `docs/issues/<ISSUE_NUMBER>/plan/03-test-plan.md` |
| Implementation notes | `docs/issues/<ISSUE_NUMBER>/implementation/README.md` |
| ADRs | `docs/architecture/ADR/` (global, not issue-scoped) |
| Core-Components | `docs/architecture/core-components/` (global, not issue-scoped) |
| Decision log | `docs/architecture/ADR/DECISION-LOG.md` |

## How to Propose ADRs and Core-Components

- **ADRs** capture architectural decisions. Copy the template from `docs/architecture/ADR/ADR-0001-template.md` and create the new ADR in the same `docs/architecture/ADR/` directory.
- **Core-Components** capture reusable cross-cutting behavior. Copy the template from `docs/architecture/core-components/CORE-COMPONENT-0001-template.md` and create in the same `docs/architecture/core-components/` directory.
- ADRs and core-components are **global** — never scoped to a single issue.
- Always update `docs/architecture/ADR/DECISION-LOG.md` when adding or modifying an ADR or core-component.

## PR Expectations

- Every PR must reference the GitHub Issue it addresses (`Closes #<ISSUE_NUMBER>`)
- PR titles must follow Conventional Commits format
- ADRs and core-components must be reviewed before implementation begins
- All tests from the test plan must pass
- Implementation must not deviate from approved ADRs or core-components without going back through the Plan stage
