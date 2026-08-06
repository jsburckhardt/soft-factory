# CORE-COMPONENT-260806-project-command-interface: Project Command Interface

## Status

Adopted

## Purpose

Provide one discoverable, language-agnostic interface for project setup, operation, and validation commands.

## Scope

This contract applies to bootstrapped repositories, local development, RPIV validation, documentation, and agent command execution.

## Definition

### Rules
- Every bootstrapped project MUST provide a root `justfile`.
- Raw project operating commands MUST exist only in `justfile` recipe bodies.
- Applicable recipes MUST cover setup, run, test, lint, format-check, type-check, build, verify-focused, and verify.
- `./harness` MUST be the supported operating surface for humans and agents.
- `.harness/contract.yml` MUST define supported focused and full validation behavior.
- The harness MUST expose JSON friction list and phase-aware friction add commands.
- A standalone verification command config MUST NOT remain after harness migration.
- The development environment MUST provide the `just` command runner.

### Interfaces
- Humans and agents discover supported commands with `./harness help`.
- Implement runs `./harness verify-focused --json` and `./harness verify --json`.
- Verify independently runs `./harness verify --json`.
- Every RPIV stage reads friction before work and records friction before handoff.
- The harness delegates project command execution to root `justfile` recipes.

### Expectations
- Recipe names remain stable when underlying tools or package managers change.
- Inapplicable conditional recipes are omitted.
- Focused and full verification remain distinct recipes.

## Rationale

A stable command interface removes duplicated shell commands from agents and documentation while keeping project-specific implementation details in one executable file.

## Usage Examples

```just
test:
    uv run pytest

verify:
    just test
    just lint
```

```text
./harness verify-focused --json
./harness verify --json
```

## Integration Guidelines

- Bootstrap derives recipe bodies from the selected technology stack.
- Documentation references recipe names instead of raw tool commands.
- The harness contract records supported command and validation behavior.
- The harness contract records the RPIV friction lifecycle and entry schema.
- Devcontainers preserve or add a `just` feature.
- Harness migration removes the legacy verification command config.

## Exceptions

- A recipe may be omitted when the selected stack has no applicable operation.

## Enforcement

- [x] Automated checks
- [x] Code review checklist
- [x] Test coverage requirements

## Related ADRs

- None.
