<instructions>
You MUST read the task breakdown before implementation.
You MUST read the test plan before implementation.
You MUST respect ADR and core-component boundaries.
You MUST implement tasks in dependency order.
You MUST run tests required by the test plan.
You MUST write implementation notes.
</instructions>

<constants>
ADR_DIR: "project/architecture/ADR"
ARTIFACT_CONTRACT_PATH: ".github/skills/templates/artifact-contract.md"
CORE_COMPONENT_DIR: "project/architecture/core-components"
IMPLEMENTATION_NOTES_PATH: "project/issues/<ISSUE_NUMBER>/implementation/README.md"
IMPLEMENTATION_NOTES_TEMPLATE_PATH: ".github/skills/templates/implementation-notes.md"
TASK_BREAKDOWN_PATH: "project/issues/<ISSUE_NUMBER>/plan/02-task-breakdown.md"
TEST_PLAN_PATH: "project/issues/<ISSUE_NUMBER>/plan/03-test-plan.md"
</constants>

<formats>
<format id="IMPLEMENTATION_STATUS_V1" name="Implementation Status" purpose="Report task implementation and test results.">
## Task <TASK_ID>: <TASK_TITLE>

- **Status:** <STATUS>
- **Files Changed:** <FILES_CHANGED>
- **Tests Passed:** <TESTS_PASSED>
- **Tests Failed:** <TESTS_FAILED>

### Changes Summary
<CHANGES_SUMMARY>

### Test Results
<TEST_RESULTS>

### Notes
<NOTES>
WHERE:
- <CHANGES_SUMMARY> is Markdown.
- <FILES_CHANGED> is String.
- <NOTES> is Markdown.
- <STATUS> is String.
- <TASK_ID> is String.
- <TASK_TITLE> is String.
- <TEST_RESULTS> is Markdown.
- <TESTS_FAILED> is Integer.
- <TESTS_PASSED> is Integer.
</format>
</formats>

<runtime>
COMPLETED_TASKS: []
CURRENT_ISSUE_NUMBER: ""
CURRENT_TASK_ID: ""
ARTIFACT_CONTRACT: ""
IMPLEMENTATION_LOG: []
IMPLEMENTATION_NOTES_TEMPLATE: ""
TASK_BREAKDOWN: ""
TEST_PLAN: ""
</runtime>

<triggers>
<trigger event="user_message" target="implement-plan" />
</triggers>

<processes>
<process id="implement-plan" name="Implement planned tasks">
RUN `load-implementation-context`
RUN `implement-next-task`
RUN `verify-current-task`
RUN `write-implementation-notes`
RETURN: CURRENT_TASK_ID, COMPLETED_TASKS
</process>

<process id="load-implementation-context" name="Load task and test plans">
SET CURRENT_ISSUE_NUMBER := <ID> (from "Agent Inference" using USER_INPUT)
USE `Read` where: path=TASK_BREAKDOWN_PATH
CAPTURE TASK_BREAKDOWN from `Read`
USE `Read` where: path=TEST_PLAN_PATH
CAPTURE TEST_PLAN from `Read`
USE `Read` where: path=ARTIFACT_CONTRACT_PATH
CAPTURE ARTIFACT_CONTRACT from `Read`
USE `Read` where: path=IMPLEMENTATION_NOTES_TEMPLATE_PATH
CAPTURE IMPLEMENTATION_NOTES_TEMPLATE from `Read`
USE `Glob` where: path=".", pattern="project/architecture/ADR/ADR-*.md"
CAPTURE ADR_FILES from `Glob`
USE `Glob` where: path=".", pattern="project/architecture/core-components/CORE-COMPONENT-*.md"
CAPTURE CORE_COMPONENT_FILES from `Glob`
</process>

<process id="implement-next-task" name="Implement next pending task">
SET CURRENT_TASK_ID := <TASK_ID> (from "Agent Inference" using TASK_BREAKDOWN, COMPLETED_TASKS)
IF CURRENT_TASK_ID is empty:
  RETURN: COMPLETED_TASKS
SET TASK_SPEC := <SPEC> (from "Agent Inference" using TASK_BREAKDOWN, CURRENT_TASK_ID)
SET CODE_CHANGES := <CHANGES> (from "Agent Inference" using TASK_SPEC, ADR_FILES, CORE_COMPONENT_FILES)
</process>

<process id="verify-current-task" name="Verify current task">
SET TEST_COMMAND := <COMMAND> (from "Agent Inference" using CURRENT_TASK_ID, TEST_PLAN)
USE `Shell` where: command=TEST_COMMAND
CAPTURE TEST_OUTPUT from `Shell`
SET TEST_RESULT := <RESULT> (from "Agent Inference" using TEST_OUTPUT, TEST_PLAN)
IF TEST_RESULT is false:
  RETURN: error="Current task verification failed"
SET COMPLETED_TASKS := COMPLETED_TASKS + [CURRENT_TASK_ID] (from "Agent Inference")
</process>

<process id="write-implementation-notes" name="Write implementation notes">
SET NOTES := <NOTES> (from "Agent Inference" using ARTIFACT_CONTRACT, COMPLETED_TASKS, CURRENT_ISSUE_NUMBER, IMPLEMENTATION_NOTES_TEMPLATE, IMPLEMENTATION_STATUS_V1, TEST_OUTPUT)
USE `Write` where: content=NOTES, path=IMPLEMENTATION_NOTES_PATH
</process>
</processes>

<input>
USER_INPUT is a GitHub issue number and optionally a specific task ID to implement.
</input>
