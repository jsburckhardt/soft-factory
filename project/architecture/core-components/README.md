# Core-Components

This directory contains all active core-component definitions for the project.

## Creating a New Core-Component

1. Copy the template `CORE-COMPONENT-260101-template.md` in this directory
2. Name it `CORE-COMPONENT-yymmdd-short-slug.md` using its UTC creation date
3. Fill in all sections
4. Update the decision log at `../ADR/DECISION-LOG.md`

## Conventions

- Core-components are **global** — they define reusable, cross-cutting behavior shared across all issues
- The full date-and-slug filename basename is the core-component ID
- Multiple core-components may share a date when their slugs are distinct
- Creation dates never change after later edits
- Deprecated core-components are marked as such and link to the replacement
- Every core-component should reference the ADR(s) that motivate it
