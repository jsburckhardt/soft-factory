# Task breakdown: #42

**Work item:** `project/work-items/42-feat-foreman-bound-managed-rpiv-workers-and-verify-integrated-delivery/`

| Task | Status | Depends on | Acceptance criteria | Test coverage requirement | Expected evidence | Architecture |
|------|--------|------------|---------------------|---------------------------|-------------------|--------------|
| T-1: Correct bounded assignments, lifecycle results, and APS control flow | Complete | None | AC-1, AC-2, AC-3, AC-4, AC-5, AC-6, AC-9 | V-1: inspect schema and assignment identity/digest checks, event/status invariants, and APS grammar | Agent contracts, typed schema, review-thread dispositions | `ADR-260906-foreman-control-plane`, `CORE-COMPONENT-260906-rpiv-observability`, `CORE-COMPONENT-260906-foreman-orchestration` |
| T-2: Keep checkout and tmux worker ownership tied to the configured base | Complete | T-1 | AC-7, AC-8 | V-2: inert success/rejection for foreign worktree, dirty/wrong-base checkout, duplicate worker, live retirement | Host recipe checks, integrated-base guard | `ADR-260906-foreman-control-plane`, `CORE-COMPONENT-260906-foreman-orchestration` |
| T-3: Synchronize consumer guidance, traceability, and repeatable validation | Complete | T-2 | AC-8, AC-9, AC-10 | V-3: focused/full root justfile verification and independent documentation review | Docs, decision log, stage evidence, validation output | `CORE-COMPONENT-260806-rpiv-stage-contract`, `CORE-COMPONENT-260906-foreman-orchestration` |

Each task requires its referenced ACs to have the stated evidence. An
unconfigured template must not be described as a live integrated worker run.
