<instructions>
You MUST run verification before git operations.
You MUST validate acceptance criteria before pushing.
You MUST NOT push directly to main or master.
You MUST follow Conventional Commits.
You MUST include the configured co-author trailer on AI-authored commits.
You MUST create a pull request with Closes #<ISSUE_NUMBER>.
You MUST write a verify summary after PR creation.
</instructions>

<constants>
AC_END_MARKER: "<!-- ACCEPTANCE_CRITERIA_END -->"
AC_START_MARKER: "<!-- ACCEPTANCE_CRITERIA_START -->"
ARTIFACT_CONTRACT_PATH: ".github/skills/templates/artifact-contract.md"
CO_AUTHOR_TRAILER: "Co-authored-by: github-copilot[bot] <175728472+github-copilot[bot]@users.noreply.github.com>"
PR_TEMPLATE_PATH: ".github/PULL_REQUEST_TEMPLATE.md"
SUMMARY_PATH: "project/issues/<ISSUE_NUMBER>/verify/summary.md"
VERIFICATION_CONFIG_PATH: ".github/soft-factory/verification.yml"
VERIFY_SUMMARY_TEMPLATE_PATH: ".github/skills/templates/verify-summary.md"
</constants>

<formats>
<format id="VERIFY_REPORT_V1" name="Verify Report" purpose="Summarize verification and shipping results.">
## Verify Report - #<ISSUE_NUMBER>

**Branch:** <BRANCH_NAME>
**PR:** <PR_URL>

### Commits
<COMMIT_LIST>

### Acceptance Criteria
<AC_SUMMARY>

### Verification Results
<VERIFICATION_SUMMARY>

### Status
<STATUS>
WHERE:
- <AC_SUMMARY> is Markdown.
- <BRANCH_NAME> is String.
- <COMMIT_LIST> is Markdown.
- <ISSUE_NUMBER> is String.
- <PR_URL> is URI.
- <STATUS> is String.
- <VERIFICATION_SUMMARY> is Markdown.
</format>
</formats>

<runtime>
ACCEPTANCE_CRITERIA: []
AC_VALIDATION_RESULTS: []
ARTIFACT_CONTRACT: ""
BRANCH_NAME: ""
COMMITS: []
CURRENT_BRANCH: ""
ISSUE_NUMBER: ""
ISSUE_BODY: ""
PR_TITLE: ""
PR_URL: ""
VERIFICATION_RESULTS: []
VERIFY_SUMMARY_TEMPLATE: ""
</runtime>

<triggers>
<trigger event="user_message" target="verify-delivery" />
</triggers>

<processes>
<process id="verify-delivery" name="Verify and ship issue work">
RUN `load-verification`
RUN `run-verification`
RUN `fetch-acceptance-criteria`
RUN `validate-acceptance-criteria`
RUN `prepare-branch`
RUN `commit-changes`
RUN `push-branch`
RUN `create-pull-request`
RUN `write-summary`
RUN `update-issue-criteria`
RETURN: format="VERIFY_REPORT_V1", ac_summary=AC_VALIDATION_RESULTS, branch_name=BRANCH_NAME, commit_list=COMMITS, issue_number=ISSUE_NUMBER, pr_url=PR_URL, status="Verified and shipped", verification_summary=VERIFICATION_RESULTS
</process>

<process id="load-verification" name="Load verification commands">
SET ISSUE_NUMBER := <ID> (from "Agent Inference" using USER_INPUT)
USE `Read` where: path=VERIFICATION_CONFIG_PATH
CAPTURE VERIFICATION_CONFIG from `Read`
USE `Read` where: path=ARTIFACT_CONTRACT_PATH
CAPTURE ARTIFACT_CONTRACT from `Read`
USE `Read` where: path=VERIFY_SUMMARY_TEMPLATE_PATH
CAPTURE VERIFY_SUMMARY_TEMPLATE from `Read`
SET VERIFICATION_COMMANDS := <COMMANDS> (from "Agent Inference" using VERIFICATION_CONFIG)
</process>

<process id="run-verification" name="Run verification commands">
FOREACH step IN VERIFICATION_COMMANDS:
  USE `Shell` where: command=step.command
  CAPTURE STEP_OUTPUT from `Shell`
  SET STEP_RESULT := <RESULT> (from "Agent Inference" using STEP_OUTPUT)
  SET VERIFICATION_RESULTS := VERIFICATION_RESULTS + [{step: step, result: STEP_RESULT}] (from "Agent Inference")
  IF STEP_RESULT is false:
    RETURN: error="Verification failed"
</process>

<process id="fetch-acceptance-criteria" name="Fetch acceptance criteria">
USE `Shell` where: command="gh issue view <ISSUE_NUMBER> --json body --jq '.body'"
CAPTURE ISSUE_BODY from `Shell`
SET ACCEPTANCE_CRITERIA := <CRITERIA> (from "Agent Inference" using ISSUE_BODY, AC_END_MARKER, AC_START_MARKER)
IF ACCEPTANCE_CRITERIA is empty:
  RETURN: error="No acceptance criteria found"
</process>

<process id="validate-acceptance-criteria" name="Validate acceptance criteria">
SET AC_VALIDATION_RESULTS := <RESULTS> (from "Agent Inference" using ACCEPTANCE_CRITERIA, VERIFICATION_RESULTS)
IF AC_VALIDATION_RESULTS contains "failed":
  RETURN: error="Acceptance criteria validation failed"
</process>

<process id="prepare-branch" name="Prepare branch">
USE `Shell` where: command="git branch --show-current"
CAPTURE CURRENT_BRANCH from `Shell`
SET BRANCH_NAME := <BRANCH> (from "Agent Inference" using CURRENT_BRANCH, ISSUE_NUMBER)
</process>

<process id="commit-changes" name="Commit related changes">
SET COMMIT_GROUPS := <GROUPS> (from "Agent Inference" using ISSUE_NUMBER)
FOREACH group IN COMMIT_GROUPS:
  USE `Shell` where: command="git add <group.files> && git commit -m '<group.message>' -m '' -m '<CO_AUTHOR_TRAILER>'"
  CAPTURE COMMIT_OUTPUT from `Shell`
  SET COMMITS := COMMITS + [COMMIT_OUTPUT] (from "Agent Inference")
</process>

<process id="push-branch" name="Push branch">
USE `Shell` where: command="git push -u origin <BRANCH_NAME>"
</process>

<process id="create-pull-request" name="Create pull request">
USE `Read` where: path=PR_TEMPLATE_PATH
CAPTURE PR_TEMPLATE from `Read`
SET PR_TITLE := <TITLE> (from "Agent Inference" using ISSUE_NUMBER)
SET PR_BODY := <BODY> (from "Agent Inference" using PR_TEMPLATE, ISSUE_NUMBER, AC_VALIDATION_RESULTS, VERIFICATION_RESULTS)
USE `Write` where: content=PR_BODY, path="/tmp/pr-body.md"
USE `Shell` where: command="gh pr create --title '<PR_TITLE>' --body-file /tmp/pr-body.md"
CAPTURE PR_OUTPUT from `Shell`
SET PR_URL := <URL> (from "Agent Inference" using PR_OUTPUT)
</process>

<process id="write-summary" name="Write verify summary">
SET SUMMARY := <SUMMARY> (from "Agent Inference" using ARTIFACT_CONTRACT, BRANCH_NAME, ISSUE_NUMBER, PR_TITLE, PR_URL, COMMITS, AC_VALIDATION_RESULTS, VERIFICATION_RESULTS, VERIFY_SUMMARY_TEMPLATE)
USE `Write` where: content=SUMMARY, path=SUMMARY_PATH
</process>

<process id="update-issue-criteria" name="Update issue acceptance criteria">
SET UPDATED_BODY := <BODY> (from "Agent Inference" using ISSUE_BODY, AC_VALIDATION_RESULTS)
USE `Write` where: content=UPDATED_BODY, path="/tmp/issue-body.md"
USE `Shell` where: command="gh issue edit <ISSUE_NUMBER> --body-file /tmp/issue-body.md"
</process>
</processes>

<input>
USER_INPUT is the GitHub issue number and optional verification instructions.
</input>
