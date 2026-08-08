# CORE-COMPONENT-260806-rpiv-stage-contract: RPIV Stage Contract

## Status

Adopted

## Purpose

Define durable ownership, evidence, validation, and handoff boundaries across the RPIV delivery pipeline.

## Scope

This contract applies to the RPIV coordinator, all four RPIV stage agents, their work-item artifacts, and pull requests.

## Definition

### Rules
- RPIV MUST create or confirm the issue feature branch before Research starts.
- Every RPIV stage MUST resolve an existing work-item directory by issue-number prefix before choosing an artifact path.
- Every RPIV stage MUST preserve an existing work-item directory name.
- Research MUST reuse the existing work-item directory when one matches the issue-number prefix.
- Research MUST create `project/work-items/<ISSUE_NUMBER>-<SHORT_DESCRIPTION>/` only when no matching directory exists.
- Research MUST derive `<SHORT_DESCRIPTION>` as lowercase ASCII kebab-case from the GitHub Issue title when creating the directory.
- Research MUST fail when more than one work-item directory matches the issue-number prefix.
- Plan, Implement, and Verify MUST require exactly one existing work-item directory.
- Research MUST record constraints, risks, relevant architecture, acceptance criteria, and repository findings only.
- Plan MUST assign stable `AC-*` IDs and map each criterion to tasks, validation, and expected evidence.
- Implement MUST execute dependency-ordered tasks, maintain tests and affected application documentation, run configured validation, record evidence, and commit.
- Implement MUST cover applicable README, API, configuration, usage, migration, architecture, operational, and deployment documentation.
- Implement MUST record documentation evidence or a concrete no-impact rationale.
- Verify MUST inspect the exact implementation commit and independently verify affected application documentation.
- Verify MUST return missing, stale, inaccurate, or inconclusive application documentation to Implement.
- Verify MUST decide acceptance, update GitHub, push, and create the pull request.
- Implement and Verify MUST use root `justfile` recipes for validation by default.
- Implement MUST run `just verify-focused` while building and `just verify` before handoff by default.
- Verify MUST rerun `just verify` independently by default.
- Verify MUST return code or test defects to Implement.
- Verify MUST return plan, architecture, scope, or acceptance coverage defects to Plan.

### Interfaces
- Plan hands Implement the acceptance catalog, tasks, test plan, ADRs, and core-components.
- Implement writes task completion, validation results, and `AC-*` evidence to `project/work-items/<ISSUE_NUMBER>-<SHORT_DESCRIPTION>/implementation/00-implementation.md`.
- Implement hands Verify the branch, commit SHA, clean-tree proof, `AC-*` evidence, documentation evidence, and validation results.
- Every action plan, task breakdown, test plan, implementation note, verification summary, and pull request carries stable `AC-*` IDs.

### Expectations
- Stage agents do not perform responsibilities owned by another stage.
- Verify does not author application documentation or repair documentation defects.
- Failed verification causes correction and downstream re-execution before acceptance.
- GitHub acceptance checkboxes are updated only by Verify after independent acceptance.

## Rationale

Explicit ownership prevents premature acceptance claims, duplicated validation logic, stale documentation, uncommitted handoffs, and gaps between issue criteria and delivery evidence. Human-readable, stable work-item paths make repository artifacts understandable without coupling their location to later issue-title edits.

## Usage Examples

```text
AC-1 -> Task T-1 -> Test V-1 -> Expected evidence -> Implementation evidence -> Verify decision
Behavior change -> Documentation requirement -> Committed documentation -> Verify documentation decision
```

## Integration Guidelines

- Keep stage prompts and AGENTS.md aligned with this contract.
- Resolve an existing work-item path before reading or writing stage artifacts.
- Keep default validation behavior and executable project command bodies in the root `justfile`.
- Document any adopted command wrapper and update stage agents before they consume it.
- Preserve acceptance criterion order when assigning stable IDs.
- Include the Implement handoff commit SHA in verification records.
- Include documentation changes or a no-impact rationale in implementation and verification records.

## Exceptions

- None.

## Enforcement

- [ ] Automated checks
- [x] Code review checklist
- [x] Test coverage requirements

## Related ADRs

- None.
