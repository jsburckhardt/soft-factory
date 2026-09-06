# Decision Log

This file is the single registry of all architectural decisions and core-components in the project. Every new or modified ADR or core-component **must** be recorded here.

## ADRs

| ID | Title | Status | Date |
|----|-------|--------|------|
| ADR-260906-foreman-control-plane | Foreman Control Plane | Accepted | 2026-09-06 |

## Core-Components

| ID | Title | Status | Date |
|----|-------|--------|------|
| CORE-COMPONENT-260505-commit-standards | Commit Standards | Adopted | 2026-05-05 |
| CORE-COMPONENT-260806-rpiv-stage-contract | RPIV Stage Contract | Adopted | 2026-08-06 |
| CORE-COMPONENT-260806-project-command-interface | Project Command Interface | Adopted | 2026-08-06 |
| CORE-COMPONENT-260806-agent-executable-acceptance-criteria | Agent-Executable Acceptance Criteria | Adopted | 2026-08-06 |
| CORE-COMPONENT-260806-architecture-artifact-naming | Architecture Artifact Naming | Adopted | 2026-08-06 |
| CORE-COMPONENT-260906-foreman-orchestration | Foreman Orchestration | Adopted | 2026-09-06 |
| CORE-COMPONENT-260906-rpiv-observability | RPIV Observability | Adopted | 2026-09-06 |

## Decisions

Short, actionable statements derived from ADRs and core-components. More than one decision can originate from a single source.

| # | Decision | Source | Date |
|---|----------|--------|------|
| 1 | Enforce Conventional Commits v1.0.0 on every commit message | CORE-COMPONENT-260505-commit-standards | 2026-05-05 |
| 2 | Require Conventional Commits format on PR titles | CORE-COMPONENT-260505-commit-standards | 2026-05-05 |
| 3 | Require the configured Copilot Co-authored-by trailer on AI-authored commits | CORE-COMPONENT-260505-commit-standards | 2026-05-05 |
| 4 | Require the RPIV implementer to commit implementation before verification | CORE-COMPONENT-260505-commit-standards | 2026-08-06 |
| 5 | Create the issue feature branch before RPIV Research starts | CORE-COMPONENT-260806-rpiv-stage-contract | 2026-08-06 |
| 6 | Assign stable AC IDs and prove task, validation, and evidence coverage | CORE-COMPONENT-260806-rpiv-stage-contract | 2026-08-06 |
| 7 | Use root justfile recipes for Implement and Verify validation by default | CORE-COMPONENT-260806-rpiv-stage-contract | 2026-08-06 |
| 8 | Restrict Verify to acceptance decisions, GitHub updates, push, and PR creation | CORE-COMPONENT-260806-rpiv-stage-contract | 2026-08-06 |
| 9 | Route verification defects to Implement or Plan by ownership | CORE-COMPONENT-260806-rpiv-stage-contract | 2026-08-06 |
| 10 | Define project operating commands as root justfile recipes | CORE-COMPONENT-260806-project-command-interface | 2026-08-06 |
| 11 | Use the root justfile as the default command interface | CORE-COMPONENT-260806-project-command-interface | 2026-08-06 |
| 12 | Provide the just command runner in project development environments | CORE-COMPONENT-260806-project-command-interface | 2026-08-06 |
| 13 | Prohibit standalone verification config that duplicates the root justfile | CORE-COMPONENT-260806-project-command-interface | 2026-08-06 |
| 14 | Require Implement and Verify to run independent stage-boundary validation | CORE-COMPONENT-260806-rpiv-stage-contract | 2026-08-06 |
| 15 | Require verify-focused and verify recipes in bootstrapped projects | CORE-COMPONENT-260806-project-command-interface | 2026-08-06 |
| 16 | Require acceptance criteria to be bounded, observable, and executable by configured agents | CORE-COMPONENT-260806-agent-executable-acceptance-criteria | 2026-08-06 |
| 17 | Require acceptance evidence to use safe, repeatable repository capabilities | CORE-COMPONENT-260806-agent-executable-acceptance-criteria | 2026-08-06 |
| 18 | Identify unavailable human or external prerequisites instead of encoding impossible agent tasks | CORE-COMPONENT-260806-agent-executable-acceptance-criteria | 2026-08-06 |
| 19 | Name architecture artifacts with their UTC creation date and descriptive slug | CORE-COMPONENT-260806-architecture-artifact-naming | 2026-08-06 |
| 20 | Use the full date-and-slug basename as the architecture artifact ID | CORE-COMPONENT-260806-architecture-artifact-naming | 2026-08-06 |
| 21 | Preserve artifact creation dates and distinguish same-day records by slug | CORE-COMPONENT-260806-architecture-artifact-naming | 2026-08-06 |
| 22 | Write implementation evidence to implementation/00-implementation.md | CORE-COMPONENT-260806-rpiv-stage-contract | 2026-08-06 |
| 23 | Require Implement to update affected application documentation and Verify to inspect it | CORE-COMPONENT-260806-rpiv-stage-contract | 2026-08-06 |
| 24 | Store RPIV artifacts under stable `project/work-items/<issue-number>-<short-description>/` paths | CORE-COMPONENT-260806-rpiv-stage-contract | 2026-08-07 |
| 25 | Reuse an existing same-issue work-item directory before creating a new artifact path | CORE-COMPONENT-260806-rpiv-stage-contract | 2026-08-07 |
| 26 | Place mission orchestration above unchanged single-issue RPIV | ADR-260906-foreman-control-plane | 2026-09-06 |
| 27 | Run isolated Copilot RPIV sessions in issue worktrees and dedicated tmux windows | ADR-260906-foreman-control-plane | 2026-09-06 |
| 28 | Gate dependency readiness and mission completion on integrated delivery evidence | CORE-COMPONENT-260906-foreman-orchestration | 2026-09-06 |
| 29 | Reconcile owned workers and enforce capacity before scheduling or recovery | CORE-COMPONENT-260906-foreman-orchestration | 2026-09-06 |
| 30 | Persist RPIV phase, status, identity, and ordered lifecycle events independently of Foreman | CORE-COMPONENT-260906-rpiv-observability | 2026-09-06 |
| 31 | Preserve four-stage RPIV while exposing standalone and managed worker lifecycle state | CORE-COMPONENT-260806-rpiv-stage-contract | 2026-09-06 |
| 32 | Correlate recoverable pauses and failure ownership with the existing worker attempt | CORE-COMPONENT-260906-rpiv-observability | 2026-09-06 |
