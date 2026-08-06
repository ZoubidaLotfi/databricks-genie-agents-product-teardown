# Targeted Instruction-Improvement Retest

## Objective

This retest evaluates whether updated Genie Agent instructions corrected the failure patterns identified during the original 30-question benchmark.

This was a **targeted retest**, not a complete second benchmark run. Only questions affected by the instruction changes were rerun through the Genie Agent.

The SQL Editor reference answers were not rerun because:

- The underlying analysis views were unchanged
- The dataset was unchanged
- The trusted SQL definitions and results remained the comparison baseline

The original benchmark remains documented in:

```text
docs/06-quality-benchmark.md
research/day-4-benchmark-results.csv
```

---

## Instruction changes tested

The existing Agent instructions were retained and expanded with these reliability rules:

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

---

## Retest scope

Eleven questions were selected because they had failed, required analyst review, or exposed a material instruction-following weakness in the original benchmark.

| Category | Questions retested |
|---|---|
| Time and trend analysis | Q10, Q11, Q12 |
| Segmentation and ranking | Q17, Q18 |
| Data quality and ambiguity | Q19, Q20, Q21, Q23 |
| Multi-step and follow-up analysis | Q25, Q26 |

Core metric questions that had already performed reliably were not rerun.

---

## Scoring method

The same scoring rubric from the original benchmark was used.

| Dimension | 0 | 1 | 2 |
|---|---|---|---|
| Numerical correctness | Wrong | Partially correct | Correct |
| SQL correctness | Invalid or wrong source | Works but has a weakness | Correct and appropriate |
| Definition compliance | Breaks business rules | Partially follows rules | Fully follows rules |
| Clarity | Misleading or unclear | Understandable with limitations | Clear and direct |
| Assumption handling | Unsupported assumption | Assumption not clearly stated | Assumption disclosed or clarification requested |

| Total score | Interpretation |
|---:|---|
| 9–10 | Reliable |
| 7–8 | Acceptable with minor issues |
| 5–6 | Requires analyst review |
| 0–4 | Failed |

---

## Overall targeted-retest results

| Metric | Original answers for retested questions | Targeted retest | Change |
|---|---:|---:|---:|
| Questions evaluated | 11 | 11 | 0 |
| Average score | **5.73/10** | **7.91/10** | **+2.18** |
| Reliable | **0** | **6** | **+6** |
| Acceptable with minor issues | **6** | **1** | **-5** |
| Requires analyst review | **1** | **2** | **+1** |
| Failed | **4** | **2** | **-2** |

Question-level movement:

| Outcome | Questions | Count |
|---|---|---:|
| Improved | Q11, Q17, Q18, Q19, Q20, Q21, Q23 | **7** |
| Unchanged | Q12 | **1** |
| Regressed | Q10, Q25, Q26 | **3** |

The targeted subset improved substantially, but the result should not be presented as a complete second benchmark score because the other 19 questions were not rerun.

---

## Results by category

| Category | Original targeted average | Retest average | Change |
|---|---:|---:|---:|
| Time and trend analysis | **5.67/10** | **6.00/10** | **+0.33** |
| Segmentation and ranking | **3.00/10** | **10.00/10** | **+7.00** |
| Data quality and ambiguity | **6.25/10** | **9.25/10** | **+3.00** |
| Multi-step and follow-up analysis | **7.50/10** | **6.00/10** | **-1.50** |

The strongest improvement occurred in **segmentation and ranking**, where the Agent followed explicit thresholds correctly after the instruction update.

The weakest retest area was **multi-step analysis**, where new semantic and aggregation weaknesses appeared despite clearer instructions.

---

## Results by scoring dimension

| Dimension | Original average | Retest average | Change |
|---|---:|---:|---:|
| Numerical correctness | **1.27/2** | **1.64/2** | **+0.36** |
| SQL correctness | **1.36/2** | **1.64/2** | **+0.27** |
| Definition compliance | **0.91/2** | **1.45/2** | **+0.55** |
| Clarity | **1.36/2** | **1.64/2** | **+0.27** |
| Assumption handling | **0.82/2** | **1.55/2** | **+0.73** |

The largest improvement was in **assumption handling**, followed by **definition compliance**. This aligns with the purpose of the new instructions.

---

## Question-level comparison

| Question | Original | Retest | Change | Retest outcome | Main finding |
|---|---:|---:|---:|---|---|
| Q10: completed payment amounts by month | 5 | 4 | -1 | Failed | Correct source and totals, but still used an unsupported dollar symbol, described a non-monotonic trend as consistently increasing, and did not calculate month-over-month changes. |
| Q11: month with highest cancellation rate | 8 | 10 | +2 | Reliable | Preserved the small-sample limitation and clearly stated that the 100% rate was based on only three terminal bookings. |
| Q12: latest three complete months | 4 | 4 | 0 | Failed | Used the current calendar month rather than the latest observed data month, so July 2025 was still incorrectly treated as complete. |
| Q17: lowest cancellation rate with at least 1,000 bookings | 3 | 10 | +7 | Reliable | Followed the explicit 1,000-booking threshold exactly and returned the trusted ranking. |
| Q18: lowest ratings with at least 1,000 reviews | 3 | 10 | +7 | Reliable | Followed the explicit 1,000-review threshold exactly and included review counts. |
| Q19: Wanderbricks revenue | 2 | 10 | +8 | Reliable | Refused to invent a revenue definition and correctly offered completed payment amount as a separate supported metric. |
| Q20: payment currency | 8 | 9 | +1 | Reliable | Removed currency speculation and symbols. Calling the question irrelevant reduced clarity slightly. |
| Q21: highest average rating | 7 | 8 | +1 | Acceptable | Included the 14-review sample size but did not explicitly explain that the sample was too small to support a strong business conclusion. |
| Q23: best-performing destination | 8 | 10 | +2 | Reliable | Clearly defined performance as average rating and preserved the small-sample warning. |
| Q25: high booking volume with below-average ratings | 7 | 6 | -1 | Analyst review | Recognized ambiguity but applied no high-volume threshold, so destinations with very low booking counts remained in the SQL result. |
| Q26: above-average cancellations and payment amounts | 8 | 6 | -2 | Analyst review | Returned the correct 15 destinations but changed the averaging population by calculating both averages only across destinations present in both datasets. |

---

## Issues resolved

### Explicit thresholds

The instruction:

```text
Follow explicit numerical thresholds exactly.
```

successfully corrected Q17 and Q18.

The Agent stopped substituting thresholds of 10 and correctly used:

```text
At least 1,000 bookings
At least 1,000 reviews
```

### Revenue and currency governance

The updated instructions successfully corrected the most serious financial-semantic failure.

For Q19, the Agent no longer called completed payment amount revenue and did not assign a currency.

For Q20, it correctly stated that no currency could be determined from the available schema.

### Preserving limitations

Q11 improved from 8/10 to 10/10 because the final answer preserved the important small-sample limitation discovered during inspection.

Q23 also preserved the low review-count warning when interpreting performance through average ratings.

---

## Issues not resolved

### Final-answer compliance is not guaranteed

Q10 still used a dollar symbol even though the updated instructions explicitly prohibited unsupported currency symbols.

This demonstrates that adding an instruction does not guarantee that the final narrative will follow it.

### Complete-month logic remained incorrect

Q12 interpreted a complete month relative to `CURRENT_DATE`.

The benchmark definition required comparing against the **latest observed data month**, because the dataset ended in July 2025. The Agent therefore continued to include a potentially incomplete final data month.

### Small-sample warnings remained inconsistent

Q21 displayed the review count but did not explicitly state that 14 reviews are insufficient for a strong comparison.

Showing a sample size is not equivalent to explaining its reliability limitation.

---

## Regressions and new weaknesses

### Undefined high volume was handled too weakly

For Q25, the Agent acknowledged that high booking volume was ambiguous but interpreted it as any destination with bookings.

The result included destinations with as few as five bookings. This was weaker than the original run, which at least applied a measurable median threshold.

A stronger instruction is needed:

```text
When an undefined quantitative term such as "high volume" is used, do not
interpret it as any non-zero value. Ask for a threshold or state and apply a
meaningful measurable threshold directly in the SQL.
```

### Average populations changed silently

For Q26, the Agent calculated both averages only across destinations appearing in both booking and payment results.

The trusted reference calculated each average independently across its relevant destination-level dataset.

The qualifying list remained unchanged, but the reported thresholds were wrong:

| Metric | Trusted reference | Retest |
|---|---:|---:|
| Average destination cancellation rate | 42.87% | 42.89% |
| Average destination completed payment amount | 616,986.74 | 633,111.02 |

This is an example of SQL that executes and returns plausible results while silently changing the analytical population.

---

## Response-time observations

Only three retest response times were manually recorded:

| Question | Response time |
|---|---:|
| Q23 | 3 minutes |
| Q25 | 1.24 minutes |
| Q26 | 1.7 minutes |

These recorded retest times were slower than the approximately 29-to-60-second range observed during the original benchmark.

The sample is too small to conclude that the instruction update caused slower responses, but response latency should be tracked in future tests.

---

## Recommended next instruction additions

The retest shows that the current reliability rules should be retained and supplemented with more specific analytical checks:

```text
When the user asks how a metric changed over time, return the previous-period
value, absolute change, and percentage change when possible.

Only describe a monthly change between consecutive months.

Do not describe a trend as consistently increasing or decreasing unless every
relevant consecutive period moves in that direction.

Define complete months relative to the latest observed data date when the data
does not extend to the current month.

When an undefined quantitative term such as "high volume" is used, ask for a
threshold or state and apply a meaningful measurable threshold. Never treat
any non-zero value as high volume.

Calculate comparison averages over the intended population for each metric.
Do not silently restrict the population through an inner join.

Calculate averages from unrounded values and round only the displayed result.

Before producing the final answer, verify that no unsupported currency symbol
has been added and that all limitations found during inspection remain visible.
```

---

## Final conclusion

The targeted instruction-improvement retest raised the selected-question average from **5.73/10 to 7.91/10**.

The intervention was especially effective for:

- Explicit numerical thresholds
- Revenue versus payment terminology
- Missing-currency handling
- Preserving some important limitations
- Clarifying ambiguous business terms

However, the retest also showed that instruction updates are not sufficient on their own.

The Agent continued to struggle with:

- Dataset-relative time boundaries
- Final-answer compliance with currency restrictions
- Consistent small-sample warnings
- Choosing meaningful assumptions for undefined quantitative terms
- Preserving the correct population when averaging across multiple datasets

The result supports a more precise product conclusion:

> Better instructions materially improve Genie Agent reliability, but they do not eliminate the need for governed metric definitions, representative examples, regression testing, and analyst review.

This targeted retest demonstrates a controlled product-improvement cycle:

1. Benchmark the Agent
2. Identify failure patterns
3. Update the instructions
4. Rerun the affected questions
5. Measure resolved issues and regressions
6. Refine the governance layer again

The retest should be presented as evidence of **instruction-level improvement**, not as a complete second benchmark of the entire 30-question set.
