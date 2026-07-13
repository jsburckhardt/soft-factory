# Task Breakdown: Standardize RPIV Workflow Naming

## Task T1: Update RPIV agent discovery metadata and agent dispatch references

- **Status:** Pending
- **Complexity:** Medium
- **Dependencies:** None
- **Related ADRs:** None
- **Related Core-Components:** CORE-COMPONENT-0002 Commit Standards, applicable to final commit/PR title only

### Description

Update RPIV agent front-matter and active agent-name references so agent discovery and subagent dispatch use the standardized RPIV names.

Target RPIV agent files:

- `.github/agents/research.agent.md`
- `.github/agents/planner.agent.md`
- `.github/agents/implementer.agent.md`
- `.github/agents/verifier.agent.md`
- `.github/agents/justdoit.agent.md`

Also inspect active handoff references in non-RPIV agents such as:

- `.github/agents/bootstrap.agent.md`
- `.github/agents/onboard-repo.agent.md`

Physical file names must remain unchanged.

### Acceptance Criteria

- [ ] `.github/agents/research.agent.md` front-matter uses `name: rpiv-research`.
- [ ] `.github/agents/planner.agent.md` front-matter uses `name: rpiv-planner`.
- [ ] `.github/agents/implementer.agent.md` front-matter uses `name: rpiv-implementer`.
- [ ] `.github/agents/verifier.agent.md` front-matter uses `name: rpiv-verifier`.
- [ ] `.github/agents/justdoit.agent.md` front-matter uses `name: rpiv`.
- [ ] `.github/agents/justdoit.agent.md` `agents:` list references `rpiv-research`, `rpiv-planner`, `rpiv-implementer`, and `rpiv-verifier`.
- [ ] `.github/agents/justdoit.agent.md` `STAGE_AGENTS` entries reference the standardized RPIV agent names.
- [ ] `.github/agents/justdoit.agent.md` subagent dispatch calls use the standardized RPIV agent names.
- [ ] `.github/agents/justdoit.agent.md` recovery guidance uses `@rpiv-research`, `@rpiv-planner`, `@rpiv-implementer`, and `@rpiv-verifier`.
- [ ] Active handoff references from non-RPIV agents to the Research stage target `rpiv-research`.
- [ ] Non-RPIV agent front-matter `name:` values remain unchanged.
- [ ] Physical agent file paths remain unchanged.

### Test Coverage

- [ ] Static front-matter inspection confirms all RPIV agent `name:` values match the required names.
- [ ] Static search confirms no RPIV agent front-matter still uses `name: research`, `name: planner`, `name: implementer`, `name: verifier`, or `name: justdoit`.
- [ ] Static search confirms `.github/agents/justdoit.agent.md` contains no active dispatch references to `agent="research"`, `agent="planner"`, `agent="implementer"`, `agent="verifier"`, `agent: research`, `agent: planner`, `agent: implementer`, or `agent: verifier`.
- [ ] Static search confirms recovery references use `@rpiv-research`, `@rpiv-planner`, `@rpiv-implementer`, and `@rpiv-verifier`.
- [ ] Static inspection confirms non-RPIV agent names remain `bootstrap`, `onboard-repo`, `excali`, `issue-generator`, `harness-cli-it`, and `APS v1.2.2 Agent`.

## Task T2: Update RPIV skill discovery metadata and skill dispatch references

- **Status:** Pending
- **Complexity:** Medium
- **Dependencies:** T1
- **Related ADRs:** None
- **Related Core-Components:** CORE-COMPONENT-0002 Commit Standards, applicable to final commit/PR title only

### Description

Update RPIV skill front-matter and active skill-name dispatch references so skill discovery and coordinator execution use the standardized RPIV names.

Target RPIV skill files:

- `.github/skills/research/SKILL.md`
- `.github/skills/planner/SKILL.md`
- `.github/skills/implementer/SKILL.md`
- `.github/skills/verifier/SKILL.md`
- `.github/skills/justdoit/SKILL.md`
- `.github/skills/justdoit/processes/run-rpiv-pipeline.md`

Physical skill directory names must remain unchanged.

### Acceptance Criteria

- [ ] `.github/skills/research/SKILL.md` front-matter uses `name: rpiv-research`.
- [ ] `.github/skills/planner/SKILL.md` front-matter uses `name: rpiv-planner`.
- [ ] `.github/skills/implementer/SKILL.md` front-matter uses `name: rpiv-implementer`.
- [ ] `.github/skills/verifier/SKILL.md` front-matter uses `name: rpiv-verifier`.
- [ ] `.github/skills/justdoit/SKILL.md` front-matter uses `name: rpiv`.
- [ ] RPIV skill entrypoint headings and introductory user-facing text use the standardized RPIV names.
- [ ] `.github/skills/justdoit/processes/run-rpiv-pipeline.md` uses `skill="rpiv-research"`, `skill="rpiv-planner"`, `skill="rpiv-implementer"`, and `skill="rpiv-verifier"`.
- [ ] No RPIV `Subagent` call still uses `skill="research"`, `skill="planner"`, `skill="implementer"`, or `skill="verifier"`.
- [ ] Non-RPIV skill front-matter `name:` values remain unchanged.
- [ ] Physical skill directory paths remain unchanged.

### Test Coverage

- [ ] Static front-matter inspection confirms all RPIV skill `name:` values match the required names.
- [ ] Static search confirms no RPIV skill front-matter still uses `name: research`, `name: planner`, `name: implementer`, `name: verifier`, or `name: justdoit`.
- [ ] Static search confirms RPIV coordinator skill process references standardized skill names in every `Subagent` call.
- [ ] Static inspection confirms non-RPIV skill names remain `bootstrap`, `onboard-repo`, `excali`, `issue-generator`, `harness-cli-it`, `agnostic-prompt-standard`, and `pr-review-complement`.

## Task T3: Update documentation and repo maps

- **Status:** Pending
- **Complexity:** Medium
- **Dependencies:** T1, T2
- **Related ADRs:** None
- **Related Core-Components:** CORE-COMPONENT-0002 Commit Standards, applicable to final commit/PR title only

### Description

Update user-facing documentation and repository maps so they consistently present RPIV workflows by the standardized names while preserving path references where paths remain unchanged.

Target files include:

- `AGENTS.md`
- `LLM.txt`
- `.github/skills/README.md`
- `CONTRIBUTING.md`

The implementer should also inspect nearby documentation for additional user-facing RPIV naming references.

### Acceptance Criteria

- [ ] `AGENTS.md` `PIPELINE_STAGES` uses `rpiv-research`, `rpiv-planner`, `rpiv-implementer`, and `rpiv-verifier` in agent fields.
- [ ] `AGENTS.md` RPIV entries use standardized RPIV names as user-facing map keys or labels.
- [ ] `AGENTS.md` full-pipeline coordinator entry is presented as `rpiv`, not `justdoit`.
- [ ] `LLM.txt` describes RPIV agent and skill entries using the standardized RPIV names.
- [ ] `.github/skills/README.md` maps RPIV agent/skill paths to standardized user-facing names.
- [ ] `CONTRIBUTING.md` presents the pipeline invocation/workflow names as `rpiv`, `rpiv-research`, `rpiv-planner`, `rpiv-implementer`, and `rpiv-verifier` where user-facing workflow names are discussed.
- [ ] Documentation distinguishes retained physical paths from standardized user-facing names when needed.
- [ ] Non-RPIV documentation entries keep their existing user-facing names.
- [ ] Historical issue, pull request, and commit references are not rewritten solely for this change.

### Test Coverage

- [ ] Static review confirms `AGENTS.md`, `LLM.txt`, `.github/skills/README.md`, and `CONTRIBUTING.md` use standardized RPIV names in user-facing contexts.
- [ ] Static search confirms old RPIV names are not presented as primary workflow names in repo maps.
- [ ] Manual review confirms any remaining old terms are path segments, internal stage labels, or explicitly documented legacy/path context.
- [ ] Manual review confirms non-RPIV names are unchanged in documentation and maps.

## Task T4: Run final naming audit and acceptance verification

- **Status:** Pending
- **Complexity:** Small
- **Dependencies:** T1, T2, T3
- **Related ADRs:** None
- **Related Core-Components:** CORE-COMPONENT-0002 Commit Standards, applicable to final commit/PR title only

### Description

Perform a repository-wide audit after implementation to verify all acceptance criteria are satisfied and no unintended architecture artifacts or unrelated workflow renames were introduced.

The audit should focus on active discovery surfaces, active dispatch references, documentation, and repo maps. It should allow retained physical paths and historical issue/PR/commit references.

### Acceptance Criteria

- [ ] RPIV workflow discovery presents `rpiv-research`, `rpiv-planner`, `rpiv-implementer`, `rpiv-verifier`, and `rpiv`.
- [ ] RPIV workflow discovery no longer presents `research`, `planner`, `implementer`, `verifier`, or `justdoit` as primary user-facing RPIV workflow names.
- [ ] Active RPIV agent and skill dispatch references use standardized RPIV names.
- [ ] Documentation and repo maps consistently present standardized RPIV names.
- [ ] Non-RPIV workflows keep their existing user-facing names.
- [ ] Physical RPIV file and directory paths remain unchanged.
- [ ] Historical issue, pull request, and commit references are not rewritten solely for this change.
- [ ] No ADR files are created or modified.
- [ ] No core-component files are created or modified.
- [ ] `project/architecture/ADR/DECISION-LOG.md` is not modified.

### Test Coverage

- [ ] Repository-wide static search is reviewed for legacy RPIV names in discovery and dispatch contexts.
- [ ] `git diff --name-only` confirms changed files are limited to RPIV naming metadata, dispatch references, docs, repo maps, and implementation notes.
- [ ] `git diff --name-only` confirms no changes under `project/architecture/ADR/` or `project/architecture/core-components/`.
- [ ] Final acceptance-criteria checklist is populated with file-path evidence for each criterion.
- [ ] Final commit message and PR title follow CORE-COMPONENT-0002 Conventional Commits requirements.
