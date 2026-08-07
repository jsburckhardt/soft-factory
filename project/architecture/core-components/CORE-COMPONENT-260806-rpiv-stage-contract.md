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
- Research MUST create work-item artifacts under `project/work-items/<ISSUE_NUMBER>-<SHORT_DESCRIPTION>/`.
- Research MUST derive `<SHORT_DESCRIPTION>` as lowercase ASCII kebab-case from the GitHub Issue title.
- Later stages MUST resolve the existing work-item directory by issue-number prefix and preserve its original name.
- Each issue-number prefix MUST identify exactly one work-item directory.
- Research MUST record constraints, risks, relevant architecture, acceptance criteria, and repository findings only.
- Plan MUST assign stable `AC-*` IDs and map each criterion to tasks, validation, and expected evidence.
- Implement MUST execute dependency-ordered tasks, maintain tests and affected application documentation, run configured validation, record evidence, and commit.
- Implement MUST cover applicable README, API, configuration, usage, migration, architecture, operational, and deployment documentation.
- Implement MUST record documentation evidence or a concrete no-impact rationale.
- Verify MUST inspect the exact implementation commit and independently verify affected application documentation.
- Verify MUST return missing, stale, inaccurate, or inconclusive application documentation to Implement.
- Verify MUST decide acceptance, update GitHub, push, and create the pull request.
- Implement and Verify MUST use `./harness` and `.harness/contract.yml` for validation.
- Implement MUST run focused harness validation while building and full harness validation before handoff.
- Verify MUST rerun full harness validation independently.
- Every RPIV stage MUST read harness friction before phase work.
- Every RPIV stage MUST record phase friction before success or failure handoff.
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
- Stage agents use prior friction to avoid repeating unsupported inference.
- Stage agents record missing harness proof for the next phase and future runs.
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
- Keep validation behavior in the harness contract.
- Keep executable project command bodies in the root `justfile` behind the harness.
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
