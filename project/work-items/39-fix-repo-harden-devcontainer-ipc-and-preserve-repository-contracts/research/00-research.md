# Research Brief: fix(repo): harden devcontainer IPC and preserve repository contracts

## GitHub Issue
- **Issue:** #39
- **Title:** fix(repo): harden devcontainer IPC and preserve repository contracts
- **Work Item:** `project/work-items/39-fix-repo-harden-devcontainer-ipc-and-preserve-repository-contracts`

## Scope Classification
- **Scope Type:** issue

## Problem Statement
Shared tmux sessions can retain a dead VS Code CLI IPC endpoint, causing later GitHub CLI login attempts to use a stale socket. The issue also bounds obsolete-artifact cleanup, preserves the root command interface, distinguishes confirmed from unconfirmed bootstrap replacement of a template command file, and requires concise generated issues.

## Acceptance Criteria

**Core**
- [ ] When `VSCODE_IPC_HOOK_CLI` has a non-empty value, `.devcontainer/post-start.sh`, `.devcontainer/post-create.sh`, and `.devcontainer/tmux.conf` make that current value observable through tmux and available to a later `gh login` invocation inside the shared tmux session.
- [ ] When `VSCODE_IPC_HOOK_CLI` is unset or empty, startup leaves no tmux-global value that a later `gh login` invocation inside the shared tmux session can receive from an earlier start.
- [ ] `.github/agents/issue-generator.agent.md` explicitly requires Less-is-more essential context and KISS acceptance criteria consisting of the smallest clear, independently verifiable set.
- [ ] The cleanup removes the tracked artifacts `.github/evolution.excalidraw`, `.github/harness-engineering.excalidraw`, and `.vscode/tasks.json`, removes the `project/architecture/soft-factory-pipeline.excalidraw` entry from `LLM.txt`, and removes no other tracked artifact as part of that cleanup.
- [ ] The repository root `justfile` remains present and exposes callable `verify-focused` and `verify` recipes.
- [ ] After the required replacement confirmation, the bootstrap agent contract permits replacing or regenerating a root `justfile` inherited from the repository template and does not fail solely because that target file already exists.

**Edge Cases**
- [ ] Repeated starts, including value changes, present-to-absent transitions, absent-to-present transitions, and an initially stale tmux-global value, leave tmux and later `gh login` invocations with only the current startup state.
- [ ] The bootstrap agent contract leaves the inherited root `justfile` unchanged when replacement is not confirmed.

**Verification**
- [ ] Shell syntax checks and a non-interactive tmux configuration check exit successfully for the affected development-container files, with command output captured as evidence.
- [ ] Deterministic tracked-file and `LLM.txt` reference checks confirm the bounded cleanup outcome.
- [ ] Agent prompt inspection confirms the issue-generation concision rules and both bootstrap confirmation branches.
- [ ] In the repository development environment, `just verify-focused` and `just verify` each exit successfully with output captured as evidence.

## Repository Findings
- Issue #39 has exactly one start marker, one end marker, and 12 unchecked Markdown criteria in Core, Edge Cases, and Verification groups, matching `project/work-items/README.md`.
- Branch `fix/39-harden-devcontainer-ipc` is at `4a162ab`, the current `origin/main` tip. Before this brief, the working diff modified five text files and deleted exactly three tracked files.
- `.devcontainer/devcontainer.json` invokes `post-create.sh` and `post-start.sh` and provides GitHub CLI, tmux, and just features.
- `.devcontainer/post-start.sh` uses `.devcontainer/.tmux-shared` and session `soft-factory`, sources `tmux.conf` every start, and only calls `set-environment -g` for non-empty values.
- The current diff adds `VSCODE_IPC_HOOK_CLI` to that conditional set and to `update-environment` in `.devcontainer/tmux.conf`; no symbol or branch removes an existing tmux-global value when startup has an empty or absent value.
- `.devcontainer/post-create.sh` defines the shell `gh login` alias. The diff adds evaluation of `tmux show-environment -g -s VSCODE_IPC_HOOK_CLI` before `gh auth login --web --clipboard`.
- `.devcontainer/tmux-attach.sh` attaches to the same socket and session. The deleted HEAD version of `.vscode/tasks.json` automatically invoked it on folder open.
- `.github/agents/issue-generator.agent.md` now has explicit Less-is-more and KISS instructions while retaining structured and agent-executable criteria rules.
- `.github/agents/bootstrap.agent.md` requires proposed-recipe confirmation and a general `INFO_CONFIRMED` gate. `configure-operations` always uses `edit/createFile` for `justfile` and has no explicit existing-file, replacement-confirmed, or replacement-unconfirmed branch.
- Root `justfile` is unchanged; `just --list` reports callable `verify-focused` and `verify`, both based on `git diff --check` with different ranges.
- The diff deletes exactly `.github/evolution.excalidraw`, `.github/harness-engineering.excalidraw`, and `.vscode/tasks.json`. `project/architecture/soft-factory-pipeline.excalidraw` remains tracked and present, while its `LLM.txt` entry is removed.
- No relevant automated test or spec files exist; the only matching filename is an APS example under `.github/skills/`.

## Constraints
- `CORE-COMPONENT-260806-rpiv-stage-contract.md` limits Research content and requires a stable issue-prefixed work-item path.
- `CORE-COMPONENT-260806-project-command-interface.md` requires root `justfile`, `verify-focused`, `verify`, and development-environment availability of just.
- `CORE-COMPONENT-260806-agent-executable-acceptance-criteria.md` requires bounded, deterministic, observable, independently verifiable criteria and safe, repeatable repository evidence.
- `AGENTS.md` requires the two root recipes before RPIV and makes them the default validation surface.
- `.github/agents/bootstrap.agent.md` refuses already-bootstrapped repositories, requires confirmation before writes, and requires generated operations to satisfy its justfile contract.
- `.devcontainer/post-start.sh` uses `set -euo pipefail`; unhandled tmux failures stop startup. It sources configuration for new and existing sessions.
- Cleanup is bounded to three tracked deletions and one specific `LLM.txt` entry removal; root `justfile` and the pipeline Excalidraw file are outside the deletion boundary.

## Relevant ADRs and Core-Components
- **ADRs:** None; `project/architecture/ADR/DECISION-LOG.md` registers no ADRs.
- **CORE-COMPONENT-260806-rpiv-stage-contract** — Research ownership and stable work-item paths.
- **CORE-COMPONENT-260806-project-command-interface** — root justfile and required recipes.
- **CORE-COMPONENT-260806-agent-executable-acceptance-criteria** — bounded agent-executable criteria.

## Risks and Open Questions
- The current `post-start.sh` diff does not remove a prior global IPC value on an empty or unset start, leaving present-to-absent and initially stale states exposed.
- Interaction among tmux `update-environment`, `source-file`, session creation or attachment, and explicit global updates is lifecycle- and order-dependent; repository documentation does not specify it.
- Quoting, absent-variable output, and behavior outside tmux for the shell `gh login` alias are undocumented.
- Bootstrap does not distinguish confirmed from unconfirmed root justfile replacement. Its earlier already-bootstrapped refusal may make replacement branches unreachable for some states.
- Deleting `.vscode/tasks.json` removes the only tracked automatic folder-open shared-session attachment; continued discoverability is undocumented.
- `LLM.txt` still references deleted `.vscode/tasks.json`, so the repository map would be stale if the current diff remained unchanged.
- No repository automated tests cover tmux environment lifecycle, bootstrap confirmation branches, or bounded cleanup.
