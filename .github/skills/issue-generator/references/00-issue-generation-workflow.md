# 00 Issue Generation Workflow

This reference defines the required behavior for creating problem-focused GitHub issues for the RPIV pipeline.

## Scope

The skill MUST read `AGENTS.md` and `project/architecture/ADR/DECISION-LOG.md` before drafting.

The skill MUST read existing issue documentation under `project/issues/`.

The skill MUST run repository history analysis to identify issue-quality gaps.

The skill MUST use history findings only to sharpen the problem statement and acceptance criteria.

The skill MUST structure every issue with only `Problem` and `Acceptance Criteria` sections.

The skill MUST NOT include proposed solutions, implementation plans, architecture decisions, technology choices, dependency choices, API designs, file paths, or test-framework prescriptions unless the user provided them as problem context.

## Acceptance criteria format

The skill MUST format every acceptance criterion as an unchecked markdown checkbox.

The skill MUST wrap criteria with `ACCEPTANCE_CRITERIA_START` and `ACCEPTANCE_CRITERIA_END` markers.

The skill MUST place exactly one start marker and one end marker.

The skill MUST allow only checkbox list items and optional group headings between the markers.

The skill MUST group criteria under headings such as `Core`, `Edge Cases`, and `Verification`.

## Rubber-duck review

The skill MUST dispatch a rubber-duck review before creating the issue.

The skill MUST incorporate rubber-duck feedback before creating the issue.

The skill MUST NOT create an issue without rubber-duck review.

## Success and error outcomes

Success means the GitHub issue is created and the created issue URL and number are reported.

Error outcomes MUST identify missing context, failed review, or failed GitHub issue creation.
