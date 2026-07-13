---
name: rpiv-implementer
description: "Execute planned tasks, produce code and tests, and record implementation notes."
license: MIT
metadata:
  author: "Soft Factory maintainers"
  spec_version: "1.0"
  framework_revision: "1.0.0"
  last_updated: "2026-07-01"
---

# rpiv-implementer

`rpiv-implementer` is a workflow skill for agents that need to execute tasks from a plan, follow the test plan, respect architecture boundaries, and document implementation outcomes.

## References

1. [00 Implementation Workflow](references/00-implementation-workflow.md)

## Skill layout

- `SKILL.md` - this file (skill entrypoint).
- `references/` - normative workflow reference documents.
  - `00-implementation-workflow.md` - implementation, testing, and notes rules.
- `processes/` - executable APS process documents.
  - `implement-plan.md` - end-to-end implementation workflow.
- `../templates/` - shared Soft Factory artifact templates.
  - `artifact-contract.md` - canonical artifact paths and ledger locations.
  - `implementation-notes.md` - implementation notes output structure.
