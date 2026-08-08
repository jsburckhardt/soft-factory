# Agents — Soft Factory Pipeline Specification

<instructions>
Every piece of work MUST flow through exactly four stages in order: Research, Plan, Implement, Verify.
You MUST classify scope_type as exactly one of: issue, architecture_decision, core_component.
You MUST NOT create an architectural decision outside of an ADR document.
You MUST NOT create reusable cross-cutting behavior outside of a core-component document.
You MUST update project/architecture/ADR/DECISION-LOG.md for every ADR or core-component change.
You MUST store RPIV artifacts under project/work-items/<ISSUE_NUMBER>-<SHORT_DESCRIPTION>/.
You MUST require Research to resolve and reuse an existing work-item directory before creating one.
You MUST allow Research to create a work-item directory only when no directory matches the issue-number prefix.
You MUST derive SHORT_DESCRIPTION as lowercase ASCII kebab-case from the GitHub Issue title when Research first creates a work item.
You MUST preserve an existing work-item directory name after creation, including when the GitHub Issue title changes.
You MUST prevent more than one work-item directory from using the same issue-number prefix.
You MUST require Plan, Implement, and Verify to resolve exactly one existing work-item directory.
You MUST treat ADRs as global artifacts stored in project/architecture/ADR/ — never inside a work-item documentation folder.
You MUST treat core-components as global artifacts stored in project/architecture/core-components/ — never inside a work-item documentation folder.
You MUST NOT edit template files directly — copy them within the same directory and rename.
You MUST name ADRs as ADR-yymmdd-short-slug.md using their UTC creation date.
You MUST name core-components as CORE-COMPONENT-yymmdd-short-slug.md using their UTC creation date.
You MUST use the full date-and-slug basename as the architecture artifact ID.
You MUST preserve an architecture artifact's creation date after later edits.
You MUST return to the Plan stage if implementation diverges from an ADR or core-component.
You MUST inspect existing repo code and documentation before proposing new work.
You MUST NOT skip any stage in the pipeline.
You MUST keep raw project operating commands in the root justfile.
You MUST treat root justfile recipes as the default validation source for Implement and Verify.
You MUST require the root justfile to expose verify-focused and verify before RPIV.
You MUST enforce this RPIV boundary: RPIV orchestrates, Research investigates, Plan proves coverage, Implement builds and provides evidence, Verify decides acceptance and creates the PR.
You MUST require Implement to maintain affected application documentation and Verify to inspect it independently.
You MUST keep issue acceptance criteria bounded, observable, and executable by configured agents with repository capabilities.
You MUST update the APS version badge in README.md and the APS_BADGE constant when the APS skill is upgraded.
You MUST mark a PR review comment as resolved via the GitHub API after fixing the issue it raised.
</instructions>

<constants>
APS_BADGE: "[![APS version](https://img.shields.io/badge/APS-v1.2.2-blue?logo=github)](https://github.com/chris-buckley/agnostic-prompt-standard/releases/tag/v1.2.2)"
PIPELINE_STAGES: YAML<<
- id: research
  name: Research
  agent: rpiv-research
  purpose: Record constraints, risks, relevant architecture, acceptance criteria, and repository findings
- id: plan
  name: Plan
  agent: rpiv-planner
  purpose: Commit architectural decisions, assign stable AC IDs, and prove task, validation, and evidence coverage
- id: implement
  name: Implement
  agent: rpiv-implementer
  purpose: Execute dependency-ordered tasks, maintain tests and application documentation, validate, record evidence, and commit
- id: verify
  name: Verify
  agent: rpiv-verifier
  purpose: Verify the exact implementation and application documentation, decide acceptance, update GitHub, push, and open the PR
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
    - project/
    - project/architecture/ADR/ADR-260101-template.md
    - project/architecture/core-components/CORE-COMPONENT-260101-template.md
    - project/architecture/ADR/DECISION-LOG.md
    - AGENTS.md
    - LLM.txt
    - application source code
  write_paths:
    - project/architecture/ADR/ADR-yymmdd-short-slug.md
    - project/architecture/core-components/CORE-COMPONENT-yymmdd-short-slug.md
    - project/architecture/ADR/DECISION-LOG.md
    - project/work-items/<ISSUE_NUMBER>-<SHORT_DESCRIPTION>/research/00-research.md
    - README.md
    - AGENTS.md
    - LLM.txt
  templates:
    - project/architecture/ADR/ADR-260101-template.md
    - project/architecture/core-components/CORE-COMPONENT-260101-template.md
  guardrails:
    - must check whether the project is already onboarded before proceeding
    - must refuse to run if the project already has the Soft Factory engineering flow
    - must analyse the existing codebase to infer tech stack and architectural decisions
    - must infer cross-cutting concerns from the existing source code
    - must create ADRs for existing architectural decisions using the UTC creation date and a descriptive slug
    - must create core-component files for existing cross-cutting concerns using the UTC creation date and a descriptive slug
    - must use full date-and-slug basenames as artifact IDs and avoid same-day slug collisions
    - must update DECISION-LOG.md with all new ADRs and core-components
    - must record decision records in the Decisions section of DECISION-LOG.md for every ADR and core-component created
    - must create a GitHub issue for repository understanding and its research brief
    - must not make new feature-level decisions
    - must not scaffold or modify application source code
bootstrap:
  file: .github/agents/bootstrap.agent.md
  purpose: Bootstrap a new project, create its justfile command interface, and prepare the first issue handoff.
  tools:
    - codebase exploration and editing
    - file creation and editing
    - terminal execution
    - GitHub CLI (gh)
  read_paths:
    - docs/
    - project/
    - project/architecture/ADR/ADR-260101-template.md
    - project/architecture/core-components/CORE-COMPONENT-260101-template.md
    - project/architecture/ADR/DECISION-LOG.md
    - .devcontainer/devcontainer.json
    - justfile
    - README.md
    - AGENTS.md
    - LLM.txt
  write_paths:
    - project/architecture/ADR/ADR-yymmdd-short-slug.md
    - project/architecture/core-components/CORE-COMPONENT-yymmdd-short-slug.md
    - project/architecture/ADR/DECISION-LOG.md
    - README.md
    - docs/README.md
    - AGENTS.md
    - LLM.txt
    - .devcontainer/devcontainer.json
    - justfile
  templates:
    - project/architecture/ADR/ADR-260101-template.md
    - project/architecture/core-components/CORE-COMPONENT-260101-template.md
  guardrails:
    - must check whether the project has already been bootstrapped before proceeding
    - must refuse to run if the project is already bootstrapped
    - must gather project name, description, and goal from the user interactively
    - must ask user to choose tech stack and identify cross-cutting concerns
    - must scaffold the project using the appropriate init command
    - must create an ADR for the tech stack decision
    - must create a core-component file for each declared cross-cutting concern
    - must create a development standards core-component covering coding conventions, commit standards, and testing practices
    - must use UTC creation dates and descriptive slugs for ADR and core-component filenames and IDs
    - must update DECISION-LOG.md with all new ADRs and core-components
    - must record decision records in the Decisions section of DECISION-LOG.md for every ADR and core-component created
    - must create a root justfile containing all project operating command bodies
    - must ensure the development environment provides the just command runner
    - must ask user to confirm or customize proposed justfile recipes
    - must not create a standalone verification command config
    - must not set up CI/CD pipelines or infrastructure
    - must not make feature-level decisions
rpiv:
  file: .github/agents/rpiv.agent.md
  purpose: Create the issue feature branch and coordinate Research, Plan, Implement, and Verify with validated handoffs.
  tools:
    - subagent dispatch
    - codebase exploration and reading
    - terminal execution
    - file creation
  read_paths:
    - AGENTS.md
    - project/architecture/ADR/DECISION-LOG.md
    - docs/
    - project/
    - project/work-items/<ISSUE_NUMBER>-<SHORT_DESCRIPTION>/
  write_paths:
    - project/work-items/<ISSUE_NUMBER>-<SHORT_DESCRIPTION>/
  templates: []
  guardrails:
    - must create or confirm the issue feature branch before Research
    - must verify the root justfile exposes verify-focused and verify before Research
    - must execute Research, Plan, Implement, and Verify in strict order
    - must delegate stage work to rpiv-research, rpiv-planner, rpiv-implementer, and rpiv-verifier
    - must validate each stage artifact before proceeding
    - Plan to Implement handoff must include the exact work-item path, acceptance criteria, tasks, test plan, and relevant ADRs
    - Implement to Verify handoff must include the exact work-item path, branch, commit SHA, clean-tree proof, implementation evidence, documentation evidence, and test results
    - verification code, test, or application documentation failures return to Implement
    - verification plan, architecture, scope, or acceptance coverage failures return to Plan
    - must stop with a pipeline error when a stage fails
rpiv-research:
  file: .github/agents/rpiv-research.agent.md
  purpose: Investigate the issue and record constraints, risks, relevant architecture, acceptance criteria, and repository findings.
  tools:
    - web search and documentation lookup
    - codebase exploration (grep, glob, file reading)
    - external API/library research
    - GitHub CLI (gh) for fetching issue details
  read_paths:
    - docs/
    - project/
    - project/architecture/ADR/
    - project/architecture/core-components/
    - project/architecture/ADR/DECISION-LOG.md
    - application source code
  write_paths:
    - project/work-items/<ISSUE_NUMBER>-<SHORT_DESCRIPTION>/research/00-research.md
  templates:
    - Research Brief (Section 5.1)
  guardrails:
    - classify scope_type as exactly one of issue, architecture_decision, core_component
    - validate that the issue has structured acceptance criteria; stop if absent
    - extract acceptance criteria from the issue and include them in the research brief
    - inspect existing repo code and docs before recording findings
    - record only constraints, risks, relevant ADRs and core-components, and repository findings
    - must not design solutions, create tasks, define tests, or propose architectural artifacts
rpiv-planner:
  file: .github/agents/rpiv-planner.agent.md
  purpose: Own the Plan stage — read the research brief, commit architectural decisions via ADRs and core-components, then produce the action plan, task breakdown, and test plan.
  tools:
    - codebase exploration (grep, glob, file reading)
    - file creation and editing
  read_paths:
    - project/work-items/<ISSUE_NUMBER>-<SHORT_DESCRIPTION>/research/00-research.md
    - project/architecture/ADR/ADR-260101-template.md
    - project/architecture/core-components/CORE-COMPONENT-260101-template.md
    - project/architecture/ADR/DECISION-LOG.md
    - project/architecture/ADR/
    - project/architecture/core-components/
    - application source code
  write_paths:
    - project/architecture/ADR/ADR-yymmdd-short-slug.md
    - project/architecture/core-components/CORE-COMPONENT-yymmdd-short-slug.md
    - project/architecture/ADR/DECISION-LOG.md
    - project/work-items/<ISSUE_NUMBER>-<SHORT_DESCRIPTION>/plan/01-action-plan.md
    - project/work-items/<ISSUE_NUMBER>-<SHORT_DESCRIPTION>/plan/02-task-breakdown.md
    - project/work-items/<ISSUE_NUMBER>-<SHORT_DESCRIPTION>/plan/03-test-plan.md
  templates:
    - project/architecture/ADR/ADR-260101-template.md
    - project/architecture/core-components/CORE-COMPONENT-260101-template.md
    - Task Breakdown (Section 5.5)
    - Test Plan (Section 5.6)
  guardrails:
    - no architectural decision exists unless it is in an ADR
    - no reusable cross-cutting behavior exists unless it is a core-component
    - every ADR or core-component change must update DECISION-LOG.md
    - every ADR or core-component must produce at least one decision record
    - ADRs and core-components are global — not scoped to an issue
    - assign UTC creation dates and descriptive slugs to ADR and core-component filenames and IDs
    - preserve creation dates and use distinct slugs for same-day artifacts
    - assign stable AC-1, AC-2, and subsequent IDs in issue order
    - map every AC ID to implementation tasks, tests or validation, and expected evidence
    - include AC IDs in the action plan, task breakdown, and test plan
    - every task must have acceptance criteria
    - every task must have explicit test coverage requirements
    - every task must identify expected evidence
    - tasks must reference relevant ADRs and core-components
rpiv-implementer:
  file: .github/agents/rpiv-implementer.agent.md
  purpose: Execute dependency-ordered tasks, maintain tests and application documentation, run configured validation, record evidence, and commit.
  tools:
    - code generation and editing
    - build and test execution
    - file creation
  read_paths:
    - project/work-items/<ISSUE_NUMBER>-<SHORT_DESCRIPTION>/plan/
    - project/architecture/ADR/
    - project/architecture/core-components/
    - justfile
    - application source code
    - README.md
    - docs/
    - API, configuration, usage, migration, architecture, operational, and deployment documentation
  write_paths:
    - application source code
    - test files
    - affected application documentation
    - project/work-items/<ISSUE_NUMBER>-<SHORT_DESCRIPTION>/plan/02-task-breakdown.md
    - project/work-items/<ISSUE_NUMBER>-<SHORT_DESCRIPTION>/implementation/00-implementation.md
  templates: []
  guardrails:
    - must implement within architectural boundaries defined by ADRs and core-components
    - deviations from ADRs or core-components require returning to the Plan stage
    - implement tasks in dependency order and mark them complete
    - write or update tests required by the plan
    - write or update all application documentation affected by the implementation
    - cover README, API, configuration, usage, migration, architecture, operational, and deployment documentation when applicable
    - record documentation evidence or an explicit no-impact rationale in implementation notes
    - return to Plan when documentation requires an ADR or core-component contract change
    - treat root justfile recipes as the validation source
    - run just verify-focused while building and fix failures
    - run just verify before handoff and fix failures
    - record concrete implementation evidence for every AC ID
    - commit the implementation and hand off a clean working tree
    - must not check GitHub acceptance criteria or claim final verification
rpiv-verifier:
  file: .github/agents/rpiv-verifier.agent.md
  purpose: Verify the exact committed implementation and documentation, decide acceptance, update GitHub criteria, push, and open a PR for review.
  tools:
    - terminal execution (git, gh, test runners)
    - file reading and editing
    - codebase exploration
  read_paths:
    - project/architecture/ADR/DECISION-LOG.md
    - project/architecture/ADR/
    - project/architecture/core-components/
    - AGENTS.md
    - project/work-items/<ISSUE_NUMBER>-<SHORT_DESCRIPTION>/
    - justfile
    - .github/PULL_REQUEST_TEMPLATE.md
    - application source code and test files
    - README.md
    - docs/
    - API, configuration, usage, migration, architecture, operational, and deployment documentation
  write_paths:
    - project/work-items/<ISSUE_NUMBER>-<SHORT_DESCRIPTION>/verify/summary.md
  templates:
    - .github/PULL_REQUEST_TEMPLATE.md
  guardrails:
    - must verify the exact branch and commit SHA received from Implement
    - must inspect the full branch diff for issue scope and architecture compliance
    - must independently inspect every application documentation category affected by the implementation
    - must fail missing, stale, inaccurate, or inconclusive documentation and return it to Implement
    - must treat root justfile recipes as the validation source
    - must rerun just verify independently
    - must not auto-detect or invent validation commands
    - must independently mark every AC ID passed or failed with concrete evidence
    - must not proceed to push or PR creation if any acceptance criterion fails validation
    - must update the GitHub issue body to mark satisfied acceptance criteria as checked
    - must populate the PR description from the PR template with acceptance criteria status
    - must not push directly to main or master
    - must not create the feature branch or implementation commits
    - must follow Conventional Commits for the PR title
    - must not force-push or use --no-verify
    - must not modify application source code, tests, or application documentation
    - must verify the branch is clean after all commits
    - must write summary.md to project/work-items/<ISSUE_NUMBER>-<SHORT_DESCRIPTION>/verify/ after PR creation
issue-generator:
  file: .github/agents/issue-generator.agent.md
  purpose: Analyze codebase history for issue-quality gaps, draft a problem-focused GitHub issue with structured agent-executable acceptance criteria, dispatch a rubber-duck subagent to critique it, then create the issue via gh. Runs before the RPIV pipeline to produce feasible work without preempting RPIV Research or Plan.
  tools:
    - codebase exploration (search, grep, file reading)
    - terminal execution (git, gh)
    - file creation
    - web fetch
    - subagent dispatch (rubber-duck)
  read_paths:
    - project/architecture/ADR/DECISION-LOG.md
    - AGENTS.md
    - LLM.txt
    - justfile
    - project/work-items/
    - application source code
  write_paths:
    - GitHub issues (via gh issue create)
  templates: []
  guardrails:
    - must read AGENTS.md and DECISION-LOG.md before starting
    - must run git history analysis to surface recurring issue-quality gaps
    - must structure every issue with only the required Problem and Acceptance Criteria sections
    - must not include proposed solutions, technical considerations, implementation plans, architecture decisions, technology choices, dependency choices, API designs, file paths, or test-framework prescriptions unless explicitly provided by the user as problem context
    - must format acceptance criteria as markdown checkboxes with ACCEPTANCE_CRITERIA_START/END HTML markers
    - must make every acceptance criterion bounded, deterministic, observable, and independently verifiable by configured agents
    - must use repository and declared agent capabilities when proposing validation evidence
    - must reject unavailable, subjective, manual-only, destructive-production, unbounded, or exhaustive validation requirements
    - must identify essential external or human prerequisites explicitly instead of encoding impossible agent tasks
    - must dispatch a rubber-duck subagent to critique the draft before creating the issue
    - must incorporate rubber-duck feedback before issue creation
    - must not create an issue without rubber-duck review
>>
TEMPLATE_PATHS: YAML<<
adr: project/architecture/ADR/ADR-260101-template.md
core_component: project/architecture/core-components/CORE-COMPONENT-260101-template.md
action_plan: project/work-items/<ISSUE_NUMBER>-<SHORT_DESCRIPTION>/plan/01-action-plan.md
task_breakdown: project/work-items/<ISSUE_NUMBER>-<SHORT_DESCRIPTION>/plan/02-task-breakdown.md
test_plan: project/work-items/<ISSUE_NUMBER>-<SHORT_DESCRIPTION>/plan/03-test-plan.md
research_brief: project/work-items/<ISSUE_NUMBER>-<SHORT_DESCRIPTION>/research/00-research.md
pull_request: .github/PULL_REQUEST_TEMPLATE.md
>>
SCOPE_TYPES: YAML<<
- issue
- architecture_decision
- core_component
>>
NAMING: YAML<<
issues: "GitHub Issue #<number>"
work_items: "project/work-items/<issue-number>-<short-description>/"
adrs: "ADR-yymmdd-short-slug.md"
core_components: "CORE-COMPONENT-yymmdd-short-slug.md"
>>
</constants>

<formats>
</formats>

<runtime>
SCOPE_TYPE: ""
ISSUE_NUMBER: ""
SHORT_DESCRIPTION: ""
WORK_ITEM_PATH: ""
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
SET WORK_ITEM_PATH := <PATH> (from "Agent Inference" using ISSUE_NUMBER, USER_INPUT; resolve one existing project/work-items/<ISSUE_NUMBER>-*/ path or derive SHORT_DESCRIPTION from the GitHub Issue title)
</process>

<process id="plan" name="Plan stage">
SET ADRS := <ADR_LIST> (from "Agent Inference" using ISSUE_NUMBER, SCOPE_TYPE, WORK_ITEM_PATH)
SET CORE_COMPONENTS := <CC_LIST> (from "Agent Inference" using ISSUE_NUMBER, SCOPE_TYPE, WORK_ITEM_PATH)
SET DECISIONS := <DECISION_LIST> (from "Agent Inference" using ADRS, CORE_COMPONENTS)
SET ACTION_PLAN := <PLAN> (from "Agent Inference" using ISSUE_NUMBER, WORK_ITEM_PATH)
SET TASK_BREAKDOWN := <TASKS> (from "Agent Inference" using ISSUE_NUMBER, WORK_ITEM_PATH, ACTION_PLAN)
SET TEST_PLAN := <TESTS> (from "Agent Inference" using ISSUE_NUMBER, WORK_ITEM_PATH, TASK_BREAKDOWN)
</process>

<process id="implement" name="Implement stage">
SET RESULT := <OUTCOME> (from "Agent Inference" using ISSUE_NUMBER, WORK_ITEM_PATH, TASK_BREAKDOWN, TEST_PLAN)
</process>

<process id="verify" name="Verify stage">
SET VERIFY_RESULT := <OUTCOME> (from "Agent Inference" using ISSUE_NUMBER, WORK_ITEM_PATH)
</process>
</processes>

<input>
USER_INPUT is the GitHub issue number, URL, or description for pipeline routing.
</input>
