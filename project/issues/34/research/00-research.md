# Research Brief: chore: standardize RPIV workflow naming

## GitHub Issue

- **Issue:** #34
- **Title:** chore: standardize RPIV workflow naming

## Scope Classification

- **Scope Type:** issue

## Problem Statement

RPIV workflow names are inconsistent across user-facing agent and skill discovery surfaces. The four RPIV stage workflows (`research`, `planner`, `implementer`, `verifier`) use generic, unprefixed names. The full-pipeline coordinator uses the name `justdoit`, which is unrelated to the RPIV acronym. This makes the RPIV workflow set harder to discover, scan, and distinguish from non-RPIV workflows.

The fix is a naming and metadata change: stage workflows should be user-discoverable as `rpiv-research`, `rpiv-planner`, `rpiv-implementer`, and `rpiv-verifier`; the coordinator should be user-discoverable as `rpiv` instead of `justdoit`. Non-RPIV workflows must retain their existing names.

## Existing Context

### Affected surfaces

#### Agent files - `name:` front-matter field

| File | Current `name` | Required `name` |
|------|----------------|-----------------|
| `.github/agents/rpiv-research.agent.md:2` | `research` | `rpiv-research` |
| `.github/agents/rpiv-planner.agent.md:2` | `planner` | `rpiv-planner` |
| `.github/agents/rpiv-implementer.agent.md:2` | `implementer` | `rpiv-implementer` |
| `.github/agents/rpiv-verifier.agent.md:2` | `verifier` | `rpiv-verifier` |
| `.github/agents/rpiv.agent.md:2` | `justdoit` | `rpiv` |

#### Skill files - `name:` front-matter field

| File | Current `name` | Required `name` |
|------|----------------|-----------------|
| `.github/skills/rpiv-research/SKILL.md:2` | `research` | `rpiv-research` |
| `.github/skills/rpiv-planner/SKILL.md:2` | `planner` | `rpiv-planner` |
| `.github/skills/rpiv-implementer/SKILL.md:2` | `implementer` | `rpiv-implementer` |
| `.github/skills/rpiv-verifier/SKILL.md:2` | `verifier` | `rpiv-verifier` |
| `.github/skills/rpiv/SKILL.md:2` | `justdoit` | `rpiv` |

#### `justdoit` agent - sub-agent and recovery references

`.github/agents/rpiv.agent.md` references stage agents by name in these locations:

- Front-matter `agents:` list: `research`, `planner`, `implementer`, `verifier`
- `STAGE_AGENTS` constant: `agent: research`, `agent: planner`, `agent: implementer`, `agent: verifier`
- Recovery instructions within `PIPELINE_ERROR` blocks: `retry with @research`, `retry with @planner`, `retry with @implementer`, `retry with @verifier`

These internal sub-agent dispatch references must be updated to the new names to remain functional after the user-facing names change.

#### `justdoit` skill process - sub-agent skill references

`.github/skills/rpiv/processes/run-rpiv-pipeline.md` references stage workflows by skill name in `Subagent` calls: `skill="research"`, `skill="planner"`, `skill="implementer"`, `skill="verifier"`. These must be updated.

#### Documentation and repo maps

- `AGENTS.md` `PIPELINE_STAGES` constant identifies the stage agents as `research`, `planner`, `implementer`, and `verifier`.
- `AGENTS.md` `AGENTS` constant uses standardized RPIV keys and references `.github/agents/rpiv.agent.md` as `rpiv`.
- `LLM.txt` names agent files and skills using the current identifiers.
- `.github/skills/README.md` maps agents to skills with current identifiers.

### Non-RPIV workflows - unchanged

The following workflows are not part of the RPIV stage/coordinator set and must keep their existing user-facing names:

| Name | Files |
|------|-------|
| `bootstrap` | `.github/agents/bootstrap.agent.md`, `.github/skills/bootstrap/SKILL.md` |
| `onboard-repo` | `.github/agents/onboard-repo.agent.md`, `.github/skills/onboard-repo/SKILL.md` |
| `excali` | `.github/agents/excali.agent.md`, `.github/skills/excali/SKILL.md` |
| `issue-generator` | `.github/agents/issue-generator.agent.md`, `.github/skills/issue-generator/SKILL.md` |
| `harness-cli-it` | `.github/agents/harness-cli-it.agent.md`, `.github/skills/harness-cli-it/SKILL.md` |
| `agnostic-prompt-standard` | `.github/skills/agnostic-prompt-standard/SKILL.md` |
| `pr-review-complement` | `.github/skills/pr-review-complement/SKILL.md` |
| `aps-v1.2.2` | `.github/agents/aps-v1.2.2.agent.md` |

## Architecture Context

No ADRs exist yet in `project/architecture/ADR/DECISION-LOG.md`. One core-component exists: `CORE-COMPONENT-0002` Commit Standards. Neither requires a change for this issue.

## Proposed ADRs

None required. This change standardizes user-facing workflow names and related references; it does not introduce a new architectural decision.

## Proposed Core-Components

None required. This change does not introduce reusable cross-cutting behavior.

## Acceptance Criteria

**Core**

- [ ] The Research stage workflow is user-discoverable as `rpiv-research`.
- [ ] The Planner stage workflow is user-discoverable as `rpiv-planner`.
- [ ] The Implementer stage workflow is user-discoverable as `rpiv-implementer`.
- [ ] The Verifier stage workflow is user-discoverable as `rpiv-verifier`.
- [ ] The full RPIV pipeline coordinator is user-discoverable as `rpiv` instead of `justdoit`.
- [ ] User-facing references to the RPIV workflow set use the standardized RPIV names consistently.

**Edge Cases**

- [ ] Non-RPIV workflows keep their existing user-facing names.
- [ ] Historical issue, pull request, and commit references do not need to be rewritten solely to satisfy this change.

**Verification**

- [ ] Workflow discovery no longer presents `research`, `planner`, `implementer`, `verifier`, or `justdoit` as the primary user-facing RPIV workflow names.
- [ ] Documentation and repo maps present the standardized RPIV workflow names consistently.

## Risks and Open Questions

### Risks

1. **Internal dispatch breakage.** The RPIV coordinator dispatches stage sub-agents by name. If `name:` fields are updated without updating corresponding dispatch references and recovery guidance, the coordinator can fail to locate its sub-agents.
2. **Platform-specific agent resolution.** Renaming the `name:` field changes invocation handles such as `@research` to `@rpiv-research`. This is expected by the issue.
3. **Path rename ambiguity.** The acceptance criteria specify user-discoverable names, not physical file or directory names. The Plan stage should decide whether to rename paths or limit the change to front matter and references.

### Open Questions

1. Should physical directory names be renamed, or should only front-matter names and user-facing references change? Follow-up user feedback resolved this in favor of renaming RPIV agent files and skill directories to the standardized RPIV names.
2. Should YAML keys in `AGENTS.md` be renamed to the standardized RPIV names, or should only display/discovery references change?
3. Are there external integrations that reference the old agent or skill names directly? No `.github/workflows/` dependency was identified during research.
