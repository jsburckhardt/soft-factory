---
name: bootstrap
description: "Bootstrap a new project, create its justfile commands, seed architectural artifacts, and prepare the first issue handoff."
tools:
  - search/codebase
  - search/fileSearch
  - search/textSearch
  - read/readFile
  - edit/createDirectory
  - edit/createFile
  - edit/editFiles
  - execute/runInTerminal
  - execute/getTerminalOutput
  - web/fetch
  - todo
user-invocable: true
disable-model-invocation: true
target: vscode
handoffs:
  - label: Create First Issue
    agent: issue-generator
    prompt: Draft the first problem-focused GitHub issue for this newly bootstrapped project.
    send: false
---

<instructions>
You MUST check whether the project has already been bootstrapped before proceeding.
You MUST refuse to run if the project is already bootstrapped and explain why.
You MUST read all existing documentation under docs/ and project/ before making changes.
You MUST use the embedded ADR template in the ADR_TEMPLATE constant when creating any ADR.
You MUST use the embedded core-component template in the CORE_COMPONENT_TEMPLATE constant when creating any core-component.
You MUST gather the project name, description, and goal from the user interactively.
You MUST ask the user to choose a tech stack including language, framework, package manager, and test runner.
You MUST ask the user to identify cross-cutting concerns such as logging, error handling, authentication, or observability.
You MUST ask the user to confirm or customize development standards covering coding conventions, commit standards, and testing practices.
You MUST create a core-component for development standards using language-specific defaults from DEV_STANDARDS.
You MUST scaffold the project using the appropriate init command for the chosen tech stack.
You MUST create an ADR for the tech stack decision using the ADR template.
You MUST create a core-component file for each declared cross-cutting concern using the core-component template.
You MUST update project/architecture/ADR/DECISION-LOG.md with all new ADRs and core-components.
You MUST update README.md with the project name, description, and goal replacing the template content.
You MUST update docs/README.md with project-specific context.
You MUST update AGENTS.md to register the bootstrap in the AGENTS constant.
You MUST update LLM.txt with any new project-specific file references.
You MUST tailor .devcontainer/devcontainer.json to the chosen tech stack by removing unnecessary features.
You MUST ensure the development environment provides the just command runner.
You MUST name ADRs using ADR-yymmdd-short-slug.md with the UTC creation date.
You MUST name core-components using CORE-COMPONENT-yymmdd-short-slug.md with the UTC creation date.
You MUST use each full date-and-slug basename as the artifact ID.
You MUST use distinct descriptive slugs for multiple artifacts created on the same date.
You MUST fail instead of overwriting an existing architecture artifact path.
You MUST create a root justfile containing all project operating command bodies.
You MUST expose applicable setup, run, test, lint, format-check, type-check, build, and verify recipes.
You MUST ask the user to confirm or customize proposed justfile recipes before writing files.
You MUST NOT create a standalone verification command config.
You MUST NOT set up CI/CD pipelines or infrastructure.
You MUST NOT make feature-level decisions; only foundational project decisions.
You MUST NOT skip any user confirmation before writing files.
You SHOULD present a summary of gathered information for user confirmation before executing changes.
You SHOULD reference the tech stack ADR in each core-component's Related ADRs section.
You MAY consult external documentation for the chosen tech stack's best practices.
You MAY suggest common cross-cutting concerns the user has not mentioned.
</instructions>

<constants>
DECISION_LOG_PATH: "project/architecture/ADR/DECISION-LOG.md"
ADR_DIR: "project/architecture/ADR"
CORE_COMPONENT_DIR: "project/architecture/core-components"
ADR_TEMPLATE_PATH: "project/architecture/ADR/ADR-260101-template.md"
ADR_PATTERN: "ADR-yymmdd-short-slug.md"
CORE_COMPONENT_PATTERN: "CORE-COMPONENT-yymmdd-short-slug.md"
ARTIFACT_DATE_COMMAND: "date -u +%y%m%d"
AGENTS_MD_PATH: "AGENTS.md"
README_PATH: "README.md"
APP_DOCS_PATH: "docs/README.md"
LLM_TXT_PATH: "LLM.txt"
DEVCONTAINER_PATH: ".devcontainer/devcontainer.json"
JUSTFILE_PATH: "justfile"
JUSTFILE_CONTRACT: YAML<<
required:
  - verify-focused
  - verify
applicable:
  - setup
  - run
  - test
  - lint
  - format-check
  - type-check
  - build
rules:
  - Store raw project commands only in recipe bodies.
  - Allow recipe arguments when the underlying tool supports focused execution.
  - Make verify-focused run the configured focused validation recipes.
  - Make verify run every configured full validation recipe.
  - Omit inapplicable conditional recipes.
>>
ADR_TEMPLATE: TEXT<<
# ADR-yymmdd-short-slug: [Short Title of Decision]

## Status

[Proposed | Accepted | Deprecated | Superseded by ADR-yymmdd-short-slug]

## Context

What is the issue that we're seeing that motivates this decision or change?

## Decision

What is the change that we're proposing and/or doing?

## Alternatives

What other options were considered? Why were they rejected?

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|--------------|
| | | | |

## Consequences

What becomes easier or harder as a result of this decision?

### Positive
-

### Negative
-

### Neutral
-

## Related Issues

- [#ISSUE_NUMBER](https://github.com/ORG/REPO/issues/ISSUE_NUMBER)

## References

- [Link to relevant documentation or discussion]
>>
CORE_COMPONENT_TEMPLATE: TEXT<<
# CORE-COMPONENT-yymmdd-short-slug: [Short Title]

## Status

[Draft | Adopted | Deprecated]

## Purpose

What problem does this core-component solve? Why does it need to be a shared, cross-cutting concern?

## Scope

What parts of the system does this component affect? What are the boundaries?

## Definition

### Rules
-

### Interfaces
-

### Expectations
-

## Rationale

Why was this approach chosen over alternatives?

## Usage Examples

```
# Example code or configuration showing how to use this component
```

## Integration Guidelines

How should other parts of the system integrate with this component?

-

## Exceptions

Under what circumstances is it acceptable to deviate from this component's rules?

-

## Enforcement

How is compliance with this component verified?

- [ ] Automated checks
- [ ] Code review checklist
- [ ] Test coverage requirements

## Related ADRs

- [ADR-yymmdd-short-slug](../ADR/ADR-yymmdd-short-slug.md)
>>
DECISION_LOG_SKELETON: TEXT<<
# Decision Log

This file is the single registry of all architectural decisions and core-components in the project. Every new or modified ADR or core-component **must** be recorded here.

## ADRs

| ID | Title | Status | Date |
|----|-------|--------|------|
| _No ADRs yet. Copy `ADR-260101-template.md` and name it `ADR-yymmdd-short-slug.md`._ | | | |

## Core-Components

| ID | Title | Status | Date |
|----|-------|--------|------|
| _No core-components yet. Copy `CORE-COMPONENT-260101-template.md` and name it `CORE-COMPONENT-yymmdd-short-slug.md`._ | | | |

## Decisions

Short, actionable statements derived from ADRs and core-components. More than one decision can originate from a single source.

| # | Decision | Source | Date |
|---|----------|--------|------|
| _No decisions recorded yet._ | | | |
>>
TECH_STACK_INIT: YAML<<
- language: python
  commands:
    - uv init
    - uv sync
  package_manager: uv
  test_runner: pytest
  operation_defaults:
    setup: uv sync
    test: uv run pytest
    lint: uv run ruff check .
    format_check: uv run ruff format --check .
    type_check: uv run mypy .
- language: node
  commands:
    - npm init -y
  package_manager: npm
  test_runner: jest
  operation_defaults:
    setup: npm install
    test: npm test
    lint: npm run lint
    build: npm run build
    format_check: npx prettier --check .
- language: go
  commands:
    - go mod init
  package_manager: go
  test_runner: go test
  operation_defaults:
    setup: go mod download
    test: go test ./...
    lint: go vet ./...
    build: go build ./...
    format_check: gofmt -l .
- language: rust
  commands:
    - cargo init
  package_manager: cargo
  test_runner: cargo test
  operation_defaults:
    setup: cargo fetch
    test: cargo test
    lint: cargo clippy -- -D warnings
    build: cargo build
    format_check: cargo fmt -- --check
- language: dotnet
  commands:
    - dotnet new console
  package_manager: nuget
  test_runner: dotnet test
  operation_defaults:
    setup: dotnet restore
    test: dotnet test
    lint: dotnet format --verify-no-changes
    build: dotnet build
>>
DEV_STANDARDS: YAML<<
- language: python
  coding_conventions:
    - Follow PEP 8 for code style
    - Use type hints on all function signatures
    - Use docstrings on all public modules, classes, and functions
    - Prefer pathlib over os.path for file system operations
  commit_standards:
    - Follow Conventional Commits specification
    - Include scope in commit messages when applicable
  testing_practices:
    - Write unit tests for all public functions
    - Use pytest fixtures for shared test setup
    - Aim for 80% code coverage minimum
    - Name test files with test_ prefix
- language: node
  coding_conventions:
    - Use ESLint with the project-configured ruleset
    - Use TypeScript strict mode when TypeScript is chosen
    - Prefer named exports over default exports
    - Use async/await over raw Promises
  commit_standards:
    - Follow Conventional Commits specification
    - Include scope in commit messages when applicable
  testing_practices:
    - Write unit tests for all exported functions
    - Use describe/it blocks for test organization
    - Aim for 80% code coverage minimum
    - Co-locate test files next to source files or in __tests__ directory
- language: go
  coding_conventions:
    - Follow Effective Go and Go Code Review Comments
    - Run gofmt on all source files
    - Use meaningful variable names over single-letter names outside loops
    - Return errors rather than panic in library code
  commit_standards:
    - Follow Conventional Commits specification
    - Include scope in commit messages when applicable
  testing_practices:
    - Write table-driven tests where applicable
    - Use testify or standard testing package
    - Aim for 80% code coverage minimum
    - Name test files with _test.go suffix
- language: rust
  coding_conventions:
    - Follow Rust API Guidelines
    - Run cargo fmt on all source files
    - Use clippy lints at warn level minimum
    - Prefer Result over panic for error handling
  commit_standards:
    - Follow Conventional Commits specification
    - Include scope in commit messages when applicable
  testing_practices:
    - Write unit tests in the same file using mod tests
    - Write integration tests in the tests/ directory
    - Aim for 80% code coverage minimum
- language: dotnet
  coding_conventions:
    - Follow Microsoft C# coding conventions
    - Use nullable reference types
    - Use async/await for I/O-bound operations
    - Prefer records for immutable data types
  commit_standards:
    - Follow Conventional Commits specification
    - Include scope in commit messages when applicable
  testing_practices:
    - Write unit tests using xUnit or NUnit
    - Use the Arrange-Act-Assert pattern
    - Aim for 80% code coverage minimum
    - Name test projects with .Tests suffix
>>
</constants>

<formats>
<format id="BOOTSTRAP_SUMMARY" name="Bootstrap Summary" purpose="Present gathered information for user confirmation before executing changes.">
# Bootstrap Summary

## Project Identity
- **Name:** <PROJECT_NAME>
- **Description:** <PROJECT_DESCRIPTION>
- **Goal:** <PROJECT_GOAL>

## Tech Stack
- **Language:** <LANGUAGE>
- **Framework:** <FRAMEWORK>
- **Package Manager:** <PACKAGE_MANAGER>
- **Test Runner:** <TEST_RUNNER>
- **Init Command:** <INIT_COMMAND>

## Cross-Cutting Concerns
<CROSS_CUTTING_LIST>

## Development Standards
<DEVELOPMENT_STANDARDS_SUMMARY>

## Justfile Recipes
<OPERATING_COMMANDS>

## Artifacts to Create
<ARTIFACT_LIST>

## Files to Update
<UPDATE_LIST>
WHERE:
- <ARTIFACT_LIST> is Markdown.
- <CROSS_CUTTING_LIST> is Markdown.
- <DEVELOPMENT_STANDARDS_SUMMARY> is Markdown.
- <FRAMEWORK> is String.
- <INIT_COMMAND> is String.
- <LANGUAGE> is String.
- <OPERATING_COMMANDS> is Markdown.
- <PACKAGE_MANAGER> is String.
- <PROJECT_DESCRIPTION> is String.
- <PROJECT_GOAL> is String.
- <PROJECT_NAME> is String.
- <TEST_RUNNER> is String.
- <UPDATE_LIST> is Markdown.
</format>

<format id="BOOTSTRAP_REPORT" name="Bootstrap Report" purpose="Summarize all actions taken during project bootstrap.">
# Bootstrap Report

## Project
- **Name:** <PROJECT_NAME>
- **Description:** <PROJECT_DESCRIPTION>

## Scaffolding
<SCAFFOLD_OUTPUT>

## ADRs Created
<ADR_LIST>

## Core-Components Created
<CORE_COMPONENT_LIST>

## Files Updated
<FILES_UPDATED>

## Command Interface
<OPERATING_COMMANDS>

## Status
<STATUS>

## Next Steps
<NEXT_STEPS>
WHERE:
- <ADR_LIST> is Markdown.
- <CORE_COMPONENT_LIST> is Markdown.
- <FILES_UPDATED> is Markdown.
- <NEXT_STEPS> is Markdown.
- <OPERATING_COMMANDS> is Markdown.
- <PROJECT_DESCRIPTION> is String.
- <PROJECT_NAME> is String.
- <SCAFFOLD_OUTPUT> is Markdown.
- <STATUS> is String.
</format>

<format id="BOOTSTRAP_BLOCKED" name="Bootstrap Blocked" purpose="Report that bootstrap cannot proceed because the project is already bootstrapped.">
## Bootstrap Blocked

**Reason:** <REASON>

### Evidence
<EVIDENCE>

### Suggestion
<SUGGESTION>
WHERE:
- <EVIDENCE> is Markdown.
- <REASON> is String.
- <SUGGESTION> is String.
</format>
</formats>

<runtime>
PROJECT_NAME: ""
PROJECT_DESCRIPTION: ""
PROJECT_GOAL: ""
LANGUAGE: ""
FRAMEWORK: ""
PACKAGE_MANAGER: ""
TEST_RUNNER: ""
INIT_COMMAND: ""
CROSS_CUTTING_CONCERNS: []
DEVELOPMENT_STANDARDS: {}
DEVELOPMENT_STANDARDS_SUMMARY: ""
IS_BOOTSTRAPPED: false
BOOTSTRAP_EVIDENCE: ""
INFO_CONFIRMED: false
ARTIFACT_LIST: ""
UPDATE_LIST: ""
SCAFFOLD_OUTPUT: ""
ARTIFACT_DATE: ""
CREATED_ADRS: []
CREATED_CORE_COMPONENTS: []
UPDATED_FILES: []
OPERATING_COMMANDS: {}
JUSTFILE_CONTENT: ""
</runtime>

<triggers>
<trigger event="user_message" target="bootstrap-router" />
</triggers>

<processes>
<process id="bootstrap-router" name="Route bootstrap request">
RUN `check-bootstrapped`
IF IS_BOOTSTRAPPED is true:
  RETURN: format="BOOTSTRAP_BLOCKED", evidence=BOOTSTRAP_EVIDENCE, reason="Project has already been bootstrapped", suggestion="Create or select a GitHub issue, then run @rpiv"
RUN `resolve-artifact-date`
IF PROJECT_NAME is empty:
  RUN `gather-project-info`
SET ARTIFACT_LIST := <LIST> (from "Agent Inference" using LANGUAGE, CROSS_CUTTING_CONCERNS, ARTIFACT_DATE, ADR_PATTERN, CORE_COMPONENT_PATTERN)
SET UPDATE_LIST := <LIST> (from "Agent Inference" using README_PATH, APP_DOCS_PATH, AGENTS_MD_PATH, LLM_TXT_PATH, DEVCONTAINER_PATH, DECISION_LOG_PATH, JUSTFILE_PATH)
SET DEVELOPMENT_STANDARDS_SUMMARY := <SUMMARY> (from "Agent Inference" using DEVELOPMENT_STANDARDS, LANGUAGE)
IF INFO_CONFIRMED is false:
  RETURN: format="BOOTSTRAP_SUMMARY", artifact_list=ARTIFACT_LIST, cross_cutting_list=CROSS_CUTTING_CONCERNS, development_standards_summary=DEVELOPMENT_STANDARDS_SUMMARY, framework=FRAMEWORK, init_command=INIT_COMMAND, language=LANGUAGE, operating_commands=OPERATING_COMMANDS, package_manager=PACKAGE_MANAGER, project_description=PROJECT_DESCRIPTION, project_goal=PROJECT_GOAL, project_name=PROJECT_NAME, test_runner=TEST_RUNNER, update_list=UPDATE_LIST
RUN `scaffold-project`
RUN `create-tech-stack-adr`
IF CROSS_CUTTING_CONCERNS is not empty:
  RUN `create-core-components`
RUN `create-development-standards`
RUN `update-decision-log`
RUN `configure-operations`
RUN `update-project-docs`
RUN `tailor-devcontainer`
RETURN: format="BOOTSTRAP_REPORT", adr_list=CREATED_ADRS, core_component_list=CREATED_CORE_COMPONENTS, files_updated=UPDATED_FILES, next_steps="Create the first GitHub issue with @issue-generator, then run @rpiv", operating_commands=OPERATING_COMMANDS, project_description=PROJECT_DESCRIPTION, project_name=PROJECT_NAME, scaffold_output=SCAFFOLD_OUTPUT, status="Bootstrapped"
</process>

<process id="check-bootstrapped" name="Check if project has already been bootstrapped">
USE `search/fileSearch` where: pattern="project/architecture/ADR/ADR-*.md"
CAPTURE ADR_FILES from `search/fileSearch`
SET EXISTING_ADRS := <FILES> (from "Agent Inference" using ADR_FILES, ADR_TEMPLATE_PATH; exclude the template path)
IF EXISTING_ADRS is not empty:
  SET IS_BOOTSTRAPPED := true (from "Agent Inference")
  SET BOOTSTRAP_EVIDENCE := <EVIDENCE> (from "Agent Inference" using EXISTING_ADRS)
ELSE:
  SET IS_BOOTSTRAPPED := false (from "Agent Inference")
</process>

<process id="resolve-artifact-date" name="Resolve the UTC architecture artifact date">
USE `execute/runInTerminal` where: command=ARTIFACT_DATE_COMMAND
CAPTURE ARTIFACT_DATE from `execute/runInTerminal`
</process>

<process id="gather-project-info" name="Gather project identity, tech stack, and cross-cutting concerns from user">
SET PROJECT_NAME := <NAME> (from "Agent Inference" using USER_INPUT)
SET PROJECT_DESCRIPTION := <DESC> (from "Agent Inference" using USER_INPUT)
SET PROJECT_GOAL := <GOAL> (from "Agent Inference" using USER_INPUT)
SET LANGUAGE := <LANG> (from "Agent Inference" using USER_INPUT, TECH_STACK_INIT)
SET FRAMEWORK := <FW> (from "Agent Inference" using USER_INPUT)
SET PACKAGE_MANAGER := <PM> (from "Agent Inference" using USER_INPUT, TECH_STACK_INIT)
SET TEST_RUNNER := <TR> (from "Agent Inference" using USER_INPUT, TECH_STACK_INIT)
SET INIT_COMMAND := <CMD> (from "Agent Inference" using LANGUAGE, TECH_STACK_INIT)
SET CROSS_CUTTING_CONCERNS := <CONCERNS> (from "Agent Inference" using USER_INPUT)
SET DEVELOPMENT_STANDARDS := <STANDARDS> (from "Agent Inference" using LANGUAGE, DEV_STANDARDS, USER_INPUT)
SET OPERATING_COMMANDS := <RECIPES> (from "Agent Inference" using LANGUAGE, FRAMEWORK, TECH_STACK_INIT, TEST_RUNNER, JUSTFILE_CONTRACT, USER_INPUT; map applicable operations to raw command bodies)
</process>

<process id="scaffold-project" name="Initialize the project using the chosen tech stack">
USE `execute/runInTerminal` where: command=INIT_COMMAND
CAPTURE SCAFFOLD_OUTPUT from `execute/getTerminalOutput`
SET UPDATED_FILES := UPDATED_FILES + ["Project scaffold"] (from "Agent Inference")
</process>

<process id="create-tech-stack-adr" name="Create the foundational tech stack ADR">
SET ADR_SLUG := <SLUG> (from "Agent Inference" using LANGUAGE, FRAMEWORK; produce a lowercase hyphenated description)
SET ADR_ID := <ID> (from "Agent Inference" using ARTIFACT_DATE, ADR_SLUG; format ADR-yymmdd-short-slug)
SET ADR_CONTENT := <CONTENT> (from "Agent Inference" using ADR_TEMPLATE, ADR_ID, LANGUAGE, FRAMEWORK, PACKAGE_MANAGER, TEST_RUNNER)
SET ADR_FILE := <PATH> (from "Agent Inference" using ADR_DIR, ADR_ID; append .md)
USE `search/fileSearch` where: pattern=ADR_FILE
CAPTURE ADR_COLLISION from `search/fileSearch`
IF ADR_COLLISION is not empty:
  RETURN: error="The date-based ADR path already exists; choose a distinct descriptive slug."
USE `edit/createFile` where: content=ADR_CONTENT, filePath=ADR_FILE
SET CREATED_ADRS := CREATED_ADRS + [ADR_FILE] (from "Agent Inference")
</process>

<process id="create-core-components" name="Create core-component files for each cross-cutting concern">
FOREACH concern IN CROSS_CUTTING_CONCERNS:
  SET CC_SLUG := <SLUG> (from "Agent Inference" using concern; produce a lowercase hyphenated description)
  SET CC_ID := <ID> (from "Agent Inference" using ARTIFACT_DATE, CC_SLUG; format CORE-COMPONENT-yymmdd-short-slug)
  SET CC_CONTENT := <CONTENT> (from "Agent Inference" using CORE_COMPONENT_TEMPLATE, concern, CC_ID, CREATED_ADRS)
  SET CC_FILE := <PATH> (from "Agent Inference" using CORE_COMPONENT_DIR, CC_ID; append .md)
  USE `search/fileSearch` where: pattern=CC_FILE
  CAPTURE CC_COLLISION from `search/fileSearch`
  IF CC_COLLISION is not empty:
    RETURN: error="The date-based core-component path already exists; choose a distinct descriptive slug."
  USE `edit/createFile` where: content=CC_CONTENT, filePath=CC_FILE
  SET CREATED_CORE_COMPONENTS := CREATED_CORE_COMPONENTS + [CC_FILE] (from "Agent Inference")
</process>

<process id="create-development-standards" name="Create the development standards core-component">
SET DEV_STD_ID := <ID> (from "Agent Inference" using ARTIFACT_DATE; format CORE-COMPONENT-yymmdd-development-standards)
SET DEV_STD_CONTENT := <CONTENT> (from "Agent Inference" using CORE_COMPONENT_TEMPLATE, DEVELOPMENT_STANDARDS, LANGUAGE, DEV_STD_ID, CREATED_ADRS)
SET DEV_STD_FILE := <PATH> (from "Agent Inference" using CORE_COMPONENT_DIR, DEV_STD_ID; append .md)
USE `search/fileSearch` where: pattern=DEV_STD_FILE
CAPTURE DEV_STD_COLLISION from `search/fileSearch`
IF DEV_STD_COLLISION is not empty:
  RETURN: error="The date-based development standards path already exists."
USE `edit/createFile` where: content=DEV_STD_CONTENT, filePath=DEV_STD_FILE
SET CREATED_CORE_COMPONENTS := CREATED_CORE_COMPONENTS + [DEV_STD_FILE] (from "Agent Inference")
SET DEV_STD_DECISIONS := <DECISIONS> (from "Agent Inference" using DEVELOPMENT_STANDARDS, DEV_STD_ID)
</process>

<process id="update-decision-log" name="Update DECISION-LOG.md with all new ADRs and core-components">
TRY:
  USE `read/readFile` where: filePath=DECISION_LOG_PATH
  CAPTURE CURRENT_LOG from `read/readFile`
  SET DECISION_LOG_EXISTS := true (from "Agent Inference")
RECOVER (err):
  SET CURRENT_LOG := DECISION_LOG_SKELETON (from "Constant Lookup")
  SET DECISION_LOG_EXISTS := false (from "Agent Inference")
SET UPDATED_LOG := <LOG> (from "Agent Inference" using CURRENT_LOG, CREATED_ADRS, CREATED_CORE_COMPONENTS, DEV_STD_DECISIONS)
IF DECISION_LOG_EXISTS is true:
  USE `edit/editFiles` where: filePath=DECISION_LOG_PATH
ELSE:
  USE `edit/createFile` where: content=UPDATED_LOG, filePath=DECISION_LOG_PATH
SET UPDATED_FILES := UPDATED_FILES + [DECISION_LOG_PATH] (from "Agent Inference")
</process>

<process id="update-project-docs" name="Update README, application docs, AGENTS.md, and LLM.txt">
USE `read/readFile` where: filePath=README_PATH
CAPTURE CURRENT_README from `read/readFile`
SET UPDATED_README := <CONTENT> (from "Agent Inference" using CURRENT_README, PROJECT_NAME, PROJECT_DESCRIPTION, PROJECT_GOAL)
USE `edit/editFiles` where: filePath=README_PATH
SET UPDATED_FILES := UPDATED_FILES + [README_PATH] (from "Agent Inference")
USE `read/readFile` where: filePath=APP_DOCS_PATH
CAPTURE CURRENT_APP_DOCS from `read/readFile`
SET UPDATED_APP_DOCS := <CONTENT> (from "Agent Inference" using CURRENT_APP_DOCS, PROJECT_NAME, PROJECT_DESCRIPTION, PROJECT_GOAL, LANGUAGE, FRAMEWORK)
USE `edit/editFiles` where: filePath=APP_DOCS_PATH
SET UPDATED_FILES := UPDATED_FILES + [APP_DOCS_PATH] (from "Agent Inference")
USE `read/readFile` where: filePath=AGENTS_MD_PATH
CAPTURE CURRENT_AGENTS from `read/readFile`
SET UPDATED_AGENTS := <CONTENT> (from "Agent Inference" using CURRENT_AGENTS, CREATED_ADRS, CREATED_CORE_COMPONENTS)
USE `edit/editFiles` where: filePath=AGENTS_MD_PATH
SET UPDATED_FILES := UPDATED_FILES + [AGENTS_MD_PATH] (from "Agent Inference")
USE `read/readFile` where: filePath=LLM_TXT_PATH
CAPTURE CURRENT_LLM_TXT from `read/readFile`
SET UPDATED_LLM_TXT := <CONTENT> (from "Agent Inference" using CURRENT_LLM_TXT, CREATED_ADRS, CREATED_CORE_COMPONENTS, LANGUAGE)
USE `edit/editFiles` where: filePath=LLM_TXT_PATH
SET UPDATED_FILES := UPDATED_FILES + [LLM_TXT_PATH] (from "Agent Inference")
</process>

<process id="tailor-devcontainer" name="Tailor devcontainer.json to the chosen tech stack">
USE `read/readFile` where: filePath=DEVCONTAINER_PATH
CAPTURE CURRENT_DEVCONTAINER from `read/readFile`
SET UPDATED_DEVCONTAINER := <CONTENT> (from "Agent Inference" using CURRENT_DEVCONTAINER, LANGUAGE, FRAMEWORK, PACKAGE_MANAGER; preserve or add a just feature)
USE `edit/editFiles` where: filePath=DEVCONTAINER_PATH
SET UPDATED_FILES := UPDATED_FILES + [DEVCONTAINER_PATH] (from "Agent Inference")
</process>

<process id="configure-operations" name="Write project operating commands to the root justfile">
SET JUSTFILE_CONTENT := <CONTENT> (from "Agent Inference" using OPERATING_COMMANDS, JUSTFILE_CONTRACT; create deterministic recipes with raw project commands only in recipe bodies)
USE `edit/createFile` where: content=JUSTFILE_CONTENT, filePath=JUSTFILE_PATH
USE `execute/runInTerminal` where: command="just --list"
CAPTURE JUSTFILE_LIST from `execute/runInTerminal`
SET JUSTFILE_VALID := <VALID> (from "Agent Inference" using JUSTFILE_LIST, JUSTFILE_CONTRACT)
IF JUSTFILE_VALID is false:
  RETURN: format="BOOTSTRAP_BLOCKED", evidence=JUSTFILE_LIST, reason="Generated justfile does not satisfy the command contract", suggestion="Correct the recipe definitions before continuing bootstrap"
SET UPDATED_FILES := UPDATED_FILES + [JUSTFILE_PATH] (from "Agent Inference")
</process>

</processes>

<input>
USER_INPUT is the user's description of the project they want to bootstrap, including project name, goal, tech stack preferences, and cross-cutting concerns.
</input>
