# Test plan: #42

| Validation | AC IDs | Method | Passing evidence |
|------------|--------|--------|------------------|
| V-1: Contracts | AC-1, AC-2, AC-3, AC-4, AC-5, AC-6, AC-9 | Inspect the exact modified Foreman and RPIV agent paths and the schema; require matching reservation/digest/issue on launch and resume, valid event/status mappings, APS placeholders <=64 characters and uppercase `SET` targets | Agent lines and schema fields on the final committed head |
| V-2: Host guards | AC-7, AC-8 | `just verify-focused` executes inert launch, worktree-ownership, controller-window, and integrated-base rejection checks; inspect the root justfile's base-checkout operation | Test runner success, rejected foreign paths, wrong branch, dirty checkout, and live retirement |
| V-3: Full verification and documentation | AC-8, AC-9, AC-10 | `just verify` plus independent comparison of README, Foreman guide, ADR, core-components, decision log, and work-item artifacts with committed behavior | Full recipe exit success, clean tree, exact branch/head, accurate documents |

Foreman integration verification in a future configured consumer must operate
on the integrated base after its own delivery evidence; the current template
cannot validate a live mission. Tests must not launch a Copilot worker or
claim automatic acceptance from a stubbed host.
