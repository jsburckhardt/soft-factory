# 00 Repository Onboarding Workflow

This reference defines the required behavior for onboarding an existing repository into Soft Factory.

## Scope

The skill MUST check whether the repository already has the Soft Factory engineering flow.

The skill MUST refuse to run when onboarding evidence already exists.

The skill MUST read `README.md` before analyzing the repository.

The skill MUST read existing documentation under `docs/` and `project/`.

The skill MUST scan the source tree to infer tech stack, language, framework, and package manager.

The skill MUST scan the source tree to identify existing cross-cutting concerns.

The skill MUST infer architectural decisions already embedded in the code and document them as ADRs.

The skill MUST load `.github/skills/templates/artifact-contract.md` before deriving artifact paths.

The skill MUST load `.github/skills/templates/adr.md` before creating ADR content.

The skill MUST load `.github/skills/templates/core-component.md` before creating core-component content.

The skill MUST load `.github/skills/templates/decision-log.md` before updating the decision log.

The skill MUST NOT make new feature-level decisions.

## Required behavior

The skill MUST create ADRs starting from `ADR-0002`.

The skill MUST create core-component files starting from `CORE-COMPONENT-0002`.

The skill MUST update `project/architecture/ADR/DECISION-LOG.md` for every ADR and core-component created.

The skill MUST create a GitHub issue titled `Repository Understanding`.

The skill MUST create `project/issues/<ISSUE_NUMBER>/research/00-research.md` for the first issue.

The skill MUST update `README.md`, `AGENTS.md`, and `LLM.txt` with onboarding context.

The skill MUST NOT edit templates directly.

The skill MUST NOT skip user confirmation before writing files.

## Success and error outcomes

Success means discovered architecture is documented, the decision log is updated, a first issue exists, and its research brief is created.

Error outcomes MUST identify existing onboarding evidence, missing repository context, failed issue creation, or invalid architecture artifact updates.
