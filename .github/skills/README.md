# Soft Factory Skills

This directory contains Skill entrypoints for users who prefer Skills over repo-local Agents. Agents remain available under `.github/agents/`.

## Agent-to-Skill mapping

| Agent | Skill | Status | Notes |
|-------|-------|--------|-------|
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

## Explicit exclusions and standalone Skills

| Entry | Status | Notes |
|-------|--------|-------|
| `.github/agents/aps-v1.2.2.agent.md` | Converter only | Intentionally excluded from conversion by issue #30 implementation scope; use it as the APS conversion/generation mechanism. |
| `.github/skills/agnostic-prompt-standard/SKILL.md` | Standalone Skill | APS reference framework consumed by conversion workflows. |
| `.github/skills/pr-review-complement/SKILL.md` | Standalone Skill | Existing standalone Skill without a matching Agent in this issue's scope. |

## Skill structure

Each converted workflow Skill has:

- `SKILL.md` as the user-facing entrypoint.
- `references/00-*.md` with normative behavior, inputs, outputs, guardrails, and outcomes.
- `processes/*.md` with an APS-style executable workflow.

Existing Agents are not removed or replaced by these Skills.
