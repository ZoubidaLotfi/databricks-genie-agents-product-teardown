# Genie Agent Setup and Smoke Test

## Purpose

This document records the configuration of the Wanderbricks Genie Agent and the results of a small smoke test.

The goal is to confirm that the Agent:

- Connects to the curated analysis views
- Understands the main business definitions
- Produces answers and supporting SQL
- Handles basic follow-up questions
- Reveals any immediate reliability issues before the full benchmark

This is not the formal benchmark. The full evaluation will be completed separately.

---

## Step 7: Create the Genie Agent

In Databricks:

```text
Genie Agents → New
```

Name the Agent:

```text
Wanderbricks Business Performance Agent
```

Use this description:

> Helps Wanderbricks managers explore booking performance, cancellations, completed payment amounts, destinations, properties, and customer ratings.

### Add the curated data sources

Add the following persistent views:

```text
workspace.wanderbricks_teardown.booking_analysis
workspace.wanderbricks_teardown.payment_analysis
workspace.wanderbricks_teardown.review_analysis
```

These views were selected instead of the raw Wanderbricks tables because they already contain the main joins, filters, and current-booking logic required for analysis.

| View | Purpose |
|---|---|
| `booking_analysis` | Current booking status, booking dates, booking value, property, destination, and country |
| `payment_analysis` | Payment attempts, completed payment amounts, property, destination, and country |
| `review_analysis` | Active reviews, ratings, property, destination, and country |

Using a small number of documented views reduces ambiguity and makes it less likely that the Agent will create incorrect joins or use outdated booking status values.

---

## Step 8: Add the business instructions

Add the following rules in the Agent configuration:

```text
Use booking_analysis as the source for current booking status.

The current_status column already contains the latest known booking status.

Define total bookings as the distinct count of booking_id.

Define completed bookings as bookings where current_status = 'completed'.

Define cancellation rate as:

cancelled bookings /
(completed bookings + cancelled bookings)

Exclude pending and confirmed bookings from the cancellation-rate denominator.

Use payment_analysis for completed payment amounts.

Only include payments where payment_status = 'completed'.

Do not describe booking_value as collected revenue.

Use review_analysis for customer ratings.

Deleted reviews have already been excluded.

When answering a time-based question, state whether the analysis uses booking creation date, check-in date, checkout date, payment date, or review date.

Mention when a metric uses a proposed teardown definition rather than a production-approved business definition.
```

These instructions are intended to give the Agent stable business rules that apply across conversations.

### Agent configuration evidence

![[Pasted image 20260804234317.png]]

---

## Step 9: Add example SQL queries

Example queries give the Agent question-and-SQL reference patterns.

The following six examples were added:

1. How many bookings are there?
2. What is the current booking-status distribution?
3. What is the cancellation rate?
4. Which destinations have the most bookings?
5. What is the completed payment amount by destination?
6. What is the average rating by destination?

The examples use the validated logic from:

```text
sql/01-core-business-metrics.sql
```

They reference the three persistent analysis views rather than the temporary `current_bookings` view.

### Example-query evidence

![[Pasted image 20260805001520.png]]

> [!NOTE]
> Example queries are part of the Agent configuration. They help the Agent generate SQL for similar questions. Benchmark questions should remain separate because they are used to evaluate the Agent rather than teach it.

---

## Step 10: Run a small smoke test

Eight basic questions were asked to confirm that the Agent functions and understands the main definitions.

### 1. How many total bookings are there?

![[Pasted image 20260805001714.png]]

### 2. How many bookings are completed?

![[Pasted image 20260805001802.png]]

### 3. What is the cancellation rate?

![[Pasted image 20260805001847.png]]

### 4. Which destination has the most bookings?

![[Pasted image 20260805002017.png]]

### 5. Show bookings by month

![[Pasted image 20260805002130.png]]

### 6. Which destinations have the highest completed payment amount?

![[Pasted image 20260805002305.png]]

### 7. What is the average rating by destination?

![[Pasted image 20260805002515.png]]

![[Pasted image 20260805002616.png]]

### 8. Which high-volume destinations have below-average ratings?

![[Pasted image 20260805002744.png]]

![[Pasted image 20260805002817.png]]

---

## Smoke-test findings

| # | Question | Agent result | SQL or code available? | Finding |
|---|---|---|---|---|
| 1 | How many total bookings are there? | **72,247 total bookings** | Not expanded in the screenshot | Correct. Matches the validated total from `booking_analysis`. |
| 2 | How many bookings are completed? | **36,835 completed bookings**, approximately 51% of total bookings | Not expanded in the screenshot | Correct. Matches the validated current booking state. |
| 3 | What is the cancellation rate? | **43.56%**, based on 28,428 cancelled and 36,835 completed bookings | Not expanded in the screenshot | Correct. The response explicitly excluded pending and confirmed bookings from the denominator. |
| 4 | Which destination has the most bookings? | **Phuket, Thailand with 7,292 bookings** | Not expanded in the screenshot | Correct. The Agent also returned the next four highest-volume destinations. |
| 5 | Show bookings by month | Monthly trend from December 2022 to July 2025, reaching **10,342 bookings in July 2025** | Yes, `Show code` was available | Correct. The Agent clearly stated that the analysis uses `booking_created_at`. |
| 6 | Which destinations have the highest completed payment amount? | Phuket ranked first with approximately **2.59M**, followed by Gold Coast and Mallorca | Yes, `Show code` was available | Ranking appears correct. However, the response added a `$` symbol and later called the metric **revenue**. The dataset does not specify currency, and completed payment amount has not been validated as accounting revenue. |
| 7 | What is the average rating by destination? | Ratings ranged from **2.80 to 3.30**, with most destinations close to 3.0 | Yes, `Show code` was available | The calculation appears correct. The initial ranking included destinations with very few reviews, such as Innsbruck with 14 reviews. Rating comparisons need a minimum review-volume rule. |
| 8 | Which high-volume destinations have below-average ratings? | Six destinations with at least 1,000 reviews were identified, with Berlin, Barcelona, and Rome among the lowest | Yes, `Show code` was available | The written answer addressed the question. The chart also displayed above-average destinations, and the Agent chose **1,000+ reviews** as the definition of high volume. That threshold should be documented as an assumption. |

---

## Summary of smoke-test results

| Check | Result |
|---|---|
| Questions answered | 8 of 8 |
| Total booking definition understood | Yes |
| Current booking state used | Yes |
| Completed booking definition followed | Yes |
| Cancellation-rate definition followed | Yes |
| Pending and confirmed bookings excluded from cancellation denominator | Yes |
| Booking month date field identified | Yes, booking creation date |
| Completed payments filtered correctly | Appears to be yes |
| Deleted reviews excluded | Appears to be yes through `review_analysis` |
| Review volume considered | Partially |
| Immediate reliability concerns | Currency assumption, use of “revenue,” and low-volume rating comparisons |

---

## What worked well

The strongest smoke-test results were:

- Total booking count
- Completed booking count
- Cancellation-rate calculation
- Destination booking ranking
- Monthly booking trend
- Use of the booking creation date for the monthly analysis
- Identification of below-average ratings among destinations with substantial review volume

The Agent successfully used the curated views and followed the main booking definitions.

---

## Issues identified before the benchmark

### 1. Unsupported currency assumption

The completed payment response displayed dollar symbols even though the sample data does not identify a currency.

The Agent should say:

```text
Completed payment amount
```

It should not automatically display:

```text
$
€
USD
EUR
```

unless the currency is explicitly available in the data or documented as an assumption.

### 2. Completed payment amount described as revenue

The Agent used the word **revenue** in part of the response.

For this teardown, the safer term is:

```text
Completed payment amount
```

The dataset has not been validated against accounting rules, refunds, taxes, fees, or recognized-revenue policies.

### 3. Rating rankings based on small samples

The general average-rating question ranked destinations with very few reviews.

Examples included:

- Innsbruck with 14 reviews
- Kitzbühel with 29 reviews
- St. Moritz with 41 reviews

These values may be mathematically correct but are not reliable comparisons against destinations with thousands of reviews.

Future rating comparisons should either:

- Apply a minimum review-count threshold, or
- Display the review count and clearly warn about small samples

### 4. Ambiguous definition of high volume

For the final question, the Agent interpreted high volume as:

```text
At least 1,000 reviews
```

This is a reasonable analysis assumption, but it was not explicitly defined in the original question.

The Agent should state the threshold whenever it makes this type of assumption.

### 5. Visualization included extra destinations

The answer to the below-average rating question correctly identified six below-average destinations.

However, the generated chart also displayed above-average destinations. The visualization therefore did not match the scope of the written answer exactly.

---

## Configuration improvements before the full benchmark

Add or strengthen the following instructions:

```text
Do not assign a currency symbol unless a currency field or documented currency definition is available.

Use the term completed payment amount. Do not call it revenue unless a production-approved revenue definition is available.

When ranking destinations by average rating, include review_count and warn when a result is based on a small number of reviews.

When the user asks for high-volume destinations without defining high volume, state the threshold used.

When generating a visualization, include only the records needed to answer the question.
```

These improvements should be treated as configuration refinements, not as benchmark results.

---

## Initial conclusion

The Genie Agent successfully answered all eight smoke-test questions and correctly applied the main booking definitions.

The Agent is functional and ready for structured benchmarking.

The smoke test also showed that correct SQL alone is not sufficient for a fully reliable answer. Wording, assumptions, sample size, units, and visualization scope can still introduce ambiguity.

The full benchmark should therefore evaluate:

- Numerical correctness
- SQL correctness
- Metric-definition compliance
- Handling of ambiguous questions
- Assumption disclosure
- Terminology
- Visualization relevance
- Consistency across repeated questions
- Response time
- Ability to answer follow-up questions
