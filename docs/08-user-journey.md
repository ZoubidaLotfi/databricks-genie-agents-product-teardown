# Part 1: User journey analysis

## Goal

Map the end-to-end experience for the two main user groups:

1. **Business user**
2. **Data or platform administrator**

This distinction is important because Genie may appear simple to the business user while requiring significant preparation from the data team.

---

## 1. Define the main user jobs

> [!NOTE] Scope and evidence
>
> This is a reconstructed current-state journey based on:
>
> - Hands-on Genie Space configuration
> - Product interface observations
> - A 30-question benchmark against trusted SQL Editor results
> - An 11-question targeted instruction-improvement retest
>
> The journey has not been validated through direct customer interviews.
> User expectations and organizational behavior should therefore be treated as
> product hypotheses, while setup and benchmark findings are direct teardown
> evidence.

We will use a Jobs to Be Done (JTBD) format.

The most useful structure is:

```text
When [situation or trigger],
I want to [job],
so that [desired outcome].
```

### Business user

> When I need an answer about business performance, I want to ask a question in natural language so that I can investigate the data without waiting for an analyst.

Typical jobs:

- Ask a business question
- Understand a trend
- Compare destinations or segments
- Follow up on a result
- Inspect generated SQL
- Decide whether the answer is trustworthy
- Share the result with another person

### Data administrator or analytics engineer

> When business users access Genie, I want to configure reliable data, definitions, instructions, and permissions so that the Agent produces controlled and useful answers.

Typical jobs:

- Select source tables or views
- Define metrics and business terminology
- Add Agent instructions
- Configure descriptions and metadata
- Test representative questions
- Review generated SQL
- Monitor failures
- Improve instructions and data models
- Control access

---

## 2. Map the business-user journey

| Stage | User action | Expectation | Main friction | Teardown evidence | Trust risk | Improvement |
|---|---|---|---|---|---|---|
| Discover | Learns about Genie | Understand what it can answer | Scope may be unclear | Testing showed that results depended on the data views and instructions added to the Genie Space. | Users may expect answers the Space cannot support. | Show supported topics, metrics, and example questions. |
| Access | Opens a Genie Space | Reach the right data quickly | Permissions or workspace access | Setup required curated views, a SQL warehouse, instructions, and permissions. | Access problems may look like product failures. | Explain access errors and guide users to the correct Space. |
| Ask | Types a business question | Get a fast and accurate answer | Terms may be vague or undefined | Q19 showed that revenue was undefined. Q23 showed that “best” could mean different metrics. Q25 showed that “high volume” needed a clear threshold. | Genie may choose a meaning the user did not intend. | Ask for clarification or show the chosen assumption. |
| Interpret | Reads the answer, table, or chart | Understand the result quickly | Poor wording, labels, or chart choices | Q10 described a changing trend as consistently increasing. Q27 mixed metrics with very different scales. Q29 made small rating differences hard to see. | A correct result may still be misunderstood. | Use clear labels, units, and suitable charts. |
| Verify | Reviews SQL and calculation details | Confirm the answer is correct | Valid SQL may still use the wrong rule | Q17 and Q18 replaced thresholds of 1,000 with 10. In the Q26 retest, the correct rows used the wrong averaging population. | Users may trust SQL only because it runs. | Show filters, formulas, dates, thresholds, and populations clearly. |
| Follow up | Asks another question | Keep the same context and definitions | Earlier assumptions may change | Related questions used different meanings for “high volume,” “best,” and “complete month.” Multi-turn consistency was not tested directly. | Answers in the same conversation may use different definitions. | Keep assumptions, filters, and thresholds visible. |
| Decide | Uses the answer for action | Feel confident using the result | Missing definitions, currency, complete periods, or sample size | Q19 confused payment amount with revenue. Q20 had no currency. Q21 used only 14 reviews. Q12 treated the latest data month as complete. | A plausible answer may lead to a poor decision. | Add warnings for missing definitions, small samples, and incomplete data. |
| Share | Sends the result to others | Share a clear and traceable answer | Important context may be lost | Important limits were weakened or omitted in Q10, the original Q11 answer, and Q21. | Others may not know how the result was calculated. | Include sources, filters, assumptions, and limitations. |

---

## 3. Map the administrator journey

| Stage | Main task | Main issue | Teardown evidence | Trust risk | Improvement |
|---|---|---|---|---|---|
| Prepare data | Create clean analysis views | Raw data may be too complex | We created separate booking, payment, and review views. | Wrong counts or duplicated data | Check duplicates, joins, and table grain. |
| Define metrics | Set business rules and terms | Some terms have no clear definition | Revenue and currency were not defined. | The Agent may invent a meaning. | Add approved definitions and metric owners. |
| Configure Space | Add views, descriptions, instructions, and access | Quality depends on setup | Results changed after instructions were updated. | Poor setup can lead to weak answers. | Use setup templates and readiness checks. |
| Test | Ask common and difficult questions | Simple tests may hide problems | Basic metrics worked better than ambiguous questions. | The Space may look ready too early. | Test direct, ambiguous, financial, and trend questions. |
| Benchmark | Compare Agent answers with trusted SQL | Requires time from analysts | We tested 30 questions against SQL Editor results. | Correct-looking answers may still be wrong. | Save trusted questions and expected results. |
| Review failures | Find why an answer failed | The cause may not be obvious | Failures came from data, definitions, SQL, and final wording. | The wrong fix may be applied. | Label each failure by cause. |
| Improve instructions | Add rules based on failures | Rules may not always be followed | Q17–Q19 improved, but Q10 and Q12 did not. | Teams may trust the new rules too much. | Add examples and clear validation rules. |
| Retest | Rerun affected questions | Fixes may create new problems | Seven questions improved, three regressed. | A local fix may reduce overall quality. | Run a small regression test after every change. |
| Release | Decide whether the Space is ready | Not every use case has the same risk | Core metrics were stronger than financial and ambiguous questions. | High-risk questions may reach users too early. | Define safe and restricted use cases. |
| Monitor | Track real usage and failures | Real questions may differ from test questions | Some retest answers took up to three minutes. | Quality and speed may drop over time. | Track failures, corrections, and response time. |
| Maintain | Update data, definitions, and access | The Space can become outdated | Reliability depended on views, rules, and instructions. | Old definitions may produce wrong answers. | Assign owners and regular review dates. |

---

## 4. Moments of trust and distrust

### Trust increases when

- The answer matches trusted SQL
- The generated SQL is visible
- The date field is clearly stated
- The Agent follows explicit thresholds
- Assumptions are disclosed
- Review counts are included
- Unsupported terms are rejected
- The Agent asks for clarification

### Trust decreases when

- SQL executes but answers a different question
- The Agent silently changes a threshold
- A currency symbol is invented
- Payment amount is called revenue
- A partial month is treated as complete
- A low-volume result is presented as representative
- A chart hides important differences
- Inspection identifies a limitation that disappears from the final answer

---

## 5. User-journey conclusion

The conclusion answers the following questions:

- Where does Genie reduce friction?
- Where does Genie transfer work to administrators?
- Where is human review still necessary?
- Which stage creates the highest trust risk?

> [!NOTE] User-journey conclusion
>
> Genie reduces friction for business users by allowing them to explore governed
> data without waiting for a custom SQL query.
>
> However, it does not remove the work required to prepare and govern the data.
> Much of the complexity moves to administrators, who must configure views,
> definitions, instructions, permissions, tests, and monitoring.
>
> The highest trust risk appears between the Ask, Verify, and Decide stages.
> A response can contain valid SQL and a plausible number while still applying
> the wrong business definition.
>
> The main product opportunity is to make definitions, filters, assumptions,
> sample sizes, and limitations visible without requiring business users to
> inspect SQL.
