# Implementation Notes: Issue #39

## Handoff Metadata

- **Branch:** `fix/39-harden-devcontainer-ipc`
- **Implementation commit SHA:** `30d67e931b5c21ff25a81a71878ee52b632d62d2`
- **Work item:** `project/work-items/39-fix-repo-harden-devcontainer-ipc-and-preserve-repository-contracts`
- **Architecture:** Implemented within the three planned core-component contracts; no ADR or core-component changes.

## Completed Tasks

- T-1: Completed shared tmux IPC lifecycle synchronization.
- T-2: Completed concise issue generation and safe bootstrap replacement contracts.
- T-3: Completed bounded cleanup and repository-map consistency.
- T-4: Completed root command-interface and validation checks.

## Acceptance Evidence

- **AC-1:** An isolated tmux server reported the current non-empty value through `tmux show-environment -g -s VSCODE_IPC_HOOK_CLI`; simulated later login evaluation observed `/tmp/ipc-one`, `/tmp/ipc-two`, and `/tmp/ipc-three`. `post-create.sh` loads that tmux value before `gh auth login`, and `tmux.conf` includes it in `update-environment`.
- **AC-2:** Empty and unset startup cases produced `unset VSCODE_IPC_HOOK_CLI;`; simulated login shells seeded with `stale` observed `<absent>`.
- **AC-3:** Prompt inspection found explicit Less-is-more essential-context wording at `.github/agents/issue-generator.agent.md:35` and KISS smallest clear independently-verifiable wording at line 36.
- **AC-4:** Merge-base deletion comparison matched exactly `.github/evolution.excalidraw`, `.github/harness-engineering.excalidraw`, and `.vscode/tasks.json`; no additional deletion was present. The pipeline entry is absent from `LLM.txt`.
- **AC-5:** `git ls-files --error-unmatch justfile`, `git diff --exit-code HEAD^ -- justfile`, and `just --list` proved the tracked root file remained present and exposed `verify-focused` and `verify`.
- **AC-6:** Bootstrap inspection found existing-file detection and explicit confirmation before writes; the confirmed `JUSTFILE_EXISTS` branch uses `edit/editFiles`, not unconditional creation. A replacement fixture changed checksum from `f76d6c40975698ad9ec264c36ab2774e8aa17f25a289f2f821d8b6c4be1a67d3` to `973caf5da7482a425386bb4fceebd0e31c13e13547f162f6f2027b77020361b8` and `just --list --justfile <fixture>` listed both required recipes.
- **AC-7:** Transition test passed stale-to-present, present-to-changed, repeated-present, present-to-empty, repeated-empty, absent-to-present, and present-to-unset cases. Every simulated login observed only current startup state.
- **AC-8:** Bootstrap returns before scaffolding or writes for pending/declined replacement. The decline fixture checksum remained `f76d6c40975698ad9ec264c36ab2774e8aa17f25a289f2f821d8b6c4be1a67d3` before and after.
- **AC-9:** `bash -n .devcontainer/post-start.sh` and `bash -n .devcontainer/post-create.sh` exited 0. An isolated tmux server loaded and sourced `.devcontainer/tmux.conf`; queried `update-environment` included `VSCODE_IPC_HOOK_CLI`.
- **AC-10:** `git diff --name-only --diff-filter=D "$(git merge-base HEAD origin/main)"` matched the sorted expected three-path set. Grep found neither stale `LLM.txt` reference, while `justfile` and `project/architecture/soft-factory-pipeline.excalidraw` remained tracked and present.
- **AC-11:** Line-numbered inspection identified issue concision rules, inherited-file detection, pending confirmation return, declined replacement return, and confirmed replacement-capable editing. Both fixture outcomes passed.
- **AC-12:** `just verify-focused` exited 0 with `git diff --check`; `just verify` exited 0 with `git diff --check "$(git merge-base HEAD origin/main)"`.

## Validation Evidence

### Focused

- T-1: `just verify-focused` — passed after lifecycle, shell syntax, and isolated tmux configuration checks.
- T-2: `just verify-focused` — passed after prompt assertions and replacement fixture checks.
- T-3: `just verify-focused` — passed after exact deletion and protected-file checks.
- T-4: `just verify-focused` — passed after command-interface checks and task-state update.

### Full

- `just verify` — final run passed after correcting three plan-artifact EOF blank-line findings from the first full run.

## Documentation Evidence

- `.github/agents/bootstrap.agent.md` now documents and executes the inherited-justfile confirmation, confirmed replacement, and decline-preservation branches.
- `.github/agents/issue-generator.agent.md` now documents explicit Less-is-more and KISS generation rules.
- `LLM.txt` removes references to the deleted task configuration and the intentionally unlisted pipeline diagram.
- No README, API, configuration guide, migration guide, architecture record, or runbook update is required: the change hardens internal devcontainer environment synchronization, agent prompt contracts, and repository inventory without changing documented setup commands, public APIs, configuration options, deployment procedures, or architecture contracts.

## Scope

Only issue #39 implementation files and preserved RPIV artifacts changed. GitHub acceptance checkboxes were not updated. Final acceptance remains owned by Verify.
