# Project

This directory contains all project management documentation organized by category.

## Structure

| Directory | Purpose |
|-----------|---------|
| `architecture/` | Architectural decisions, core-components, and templates |
| `work-items/` | Human-readable RPIV work-item artifacts (research briefs, plans, implementation notes) |

Foreman keeps long-lived strategic context and its local mission/worker ledger
in [`.foreman/`](../.foreman/README.md), outside bounded issue artifacts.
Architectural decisions and shared contracts remain global under `architecture/`.

## Conventions

- Each work-item folder uses `<issue-number>-<short-description>` (for example, `work-items/42-improve-cache-invalidation/`)
- Research derives the short description from the GitHub Issue title when creating the folder; later stages preserve that path
- ADRs and core-components are global and live under `architecture/`
- Templates are read-only references — copy and rename them, don't edit them directly
