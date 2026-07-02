# Soft Factory Skills

This directory contains Skill entrypoints for users who prefer Skills over repo-local Agents. Agents remain available under `.github/agents/`.

## Agent-to-Skill mapping

| Agent | Skill | Status | Notes |
|-------|-------|--------|-------|
| `.github/agents/aps-v1.2.2.agent.md` | `.github/skills/agnostic-prompt-standard/SKILL.md` | Available | Existing APS Skill is the user-facing counterpart for APS prompt and Skill generation workflows; no duplicate Skill is needed. |
| `.github/agents/bootstrap.agent.md` | `.github/skills/bootstrap/SKILL.md` | Available | Bootstraps a new Soft Factory project. |
| `.github/agents/excali.agent.md` | `.github/skills/excali/SKILL.md` | Available | Generates Excalidraw diagrams. |
| `.github/agents/harness-cli-it.agent.md` | `.github/skills/harness-cli-it/SKILL.md` | Available | Existing Skill retained and mapped to its Agent workflow. |
| `.github/agents/implementer.agent.md` | `.github/skills/implementer/SKILL.md` | Available | Implements planned tasks and records implementation notes. |
| `.github/agents/issue-generator.agent.md` | `.github/skills/issue-generator/SKILL.md` | Available | Creates problem-focused issues with structured acceptance criteria. |
| `.github/agents/justdoit.agent.md` | `.github/skills/justdoit/SKILL.md` | Available | Coordinates the full RPIV pipeline. |
| `.github/agents/onboard-repo.agent.md` | `.github/skills/onboard-repo/SKILL.md` | Available | Introduces Soft Factory into an existing repository. |
| `.github/agents/planner.agent.md` | `.github/skills/planner/SKILL.md` | Available | Produces action, task, and test plans. |
| `.github/agents/research.agent.md` | `.github/skills/research/SKILL.md` | Available | Produces issue research briefs. |
| `.github/agents/verifier.agent.md` | `.github/skills/verifier/SKILL.md` | Available | Verifies, commits, pushes, and opens PRs. |

## Standalone Skills

| Entry | Status | Notes |
|-------|--------|-------|
| `.github/skills/pr-review-complement/SKILL.md` | Standalone Skill | Existing standalone Skill without a matching Agent in this issue's scope. |

## Skill structure

Each converted workflow Skill has:

- `SKILL.md` as the user-facing entrypoint.
- `references/00-*.md` with normative behavior, inputs, outputs, guardrails, and outcomes.
- `processes/*.md` with an APS-style executable workflow.

## Shared templates

The `templates/` directory defines reusable artifact contracts for Skills that write RPIV or architecture artifacts.

| Template | Contract |
|----------|----------|
| `templates/artifact-contract.md` | Canonical output paths and ledger locations. |
| `templates/research-brief.md` | Research stage output structure. |
| `templates/action-plan.md` | Plan stage action plan structure. |
| `templates/task-breakdown.md` | Plan stage task breakdown structure. |
| `templates/test-plan.md` | Plan stage test plan structure. |
| `templates/implementation-notes.md` | Implement stage notes structure. |
| `templates/verify-summary.md` | Verify stage summary structure. |
| `templates/decision-log.md` | Decision ledger structure. |
| `templates/adr.md` | ADR structure. |
| `templates/core-component.md` | Core-component structure. |

Existing Agents are not removed or replaced by these Skills.
