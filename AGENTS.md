# Agents — Soft Factory Pipeline Specification

<instructions>
Every piece of work MUST flow through exactly four stages in order: Research, Plan, Implement, Verify.
You MUST classify scope_type as exactly one of: issue, architecture_decision, core_component.
You MUST NOT create an architectural decision outside of an ADR document.
You MUST NOT create reusable cross-cutting behavior outside of a core-component document.
You MUST update docs/architecture/ADR/DECISION-LOG.md for every ADR or core-component change.
You MUST treat ADRs as global artifacts stored in docs/architecture/ADR/ — never inside an issue documentation folder.
You MUST treat core-components as global artifacts stored in docs/architecture/core-components/ — never inside an issue documentation folder.
You MUST NOT edit template files directly — copy them within the same directory and rename.
You MUST return to the Plan stage if implementation diverges from an ADR or core-component.
You MUST inspect existing repo code and documentation before proposing new work.
You MUST NOT skip any stage in the pipeline.
You MUST update the APS version badge in README.md and the APS_BADGE constant when the APS skill is upgraded.
</instructions>

<constants>
APS_BADGE: "[![APS version](https://img.shields.io/badge/APS-v1.2.2-blue?logo=github)](https://github.com/chris-buckley/agnostic-prompt-standard/releases/tag/v1.2.2)"
PIPELINE_STAGES: YAML<<
- id: research
  name: Research
  agent: research
  purpose: Explore the problem space, classify scope, produce a research brief
- id: plan
  name: Plan
  agent: planner
  purpose: Commit architectural decisions via ADRs and core-components, then produce the action plan, task breakdown, and test plan
- id: implement
  name: Implement
  agent: implementer
  purpose: Execute tasks, write code and tests, verify against the plan
- id: verify
  name: Verify
  agent: verifier
  purpose: Run tests, commit, push, and open a pull request for review
>>
AGENTS: YAML<<
onboard-repo:
  file: .github/agents/onboard-repo.agent.md
  purpose: Introduce the Soft Factory engineering flow into an existing repository by analysing its codebase, inferring architectural decisions already embedded in the code, scaffolding the documentation infrastructure, and creating the first GitHub issue and seeding it with a full repository-understanding brief.
  tools:
    - codebase exploration and reading
    - file creation and editing
    - web fetch
    - GitHub CLI (gh)
  read_paths:
    - README.md
    - docs/
    - docs/architecture/ADR/ADR-0001-template.md
    - docs/architecture/core-components/CORE-COMPONENT-0001-template.md
    - docs/architecture/ADR/DECISION-LOG.md
    - AGENTS.md
    - LLM.txt
    - application source code
  write_paths:
    - docs/architecture/ADR/ADR-####-slug.md
    - docs/architecture/core-components/CORE-COMPONENT-####-slug.md
    - docs/architecture/ADR/DECISION-LOG.md
    - docs/issues/<ISSUE_NUMBER>/research/00-research.md
    - README.md
    - AGENTS.md
    - LLM.txt
  templates:
    - docs/architecture/ADR/ADR-0001-template.md
    - docs/architecture/core-components/CORE-COMPONENT-0001-template.md
  guardrails:
    - must check whether the project is already onboarded before proceeding
    - must refuse to run if the project already has the Soft Factory engineering flow
    - must analyse the existing codebase to infer tech stack and architectural decisions
    - must infer cross-cutting concerns from the existing source code
    - must create ADRs for existing architectural decisions starting from ADR-0002
    - must create core-component files for existing cross-cutting concerns starting from CORE-COMPONENT-0002
    - must update DECISION-LOG.md with all new ADRs and core-components
    - must record decision records in the Decisions section of DECISION-LOG.md for every ADR and core-component created
    - must create a GitHub issue for repository understanding and its research brief
    - must not make new feature-level decisions
    - must not scaffold or modify application source code
bootstrap:
  file: .github/agents/bootstrap.agent.md
  purpose: Bootstrap a new project from the Soft Factory template by gathering project identity, tech stack, and cross-cutting concerns, then scaffolding the codebase and seeding architectural artifacts.
  tools:
    - codebase exploration and editing
    - file creation and editing
    - terminal execution
    - GitHub CLI (gh)
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
    - .github/soft-factory/verification.yml
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
    - must configure project verification commands and write .github/soft-factory/verification.yml
    - must ask user to confirm or customize proposed verification commands
    - must not set up CI/CD pipelines or infrastructure
    - must not make feature-level decisions
research:
  file: .github/agents/research.agent.md
  purpose: Explore the problem space, classify scope, and produce a research brief that hands off cleanly to the Plan stage.
  tools:
    - web search and documentation lookup
    - codebase exploration (grep, glob, file reading)
    - external API/library research
    - GitHub CLI (gh) for fetching issue details
  read_paths:
    - docs/
    - docs/architecture/ADR/
    - docs/architecture/core-components/
    - docs/architecture/ADR/DECISION-LOG.md
    - application source code
  write_paths:
    - docs/issues/<ISSUE_NUMBER>/research/00-research.md
  templates:
    - Research Brief (Section 5.1)
  guardrails:
    - classify scope_type as exactly one of issue, architecture_decision, core_component
    - inspect existing repo code and docs before proposing new work
    - explicitly state if ADRs or core-components are required
    - propose ADR titles and core-component titles when applicable
    - never make architectural decisions — only propose them
planner:
  file: .github/agents/planner.agent.md
  purpose: Own the Plan stage — read the research brief, commit architectural decisions via ADRs and core-components, then produce the action plan, task breakdown, and test plan.
  tools:
    - codebase exploration (grep, glob, file reading)
    - file creation and editing
  read_paths:
    - docs/issues/<ISSUE_NUMBER>/research/00-research.md
    - docs/architecture/ADR/ADR-0001-template.md
    - docs/architecture/core-components/CORE-COMPONENT-0001-template.md
    - docs/architecture/ADR/DECISION-LOG.md
    - docs/architecture/ADR/
    - docs/architecture/core-components/
    - application source code
  write_paths:
    - docs/architecture/ADR/ADR-####-slug.md
    - docs/architecture/core-components/CORE-COMPONENT-####-slug.md
    - docs/architecture/ADR/DECISION-LOG.md
    - docs/issues/<ISSUE_NUMBER>/plan/01-action-plan.md
    - docs/issues/<ISSUE_NUMBER>/plan/02-task-breakdown.md
    - docs/issues/<ISSUE_NUMBER>/plan/03-test-plan.md
  templates:
    - docs/architecture/ADR/ADR-0001-template.md
    - docs/architecture/core-components/CORE-COMPONENT-0001-template.md
    - Task Breakdown (Section 5.5)
    - Test Plan (Section 5.6)
  guardrails:
    - no architectural decision exists unless it is in an ADR
    - no reusable cross-cutting behavior exists unless it is a core-component
    - every ADR or core-component change must update DECISION-LOG.md
    - every ADR or core-component must produce at least one decision record
    - ADRs and core-components are global — not scoped to an issue
    - every task must have acceptance criteria
    - every task must have explicit test coverage requirements
    - tasks must reference relevant ADRs and core-components
implementer:
  file: .github/agents/implementer.agent.md
  purpose: Execute tasks from the plan, produce code and tests, and verify implementation against the test plan.
  tools:
    - code generation and editing
    - build and test execution
    - file creation
  read_paths:
    - docs/issues/<ISSUE_NUMBER>/plan/
    - docs/architecture/ADR/
    - docs/architecture/core-components/
    - application source code
  write_paths:
    - application source code
    - test files
    - docs/issues/<ISSUE_NUMBER>/implementation/README.md
  templates: []
  guardrails:
    - must implement within architectural boundaries defined by ADRs and core-components
    - deviations from ADRs or core-components require returning to the Plan stage
    - implementation must satisfy the test plan
    - must not skip tests defined in the test plan
verifier:
  file: .github/agents/verifier.agent.md
  purpose: Verify completed work — run tests, create commits following Conventional Commits, push, and open a PR assigned to Copilot for review.
  tools:
    - terminal execution (git, gh, test runners)
    - file reading and editing
    - codebase exploration
  read_paths:
    - docs/architecture/ADR/DECISION-LOG.md
    - docs/architecture/ADR/
    - docs/architecture/core-components/
    - AGENTS.md
    - docs/issues/<ISSUE_NUMBER>/
    - .github/soft-factory/verification.yml
    - application source code and test files
  write_paths:
    - docs/architecture/ADR/DECISION-LOG.md
    - AGENTS.md
    - docs/
    - README.md
  templates: []
  guardrails:
    - must not proceed if any configured or auto-detected verification step fails
    - must load verification commands from .github/soft-factory/verification.yml when present
    - must fall back to auto-detecting applicable verification steps from project files when verification config is absent
    - must not push directly to main or master
    - must create feature branches following pattern <type>/<ISSUE_NUMBER>-<short-slug>
    - must follow Conventional Commits for all commit messages and the PR title
    - must include Co-authored-by trailer on every commit
    - must not force-push or use --no-verify
    - must not modify application source code
    - must verify the branch is clean after all commits
    - must assign the PR to Copilot for review
>>
TEMPLATE_PATHS: YAML<<
adr: docs/architecture/ADR/ADR-0001-template.md
core_component: docs/architecture/core-components/CORE-COMPONENT-0001-template.md
action_plan: docs/issues/<ISSUE_NUMBER>/plan/01-action-plan.md
task_breakdown: docs/issues/<ISSUE_NUMBER>/plan/02-task-breakdown.md
test_plan: docs/issues/<ISSUE_NUMBER>/plan/03-test-plan.md
research_brief: docs/issues/<ISSUE_NUMBER>/research/00-research.md
>>
SCOPE_TYPES: YAML<<
- issue
- architecture_decision
- core_component
>>
NAMING: YAML<<
issues: "GitHub Issue #<number>"
adrs: "ADR-####-short-slug.md"
core_components: "CORE-COMPONENT-####-short-slug.md"
>>
</constants>

<formats>
</formats>

<runtime>
SCOPE_TYPE: ""
ISSUE_NUMBER: ""
ADRS: []
CORE_COMPONENTS: []
DECISIONS: []
ACTION_PLAN: ""
TASK_BREAKDOWN: ""
TEST_PLAN: ""
RESULT: ""
VERIFY_RESULT: ""
</runtime>

<triggers>
<trigger event="user_message" target="pipeline-route" />
</triggers>

<processes>
<process id="pipeline-route" name="Route work through the RPIV pipeline">
RUN `research`
RUN `plan`
RUN `implement`
RUN `verify`
RETURN: SCOPE_TYPE, ISSUE_NUMBER
</process>

<process id="research" name="Research stage">
SET SCOPE_TYPE := <CLASSIFICATION> (from "Agent Inference" using USER_INPUT)
SET ISSUE_NUMBER := <ID> (from "Agent Inference")
</process>

<process id="plan" name="Plan stage">
SET ADRS := <ADR_LIST> (from "Agent Inference" using ISSUE_NUMBER, SCOPE_TYPE)
SET CORE_COMPONENTS := <CC_LIST> (from "Agent Inference" using ISSUE_NUMBER, SCOPE_TYPE)
SET DECISIONS := <DECISION_LIST> (from "Agent Inference" using ADRS, CORE_COMPONENTS)
SET ACTION_PLAN := <PLAN> (from "Agent Inference" using ISSUE_NUMBER)
SET TASK_BREAKDOWN := <TASKS> (from "Agent Inference" using ISSUE_NUMBER, ACTION_PLAN)
SET TEST_PLAN := <TESTS> (from "Agent Inference" using ISSUE_NUMBER, TASK_BREAKDOWN)
</process>

<process id="implement" name="Implement stage">
SET RESULT := <OUTCOME> (from "Agent Inference" using ISSUE_NUMBER, TASK_BREAKDOWN, TEST_PLAN)
</process>

<process id="verify" name="Verify stage">
SET VERIFY_RESULT := <OUTCOME> (from "Agent Inference" using ISSUE_NUMBER)
</process>
</processes>

<input>
USER_INPUT is the GitHub issue number, URL, or description for pipeline routing.
</input>
