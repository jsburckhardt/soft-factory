# Soft Factory Artifact Contract

This contract defines the canonical artifact locations used by Soft Factory Skills.

## Issue artifacts

| Artifact | Path pattern |
|----------|--------------|
| Research brief | `project/issues/<ISSUE_NUMBER>/research/00-research.md` |
| Action plan | `project/issues/<ISSUE_NUMBER>/plan/01-action-plan.md` |
| Task breakdown | `project/issues/<ISSUE_NUMBER>/plan/02-task-breakdown.md` |
| Test plan | `project/issues/<ISSUE_NUMBER>/plan/03-test-plan.md` |
| Implementation notes | `project/issues/<ISSUE_NUMBER>/implementation/README.md` |
| Verify summary | `project/issues/<ISSUE_NUMBER>/verify/summary.md` |

## Architecture artifacts

| Artifact | Path pattern |
|----------|--------------|
| ADR directory | `project/architecture/ADR/` |
| ADR template | `.github/skills/templates/adr.md` |
| ADR file | `project/architecture/ADR/ADR-####-short-slug.md` |
| Core-component directory | `project/architecture/core-components/` |
| Core-component template | `.github/skills/templates/core-component.md` |
| Core-component file | `project/architecture/core-components/CORE-COMPONENT-####-short-slug.md` |
| Decision log | `project/architecture/ADR/DECISION-LOG.md` |
| Decision log template | `.github/skills/templates/decision-log.md` |

## Rules

- Skills MUST use the GitHub issue number for `<ISSUE_NUMBER>`.
- Skills MUST assign ADR numbers sequentially using `ADR-####-short-slug.md`.
- Skills MUST assign core-component numbers sequentially using `CORE-COMPONENT-####-short-slug.md`.
- Skills MUST update the decision log whenever ADR or core-component artifacts are added or changed.
- Skills MUST treat ADRs and core-components as global artifacts, not issue-scoped artifacts.
- Skills SHOULD prefer this contract over hardcoded artifact path assumptions.
