# Genie Agent Quality Benchmark

## Objective

This benchmark evaluates whether the **Wanderbricks Business Performance Agent** can answer business-data questions accurately, consistently, and transparently using the curated analysis views:

- `booking_analysis`
- `payment_analysis`
- `review_analysis`

The benchmark compares the Agent's responses and generated SQL with independent reference answers produced in the Databricks SQL Editor.

The full row-level evidence is stored in:

```text
research/day-4-benchmark-results.csv
```

---

## Method

The benchmark contains **30 questions** divided into five categories:

| Category | Questions | Main capability tested |
|---|---:|---|
| Core metric accuracy | 6 | Counts, booking status, cancellation rate, payments, and ratings |
| Time and trend analysis | 6 | Date selection, monthly grouping, trends, and complete-month logic |
| Segmentation and ranking | 6 | Destination, country, property type, ranking, and thresholds |
| Data quality and ambiguity | 6 | Currency, revenue, sample size, and undefined terminology |
| Multi-step and follow-up analysis | 6 | Cross-view comparisons, combined metrics, and judgment |

Each response was scored across five dimensions from `0` to `2`:

| Dimension | 0 | 1 | 2 |
|---|---|---|---|
| Numerical correctness | Wrong | Partially correct | Correct |
| SQL correctness | Invalid or wrong source | Works but has a weakness | Correct and appropriate |
| Definition compliance | Breaks business rules | Partially follows rules | Fully follows rules |
| Clarity | Misleading or unclear | Understandable with limitations | Clear and direct |
| Assumption handling | Unsupported assumption | Assumption not clearly stated | Assumption disclosed or clarification requested |

The maximum score per question is **10**.

| Total score | Interpretation |
|---:|---|
| 9–10 | Reliable |
| 7–8 | Acceptable with minor issues |
| 5–6 | Requires analyst review |
| 0–4 | Failed |

Agent response times were manually observed to range from approximately **29 to 60 seconds**. Exact timings were not recorded for each individual question.

---


## SQL Editor versus Genie Agent

The Databricks SQL Editor was used to create the **trusted reference result** for each question. It was not scored as a competing assistant. Its role was to establish:

- The independently calculated numerical result
- The correct source view and filters
- The applicable business definition
- The expected treatment of ambiguity

The Genie Agent answer and generated SQL were then evaluated against that reference. The detailed comparison is available for every question in:

```text
research/day-4-benchmark-results.csv
```

The most important comparison columns are:

| SQL Editor baseline | Genie Agent evidence |
|---|---|
| `Trusted result` | `Agent answer` |
| `Expected behavior` | `Agent SQL` |
| Business definitions and restrictions | Five scoring dimensions and issue notes |

### Direct comparison results

| Comparison with the SQL Editor reference | Questions | Percentage |
|---|---:|---:|
| Numerically correct | **24** | **80.0%** |
| Partially correct | **3** | **10.0%** |
| Numerically wrong | **3** | **10.0%** |
| SQL fully correct and appropriate | **18** | **60.0%** |
| SQL worked but had a weakness or could not be fully verified | **12** | **40.0%** |
| Invalid SQL or wrong source | **0** | **0.0%** |
| Fully followed business definitions | **18** | **60.0%** |
| Partially followed business definitions | **8** | **26.7%** |
| Broke business definitions | **4** | **13.3%** |

This distinction matters because an Agent can return executable SQL and even a plausible number while still answering a different business question.

### Comparison by question category

| Category | Editor reference available | Agent numerically correct | Partial | Wrong | Agent average |
|---|---:|---:|---:|---:|---:|
| Core metric accuracy | 6/6 | **6** | 0 | 0 | **9.00/10** |
| Time and trend analysis | 6/6 | **5** | 1 | 0 | **7.17/10** |
| Segmentation and ranking | 6/6 | **3** | 1 | 2 | **7.17/10** |
| Data quality and ambiguity | 6/6 | **5** | 0 | 1 | **7.50/10** |
| Multi-step and follow-up analysis | 6/6 | **5** | 1 | 0 | **8.50/10** |

### Examples of Editor and Agent divergence

| Question | SQL Editor reference | Genie Agent response | Why it matters |
|---|---|---|---|
| Q12: latest three complete months | April, May, and June 2025 | May, June, and July 2025 | The Agent included the latest observed month without proving it was complete. |
| Q17: lowest cancellation rate with at least 1,000 bookings | Mallorca, New York, Abu Dhabi, Madrid, and Xi'an | Used a threshold of 10 terminal bookings and returned different destinations | The SQL ran, but the Agent replaced an explicit user threshold. |
| Q18: lowest rating with at least 1,000 reviews | Berlin, Barcelona, Rome, New York, and Singapore | Used a threshold of 10 reviews | A changed threshold completely altered the ranking. |
| Q19: Wanderbricks revenue | No approved revenue definition; several possible proxy measures | Reported `$25,296,456.50` as revenue | The Agent converted completed payment amount into revenue and assumed a currency. |
| Q25: high volume with below-average ratings | Benchmark threshold of at least 1,000 bookings | Defined high volume as above the median, more than 1,062 bookings | The assumption was disclosed, but it excluded a destination that met the benchmark definition. |

The comparison shows that the Agent's main weakness was not its ability to write SQL. The larger issue was preserving the SQL Editor's business definitions and analytical boundaries.

---

## Overall benchmark results

| Metric | Result |
|---|---:|
| Questions evaluated | **30** |
| Average score | **7.87/10** |
| Questions scoring at least 7/10 | **25 of 30 (83.3%)** |
| Reliable responses | **15 (50.0%)** |
| Acceptable with minor issues | **10 (33.3%)** |
| Requires analyst review | **1 (3.3%)** |
| Failed responses | **4 (13.3%)** |
| Observed response time | **29–60 seconds** |

The Agent produced a reliable or acceptable response for **25 of 30 questions**. However, five questions required analyst review or failed because of unsupported assumptions, changed thresholds, or incorrect business terminology.

---

## Results by category

| Category | Average score | Reliable | Acceptable | Analyst review | Failed |
|---|---:|---:|---:|---:|---:|
| Core metric accuracy | **9.00/10** | 4 | 2 | 0 | 0 |
| Time and trend analysis | **7.17/10** | 2 | 2 | 1 | 1 |
| Segmentation and ranking | **7.17/10** | 3 | 1 | 0 | 2 |
| Data quality and ambiguity | **7.50/10** | 2 | 3 | 0 | 1 |
| Multi-step and follow-up analysis | **8.50/10** | 4 | 2 | 0 | 0 |

### Category interpretation

**Core metric accuracy** was the strongest category. The Agent reliably handled total bookings, completed bookings, cancellation rate, completed payment amount, and destination-level counts.

**Time and trend analysis** was less consistent. It selected the correct date fields in most questions, but it mishandled the definition of a complete month and sometimes described fluctuating data as a consistently increasing trend.

**Segmentation and ranking** included two important failures. The Agent replaced explicit thresholds of 1,000 bookings and 1,000 reviews with unsupported thresholds of 10.

**Data quality and ambiguity** showed mixed performance. The Agent handled some ambiguous terms well, such as active bookings and high volume, but failed the revenue question by treating completed payment amount as revenue and assuming a dollar currency.

**Multi-step analysis** performed well overall. The Agent correctly combined booking, payment, and review metrics when the requested criteria were sufficiently clear.

---

## Results by scoring dimension

| Dimension | Average | Percentage of maximum |
|---|---:|---:|
| Numerical correctness | **1.70/2** | **85.0%** |
| SQL correctness | **1.60/2** | **80.0%** |
| Definition compliance | **1.47/2** | **73.3%** |
| Clarity | **1.63/2** | **81.7%** |
| Assumption handling | **1.47/2** | **73.3%** |

The strongest dimension was **numerical correctness**. When the Agent selected the correct definition and filters, it usually returned the correct numerical result.

The weakest dimensions were **definition compliance** and **assumption handling**. The main reliability risk was not incorrect arithmetic. It was the Agent silently changing definitions or presenting unsupported business interpretations.

---

## Strongest responses

The Agent received a perfect score for the following questions:

- **Q04**: What is the cancellation rate?
- **Q05**: What is the total completed payment amount?
- **Q13**: Which destination has the most bookings?
- **Q14**: Show the top five countries by booking volume.
- **Q15**: Which property type has the most completed bookings?
- **Q22**: Which high-volume destination has the lowest rating?
- **Q24**: How many active bookings are there?

These results show that the Agent is strongest when:

- The metric is clearly defined
- The required view is obvious
- The question uses terminology already included in the Agent instructions
- The calculation requires a direct aggregation or ranking
- The response does not require financial interpretation or an undefined business threshold

---

## Main failure patterns

### 1. Explicit thresholds were replaced

For Q17 and Q18, the questions explicitly required thresholds of:

```text
At least 1,000 bookings
At least 1,000 reviews
```

The Agent replaced both with thresholds of `10`. The SQL executed correctly, but it answered a different question.

This is a serious reliability issue because successful SQL execution does not guarantee compliance with the user's definition.

### 2. Completed payment amount was presented as revenue

For Q19, the Agent returned:

```text
$25,296,456.50 in revenue
```

The available data only supports the term **completed payment amount**. It does not provide a production-approved revenue definition or a confirmed currency.

The Agent's own inspection identified possible refunds and accounting ambiguity, but its final answer ignored those limitations.

### 3. Unsupported currency symbols appeared

Dollar symbols appeared in several responses even though the payment data contains no currency field.

This affected questions involving:

- Payment trends
- Revenue
- Destination performance
- Currency identification

The Agent should display payment amounts without a currency symbol unless governed metadata explicitly provides one.

### 4. Complete-month logic was inconsistent

For Q12, the benchmark definition required excluding July 2025 because it was the latest observed data month and could be incomplete.

The Agent included July 2025 and returned May, June, and July instead of April, May, and June. It also omitted the requested month-over-month comparison.

### 5. Small samples were not always highlighted

For Q21, Innsbruck had the highest raw average rating at `3.30`, but this was based on only `14 reviews`.

The Agent included the review count but did not warn that the ranking was based on a very small sample. A more reliable answer would compare the raw result with a minimum-volume result.

### 6. Some visualizations reduced clarity

Several charts placed metrics with very different scales on the same axis. For example, completed payment amounts in the millions were shown beside ratings around `3.0`.

The underlying SQL was correct, but the visualization made smaller metrics difficult to interpret.

---

## Questions requiring review or classified as failures

| Question | Score | Main issue |
|---|---:|---|
| Q10: How have completed payment amounts changed by payment month? | **5/10** | Correct monthly amounts, but it assumed dollars and described the trend as consistently upward despite several decreases. SQL was not captured. |
| Q12: Compare booking volume in the latest three complete months. | **4/10** | It included July 2025 even though the benchmark definition excludes the latest observed month, did not compute changes, and the rerun result was inconsistent. |
| Q17: Which destinations have the lowest cancellation rate among those with at least 1,000 bookings? | **3/10** | The Agent ignored the explicit 1,000-total-booking threshold, substituted 10 terminal bookings, and justified the unsupported threshold as statistically significant. |
| Q18: Which destinations have the lowest average rating among those with at least 1,000 reviews? | **3/10** | The Agent ignored the explicit 1,000-review threshold and replaced it with an unsupported 10-review threshold. |
| Q19: What is Wanderbricks revenue? | **2/10** | It renamed completed payment amount as revenue, assumed dollars, and ignored the ambiguity and refund/accounting concerns that its own inspection identified. |

---

## Configuration improvements recommended

Before a second benchmark run, the Agent instructions should be strengthened with the following rules:

```text
Follow explicit numerical thresholds exactly. Do not replace a user-provided
threshold with another threshold.

Do not assign a currency symbol unless a currency field or governed currency
definition is available.

Use the term completed payment amount. Do not call it revenue unless a
production-approved revenue definition is available.

When ranking average ratings, include review_count and warn when the result is
based on a small sample.

When the user asks for complete months, state how a complete month is defined
and exclude the latest observed month when it may be incomplete.

When a question is ambiguous, either request clarification or clearly state
the assumption before calculating the result.

Ensure the final answer preserves important limitations discovered during the
inspection process.
```

These changes should be made only after Benchmark Run 1 is documented. A second run should use the same 30 questions to measure whether the configuration changes improve reliability.

---

## Final conclusion

The benchmark produced an average score of **{average_score:.2f}/10**, with **{scores_at_least_7} of {question_count} questions ({100 * scores_at_least_7 / question_count:.1f}%)** receiving a reliable or acceptable score.

The Genie Agent performed well on clearly defined metrics, direct aggregations, rankings, and multi-view comparisons. It correctly used the curated analysis views and generally generated executable SQL.

Its main weakness was not calculation accuracy. The larger risk was **semantic reliability**:

- Changing explicit thresholds
- Assuming unsupported currency
- Treating completed payment amount as revenue
- Hiding or weakening important assumptions
- Presenting low-volume rating results without sufficient warning

The result supports the teardown hypothesis that a Genie Agent can help Product Managers investigate business data faster and reduce dependence on analysts for routine questions. However, its reliability depends heavily on governed definitions, precise instructions, curated data sources, and analyst review for ambiguous or financially sensitive questions.

The Agent should therefore be treated as an **assisted analytics tool**, not as an unsupervised source of business truth. It is suitable for exploration and first-pass analysis, but important decisions should still be checked against governed metrics and trusted SQL.
