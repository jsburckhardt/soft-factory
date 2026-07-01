<instructions>
You MUST read the pipeline specification before starting.
You MUST validate issue acceptance criteria before Research.
You MUST execute Research, Plan, Implement, and Verify in order.
You MUST verify each stage output before continuing.
You MUST NOT skip stages.
You MUST report the failed stage when the pipeline stops.
</instructions>

<constants>
AGENTS_MD_PATH: "AGENTS.md"
DECISION_LOG_PATH: "project/architecture/ADR/DECISION-LOG.md"
ISSUES_DIR: "project/issues"
STAGES: YAML<<
- id: research
  output: project/issues/<ISSUE_NUMBER>/research/00-research.md
- id: plan
  output: project/issues/<ISSUE_NUMBER>/plan/01-action-plan.md
- id: implement
  output: project/issues/<ISSUE_NUMBER>/implementation/README.md
- id: verify
  output: project/issues/<ISSUE_NUMBER>/verify/summary.md
>>
</constants>

<formats>
<format id="PIPELINE_RESULT_V1" name="Pipeline Result" purpose="Summarize full RPIV pipeline execution.">
# Pipeline Complete - #<ISSUE_NUMBER>

## Task
<TASK_DESCRIPTION>

## Stages
<STAGE_RESULTS>

## Final Result
<FINAL_RESULT>
WHERE:
- <FINAL_RESULT> is Markdown.
- <ISSUE_NUMBER> is String.
- <STAGE_RESULTS> is Markdown.
- <TASK_DESCRIPTION> is Markdown.
</format>
</formats>

<runtime>
CURRENT_STAGE: ""
ISSUE_NUMBER: ""
PIPELINE_STATUS: ""
STAGE_RESULTS: []
TASK_DESCRIPTION: ""
</runtime>

<triggers>
<trigger event="user_message" target="run-rpiv-pipeline" />
</triggers>

<processes>
<process id="run-rpiv-pipeline" name="Run RPIV pipeline">
RUN `init-pipeline`
RUN `run-research`
RUN `run-plan`
RUN `run-implement`
RUN `run-verify`
RETURN: format="PIPELINE_RESULT_V1", final_result=PIPELINE_STATUS, issue_number=ISSUE_NUMBER, stage_results=STAGE_RESULTS, task_description=TASK_DESCRIPTION
</process>

<process id="init-pipeline" name="Initialize pipeline context">
USE `Read` where: path=AGENTS_MD_PATH
CAPTURE PIPELINE_SPEC from `Read`
USE `Read` where: path=DECISION_LOG_PATH
CAPTURE DECISION_LOG from `Read`
SET ISSUE_NUMBER := <NUMBER> (from "Agent Inference" using USER_INPUT)
USE `Shell` where: command="gh issue view <ISSUE_NUMBER> --json title,body,labels,assignees,milestone"
CAPTURE ISSUE_JSON from `Shell`
SET TASK_DESCRIPTION := <DESC> (from "Agent Inference" using ISSUE_JSON)
SET HAS_ACCEPTANCE_CRITERIA := <HAS_AC> (from "Agent Inference" using ISSUE_JSON)
IF HAS_ACCEPTANCE_CRITERIA is false:
  RETURN: error="Issue missing structured acceptance criteria"
</process>

<process id="run-research" name="Run Research stage">
SET CURRENT_STAGE := "research" (from "Agent Inference")
SET RESEARCH_RESULT := <RESULT> (from "Agent Inference" using ISSUE_NUMBER, TASK_DESCRIPTION)
SET STAGE_RESULTS := STAGE_RESULTS + ["Research complete"] (from "Agent Inference")
</process>

<process id="run-plan" name="Run Plan stage">
SET CURRENT_STAGE := "plan" (from "Agent Inference")
SET PLAN_RESULT := <RESULT> (from "Agent Inference" using ISSUE_NUMBER, RESEARCH_RESULT)
SET STAGE_RESULTS := STAGE_RESULTS + ["Plan complete"] (from "Agent Inference")
</process>

<process id="run-implement" name="Run Implement stage">
SET CURRENT_STAGE := "implement" (from "Agent Inference")
SET IMPLEMENT_RESULT := <RESULT> (from "Agent Inference" using ISSUE_NUMBER, PLAN_RESULT)
SET STAGE_RESULTS := STAGE_RESULTS + ["Implement complete"] (from "Agent Inference")
</process>

<process id="run-verify" name="Run Verify stage">
SET CURRENT_STAGE := "verify" (from "Agent Inference")
SET VERIFY_RESULT := <RESULT> (from "Agent Inference" using ISSUE_NUMBER, IMPLEMENT_RESULT)
SET PIPELINE_STATUS := "complete" (from "Agent Inference")
SET STAGE_RESULTS := STAGE_RESULTS + ["Verify complete"] (from "Agent Inference")
</process>
</processes>

<input>
USER_INPUT is a GitHub issue number or URL to deliver through the full RPIV pipeline.
</input>
