# 00 Bootstrap Workflow

This reference defines the required behavior for bootstrapping a new project from the Soft Factory template.

## Scope

The skill MUST check whether the project has already been bootstrapped.

The skill MUST refuse to run when bootstrap evidence already exists.

The skill MUST read existing documentation under `docs/` and `project/` before making changes.

The skill MUST read the ADR and core-component templates before creating architecture artifacts.

The skill MUST load `.github/skills/templates/artifact-contract.md` before deriving artifact paths.

The skill MUST load `.github/skills/templates/adr.md` before creating ADR content.

The skill MUST load `.github/skills/templates/core-component.md` before creating core-component content.

The skill MUST load `.github/skills/templates/decision-log.md` before updating the decision log.

The skill MUST gather project name, description, goal, tech stack, verification commands, and cross-cutting concerns from the user.

The skill MUST NOT skip user confirmation before writing files.

## Required behavior

The skill MUST scaffold the project using the selected tech stack's init command.

The skill MUST create a tech stack ADR using the ADR template.

The skill MUST create core-components for declared cross-cutting concerns.

The skill MUST create a development standards core-component.

The skill MUST update `project/architecture/ADR/DECISION-LOG.md` for all ADRs and core-components.

The skill MUST configure verification commands in `.github/soft-factory/verification.yml`.

The skill MUST update `README.md`, `docs/README.md`, `AGENTS.md`, `LLM.txt`, and `.devcontainer/devcontainer.json` as needed.

The skill MUST NOT set up CI/CD pipelines or infrastructure.

The skill MUST NOT make feature-level decisions.

## Success and error outcomes

Success means the project is scaffolded, foundational documentation is seeded, verification config exists, and updated files are summarized.

Error outcomes MUST identify existing bootstrap evidence, missing user confirmation, failed scaffolding, or invalid architecture artifact updates.
