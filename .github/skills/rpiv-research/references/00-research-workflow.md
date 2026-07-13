# 00 Research Workflow

This reference defines the required behavior for researching a GitHub issue before planning implementation work.

## Scope

The skill MUST fetch the GitHub issue details before producing research output.

The skill MUST inspect existing documentation, architecture records, core-components, and relevant source code.

The skill MUST classify `scope_type` as exactly one of `issue`, `architecture_decision`, or `core_component`.

The skill MUST NOT make architectural decisions.

The skill MUST only propose ADR or core-component titles when the research indicates they are required.

## Required inputs

The user MUST provide a GitHub issue number, URL, or issue reference.

The target issue MUST contain structured acceptance criteria as markdown checkboxes between `ACCEPTANCE_CRITERIA_START` and `ACCEPTANCE_CRITERIA_END` markers, or under an `Acceptance Criteria` heading.

## Required outputs

The skill MUST write `project/issues/<ISSUE_NUMBER>/research/00-research.md`.

The skill MUST load `.github/skills/templates/artifact-contract.md` before deriving the output path.

The skill MUST load `.github/skills/templates/research-brief.md` before generating the research brief.

The research brief MUST include:

- The GitHub issue number and title.
- The scope classification.
- The problem statement.
- Existing repository context.
- Proposed ADRs when applicable.
- Proposed core-components when applicable.
- Acceptance criteria copied from the issue.
- Risks and open questions.

## Guardrails

The skill MUST stop when the issue lacks structured acceptance criteria.

The skill MUST preserve acceptance criteria verbatim in the research brief.

The skill MUST cite existing ADRs and core-components when they are relevant.

The skill SHOULD identify risks, unknowns, and open questions.

## Success and error outcomes

Success means the research brief exists at the expected path and contains the issue acceptance criteria plus scope classification.

Error outcomes MUST state the missing input, missing acceptance criteria, or unavailable repository context that blocked the research.
