# User Journey, Trust & Operating Model

## Objective

This phase looks at the experience from both sides of the product:

1. **Business user** asking questions in Genie
2. **Data / platform administrator** preparing and maintaining the experience

The goal is to understand where Genie removes friction, where work shifts to the data team, and where trust can break.

> **Scope note:** This is a reconstructed current-state journey based on hands-on setup, product observations, the 30-question benchmark, and the targeted retest. It has not been validated through direct customer interviews.

---

## 1. Jobs to Be Done

### Business user

> **When I need an answer about business performance, I want to ask a question in natural language so that I can investigate the data without waiting for an analyst.**

Main jobs:

- Ask a business question
- Understand a trend
- Compare segments
- Ask follow-up questions
- Check whether the answer is trustworthy
- Share the result

### Data / platform administrator

> **When business users access Genie, I want to configure reliable data, definitions, instructions, and permissions so that the Agent produces controlled and useful answers.**

Main jobs:

- Prepare trusted data
- Define metrics and terminology
- Configure the Agent
- Test representative questions
- Investigate failures
- Improve and retest
- Control access
- Maintain the setup over time

---

## 2. Business-user journey

The business-user experience is simple on the surface:

```text
Discover → Ask → Interpret → Verify → Follow up → Decide → Share
```

| Stage | User need | Main friction | Product opportunity |
| --- | --- | --- | --- |
| **Discover** | Know what Genie can answer | Scope may be unclear | Show supported topics, metrics, and example questions |
| **Ask** | Get a useful answer quickly | Business terms may be vague | Clarify or show the assumption used |
| **Interpret** | Understand the result | Labels, wording, or charts may mislead | Use clear units, labels, and relevant visuals |
| **Verify** | Know whether the answer is safe to use | Valid SQL can still apply the wrong business rule | Show filters, thresholds, dates, and definitions |
| **Follow up** | Continue the analysis | Assumptions may change between questions | Keep assumptions and context visible |
| **Decide** | Use the result with confidence | Missing currency, small samples, or incomplete periods can change the decision | Surface warnings before the user acts |
| **Share** | Send a trustworthy result | Context can disappear when the answer is shared | Include definitions, assumptions, and limitations |

### Key friction

Genie reduces the effort required to **ask** a question.

The largest risk appears later, when the user must decide:

> **Can I trust this answer enough to act on it?**

---

## 3. Administrator journey

The administrator journey is less visible to the business user, but it carries most of the reliability work.

```text
Prepare → Define → Configure → Test → Benchmark → Improve → Retest → Release → Monitor
```

| Stage | Main responsibility | Product risk |
| --- | --- | --- |
| **Prepare** | Build clean analysis views | Poor data preparation creates wrong answers |
| **Define** | Set metric and terminology rules | Undefined terms may be interpreted differently |
| **Configure** | Add data, metadata, instructions, and access | Quality depends heavily on setup |
| **Test** | Check common and difficult questions | Simple questions may hide deeper failures |
| **Benchmark** | Compare Agent answers with trusted references | Plausible answers may still be wrong |
| **Improve** | Update instructions or examples | Fixes may not always be followed |
| **Retest** | Measure improvements and regressions | A local fix can create a new problem |
| **Release** | Decide which use cases are safe | High-risk questions may reach users too early |
| **Monitor** | Track failures, corrections, and latency | Quality can drift over time |

### Operating-model insight

Genie does not remove analytics work.

It **shifts part of that work** from repeated analyst requests toward:

- Semantic preparation
- Agent configuration
- Testing
- Governance
- Monitoring

This is an important product trade-off.

---

## 4. Moments of trust

Trust increases when Genie:

- Matches trusted results
- Preserves explicit thresholds
- States the date field used
- Shows assumptions
- Includes sample size
- Avoids unsupported terminology
- Makes the calculation easy to inspect

Trust decreases when Genie:

- Changes a user-provided threshold
- Invents a currency
- Calls completed payment amount “revenue”
- Treats an incomplete period as complete
- Uses a small sample without warning
- Produces a chart that hides important differences
- Drops a limitation from the final answer

---

## 5. Highest-risk moment

The highest-risk part of the journey is:

```text
Ask → Verify → Decide
```

This is where a plausible answer can become a business decision.

The benchmark showed that Genie can produce:

- Executable SQL
- A plausible number
- A clear-looking answer

while still applying the wrong business meaning.

### Product insight

> **The main trust problem is not access to the answer. It is knowing whether the answer used the right business meaning.**

---

## 6. Product opportunity

The biggest opportunity is to make trust information visible without forcing business users to inspect SQL.

The experience should make it easier to see:

- Metric definition
- Filters
- Thresholds
- Date period
- Assumptions
- Sample size
- Missing units or currency
- Data limitations

This would reduce the gap between **answer generation** and **decision confidence**.

---

## 7. PM prioritization

### P0: Protect business meaning

Prevent silent changes to:

- Metric definitions
- Explicit thresholds
- Analytical populations

### P0: Surface decision-critical warnings

Make missing currency, incomplete periods, and weak sample sizes visible before the answer is used.

### P1: Preserve context across follow-ups

Keep assumptions and definitions stable across related questions.

### P1: Improve shareability

Shared results should carry the assumptions and limitations needed to interpret them correctly.

### P2: Reduce administrator effort

Add reusable templates, regression checks, and readiness criteria for Genie configurations.

---

## 8. Definition of Done

This user-journey phase is complete when:

- [x] The main business-user JTBD is defined.
- [x] The administrator JTBD is defined.
- [x] The business-user journey is mapped.
- [x] The administrator operating journey is mapped.
- [x] The main friction points are identified.
- [x] Trust-building and trust-breaking moments are documented.
- [x] The highest-risk stage of the journey is identified.
- [x] Product opportunities are linked to observed teardown evidence.
- [x] Opportunities are prioritized by business risk.
- [x] The limits of the evidence are stated clearly.

---

## 9. Decision Gate

**Decision: proceed from journey analysis to product opportunity definition.**

The teardown now shows where Genie creates value and where trust breaks.

The next product work should focus on the **Ask → Verify → Decide** gap, where business users need clearer evidence that the Agent used the right definitions, assumptions, and analytical context.

### Product question for the next phase

> **How might Genie make trust-critical context visible before a business user acts on an answer?**
