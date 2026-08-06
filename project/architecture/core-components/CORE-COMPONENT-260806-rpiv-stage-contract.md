# CORE-COMPONENT-260806-rpiv-stage-contract: RPIV Stage Contract

## Status

Adopted

## Purpose

Define durable ownership, evidence, validation, and handoff boundaries across the RPIV delivery pipeline.

## Scope

This contract applies to the RPIV coordinator, all four RPIV stage agents, their issue artifacts, and pull requests.

## Definition

### Rules
- RPIV MUST create or confirm the issue feature branch before Research starts.
- Research MUST record constraints, risks, relevant architecture, acceptance criteria, and repository findings only.
- Plan MUST assign stable `AC-*` IDs and map each criterion to tasks, validation, and expected evidence.
- Implement MUST execute dependency-ordered tasks, maintain tests, run configured validation, record evidence, and commit.
- Verify MUST inspect the exact implementation commit, decide acceptance, update GitHub, push, and create the pull request.
- Implement and Verify MUST use `./harness` and `.harness/contract.yml` for validation.
- Implement MUST run focused harness validation while building and full harness validation before handoff.
- Verify MUST rerun full harness validation independently.
- Every RPIV stage MUST read harness friction before phase work.
- Every RPIV stage MUST record phase friction before success or failure handoff.
- Verify MUST return code or test defects to Implement.
- Verify MUST return plan, architecture, scope, or acceptance coverage defects to Plan.

### Interfaces
- Plan hands Implement the acceptance catalog, tasks, test plan, ADRs, and core-components.
- Implement writes task completion, validation results, and `AC-*` evidence to `project/issues/<ISSUE_NUMBER>/implementation/00-implementation.md`.
- Implement hands Verify the branch, commit SHA, clean-tree proof, `AC-*` evidence, and validation results.
- Every action plan, task breakdown, test plan, implementation note, verification summary, and pull request carries stable `AC-*` IDs.

### Expectations
- Stage agents do not perform responsibilities owned by another stage.
- Stage agents use prior friction to avoid repeating unsupported inference.
- Stage agents record missing harness proof for the next phase and future runs.
- Failed verification causes correction and downstream re-execution before acceptance.
- GitHub acceptance checkboxes are updated only by Verify after independent acceptance.

## Rationale

Explicit ownership prevents premature acceptance claims, duplicated validation logic, uncommitted handoffs, and gaps between issue criteria and delivery evidence.

## Usage Examples

```text
AC-1 -> Task T-1 -> Test V-1 -> Expected evidence -> Implementation evidence -> Verify decision
```

## Integration Guidelines

- Keep stage prompts and AGENTS.md aligned with this contract.
- Keep validation behavior in the harness contract.
- Keep executable project command bodies in the root `justfile` behind the harness.
- Preserve acceptance criterion order when assigning stable IDs.
- Include the Implement handoff commit SHA in verification records.

## Exceptions

- None.

## Enforcement

- [ ] Automated checks
- [x] Code review checklist
- [x] Test coverage requirements

## Related ADRs

- None.
