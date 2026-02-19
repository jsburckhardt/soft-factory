# Research Brief: Example Workitem

## Title
Example Feature — User Greeting System

## Idea Summary
Implement a simple user greeting system that displays a personalized greeting message. This serves as a demonstration of the full pipeline.

## Scope Type
```
scope_type: workitem
```

## Related Workitem
WI-0001-example

## Existing Repo Context
- This is a greenfield template repository with no existing application code
- No prior ADRs or core-components exist

## External References
- N/A (this is a demonstration workitem)

## Options Considered

| Option | Description | Pros | Cons |
|--------|-------------|------|------|
| A. Simple function | Single greeting function | Simple, easy to test | Not extensible |
| B. Greeting service | Service class with interface | Extensible, testable | More setup |

## Recommendation
Option A — a simple function is sufficient for this demonstration.

## Risks & Unknowns
- No significant risks for this example
- Unknown: future greeting customization needs

## Required ADRs
No — this example does not require architectural decisions.

## Required Core-Components
No — this example does not introduce reusable cross-cutting behavior.

## Verification Strategy
- Unit tests for the greeting function
- Manual verification of output

## Architect Handoff Notes
- Proceed with a simple function-based approach
- No ADRs or core-components needed
- Create action plan focused on a single implementation task
