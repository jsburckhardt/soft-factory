---
name: bootstrap
description: "Bootstrap a new project from the Soft Factory template and seed foundational architecture artifacts."
license: MIT
metadata:
  author: "Soft Factory maintainers"
  spec_version: "1.0"
  framework_revision: "1.0.0"
  last_updated: "2026-07-01"
---

# Bootstrap

Bootstrap is a workflow skill for agents that need to gather project identity and foundational decisions, scaffold a new project, and seed Soft Factory architecture documentation.

## References

1. [00 Bootstrap Workflow](references/00-bootstrap-workflow.md)

## Skill layout

- `SKILL.md` - this file (skill entrypoint).
- `references/` - normative workflow reference documents.
  - `00-bootstrap-workflow.md` - project bootstrap, user confirmation, scaffolding, and architecture artifact rules.
- `processes/` - executable APS process documents.
  - `bootstrap-project.md` - end-to-end bootstrap workflow.
- `../templates/` - shared Soft Factory artifact templates.
  - `artifact-contract.md` - canonical artifact paths and ledger locations.
  - `adr.md` - ADR output structure.
  - `core-component.md` - core-component output structure.
  - `decision-log.md` - decision ledger output structure.
