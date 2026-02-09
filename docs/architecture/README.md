# Architecture

This directory contains all architectural documentation for the project.

## Structure

| Directory | Purpose |
|-----------|---------|
| `decisions/` | ADR template, active ADRs, and the decision log (`DECISION-LOG.md`). |
| `core-components/` | Core-component template and active core-component definitions |

## Key Concepts

### ADRs (Architecture Decision Records)
ADRs capture significant architectural decisions. They are **global** — not scoped to any single initiative. Every ADR must be recorded in `decisions/DECISION-LOG.md`.

### Core-Components
Core-components define reusable, cross-cutting behavioral contracts. They are **global** and shared across all initiatives. Every core-component must be recorded in `decisions/DECISION-LOG.md`.

### Templates
Templates are read-only references — copy and rename them, don't edit them directly:
- `decisions/ADR-0001-template.md` — copy within `decisions/` to create a new ADR
- `core-components/CORE-COMPONENT-0001-template.md` — copy within `core-components/` to create a new core-component
