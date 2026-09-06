# Foreman local workspace

Foreman stores long-lived repository context in `context/vision.md`,
`context/repository.md`, `context/architecture.md`, and `context/constraints.md`.
Each entry records sources, observed commit/date, unresolved questions, and
refresh triggers.

`mission.json` holds the active mission and work graph. `registry.json` holds
worker reservations. `inbox/` holds typed commands; `.lock` serializes local
control-plane mutations. These files are local and Git-ignored, not committed
backlog substitutes. Retain this directory when resuming a mission.

See [the operator guide](../docs/foreman.md) for schemas, commands, lifecycle,
and the distinction between Foreman and RPIV.
