# Action Plan: Standardize RPIV Workflow Naming

## Feature

- **ID:** 34
- **Research Brief:** project/issues/34/research/00-research.md

## ADRs Created

- None. The research brief classified this as `issue` scope and concluded no architectural decision is required.

## Core-Components Created

- None. The research brief concluded no reusable cross-cutting behavior is introduced.
- Existing relevant core-component: `CORE-COMPONENT-0002` Commit Standards, applicable only to the final commit message and PR title.

## Implementation Scope

Standardize the user-discoverable RPIV workflow names across agent metadata, skill metadata, active RPIV dispatch references, and repository documentation/maps.

### Required user-facing names

| Workflow | Current primary name | Required primary name |
|----------|----------------------|-----------------------|
| Research stage | `research` | `rpiv-research` |
| Planner stage | `planner` | `rpiv-planner` |
| Implementer stage | `implementer` | `rpiv-implementer` |
| Verifier stage | `verifier` | `rpiv-verifier` |
| Full pipeline coordinator | `justdoit` | `rpiv` |

### Scope resolutions

- Rename physical RPIV agent file paths:
  - `.github/agents/research.agent.md` to `.github/agents/rpiv-research.agent.md`
  - `.github/agents/planner.agent.md` to `.github/agents/rpiv-planner.agent.md`
  - `.github/agents/implementer.agent.md` to `.github/agents/rpiv-implementer.agent.md`
  - `.github/agents/verifier.agent.md` to `.github/agents/rpiv-verifier.agent.md`
  - `.github/agents/justdoit.agent.md` to `.github/agents/rpiv.agent.md`
- Rename physical RPIV skill directory paths:
  - `.github/skills/research/` to `.github/skills/rpiv-research/`
  - `.github/skills/planner/` to `.github/skills/rpiv-planner/`
  - `.github/skills/implementer/` to `.github/skills/rpiv-implementer/`
  - `.github/skills/verifier/` to `.github/skills/rpiv-verifier/`
  - `.github/skills/justdoit/` to `.github/skills/rpiv/`
- Update front-matter `name:` fields and all user-facing path references to match the renamed RPIV files/directories.
- Update active dispatch references that resolve agents or skills by name.
- Keep stage IDs, artifact directory names, process names, and historical references unchanged when they are not primary user-facing workflow names.
- Do not rewrite historical issue, pull request, or commit records solely for this naming change.
- Keep non-RPIV workflow names unchanged.

## Implementation Tasks

1. **T1 - Update RPIV agent discovery metadata and agent dispatch references**
   - Update RPIV agent front-matter `name:` values.
   - Update the coordinator agent's subagent list, stage-agent constants, direct dispatch calls, and recovery guidance.
   - Update active non-RPIV handoff references that target RPIV agents while preserving non-RPIV workflow names.
2. **T2 - Update RPIV skill discovery metadata and skill dispatch references**
   - Update RPIV skill front-matter `name:` values.
   - Update RPIV coordinator skill text and subagent skill references.
   - Rename physical skill directory names.
3. **T3 - Update documentation and repo maps**
   - Update `AGENTS.md`, `LLM.txt`, `.github/skills/README.md`, and relevant contributor documentation so RPIV workflow names are consistently shown as `rpiv-*` and `rpiv`.
   - Rename RPIV entries/keys in repo maps where they serve as user-facing identifiers.
   - Preserve non-RPIV workflow names.
4. **T4 - Run final naming audit and acceptance verification**
   - Confirm no primary RPIV discovery surface still presents `research`, `planner`, `implementer`, `verifier`, or `justdoit`.
   - Confirm remaining legacy terms are limited to internal stage concepts or historical/current issue documentation.
   - Confirm no ADR, core-component, or decision-log changes were made.

## Non-Goals

- Do not create ADRs.
- Do not create core-components.
- Do not update `project/architecture/ADR/DECISION-LOG.md`.
- Do not change non-RPIV workflow discovery names.
- Do not rewrite historical issue, PR, or commit references solely for this change.
