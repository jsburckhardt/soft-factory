# Test Plan: Harden devcontainer IPC and preserve repository contracts

## Test TEST-1: Exercise IPC propagation and stale-state transitions

- **Type:** Integration
- **Task:** T-1
- **Acceptance Criteria:** AC-1, AC-2, AC-7
- **Priority:** Critical

### Setup
Use a temporary workspace, unique tmux socket/server, temporary CLI configuration, and a stub final login process that records the IPC environment without credentials or interaction. Register cleanup for only explicit test resources.

### Steps
1. Seed stale global state, run startup with a new value, and query `show-environment -g -s`.
2. Evaluate that shell output before invoking the stub login and record its environment.
3. Repeat with changed and unchanged non-empty values.
4. Start with empty and unset values while the simulated login shell begins stale.
5. Run absent-to-present, present-to-absent, repeated, and initially stale sequences and compare all observations to expected current states.

### Expected Result
Non-empty starts expose only the current value. Empty/unset starts emit an unset action and later login receives no value. No transition retains stale state.

### Expected Evidence
A zero-exit transition table containing startup input, tmux output, login observation, and result.

## Test TEST-2: Validate shell syntax and tmux configuration

- **Type:** Static / integration
- **Task:** T-1
- **Acceptance Criteria:** AC-9
- **Priority:** High

### Setup
Ensure Bash and tmux are available and allocate a unique temporary socket.

### Steps
1. Run `bash -n .devcontainer/post-start.sh`.
2. Run `bash -n .devcontainer/post-create.sh`.
3. Start a detached session with `.devcontainer/tmux.conf`, source it non-interactively, query `update-environment`, and terminate only the test server.

### Expected Result
All commands exit zero and configuration contains `VSCODE_IPC_HOOK_CLI`.

### Expected Evidence
Captured commands, tmux configuration output, and explicit zero statuses.

## Test TEST-3: Inspect agent concision and replacement contracts

- **Type:** Contract / static
- **Task:** T-2
- **Acceptance Criteria:** AC-3, AC-6, AC-8, AC-11
- **Priority:** High

### Setup
Read both agent files and use a temporary inherited `justfile` fixture.

### Steps
1. Assert explicit Less-is-more and KISS rules with essential and independently verifiable wording.
2. Assert bootstrap detects existing `justfile`, requests replacement confirmation, and routes confirmation to replacement-capable editing rather than creation.
3. Assert declined/missing confirmation returns before any target write.
4. Model both outcomes: compare decline checksums, then confirm replacement and run `just --list --justfile <fixture>`.

### Expected Result
All assertions pass; decline preserves exact bytes and confirmation permits valid replacement despite file existence.

### Expected Evidence
Line-numbered matches, equal decline checksums, differing confirmed checksums, and successful recipe output.

## Test TEST-4: Prove bounded cleanup and map consistency

- **Type:** Repository integrity
- **Task:** T-3
- **Acceptance Criteria:** AC-4, AC-10
- **Priority:** High

### Setup
Resolve the merge-base with `origin/main` and define the sorted three-path expected deletion list.

### Steps
1. Derive all `D` paths from merge-base diff and compare them byte-for-byte with expected.
2. Assert all three paths are absent.
3. Assert `LLM.txt` lacks the pipeline and tasks references.
4. Assert pipeline diagram and root `justfile` remain tracked and present.

### Expected Result
Deletion set is exact, stale/requested references are absent, and protected files remain.

### Expected Evidence
Expected/actual lists, comparison status zero, grep results, and tracking/presence output.

## Test TEST-5: Validate root command interface and recipes

- **Type:** Contract / regression
- **Task:** T-4
- **Acceptance Criteria:** AC-5, AC-12
- **Priority:** Critical

### Setup
Run after T-1 through T-3 in the repository development environment.

### Steps
1. Assert root `justfile` exists and is tracked.
2. Run `git diff --exit-code HEAD -- justfile`.
3. Run `just --list` and assert both required recipes.
4. Run `just verify-focused` and capture output/status.
5. Run `just verify` and capture output/status.

### Expected Result
The root file is unchanged and both recipes are callable and successful.

### Expected Evidence
Tracking output, empty file diff, recipe listing, and both zero-exit outputs.

## Acceptance Coverage Validation
| AC | Test | Task |
|---|---|---|
| AC-1 | TEST-1 | T-1 |
| AC-2 | TEST-1 | T-1 |
| AC-3 | TEST-3 | T-2 |
| AC-4 | TEST-4 | T-3 |
| AC-5 | TEST-5 | T-4 |
| AC-6 | TEST-3 | T-2 |
| AC-7 | TEST-1 | T-1 |
| AC-8 | TEST-3 | T-2 |
| AC-9 | TEST-2 | T-1 |
| AC-10 | TEST-4 | T-3 |
| AC-11 | TEST-3 | T-2 |
| AC-12 | TEST-5 | T-4 |

Every AC has a task, finite validation, and concrete expected evidence. Tests require no credentials, interactive login, destructive external state, or out-of-scope changes.
