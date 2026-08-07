# Genie Quality Benchmark Research

## Research purpose

This file contains the detailed evidence behind the PM-facing Genie quality benchmark.

It preserves the benchmark method, scoring model, SQL Editor comparison, category results, question-level divergences, failure patterns, and recommended configuration changes.

---

## 1. Benchmark scope

The benchmark evaluates whether the **Wanderbricks Business Performance Agent** can answer business-data questions accurately, consistently, and transparently using:

- `booking_analysis`
- `payment_analysis`
- `review_analysis`

The Agent responses and generated SQL were compared with independent reference answers produced in the Databricks SQL Editor.

The full row-level evidence is stored in:

```text
research/day-4-benchmark-results.csv
```

---

## 2. Benchmark method

The benchmark contains **30 questions** divided into five categories:

| Category | Questions | Main capability tested |
| --- | ---: | --- |
| Core metric accuracy | 6 | Counts, booking status, cancellation rate, payments, and ratings |
| Time and trend analysis | 6 | Date selection, monthly grouping, trends, and complete-month logic |
| Segmentation and ranking | 6 | Destination, country, property type, ranking, and thresholds |
| Data quality and ambiguity | 6 | Currency, revenue, sample size, and undefined terminology |
| Multi-step and follow-up analysis | 6 | Cross-view comparisons, combined metrics, and judgment |

Each response was scored across five dimensions from `0` to `2`:

| Dimension | 0 | 1 | 2 |
| --- | --- | --- | --- |
| Numerical correctness | Wrong | Partially correct | Correct |
| SQL correctness | Invalid or wrong source | Works but has a weakness | Correct and appropriate |
| Definition compliance | Breaks business rules | Partially follows rules | Fully follows rules |
| Clarity | Misleading or unclear | Understandable with limitations | Clear and direct |
| Assumption handling | Unsupported assumption | Assumption not clearly stated | Assumption disclosed or clarification requested |

Maximum score per question: **10**.

| Total score | Interpretation |
| ---: | --- |
| 9–10 | Reliable |
| 7–8 | Acceptable with minor issues |
| 5–6 | Requires analyst review |
| 0–4 | Failed |

Agent response times were manually observed at approximately **29–60 seconds**. Exact timings were not recorded for every question.

---

## 3. SQL Editor reference

The Databricks SQL Editor was used to create the trusted reference for each question.

Its role was to establish:

- Independently calculated numerical result
- Correct source view and filters
- Applicable business definition
- Expected treatment of ambiguity

The Genie answer and generated SQL were then evaluated against that reference.

### Direct comparison

| Comparison with SQL Editor reference | Questions | Percentage |
| --- | ---: | ---: |
| Numerically correct | **24** | **80.0%** |
| Partially correct | **3** | **10.0%** |
| Numerically wrong | **3** | **10.0%** |
| SQL fully correct and appropriate | **18** | **60.0%** |
| SQL worked but had a weakness or could not be fully verified | **12** | **40.0%** |
| Invalid SQL or wrong source | **0** | **0.0%** |
| Fully followed business definitions | **18** | **60.0%** |
| Partially followed business definitions | **8** | **26.7%** |
| Broke business definitions | **4** | **13.3%** |

This distinction matters because executable SQL and a plausible number can still answer the wrong business question.

---

## 4. Overall results

| Metric | Result |
| --- | ---: |
| Questions evaluated | **30** |
| Average score | **7.87 / 10** |
| Questions scoring at least 7/10 | **25 of 30 (83.3%)** |
| Reliable responses | **15 (50.0%)** |
| Acceptable with minor issues | **10 (33.3%)** |
| Requires analyst review | **1 (3.3%)** |
| Failed responses | **4 (13.3%)** |
| Observed response time | **29–60 seconds** |

---

## 5. Results by category

| Category | Average score | Reliable | Acceptable | Analyst review | Failed |
| --- | ---: | ---: | ---: | ---: | ---: |
| Core metric accuracy | **9.00 / 10** | 4 | 2 | 0 | 0 |
| Time and trend analysis | **7.17 / 10** | 2 | 2 | 1 | 1 |
| Segmentation and ranking | **7.17 / 10** | 3 | 1 | 0 | 2 |
| Data quality and ambiguity | **7.50 / 10** | 2 | 3 | 0 | 1 |
| Multi-step and follow-up analysis | **8.50 / 10** | 4 | 2 | 0 | 0 |

### Interpretation

**Core metric accuracy** was strongest. The Agent reliably handled total bookings, completed bookings, cancellation rate, completed payment amount, and destination-level counts.

**Time and trend analysis** was less consistent. It selected appropriate date fields in most cases but mishandled complete-month logic and sometimes overstated trend direction.

**Segmentation and ranking** included two important failures because explicit thresholds of 1,000 were replaced by 10.

**Data quality and ambiguity** was mixed. The Agent handled some ambiguous terms well but failed the revenue question by treating completed payment amount as revenue and assuming dollars.

**Multi-step analysis** performed well when the requested criteria were sufficiently clear.

---

## 6. Results by scoring dimension

| Dimension | Average | Percentage of maximum |
| --- | ---: | ---: |
| Numerical correctness | **1.70 / 2** | **85.0%** |
| SQL correctness | **1.60 / 2** | **80.0%** |
| Definition compliance | **1.47 / 2** | **73.3%** |
| Clarity | **1.63 / 2** | **81.7%** |
| Assumption handling | **1.47 / 2** | **73.3%** |

The strongest dimension was numerical correctness.

The weakest dimensions were definition compliance and assumption handling.

---

## 7. Key Editor vs Agent divergences

| Question | SQL Editor reference | Genie Agent response | Why it matters |
| --- | --- | --- | --- |
| Q12: latest three complete months | April, May, June 2025 | May, June, July 2025 | The latest observed month was included without proving it was complete |
| Q17: lowest cancellation rate with at least 1,000 bookings | Used 1,000-booking threshold | Used 10 terminal bookings | Explicit user threshold was replaced |
| Q18: lowest rating with at least 1,000 reviews | Used 1,000-review threshold | Used 10 reviews | Ranking changed because the threshold changed |
| Q19: Wanderbricks revenue | No approved revenue definition | `$25,296,456.50` as revenue | Completed payments were reinterpreted as revenue and currency was assumed |
| Q25: high volume with below-average ratings | Benchmark threshold of at least 1,000 bookings | Above median, more than 1,062 bookings | The assumption was disclosed but changed the benchmark population |

---

## 8. Strongest responses

Perfect-score questions:

- **Q04**: cancellation rate
- **Q05**: total completed payment amount
- **Q13**: destination with most bookings
- **Q14**: top five countries by booking volume
- **Q15**: property type with most completed bookings
- **Q22**: high-volume destination with lowest rating
- **Q24**: active bookings

These results indicate that the Agent is strongest when:

- The metric is clearly defined
- The required view is obvious
- The terminology already exists in the instructions
- The calculation is a direct aggregation or ranking
- Financial interpretation or an undefined threshold is not required

---

## 9. Main failure patterns

### 9.1 Explicit thresholds were replaced

For Q17 and Q18, the user explicitly required:

```text
At least 1,000 bookings
At least 1,000 reviews
```

The Agent replaced both thresholds with `10`.

The SQL executed, but the Agent answered a different question.

### 9.2 Completed payment amount was presented as revenue

For Q19, the Agent returned:

```text
$25,296,456.50 in revenue
```

The data only supports **completed payment amount**. There is no production-approved revenue definition or confirmed currency.

### 9.3 Unsupported currency symbols appeared

Dollar symbols appeared in several responses even though the payment data contains no currency field.

### 9.4 Complete-month logic was inconsistent

For Q12, July 2025 should have been excluded because it was the latest observed month and might be incomplete.

The Agent included July and omitted the requested month-over-month comparison.

### 9.5 Small samples were not always highlighted

For Q21, Innsbruck had the highest raw average rating at `3.30`, but this was based on only `14 reviews`.

The review count was shown but the small-sample risk was not clearly highlighted.

### 9.6 Some visualizations reduced clarity

Several charts combined metrics with very different scales, making smaller metrics difficult to interpret.

---

## 10. Questions requiring review or classified as failures

| Question | Score | Main issue |
| --- | ---: | --- |
| Q10: completed payment trend | **5/10** | Correct monthly amounts, but unsupported dollar symbol and overstated trend |
| Q12: latest three complete months | **4/10** | Included July, omitted requested changes, inconsistent rerun |
| Q17: lowest cancellation rate, at least 1,000 bookings | **3/10** | Replaced 1,000-booking threshold with 10 terminal bookings |
| Q18: lowest average rating, at least 1,000 reviews | **3/10** | Replaced 1,000-review threshold with 10 reviews |
| Q19: Wanderbricks revenue | **2/10** | Reinterpreted completed payment amount as revenue and assumed dollars |

---

## 11. Recommended configuration changes

Before retesting, strengthen the Agent instructions with:

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

These changes should be applied only after Benchmark Run 1 has been documented so the retest remains comparable.

---

## 12. Research conclusion

The benchmark average was **7.87 / 10**, with **25 of 30 questions (83.3%)** receiving a reliable or acceptable score.

The Agent performed well on clearly defined metrics, direct aggregations, rankings, and multi-view comparisons.

Its main weakness was **semantic reliability**, not SQL execution.

The benchmark therefore supports a targeted configuration-improvement phase followed by a controlled retest of the affected questions.
