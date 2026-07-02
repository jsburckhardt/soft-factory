<instructions>
You MUST check for existing bootstrap evidence before changing files.
You MUST gather project identity and tech stack details from the user.
You MUST ask for verification command confirmation before writing config.
You MUST scaffold the selected project type.
You MUST create required ADR and core-component artifacts.
You MUST update the decision log and project documentation.
You MUST NOT create CI/CD infrastructure.
</instructions>

<constants>
ADR_TEMPLATE_PATH: ".github/skills/templates/adr.md"
APP_DOCS_PATH: "docs/README.md"
ARTIFACT_CONTRACT_PATH: ".github/skills/templates/artifact-contract.md"
BOOTSTRAP_MARKER_PATTERN: "project/architecture/ADR/ADR-0002-*.md"
CORE_COMPONENT_TEMPLATE_PATH: ".github/skills/templates/core-component.md"
DECISION_LOG_PATH: "project/architecture/ADR/DECISION-LOG.md"
DECISION_LOG_TEMPLATE_PATH: ".github/skills/templates/decision-log.md"
DEVCONTAINER_PATH: ".devcontainer/devcontainer.json"
LLM_TXT_PATH: "LLM.txt"
README_PATH: "README.md"
VERIFICATION_CONFIG_PATH: ".github/soft-factory/verification.yml"
</constants>

<formats>
<format id="BOOTSTRAP_CONFIRMATION_V1" name="Bootstrap Confirmation" purpose="Request confirmation before bootstrap writes files.">
# Bootstrap Confirmation Required

## Project
- **Name:** <PROJECT_NAME>
- **Description:** <PROJECT_DESCRIPTION>
- **Tech Stack:** <TECH_STACK>

## Planned cross-cutting concerns
<CROSS_CUTTING_CONCERNS>

## Verification commands
<VERIFICATION_COMMANDS>

Reply with confirmation before this workflow writes files.
WHERE:
- <CROSS_CUTTING_CONCERNS> is Markdown.
- <PROJECT_DESCRIPTION> is String.
- <PROJECT_NAME> is String.
- <TECH_STACK> is String.
- <VERIFICATION_COMMANDS> is Markdown.
</format>

<format id="BOOTSTRAP_REPORT_V1" name="Bootstrap Report" purpose="Summarize project bootstrap actions.">
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

## Status
<STATUS>
WHERE:
- <ADR_LIST> is Markdown.
- <CORE_COMPONENT_LIST> is Markdown.
- <FILES_UPDATED> is Markdown.
- <PROJECT_DESCRIPTION> is String.
- <PROJECT_NAME> is String.
- <SCAFFOLD_OUTPUT> is Markdown.
- <STATUS> is String.
</format>
</formats>

<runtime>
CREATED_ADRS: []
CREATED_CORE_COMPONENTS: []
ARTIFACT_CONTRACT: ""
CROSS_CUTTING_CONCERNS: []
DECISION_LOG_TEMPLATE: ""
INFO_CONFIRMED: false
IS_BOOTSTRAPPED: false
PROJECT_DESCRIPTION: ""
PROJECT_NAME: ""
TECH_STACK: ""
UPDATED_FILES: []
VERIFICATION_COMMANDS: {}
</runtime>

<triggers>
<trigger event="user_message" target="bootstrap-project" />
</triggers>

<processes>
<process id="bootstrap-project" name="Bootstrap project">
RUN `check-bootstrapped`
IF IS_BOOTSTRAPPED is true:
  RETURN: error="Project has already been bootstrapped"
RUN `gather-project-info`
IF INFO_CONFIRMED is false:
  RETURN: format="BOOTSTRAP_CONFIRMATION_V1", cross_cutting_concerns=CROSS_CUTTING_CONCERNS, project_description=PROJECT_DESCRIPTION, project_name=PROJECT_NAME, tech_stack=TECH_STACK, verification_commands=VERIFICATION_COMMANDS
RUN `scaffold-project`
RUN `create-architecture-artifacts`
RUN `configure-verification`
RUN `update-project-docs`
RETURN: format="BOOTSTRAP_REPORT_V1", adr_list=CREATED_ADRS, core_component_list=CREATED_CORE_COMPONENTS, files_updated=UPDATED_FILES, project_description=PROJECT_DESCRIPTION, project_name=PROJECT_NAME, scaffold_output=SCAFFOLD_OUTPUT, status="Bootstrapped"
</process>

<process id="check-bootstrapped" name="Check bootstrap status">
USE `Glob` where: path=".", pattern=BOOTSTRAP_MARKER_PATTERN
CAPTURE EXISTING_ADRS from `Glob`
IF EXISTING_ADRS is not empty:
  SET IS_BOOTSTRAPPED := true (from "Agent Inference")
ELSE:
  SET IS_BOOTSTRAPPED := false (from "Agent Inference")
</process>

<process id="gather-project-info" name="Gather project information">
SET PROJECT_NAME := <NAME> (from "Agent Inference" using USER_INPUT)
SET PROJECT_DESCRIPTION := <DESCRIPTION> (from "Agent Inference" using USER_INPUT)
SET TECH_STACK := <STACK> (from "Agent Inference" using USER_INPUT)
SET CROSS_CUTTING_CONCERNS := <CONCERNS> (from "Agent Inference" using USER_INPUT)
SET INFO_CONFIRMED := <CONFIRMED> (from "Agent Inference" using USER_INPUT)
SET VERIFICATION_COMMANDS := <COMMANDS> (from "Agent Inference" using USER_INPUT, TECH_STACK)
</process>

<process id="scaffold-project" name="Scaffold selected project">
SET INIT_COMMAND := <COMMAND> (from "Agent Inference" using TECH_STACK)
USE `Shell` where: command=INIT_COMMAND
CAPTURE SCAFFOLD_OUTPUT from `Shell`
</process>

<process id="create-architecture-artifacts" name="Create foundational architecture artifacts">
USE `Read` where: path=ADR_TEMPLATE_PATH
CAPTURE ADR_TEMPLATE from `Read`
USE `Read` where: path=CORE_COMPONENT_TEMPLATE_PATH
CAPTURE CORE_COMPONENT_TEMPLATE from `Read`
USE `Read` where: path=DECISION_LOG_TEMPLATE_PATH
CAPTURE DECISION_LOG_TEMPLATE from `Read`
USE `Read` where: path=ARTIFACT_CONTRACT_PATH
CAPTURE ARTIFACT_CONTRACT from `Read`
SET CREATED_ADRS := <ADRS> (from "Agent Inference" using ADR_TEMPLATE, PROJECT_NAME, TECH_STACK)
SET CREATED_CORE_COMPONENTS := <CORE_COMPONENTS> (from "Agent Inference" using CORE_COMPONENT_TEMPLATE, CROSS_CUTTING_CONCERNS)
SET UPDATED_DECISION_LOG := <LOG> (from "Agent Inference" using ARTIFACT_CONTRACT, CREATED_ADRS, CREATED_CORE_COMPONENTS, DECISION_LOG_TEMPLATE)
USE `Write` where: content=UPDATED_DECISION_LOG, path=DECISION_LOG_PATH
</process>

<process id="configure-verification" name="Configure verification commands">
SET VERIFICATION_YAML := <YAML> (from "Agent Inference" using VERIFICATION_COMMANDS)
USE `Write` where: content=VERIFICATION_YAML, path=VERIFICATION_CONFIG_PATH
</process>

<process id="update-project-docs" name="Update project documentation">
SET DOC_UPDATES := <UPDATES> (from "Agent Inference" using PROJECT_NAME, PROJECT_DESCRIPTION, TECH_STACK, CREATED_ADRS, CREATED_CORE_COMPONENTS)
USE `Write` where: content=DOC_UPDATES.readme, path=README_PATH
USE `Write` where: content=DOC_UPDATES.docs, path=APP_DOCS_PATH
USE `Write` where: content=DOC_UPDATES.llm, path=LLM_TXT_PATH
USE `Write` where: content=DOC_UPDATES.devcontainer, path=DEVCONTAINER_PATH
SET UPDATED_FILES := <FILES> (from "Agent Inference" using DOC_UPDATES)
</process>
</processes>

<input>
USER_INPUT is the user's project description, goal, tech stack preferences, and cross-cutting concerns.
</input>
