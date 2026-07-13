# Test Plan: Standardize RPIV Workflow Naming

## Test TEST-001: RPIV agent discovery metadata and dispatch references

- **Type:** Static inspection
- **Task:** T1
- **Priority:** High

### Setup

Complete Task T1.

### Steps

1. Inspect front-matter in:
   - `.github/agents/rpiv-research.agent.md`
   - `.github/agents/rpiv-planner.agent.md`
   - `.github/agents/rpiv-implementer.agent.md`
   - `.github/agents/rpiv-verifier.agent.md`
   - `.github/agents/rpiv.agent.md`
2. Inspect `.github/agents/rpiv.agent.md` for:
   - `agents:` list values
   - `STAGE_AGENTS` agent values
   - `agent/runSubagent` agent arguments
   - recovery guidance using `@...`
3. Inspect active handoff references in `.github/agents/bootstrap.agent.md` and `.github/agents/onboard-repo.agent.md`.
4. Inspect non-RPIV agent front-matter names.

### Expected Result

- RPIV agent front-matter names are `rpiv-research`, `rpiv-planner`, `rpiv-implementer`, `rpiv-verifier`, and `rpiv`.
- Active RPIV dispatch and recovery references use standardized RPIV names.
- Non-RPIV agent names remain unchanged.
- Renamed RPIV agent file paths exist and old RPIV agent file paths are removed.

## Test TEST-002: RPIV skill discovery metadata and skill orchestration references

- **Type:** Static inspection
- **Task:** T2
- **Priority:** High

### Setup

Complete Task T2.

### Steps

1. Inspect front-matter in:
   - `.github/skills/rpiv-research/SKILL.md`
   - `.github/skills/rpiv-planner/SKILL.md`
   - `.github/skills/rpiv-implementer/SKILL.md`
   - `.github/skills/rpiv-verifier/SKILL.md`
   - `.github/skills/rpiv/SKILL.md`
2. Inspect `.github/skills/rpiv/processes/run-rpiv-pipeline.md` for `Subagent` skill arguments.
3. Inspect RPIV skill entrypoint headings and introductory text.
4. Inspect non-RPIV skill front-matter names.

### Expected Result

- RPIV skill front-matter names are `rpiv-research`, `rpiv-planner`, `rpiv-implementer`, `rpiv-verifier`, and `rpiv`.
- RPIV coordinator skill dispatches `rpiv-research`, `rpiv-planner`, `rpiv-implementer`, and `rpiv-verifier`.
- Non-RPIV skill names remain unchanged.
- Renamed RPIV skill directory paths exist and old RPIV skill directory paths are removed.

## Test TEST-003: Documentation and repo map naming consistency

- **Type:** Documentation review
- **Task:** T3
- **Priority:** High

### Setup

Complete Tasks T1, T2, and T3.

### Steps

1. Review `AGENTS.md`.
2. Review `LLM.txt`.
3. Review `.github/skills/README.md`.
4. Review `CONTRIBUTING.md`.
5. Search these files for user-facing references to `research`, `planner`, `implementer`, `verifier`, and `justdoit`.
6. Classify any remaining legacy terms as either:
   - allowed internal stage labels,
   - allowed historical/current issue context,
   - or disallowed primary workflow names.

### Expected Result

- Repo maps and documentation present RPIV workflows as `rpiv-research`, `rpiv-planner`, `rpiv-implementer`, `rpiv-verifier`, and `rpiv`.
- Any retained legacy terms are clearly path, stage, or historical-context references.
- Non-RPIV workflow names remain unchanged.

## Test TEST-004: Non-RPIV preservation and physical path boundary

- **Type:** Regression/static inspection
- **Task:** T1, T2, T3, T4
- **Priority:** Medium

### Setup

Complete all implementation tasks.

### Steps

1. Inspect non-RPIV agent front-matter names:
   - `bootstrap`
   - `onboard-repo`
   - `excali`
   - `issue-generator`
   - `harness-cli-it`
   - `APS v1.2.2 Agent`
2. Inspect non-RPIV skill front-matter names:
   - `bootstrap`
   - `onboard-repo`
   - `excali`
   - `issue-generator`
   - `harness-cli-it`
   - `agnostic-prompt-standard`
   - `pr-review-complement`
3. Confirm renamed RPIV physical file and directory paths exist.
4. Confirm old RPIV physical file and directory paths were removed.

### Expected Result

- Non-RPIV workflow names are unchanged.
- Renamed RPIV physical paths exist.
- Old RPIV physical paths are removed.

## Test TEST-005: Final acceptance and architecture-boundary audit

- **Type:** Acceptance audit
- **Task:** T4
- **Priority:** High

### Setup

Complete all implementation tasks and Tests TEST-001 through TEST-004.

### Steps

1. Run a repository-wide search for old RPIV names in discovery and dispatch contexts.
2. Confirm no RPIV front-matter discovery field uses old primary names.
3. Confirm no active RPIV `agent` or `skill` dispatch reference uses old primary names.
4. Review `git diff --name-only`.
5. Confirm no ADR files were created or modified.
6. Confirm no core-component files were created or modified.
7. Confirm `project/architecture/ADR/DECISION-LOG.md` was not modified.
8. Prepare evidence mapping each Issue #34 acceptance criterion to the file paths that satisfy it.
9. Ensure final commit message and PR title use Conventional Commits per `CORE-COMPONENT-0002`.

### Expected Result

- All Issue #34 acceptance criteria are satisfied with concrete file evidence.
- No architecture artifacts or decision log entries changed.
- No non-RPIV workflow was renamed.
- Final delivery can proceed to Verify with a Conventional Commit-compliant PR title.
