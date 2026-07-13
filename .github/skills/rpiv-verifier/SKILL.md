---
name: rpiv-verifier
description: "Run verification, validate acceptance criteria, create commits, push a branch, and open a pull request."
license: MIT
metadata:
  author: "Soft Factory maintainers"
  spec_version: "1.0"
  framework_revision: "1.0.0"
  last_updated: "2026-07-01"
---

# rpiv-verifier

`rpiv-verifier` is a workflow skill for agents that need to validate completed work, ship it through git and GitHub, and record a reviewable delivery summary.

## References

1. [00 Verification Workflow](references/00-verification-workflow.md)

## Skill layout

- `SKILL.md` - this file (skill entrypoint).
- `references/` - normative workflow reference documents.
  - `00-verification-workflow.md` - verification, acceptance criteria, git, PR, and summary rules.
- `processes/` - executable APS process documents.
  - `verify-delivery.md` - end-to-end verification and shipping workflow.
- `../templates/` - shared Soft Factory artifact templates.
  - `artifact-contract.md` - canonical artifact paths and ledger locations.
  - `verify-summary.md` - verify summary output structure.
