# Verify Summary — #34

## Feature Overview

**Issue:** #34 — chore: standardize RPIV workflow naming

Delivered standardized RPIV user-facing workflow names across agent and skill discovery metadata, active coordinator dispatch references, and repository documentation/repo maps while preserving existing physical paths and non-RPIV workflow names.

## Branch & PR

| Field | Value |
|-------|-------|
| Branch | `feat/34-standardize-rpiv-naming` |
| PR | [chore: standardize rpiv workflow naming](https://github.com/jsburckhardt/soft-factory/pull/35) |

## Commits

| Hash | Message |
|------|---------|
| b0a81f8 | chore: standardize rpiv workflow naming |
| 40cba4f | docs: update AGENTS.md for rpiv workflow names |
| 8664e94 | docs: update rpiv workflow references |

## Acceptance Criteria

| Status | Criterion | Evidence |
|--------|-----------|----------|
| ✅ passed | The Research stage workflow is user-discoverable as `rpiv-research`. | `.github/agents/research.agent.md` and `.github/skills/research/SKILL.md` front matter use `name: rpiv-research`. |
| ✅ passed | The Planner stage workflow is user-discoverable as `rpiv-planner`. | `.github/agents/planner.agent.md` and `.github/skills/planner/SKILL.md` front matter use `name: rpiv-planner`. |
| ✅ passed | The Implementer stage workflow is user-discoverable as `rpiv-implementer`. | `.github/agents/implementer.agent.md` and `.github/skills/implementer/SKILL.md` front matter use `name: rpiv-implementer`. |
| ✅ passed | The Verifier stage workflow is user-discoverable as `rpiv-verifier`. | `.github/agents/verifier.agent.md` and `.github/skills/verifier/SKILL.md` front matter use `name: rpiv-verifier`. |
| ✅ passed | The full RPIV pipeline coordinator is user-discoverable as `rpiv` instead of `justdoit`. | `.github/agents/justdoit.agent.md` and `.github/skills/justdoit/SKILL.md` front matter use `name: rpiv`. |
| ✅ passed | User-facing references to the RPIV workflow set use the standardized RPIV names consistently. | `AGENTS.md`, `LLM.txt`, `.github/skills/README.md`, and `CONTRIBUTING.md` reference `rpiv`, `rpiv-research`, `rpiv-planner`, `rpiv-implementer`, and `rpiv-verifier`. |
| ✅ passed | Non-RPIV workflows keep their existing user-facing names. | Static front-matter verification confirmed non-RPIV names remain `bootstrap`, `onboard-repo`, `excali`, `issue-generator`, `harness-cli-it`, `agnostic-prompt-standard`, `pr-review-complement`, and `APS v1.2.2 Agent`. |
| ✅ passed | Historical issue, pull request, and commit references do not need to be rewritten solely to satisfy this change. | Changed-file scope verification is limited to RPIV naming metadata, docs/repo maps, and Issue #34 artifacts. |
| ✅ passed | Workflow discovery no longer presents `research`, `planner`, `implementer`, `verifier`, or `justdoit` as the primary user-facing RPIV workflow names. | Legacy discovery/dispatch grep guard found no primary-name matches in active discovery and dispatch contexts. |
| ✅ passed | Documentation and repo maps present the standardized RPIV workflow names consistently. | Documentation static checks passed for `AGENTS.md`, `LLM.txt`, `.github/skills/README.md`, and `CONTRIBUTING.md`. |

## ADRs & Core-Components

| ID | Title |
|----|-------|
| CORE-COMPONENT-0002 | Commit Standards |

## Verification Results

| Category | Command | Status |
|----------|---------|--------|
| Static inspection | Shell static RPIV naming verification from Issue #34 test plan | ✅ passed |
| Search guard | Legacy RPIV primary discovery/dispatch grep guard | ✅ passed |
| Architecture boundary | ADR/core-component/DECISION-LOG change guard | ✅ passed |
| Change scope | Issue #34 changed-file scope guard | ✅ passed |
| Commit signatures | GitHub commit signature verification for pushed commits | ✅ passed |

## Generated At

2026-07-13T07:41:59Z
