# Core-Components

This directory contains all active core-component definitions for the project.

## Creating a New Core-Component

1. Copy the template `CORE-COMPONENT-0001-template.md` in this directory
2. Name it `CORE-COMPONENT-####-short-slug.md` (use the next available number)
3. Fill in all sections
4. Update the decision log at `../decisions/DECISION-LOG.md`

## Conventions

- Core-components are **global** — they define reusable, cross-cutting behavior shared across all initiatives
- Core-component IDs are sequential and never reused
- Deprecated core-components are marked as such and link to the replacement
- Every core-component should reference the ADR(s) that motivate it
