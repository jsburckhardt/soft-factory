# 00 RPIV Pipeline Workflow

This reference defines the required behavior for executing a GitHub issue through the full Soft Factory RPIV pipeline.

## Scope

The skill MUST read `AGENTS.md` before starting.

The skill MUST read `project/architecture/ADR/DECISION-LOG.md` before starting.

The skill MUST inspect documentation under `docs/` and `project/`.

The skill MUST identify the GitHub issue number before dispatching stages.

The skill MUST load `.github/skills/templates/artifact-contract.md` before checking stage output artifacts.

The skill MUST execute stages in strict order: Research, Plan, Implement, Verify.

The skill MUST NOT skip any stage.

The skill MUST NOT make architectural decisions directly.

The skill MUST NOT modify application source code directly.

## Acceptance criteria requirement

The skill MUST validate that the GitHub issue contains structured acceptance criteria before dispatching Research.

If acceptance criteria are absent, the skill MUST stop and instruct the user to create or update the issue with structured criteria.

## Stage orchestration

The skill MUST dispatch each stage to its corresponding workflow.

The skill MUST verify each stage output artifact exists before proceeding.

The skill MUST summarize each stage result before moving to the next stage.

The skill MAY retry a failed stage once before reporting an error.

## Success and error outcomes

Success means all four stages complete and the final verification result is available.

Error outcomes MUST identify the failed stage, the reason, and the recovery action.
