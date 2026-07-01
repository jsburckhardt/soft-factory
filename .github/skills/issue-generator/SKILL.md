---
name: issue-generator
description: "Draft a problem-focused GitHub issue with structured acceptance criteria and rubber-duck review."
license: MIT
metadata:
  author: "Soft Factory maintainers"
  spec_version: "1.0"
  framework_revision: "1.0.0"
  last_updated: "2026-07-01"
---

# Issue Generator

Issue Generator is a workflow skill for agents that need to create GitHub issues containing only a clear problem statement and structured acceptance criteria.

## References

1. [00 Issue Generation Workflow](references/00-issue-generation-workflow.md)

## Skill layout

- `SKILL.md` - this file (skill entrypoint).
- `references/` - normative workflow reference documents.
  - `00-issue-generation-workflow.md` - problem-focused issue generation rules.
- `processes/` - executable APS process documents.
  - `generate-issue.md` - end-to-end issue drafting and creation workflow.
