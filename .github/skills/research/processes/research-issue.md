<instructions>
You MUST fetch the GitHub issue before researching.
You MUST inspect existing repository documentation and architecture records.
You MUST extract acceptance criteria verbatim.
You MUST classify scope_type as issue, architecture_decision, or core_component.
You MUST write the research brief to the issue research directory.
You MUST NOT make architectural decisions.
</instructions>

<constants>
AC_END_MARKER: "<!-- ACCEPTANCE_CRITERIA_END -->"
AC_START_MARKER: "<!-- ACCEPTANCE_CRITERIA_START -->"
ARTIFACT_CONTRACT_PATH: ".github/skills/templates/artifact-contract.md"
BRIEF_PATH_TEMPLATE: "project/issues/<ISSUE_NUMBER>/research/00-research.md"
RESEARCH_BRIEF_TEMPLATE_PATH: ".github/skills/templates/research-brief.md"
SCOPE_TYPES: YAML<<
- architecture_decision
- core_component
- issue
>>
</constants>

<formats>
<format id="RESEARCH_BRIEF_V1" name="Research Brief" purpose="Capture issue research for Plan handoff.">
# Research Brief: <TITLE>

## GitHub Issue
- **Issue:** #<ISSUE_NUMBER>
- **Title:** <ISSUE_TITLE>

## Scope Classification
- **Scope Type:** <SCOPE_TYPE>

## Problem Statement
<PROBLEM_STATEMENT>

## Existing Context
<EXISTING_CONTEXT>

## Proposed ADRs
<PROPOSED_ADRS>

## Proposed Core-Components
<PROPOSED_CORE_COMPONENTS>

## Acceptance Criteria (from issue)
<ACCEPTANCE_CRITERIA>

## Risks and Open Questions
<RISKS>
WHERE:
- <ACCEPTANCE_CRITERIA> is Markdown.
- <EXISTING_CONTEXT> is Markdown.
- <ISSUE_NUMBER> is Integer.
- <ISSUE_TITLE> is String.
- <PROBLEM_STATEMENT> is Markdown.
- <PROPOSED_ADRS> is Markdown.
- <PROPOSED_CORE_COMPONENTS> is Markdown.
- <RISKS> is Markdown.
- <SCOPE_TYPE> is String.
- <TITLE> is String.
</format>
</formats>

<runtime>
ACCEPTANCE_CRITERIA: ""
ARTIFACT_CONTRACT: ""
CURRENT_ISSUE_NUMBER: ""
ISSUE_BODY: ""
ISSUE_TITLE: ""
RESEARCH_BRIEF_PATH: ""
RESEARCH_BRIEF_TEMPLATE: ""
SCOPE_TYPE: ""
</runtime>

<triggers>
<trigger event="user_message" target="research-issue" />
</triggers>

<processes>
<process id="research-issue" name="Research GitHub issue">
RUN `load-artifact-templates`
RUN `fetch-issue`
RUN `gather-context`
RUN `classify-scope`
RUN `write-research-brief`
</process>

<process id="load-artifact-templates" name="Load artifact templates">
USE `Read` where: path=ARTIFACT_CONTRACT_PATH
CAPTURE ARTIFACT_CONTRACT from `Read`
USE `Read` where: path=RESEARCH_BRIEF_TEMPLATE_PATH
CAPTURE RESEARCH_BRIEF_TEMPLATE from `Read`
</process>

<process id="fetch-issue" name="Fetch issue and acceptance criteria">
SET CURRENT_ISSUE_NUMBER := <NUMBER> (from "Agent Inference" using USER_INPUT)
USE `Shell` where: command="gh issue view <CURRENT_ISSUE_NUMBER> --json title,body,labels,assignees,milestone"
CAPTURE ISSUE_JSON from `Shell`
SET ISSUE_TITLE := <TITLE> (from "Agent Inference" using ISSUE_JSON)
SET ISSUE_BODY := <BODY> (from "Agent Inference" using ISSUE_JSON)
SET ACCEPTANCE_CRITERIA := <CRITERIA> (from "Agent Inference" using ISSUE_BODY, AC_END_MARKER, AC_START_MARKER)
IF ACCEPTANCE_CRITERIA is empty:
  RETURN: error="Issue is missing structured acceptance criteria"
</process>

<process id="gather-context" name="Gather repository context">
USE `Glob` where: path=".", pattern="docs/**/*.md"
CAPTURE DOC_FILES from `Glob`
USE `Glob` where: path=".", pattern="project/**/*.md"
CAPTURE PROJECT_FILES from `Glob`
USE `Glob` where: path=".", pattern="project/architecture/ADR/ADR-*.md"
CAPTURE ADR_FILES from `Glob`
USE `Glob` where: path=".", pattern="project/architecture/core-components/CORE-COMPONENT-*.md"
CAPTURE CORE_COMPONENT_FILES from `Glob`
</process>

<process id="classify-scope" name="Classify issue scope">
SET SCOPE_TYPE := <SCOPE> (from "Agent Inference" using ISSUE_BODY, SCOPE_TYPES, ADR_FILES, CORE_COMPONENT_FILES)
</process>

<process id="write-research-brief" name="Write research brief">
SET RESEARCH_BRIEF_PATH := <PATH> (from "Agent Inference" using ARTIFACT_CONTRACT, BRIEF_PATH_TEMPLATE, CURRENT_ISSUE_NUMBER)
SET BRIEF_CONTENT := <BRIEF> (from "Agent Inference" using ACCEPTANCE_CRITERIA, CURRENT_ISSUE_NUMBER, ISSUE_BODY, ISSUE_TITLE, RESEARCH_BRIEF_TEMPLATE, SCOPE_TYPE)
USE `Write` where: content=BRIEF_CONTENT, path=RESEARCH_BRIEF_PATH
</process>
</processes>

<input>
USER_INPUT is a GitHub issue number, URL, or issue reference to research.
</input>
