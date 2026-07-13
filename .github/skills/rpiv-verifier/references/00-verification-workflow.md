# 00 Verification Workflow

This reference defines the required behavior for verifying and shipping completed issue work.

## Scope

The skill MUST run configured verification commands before git operations.

The skill MUST load `.github/soft-factory/verification.yml` when it exists.

The skill MUST fall back to repository auto-detection when verification config is absent.

The skill MUST stop when any verification step fails.

The skill MUST NOT push directly to `main` or `master`.

## Acceptance criteria

The skill MUST fetch the GitHub issue body.

The skill MUST parse acceptance criteria from `ACCEPTANCE_CRITERIA_START` and `ACCEPTANCE_CRITERIA_END` markers, or from checkbox items under an `Acceptance Criteria` heading.

The skill MUST validate each criterion against concrete evidence.

The skill MUST NOT push or create a PR when any criterion fails.

The skill MUST update the GitHub issue body after PR creation to mark satisfied criteria as checked.

## Git and PR behavior

The skill MUST create or use a feature branch.

The skill MUST stage only files related to the current issue.

The skill MUST use Conventional Commits for commit messages and PR title.

The skill MUST include the configured co-author trailer on AI-authored commits.

The skill MUST push the branch and create a pull request using the PR template.

The PR body MUST contain `Closes #<ISSUE_NUMBER>`.

## Required outputs

The skill MUST write `project/issues/<ISSUE_NUMBER>/verify/summary.md` after PR creation.

The skill MUST load `.github/skills/templates/artifact-contract.md` before deriving artifact paths.

The skill MUST load `.github/skills/templates/verify-summary.md` before generating the verify summary.

The summary MUST avoid secrets, tokens, environment variables, raw command output, and absolute local filesystem paths.

## Success and error outcomes

Success means verification passes, criteria are validated, commits are created, a PR is opened, and a summary is written.

Error outcomes MUST identify the verification, authentication, acceptance criteria, git, push, PR, or summary step that blocked delivery.
