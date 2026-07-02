# 00 Implementation Workflow

This reference defines the required behavior for executing planned implementation tasks.

## Scope

The skill MUST read the task breakdown before implementing.

The skill MUST read the test plan before implementing.

The skill MUST read relevant ADRs and core-components before changing files.

The skill MUST implement within architecture boundaries defined by ADRs and core-components.

The skill MUST return to Plan when implementation requires deviation from an ADR or core-component.

## Task execution

The skill MUST follow task order and respect dependencies.

The skill MUST satisfy the test plan for every implemented task.

The skill MUST NOT skip any test defined in the test plan.

The skill SHOULD make the smallest changes that satisfy the task.

The skill MAY refactor existing code only when required by a task.

## Required outputs

The skill MUST produce implementation notes at `project/issues/<ISSUE_NUMBER>/implementation/README.md`.

The skill MUST load `.github/skills/templates/artifact-contract.md` before deriving artifact paths.

The skill MUST load `.github/skills/templates/implementation-notes.md` before generating implementation notes.

The notes MUST summarize completed tasks, files changed, test results, and any deviations or follow-up risks.

## Success and error outcomes

Success means each planned task is implemented, tested, and recorded in implementation notes.

Error outcomes MUST identify the blocked task, failed test, missing plan artifact, or architecture conflict.
