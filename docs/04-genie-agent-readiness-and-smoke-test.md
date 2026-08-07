# Genie Agent Readiness & Smoke Test

## Objective

This phase checks whether the Wanderbricks Genie Agent is ready for formal benchmarking.

The goal is not to score the product yet. It is to confirm that the Agent is connected to the right data, understands the main business definitions, and can answer basic questions without obvious setup failures.

> **Phase goal:** remove configuration issues before the benchmark so the evaluation measures product behavior rather than avoidable setup mistakes.

---

## 1. Configuration strategy

The Agent was configured around three curated analysis views:

| View | Role |
| --- | --- |
| `booking_analysis` | Current booking status, dates, booking value, property, destination, and country |
| `payment_analysis` | Payment attempts and completed payment amounts |
| `review_analysis` | Active reviews, ratings, property, destination, and country |

Using a small set of prepared views reduces ambiguity and avoids exposing the Agent to unnecessary joins or stale booking-status logic.

### Why this matters

The dashboard baseline and Genie should use the same underlying data rules.

This keeps the comparison fair and makes it easier to identify whether a difference comes from the **product experience** or from the **data preparation**.

---

## 2. Business guardrails added

The Agent was given the main definitions established during the data-readiness phase.

Key guardrails included:

- Use the reconstructed current booking status.
- Count total bookings using distinct `booking_id`.
- Define cancellation rate using completed + cancelled bookings only.
- Use completed payments for completed payment amount.
- Do not treat booking value as collected revenue.
- Exclude deleted reviews.
- State the date field used in time-based analysis.
- Make proposed business definitions visible when relevant.

Example SQL patterns were also added for common questions so the Agent had reference examples for the agreed metric logic.

The detailed configuration is documented in the [technical research file](../research/04-genie-agent-setup-and-smoke-test-research.md).

---

## 3. Readiness check

A small **8-question smoke test** was run before the formal benchmark.

The smoke test checked whether the Agent could:

- Answer core booking questions
- Apply the agreed cancellation-rate definition
- Use the correct booking date for trends
- Rank destinations
- Analyze completed payment amounts
- Compare customer ratings
- Handle a more ambiguous follow-up question

### Result

**8 of 8 questions received an answer.**

The strongest results were:

- **72,247** total bookings
- **36,835** completed bookings
- **43.56%** cancellation rate
- Phuket identified as the highest-volume destination
- Monthly booking trend generated using booking creation date
- Completed payment and rating analysis produced successfully

The Agent was therefore functional enough to move toward structured evaluation.

---

## 4. What the smoke test revealed

The smoke test also exposed several trust risks before the benchmark.

| Risk | What happened | Product implication |
| --- | --- | --- |
| **Unsupported currency** | A dollar symbol was added even though currency was not defined | A correct number can still be misleading when context is invented |
| **Revenue terminology** | Completed payment amount was described as revenue | Business terminology needs stronger semantic control |
| **Small rating samples** | Destinations with very few reviews appeared at the top of rankings | Correct calculations can still produce weak business conclusions |
| **Undefined “high volume”** | The Agent selected its own threshold | Assumptions need to be visible when the user has not defined them |
| **Chart scope mismatch** | A visualization included destinations outside the written answer | Visual output also needs to match the business question |

These were not treated as benchmark failures because they were discovered during setup.

They became **pre-benchmark configuration risks** to address before formal scoring.

---

## 5. Product insight

The smoke test changed the evaluation focus.

The initial question was whether Genie could:

> Generate correct answers from the prepared data.

The smoke test showed that this is not enough.

A useful business answer also needs to preserve:

- The right metric definition
- The right terminology
- The right units
- The right comparison population
- Clear assumptions
- Relevant visualizations

This leads to a stronger benchmark principle:

> **Valid SQL does not automatically mean a trustworthy business answer.**

The formal benchmark should therefore evaluate both **technical correctness** and **business meaning**.

---

## 6. Benchmark criteria confirmed

Based on the smoke test, the formal benchmark should evaluate:

- Numerical correctness
- SQL correctness
- Business-definition compliance
- Handling of ambiguity
- Assumption disclosure
- Terminology
- Visualization relevance
- Consistency
- Response time
- Follow-up capability

This expands the evaluation beyond “did the query run?” and better reflects how a Product Manager would judge whether the Agent is safe and useful in practice.

---

## 7. Pre-benchmark actions

Before starting the formal benchmark, the Agent configuration should reinforce the following guardrails:

- Do not assign a currency unless it is available in the data.
- Use **completed payment amount**, not **revenue**, unless an approved revenue definition exists.
- Include review counts when ranking destinations by rating.
- Warn when a result is based on a small sample.
- State any threshold introduced for an ambiguous term such as “high volume”.
- Keep generated visualizations aligned with the exact question asked.

These are configuration refinements, not benchmark results.

---

## 8. Definition of Done

This readiness phase is complete when:

- [x] The Genie Agent is connected to the curated Wanderbricks views.
- [x] Core business definitions are included in the Agent configuration.
- [x] Example SQL patterns are available for the main metrics.
- [x] The Agent can answer the basic Wanderbricks questions.
- [x] The agreed booking and cancellation definitions are applied correctly.
- [x] Immediate semantic and trust risks are identified.
- [x] Pre-benchmark configuration improvements are documented.
- [x] The benchmark criteria are updated based on smoke-test findings.
- [x] The Agent is stable enough for structured evaluation.

---

## 9. Decision Gate

**Decision: proceed to the formal Genie benchmark.**

The Agent is functional and the main setup risks are understood.

The next phase should test the Agent systematically across a broader set of questions to determine:

- How often answers are numerically correct
- Whether business definitions remain consistent
- How well the Agent handles ambiguous requests
- Whether assumptions and limitations are communicated
- How reliable the experience remains across follow-up questions
- How quickly answers are returned

### Product question for the next phase

> **Can Genie remain reliable when the questions become less predictable and more ambiguous?**
