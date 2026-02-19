# Soft Factory

A structured, agent-driven template for turning ideas into production-ready code through a staged vibe-engineering pipeline.

## Overview

Soft Factory enforces a four-stage, guardrailed workflow that makes every decision traceable and every artifact discoverable:

| Stage | Purpose | Key Output |
|-------|---------|------------|
| **1. Research** | Explore the problem space, classify scope | Research Brief |
| **2. Architect** | Commit architectural decisions | ADRs, Core-Components, Action Plan |
| **3. Plan** | Break work into executable tasks | Task Breakdown, Test Plan |
| **4. Implement** | Execute tasks with verification | Code, Tests, Implementation Notes |

## Repository Structure

```
/
  agents.md                          # Agent definitions & guardrails
  CONTRIBUTING.md                    # How to contribute
  LLM.txt                           # Model-facing operational guide
  README.md                         # This file
  docs/
    README.md                        # Docs overview
    application/
      README.md                      # Application-specific docs
    architecture/
      README.md                      # Architecture overview
      ADR/
        DECISION-LOG.md              # Decision log (ADRs + Core-Components)
        ADR-0001-template.md         # ADR template (do not edit directly)
      core-components/
        README.md                    # Active Core-Components
        CORE-COMPONENT-0001-template.md  # Core-Component template (do not edit)
    workitems/
      README.md                      # Workitems overview
      WI-####-slug/
        README.md
        research/
          00-research.md
        plan/
          01-action-plan.md
          02-task-breakdown.md
          03-test-plan.md
        implementation/
          README.md
        artifacts/
          README.md
```

## Key Concepts

### Workitems
Feature- or delivery-scoped work. Each workitem follows the full pipeline and lives under `docs/workitems/WI-####-slug/`.

### ADRs (Architecture Decision Records)
Global architectural decisions. They live under `docs/architecture/ADR/` and are tracked in `docs/architecture/ADR/DECISION-LOG.md`.

### Core-Components
Global, reusable, cross-cutting behavioral definitions. They live under `docs/architecture/core-components/` and are tracked in `docs/architecture/ADR/DECISION-LOG.md`.

### Scope Classification
Every research output must declare exactly one `scope_type`:
- `workitem` — feature or delivery work
- `architecture_decision` — a global architectural decision
- `core_component` — a reusable cross-cutting concern

## Getting Started

1. Use this repository as a template
2. Read [`CONTRIBUTING.md`](CONTRIBUTING.md) for the full workflow
3. Read [`agents.md`](agents.md) for agent definitions
4. Start your first workitem under `docs/workitems/`

## Agents

This template defines four agents that drive the pipeline. See [`agents.md`](agents.md) for full details:

1. **Research Agent** — classifies scope and produces research briefs
2. **ADR Agent** — creates ADRs and core-components, updates the decision registry
3. **Planner Agent** — produces task breakdowns and test plans
4. **Implementer Agent** — executes tasks within architectural boundaries
