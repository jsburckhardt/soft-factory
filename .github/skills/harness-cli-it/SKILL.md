---
name: harness-cli-it
description: "Create a repo-local engineering harness CLI that wraps existing commands, records evidence, and exposes supported human and agent workflows."
license: MIT
metadata:
  author: "Soft Factory maintainers"
  spec_version: "1.0"
  framework_revision: "1.0.0"
  last_updated: "2026-06-11"
---

# Harness CLI IT

Harness CLI IT is a workflow skill for agents that need to create, update, repair, or verify a repo-local engineering harness. The skill standardizes `./harness` as the supported operating surface for humans and agents while preserving existing project commands and recording any inference gaps as friction.

## References

1. [00 Engineering Harness Workflow](references/00-engineering-harness-workflow.md)

## Skill layout

- `SKILL.md` - this file (skill entrypoint).
- `references/` - normative specification documents.
  - `00-engineering-harness-workflow.md` - harness creation, command wrapping, evidence, friction, and adoption rules.
- `processes/` - executable APS process documents.
  - `create-engineering-harness.md` - end-to-end harness creation and verification workflow.
- `assets/` - reusable constants and format contracts.
  - `constants/` - optional constant blocks.
  - `formats/` - optional format contracts.
- `guides/` - optional prose guides.
- `scripts/` - optional build, compile, or lint scripts.
