# Product Discovery Research

## Research purpose

This file contains the supporting research and early decisions behind the Product Discovery & Scope document.

The main Product Discovery conclusions are documented in the [Product Discovery & Scope document](../docs/01-product-discovery-and-scope.md).

---

## 1. Initial product research

During discovery, the main questions were:

| Research question | Finding |
| --- | --- |
| **Who is Genie designed for?** | Business users can ask questions in natural language, while data teams configure the data and business context behind the Agent. |
| **What does Genie depend on?** | Governed data, metadata, SQL compute, business definitions, and Agent configuration. |
| **Can users inspect how answers are produced?** | Yes. Genie exposes generated SQL and analysis information. |
| **How is it different from a dashboard?** | Dashboards focus on predefined analysis. Genie supports new and follow-up questions. |
| **Where could reliability problems appear?** | Business definitions, assumptions, thresholds, time periods, missing context, and data-quality issues were identified as areas to test. |

These findings shaped the later benchmark.

---

## 2. Scope changes during discovery

The initial project idea was broader than the final teardown.

| Initial idea | Final decision | Why |
| --- | --- | --- |
| SaaS product analytics | Wanderbricks booking analytics | Wanderbricks provided a usable Databricks sample scenario |
| Adoption, activation, retention, churn | Bookings, cancellations, payments, ratings | These matched the available dataset |
| Revenue analysis | Booking value and completed payment amount | No approved revenue definition was available |
| Measure time saved vs analyst workflow | Observe Genie response time only | Analyst turnaround time was not formally measured |
| Broad AI-agent evaluation | Focus on analytical reliability and trust | This became the strongest product question |
| Test many possible Agent behaviors | Focus benchmark on business analytics questions | Clarification, refusal, and unsupported-request testing were outside scope |

---

## 3. Questions carried into testing

These discovery questions became inputs to later phases:

- How much semantic preparation does Genie need?
- Does Genie preserve business definitions?
- How does it handle ambiguous terminology?
- Does it preserve explicit thresholds?
- How does it handle missing context such as currency?
- Can technically valid SQL still answer the wrong business question?
- Do stronger instructions improve reliability?
- Can configuration changes create regressions?

These questions were later tested through the data investigation, smoke test, 30-question benchmark, and targeted retest.

---

## 4. Questions not formally tested

Some discovery questions remained outside the final teardown:

- Consistency across repeated identical prompts
- User adoption
- Production-scale maintenance effort
- Builder workload over time
- Clarification quality
- Refusal behavior
- Unsupported-request handling

They should therefore not be presented as validated findings.

---

## 5. Supporting discovery artifacts

The main supporting artifacts created during this phase are:

- [Product assumptions](day-1-assumptions-and-validation-research.md)
- [Product glossary](glossary.md)
- [Product map and architecture research](product-map.md)

The assumptions register preserves the hypotheses established before the benchmark and records which ones were eventually supported, rejected, or left untested.

## Research conclusion

The discovery phase helped narrow the teardown from a broad AI analytics project into a focused test of **reliability and trust in Genie**.

The key decisions were:

- Use Wanderbricks as the business scenario.
- Focus on bookings, cancellations, payments, and ratings.
- Treat revenue carefully because no approved definition was available.
- Compare Genie with a dashboard baseline.
- Evaluate both technical correctness and business meaning.
- Exclude adoption, refusal behavior, and long-term maintenance from the formal scope.

This gave the later benchmark a clear focus:

> **Can Genie make business analysis more flexible without losing reliability and trust?**
