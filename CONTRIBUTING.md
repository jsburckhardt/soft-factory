# Contributing to This Project

This project uses a staged pipeline to move from idea to production code. Every contribution follows the same flow.

## Pipeline Overview (RPIV)

```
Research → Plan → Implement → Verify
```

Each stage has clear inputs, outputs, and artifact locations. No stage may be skipped.

## How to Start Work on an Issue

For a mission spanning multiple issues, start with the `foreman` agent. It
understands repository/product context, reuses or creates reviewed issue nodes,
and coordinates their dependencies and isolated RPIV workers. Foreman is not a
pipeline stage and never takes over issue execution. See
[the Foreman guide](docs/foreman.md).

1. **Create a GitHub Issue** describing the work to be done.
2. **Run the `rpiv` pipeline** — the full-pipeline coordinator handles each stage in order, starting from the issue number. Research creates `project/work-items/<ISSUE_NUMBER>-<SHORT_DESCRIPTION>/`, and later stages preserve that path. Use individual stage workflows as needed: `rpiv-research`, `rpiv-planner`, `rpiv-implementer`, and `rpiv-verifier`.

## Stage 1 — Research

- The `rpiv-research` workflow fetches the GitHub Issue via `gh issue view`
- Produces `project/work-items/<ISSUE_NUMBER>-<SHORT_DESCRIPTION>/research/00-research.md`
- Classifies `scope_type` as one of: `issue`, `architecture_decision`, `core_component`
- Identifies whether ADRs or core-components are needed
- References existing ADRs and core-components

## Stage 2 — Plan

- The `rpiv-planner` workflow reads the research brief before creating any architectural artifacts
- Creates ADRs in `project/architecture/ADR/` using the ADR template **when the research brief identifies them as needed**
- Creates core-components in `project/architecture/core-components/` using the core-component template **when the research brief identifies them as needed**
- Updates `project/architecture/ADR/DECISION-LOG.md` with every new ADR or core-component
- Produces `project/work-items/<ISSUE_NUMBER>-<SHORT_DESCRIPTION>/plan/01-action-plan.md` with the chosen approach
- Produces `project/work-items/<ISSUE_NUMBER>-<SHORT_DESCRIPTION>/plan/02-task-breakdown.md` with acceptance criteria for every task
- Produces `project/work-items/<ISSUE_NUMBER>-<SHORT_DESCRIPTION>/plan/03-test-plan.md` with full test coverage requirements
- References relevant ADRs and core-components in every task

## Stage 3 — Implement

- The `rpiv-implementer` workflow executes tasks from the task breakdown
- Writes tests as specified in the test plan
- Updates affected README, API, configuration, usage, migration, architecture, operational, and deployment documentation
- Documents implementation notes in `project/work-items/<ISSUE_NUMBER>-<SHORT_DESCRIPTION>/implementation/00-implementation.md`
- Deviations from ADRs or core-components require returning to the Plan stage

## Stage 4 — Verify

- The `rpiv-verifier` workflow runs the full test suite and confirms all tests pass
- Independently verifies affected application documentation matches the committed behavior
- Inspects implementation commits created by Implement; it may commit only its verification summary
- Pushes to a feature branch (`<type>/<ISSUE_NUMBER>-<short-slug>`)
- Opens a pull request with `Closes #<ISSUE_NUMBER>` in the body
- Returns the verified commit and PR URL; Foreman separately evaluates integration and mission outcomes

## Where Artifacts Belong

| Artifact | Location |
|----------|----------|
| Research briefs | `project/work-items/<ISSUE_NUMBER>-<SHORT_DESCRIPTION>/research/00-research.md` |
| Action plans | `project/work-items/<ISSUE_NUMBER>-<SHORT_DESCRIPTION>/plan/01-action-plan.md` |
| Task breakdowns | `project/work-items/<ISSUE_NUMBER>-<SHORT_DESCRIPTION>/plan/02-task-breakdown.md` |
| Test plans | `project/work-items/<ISSUE_NUMBER>-<SHORT_DESCRIPTION>/plan/03-test-plan.md` |
| Implementation notes | `project/work-items/<ISSUE_NUMBER>-<SHORT_DESCRIPTION>/implementation/00-implementation.md` |
| ADRs | `project/architecture/ADR/` (global, not issue-scoped) |
| Core-Components | `project/architecture/core-components/` (global, not issue-scoped) |
| Decision log | `project/architecture/ADR/DECISION-LOG.md` |
| RPIV state and event history (local, ignored) | `project/work-items/<ISSUE_NUMBER>-<SHORT_DESCRIPTION>/{state.json,events.jsonl}` |
| Foreman strategic context and mission graph (local, ignored) | `.foreman/` |
| Isolated worker checkouts (local, ignored) | `.trees/issue-<ISSUE_NUMBER>/` |

## How to Propose ADRs and Core-Components

- **ADRs** capture architectural decisions. Copy `project/architecture/ADR/ADR-260101-template.md` and name the new file `ADR-yymmdd-short-slug.md` using its UTC creation date.
- **Core-Components** capture reusable cross-cutting behavior. Copy `project/architecture/core-components/CORE-COMPONENT-260101-template.md` and name the new file `CORE-COMPONENT-yymmdd-short-slug.md` using its UTC creation date.
- ADRs and core-components are **global** — never scoped to a single work item.
- The full date-and-slug basename is the artifact ID; keep the creation date unchanged after later edits.
- Always update `project/architecture/ADR/DECISION-LOG.md` when adding or modifying an ADR or core-component.

## PR Expectations

- Every PR must reference the GitHub Issue it addresses (`Closes #<ISSUE_NUMBER>`)
- PR titles must follow Conventional Commits format
- ADRs and core-components must be reviewed before implementation begins
- All tests from the test plan must pass
- Implementation must not deviate from approved ADRs or core-components without going back through the Plan stage
