# Action Plan: Harden devcontainer IPC and preserve repository contracts

## Feature
- **ID:** 39
- **Research Brief:** `project/work-items/39-fix-repo-harden-devcontainer-ipc-and-preserve-repository-contracts/research/00-research.md`

## ADRs Created
- None. The issue introduces no architectural choice.

## Core-Components Created
- None. The work implements existing contracts without changing reusable cross-cutting behavior.

## Acceptance Criteria
- **AC-1:** When `VSCODE_IPC_HOOK_CLI` has a non-empty value, `.devcontainer/post-start.sh`, `.devcontainer/post-create.sh`, and `.devcontainer/tmux.conf` make that current value observable through tmux and available to a later `gh login` invocation inside the shared tmux session.
- **AC-2:** When `VSCODE_IPC_HOOK_CLI` is unset or empty, startup leaves no tmux-global value that a later `gh login` invocation inside the shared tmux session can receive from an earlier start.
- **AC-3:** `.github/agents/issue-generator.agent.md` explicitly requires Less-is-more essential context and KISS acceptance criteria consisting of the smallest clear, independently verifiable set.
- **AC-4:** The cleanup removes the tracked artifacts `.github/evolution.excalidraw`, `.github/harness-engineering.excalidraw`, and `.vscode/tasks.json`, removes the `project/architecture/soft-factory-pipeline.excalidraw` entry from `LLM.txt`, and removes no other tracked artifact as part of that cleanup.
- **AC-5:** The repository root `justfile` remains present and exposes callable `verify-focused` and `verify` recipes.
- **AC-6:** After the required replacement confirmation, the bootstrap agent contract permits replacing or regenerating a root `justfile` inherited from the repository template and does not fail solely because that target file already exists.
- **AC-7:** Repeated starts, including value changes, present-to-absent transitions, absent-to-present transitions, and an initially stale tmux-global value, leave tmux and later `gh login` invocations with only the current startup state.
- **AC-8:** The bootstrap agent contract leaves the inherited root `justfile` unchanged when replacement is not confirmed.
- **AC-9:** Shell syntax checks and a non-interactive tmux configuration check exit successfully for the affected development-container files, with command output captured as evidence.
- **AC-10:** Deterministic tracked-file and `LLM.txt` reference checks confirm the bounded cleanup outcome.
- **AC-11:** Agent prompt inspection confirms the issue-generation concision rules and both bootstrap confirmation branches.
- **AC-12:** In the repository development environment, `just verify-focused` and `just verify` each exit successfully with output captured as evidence.

## Acceptance Coverage
| AC | Implementation | Validation | Expected evidence |
|---|---|---|---|
| AC-1 | T-1 | TEST-1 | Isolated tmux and simulated login output show the current value. |
| AC-2 | T-1 | TEST-1 | Tmux emits an unset action and simulated login observes absence. |
| AC-3 | T-2 | TEST-3 | Prompt assertions identify both explicit concision rules. |
| AC-4 | T-3 | TEST-4 | Diff reports exactly three required deletions and the map entry is absent. |
| AC-5 | T-4 | TEST-5 | Presence and recipe listing show both required commands. |
| AC-6 | T-2 | TEST-3 | Confirmed existing-file branch uses replacement-capable editing. |
| AC-7 | T-1 | TEST-1 | Transition table shows only current state for every required sequence. |
| AC-8 | T-2 | TEST-3 | No-confirm branch plus equal checksums prove preservation. |
| AC-9 | T-1 | TEST-2 | Shell and tmux checks return zero with captured output. |
| AC-10 | T-3 | TEST-4 | Exact deletion-set and reference assertions return zero. |
| AC-11 | T-2 | TEST-3 | Inspection output identifies concision and both confirmation branches. |
| AC-12 | T-4 | TEST-5 | Both just recipes return zero with captured output. |

**Coverage proof:** Every AC-1 through AC-12 maps to implementation, validation, and concrete evidence.

## Implementation Tasks
- **T-1 (AC-1, AC-2, AC-7, AC-9):** Preserve current IPC propagation, mark the tmux-global variable removed for empty/unset startup, and validate lifecycle transitions.
- **T-2 (AC-3, AC-6, AC-8, AC-11):** Preserve issue concision rules and add explicit confirmed-replacement and no-confirm preservation branches to bootstrap.
- **T-3 (AC-4, AC-10):** Preserve exactly the three cleanup deletions, remove requested and stale map references, and retain protected files.
- **T-4 (AC-5, AC-12):** Preserve the root command interface, run both validation recipes, and record handoff evidence.

## Relevant Architecture
- `CORE-COMPONENT-260806-rpiv-stage-contract`
- `CORE-COMPONENT-260806-project-command-interface`
- `CORE-COMPONENT-260806-agent-executable-acceptance-criteria`
- ADRs: None.

## Scope Guardrails
- Preserve current uncommitted user changes and modify only issue #39 files plus RPIV artifacts.
- Do not delete `justfile` or `project/architecture/soft-factory-pipeline.excalidraw`.
- Do not replace the deleted automatic tmux attachment task unless separately requested.
- Do not modify architecture artifacts or `DECISION-LOG.md`.

