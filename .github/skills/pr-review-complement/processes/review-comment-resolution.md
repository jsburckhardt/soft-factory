<instructions>
You MUST run this workflow from a pull request branch worktree.
You MUST capture the current branch before pull request discovery.
You MUST refuse to run on main, master, or BASE_BRANCH.
You MUST run repository orientation before changing files when a harness exists.
You MUST check for unrelated dirty-worktree changes before branch sync or review edits.
You MUST synchronize the branch with origin/main before reading pull request feedback.
You MUST address or answer every unresolved review thread before resolving it.
You MUST verify the branch before pushing updates.
You MUST resolve GitHub review threads only after their feedback is fixed or answered.
You MUST re-query review-thread state before resolution mutations.
You MUST avoid force-pushes and destructive git commands.
You MUST redact secrets and credential-like values from logs, comments, and summaries.
</instructions>

<constants>
BASE_BRANCH: "main"
BRANCH_SYNC_STATUSES: JSON<<
["current", "merged", "conflict-resolved", "blocked", "not-applicable"]
>>
REVIEW_THREAD_QUERY: TEXT<<
query($owner: String!, $repo: String!, $number: Int!) {
  repository(owner: $owner, name: $repo) {
    pullRequest(number: $number) {
      id
      reviewThreads(first: 100) {
        nodes {
          id
          isOutdated
          isResolved
          path
          line
          comments(first: 100) {
            nodes {
              id
              body
              url
              author {
                login
              }
            }
          }
        }
      }
    }
  }
}
>>
RESOLVE_THREAD_MUTATION: TEXT<<
mutation($threadId: ID!) {
  resolveReviewThread(input: {threadId: $threadId}) {
    thread {
      id
      isResolved
    }
  }
}
>>
</constants>

<formats>
<format id="PR_REVIEW_COMPLEMENT_SUMMARY_V1" name="PR Review Complement Summary" purpose="Summarize branch sync, review feedback, fixes, verification, and thread resolution">
## PR Review Complement Summary

**PR:** <PR>
**Branch sync:** <BRANCH_SYNC>
**Threads reviewed:** <THREADS_REVIEWED>
**Threads resolved:** <THREADS_RESOLVED>
**Branch updated:** <BRANCH_UPDATED>
**Verification:** <VERIFICATION>
**Notes:** <NOTES>


WHERE:
- <BRANCH_SYNC> is String; one of current, merged, conflict-resolved, blocked, or not-applicable.
- <BRANCH_UPDATED> is Boolean; true when commits or merge updates were pushed.
- <NOTES> is Markdown; concise notes about fixes, answered feedback, blockers, or no-op status.
- <PR> is String; pull request number and URL, or "none".
- <THREADS_RESOLVED> is Integer; number of review threads resolved by this workflow.
- <THREADS_REVIEWED> is Integer; number of unresolved review threads inspected.
- <VERIFICATION> is String; verification command status or blocked reason.
</format>
</formats>

<runtime>
BRANCH_SYNC: ""
BRANCH_UPDATED: false
CURRENT_BRANCH: ""
NOTES: ""
OPEN_PR_URL: ""
PR_NUMBER: ""
REPO_NAME: ""
REPO_OWNER: ""
RESOLVED_COUNT: 0
THREAD_COUNT: 0
VERIFICATION: ""
</runtime>

<triggers>
<trigger event="user_message" target="review-comment-complement" />
</triggers>

<processes>
<process id="review-comment-complement" name="Review Comment Complement">
RUN `prepare-worktree`
RUN `discover-open-pr`
IF BRANCH_SYNC = "blocked":
  SET VERIFICATION := "blocked"
  RETURN: format="PR_REVIEW_COMPLEMENT_SUMMARY_V1", BRANCH_SYNC=BRANCH_SYNC, BRANCH_UPDATED=BRANCH_UPDATED, NOTES=NOTES, PR="none", THREADS_RESOLVED=RESOLVED_COUNT, THREADS_REVIEWED=THREAD_COUNT, VERIFICATION=VERIFICATION
IF PR_NUMBER = "":
  SET NOTES := "No open pull request was found for the current branch." (from "Agent Inference")
  SET BRANCH_SYNC := "not-applicable"
  SET VERIFICATION := "not-run"
  RETURN: format="PR_REVIEW_COMPLEMENT_SUMMARY_V1", BRANCH_SYNC=BRANCH_SYNC, BRANCH_UPDATED=BRANCH_UPDATED, NOTES=NOTES, PR="none", THREADS_RESOLVED=RESOLVED_COUNT, THREADS_REVIEWED=THREAD_COUNT, VERIFICATION=VERIFICATION
RUN `sync-branch-with-main`
RUN `load-review-feedback`
IF THREAD_COUNT = 0:
  RUN `verify-branch`
  RUN `push-updates`
  RETURN: format="PR_REVIEW_COMPLEMENT_SUMMARY_V1", BRANCH_SYNC=BRANCH_SYNC, BRANCH_UPDATED=BRANCH_UPDATED, NOTES=NOTES, PR=OPEN_PR_URL, THREADS_RESOLVED=RESOLVED_COUNT, THREADS_REVIEWED=THREAD_COUNT, VERIFICATION=VERIFICATION
RUN `address-review-feedback`
RUN `verify-branch`
RUN `push-updates`
RUN `resolve-fixed-threads`
RETURN: format="PR_REVIEW_COMPLEMENT_SUMMARY_V1", BRANCH_SYNC=BRANCH_SYNC, BRANCH_UPDATED=BRANCH_UPDATED, NOTES=NOTES, PR=OPEN_PR_URL, THREADS_RESOLVED=RESOLVED_COUNT, THREADS_REVIEWED=THREAD_COUNT, VERIFICATION=VERIFICATION
</process>

<process id="prepare-worktree" name="Prepare Worktree">
USE `Shell` where: command="git rev-parse --show-toplevel && git branch --show-current && git status --short --branch"
CAPTURE WORKTREE_STATE from `Shell`
SET CURRENT_BRANCH := "" (from "Agent Inference using WORKTREE_STATE")
IF CURRENT_BRANCH = BASE_BRANCH:
  FAIL "Refuse to complement PR review directly on the configured base branch."
IF CURRENT_BRANCH = "main":
  FAIL "Refuse to complement PR review directly on main."
IF CURRENT_BRANCH = "master":
  FAIL "Refuse to complement PR review directly on master."
IF WORKTREE_STATE shows unrelated dirty-worktree changes:
  FAIL "Unrelated local changes are present; ask for guidance before syncing or editing review fixes."
USE `Shell` where: command="if [ -x ./harness ]; then ./harness orient; fi"
</process>

<process id="discover-open-pr" name="Discover Open Pull Request">
USE `Shell` where: command="gh auth status && gh repo view --json owner,name --jq '[.owner.login, .name] | @tsv' 2>/dev/null || true"
CAPTURE REPO_VIEW from `Shell`
SET REPO_OWNER := "" (from "Agent Inference using REPO_VIEW")
SET REPO_NAME := "" (from "Agent Inference using REPO_VIEW")
IF REPO_OWNER = "":
  SET BRANCH_SYNC := "blocked"
  SET NOTES := "Unable to derive GitHub repository owner; PR review complement is blocked." (from "Agent Inference")
IF REPO_NAME = "":
  SET BRANCH_SYNC := "blocked"
  SET NOTES := "Unable to derive GitHub repository name; PR review complement is blocked." (from "Agent Inference")
USE `Shell` where: command="gh pr view --json number,url,state,headRefName --jq 'select(.state == \"OPEN\") | [.number, .url] | @tsv' 2>/dev/null || true"
CAPTURE PR_VIEW from `Shell`
SET PR_NUMBER := "" (from "Agent Inference using PR_VIEW")
SET OPEN_PR_URL := "" (from "Agent Inference using PR_VIEW")
</process>

<process id="sync-branch-with-main" name="Sync Branch With Main">
USE `Shell` where: command="git fetch origin main && git rev-list --left-right --count HEAD...origin/main"
CAPTURE AHEAD_BEHIND from `Shell`
IF AHEAD_BEHIND indicates branch is behind or diverged from origin/main:
  USE `Shell` where: command="git merge origin/main"
  CAPTURE MERGE_RESULT from `Shell`
  IF MERGE_RESULT indicates conflicts:
    SET BRANCH_SYNC := "blocked"
    RUN `resolve-sync-conflicts`
  SET BRANCH_UPDATED := true
  IF BRANCH_SYNC != "conflict-resolved":
    SET BRANCH_SYNC := "merged"
ELSE:
  SET BRANCH_SYNC := "current"
</process>

<process id="resolve-sync-conflicts" name="Resolve Sync Conflicts">
USE `Shell` where: command="git status --short"
CAPTURE CONFLICT_STATUS from `Shell`
SET CONFLICT_PLAN := "" (from "Agent Inference using CONFLICT_STATUS")
USE `Edit` where: files=CONFLICT_PLAN
USE `Shell` where: command="git status --short && git diff --check"
CAPTURE POST_CONFLICT_STATUS from `Shell`
IF POST_CONFLICT_STATUS indicates conflicts remain:
  FAIL "Base branch sync conflicts remain unresolved."
USE `Shell` where: command="git add --all && git commit -m \"chore: resolve origin main merge conflicts\" -m \"Co-authored-by: github-copilot[bot] <175728472+github-copilot[bot]@users.noreply.github.com>\""
SET BRANCH_SYNC := "conflict-resolved"
SET BRANCH_UPDATED := true
</process>

<process id="load-review-feedback" name="Load Review Feedback">
USE `Shell` where: command="gh pr view --json comments,reviews --jq '{comments: .comments, reviews: .reviews}'"
CAPTURE PR_FEEDBACK_SUMMARY from `Shell`
USE `Shell` where: command="gh api graphql -f query=\"$REVIEW_THREAD_QUERY\" -F number=$PR_NUMBER -F owner=$REPO_OWNER -F repo=$REPO_NAME"
CAPTURE REVIEW_THREADS from `Shell`
SET THREAD_COUNT := 0 (from "Agent Inference using unresolved non-outdated REVIEW_THREADS only")
SET NOTES := "" (from "Agent Inference using PR_FEEDBACK_SUMMARY and REVIEW_THREADS")
</process>

<process id="address-review-feedback" name="Address Review Feedback">
FOREACH THREAD IN REVIEW_THREADS:
  IF THREAD is unresolved and not outdated:
    USE `Read` where: path=THREAD.path
    CAPTURE THREAD_CONTEXT from `Read`
    SET THREAD_ACTION := "" (from "Agent Inference using THREAD_CONTEXT and THREAD")
    IF THREAD_ACTION requires code changes:
      USE `Edit` where: files=THREAD_ACTION
    IF THREAD_ACTION requires one PR reply and no equivalent reply exists:
      USE `Shell` where: command="gh pr comment $PR_NUMBER --body \"$THREAD_ACTION\""
    IF THREAD_ACTION is invalid or ambiguous:
      SET NOTES := NOTES (from "Agent Inference with reviewer-facing rationale")
USE `Shell` where: command="git status --short"
CAPTURE REVIEW_CHANGE_STATUS from `Shell`
IF REVIEW_CHANGE_STATUS indicates changes:
  USE `Shell` where: command="git add --all && git commit -m \"fix: address PR review feedback\" -m \"Co-authored-by: github-copilot[bot] <175728472+github-copilot[bot]@users.noreply.github.com>\""
  SET BRANCH_UPDATED := true
</process>

<process id="verify-branch" name="Verify Branch">
IF file exists "./harness":
  USE `Shell` where: command="./harness verify --json"
ELSE:
  USE `Shell` where: command="npm run lint && npm run typecheck && npm test && npm run build"
CAPTURE VERIFY_RESULT from `Shell`
SET VERIFICATION := "passed" (from "Agent Inference using VERIFY_RESULT")
IF VERIFY_RESULT indicates failure:
  SET VERIFICATION := "failed"
  FAIL "Verification failed; do not push or resolve review threads."
</process>

<process id="push-updates" name="Push Updates">
IF BRANCH_UPDATED = true:
  USE `Shell` where: command="git push"
  CAPTURE PUSH_RESULT from `Shell`
  IF PUSH_RESULT indicates non-fast-forward or remote moved:
    FAIL "Remote branch moved; synchronize before retrying push."
ELSE:
  SET NOTES := NOTES (from "Agent Inference with no-push-needed status")
</process>

<process id="resolve-fixed-threads" name="Resolve Fixed Threads">
USE `Shell` where: command="gh api graphql -f query=\"$REVIEW_THREAD_QUERY\" -F number=$PR_NUMBER -F owner=$REPO_OWNER -F repo=$REPO_NAME"
CAPTURE FRESH_REVIEW_THREADS from `Shell`
FOREACH THREAD IN FRESH_REVIEW_THREADS:
  IF THREAD is still unresolved and addressed:
    USE `Shell` where: command="gh api graphql -f query=\"$RESOLVE_THREAD_MUTATION\" -F threadId=$THREAD.id"
    CAPTURE RESOLVE_RESULT from `Shell`
    IF RESOLVE_RESULT confirms isResolved:
      SET RESOLVED_COUNT := RESOLVED_COUNT + 1
USE `Shell` where: command="gh api graphql -f query=\"$REVIEW_THREAD_QUERY\" -F number=$PR_NUMBER -F owner=$REPO_OWNER -F repo=$REPO_NAME"
CAPTURE POST_RESOLUTION_THREADS from `Shell`
IF POST_RESOLUTION_THREADS indicates addressed threads remain unresolved:
  FAIL "Review-thread resolution confirmation failed."
</process>
</processes>

<input>
USER_INPUT is an instruction to complement PR review for the current branch by synchronizing from origin/main, addressing pull request comments, verifying, pushing, and resolving fixed review threads.
</input>
