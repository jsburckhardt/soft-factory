# Task Breakdown: Harden devcontainer IPC and preserve repository contracts

## Task T-1: Complete shared tmux IPC lifecycle synchronization

- **Status:** Complete
- **Complexity:** Medium
- **Dependencies:** None
- **Acceptance Criteria:** AC-1, AC-2, AC-7, AC-9
- **Related ADRs:** None
- **Related Core-Components:** CORE-COMPONENT-260806-agent-executable-acceptance-criteria

### Description
Preserve the IPC changes in the three development-container files. Add the missing empty/unset branch that marks `VSCODE_IPC_HOOK_CLI` removed globally so alias evaluation clears stale shell state. Keep socket/session behavior unchanged and use isolated test state. Record documentation impact or a concrete no-impact rationale.

### Acceptance Criteria
- **AC-1:** When `VSCODE_IPC_HOOK_CLI` has a non-empty value, `.devcontainer/post-start.sh`, `.devcontainer/post-create.sh`, and `.devcontainer/tmux.conf` make that current value observable through tmux and available to a later `gh login` invocation inside the shared tmux session.
- **AC-2:** When `VSCODE_IPC_HOOK_CLI` is unset or empty, startup leaves no tmux-global value that a later `gh login` invocation inside the shared tmux session can receive from an earlier start.
- **AC-7:** Repeated starts, including value changes, present-to-absent transitions, absent-to-present transitions, and an initially stale tmux-global value, leave tmux and later `gh login` invocations with only the current startup state.
- **AC-9:** Shell syntax checks and a non-interactive tmux configuration check exit successfully for the affected development-container files, with command output captured as evidence.

### Test Coverage
- Run TEST-1 for non-empty, repeated, changed, stale, present-to-absent, and absent-to-present states plus simulated login consumption.
- Run TEST-2 for both shell scripts and isolated tmux configuration loading.

### Expected Evidence
- Transition table with startup input, tmux shell output, and simulated-login observation.
- Zero-exit syntax/configuration output and focused source diff.
- Documentation impact/no-impact rationale in implementation evidence.

## Task T-2: Enforce concise issue generation and safe bootstrap replacement

- **Status:** Complete
- **Complexity:** Medium
- **Dependencies:** None
- **Acceptance Criteria:** AC-3, AC-6, AC-8, AC-11
- **Related ADRs:** None
- **Related Core-Components:** CORE-COMPONENT-260806-project-command-interface, CORE-COMPONENT-260806-agent-executable-acceptance-criteria

### Description
Preserve the issue-generator Less-is-more and KISS rules. Make bootstrap detect an inherited root `justfile`, explicitly obtain replacement confirmation, edit/regenerate it only after confirmation, and return before writing when confirmation is absent. Keep general pre-write confirmation and recipe validation intact.

### Acceptance Criteria
- **AC-3:** `.github/agents/issue-generator.agent.md` explicitly requires Less-is-more essential context and KISS acceptance criteria consisting of the smallest clear, independently verifiable set.
- **AC-6:** After the required replacement confirmation, the bootstrap agent contract permits replacing or regenerating a root `justfile` inherited from the repository template and does not fail solely because that target file already exists.
- **AC-8:** The bootstrap agent contract leaves the inherited root `justfile` unchanged when replacement is not confirmed.
- **AC-11:** Agent prompt inspection confirms the issue-generation concision rules and both bootstrap confirmation branches.

### Test Coverage
- Run TEST-3 static assertions for concision and absent-file, confirmed-replacement, and no-confirm branches.
- Model both existing-file outcomes on a temporary fixture; compare decline checksums and validate confirmed generated recipes.
- Assert the confirmed existing-file branch does not use `edit/createFile` for the target.

### Expected Evidence
- Line-numbered prompt assertions for all required branches and rules.
- Equal no-confirm checksums, differing confirmed checksums, and successful fixture recipe listing.

## Task T-3: Finalize bounded cleanup and repository map

- **Status:** Complete
- **Complexity:** Small
- **Dependencies:** None
- **Acceptance Criteria:** AC-4, AC-10
- **Related ADRs:** None
- **Related Core-Components:** CORE-COMPONENT-260806-agent-executable-acceptance-criteria

### Description
Preserve deletion of exactly `.github/evolution.excalidraw`, `.github/harness-engineering.excalidraw`, and `.vscode/tasks.json`. Preserve removal of the pipeline diagram entry from `LLM.txt`, remove the stale tasks entry, and retain the pipeline file and root `justfile`.

### Acceptance Criteria
- **AC-4:** The cleanup removes the tracked artifacts `.github/evolution.excalidraw`, `.github/harness-engineering.excalidraw`, and `.vscode/tasks.json`, removes the `project/architecture/soft-factory-pipeline.excalidraw` entry from `LLM.txt`, and removes no other tracked artifact as part of that cleanup.
- **AC-10:** Deterministic tracked-file and `LLM.txt` reference checks confirm the bounded cleanup outcome.

### Test Coverage
- Run TEST-4 against the merge-base and compare the complete sorted deletion set with expected paths.
- Assert required paths/references are absent and protected files remain tracked and present.

### Expected Evidence
- Matching expected/actual deletion lists and zero comparison status.
- `LLM.txt` grep and protected-file tracking/presence output.

## Task T-4: Validate the preserved command interface and handoff

- **Status:** Complete
- **Complexity:** Small
- **Dependencies:** T-1, T-2, T-3
- **Acceptance Criteria:** AC-5, AC-12
- **Related ADRs:** None
- **Related Core-Components:** CORE-COMPONENT-260806-rpiv-stage-contract, CORE-COMPONENT-260806-project-command-interface, CORE-COMPONENT-260806-agent-executable-acceptance-criteria

### Description
After dependent work, prove root `justfile` remains unchanged from `HEAD`, tracked, present, and callable. Run focused/full validation and record task, AC, validation, and documentation evidence in the preserved work-item directory.

### Acceptance Criteria
- **AC-5:** The repository root `justfile` remains present and exposes callable `verify-focused` and `verify` recipes.
- **AC-12:** In the repository development environment, `just verify-focused` and `just verify` each exit successfully with output captured as evidence.

### Test Coverage
- Run TEST-5 file/tracking checks, unchanged-file comparison, recipe listing, and both validation recipes.
- Confirm implementation evidence covers AC-1 through AC-12 before handoff.

### Expected Evidence
- Empty root `justfile` diff, recipe listing, and both zero-exit validation outputs.
- Completed `implementation/00-implementation.md` with AC-indexed and documentation evidence.

