---
name: planner
description: "Read a research brief, commit required architecture artifacts, and produce action, task, and test plans."
license: MIT
metadata:
  author: "Soft Factory maintainers"
  spec_version: "1.0"
  framework_revision: "1.0.0"
  last_updated: "2026-07-01"
---

# Planner

Planner is a workflow skill for agents that need to transform a research brief into committed planning artifacts, including ADRs or core-components when required by scope.

## References

1. [00 Planning Workflow](references/00-planning-workflow.md)

## Skill layout

- `SKILL.md` - this file (skill entrypoint).
- `references/` - normative workflow reference documents.
  - `00-planning-workflow.md` - planning, architecture artifact, task breakdown, and test plan rules.
- `processes/` - executable APS process documents.
  - `plan-issue.md` - end-to-end planning workflow.
