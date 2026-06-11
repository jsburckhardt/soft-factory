---
name: pr-review-complement
description: "Complements PR review by updating a branch from origin/main, addressing open review feedback, and resolving fixed review threads."
license: MIT
metadata:
  author: "LoreCast maintainers"
  spec_version: "1.0"
  framework_revision: "1.0.0"
  last_updated: "2026-06-07"
---

# PR Review Complement

PR Review Complement is a workflow skill for coding agents that need to keep a pull request branch current with `origin/main`, inspect open PR review feedback, apply or explain fixes, verify the updated branch, push changes, and mark fixed GitHub review threads as resolved.

## References

1. [00 Review Comment Resolution Workflow](references/00-review-comment-resolution-workflow.md)

## Skill layout

- `SKILL.md` - this file (skill entrypoint).
- `references/` - normative specification documents.
  - `00-review-comment-resolution-workflow.md` - branch sync, feedback handling, verification, and thread resolution rules.
- `processes/` - executable APS process documents.
  - `processes/review-comment-resolution.md` - end-to-end PR review complement workflow.
- `assets/` - reusable constants and format contracts.
  - `constants/` - constant blocks.
  - `formats/` - format contracts.
- `guides/` - optional prose guides.
- `scripts/` - optional build, compile, or lint scripts.
