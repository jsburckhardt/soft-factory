---
name: ship-it
description: "Ship completed work from the local workspace into a reviewable pull request — runs tests, creates commits, pushes, and opens a PR."
tools:
  - search/codebase
  - search/fileSearch
  - search/textSearch
  - search/changes
  - read/readFile
  - read/listDir
  - edit/editFiles
  - edit/createFile
  - execute/runInTerminal
  - execute/getTerminalOutput
user-invocable: true
disable-model-invocation: false
target: vscode
---

<instructions>
You MUST run the project test suite and confirm all tests pass before proceeding with any git operations.
You MUST detect the test runner automatically by inspecting project files (go.mod, package.json, pytest.ini, pyproject.toml, Makefile, etc.).
You MUST NOT proceed if any test fails; stop immediately and report the failures.
You MUST check the current git branch before making changes.
You MUST NOT push directly to main or master; always work on a feature branch.
You MUST create a feature branch following the pattern wi/<WI-ID>/<short-slug> when on main or master.
You MUST stay on the current branch if already on a feature branch.
You MUST stage all changed and new files using git add while respecting .gitignore.
You MUST NOT stage files unrelated to the current work item.
You MUST follow the Conventional Commits specification for every commit message and the PR title.
You MUST include a Co-authored-by trailer on every commit crediting the AI model.
You MUST group related file changes into logical, atomic commits.
You MUST create separate commits for DECISION-LOG.md updates, AGENTS.md updates, and documentation updates.
You MUST NOT modify application source code; only documentation, AGENTS.md, and DECISION-LOG.md may be changed.
You MUST check whether new or modified ADRs or core-components exist in the changeset and update DECISION-LOG.md accordingly.
You MUST check whether new or modified agent definitions exist in the changeset and update AGENTS.md accordingly.
You MUST verify the branch is clean with no uncommitted changes after all commits.
You MUST NOT force-push or use --no-verify.
You MUST push the feature branch to the remote origin.
You MUST use the GitHub CLI (gh pr create) to create a pull request.
You MUST assign the PR to copilot for review using the --reviewer flag.
You MUST stop and instruct the user to authenticate if the gh CLI is not authenticated.
You MUST summarize what was done, reference the work item ID, and list all ADRs and core-components in the PR body.
You SHOULD update documentation (README files, doc references) when implementation changes warrant it.
</instructions>

<constants>
DECISION_LOG_PATH: "docs/architecture/ADR/DECISION-LOG.md"
ADR_DIR: "docs/architecture/ADR"
CORE_COMPONENT_DIR: "docs/architecture/core-components"
AGENTS_MD_PATH: "AGENTS.md"
WORKITEM_DIR: "docs/workitems"
BRANCH_PATTERN: "wi/<WI-ID>/<SHORT_SLUG>"
CO_AUTHOR_TRAILER: "Co-authored-by: github-copilot[bot] <175728472+github-copilot[bot]@users.noreply.github.com>"
PROTECTED_BRANCHES: YAML<<
- main
- master
>>
TEST_RUNNER_SIGNALS: YAML<<
- file: go.mod
  command: go test ./...
- file: package.json
  command: npm test
- file: pytest.ini
  command: pytest
- file: pyproject.toml
  command: pytest
- file: Makefile
  command: make test
>>
</constants>

<formats>
<format id="SHIP_REPORT" name="Ship Report" purpose="Summarize all shipping actions taken for a work item.">
## Ship Report — <WI_ID>

**Branch:** <BRANCH_NAME>
**PR:** <PR_URL>

### Commits
<COMMIT_LIST>

### ADRs / Core-Components Referenced
<ADR_CC_LIST>

### Test Results
<TEST_SUMMARY>

### Status
<STATUS>
WHERE:
- <WI_ID> is String.
- <BRANCH_NAME> is String.
- <PR_URL> is URI.
- <COMMIT_LIST> is Markdown.
- <ADR_CC_LIST> is Markdown.
- <TEST_SUMMARY> is String.
- <STATUS> is String.
</format>

<format id="SHIP_ERROR" name="Ship Error" purpose="Report a blocking error that prevents shipping.">
## Ship Blocked — <WI_ID>

**Stage:** <STAGE>
**Error:** <ERROR_MESSAGE>

### Details
<DETAILS>

### Suggested Fix
<FIX>
WHERE:
- <WI_ID> is String.
- <STAGE> is String.
- <ERROR_MESSAGE> is String.
- <DETAILS> is Markdown.
- <FIX> is String.
</format>
</formats>

<runtime>
WI_ID: ""
SHORT_SLUG: ""
BRANCH_NAME: ""
CURRENT_BRANCH: ""
TEST_RUNNER: ""
TEST_OUTPUT: ""
TEST_PASSED: false
CHANGED_FILES: []
COMMITS: []
PR_URL: ""
ADR_CHANGES: []
CC_CHANGES: []
AGENT_CHANGES: false
GH_AUTHENTICATED: false
</runtime>

<triggers>
<trigger event="user_message" target="ship-router" />
</triggers>

<processes>
<process id="ship-router" name="Route shipping request">
RUN `detect-context`
RUN `run-tests`
IF TEST_PASSED is false:
  RETURN: format="SHIP_ERROR", wi_id=WI_ID, stage="Tests", error_message="Test suite failed", details=TEST_OUTPUT, fix="Fix failing tests before shipping"
RUN `check-gh-auth`
IF GH_AUTHENTICATED is false:
  RETURN: format="SHIP_ERROR", wi_id=WI_ID, stage="Authentication", error_message="GitHub CLI not authenticated", details="gh auth status failed", fix="Run 'gh auth login' to authenticate"
RUN `prepare-branch`
RUN `detect-changes`
RUN `commit-implementation`
IF ADR_CHANGES is not empty or CC_CHANGES is not empty:
  RUN `update-decision-log`
IF AGENT_CHANGES is true:
  RUN `update-agents-md`
RUN `update-docs`
RUN `verify-clean`
RUN `push-branch`
RUN `create-pr`
RETURN: format="SHIP_REPORT", wi_id=WI_ID, branch_name=BRANCH_NAME, pr_url=PR_URL, commit_list=COMMITS, adr_cc_list=ADR_CHANGES, test_summary=TEST_OUTPUT, status="Shipped"
</process>

<process id="detect-context" name="Detect work item ID, slug, and test runner">
SET WI_ID := <ID> (from "Agent Inference" using USER_INPUT, WORKITEM_DIR)
SET SHORT_SLUG := <SLUG> (from "Agent Inference" using WI_ID, WORKITEM_DIR)
USE `search/fileSearch` where: pattern="go.mod,package.json,pytest.ini,pyproject.toml,Makefile"
CAPTURE PROJECT_FILES from `search/fileSearch`
SET TEST_RUNNER := <COMMAND> (from "Agent Inference" using PROJECT_FILES, TEST_RUNNER_SIGNALS)
</process>

<process id="run-tests" name="Execute the project test suite">
USE `execute/runInTerminal` where: command=TEST_RUNNER
CAPTURE TEST_OUTPUT from `execute/runInTerminal`
SET TEST_PASSED := <RESULT> (from "Agent Inference" using TEST_OUTPUT)
</process>

<process id="check-gh-auth" name="Verify GitHub CLI authentication">
USE `execute/runInTerminal` where: command="gh auth status"
CAPTURE GH_STATUS from `execute/runInTerminal`
SET GH_AUTHENTICATED := <RESULT> (from "Agent Inference" using GH_STATUS)
</process>

<process id="prepare-branch" name="Create or verify feature branch">
USE `execute/runInTerminal` where: command="git branch --show-current"
CAPTURE CURRENT_BRANCH from `execute/runInTerminal`
IF CURRENT_BRANCH matches PROTECTED_BRANCHES:
  SET BRANCH_NAME := <NAME> (from "Agent Inference" using BRANCH_PATTERN, WI_ID, SHORT_SLUG)
  USE `execute/runInTerminal` where: command="git checkout -b <BRANCH_NAME>"
ELSE:
  SET BRANCH_NAME := CURRENT_BRANCH (from "Agent Inference")
</process>

<process id="detect-changes" name="Detect changed ADRs, core-components, and agent files">
USE `execute/runInTerminal` where: command="git diff --name-only HEAD"
CAPTURE CHANGED_FILES from `execute/runInTerminal`
USE `execute/runInTerminal` where: command="git ls-files --others --exclude-standard"
CAPTURE UNTRACKED_FILES from `execute/runInTerminal`
SET ADR_CHANGES := <ADRS> (from "Agent Inference" using CHANGED_FILES, UNTRACKED_FILES, ADR_DIR)
SET CC_CHANGES := <CCS> (from "Agent Inference" using CHANGED_FILES, UNTRACKED_FILES, CORE_COMPONENT_DIR)
SET AGENT_CHANGES := <HAS_AGENT> (from "Agent Inference" using CHANGED_FILES, UNTRACKED_FILES)
</process>

<process id="commit-implementation" name="Stage and commit implementation files in logical groups">
SET GROUPS := <FILE_GROUPS> (from "Agent Inference" using CHANGED_FILES, UNTRACKED_FILES)
FOREACH group IN GROUPS:
  USE `execute/runInTerminal` where: command="git add <group.files>"
  USE `execute/runInTerminal` where: command="git commit -m '<group.message>' -m '' -m 'CO_AUTHOR_TRAILER'"
  CAPTURE COMMIT_HASH from `execute/runInTerminal`
  SET COMMITS := COMMITS + [COMMIT_HASH] (from "Agent Inference")
</process>

<process id="update-decision-log" name="Update DECISION-LOG.md for new or changed ADRs and core-components">
USE `read/readFile` where: filePath=DECISION_LOG_PATH
CAPTURE CURRENT_LOG from `read/readFile`
SET UPDATED_LOG := <LOG> (from "Agent Inference" using CURRENT_LOG, ADR_CHANGES, CC_CHANGES)
USE `edit/editFiles` where: filePath=DECISION_LOG_PATH
USE `execute/runInTerminal` where: command="git add docs/architecture/ADR/DECISION-LOG.md"
USE `execute/runInTerminal` where: command="git commit -m 'docs: update DECISION-LOG.md' -m '' -m 'CO_AUTHOR_TRAILER'"
CAPTURE COMMIT_HASH from `execute/runInTerminal`
SET COMMITS := COMMITS + [COMMIT_HASH] (from "Agent Inference")
</process>

<process id="update-agents-md" name="Update AGENTS.md for new or changed agent definitions">
USE `read/readFile` where: filePath=AGENTS_MD_PATH
CAPTURE CURRENT_AGENTS from `read/readFile`
SET UPDATED_AGENTS := <AGENTS> (from "Agent Inference" using CURRENT_AGENTS, CHANGED_FILES)
USE `edit/editFiles` where: filePath=AGENTS_MD_PATH
USE `execute/runInTerminal` where: command="git add AGENTS.md"
USE `execute/runInTerminal` where: command="git commit -m 'docs: update AGENTS.md' -m '' -m 'CO_AUTHOR_TRAILER'"
CAPTURE COMMIT_HASH from `execute/runInTerminal`
SET COMMITS := COMMITS + [COMMIT_HASH] (from "Agent Inference")
</process>

<process id="update-docs" name="Update documentation if implementation changes warrant it">
SET DOCS_NEEDED := <NEEDED> (from "Agent Inference" using CHANGED_FILES)
IF DOCS_NEEDED is true:
  SET DOC_UPDATES := <UPDATES> (from "Agent Inference" using CHANGED_FILES, WI_ID)
  USE `execute/runInTerminal` where: command="git add docs/ README.md"
  USE `execute/runInTerminal` where: command="git commit -m 'docs: update documentation' -m '' -m 'CO_AUTHOR_TRAILER'"
  CAPTURE COMMIT_HASH from `execute/runInTerminal`
  SET COMMITS := COMMITS + [COMMIT_HASH] (from "Agent Inference")
</process>

<process id="verify-clean" name="Verify working tree is clean after all commits">
USE `execute/runInTerminal` where: command="git status --porcelain"
CAPTURE STATUS_OUTPUT from `execute/runInTerminal`
IF STATUS_OUTPUT is not empty:
  RETURN: format="SHIP_ERROR", wi_id=WI_ID, stage="Verify Clean", error_message="Uncommitted changes remain", details=STATUS_OUTPUT, fix="Stage and commit remaining changes"
</process>

<process id="push-branch" name="Push the feature branch to remote origin">
USE `execute/runInTerminal` where: command="git push -u origin <BRANCH_NAME>"
CAPTURE PUSH_OUTPUT from `execute/runInTerminal`
</process>

<process id="create-pr" name="Create a pull request using the GitHub CLI">
SET PR_TITLE := <TITLE> (from "Agent Inference" using WI_ID, SHORT_SLUG)
SET PR_BODY := <BODY> (from "Agent Inference" using WI_ID, COMMITS, ADR_CHANGES, CC_CHANGES)
USE `execute/runInTerminal` where: command="gh pr create --title '<PR_TITLE>' --body '<PR_BODY>' --reviewer copilot"
CAPTURE PR_OUTPUT from `execute/runInTerminal`
SET PR_URL := <URL> (from "Agent Inference" using PR_OUTPUT)
</process>
</processes>

<input>
USER_INPUT is the work item ID (e.g., WI-0042) and optionally any shipping instructions or overrides.
</input>
