<instructions>
You MUST read repository context before drafting.
You MUST draft only Problem and Acceptance Criteria sections.
You MUST keep acceptance criteria observable and solution-neutral.
You MUST dispatch rubber-duck review before creating the issue.
You MUST incorporate rubber-duck feedback.
You MUST create the GitHub issue only after approval.
</instructions>

<constants>
DECISION_LOG_PATH: "project/architecture/ADR/DECISION-LOG.md"
ISSUES_DIR: "project/issues"
MAX_REVISIONS: 2
</constants>

<formats>
<format id="ISSUE_CREATED_V1" name="Issue Created" purpose="Confirm GitHub issue creation.">
## Issue Created

**Title:** <ISSUE_TITLE>
**URL:** <ISSUE_URL>
**Number:** #<ISSUE_NUMBER>

### Rubber-Duck Review
<REVIEW_SUMMARY>
WHERE:
- <ISSUE_NUMBER> is String.
- <ISSUE_TITLE> is String.
- <ISSUE_URL> is URI.
- <REVIEW_SUMMARY> is String.
</format>
</formats>

<runtime>
DRAFT_BODY: ""
DRAFT_TITLE: ""
FEATURE_DESCRIPTION: ""
ISSUE_NUMBER: ""
ISSUE_URL: ""
REVISION_COUNT: 0
RUBBER_DUCK_OK: false
RUBBER_DUCK_RESULT: ""
</runtime>

<triggers>
<trigger event="user_message" target="generate-issue" />
</triggers>

<processes>
<process id="generate-issue" name="Generate problem-focused issue">
RUN `analyze-context`
RUN `analyze-history`
RUN `draft-issue`
RUN `rubber-duck-review`
IF RUBBER_DUCK_OK is false:
  RUN `revise-draft`
RUN `create-issue`
RETURN: format="ISSUE_CREATED_V1", issue_number=ISSUE_NUMBER, issue_title=DRAFT_TITLE, issue_url=ISSUE_URL, review_summary=RUBBER_DUCK_RESULT
</process>

<process id="analyze-context" name="Read project context">
USE `Read` where: path=DECISION_LOG_PATH
CAPTURE DECISION_LOG from `Read`
USE `Read` where: path="AGENTS.md"
CAPTURE AGENTS_SPEC from `Read`
USE `Read` where: path="LLM.txt"
CAPTURE REPO_MAP from `Read`
SET FEATURE_DESCRIPTION := <DESC> (from "Agent Inference" using USER_INPUT)
</process>

<process id="analyze-history" name="Analyze issue-quality gaps">
USE `Shell` where: command="git --no-pager log --all --oneline --grep='fix:' --format='%h %s'"
CAPTURE FIX_COMMITS from `Shell`
USE `Shell` where: command="gh issue list --state closed --limit 20 --json number,title,labels"
CAPTURE CLOSED_ISSUES from `Shell`
USE `Shell` where: command="gh pr list --state merged --limit 20 --json number,title,mergedAt"
CAPTURE MERGED_PRS from `Shell`
SET HISTORY_ANALYSIS := <ANALYSIS> (from "Agent Inference" using FIX_COMMITS, CLOSED_ISSUES, MERGED_PRS)
</process>

<process id="draft-issue" name="Draft issue">
SET DRAFT_TITLE := <TITLE> (from "Agent Inference" using FEATURE_DESCRIPTION)
SET DRAFT_BODY := <BODY> (from "Agent Inference" using FEATURE_DESCRIPTION, HISTORY_ANALYSIS)
</process>

<process id="rubber-duck-review" name="Review draft issue">
SET REVIEW_PROMPT := <PROMPT> (from "Agent Inference" using DRAFT_TITLE, DRAFT_BODY)
USE `Subagent` where: prompt=REVIEW_PROMPT
CAPTURE RUBBER_DUCK_RESULT from `Subagent`
SET RUBBER_DUCK_OK := <APPROVED> (from "Agent Inference" using RUBBER_DUCK_RESULT)
</process>

<process id="revise-draft" name="Revise draft">
SET DRAFT_BODY := <REVISED_BODY> (from "Agent Inference" using DRAFT_BODY, RUBBER_DUCK_RESULT)
SET REVISION_COUNT := REVISION_COUNT + 1 (from "Agent Inference")
IF REVISION_COUNT > MAX_REVISIONS:
  RETURN: error="Draft not approved after maximum revisions"
RUN `rubber-duck-review`
</process>

<process id="create-issue" name="Create GitHub issue">
USE `Write` where: content=DRAFT_BODY, path="/tmp/issue-body.md"
USE `Shell` where: command="gh issue create --title '<DRAFT_TITLE>' --body-file /tmp/issue-body.md"
CAPTURE CREATE_OUTPUT from `Shell`
SET ISSUE_URL := <URL> (from "Agent Inference" using CREATE_OUTPUT)
SET ISSUE_NUMBER := <NUMBER> (from "Agent Inference" using CREATE_OUTPUT)
</process>
</processes>

<input>
USER_INPUT is a feature request description or problem area for issue generation.
</input>
