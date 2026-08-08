# Failure Analysis

This analysis includes only failure patterns that were observed during the Genie benchmark or targeted retest.

The main weakness was not SQL execution. It was **semantic reliability**: Genie could produce valid SQL and plausible results while applying the wrong business meaning.

| Failure category | What happened | Observed example | User impact | Likely cause | Configuration response | Product opportunity | Severity | Detection |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| **Metric-definition failure** | Genie used a metric without an approved business definition | **Q19:** completed payment amount was presented as revenue | User may make decisions using the wrong KPI | Undefined business metric | Add explicit metric definitions and prohibited interpretations | Surface the definition or proxy used | **High** | Trusted SQL + review |
| **Explicit-constraint failure** | Genie changed a threshold provided by the user | **Q17:** 1,000 bookings became 10. **Q18:** 1,000 reviews became 10 | Analysis answers a materially different question | User constraint not preserved | Add instructions to preserve explicit thresholds | Show requested vs applied threshold | **High** | Benchmark comparison |
| **Ambiguity failure** | Genie selected its own interpretation of an undefined term | **Q25:** "high booking volume" was interpreted inconsistently and later had no threshold | Result depends on an unstated definition | Ambiguous business language | Define common terms or require clarification | Flag undefined business terms | **High** | Review + trusted answer |
| **Date-period failure** | Genie treated the latest observed month as complete | **Q12:** July 2025 was included in the latest three complete months | Trend analysis can use incomplete data | Incomplete-period logic | Add complete-period rules | Warn when the latest period may be incomplete | **High** | Trusted SQL |
| **Unsupported-context failure** | Genie introduced context not available in the data | **Q10, Q19, Q20:** dollar symbols or currency assumptions were used without a currency field | Gives false precision and misleading business context | Missing metadata + model assumption | Explicitly prohibit unsupported currency assumptions | Show missing units or currency | **High** | Schema review + benchmark |
| **Analytical-population failure** | Genie calculated a benchmark over the wrong population | **Q26:** retest averages were based only on destinations present in both datasets | Result may look correct while using the wrong comparison base | Population definition not preserved | Define approved calculation populations | Show population used in calculations | **High** | SQL review |
| **Small-sample interpretation failure** | Genie ranked a result without clearly communicating weak evidence | **Q21:** Innsbruck ranked highest with only 14 reviews | User may over-trust an unstable ranking | No minimum sample rule or weak warning | Add sample-size guidance | Surface sample size and warnings | **Medium** | Review count comparison |
| **Trend-interpretation failure** | Written conclusion did not match the underlying values | **Q10:** a non-monotonic trend was described as consistently increasing | User may misunderstand the result despite correct underlying data | Overgeneralized narrative | Add instructions to describe only supported trends | Detect mismatch between result and written conclusion | **Medium** | Manual review |
| **Transparency failure** | Important assumptions or limitations were missing from the final answer | Seen across revenue, currency, thresholds, sample sizes, and incomplete periods | User cannot easily judge whether an answer is safe to use | Context remains hidden behind SQL or reasoning | Require assumptions and limitations to be stated | **Analytics Trust Center** | **High** | Benchmark review |
| **Visualization failure** | The chart technically represented the result but made interpretation difficult | **Q27:** incompatible metric scales. **Q29:** rating differences were visually compressed | Correct results become harder to interpret | Weak visualization defaults | Add chart-selection guidance | Better visualization recommendations | **Medium** | UX review |
| **Regression after configuration change** | A previously better answer became weaker after new instructions | **Q10, Q25, Q26** regressed during the targeted retest | Improvements in one area can create new failures elsewhere | Instruction changes affect multiple behaviors | Rerun affected benchmark questions after changes | Automated regression testing | **High** | Baseline vs retest |

---

## Main failure pattern

The benchmark showed that Genie was generally strong when the question had:

- A clear metric
- A clear population
- An explicit date field
- A straightforward calculation

Reliability decreased when the question required interpretation of:

- Business definitions
- Thresholds
- Time periods
- Units or currency
- Sample quality
- Analytical populations

> **Key finding:** valid SQL does not guarantee a trustworthy business answer.

---

## What improved after configuration changes

Targeted instructions improved several important behaviors:

- Explicit thresholds were preserved more reliably
- Undefined revenue was handled better
- Unsupported currency assumptions were reduced
- Ambiguous questions received better explanations
- Reliability increased from **0 to 6 reliable answers** within the targeted 11-question set

However, configuration did not eliminate all failures.

Three questions regressed after the changes:

- **Q10**
- **Q25**
- **Q26**

This supports the conclusion that **instructions improve reliability but are not a complete governance layer**.

---

## Product implication

The strongest product opportunity is not simply better SQL generation.

It is helping users understand when Genie may have applied the wrong business meaning.

This led to the proposed **Analytics Trust Center**, which would surface issues such as:

- Undefined metrics
- Changed thresholds
- Missing currency
- Incomplete periods
- Small samples
- Wrong analytical populations
- Hidden assumptions
