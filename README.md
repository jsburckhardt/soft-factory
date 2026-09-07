# Project Name

<!-- Replace with a short description of your project. -->
[![APS version](https://img.shields.io/badge/APS-v1.2.2-blue?logo=github)](https://github.com/chris-buckley/agnostic-prompt-standard/releases/tag/v1.2.2)

## Engineering workflow

This repository is a **template**, not a Foreman application. Start a new
project with `bootstrap`, or use `onboard-repo` to discover an existing project's
stack and commands. Those agents record the project's capabilities and can
configure thin worker-operation recipes when explicitly requested. Foreman
does not impose Python or another implementation language.

**Foreman owns the mission; RPIV delivers one issue.** Give the `foreman` agent a
PRD or product direction to build and maintain a dependency graph of GitHub
issues, retain repository context, and schedule isolated RPIV workers within a
configured capacity when that project has enabled worker execution.

```text
Product direction -> Foreman -> issue dependency graph
                          -> tmux session: foreman
                             foreman | rpiv-21 | rpiv-22
                                        |         |
                                  .trees/issue-21  .trees/issue-22
                                        |         |
                                  Copilot CLI + RPIV
                                  Research -> Plan -> Implement -> Verify
```

Foreman is optional: use `rpiv` directly for a single issue. Each worker exposes
structured state/events; a delivered PR is not treated as merged integration.
The template ships no scheduler runtime and does not start workers or enable
`--yolo` automatically. Mission context can be maintained before execution is
configured; standalone RPIV remains available.
See [Foreman usage and operations](docs/foreman.md) for setup, graph format,
permission modes, start/resume/pause, and worker communication.

## Documentation

- [`CONTRIBUTING.md`](CONTRIBUTING.md) — pipeline workflow, how to contribute via GitHub Issues, and where artifacts belong
- [`AGENTS.md`](AGENTS.md) — agent definitions, guardrails, and pipeline specification
- [`docs/`](docs/) — application-specific documentation (API docs, user guides, etc.)
- [`project/`](project/) — architecture decisions, core-components, and human-readable work-item artifacts
- [`.github/agents/foreman.agent.md`](.github/agents/foreman.agent.md) — APS mission coordinator for Copilot CLI
