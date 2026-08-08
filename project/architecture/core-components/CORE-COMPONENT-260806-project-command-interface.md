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
- The root `justfile` MUST be the default operating surface for humans and agents.
- A project MAY adopt a documented command wrapper that delegates to root `justfile` recipes.
- A standalone verification command config MUST NOT duplicate the root `justfile`.
- The development environment MUST provide the `just` command runner.

### Interfaces
- Humans and agents discover default commands with `just --list`.
- Implement runs `just verify-focused` and `just verify` unless project architecture adopts another interface.
- Verify independently runs `just verify` unless project architecture adopts another interface.

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
just verify-focused
just verify
```

## Integration Guidelines

- Bootstrap derives recipe bodies from the selected technology stack.
- Documentation references recipe names instead of raw tool commands.
- Devcontainers preserve or add a `just` feature.

## Exceptions

- A recipe may be omitted when the selected stack has no applicable operation.
- An adopted wrapper may become the operating surface after its contract and consuming agents are updated.

## Enforcement

- [x] Automated checks
- [x] Code review checklist
- [x] Test coverage requirements

## Related ADRs

- None.
