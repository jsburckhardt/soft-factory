# Implementation Notes: Issue #34 - Standardize RPIV Workflow Naming

## Summary

Standardized RPIV user-facing workflow names and renamed the physical RPIV agent files and skill directories.

Required names implemented:

- Research stage: `rpiv-research`
- Planner stage: `rpiv-planner`
- Implementer stage: `rpiv-implementer`
- Verifier stage: `rpiv-verifier`
- Full pipeline coordinator: `rpiv`

No ADR, core-component, or `project/architecture/ADR/DECISION-LOG.md` changes were made.

## Files Changed

- `.github/agents/rpiv-research.agent.md`
- `.github/agents/rpiv-planner.agent.md`
- `.github/agents/rpiv-implementer.agent.md`
- `.github/agents/rpiv-verifier.agent.md`
- `.github/agents/rpiv.agent.md`
- `.github/agents/bootstrap.agent.md`
- `.github/agents/onboard-repo.agent.md`
- `.github/skills/rpiv-research/SKILL.md`
- `.github/skills/rpiv-planner/SKILL.md`
- `.github/skills/rpiv-implementer/SKILL.md`
- `.github/skills/rpiv-verifier/SKILL.md`
- `.github/skills/rpiv/SKILL.md`
- `.github/skills/rpiv/processes/run-rpiv-pipeline.md`
- `.github/skills/README.md`
- `AGENTS.md`
- `LLM.txt`
- `CONTRIBUTING.md`
- `project/issues/34/implementation/README.md`

## Task T1: Update RPIV agent discovery metadata and agent dispatch references

- **Status:** Complete
- **Tests Passed:** 1
- **Tests Failed:** 0

### Changes Summary

- Updated RPIV agent front-matter names to `rpiv-research`, `rpiv-planner`, `rpiv-implementer`, `rpiv-verifier`, and `rpiv`.
- Updated `.github/agents/rpiv.agent.md` coordinator `agents:` list, `STAGE_AGENTS`, `agent/runSubagent` dispatch targets, and recovery `@...` references to standardized RPIV names.
- Updated bootstrap/onboard handoff and next-step guidance to target `rpiv-research`.
- Renamed all physical RPIV agent file paths to standardized RPIV names.

### Test Results

- Ran TEST-001 static agent checks.
- Confirmed RPIV agent front-matter has required names.
- Confirmed no active coordinator dispatch/recovery reference remains for `agent="research"`, `agent="planner"`, `agent="implementer"`, `agent="verifier"`, `agent: research`, `agent: planner`, `agent: implementer`, `agent: verifier`, or old `@...` handles.
- Confirmed non-RPIV agent names remain `bootstrap`, `onboard-repo`, `excali`, `issue-generator`, `harness-cli-it`, and `APS v1.2.2 Agent`.

## Task T2: Update RPIV skill discovery metadata and skill dispatch references

- **Status:** Complete
- **Tests Passed:** 1
- **Tests Failed:** 0

### Changes Summary

- Updated RPIV skill front-matter names to `rpiv-research`, `rpiv-planner`, `rpiv-implementer`, `rpiv-verifier`, and `rpiv`.
- Updated RPIV skill entrypoint headings and introductory text to show standardized names.
- Updated `.github/skills/rpiv/processes/run-rpiv-pipeline.md` `Subagent` skill arguments to `rpiv-research`, `rpiv-planner`, `rpiv-implementer`, and `rpiv-verifier`.
- Renamed all physical RPIV skill directory paths to standardized RPIV names.

### Test Results

- Ran TEST-002 static skill checks.
- Confirmed RPIV skill front-matter has required names.
- Confirmed no RPIV `Subagent` call still uses `skill="research"`, `skill="planner"`, `skill="implementer"`, or `skill="verifier"`.
- Confirmed non-RPIV skill names remain `bootstrap`, `onboard-repo`, `excali`, `issue-generator`, `harness-cli-it`, `agnostic-prompt-standard`, and `pr-review-complement`.

## Task T3: Update documentation and repo maps

- **Status:** Complete
- **Tests Passed:** 1
- **Tests Failed:** 0

### Changes Summary

- Updated `AGENTS.md` `PIPELINE_STAGES` agent fields to standardized RPIV names.
- Added/presented the full-pipeline coordinator as `rpiv` in the `AGENTS.md` repo map and renamed RPIV stage map keys to `rpiv-*`.
- Updated `LLM.txt` RPIV agent and skill descriptions to standardized names while retaining physical paths.
- Updated `.github/skills/README.md` with a user-facing name column mapping RPIV paths to `rpiv`, `rpiv-research`, `rpiv-planner`, `rpiv-implementer`, and `rpiv-verifier`.
- Updated `CONTRIBUTING.md` to refer to the `rpiv` pipeline and individual `rpiv-*` stage workflows.

### Test Results

- Ran TEST-003 documentation review.
- Confirmed docs and repo maps present standardized RPIV workflow names.
- Reviewed remaining old terms and classified them as internal stage IDs, artifact path segments, stage labels, or current issue documentation context.
- Confirmed non-RPIV documentation names were preserved.

## Task T4: Run final naming audit and acceptance verification

- **Status:** Complete
- **Tests Passed:** 2
- **Tests Failed:** 0

### Changes Summary

- Performed final active discovery, dispatch, preservation, path-boundary, and architecture-boundary audits.
- Confirmed tracked changes are limited to RPIV naming metadata, dispatch references, and documentation/repo maps; implementation notes are recorded at `project/issues/34/implementation/README.md`.

### Test Results

- Ran TEST-004 non-RPIV preservation and physical path checks.
- Ran TEST-005 final acceptance and architecture-boundary audit.
- Confirmed renamed RPIV physical agent paths and skill directories exist.
- Confirmed old RPIV physical agent files and skill directories were removed.
- Confirmed `git diff --name-only -- project/architecture/ADR project/architecture/core-components` produced no architecture changes.
- No commit or PR was created during Implement; Verify should use a Conventional Commits-compliant title such as `chore: standardize rpiv workflow naming` per CORE-COMPONENT-0002.

## Test Plan Coverage

| Test | Status | Evidence |
|------|--------|----------|
| TEST-001 | Passed | Static front-matter and dispatch checks for `.github/agents/*` RPIV files plus bootstrap/onboard handoffs. |
| TEST-002 | Passed | Static front-matter and `Subagent` skill checks for `.github/skills/*` RPIV files. |
| TEST-003 | Passed | Static review of `AGENTS.md`, `LLM.txt`, `.github/skills/README.md`, and `CONTRIBUTING.md`. |
| TEST-004 | Passed | Non-RPIV front-matter names unchanged; renamed RPIV physical paths exist; old physical RPIV paths removed. |
| TEST-005 | Passed | Final active naming audit and `git diff --name-only` architecture-boundary check completed. |

## Acceptance Evidence

- RPIV discovery names: `.github/agents/*.agent.md` and `.github/skills/*/SKILL.md` front-matter now expose `rpiv-research`, `rpiv-planner`, `rpiv-implementer`, `rpiv-verifier`, and `rpiv`.
- Active agent dispatch: `.github/agents/rpiv.agent.md` uses standardized `rpiv-*` agent names in the coordinator metadata, constants, `agent/runSubagent` calls, and recovery guidance.
- Active skill dispatch: `.github/skills/rpiv/processes/run-rpiv-pipeline.md` uses standardized `rpiv-*` skill names in all `Subagent` calls.
- Documentation/repo maps: `AGENTS.md`, `LLM.txt`, `.github/skills/README.md`, and `CONTRIBUTING.md` present standardized RPIV workflow names and retain physical path context where needed.
- Non-RPIV preservation: non-RPIV agent/skill front-matter names were verified unchanged.
- Architecture boundary: no ADR files, core-component files, or decision-log files were modified.
