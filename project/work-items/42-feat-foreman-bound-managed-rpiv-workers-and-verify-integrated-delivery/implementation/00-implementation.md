# Implementation evidence: #42

**Branch:** `feat/42-foreman-rpiv-tmux`
**Original feature commit:** `bdced3a8e248ba9314db33552dee6659b9558fab`
**Review correction:** Same branch and PR #43. The original feature commit
predates issue #42; this note does not misrepresent its delivery chronology.

## Task evidence

| Task | Result | Concrete evidence |
|------|--------|-------------------|
| T-1 | Complete | Foreman reserves assignment digest before launch and validates event/result schema; RPIV validates GitHub criteria, reserved identity, assignment bytes, and status-event pairings on launch/resume. APS agent placeholders and `SET` targets are checked by the focused contract test. |
| T-2 | Complete | `integration-sync` guards the clean configured base checkout before fast-forward; `tmux-worker-launch` checks the exact root-owned Git worktree/common directory. Inert checks reject wrong branch, dirty checkout, foreign path, unrelated Git common directory, duplicate window, and live retirement. |
| T-3 | Complete | Foreman guide, orchestration/observability core-components, decision log, and issue work-item describe the updated behavior. `tests/foreman-contract.sh` exercises host commands without starting a worker. |

## Acceptance evidence

| AC IDs | Evidence |
|--------|----------|
| AC-1, AC-2 | Versioned assignment, persisted SHA-256 reservation, launch/resume GitHub issue and registry checks, acknowledged pause and new revision requirement |
| AC-3 | Typed `evidence.worker_result` JSON Schema, event/status/issue validation and completion per-AC evidence rule |
| AC-4 | Foreman's stable-head review and changed-path scope guards |
| AC-5 | Correlated file commands, replay guard, answered `PROGRESS` versus unanswered `NEEDS_DECISION` |
| AC-6 | Graph/capacity/reservation predicates and missing-window reconciliation |
| AC-7 | Owned `integration-checkout`, exact-base SHA comparison, `just verify` and mission-condition evidence gate |
| AC-8 | Root-owned tmux controller/worker commands and inert foreign-path, duplicate-window, live-retire checks |
| AC-9 | Durable reservation on loss/pause and Foreman-only dependency disposition |
| AC-10 | `just verify-focused` and `just verify` on the template checkout; no live fleet claimed |

## Validation and documentation

- Focused verification: `just verify-focused` passed after the host and APS
  corrections. Full verification is rerun before the Verify handoff.
- Application documentation: no application or API exists in this template,
  so no application usage/API/migration/deployment docs are affected. The
  relevant template usage (`docs/foreman.md`), architecture contracts, and
  decision log are updated. The README's general opt-in and verification
  description remains accurate.
- Live integration verification cannot be claimed for this unconfigured
  template; a consuming project must approve its worker profile and base
  checkout before running a mission.
