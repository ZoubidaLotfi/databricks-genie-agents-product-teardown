# User Journey Evidence Research

## Research purpose

This file preserves the detailed teardown evidence behind the PM-facing user journey and trust analysis.

The journey is reconstructed from:

- Hands-on Genie Space configuration
- Product interface observations
- A 30-question benchmark against trusted SQL Editor results
- An 11-question targeted instruction-improvement retest

It has not been validated through direct customer interviews.

User expectations and organizational behavior should therefore be treated as product hypotheses. Setup and benchmark observations are direct teardown evidence.

---

## 1. Business-user evidence matrix

| Stage | User action | Expectation | Main friction | Teardown evidence | Trust risk | Improvement |
| --- | --- | --- | --- | --- | --- | --- |
| Discover | Learns about Genie | Understand what it can answer | Scope may be unclear | Results depended on the views and instructions configured in the Genie Space | Users may expect answers the Space cannot support | Show supported topics, metrics, and example questions |
| Access | Opens a Genie Space | Reach the right data quickly | Permissions or workspace access | Setup required curated views, a SQL warehouse, instructions, and permissions | Access issues may look like product failures | Explain access errors and guide users to the correct Space |
| Ask | Types a business question | Get a fast and accurate answer | Terms may be vague or undefined | Q19: revenue undefined. Q23: “best” ambiguous. Q25: “high volume” needed a threshold | Genie may choose a meaning the user did not intend | Ask for clarification or show the chosen assumption |
| Interpret | Reads answer, table, or chart | Understand quickly | Poor wording, labels, or chart choices | Q10 overstated trend direction. Q27 mixed metrics with very different scales. Q29 made small rating differences hard to see | Correct result may still be misunderstood | Use clear labels, units, and suitable charts |
| Verify | Reviews SQL and calculation details | Confirm correctness | Valid SQL may still use the wrong rule | Q17 and Q18 replaced thresholds of 1,000 with 10. Q26 retest used the wrong averaging population | Users may trust SQL simply because it runs | Show filters, formulas, dates, thresholds, and populations |
| Follow up | Asks another question | Keep the same context | Earlier assumptions may change | Related questions used different meanings for “high volume,” “best,” and “complete month.” Multi-turn consistency was not directly tested | Related answers may use inconsistent definitions | Keep assumptions, filters, and thresholds visible |
| Decide | Uses answer for action | Feel confident using it | Missing definitions, currency, periods, or sample size | Q19 confused payment amount with revenue. Q20 lacked currency. Q21 used 14 reviews. Q12 treated latest data month as complete | Plausible answer may lead to poor decision | Add warnings for missing definitions, small samples, and incomplete data |
| Share | Sends result to others | Share a traceable answer | Context may be lost | Important limits were weakened or omitted in Q10, original Q11, and Q21 | Others may not know how the result was calculated | Include sources, filters, assumptions, and limitations |

---

## 2. Administrator evidence matrix

| Stage | Main task | Main issue | Teardown evidence | Trust risk | Improvement |
| --- | --- | --- | --- | --- | --- |
| Prepare data | Create clean analysis views | Raw data may be too complex | Separate booking, payment, and review views were created | Wrong counts or duplicated data | Check duplicates, joins, and table grain |
| Define metrics | Set business rules and terms | Some terms have no clear definition | Revenue and currency were not defined | Agent may invent a meaning | Add approved definitions and metric owners |
| Configure Space | Add views, descriptions, instructions, and access | Quality depends on setup | Results changed after instructions were updated | Poor setup can lead to weak answers | Use setup templates and readiness checks |
| Test | Ask common and difficult questions | Simple tests may hide problems | Basic metrics worked better than ambiguous questions | Space may look ready too early | Test direct, ambiguous, financial, and trend questions |
| Benchmark | Compare Agent answers with trusted SQL | Requires analyst effort | 30 questions were tested against SQL Editor results | Correct-looking answers may still be wrong | Save trusted questions and expected results |
| Review failures | Diagnose why an answer failed | Cause may not be obvious | Failures came from data, definitions, SQL, and final wording | Wrong fix may be applied | Label each failure by cause |
| Improve instructions | Add rules based on failures | Rules may not always be followed | Q17–Q19 improved, but Q10 and Q12 did not | Teams may over-trust new rules | Add examples and validation rules |
| Retest | Rerun affected questions | Fixes may create new problems | Seven questions improved and three regressed | Local fix may reduce overall quality | Run regression tests after changes |
| Release | Decide whether Space is ready | Use cases have different risk levels | Core metrics were stronger than financial and ambiguous questions | High-risk questions may reach users too early | Define safe and restricted use cases |
| Monitor | Track real usage and failures | Real questions may differ from test questions | Some retest answers took up to three minutes | Quality and speed may drift | Track failures, corrections, and response time |
| Maintain | Update data, definitions, and access | Space can become outdated | Reliability depended on views, rules, and instructions | Old definitions may produce wrong answers | Assign owners and review dates |

---

## 3. Trust evidence

### Trust increases when

- Answer matches trusted SQL
- Generated SQL is visible
- Date field is clearly stated
- Explicit thresholds are preserved
- Assumptions are disclosed
- Review counts are included
- Unsupported terms are rejected
- Agent asks for clarification

### Trust decreases when

- SQL runs but answers a different question
- Threshold changes silently
- Currency is invented
- Payment amount is called revenue
- Partial month is treated as complete
- Low-volume result is presented as representative
- Chart hides important differences
- Limitation found during inspection disappears from final answer

---

## 4. Research conclusion

The teardown suggests that Genie reduces business-user friction at the **Ask** stage, but reliability work moves upstream to the administrator and downstream to the **Verify / Decide** stages.

The strongest evidence points to the **Ask → Verify → Decide** part of the journey as the main trust risk.

The key product opportunity is therefore to make definitions, filters, assumptions, sample sizes, and limitations visible without requiring business users to inspect SQL.
