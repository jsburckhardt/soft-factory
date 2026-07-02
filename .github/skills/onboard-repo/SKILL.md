---
name: onboard-repo
description: "Introduce the Soft Factory engineering flow into an existing repository by documenting discovered architecture and seeding the first issue."
license: MIT
metadata:
  author: "Soft Factory maintainers"
  spec_version: "1.0"
  framework_revision: "1.0.0"
  last_updated: "2026-07-01"
---

# Onboard Repo

Onboard Repo is a workflow skill for agents that need to introduce Soft Factory into an existing repository by analyzing current code and documentation, recording discovered decisions, and creating a repository-understanding issue.

## References

1. [00 Repository Onboarding Workflow](references/00-repository-onboarding-workflow.md)

## Skill layout

- `SKILL.md` - this file (skill entrypoint).
- `references/` - normative workflow reference documents.
  - `00-repository-onboarding-workflow.md` - existing-repository onboarding rules.
- `processes/` - executable APS process documents.
  - `onboard-repository.md` - end-to-end repository onboarding workflow.
- `../templates/` - shared Soft Factory artifact templates.
  - `artifact-contract.md` - canonical artifact paths and ledger locations.
  - `adr.md` - ADR output structure.
  - `core-component.md` - core-component output structure.
  - `decision-log.md` - decision ledger output structure.
