# Issues

This directory contains per-issue documentation produced by the RPIV pipeline. Each subdirectory maps to a **GitHub Issue** by number.

## Canonical Structure

When an agent runs the pipeline for GitHub Issue `#42`, it creates:

```
docs/issues/42/
  research/
    00-research.md          ← Research brief (scope classification, findings)
  plan/
    01-action-plan.md       ← Chosen approach, non-goals, acceptance criteria
    02-task-breakdown.md    ← Tasks with acceptance criteria and test requirements
    03-test-plan.md         ← Full test coverage requirements
  implementation/
    README.md               ← Implementation notes and decisions made during coding
```

## Conventions

- Subdirectory names are plain issue numbers (e.g., `42/`, not `WI-0042-slug/`)
- Agents create these directories automatically — do not create them manually
- ADRs and core-components are **global** and live under `docs/architecture/`, never inside an issue folder
- Templates are defined in the agent specifications, not duplicated here
