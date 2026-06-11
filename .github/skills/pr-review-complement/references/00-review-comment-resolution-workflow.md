# 00 Review Comment Resolution Workflow

This reference defines the required behavior for complementing a pull request reviewer. The workflow is intended for agents working in a GitHub repository with the `gh` CLI available.

## Scope

The agent MUST operate on the current branch and its open pull request.

The agent MUST keep the branch current with `origin/main` before reading or acting on review comments.

The base branch is pinned to `main` for this version. PR-specific base-branch derivation is future work unless implemented with tests.

The agent MUST address open review feedback, verify the result, push updates, and resolve fixed GitHub review threads.

The agent MUST NOT force-push, rewrite branch history, or update `main`, `master`, or the configured base branch directly.

## Preconditions

The agent MUST confirm the current directory is a git worktree.

The agent MUST capture the current branch name before PR discovery, branch sync, or review-thread mutation.

The agent MUST refuse to run from `main`, `master`, or the configured base branch.

The agent MUST confirm `gh` is authenticated before requesting pull request data.

The agent MUST run repository orientation before changing files when `./harness` exists.

The agent MUST check for local uncommitted changes, including dirty-worktree changes, before branch synchronization or review edits.

The agent MUST stop and ask for guidance if local uncommitted changes are unrelated to the review work and would be affected by sync, conflict resolution, or review fixes.

The agent MUST refuse destructive git commands such as force-push, `git reset --hard`, checkout-discard, and history rewriting unless an explicit future workflow revision adds safe, tested handling.

## Branch synchronization

The agent MUST fetch `origin/main` before inspecting pull request comments.

The agent MUST determine whether the current branch is behind or diverged from `origin/main` using `git rev-list --left-right --count HEAD...origin/main` or an equivalent non-rewriting check.

If the branch is already current with `origin/main`, the agent MUST skip merge work and report `Branch sync` as `current`.

If the branch is behind or diverged from `origin/main`, the agent MUST merge `origin/main` before loading review feedback.

If conflicts occur, the agent MUST block review-feedback handling, verification, push, and thread resolution until conflicts are resolved.

When resolving conflicts, the agent MUST preserve the intended branch changes and the latest compatible base behavior.

The agent MUST run applicable repository verification after resolving conflicts.

The agent MUST commit conflict resolutions or sync fixes when the merge produces changes that need to be recorded.

The agent MUST follow repository commit conventions, including required commit trailers.

The agent MUST push the updated branch after verification succeeds.

The agent MUST stop or return to synchronization if push is rejected because the remote branch moved.

The agent MUST use normal `git push` and MUST NOT use force-push.

## Pull request discovery

The agent MUST identify the open pull request for the current branch.

If there is no open pull request for the current branch, the agent MUST report a no-op summary and MUST NOT make review-comment changes.

The agent SHOULD use `gh pr view` or an equivalent GitHub API query to identify the PR number and URL.

The agent MUST derive the GitHub repository owner and name from `gh` before issuing GraphQL review-thread queries.

The agent MUST report a blocked summary when `gh` is missing, unauthenticated, unable to discover repository owner/name, or unable to retrieve GraphQL review-thread data.

## Feedback discovery

The agent MUST read open review threads before deciding that there is no actionable review feedback.

The agent SHOULD read general PR comments and review summaries as context.

The agent MUST distinguish general PR comments from GitHub review threads.

The agent MUST count only unresolved review threads as resolvable feedback.

The agent MUST distinguish unresolved review threads from resolved, outdated, or non-actionable feedback.

The agent SHOULD use GitHub GraphQL review-thread data so thread IDs are available for resolution.

The agent MUST preserve reviewer intent and avoid dismissing feedback just because a thread is difficult or ambiguous.

## Feedback handling

For each unresolved review thread, the agent MUST inspect the referenced file, code, and surrounding implementation before deciding on a response.

If the feedback identifies a valid defect, missing test, documentation gap, or maintainability issue, the agent MUST implement a focused fix.

If the feedback is ambiguous or does not appear to make sense, the agent MUST investigate against the current code and requirements.

If no code change is appropriate, the agent MUST leave at most one concise, non-duplicate PR response explaining the evidence and chosen resolution.

The agent MUST NOT mark a review thread resolved until the feedback is fixed or explicitly answered with a defensible rationale.

The agent MUST NOT incorrectly resolve unrelated threads when feedback is ambiguous, outdated, already resolved, or not tied to a resolvable review thread.

The agent MUST add or update tests when the feedback changes behavior or fixes a defect.

The agent MUST keep fixes scoped to review feedback and directly related sync fallout.

Repeated workflow runs MUST NOT duplicate commits, duplicate PR replies, duplicate thread-resolution mutations, or noisy pushes when `Branch updated` is false.

## Verification and push

The agent MUST use the repository operating surface when one exists.

If `./harness` exists, the agent MUST run `./harness verify --json`.

If no harness exists, the agent MUST use the repository's configured lint, typecheck, test, and build commands.

The agent MUST NOT push updates while verification is failing.

The agent MUST leave review threads unresolved when verification fails, push fails, remote push is rejected, or post-resolution thread-state verification fails.

The agent MUST record verification status in the summary format.

## Resolving review threads

The agent MUST re-query review-thread state immediately before resolving threads.

The agent MUST mark a GitHub review thread as resolved only after addressing that thread.

The agent MUST resolve only still-unresolved fixed threads through the GitHub review-thread mutation.

The agent MUST verify resolved thread state after issuing resolution mutations.

The agent MUST treat repeated resolution attempts as idempotent no-ops when threads are already resolved.

The agent MUST not resolve general PR comments that are not review threads, because GitHub does not expose them as resolvable threads.

The agent SHOULD leave a PR comment when general comments were addressed but cannot be marked resolved.

Stale thread state between review loading and resolution MUST be handled by re-querying before mutation and skipping threads that are already resolved or no longer actionable.

## Summary contract

The workflow summary MUST include `PR` as a string.

The workflow summary MUST include `Branch sync` as one of `current`, `merged`, `conflict-resolved`, `blocked`, or `not-applicable`.

The workflow summary MUST include `Threads reviewed` as an integer.

The workflow summary MUST include `Threads resolved` as an integer.

The workflow summary MUST include `Branch updated` as a boolean.

The workflow summary MUST include `Verification` as a string.

The workflow summary MUST include `Notes` as Markdown.

## Safety and privacy

The agent MUST NOT expose tokens, secrets, raw credentials, raw credential errors, unrelated private review content, or personal data in logs, commits, PR comments, or summaries.

The agent MUST redact credential-like values encountered while debugging.

The agent MUST avoid posting unnecessary source dumps in PR comments.

The agent MUST use concise reviewer-facing comments that explain the fix, test evidence, or rationale.

GitHub owner, repository, PR number, and thread IDs MUST be discovered at runtime rather than hardcoded with sensitive or stale values.

## Accessibility

No UI is introduced by this skill.

If future UI or rendered summary controls are added for this skill, they MUST have visible controls, keyboard reachability, labelled icon-only actions, and correct disabled or unavailable semantics.
