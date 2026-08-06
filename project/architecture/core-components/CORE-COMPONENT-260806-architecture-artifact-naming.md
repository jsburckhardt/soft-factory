# CORE-COMPONENT-260806-architecture-artifact-naming: Architecture Artifact Naming

## Status

Adopted

## Purpose

Define stable, chronological, and collision-safe names for global ADR and core-component artifacts.

## Scope

This contract applies to architecture templates, artifact creation agents, filenames, document headings, references, and the decision log.

## Definition

### Rules
- ADR filenames MUST use `ADR-yymmdd-short-slug.md`.
- Core-component filenames MUST use `CORE-COMPONENT-yymmdd-short-slug.md`.
- `yymmdd` MUST be the artifact's UTC creation date and MUST remain unchanged after later edits.
- The document ID MUST equal the full filename basename, including the date and short slug.
- Multiple artifacts created on the same date MUST use distinct descriptive slugs.
- Agents MUST fail rather than overwrite an existing artifact with the same date and slug.
- Templates MUST use the example date `260101` in their filenames and the `yymmdd-short-slug` placeholder in their contents.
- The decision log MUST reference the full date-and-slug document ID.

### Interfaces
- Bootstrap, Onboard, and RPIV Plan resolve the UTC creation date with `date -u +%y%m%d`.
- Artifact creation combines the resolved date with a lowercase hyphenated short slug.
- Documentation and repository maps reference the date-based template paths.

### Expectations
- Filenames sort chronologically by creation date.
- Same-day artifacts remain uniquely identifiable by their slugs.
- Renaming an artifact updates every repository cross-reference in the same change.

## Rationale

Date-based names remove sequence coordination while preserving chronological discovery. Including the slug in the ID prevents collisions when several artifacts are created on the same day.

## Usage Examples

```text
ADR-270101-service-boundaries.md
CORE-COMPONENT-270101-structured-logging.md
```

## Integration Guidelines

- Use UTC so agents in different environments derive the same date.
- Choose a slug that describes the decision or cross-cutting contract.
- Keep the original date when changing status or content later.

## Exceptions

- None.

## Enforcement

- [x] Automated checks
- [x] Code review checklist
- [ ] Test coverage requirements

## Related ADRs

- None.
