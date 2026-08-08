# Work Items

This directory contains the documentation produced for each RPIV work item. Every work item maps to a **GitHub Issue** by number and adds a short description so readers can understand the subject without opening the issue.

## Canonical Structure

When an agent runs the pipeline for GitHub Issue `#42` titled "Improve cache invalidation", it creates:

```
project/work-items/42-improve-cache-invalidation/
  research/
    00-research.md          ← Research brief (scope classification, findings)
  plan/
    01-action-plan.md       ← Chosen approach, non-goals, acceptance criteria
    02-task-breakdown.md    ← Tasks with acceptance criteria and test requirements
    03-test-plan.md         ← Full test coverage requirements
  implementation/
    00-implementation.md    ← Implementation notes and decisions made during coding
  verify/
    summary.md              ← Feature delivery summary (commits, AC status, verification)
```

## Conventions

- Subdirectory names use `<issue-number>-<short-description>` (for example, `42-improve-cache-invalidation/`)
- The issue number is the unchanged GitHub Issue number
- The short description is lowercase ASCII kebab-case derived from the issue title when Research first creates the work item
- Research reuses an existing directory with the same issue-number prefix instead of creating another
- An existing work-item directory keeps its original name even if the GitHub Issue title changes later
- Exactly one work-item directory may use a given issue-number prefix
- Agents create these directories automatically — do not create them manually
- ADRs and core-components are **global** and live under `project/architecture/`, never inside a work-item folder
- Templates are defined in the agent specifications, not duplicated here
- Implementation notes record changed application documentation or an explicit no-impact rationale

## Acceptance Criteria Format

Every GitHub issue **must** include structured acceptance criteria for the RPIV pipeline to process it. Use the `@issue-generator` agent to create properly formatted issues.

The Plan stage assigns stable IDs (`AC-1`, `AC-2`, and so on) in issue order. Those IDs remain consistent across the action plan, task breakdown, test plan, implementation notes, verification summary, and pull request.

### Required format

Acceptance criteria must be formatted as markdown checkboxes wrapped with HTML comment markers:

```markdown
## Acceptance Criteria

<!-- ACCEPTANCE_CRITERIA_START -->

**Core**
- [ ] Criterion one
- [ ] Criterion two

**Edge Cases**
- [ ] Edge case one

**Verification**
- [ ] Verification requirement one

<!-- ACCEPTANCE_CRITERIA_END -->
```

### Rules

- Exactly one `<!-- ACCEPTANCE_CRITERIA_START -->` and one `<!-- ACCEPTANCE_CRITERIA_END -->` marker
- Only `- [ ]` checkbox list items between the markers (plus optional group headings)
- Every criterion is bounded, deterministic, observable, and independently verifiable by configured agents
- Validation uses repository tools or declared agent capabilities and produces inspectable evidence
- Criteria do not require unavailable credentials, inaccessible systems, unsupported hardware, indefinite observation, exhaustive proof, or subjective manual judgment
- Essential external or human prerequisites are stated explicitly instead of being encoded as impossible agent acceptance criteria
- Criteria describe required outcomes without prescribing implementation or test frameworks
- The verifier agent validates each criterion and marks satisfied ones as `- [x]` in both the issue and the PR description
