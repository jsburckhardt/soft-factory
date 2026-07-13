---
name: rpiv
description: "Execute the full RPIV pipeline for a GitHub issue from Research through Verify."
license: MIT
metadata:
  author: "Soft Factory maintainers"
  spec_version: "1.0"
  framework_revision: "1.0.0"
  last_updated: "2026-07-01"
---

# rpiv

`rpiv` is a coordinator workflow skill for agents that need to drive a GitHub issue through Research, Plan, Implement, and Verify in strict order.

## References

1. [00 RPIV Pipeline Workflow](references/00-rpiv-pipeline-workflow.md)

## Skill layout

- `SKILL.md` - this file (skill entrypoint).
- `references/` - normative workflow reference documents.
  - `00-rpiv-pipeline-workflow.md` - full-pipeline orchestration rules.
- `processes/` - executable APS process documents.
  - `run-rpiv-pipeline.md` - end-to-end RPIV orchestration workflow.
- `../templates/` - shared Soft Factory artifact templates.
  - `artifact-contract.md` - canonical artifact paths and ledger locations used to verify stage outputs.
