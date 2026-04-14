# Why Design Thinking?

> Adapted from [microsoft/hve-core](https://github.com/microsoft/hve-core) — understanding when and why to use Design Thinking before entering the RPIV pipeline.

## The Core Problem: Wrong Problem, Not Wrong Code

Most projects don't fail because of bad code. They fail because they solve the **wrong problem**. Teams jump straight into implementation with an incomplete understanding of what users actually need, which stakeholders disagree about, or where the real constraints lie.

Design Thinking (DT) addresses this by providing a structured framework for **discovering the right problem** before investing in a technical solution. It slows you down at the start so you can move faster later — with confidence that you're building the right thing.

## When to Use Design Thinking

DT is an **optional** pre-Research activity in the soft-factory RPIV pipeline. Use it when any of these four trigger conditions are present:

1. **Requirements are unclear** — stakeholders describe solutions ("we need a dashboard") rather than problems ("we can't see which orders are late").
2. **Stakeholder conflict** — multiple stakeholders disagree on priorities, scope, or success criteria.
3. **Cross-boundary problems** — the problem spans organizational boundaries, user roles, or technical systems where no single stakeholder has the full picture.
4. **User adoption is critical** — the success of the solution depends on users changing their behavior, and adoption cannot be assumed.

If even one of these conditions is present, a DT session can significantly improve the quality of input to the RPIV pipeline.

## When to Skip Design Thinking

Not every workitem needs DT. Go straight to the RPIV pipeline (starting with the `research` agent) when:

1. **Requirements are well understood** — the problem and solution are agreed upon by all stakeholders, with clear acceptance criteria.
2. **Purely technical task** — the work is a refactoring, dependency upgrade, bug fix, or other technical task with no user-facing ambiguity.
3. **Prior DT session exists** — a previous DT session already produced a validated handoff artifact that covers this scope. Don't repeat discovery work.

## The Three-Space Model

Design Thinking organizes discovery into three spaces, each with increasing fidelity:

### Problem Space (Methods 1–3) — Rough / Exploratory

The goal is to understand the **real problem** before proposing solutions. Work is deliberately rough — sketches, sticky notes, conversation summaries. Fidelity is low because you're exploring.

- **Method 1: Scope Conversations** — Map the stakeholder landscape and establish problem boundaries.
- **Method 2: Observations & Interviews** — Gather user needs, pain points, and contextual insights directly from users.
- **Method 3: Problem Framing** — Synthesize observations into a validated problem statement and "How Might We" questions.

### Solution Space (Methods 4–6) — Scrappy / Concept-grade

The goal is to generate and test **solution concepts** with minimal investment. Work is scrappy — paper prototypes, concept sketches, assumption lists. You're testing ideas, not building products.

- **Method 4: Concept Generation** — Generate multiple solution concepts. Quantity over quality.
- **Method 5: Assumption Mapping** — Identify and prioritize the riskiest assumptions behind each concept.
- **Method 6: Concept Testing** — Test concepts against real user feedback. Validate or invalidate assumptions.

### Validation Space (Methods 7–9) — Functionally Rigorous

The goal is to validate that the chosen solution **works for real users** in realistic conditions. Work is functionally rigorous — working prototypes, structured user tests, implementation specifications.

- **Method 7: Prototype Building** — Build functional prototypes sufficient for user testing.
- **Method 8: User Testing** — Conduct structured tests with real users. Gather evidence.
- **Method 9: Implementation Spec** — Produce a functional specification backed by test evidence.

## DT vs. Traditional Requirements Gathering

| Aspect | Traditional Requirements | Design Thinking |
|--------|--------------------------|-----------------|
| Starting point | Solution assumptions | Problem discovery |
| Stakeholder input | Requirements document (often written by one person) | Multi-stakeholder conversations and observations |
| User involvement | End of process (UAT) | Throughout (interviews, concept testing, user testing) |
| Fidelity progression | High fidelity from the start | Rough → Scrappy → Rigorous |
| Failure mode | "We built what was specified" (but nobody wanted it) | "We built what users validated" |
| Output to RPIV | Requirements spec → Research agent | Confidence-marked findings → Research agent |
| Iteration | Costly change requests | Built-in: revisit earlier spaces as needed |

## Relationship with the RPIV Pipeline

Design Thinking is **upstream** of the RPIV pipeline — it feeds into it but never replaces it. The four mandatory RPIV stages (Research → Plan → Implement → Verify) remain unchanged.

```
[DT Coach] → [Research Agent] → [Planner Agent] → [Implementer Agent] → [Verifier Agent]
  (optional)    (mandatory)        (mandatory)        (mandatory)           (mandatory)
```

- **All DT exits go to the Research agent.** Whether you exit after Problem Space (Exit 1), Solution Space (Exit 2), or Validation Space (Exit 3), the handoff always goes to the `research` agent.
- **The Research agent adjusts its scope** based on how much DT work was done. A validated problem statement (Exit 1) means broader research; a functional spec (Exit 3) means narrowly-scoped research.
- **RPIV can return to DT** when the `research` agent discovers that fundamental assumptions need revision.

See [DT-RPIV Integration](dt-rpiv-integration.md) for the full contract.

## Industry Applicability

Design Thinking is not limited to software. The three-space model applies to any domain where you're solving problems for people:

- **Manufacturing** — understanding production line inefficiencies before designing automation
- **Healthcare** — discovering clinician workflows before building clinical decision support
- **Education** — understanding student learning patterns before designing courseware
- **Internal tools** — discovering what operations teams actually need vs. what they say they need
- **Platform APIs** — understanding developer experience before designing API surfaces

The `dt-coach` agent adapts the framework to your specific domain during a coaching session.

## Next Steps

- Understand [how the DT Coach works](dt-coach.md) and how to run a session.
- Review the [DT-RPIV Integration Contract](dt-rpiv-integration.md) to see how DT feeds into the pipeline.
- Return to the [Design Thinking Guide](README.md) for the full method overview.

---

*Adapted from [microsoft/hve-core](https://github.com/microsoft/hve-core) Design Thinking framework. See [ADR-0002](../architecture/ADR/ADR-0002-adopt-hve-design-thinking.md) for the adoption decision.*
