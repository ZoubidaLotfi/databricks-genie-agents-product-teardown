# Assumptions & Validation Research

## Purpose

This register tracks the main assumptions made at the start of the teardown and whether the project evidence supported them.

Validation is based on:

- Dashboard baseline
- Genie smoke test
- 30-question benchmark
- 11-question targeted retest
- User-journey analysis
- Competitive analysis
- Hands-on configuration experience

> Assumptions that required user interviews, pilots, or repeated behavioral testing are marked as **Not validated** rather than inferred from the teardown.

---

## Assumptions Register

| Assumption | Why it matters | Evidence used | Status | Final conclusion |
| --- | --- | --- | --- | --- |
| **Business users can benefit from conversational analytics** | Core product value | Genie testing and benchmark | **Partially validated** | Genie made direct and follow-up analysis easier, but actual user demand was not tested with interviews or usage data. |
| **Dashboards limit flexible follow-up analysis** | Baseline comparison | Dashboard baseline and workflow analysis | **Validated** | Dashboards answer predefined questions well, but new questions often require additional analysis or dashboard changes. |
| **Metric ambiguity creates material trust risk** | Reliability | Benchmark failures | **Validated** | Revenue, high volume, complete periods, and other ambiguous terms caused incorrect or inconsistent answers. |
| **Semantic preparation improves answer quality** | Product setup | Data preparation and benchmark | **Validated** | Curated views, definitions, and business rules created a stronger foundation for Genie. |
| **Instructions improve Agent behavior** | Configuration value | Targeted retest | **Validated with limitation** | Targeted average improved from **5.73 to 7.91**, but 3 questions regressed. |
| **Instructions alone are sufficient for reliability** | Governance model | Targeted retest | **Rejected** | Instructions improved results but did not consistently preserve business meaning. |
| **Genie can produce accurate business answers** | Product feasibility | 30-question benchmark | **Validated** | 80% of original answers were numerically correct, with strongest performance on clear and well-defined questions. |
| **Valid SQL means the business answer is correct** | Trust model | Benchmark SQL review | **Rejected** | Executable SQL sometimes answered a different business question. |
| **Users need visibility into assumptions and definitions** | Trust experience | Benchmark and user journey | **Partially validated** | The teardown found a clear visibility gap, but the proposed Trust Center was not tested with real users. |
| **Small samples can create misleading rankings** | Decision quality | Q21 | **Validated** | Innsbruck ranked highest by rating with only 14 reviews, showing why sample context matters. |
| **Incomplete periods can affect trend analysis** | Time analysis | Q12 | **Validated** | Genie treated the latest observed month as complete when it should not have. |
| **Human oversight remains useful for sensitive questions** | Governance | Benchmark and retest | **Validated** | Ambiguous definitions, populations, and assumptions sometimes required analyst review. |
| **Regression testing is needed after configuration changes** | Maintenance | Targeted retest | **Validated** | Q10, Q25, and Q26 regressed after configuration changes. |
| **Governed definitions are important for reliable self-service analytics** | Product strategy | Benchmark, retest, competitive analysis | **Validated** | Reliability was strongest when metrics and rules were clearly defined. |
| **Dashboard and Genie serve different analytical needs** | Product positioning | Dashboard baseline and Genie testing | **Validated** | Dashboards work well for predefined monitoring; Genie adds flexibility for new and follow-up questions. |
| **Genie behavior is consistent across repeated identical prompts** | Operational reliability | No repeated-run test performed | **Not validated** | The teardown did not systematically rerun identical prompts to test determinism. |
| **Clarification behavior improves user outcomes** | UX | No dedicated clarification test | **Not validated** | Clarification quality was not formally benchmarked. |
| **Unsupported requests are handled safely** | Product boundaries | No dedicated boundary test | **Not validated** | Unsupported-request and refusal behavior were outside the benchmark scope. |
| **Maintenance burden is manageable** | Operational viability | Configuration experience only | **Not validated** | Setup and retesting required noticeable effort, but builder time was not formally measured. |
| **Business users would adopt Genie** | Adoption | No pilot or user study | **Not validated** | Adoption cannot be concluded from the teardown alone. |
| **Builder workload is acceptable** | Operations | Hands-on setup experience | **Not validated** | The workload was observed qualitatively but not measured against an acceptance threshold. |

---

## Main validated assumptions

The teardown provides strong evidence for four conclusions:

1. **Genie can answer well-defined business questions accurately.**
2. **Business ambiguity is a major reliability risk.**
3. **Configuration improves reliability but does not guarantee it.**
4. **Governance, regression testing, and visible context remain important.**

---

## Assumptions still requiring real-user validation

The teardown did not validate:

- User adoption
- User willingness to rely on Genie
- Trust Center usability
- Builder workload at production scale
- Long-term maintenance effort
- Repeated-answer consistency

These would require user research, pilots, or production usage data.
