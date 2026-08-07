# Targeted Instruction Retest Research

## Research purpose

This file contains the detailed evidence behind the PM-facing targeted reliability retest.

It preserves the instruction changes, retest scope, scoring method, question-level results, resolved issues, regressions, response-time observations, and recommended instruction additions.

---

## 1. Retest objective

This retest evaluates whether updated Genie Agent instructions corrected the failure patterns identified during the original 30-question benchmark.

This was a **targeted retest**, not a complete second benchmark run.

Only questions affected by the instruction changes were rerun.

The SQL Editor reference answers were not rerun because:

- The underlying analysis views were unchanged
- The dataset was unchanged
- The trusted SQL definitions and results remained the comparison baseline

---

## 2. Instruction changes tested

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

## 3. Retest scope

Eleven questions were selected because they had failed, required analyst review, or exposed a material instruction-following weakness in the original benchmark.

| Category | Questions retested |
| --- | --- |
| Time and trend analysis | Q10, Q11, Q12 |
| Segmentation and ranking | Q17, Q18 |
| Data quality and ambiguity | Q19, Q20, Q21, Q23 |
| Multi-step and follow-up analysis | Q25, Q26 |

Core metric questions that had already performed reliably were not rerun.

---

## 4. Scoring method

The same scoring rubric from the original benchmark was used.

| Dimension | 0 | 1 | 2 |
| --- | --- | --- | --- |
| Numerical correctness | Wrong | Partially correct | Correct |
| SQL correctness | Invalid or wrong source | Works but has a weakness | Correct and appropriate |
| Definition compliance | Breaks business rules | Partially follows rules | Fully follows rules |
| Clarity | Misleading or unclear | Understandable with limitations | Clear and direct |
| Assumption handling | Unsupported assumption | Assumption not clearly stated | Assumption disclosed or clarification requested |

| Total score | Interpretation |
| ---: | --- |
| 9–10 | Reliable |
| 7–8 | Acceptable with minor issues |
| 5–6 | Requires analyst review |
| 0–4 | Failed |

---

## 5. Overall results

| Metric | Original answers for retested questions | Targeted retest | Change |
| --- | ---: | ---: | ---: |
| Questions evaluated | 11 | 11 | 0 |
| Average score | **5.73/10** | **7.91/10** | **+2.18** |
| Reliable | **0** | **6** | **+6** |
| Acceptable with minor issues | **6** | **1** | **-5** |
| Requires analyst review | **1** | **2** | **+1** |
| Failed | **4** | **2** | **-2** |

### Question movement

| Outcome | Questions | Count |
| --- | --- | ---: |
| Improved | Q11, Q17, Q18, Q19, Q20, Q21, Q23 | **7** |
| Unchanged | Q12 | **1** |
| Regressed | Q10, Q25, Q26 | **3** |

The targeted subset improved substantially, but this should not be presented as a complete second benchmark because the other 19 questions were not rerun.

---

## 6. Results by category

| Category | Original targeted average | Retest average | Change |
| --- | ---: | ---: | ---: |
| Time and trend analysis | **5.67/10** | **6.00/10** | **+0.33** |
| Segmentation and ranking | **3.00/10** | **10.00/10** | **+7.00** |
| Data quality and ambiguity | **6.25/10** | **9.25/10** | **+3.00** |
| Multi-step and follow-up analysis | **7.50/10** | **6.00/10** | **-1.50** |

The strongest improvement occurred in segmentation and ranking.

The weakest retest area was multi-step analysis, where new semantic and aggregation weaknesses appeared.

---

## 7. Results by scoring dimension

| Dimension | Original average | Retest average | Change |
| --- | ---: | ---: | ---: |
| Numerical correctness | **1.27/2** | **1.64/2** | **+0.36** |
| SQL correctness | **1.36/2** | **1.64/2** | **+0.27** |
| Definition compliance | **0.91/2** | **1.45/2** | **+0.55** |
| Clarity | **1.36/2** | **1.64/2** | **+0.27** |
| Assumption handling | **0.82/2** | **1.55/2** | **+0.73** |

The largest improvement was in assumption handling, followed by definition compliance.

---

## 8. Question-level comparison

| Question | Original | Retest | Change | Retest outcome | Main finding |
| --- | ---: | ---: | ---: | --- | --- |
| Q10: completed payment amounts by month | 5 | 4 | -1 | Failed | Correct source and totals, but still used an unsupported dollar symbol, described a non-monotonic trend as consistently increasing, and did not calculate month-over-month changes |
| Q11: month with highest cancellation rate | 8 | 10 | +2 | Reliable | Preserved the small-sample limitation and stated that the 100% rate was based on only three terminal bookings |
| Q12: latest three complete months | 4 | 4 | 0 | Failed | Used the current calendar month rather than the latest observed data month |
| Q17: lowest cancellation rate with at least 1,000 bookings | 3 | 10 | +7 | Reliable | Followed the explicit 1,000-booking threshold exactly |
| Q18: lowest ratings with at least 1,000 reviews | 3 | 10 | +7 | Reliable | Followed the explicit 1,000-review threshold and included review counts |
| Q19: Wanderbricks revenue | 2 | 10 | +8 | Reliable | Refused to invent a revenue definition and offered completed payment amount as a supported metric |
| Q20: payment currency | 8 | 9 | +1 | Reliable | Removed currency speculation and symbols |
| Q21: highest average rating | 7 | 8 | +1 | Acceptable | Included the 14-review sample size but did not clearly explain the weakness of the sample |
| Q23: best-performing destination | 8 | 10 | +2 | Reliable | Defined performance as average rating and preserved the small-sample warning |
| Q25: high booking volume with below-average ratings | 7 | 6 | -1 | Analyst review | Recognized ambiguity but applied no meaningful high-volume threshold |
| Q26: above-average cancellations and payment amounts | 8 | 6 | -2 | Analyst review | Returned the correct 15 destinations but changed the averaging population |

---

## 9. Issues resolved

### 9.1 Explicit thresholds

The instruction:

```text
Follow explicit numerical thresholds exactly.
```

successfully corrected Q17 and Q18.

The Agent correctly used:

```text
At least 1,000 bookings
At least 1,000 reviews
```

### 9.2 Revenue and currency governance

Q19 no longer described completed payment amount as revenue and did not assign a currency.

Q20 correctly stated that no currency could be determined from the available schema.

### 9.3 Preserving limitations

Q11 improved from 8/10 to 10/10 because the final answer preserved the small-sample limitation.

Q23 also preserved the low review-count warning.

---

## 10. Issues not resolved

### 10.1 Final-answer compliance

Q10 still used a dollar symbol even though the updated instructions prohibited unsupported currency symbols.

This shows that adding an instruction does not guarantee final-answer compliance.

### 10.2 Complete-month logic

Q12 interpreted a complete month relative to `CURRENT_DATE`.

The benchmark definition required comparison against the latest observed data month.

### 10.3 Small-sample warnings

Q21 displayed the review count but did not explicitly explain that 14 reviews are too weak for a strong comparison.

Showing sample size is not the same as explaining its reliability implication.

---

## 11. Regressions and new weaknesses

### 11.1 Undefined high volume

For Q25, Genie acknowledged that high booking volume was ambiguous but effectively treated any positive booking count as sufficient.

The result included destinations with as few as five bookings.

A stronger rule is needed:

```text
When an undefined quantitative term such as "high volume" is used, do not
interpret it as any non-zero value. Ask for a threshold or state and apply a
meaningful measurable threshold directly in the SQL.
```

### 11.2 Average populations changed silently

For Q26, Genie calculated both averages only across destinations appearing in both booking and payment results.

The trusted reference calculated each average independently over its relevant population.

| Metric | Trusted reference | Retest |
| --- | ---: | ---: |
| Average destination cancellation rate | 42.87% | 42.89% |
| Average destination completed payment amount | 616,986.74 | 633,111.02 |

The final qualifying list remained unchanged, but the thresholds were wrong.

This is another example of plausible SQL silently changing the analytical population.

---

## 12. Response-time observations

Only three retest response times were manually recorded:

| Question | Response time |
| --- | ---: |
| Q23 | 3 minutes |
| Q25 | 1.24 minutes |
| Q26 | 1.7 minutes |

These were slower than the approximately 29-to-60-second range observed during the original benchmark.

The sample is too small to conclude that the instruction update caused the slowdown.

---

## 13. Recommended instruction additions

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

## 14. Research conclusion

The targeted retest raised the selected-question average from **5.73/10 to 7.91/10**.

Seven questions improved, one was unchanged, and three regressed.

The strongest gains were in explicit-threshold compliance, revenue terminology, currency handling, and assumption management.

The retest also showed that instruction updates alone do not guarantee semantic reliability.

The result should therefore be presented as evidence of **instruction-level improvement**, not as a complete second benchmark of the entire 30-question set.
