<instructions>
You MUST read the research brief before planning.
You MUST create ADRs only when required by the research brief.
You MUST create core-components only when required by the research brief.
You MUST update the decision log for every architecture artifact change.
You MUST write the action plan, task breakdown, and test plan.
You MUST ensure every task has acceptance criteria and test coverage.
</instructions>

<constants>
ACTION_PLAN_PATH: "project/issues/<ISSUE_NUMBER>/plan/01-action-plan.md"
ACTION_PLAN_TEMPLATE_PATH: ".github/skills/templates/action-plan.md"
ADR_DIR: "project/architecture/ADR"
ADR_TEMPLATE_PATH: ".github/skills/templates/adr.md"
ARTIFACT_CONTRACT_PATH: ".github/skills/templates/artifact-contract.md"
CORE_COMPONENT_DIR: "project/architecture/core-components"
CORE_COMPONENT_TEMPLATE_PATH: ".github/skills/templates/core-component.md"
DECISION_LOG_PATH: "project/architecture/ADR/DECISION-LOG.md"
DECISION_LOG_TEMPLATE_PATH: ".github/skills/templates/decision-log.md"
RESEARCH_BRIEF_PATH: "project/issues/<ISSUE_NUMBER>/research/00-research.md"
TASK_BREAKDOWN_PATH: "project/issues/<ISSUE_NUMBER>/plan/02-task-breakdown.md"
TASK_BREAKDOWN_TEMPLATE_PATH: ".github/skills/templates/task-breakdown.md"
TEST_PLAN_PATH: "project/issues/<ISSUE_NUMBER>/plan/03-test-plan.md"
TEST_PLAN_TEMPLATE_PATH: ".github/skills/templates/test-plan.md"
</constants>

<formats>
<format id="PLAN_SUMMARY_V1" name="Planning Summary" purpose="Summarize planning artifacts written for an issue.">
# Planning Summary: #<ISSUE_NUMBER>

## Artifacts
<ARTIFACTS>

## Architecture
<ARCHITECTURE_SUMMARY>

## Tasks
<TASK_SUMMARY>
WHERE:
- <ARCHITECTURE_SUMMARY> is Markdown.
- <ARTIFACTS> is Markdown.
- <ISSUE_NUMBER> is String.
- <TASK_SUMMARY> is Markdown.
</format>
</formats>

<runtime>
ACTION_PLAN: ""
ACTION_PLAN_TEMPLATE: ""
ARTIFACT_CONTRACT: ""
CREATED_ADRS: []
CREATED_CORE_COMPONENTS: []
CURRENT_ISSUE_NUMBER: ""
DECISION_LOG_TEMPLATE: ""
RESEARCH_BRIEF: ""
TASK_BREAKDOWN_TEMPLATE: ""
TASKS: []
TEST_PLAN_TEMPLATE: ""
TESTS: []
</runtime>

<triggers>
<trigger event="user_message" target="plan-issue" />
</triggers>

<processes>
<process id="plan-issue" name="Plan issue implementation">
RUN `load-planning-context`
RUN `create-architecture-artifacts`
RUN `write-action-plan`
RUN `write-task-breakdown`
RUN `write-test-plan`
RETURN: format="PLAN_SUMMARY_V1", architecture_summary=CREATED_ADRS, artifacts=[ACTION_PLAN_PATH, TASK_BREAKDOWN_PATH, TEST_PLAN_PATH], issue_number=CURRENT_ISSUE_NUMBER, task_summary=TASKS
</process>

<process id="load-planning-context" name="Load research and templates">
SET CURRENT_ISSUE_NUMBER := <ID> (from "Agent Inference" using USER_INPUT)
USE `Read` where: path=RESEARCH_BRIEF_PATH
CAPTURE RESEARCH_BRIEF from `Read`
USE `Read` where: path=ADR_TEMPLATE_PATH
CAPTURE ADR_TEMPLATE from `Read`
USE `Read` where: path=CORE_COMPONENT_TEMPLATE_PATH
CAPTURE CORE_COMPONENT_TEMPLATE from `Read`
USE `Read` where: path=DECISION_LOG_PATH
CAPTURE DECISION_LOG from `Read`
USE `Read` where: path=ARTIFACT_CONTRACT_PATH
CAPTURE ARTIFACT_CONTRACT from `Read`
USE `Read` where: path=ACTION_PLAN_TEMPLATE_PATH
CAPTURE ACTION_PLAN_TEMPLATE from `Read`
USE `Read` where: path=TASK_BREAKDOWN_TEMPLATE_PATH
CAPTURE TASK_BREAKDOWN_TEMPLATE from `Read`
USE `Read` where: path=TEST_PLAN_TEMPLATE_PATH
CAPTURE TEST_PLAN_TEMPLATE from `Read`
USE `Read` where: path=DECISION_LOG_TEMPLATE_PATH
CAPTURE DECISION_LOG_TEMPLATE from `Read`
</process>

<process id="create-architecture-artifacts" name="Create required architecture artifacts">
SET CREATED_ADRS := <ADRS> (from "Agent Inference" using ADR_DIR, ADR_TEMPLATE, ARTIFACT_CONTRACT, RESEARCH_BRIEF)
SET CREATED_CORE_COMPONENTS := <CORE_COMPONENTS> (from "Agent Inference" using ARTIFACT_CONTRACT, CORE_COMPONENT_DIR, CORE_COMPONENT_TEMPLATE, RESEARCH_BRIEF)
IF CREATED_ADRS is not empty OR CREATED_CORE_COMPONENTS is not empty:
  SET UPDATED_DECISION_LOG := <LOG> (from "Agent Inference" using ARTIFACT_CONTRACT, DECISION_LOG, DECISION_LOG_TEMPLATE, CREATED_ADRS, CREATED_CORE_COMPONENTS)
  USE `Write` where: content=UPDATED_DECISION_LOG, path=DECISION_LOG_PATH
</process>

<process id="write-action-plan" name="Write action plan">
SET ACTION_PLAN := <PLAN> (from "Agent Inference" using ACTION_PLAN_TEMPLATE, ARTIFACT_CONTRACT, RESEARCH_BRIEF, CREATED_ADRS, CREATED_CORE_COMPONENTS)
USE `Write` where: content=ACTION_PLAN, path=ACTION_PLAN_PATH
</process>

<process id="write-task-breakdown" name="Write task breakdown">
SET TASKS := <TASK_LIST> (from "Agent Inference" using ACTION_PLAN, CREATED_ADRS, CREATED_CORE_COMPONENTS)
SET TASK_BREAKDOWN := <BREAKDOWN> (from "Agent Inference" using TASKS, TASK_BREAKDOWN_TEMPLATE)
USE `Write` where: content=TASK_BREAKDOWN, path=TASK_BREAKDOWN_PATH
</process>

<process id="write-test-plan" name="Write test plan">
SET TESTS := <TEST_LIST> (from "Agent Inference" using TASKS)
SET TEST_PLAN := <PLAN> (from "Agent Inference" using TESTS, TEST_PLAN_TEMPLATE)
USE `Write` where: content=TEST_PLAN, path=TEST_PLAN_PATH
</process>
</processes>

<input>
USER_INPUT is a GitHub issue number or reference to a completed research brief.
</input>
