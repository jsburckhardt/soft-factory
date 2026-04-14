# CORE-COMPONENT-0002: Confidence Markers

## Status

Active

## Purpose

Every research finding, DT handoff claim, and architectural assumption in the RPIV pipeline carries an implicit confidence level. Making that confidence explicit through a standardized marker schema allows downstream agents (planner, implementer, verifier) to calibrate their work appropriately — treating validated facts differently from unverified assumptions or conflicting evidence.

Without explicit markers, agents either over-invest in re-validating reliable information or under-invest in resolving genuine unknowns. Confidence markers solve this by creating a shared vocabulary for epistemic status across all pipeline stages.

## Scope

This component affects:

- **Research agent** — must tag findings in `00-research.md` with confidence markers.
- **DT Coach agent** — must tag handoff artifact claims with confidence markers.
- **Planner agent** — must escalate `conflicting` items before creating dependent tasks; must note `unknown` items in task acceptance criteria.
- **Implementer agent** — must flag `unknown` items in implementation notes; must not treat `assumed` claims as ground truth without verification.
- **Verifier agent** — must check that `conflicting` items have been resolved before approving a PR.

Boundaries:

- Confidence markers apply to **factual claims** in research briefs and DT handoff artifacts. They do not apply to code, test assertions, or architectural decisions (which have their own status fields).
- Markers are metadata on claims, not a scoring system — there is no numeric confidence percentage.

## Definition

### Rules

- Every factual claim in a `00-research.md` brief that is not directly verifiable from source code or existing documentation MUST carry one of the four confidence markers: `validated`, `assumed`, `unknown`, or `conflicting`.
- Every factual claim in a `dt-handoff.md` artifact MUST carry a confidence marker.
- The `planner` agent MUST escalate `conflicting` items before creating tasks that depend on them. Escalation means either resolving the conflict within the research brief or returning to the Research stage.
- The `implementer` agent MUST flag `unknown` items in implementation notes and MUST NOT proceed with implementation that depends on unresolved `unknown` items without documenting the risk.
- The `verifier` agent MUST check that no `conflicting` items remain unresolved in the workitem's research brief or DT handoff artifact before approving the PR.
- Returning to a prior pipeline stage is the correct response when a `conflicting` item cannot be resolved — this is designed behavior, not failure.

### Interfaces

- **Marker schema:**

  | Marker | Meaning | Downstream Treatment |
  |--------|---------|---------------------|
  | `validated` | Confirmed through multi-source evidence or direct verification | Treat as reliable; no re-investigation needed |
  | `assumed` | Believed true but not independently verified | Verification target — should be confirmed during implementation or testing |
  | `unknown` | Identified gap that has not yet been investigated | Primary research or investigation target; must be resolved before dependent work proceeds |
  | `conflicting` | Evidence from multiple sources points in different directions | Must be resolved before proceeding; escalation to prior stage is appropriate |

- **Inline syntax for research briefs and handoff artifacts:**

  ```markdown
  - The API supports batch operations `[validated]` — confirmed via API documentation v2.3.
  - Rate limits are 1000 req/min `[assumed]` — based on free-tier defaults, not confirmed for enterprise.
  - WebSocket support status `[unknown]` — not mentioned in available documentation.
  - Cache invalidation strategy `[conflicting]` — API docs say TTL-based, support forum says event-driven.
  ```

- **Table syntax for structured sections (e.g., Risks & Unknowns):**

  ```markdown
  | Item | Confidence | Notes |
  |------|------------|-------|
  | API batch support | `validated` | Confirmed via API docs v2.3 |
  | Rate limits | `assumed` | Free-tier defaults; enterprise TBD |
  ```

### Expectations

- Confidence markers are **additive** — they do not change the structure of existing research briefs, only annotate factual claims within them.
- Backward compatibility: existing research briefs without markers are treated as having implicit `assumed` confidence on all claims. New research briefs SHOULD use explicit markers.
- The marker schema is closed: only `validated`, `assumed`, `unknown`, and `conflicting` are valid markers. Custom markers are not permitted.
- Markers may change over time — an `unknown` item may become `validated` after investigation, or an `assumed` item may become `conflicting` when contradictory evidence is found.

## Rationale

The confidence marker schema originated in the HVE Design Thinking framework (microsoft/hve-core) where it was used to tag DT handoff artifacts. However, the concept of epistemic confidence applies universally to any research output. By extracting it as a core-component rather than keeping it DT-specific, soft-factory gains a cross-cutting quality standard that improves every research brief — whether or not DT was used upstream.

Alternatives considered:

- **Numeric confidence scores (0–100%)**: Rejected because numeric precision implies false accuracy. A claim is not "73% confident" — it either has evidence, lacks evidence, or has conflicting evidence.
- **Binary (verified/unverified)**: Rejected because it loses the distinction between "not yet investigated" (`unknown`) and "investigated but contradictory" (`conflicting`), which require very different downstream responses.
- **Free-text confidence notes**: Rejected because unstructured text cannot be parsed by agents for automated escalation or verification checks.

## Usage Examples

```markdown
# Research Brief: Payment Gateway Integration

## Findings

- Stripe supports idempotent requests via `Idempotency-Key` header `[validated]` — confirmed in Stripe API docs.
- PayPal's batch payout API has a 500-item limit `[assumed]` — based on community reports, not official docs.
- Square's webhook retry behavior `[unknown]` — not documented; requires empirical testing.
- PCI compliance scope for tokenized vs. raw card data `[conflicting]` — Stripe docs say SAQ-A, PCI Council guidance suggests SAQ A-EP for JavaScript-based tokenization.

## Risks & Unknowns

| Risk | Confidence | Mitigation |
|------|------------|------------|
| PayPal batch limit may be lower in sandbox | `assumed` | Test in sandbox during implementation |
| Square webhook retries may cause duplicate processing | `unknown` | Add idempotency layer before integration |
| PCI scope determination | `conflicting` | Escalate to compliance team before implementation proceeds |
```

## Integration Guidelines

- **Research agent**: When writing `00-research.md`, tag every factual claim that is not directly verifiable from source code or committed documentation. Use inline syntax `[marker]` for prose and table syntax for structured sections.
- **DT Coach agent**: When writing `dt-handoff.md`, tag every finding and recommendation with its confidence marker. DT-originated markers carry forward into the Research stage.
- **Planner agent**: When reading research briefs, scan for `[conflicting]` markers. If any exist on items that block task creation, escalate before proceeding. Include `[unknown]` items in task acceptance criteria as verification requirements.
- **Implementer agent**: When reading task descriptions, check for inherited `[unknown]` or `[assumed]` markers. Flag these in implementation notes. If implementation depends on an `[unknown]` item, document the risk and consider requesting a return to Research.
- **Verifier agent**: Before approving a PR, verify that no `[conflicting]` items from the research brief remain unresolved. Check that `[unknown]` items referenced in tasks have been either resolved or explicitly documented as accepted risks.

## Exceptions

- **Trivially verifiable claims** (e.g., "The repository uses TypeScript" when `tsconfig.json` exists) do not require markers — they are directly verifiable from source code.
- **Architectural decisions in ADRs** do not use confidence markers — ADRs have their own status field (Proposed/Accepted/Deprecated/Superseded).
- **Existing research briefs** created before this core-component are not retroactively required to add markers, but SHOULD be updated if they are referenced by active workitems.

## Enforcement

- [x] Code review checklist — reviewers verify that research briefs and DT handoff artifacts include appropriate confidence markers.
- [x] Automated checks — grep-based validation that `00-research.md` files contain at least one confidence marker (prevents unmarked briefs from being committed).
- [x] Agent guardrails — the planner agent's instructions include a check for unresolved `[conflicting]` items before task creation.

## Related ADRs

- [ADR-0002: Adopt HVE Design Thinking](../ADR/ADR-0002-adopt-hve-design-thinking.md)
