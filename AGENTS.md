# Agents — Soft Factory Pipeline Specification

<instructions>
Every piece of work MUST flow through exactly five stages in order: Research, Architect, Plan, Implement, Ship.
You MUST classify scope_type as exactly one of: workitem, architecture_decision, core_component.
You MUST NOT create an architectural decision outside of an ADR document.
You MUST NOT create reusable cross-cutting behavior outside of a core-component document.
You MUST update docs/architecture/ADR/DECISION-LOG.md for every ADR or core-component change.
You MUST treat ADRs as global artifacts stored in docs/architecture/ADR/ — never inside a workitem folder.
You MUST treat core-components as global artifacts stored in docs/architecture/core-components/ — never inside a workitem folder.
You MUST NOT edit template files directly — copy them within the same directory and rename.
You MUST return to the Architect stage if implementation diverges from an ADR or core-component.
You MUST inspect existing repo code and documentation before proposing new work.
You MUST NOT skip any stage in the pipeline.
</instructions>

<constants>
PIPELINE_STAGES: YAML<<
- id: research
  name: Research
  agent: research
  purpose: Explore the problem space, classify scope, produce a research brief
- id: architect
  name: Architect
  agent: architect
  purpose: Commit decisions via ADRs and core-components, produce an action plan
- id: plan
  name: Plan
  agent: planner
  purpose: Break work into tasks with acceptance criteria and test plans
- id: implement
  name: Implement
  agent: implementer
  purpose: Execute tasks, write code and tests, verify against the plan
- id: ship
  name: Ship
  agent: ship-it
  purpose: Run tests, commit, push, and open a pull request for review
>>
AGENTS: YAML<<
bootstrap:
  file: .github/agents/bootstrap.agent.md
  purpose: Bootstrap a new project from the Soft Factory template by gathering project identity, tech stack, and cross-cutting concerns, then scaffolding the codebase and seeding architectural artifacts.
  tools:
    - codebase exploration and editing
    - file creation and editing
    - terminal execution
  read_paths:
    - docs/
    - docs/architecture/ADR/ADR-0001-template.md
    - docs/architecture/core-components/CORE-COMPONENT-0001-template.md
    - docs/architecture/ADR/DECISION-LOG.md
    - .devcontainer/devcontainer.json
    - README.md
    - AGENTS.md
    - LLM.txt
  write_paths:
    - docs/architecture/ADR/ADR-####-slug.md
    - docs/architecture/core-components/CORE-COMPONENT-####-slug.md
    - docs/architecture/ADR/DECISION-LOG.md
    - README.md
    - docs/application/README.md
    - AGENTS.md
    - LLM.txt
    - .devcontainer/devcontainer.json
  templates:
    - docs/architecture/ADR/ADR-0001-template.md
    - docs/architecture/core-components/CORE-COMPONENT-0001-template.md
  guardrails:
    - must check whether the project has already been bootstrapped before proceeding
    - must refuse to run if the project is already bootstrapped
    - must gather project name, description, and goal from the user interactively
    - must ask user to choose tech stack and identify cross-cutting concerns
    - must scaffold the project using the appropriate init command
    - must create an ADR for the tech stack decision
    - must create a core-component file for each declared cross-cutting concern
    - must update DECISION-LOG.md with all new ADRs and core-components
    - must record decision records in the Decisions section of DECISION-LOG.md for every ADR and core-component created
    - must not set up CI/CD pipelines or infrastructure
    - must not make feature-level decisions
research:
  file: .github/agents/research.agent.md
  purpose: Explore the problem space, classify scope, and produce a research brief that hands off cleanly to the Architect stage.
  tools:
    - web search and documentation lookup
    - codebase exploration (grep, glob, file reading)
    - external API/library research
  read_paths:
    - docs/
    - docs/architecture/ADR/
    - docs/architecture/core-components/
    - docs/architecture/ADR/DECISION-LOG.md
    - application source code
  write_paths:
    - docs/workitems/<WI-ID>/research/00-research.md
  templates:
    - Research Brief (Section 5.1)
  guardrails:
    - classify scope_type as exactly one of workitem, architecture_decision, core_component
    - inspect existing repo code and docs before proposing new work
    - explicitly state if ADRs or core-components are required
    - propose ADR titles and core-component titles when applicable
    - never make architectural decisions — only propose them
architect:
  file: .github/agents/architect.agent.md
  purpose: Commit architectural decisions by creating ADRs and core-components, and update the decision registry.
  tools:
    - file creation and editing
    - codebase exploration
  read_paths:
    - docs/workitems/<WI-ID>/research/00-research.md
    - docs/architecture/ADR/ADR-0001-template.md
    - docs/architecture/core-components/CORE-COMPONENT-0001-template.md
    - docs/architecture/ADR/DECISION-LOG.md
    - docs/architecture/ADR/
    - docs/architecture/core-components/
  write_paths:
    - docs/architecture/ADR/ADR-####-slug.md
    - docs/architecture/core-components/CORE-COMPONENT-####-slug.md
    - docs/architecture/ADR/DECISION-LOG.md
    - docs/workitems/<WI-ID>/plan/01-action-plan.md
  templates:
    - docs/architecture/ADR/ADR-0001-template.md
    - docs/architecture/core-components/CORE-COMPONENT-0001-template.md
  guardrails:
    - no architectural decision exists unless it is in an ADR
    - no reusable cross-cutting behavior exists unless it is a core-component
    - every ADR or core-component change must update DECISION-LOG.md
    - every ADR or core-component must produce at least one decision record in the Decisions section of DECISION-LOG.md
    - decision records are short actionable statements referencing their source ADR or core-component
    - ADRs and core-components are global — not scoped to a workitem
    - must create a Plan of Attack (01-action-plan.md) for the workitem
planner:
  file: .github/agents/planner.agent.md
  purpose: Transform intent into executable, testable work by producing a task breakdown and test plan.
  tools:
    - file creation and editing
    - codebase exploration
  read_paths:
    - docs/workitems/<WI-ID>/plan/01-action-plan.md
    - docs/architecture/ADR/
    - docs/architecture/core-components/
    - application source code
  write_paths:
    - docs/workitems/<WI-ID>/plan/02-task-breakdown.md
    - docs/workitems/<WI-ID>/plan/03-test-plan.md
  templates:
    - Task Breakdown (Section 5.5)
    - Test Plan (Section 5.6)
  guardrails:
    - every task must have acceptance criteria
    - every task must have explicit test coverage requirements
    - tasks must reference relevant ADRs and core-components
    - must not deviate from decisions made in the Architect stage
implementer:
  file: .github/agents/implementer.agent.md
  purpose: Execute tasks from the plan, produce code and tests, and verify implementation against the test plan.
  tools:
    - code generation and editing
    - build and test execution
    - file creation
  read_paths:
    - docs/workitems/<WI-ID>/plan/
    - docs/architecture/ADR/
    - docs/architecture/core-components/
    - application source code
  write_paths:
    - application source code
    - test files
    - docs/workitems/<WI-ID>/implementation/README.md
  templates: []
  guardrails:
    - must implement within architectural boundaries defined by ADRs and core-components
    - deviations from ADRs or core-components require returning to the Architect stage
    - implementation must satisfy the test plan
    - must not skip tests defined in the test plan
ship-it:
  file: .github/agents/ship-it.agent.md
  purpose: Ship completed work — run tests, create commits following Conventional Commits, push, and open a PR assigned to copilot for review.
  tools:
    - terminal execution (git, gh, test runners)
    - file reading and editing
    - codebase exploration
  read_paths:
    - docs/architecture/ADR/DECISION-LOG.md
    - docs/architecture/ADR/
    - docs/architecture/core-components/
    - AGENTS.md
    - docs/workitems/<WI-ID>/
    - application source code and test files
  write_paths:
    - docs/architecture/ADR/DECISION-LOG.md
    - AGENTS.md
    - docs/
    - README.md
  templates: []
  guardrails:
    - must not proceed if tests fail
    - must not push directly to main or master
    - must create feature branches following pattern <type>/<WI-ID>-<short-slug> (e.g., feat/WI-0002-readme-cleanup)
    - must follow Conventional Commits for all commit messages and the PR title
    - must include Co-authored-by trailer on every commit
    - must not force-push or use --no-verify
    - must not modify application source code
    - must verify the branch is clean after all commits
    - must assign the PR to copilot for review
>>
TEMPLATE_PATHS: YAML<<
adr: docs/architecture/ADR/ADR-0001-template.md
core_component: docs/architecture/core-components/CORE-COMPONENT-0001-template.md
action_plan: docs/workitems/<WI-ID>/plan/01-action-plan.md
task_breakdown: docs/workitems/<WI-ID>/plan/02-task-breakdown.md
test_plan: docs/workitems/<WI-ID>/plan/03-test-plan.md
research_brief: docs/workitems/<WI-ID>/research/00-research.md
>>
SCOPE_TYPES: YAML<<
- workitem
- architecture_decision
- core_component
>>
NAMING: YAML<<
workitems: "WI-####-short-slug"
adrs: "ADR-####-short-slug.md"
core_components: "CORE-COMPONENT-####-short-slug.md"
>>
</constants>

<processes>
<process id="pipeline-route" name="Route work through the pipeline based on scope classification">
RUN `research`
IF SCOPE_TYPE = "workitem":
  RUN `architect`
  RUN `plan`
  RUN `implement`
  RUN `ship`
IF SCOPE_TYPE = "architecture_decision":
  RUN `architect`
  RUN `plan`
  RUN `implement`
  RUN `ship`
IF SCOPE_TYPE = "core_component":
  RUN `architect`
  RUN `plan`
  RUN `implement`
  RUN `ship`
RETURN: SCOPE_TYPE, WI_ID
</process>

<process id="research" name="Research stage">
SET SCOPE_TYPE := <CLASSIFICATION> (from "research" using USER_INPUT)
SET WI_ID := <ID> (from "research")
</process>

<process id="architect" name="Architect stage">
SET ADRS := <ADR_LIST> (from "architect" using WI_ID, SCOPE_TYPE)
SET CORE_COMPONENTS := <CC_LIST> (from "architect" using WI_ID, SCOPE_TYPE)
SET DECISIONS := <DECISION_LIST> (from "architect" using ADRS, CORE_COMPONENTS)
SET ACTION_PLAN := <PLAN> (from "architect" using WI_ID)
</process>

<process id="plan" name="Plan stage">
SET TASK_BREAKDOWN := <TASKS> (from "planner" using WI_ID, ACTION_PLAN)
SET TEST_PLAN := <TESTS> (from "planner" using WI_ID, TASK_BREAKDOWN)
</process>

<process id="implement" name="Implement stage">
SET RESULT := <OUTCOME> (from "implementer" using WI_ID, TASK_BREAKDOWN, TEST_PLAN)
</process>

<process id="ship" name="Ship stage">
SET SHIP_RESULT := <OUTCOME> (from "ship-it" using WI_ID)
</process>
</processes>
