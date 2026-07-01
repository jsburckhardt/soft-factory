---
name: excali
description: "Generate Excalidraw diagrams from text descriptions, wireframes, or specifications."
license: MIT
metadata:
  author: "Soft Factory maintainers"
  spec_version: "1.0"
  framework_revision: "1.0.0"
  last_updated: "2026-07-01"
---

# Excali

Excali is a workflow skill for agents that need to generate valid Excalidraw JSON diagrams from natural-language descriptions or existing diagram conventions.

## References

1. [00 Excalidraw Generation Workflow](references/00-excalidraw-generation-workflow.md)

## Skill layout

- `SKILL.md` - this file (skill entrypoint).
- `references/` - normative workflow reference documents.
  - `00-excalidraw-generation-workflow.md` - diagram generation and Excalidraw JSON validity rules.
- `processes/` - executable APS process documents.
  - `generate-excalidraw.md` - end-to-end diagram generation workflow.
