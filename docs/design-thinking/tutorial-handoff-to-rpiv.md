# Tutorial: Handoff from Design Thinking to RPIV

> Adapted from [microsoft/hve-core](https://github.com/microsoft/hve-core) — a step-by-step guide for transitioning from a DT session to the RPIV pipeline.

## Prerequisites

Before handing off from DT to the RPIV pipeline, ensure:

1. **You've completed at least the Problem Space (Methods 1–3).** Exit Point 1 is the minimum viable handoff.
2. **Your findings have confidence markers.** Every claim should be tagged as `validated`, `assumed`, `unknown`, or `conflicting` per [CORE-COMPONENT-0002](../architecture/core-components/CORE-COMPONENT-0002-confidence-markers.md).
3. **Stakeholders have reviewed the problem framing.** At minimum, the problem statement should be agreed upon.
4. **You know your exit point.** Choose Exit 1, 2, or 3 based on how much DT work you've done.

## Choosing Your Exit Point

| Exit Point | After Methods | Best When | Research Scope |
|------------|---------------|-----------|----------------|
| **Exit 1** — Problem Statement Complete | 1–3 | Problem is clear but no solution concepts exist yet | Broad — explore solution approaches, validate needs technically |
| **Exit 2** — Concept Validated | 1–6 | A solution concept has been tested with users | Medium — focus on tested direction, resolve constraint gaps |
| **Exit 3** — Implementation Spec Ready | 1–9 | A functional prototype has been user-tested and spec'd | Narrow — production readiness, scaling, integration concerns |

**Recommendation:** Most workitems exit at Exit Point 1. Only continue to Exit 2 or 3 when the problem complexity warrants it (high stakeholder disagreement, novel domain, critical adoption requirements).

## What the Research Agent Needs

The `research` agent reads the DT handoff artifact at `docs/workitems/<WI-ID>/artifacts/dt-handoff.md` and uses it to scope its work. The handoff must include:

1. **Exit point reached** — so the Research agent knows how much DT work was done.
2. **Findings with confidence markers** — so the Research agent knows what to trust, verify, and investigate.
3. **Scope boundaries** — so the Research agent stays focused.
4. **Unresolved questions** — so the Research agent prioritizes investigation targets.

## Confidence Markers Quick Reference

| Marker | What It Means | What Research Agent Does With It |
|--------|---------------|----------------------------------|
| `validated` | Confirmed through evidence (interviews, testing, etc.) | Carries forward without re-investigation |
| `assumed` | Believed true but not independently verified | Targets for verification during research |
| `unknown` | Gap identified but not investigated | Primary research targets |
| `conflicting` | Contradictory evidence exists | Must resolve before proceeding; may trigger return to DT |

## Walkthrough: Exit Point 1 (Problem Space → Research Agent)

This walkthrough demonstrates the most common handoff — exiting after the Problem Space.

### Scenario

A logistics company wants to "improve their delivery tracking system." After running DT Methods 1–3 with the `dt-coach` agent, the team has discovered:

- The real problem isn't the tracking system — it's that dispatchers and drivers have different views of delivery status, causing miscommunication.
- Dispatchers rely on the dashboard (updated every 5 minutes), but drivers update status via mobile (updated in real-time).
- The 5-minute lag causes dispatchers to call drivers for updates they've already posted.

### Step 1: Review Your DT Findings

Before exiting, review what you've learned across Methods 1–3:

- **Method 1 (Scope Conversations):** Identified three stakeholder groups — dispatchers, drivers, and operations managers.
- **Method 2 (Observations & Interviews):** Observed dispatchers calling drivers 8–12 times per shift for status updates that were already in the system.
- **Method 3 (Problem Framing):** Framed the problem as "dashboard refresh latency causes dispatcher-driver miscommunication, resulting in 8–12 unnecessary calls per shift."

### Step 2: Tag Findings with Confidence Markers

Review each finding and assign a confidence marker:

- Dispatchers rely on dashboard for status tracking `[validated]` — observed directly during ride-along.
- Dashboard refresh rate is 5 minutes `[assumed]` — reported by IT, not independently measured.
- Drivers update status in real-time via mobile `[validated]` — confirmed via driver interviews and app logs.
- Reducing unnecessary calls will improve driver satisfaction `[assumed]` — drivers complained about calls, but satisfaction improvement is projected.
- WebSocket support for real-time dashboard updates `[unknown]` — not investigated technically.
- Operations managers also experience the lag problem `[unknown]` — not included in observations.

### Step 3: Write the Handoff Artifact

The `dt-coach` agent produces the handoff artifact at `docs/workitems/<WI-ID>/artifacts/dt-handoff.md`:

```markdown
# DT Handoff: WI-0042-delivery-tracking

## Exit Point
Exit 1 — Problem Statement Complete (Methods 1–3)

## Problem Statement
Dashboard refresh latency (5-minute polling interval) causes dispatcher-driver
miscommunication, resulting in 8–12 unnecessary status-check calls per shift.

## Findings
- Dispatchers rely on dashboard for delivery status tracking `[validated]`
  — observed directly during 3 ride-along sessions
- Dashboard refresh rate is approximately 5 minutes `[assumed]`
  — reported by IT team, not independently measured
- Drivers update status in real-time via mobile app `[validated]`
  — confirmed via driver interviews (n=6) and app usage logs
- Unnecessary calls average 8–12 per shift per dispatcher `[validated]`
  — counted during 2 observation sessions
- Reducing unnecessary calls will improve driver satisfaction `[assumed]`
  — based on driver complaints, not measured quantitatively
- WebSocket support for real-time updates `[unknown]`
  — technical feasibility not investigated
- Operations manager impact `[unknown]`
  — not included in stakeholder observations

## Scope Boundaries
- In scope: Dispatcher-driver status synchronization mechanism
- In scope: Dashboard refresh mechanism (polling → real-time)
- Out of scope: Mobile app redesign (app works well for drivers)
- Out of scope: Operations manager workflows (separate initiative)

## Unresolved Questions
- What is the actual dashboard refresh rate? `[assumed]` — needs measurement
- Does the existing infrastructure support WebSocket connections? `[unknown]`
- Are there other data synchronization issues beyond status updates? `[unknown]`

## Recommendations for Research Agent
- Validate the 5-minute refresh rate claim by inspecting the dashboard codebase
- Investigate WebSocket/SSE support in the current tech stack
- Assess whether the mobile app's real-time updates can be mirrored to the dashboard
- Consider interviewing operations managers to determine if they're affected
```

### Step 4: Hand Off to the Research Agent

After the handoff artifact is committed, invoke the `research` agent with the workitem. The Research agent will:

1. Read `docs/workitems/WI-0042-delivery-tracking/artifacts/dt-handoff.md`.
2. Note the exit point (Exit 1) and adjust scope accordingly — broad exploration needed.
3. Treat `validated` findings as reliable input.
4. Target `assumed` items (dashboard refresh rate) for verification.
5. Investigate `unknown` items (WebSocket support, operations manager impact).
6. Produce a research brief at `docs/workitems/WI-0042-delivery-tracking/research/00-research.md`.

## Exit Point 2: Concept Validated (Brief)

At Exit Point 2, you've completed Methods 4–6 and have a tested solution concept. The handoff includes everything from Exit 1 plus:

- **Solution concept description** — what was proposed and why.
- **Assumption test results** — which assumptions were validated and which were invalidated.
- **Constraints** — technical, organizational, and user-facing constraints discovered during concept testing.

The Research agent narrows its scope to the validated concept direction and focuses on technical feasibility and constraint resolution.

## Exit Point 3: Implementation Spec Ready (Brief)

At Exit Point 3, you've completed all nine methods and have a functional specification backed by user testing. The handoff includes everything from Exit 2 plus:

- **Functional specification** — detailed implementation requirements.
- **User testing evidence** — structured test results with user feedback.
- **Implementation constraints** — specific technical requirements and non-functional requirements.

The Research agent focuses narrowly on production readiness, scaling, and integration concerns. Most problem and solution questions are already answered.

## When RPIV Returns to DT

Sometimes the `research` agent discovers that DT assumptions need revision. This triggers a return to DT coaching.

### Practical Example

Continuing the delivery tracking scenario:

> The `research` agent investigates the dashboard and discovers that the 5-minute refresh rate is actually a client-side caching issue, not a server-side polling interval. The server supports real-time push via Server-Sent Events (SSE), but the dashboard JavaScript caches responses for 5 minutes due to a performance optimization from 2019.
>
> This changes the problem framing: the issue isn't "polling vs. real-time" — it's "a stale cache configuration." The fix might be as simple as adjusting cache TTL, which reframes the entire scope.
>
> The `research` agent marks the original problem framing as `conflicting` and recommends returning to DT Method 3 (Problem Framing) to reframe the problem with this new technical evidence.

See [DT-RPIV Integration](dt-rpiv-integration.md) for the full return path protocol.

## Quick Reference

| Step | Action | Output |
|------|--------|--------|
| 1 | Complete DT methods through your chosen exit point | DT findings |
| 2 | Tag all findings with confidence markers | Marked findings |
| 3 | Write handoff artifact | `docs/workitems/<WI-ID>/artifacts/dt-handoff.md` |
| 4 | Invoke Research agent | Research brief begins |
| 5 | (If needed) Research returns to DT | Updated handoff artifact |

## Related Documents

- [DT-RPIV Integration](dt-rpiv-integration.md) — Full integration contract
- [DT-RPIV Mapping](dt-rpiv-mapping.md) — Terminology and exit-point contracts
- [DT Coach Guide](dt-coach.md) — How to use the DT Coach agent
- [Design Thinking Guide](README.md) — Framework overview

---

*Adapted from [microsoft/hve-core](https://github.com/microsoft/hve-core) Design Thinking framework. See [ADR-0002](../architecture/ADR/ADR-0002-adopt-hve-design-thinking.md) for the adoption decision.*
