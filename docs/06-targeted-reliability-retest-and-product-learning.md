# Targeted Reliability Retest & Product Learning

## Objective

This phase tests whether targeted instruction changes improve the Genie Agent's reliability on the failure patterns found in the first benchmark.

This is **not a full second benchmark**. Only the questions affected by the instruction changes were rerun.

> **Product goal:** test whether a small configuration change can improve reliability before considering broader product or governance changes.

The detailed question-level evidence is documented in the [research file](../research/06-targeted-instruction-retest-research.md).

---

## 1. Improvement hypothesis

The first benchmark showed that Genie was often technically correct but could still:

- Change explicit thresholds
- Invent currency context
- Reinterpret completed payments as revenue
- Miss small-sample risks
- Handle ambiguous terms inconsistently

### Hypothesis

> Stronger instructions should improve semantic reliability without changing the underlying data or benchmark logic.

This keeps the intervention controlled:

**Same data + same trusted answers + updated instructions**

---

## 2. What changed

The Agent instructions were strengthened around the highest-priority reliability risks.

| Improvement area | New guardrail |
| --- | --- |
| **Explicit thresholds** | Follow user-provided thresholds exactly |
| **Currency** | Do not add a currency unless it is governed or present in the data |
| **Revenue terminology** | Do not call completed payment amount revenue without an approved definition |
| **Small samples** | Include review counts and warn about weak samples |
| **Complete periods** | Treat the latest observed data month carefully |
| **Ambiguity** | State assumptions or ask for clarification |
| **Limitations** | Preserve important caveats in the final answer |

No data views or trusted SQL reference answers were changed.

---

## 3. Retest scope

**11 questions** were selected because they had failed, required analyst review, or showed an important instruction-following weakness.

| Area | Questions retested |
| --- | --- |
| Time and trends | Q10, Q11, Q12 |
| Segmentation and ranking | Q17, Q18 |
| Data quality and ambiguity | Q19, Q20, Q21, Q23 |
| Multi-step analysis | Q25, Q26 |

Core questions that were already reliable were not rerun.

This makes the retest a **targeted product experiment**, not a replacement for the original 30-question benchmark.

---

## 4. Headline results

| KPI | Before | Retest | Change |
| --- | ---: | ---: | ---: |
| Average score | **5.73 / 10** | **7.91 / 10** | **+2.18** |
| Reliable answers | **0** | **6** | **+6** |
| Failed answers | **4** | **2** | **-2** |

### Question movement

- **7 improved**
- **1 unchanged**
- **3 regressed**

The intervention improved the targeted subset substantially, but it did not solve every reliability issue.

---

## 5. What improved

### Explicit thresholds

Q17 and Q18 improved from **3/10 to 10/10**.

Genie correctly preserved the requested thresholds of:

- At least 1,000 bookings
- At least 1,000 reviews

### Revenue and currency handling

Q19 improved from **2/10 to 10/10**.

Genie stopped presenting completed payment amount as revenue and did not invent a currency.

Q20 also improved by removing unsupported currency speculation.

### Assumption handling

Across the retested questions, **assumption handling showed the largest improvement**.

This supports the idea that targeted instructions can improve how Genie handles business context.

---

## 6. What did not improve

Some issues remained even after the instructions were strengthened.

| Remaining issue | What happened |
| --- | --- |
| **Final-answer compliance** | Q10 still displayed an unsupported dollar symbol |
| **Complete-month logic** | Q12 still treated the latest observed month as complete |
| **Small-sample warning** | Q21 showed the review count but did not clearly explain the reliability risk |

This shows an important limitation:

> **An instruction can reduce a failure pattern without guaranteeing compliance in every answer.**

---

## 7. Regressions

Three questions scored lower after the update.

### Q10: payment trend

The Agent still used unsupported currency and described a fluctuating trend as consistently increasing.

### Q25: undefined high volume

The Agent recognized the ambiguity but applied no meaningful threshold, allowing very low-volume destinations into the result.

### Q26: averaging population

The final destination list was correct, but Genie silently changed the population used to calculate the comparison averages.

These regressions matter because they show that improving one instruction area can expose weaknesses somewhere else.

---

## 8. Product learning

The retest supports two conclusions at the same time:

### What instructions can do

Instructions can materially improve:

- Threshold compliance
- Business terminology
- Currency handling
- Assumption disclosure
- Some limitation handling

### What instructions cannot guarantee

Instructions alone do not fully control:

- Final-answer wording
- Analytical populations
- Time-boundary logic
- Small-sample interpretation
- Ambiguous quantitative terms

### Key product insight

> **Better instructions improve reliability, but they are not a complete governance layer.**

For a business-facing analytics Agent, reliability also depends on:

- Governed metric definitions
- Strong examples
- Regression testing
- Visible assumptions
- Analyst review for sensitive questions

---

## 9. Product iteration loop

This phase follows a simple product improvement cycle:

```text
Benchmark
   ↓
Identify failure patterns
   ↓
Prioritize the highest-risk issues
   ↓
Change one part of the configuration
   ↓
Retest affected questions
   ↓
Measure improvements and regressions
   ↓
Refine again
```

This keeps the teardown evidence-driven rather than making broad configuration changes without measuring their impact.

---

## 10. Next reliability priorities

Based on the retest, the next priorities are:

### P0: Protect analytical populations

Genie should not silently change which records or destinations are included when calculating averages.

### P0: Enforce explicit user constraints

Thresholds, units, and requested comparison logic should survive all the way to the final answer.

### P1: Improve time-boundary logic

Complete periods should be defined relative to the available dataset, not automatically to the current date.

### P1: Handle undefined quantitative terms safely

Terms such as **high volume** should trigger a clear assumption or clarification.

### P1: Make evidence quality visible

Small samples should include not only the count, but also a clear warning about reliability.

---

## 11. Definition of Done

This targeted improvement phase is complete when:

- [x] The main failure patterns from Benchmark Run 1 are prioritized.
- [x] Targeted instruction changes are applied without changing the underlying data.
- [x] The affected questions are rerun using the same scoring method.
- [x] Improvement is measured against the original answers.
- [x] Resolved issues are identified.
- [x] Unresolved issues are documented.
- [x] Regressions are captured rather than hidden.
- [x] New reliability priorities are defined.
- [x] The retest is clearly presented as a targeted experiment, not a full second benchmark.

---

## 12. Decision Gate

**Decision: keep the instruction improvements, but do not treat instructions as sufficient governance.**

The retest shows that the Agent can be improved through configuration, but important semantic risks remain.

The next phase should move from **Agent tuning** to a broader product view of the user experience, trust, and competitive positioning.

### Product conclusion from this experiment

> **Genie becomes more reliable with better instructions, but business trust still requires stronger semantic controls and visible context.**
