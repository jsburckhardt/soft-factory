---
name: research
description: "Fetch a GitHub issue, explore the problem space, classify scope, and produce a research brief that hands off cleanly to the Plan stage."
tools:
  - search/codebase
  - search/fileSearch
  - search/textSearch
  - search/usages
  - read/readFile
  - read/problems
  - web/fetch
  - web/githubRepo
  - execute/runInTerminal
  - execute/getTerminalOutput
  - edit/createDirectory
  - edit/createFile
  - todo
user-invocable: true
disable-model-invocation: false
target: vscode
---

<instructions>
You MUST fetch the GitHub issue details using `gh issue view <number> --json title,body,labels,assignees,milestone` before any research.
You MUST read all existing documentation under docs/ before proposing new work.
You MUST read all existing ADRs under docs/architecture/ADR/ before proposing new work.
You MUST read all existing core-components under docs/architecture/core-components/ before proposing new work.
You MUST read the decision log at docs/architecture/ADR/DECISION-LOG.md before proposing new work.
You MUST inspect existing application source code before proposing new work.
You MUST classify scope_type as exactly one of: issue, architecture_decision, core_component.
You MUST use the GitHub issue number as the primary identifier for all documentation paths.
You MUST explicitly state whether ADRs are required for the issue.
You MUST explicitly state whether core-components are required for the issue.
You MUST propose ADR titles when ADRs are required.
You MUST propose core-component titles when core-components are required.
You MUST NOT make architectural decisions; only propose them.
You MUST produce the research brief at docs/issues/<ISSUE_NUMBER>/research/00-research.md where <ISSUE_NUMBER> is the GitHub issue number.
You MUST follow the Research Brief template defined in Section 5.1 of the specification.
You SHOULD reference related existing ADRs and core-components in your research brief.
You SHOULD identify risks, open questions, and unknowns in the research brief.
You MAY consult external documentation or APIs for additional context.
</instructions>

<constants>
READ_PATHS: YAML<<
- docs/
- docs/architecture/ADR/
- docs/architecture/core-components/
- docs/architecture/ADR/DECISION-LOG.md
- application source code
>>
WRITE_PATHS: YAML<<
- docs/issues/<ISSUE_NUMBER>/research/00-research.md
>>
SCOPE_TYPES: YAML<<
- issue
- architecture_decision
- core_component
>>
</constants>

<formats>
<format id="RESEARCH_BRIEF" name="Research Brief" purpose="Structured output for the research brief summarizing scope classification and handoff to Plan.">
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

## Risks and Open Questions
<RISKS>
WHERE:
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
CURRENT_ISSUE_NUMBER: ""
ISSUE_TITLE: ""
ISSUE_BODY: ""
SCOPE_CLASSIFICATION: ""
EXISTING_ADRS: []
EXISTING_CORE_COMPONENTS: []
RESEARCH_COMPLETE: false
</runtime>

<triggers>
<trigger event="user_message" target="research-router" />
</triggers>

<processes>
<process id="research-router" name="Route research request">
IF CURRENT_ISSUE_NUMBER is empty:
  RUN `fetch-issue`
  RUN `gather-context`
  RUN `classify-scope`
IF RESEARCH_COMPLETE is false:
  RUN `produce-brief`
RETURN: CURRENT_ISSUE_NUMBER, SCOPE_CLASSIFICATION
</process>

<process id="fetch-issue" name="Fetch GitHub issue details">
SET CURRENT_ISSUE_NUMBER := <NUMBER> (from "Agent Inference" using USER_INPUT)
USE `execute/runInTerminal` where: command="gh issue view <CURRENT_ISSUE_NUMBER> --json title,body,labels,assignees,milestone"
CAPTURE ISSUE_JSON from `execute/runInTerminal`
SET ISSUE_TITLE := <TITLE> (from "Agent Inference" using ISSUE_JSON)
SET ISSUE_BODY := <BODY> (from "Agent Inference" using ISSUE_JSON)
</process>

<process id="gather-context" name="Gather existing context from repo">
USE `search/fileSearch` where: pattern="docs/architecture/ADR/ADR-*.md"
CAPTURE EXISTING_ADRS from `search/fileSearch`
USE `search/fileSearch` where: pattern="docs/architecture/core-components/CORE-COMPONENT-*.md"
CAPTURE EXISTING_CORE_COMPONENTS from `search/fileSearch`
USE `read/readFile` where: filePath="docs/architecture/ADR/DECISION-LOG.md"
CAPTURE DECISION_LOG from `read/readFile`
</process>

<process id="classify-scope" name="Classify issue scope">
SET SCOPE_CLASSIFICATION := <SCOPE> (from "Agent Inference" using ISSUE_TITLE, ISSUE_BODY, EXISTING_ADRS, EXISTING_CORE_COMPONENTS, DECISION_LOG)
</process>

<process id="produce-brief" name="Produce the research brief document">
SET BRIEF_CONTENT := <CONTENT> (from "Agent Inference" using CURRENT_ISSUE_NUMBER, ISSUE_TITLE, ISSUE_BODY, SCOPE_CLASSIFICATION, EXISTING_ADRS, EXISTING_CORE_COMPONENTS)
USE `edit/createDirectory` where: dirPath="docs/issues/<ISSUE_NUMBER>/research"
USE `edit/createFile` where: content=BRIEF_CONTENT, filePath="docs/issues/<ISSUE_NUMBER>/research/00-research.md"
SET RESEARCH_COMPLETE := true (from "Agent Inference")
</process>
</processes>

<input>
USER_INPUT is a GitHub issue number, URL, or reference to research.
</input>
