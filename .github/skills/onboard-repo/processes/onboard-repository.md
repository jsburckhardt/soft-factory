<instructions>
You MUST check whether the repository is already onboarded.
You MUST analyze existing code and documentation before writing files.
You MUST document discovered architecture as ADRs.
You MUST document discovered cross-cutting concerns as core-components.
You MUST update the decision log.
You MUST create the first repository-understanding issue.
You MUST NOT make feature-level decisions.
</instructions>

<constants>
ADR_TEMPLATE_PATH: ".github/skills/templates/adr.md"
ARTIFACT_CONTRACT_PATH: ".github/skills/templates/artifact-contract.md"
CORE_COMPONENT_TEMPLATE_PATH: ".github/skills/templates/core-component.md"
DECISION_LOG_PATH: "project/architecture/ADR/DECISION-LOG.md"
DECISION_LOG_TEMPLATE_PATH: ".github/skills/templates/decision-log.md"
FIRST_ISSUE_TITLE: "Repository Understanding"
LLM_TXT_PATH: "LLM.txt"
ONBOARD_MARKER_PATTERN: "project/architecture/ADR/ADR-0002-*.md"
README_PATH: "README.md"
</constants>

<formats>
<format id="ONBOARD_CONFIRMATION_V1" name="Onboarding Confirmation" purpose="Request confirmation before onboarding writes files.">
# Onboarding Confirmation Required

## Repository
- **Name:** <PROJECT_NAME>
- **Description:** <PROJECT_DESCRIPTION>
- **Tech Stack:** <TECH_STACK>

## Discovered ADR candidates
<DISCOVERED_ADRS>

## Discovered cross-cutting concerns
<DISCOVERED_CONCERNS>

Reply with confirmation before this workflow writes files.
WHERE:
- <DISCOVERED_ADRS> is Markdown.
- <DISCOVERED_CONCERNS> is Markdown.
- <PROJECT_DESCRIPTION> is String.
- <PROJECT_NAME> is String.
- <TECH_STACK> is String.
</format>

<format id="ONBOARD_REPORT_V1" name="Onboarding Report" purpose="Summarize repository onboarding actions.">
# Onboarding Report

## Repository
- **Name:** <PROJECT_NAME>
- **Description:** <PROJECT_DESCRIPTION>
- **Tech Stack:** <TECH_STACK>

## ADRs Created
<ADR_LIST>

## Core-Components Created
<CORE_COMPONENT_LIST>

## First GitHub Issue
- **Issue:** #<FIRST_ISSUE_NUMBER>
- **Title:** Repository Understanding

## Files Updated
<FILES_UPDATED>
WHERE:
- <ADR_LIST> is Markdown.
- <CORE_COMPONENT_LIST> is Markdown.
- <FILES_UPDATED> is Markdown.
- <FIRST_ISSUE_NUMBER> is Integer.
- <PROJECT_DESCRIPTION> is String.
- <PROJECT_NAME> is String.
- <TECH_STACK> is String.
</format>
</formats>

<runtime>
CREATED_ADRS: []
CREATED_CORE_COMPONENTS: []
ARTIFACT_CONTRACT: ""
DECISION_LOG_TEMPLATE: ""
DISCOVERED_CONCERNS: []
FIRST_ISSUE_NUMBER: ""
INFO_CONFIRMED: false
IS_ONBOARDED: false
PROJECT_DESCRIPTION: ""
PROJECT_NAME: ""
TECH_STACK: ""
UPDATED_FILES: []
</runtime>

<triggers>
<trigger event="user_message" target="onboard-repository" />
</triggers>

<processes>
<process id="onboard-repository" name="Onboard existing repository">
RUN `check-onboarded`
IF IS_ONBOARDED is true:
  RETURN: error="Repository already has the Soft Factory engineering flow"
RUN `analyze-repository`
IF INFO_CONFIRMED is false:
  RETURN: format="ONBOARD_CONFIRMATION_V1", discovered_adrs=DISCOVERED_ADRS, discovered_concerns=DISCOVERED_CONCERNS, project_description=PROJECT_DESCRIPTION, project_name=PROJECT_NAME, tech_stack=TECH_STACK
RUN `create-discovered-artifacts`
RUN `create-first-issue`
RUN `update-project-docs`
RETURN: format="ONBOARD_REPORT_V1", adr_list=CREATED_ADRS, core_component_list=CREATED_CORE_COMPONENTS, files_updated=UPDATED_FILES, first_issue_number=FIRST_ISSUE_NUMBER, project_description=PROJECT_DESCRIPTION, project_name=PROJECT_NAME, tech_stack=TECH_STACK
</process>

<process id="check-onboarded" name="Check onboarding status">
USE `Glob` where: path=".", pattern=ONBOARD_MARKER_PATTERN
CAPTURE EXISTING_ADRS from `Glob`
IF EXISTING_ADRS is not empty:
  SET IS_ONBOARDED := true (from "Agent Inference")
ELSE:
  SET IS_ONBOARDED := false (from "Agent Inference")
</process>

<process id="analyze-repository" name="Analyze repository context">
USE `Read` where: path=README_PATH
CAPTURE README_CONTENT from `Read`
USE `Glob` where: path=".", pattern="**/*"
CAPTURE REPO_FILES from `Glob`
SET PROJECT_NAME := <NAME> (from "Agent Inference" using README_CONTENT, USER_INPUT)
SET PROJECT_DESCRIPTION := <DESC> (from "Agent Inference" using README_CONTENT, USER_INPUT)
SET TECH_STACK := <STACK> (from "Agent Inference" using REPO_FILES)
SET DISCOVERED_ADRS := <ADRS> (from "Agent Inference" using REPO_FILES, TECH_STACK)
SET DISCOVERED_CONCERNS := <CONCERNS> (from "Agent Inference" using REPO_FILES)
SET INFO_CONFIRMED := <CONFIRMED> (from "Agent Inference" using USER_INPUT)
</process>

<process id="create-discovered-artifacts" name="Create discovered architecture artifacts">
USE `Read` where: path=ADR_TEMPLATE_PATH
CAPTURE ADR_TEMPLATE from `Read`
USE `Read` where: path=CORE_COMPONENT_TEMPLATE_PATH
CAPTURE CORE_COMPONENT_TEMPLATE from `Read`
USE `Read` where: path=DECISION_LOG_TEMPLATE_PATH
CAPTURE DECISION_LOG_TEMPLATE from `Read`
USE `Read` where: path=ARTIFACT_CONTRACT_PATH
CAPTURE ARTIFACT_CONTRACT from `Read`
SET CREATED_ADRS := <ADRS> (from "Agent Inference" using ADR_TEMPLATE, DISCOVERED_ADRS)
SET CREATED_CORE_COMPONENTS := <CORE_COMPONENTS> (from "Agent Inference" using CORE_COMPONENT_TEMPLATE, DISCOVERED_CONCERNS)
SET UPDATED_DECISION_LOG := <LOG> (from "Agent Inference" using ARTIFACT_CONTRACT, CREATED_ADRS, CREATED_CORE_COMPONENTS, DECISION_LOG_TEMPLATE)
USE `Write` where: content=UPDATED_DECISION_LOG, path=DECISION_LOG_PATH
</process>

<process id="create-first-issue" name="Create first issue and research brief">
SET ISSUE_BODY := <BODY> (from "Agent Inference" using PROJECT_NAME, PROJECT_DESCRIPTION, TECH_STACK, CREATED_ADRS, CREATED_CORE_COMPONENTS)
USE `Write` where: content=ISSUE_BODY, path="/tmp/issue-body.md"
USE `Shell` where: command="gh issue create --title 'Repository Understanding' --body-file /tmp/issue-body.md"
CAPTURE ISSUE_OUTPUT from `Shell`
SET FIRST_ISSUE_NUMBER := <NUMBER> (from "Agent Inference" using ISSUE_OUTPUT)
SET BRIEF := <BRIEF> (from "Agent Inference" using FIRST_ISSUE_NUMBER, PROJECT_NAME, PROJECT_DESCRIPTION, TECH_STACK)
USE `Write` where: content=BRIEF, path="project/issues/<FIRST_ISSUE_NUMBER>/research/00-research.md"
</process>

<process id="update-project-docs" name="Update repository documentation">
SET DOC_UPDATES := <UPDATES> (from "Agent Inference" using CREATED_ADRS, CREATED_CORE_COMPONENTS, FIRST_ISSUE_NUMBER)
USE `Write` where: content=DOC_UPDATES.readme, path=README_PATH
USE `Write` where: content=DOC_UPDATES.llm, path=LLM_TXT_PATH
SET UPDATED_FILES := <FILES> (from "Agent Inference" using DOC_UPDATES)
</process>
</processes>

<input>
USER_INPUT is optional repository context to supplement automatic analysis.
</input>
