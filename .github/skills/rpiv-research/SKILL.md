---
name: rpiv-research
description: "Fetch a GitHub issue, explore the problem space, classify scope, and produce a research brief for the Plan stage."
license: MIT
metadata:
  author: "Soft Factory maintainers"
  spec_version: "1.0"
  framework_revision: "1.0.0"
  last_updated: "2026-07-01"
---

# rpiv-research

`rpiv-research` is a workflow skill for agents that need to fetch a GitHub issue, inspect existing repository context, classify the issue scope, and write the research brief that hands off to the Plan stage.

## References

1. [00 Research Workflow](references/00-research-workflow.md)

## Skill layout

- `SKILL.md` - this file (skill entrypoint).
- `references/` - normative workflow reference documents.
  - `00-research-workflow.md` - issue fetching, context gathering, scope classification, and research brief rules.
- `processes/` - executable APS process documents.
  - `research-issue.md` - end-to-end research workflow.
- `../templates/` - shared Soft Factory artifact templates.
  - `artifact-contract.md` - canonical artifact paths and ledger locations.
  - `research-brief.md` - research brief output structure.
