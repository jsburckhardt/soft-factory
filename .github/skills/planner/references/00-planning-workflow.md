# 00 Planning Workflow

This reference defines the required behavior for planning work after Research is complete.

## Scope

The skill MUST read `project/issues/<ISSUE_NUMBER>/research/00-research.md` before planning.

The skill MUST create ADRs only in `project/architecture/ADR/`.

The skill MUST create core-components only in `project/architecture/core-components/`.

The skill MUST update `project/architecture/ADR/DECISION-LOG.md` for every ADR or core-component change.

The skill MUST treat ADRs and core-components as global artifacts.

The skill MUST NOT create architecture decisions outside ADRs.

The skill MUST NOT create reusable cross-cutting behavior outside core-components.

## Required outputs

The skill MUST produce:

- `project/issues/<ISSUE_NUMBER>/plan/01-action-plan.md`.
- `project/issues/<ISSUE_NUMBER>/plan/02-task-breakdown.md`.
- `project/issues/<ISSUE_NUMBER>/plan/03-test-plan.md`.

The skill MUST load `.github/skills/templates/artifact-contract.md` before deriving artifact paths.

The skill MUST load `.github/skills/templates/action-plan.md` before generating an action plan.

The skill MUST load `.github/skills/templates/task-breakdown.md` before generating a task breakdown.

The skill MUST load `.github/skills/templates/test-plan.md` before generating a test plan.

The skill MUST load `.github/skills/templates/adr.md` before creating ADR content.

The skill MUST load `.github/skills/templates/core-component.md` before creating core-component content.

The skill MUST load `.github/skills/templates/decision-log.md` before updating the decision log.

Each task MUST include acceptance criteria.

Each task MUST include explicit test coverage requirements.

Each task MUST reference relevant ADRs and core-components.

## Decision log behavior

Each new ADR or core-component MUST add an entry to the relevant decision-log registry.

Each new ADR or core-component MUST add one or more short, actionable decision records.

Decision statements MUST start with an imperative verb.

Decision statements MUST be specific enough for review.

## Success and error outcomes

Success means the action plan, task breakdown, and test plan exist and reference any required architecture artifacts.

Error outcomes MUST identify missing research input, invalid template usage, or missing decision-log updates.
