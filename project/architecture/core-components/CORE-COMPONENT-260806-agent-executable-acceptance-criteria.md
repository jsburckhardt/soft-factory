# CORE-COMPONENT-260806-agent-executable-acceptance-criteria: Agent-Executable Acceptance Criteria

## Status

Adopted

## Purpose

Ensure generated issues define outcomes that autonomous agents can implement, validate, and support with evidence.

## Scope

This contract applies to issue generation, acceptance-criteria documentation, RPIV planning, implementation evidence, verification summaries, and pull requests.

## Definition

### Rules
- Every acceptance criterion MUST be bounded, deterministic, observable, and independently verifiable.
- Acceptance criteria MUST be achievable with repository access and configured agent tools.
- Requested validation MUST be safe, repeatable, and produce inspectable evidence.
- Acceptance criteria MUST NOT require unavailable credentials, inaccessible systems, unsupported hardware, indefinite observation, exhaustive proof, or nondeterministic success.
- Manual-only or subjective validation MUST NOT be required unless the user explicitly requests it and identifies an available reviewer.
- Production-only or destructive validation MUST NOT be required when a safe reproducible check can prove the outcome.
- Essential external or human prerequisites MUST be identified explicitly instead of being encoded as impossible agent tasks.
- Acceptance criteria MUST describe outcomes without prescribing implementation or test frameworks.

### Interfaces
- Issue Generator inspects `AGENTS.md` and the root `justfile` when present before drafting criteria.
- Issue Generator runs an agent-feasibility assessment before rubber-duck review and issue creation.
- The rubber-duck review challenges criteria that agents cannot execute or verify.
- Plan maps every accepted criterion to finite tasks, validation, and expected evidence.
- Implement records agent-produced evidence, and Verify independently decides whether that evidence proves acceptance.

### Expectations
- An agent can identify a finite completion state for every criterion.
- Validation evidence can be reproduced from repository-accessible commands and artifacts.
- Missing external access is surfaced as a dependency or blocker rather than hidden inside acceptance criteria.
- Criteria remain solution-neutral so Plan can choose the implementation and validation approach.

## Rationale

Unbounded, subjective, inaccessible, or manual-only criteria cause autonomous delivery to stall or produce unverifiable claims. Feasible outcome-based criteria preserve planning freedom while giving agents a clear path to evidence.

## Usage Examples

```text
Preferred: An invalid configuration produces a non-zero result and an actionable error message.
Rejected: A human confirms that the configuration experience feels intuitive.
```

## Integration Guidelines

- Derive feasible evidence from declared repository and agent capabilities.
- Split broad outcomes into independently verifiable criteria.
- State necessary external review or access in the problem context before issue creation.
- Never place credentials or secrets in issue text.

## Exceptions

- A user may explicitly require human or external validation only when the responsible reviewer or accessible environment is identified.

## Enforcement

- [x] Automated checks
- [x] Code review checklist
- [ ] Test coverage requirements

## Related ADRs

- None.
