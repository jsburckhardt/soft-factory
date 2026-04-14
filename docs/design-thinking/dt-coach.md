# DT Coach Guide

> Adapted from [microsoft/hve-core](https://github.com/microsoft/hve-core) — guide to using the DT Coach agent for Design Thinking sessions in soft-factory.

## What Is the DT Coach?

The DT Coach is a specialized agent (`dt-coach`) that guides teams through the nine-method Design Thinking framework. It acts as a **thinking partner**, not a solution provider — helping you discover the right problem and validate your approach before entering the RPIV pipeline.

The DT Coach agent file is located at `.github/agents/dt-coach.agent.md`.

## When to Use the DT Coach

Start a DT Coach session when:

1. **You have a vague problem** — stakeholders say things like "we need to modernize" or "the system is slow" but can't articulate specific user needs.
2. **Stakeholders disagree** — different teams have conflicting priorities or success criteria for the same initiative.
3. **You're entering a new domain** — the team is working in an unfamiliar industry, user base, or problem space.
4. **User adoption is the real risk** — the technical solution might work but users may not use it. Adoption depends on understanding workflows.
5. **A previous implementation failed** — something was built but didn't achieve its goals, and you need to understand why before trying again.

## What the DT Coach Does

The DT Coach provides five core capabilities:

1. **Method guidance** — walks you through each of the nine methods with context-appropriate questions and prompts.
2. **Progress tracking** — maintains session state so you can pause and resume across multiple sessions.
3. **Fidelity enforcement** — ensures your work matches the appropriate fidelity for each space (rough in Problem, scrappy in Solution, rigorous in Validation).
4. **Assumption surfacing** — actively helps you identify and challenge hidden assumptions throughout the process.
5. **Handoff preparation** — produces structured handoff artifacts with confidence markers when you're ready to exit to the RPIV pipeline.

## Think / Speak / Empower Philosophy

The DT Coach follows a three-part coaching philosophy:

### Think (Internal Reasoning)

Before responding, the coach considers:
- What method is the team currently in?
- What have they already discovered?
- What assumptions are they making?
- Where are the gaps in their understanding?
- What question would help them discover the answer themselves?

### Speak (Communication Style)

The coach communicates as a **colleague**, not an authority:
- Uses questions more than statements
- Offers observations, not judgments
- Presents options, not prescriptions
- Acknowledges uncertainty openly
- Matches the team's domain language

### Empower (Outcome Orientation)

The coach empowers the team to own their decisions:
- Provides choices rather than directives
- Explains the reasoning behind suggested approaches
- Celebrates discoveries and insights
- Never takes credit for the team's conclusions
- Ensures the team can continue without the coach

## Output Artifacts and Paths

The DT Coach produces two types of artifacts, stored per [ADR-0003](../architecture/ADR/ADR-0003-dt-artifact-storage.md):

| Artifact | Path | Committed? | Purpose |
|----------|------|------------|---------|
| Session state | `.copilot-tracking/dt/<WI-ID>/coaching-state.md` | No (gitignored) | Tracks current method, progress, and scratchpad notes |
| Handoff artifact | `docs/workitems/<WI-ID>/artifacts/dt-handoff.md` | Yes | Structured findings with confidence markers for the Research agent |

The handoff artifact includes [confidence markers](../architecture/core-components/CORE-COMPONENT-0002-confidence-markers.md) on every finding:
- `validated` — confirmed through multi-source evidence
- `assumed` — believed true but not independently verified
- `unknown` — identified gap requiring investigation
- `conflicting` — evidence points in different directions

## How to Use the DT Coach

### Starting a Session

1. Invoke the `dt-coach` agent with your workitem context.
2. The coach creates a session state file at `.copilot-tracking/dt/<WI-ID>/coaching-state.md`.
3. The coach begins with **Method 1: Scope Conversations** — asking about stakeholders, problem boundaries, and initial understanding.

### Navigating Methods

- The coach guides you through methods sequentially (M1 → M2 → M3 → …), but the process is **not strictly linear**.
- You can revisit earlier methods when new information invalidates previous conclusions.
- At each method boundary, the coach summarizes findings and asks whether to continue or exit to the RPIV pipeline.

### Pausing and Resuming

- To pause a session, simply end the conversation. The coach saves progress in the session state file.
- To resume, invoke the `dt-coach` agent again with the same workitem. The coach reads the session state and picks up where you left off.

### Exiting to the RPIV Pipeline

When you reach an exit point (after Method 3, 6, or 9), the coach:
1. Summarizes all findings with confidence markers.
2. Writes the handoff artifact to `docs/workitems/<WI-ID>/artifacts/dt-handoff.md`.
3. Recommends handing off to the `research` agent with specific scope guidance.

See [Tutorial: Handoff to RPIV](tutorial-handoff-to-rpiv.md) for a step-by-step walkthrough.

## Progressive Hint Engine

The DT Coach uses a four-level escalation approach when teams get stuck:

| Level | Approach | Example |
|-------|----------|---------|
| **Level 1: Open question** | Broad, exploratory question | "What do you think the users' biggest frustration is?" |
| **Level 2: Directed question** | Narrower question pointing toward a specific area | "Have you considered how the night-shift operators experience this differently from day shift?" |
| **Level 3: Observation** | Share a pattern or insight from the session | "I notice that three of the five stakeholders mentioned data latency but none mentioned data accuracy — is accuracy a solved problem or an unexamined assumption?" |
| **Level 4: Suggestion** | Offer a concrete action (still as a choice, not a directive) | "One option would be to run a 30-minute observation session on the factory floor. Another would be to interview the shift supervisor. Which feels more useful right now?" |

The coach always starts at Level 1 and only escalates when the team needs more structure. The goal is always to help the team discover answers themselves.

## Example Interaction

**Scenario:** A manufacturing company wants to "modernize their production monitoring system."

> **Coach (M1):** "Let's start by mapping who's affected by this system. Who are the stakeholders — not just the people requesting the change, but the people who use the current system daily?"
>
> **Team:** "The plant manager wants it, IT maintains it, and the line operators use it."
>
> **Coach (M1):** "That's three groups with potentially different needs. What does 'modernize' mean to each of them?"
>
> **Team:** "Good question — we actually haven't asked the operators."
>
> **Coach (M1):** "That's a valuable discovery. Before moving on, should we include the operators in scope? Their daily experience might reveal problems that the plant manager and IT don't see."
>
> *[Session continues through Method 2: Observations & Interviews, where the team discovers that operators don't want a new dashboard — they want fewer false alarms from the current system.]*
>
> **Coach (M3):** "Based on what you've learned, the problem isn't 'outdated monitoring system' — it's 'excessive false alarms causing operator alert fatigue.' Would you like to frame it this way and exit to the Research agent, or continue into the Solution Space?"

## Tips and Common Pitfalls

### Tips

- **Start with stakeholders, not solutions.** Method 1 exists for a reason — don't skip it.
- **Embrace rough fidelity in Problem Space.** Sticky notes and conversation summaries are the right artifact here. Don't write detailed specs.
- **Exit when you have enough.** Not every workitem needs all nine methods. Exit 1 (after Problem Space) is often sufficient.
- **Bring real users.** Methods 2, 6, and 8 are dramatically more effective with actual users rather than proxies.

### Common Pitfalls

- **Jumping to solutions** — The most common mistake. If you're designing screens in Method 1, you've skipped ahead. The coach will redirect you.
- **Over-investing in Problem Space** — Some teams research forever. If your problem statement is clear and stakeholders agree, exit and start building.
- **Ignoring `conflicting` markers** — Conflicting evidence means there's a real disagreement that must be resolved before implementation. Don't paper over it.
- **Treating DT as a checkbox** — DT is a discovery process, not a compliance process. If you're going through the motions without genuine curiosity, the output won't help.

## Related Documents

- [Design Thinking Guide](README.md) — Overview of the three-space, nine-method framework
- [DT-RPIV Integration](dt-rpiv-integration.md) — How DT feeds into the RPIV pipeline
- [Tutorial: Handoff to RPIV](tutorial-handoff-to-rpiv.md) — Step-by-step handoff walkthrough
- [DT-RPIV Mapping](dt-rpiv-mapping.md) — Terminology and contract reference

---

*Adapted from [microsoft/hve-core](https://github.com/microsoft/hve-core) Design Thinking framework. See [ADR-0002](../architecture/ADR/ADR-0002-adopt-hve-design-thinking.md) for the adoption decision.*
