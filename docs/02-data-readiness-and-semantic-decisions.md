# Data Readiness & Semantic Decisions

## Objective

Before building the dashboard or testing Databricks Genie, I needed to make sure the data foundation was clear enough to support reliable product decisions.

This phase focuses on **data readiness**, **metric alignment**, and **semantic clarity** rather than building a production-grade data model.

The detailed technical analysis, schemas, validation results, and SQL are documented in the [research file](../research/02-data-semantic-model-research.md).

## 1. Product goal

The Wanderbricks scenario requires a manager to investigate:

- Booking performance
- Cancellations
- Collected payment amounts
- Destination and property performance
- Customer satisfaction

The data foundation therefore needs to support these questions consistently across both the dashboard baseline and the Genie Agent.

## 2. Scope decision

To keep the teardown focused, I limited the first version to six core tables:

| Data area | Table | Why it matters |
| --- | --- | --- |
| Bookings | `bookings` | Original reservation data |
| Booking changes | `booking_updates` | Latest known booking state |
| Properties | `properties` | Property-level performance |
| Destinations | `destinations` | Geographic comparisons |
| Payments | `payments` | Completed payment amounts |
| Reviews | `reviews` | Customer satisfaction |

### Out of scope

The first version does not cover:

- Marketing attribution
- Customer segmentation
- Support-ticket analysis
- Clickstream behavior
- Machine-learning predictions
- Production-grade financial reconciliation

This keeps the scope aligned with the teardown question and avoids adding data that does not directly support the first product evaluation.

## 3. Data-readiness decisions

The preparation phase surfaced several issues that could directly affect product trust.

| Finding | Product risk | Decision |
| --- | --- | --- |
| Main booking status is stale | Dashboard or Genie could report the wrong current booking state | Reconstruct current status using the latest booking update |
| Payment retries exist | Counting payment rows could overcount paying bookings | Use completed payments and distinct booking IDs where needed |
| `bookings.total_amount` is not collected revenue | Revenue-style questions could use the wrong amount | Treat it as booking value, not collected payment amount |
| Reviews are incomplete by nature | Average rating could be interpreted as representing all customers | Treat ratings as a satisfaction indicator based on reviewers |
| Monetary values may require rounding | Small decimal differences could create inconsistent outputs | Display monetary values to two decimal places |

The most important finding was the stale booking status. More than 91% of original pending and confirmed bookings already had checkout dates in the past, so the original status field was not reliable enough for current-state analysis.

## 4. Metric contracts

Instead of allowing the dashboard and Genie to interpret metrics differently, I defined a small set of **metric contracts** for the teardown.

| Metric | Working definition | Key guardrail |
| --- | --- | --- |
| **Total bookings** | Distinct bookings | Use the reconstructed booking dataset |
| **Completed bookings** | Bookings whose latest known status is completed | Use the latest known booking state |
| **Cancellation rate** | Cancelled bookings / completed + cancelled bookings | Pending and confirmed bookings are excluded |
| **Collected payment amount** | Sum of completed payment amounts | Do not use booking `total_amount` as collected revenue |
| **Average rating** | Average rating from non-deleted reviews | Represents reviewers, not all customers |

These are **working definitions for the teardown**, not production-approved financial or operational metrics.

## 5. Semantic alignment

A core product risk is that technically correct SQL can still answer the wrong business question.

To reduce that risk, the following terms are kept explicit:

- **Booking value**: amount attached to the booking
- **Collected payment amount**: completed payment amount
- **Current booking state**: latest known booking status
- **Terminal booking**: completed or cancelled booking
- **Customer satisfaction**: rating from a non-deleted review
- **Cancellation rate**: cancelled terminal bookings divided by all terminal bookings

This creates a shared semantic layer for the dashboard and Genie evaluation.

## 6. Assumption log

The following assumptions are accepted for this teardown:

1. The latest booking update represents the current booking state.
2. The original booking row is used when no update exists.
3. `completed` and `cancelled` are terminal statuses.
4. Pending and confirmed bookings are excluded from the cancellation-rate denominator.
5. A completed payment represents collected payment amount.
6. Deleted reviews are excluded from satisfaction metrics.
7. Refunds, disputes, reversals, and accounting reconciliation are outside the scope.
8. These definitions are designed for product testing, not financial certification.

Keeping these assumptions visible is important because they may affect how Genie interprets future questions.

## 7. Key risks addressed

The data-preparation phase identified several risks that could affect the
dashboard and Genie evaluation.

| Risk | How it was addressed |
| --- | --- |
| **Stale booking status** | Current booking state was reconstructed using the latest booking update. |
| **Metric ambiguity** | Working definitions were created for bookings, cancellations, payments, and ratings. |
| **Booking value vs collected payment** | The two concepts were separated to avoid treating booking amount as collected revenue. |
| **Payment retries** | Completed payments and distinct bookings were used where appropriate to avoid overcounting. |
| **Review bias** | Ratings were treated as feedback from reviewers, not as a measure of the full customer population. |
| **Missing business context** | Important assumptions such as date fields, cancellation logic, and metric limitations were documented for later testing. |

These decisions reduce avoidable data and semantic errors before comparing the
dashboard baseline with the Genie Agent.

## 8. Product principle for the next phases

The dashboard baseline and Genie Agent should use the **same underlying metric definitions and data rules**.

This creates a fairer comparison:

> When the dashboard and Genie disagree, the investigation should focus on the product behavior rather than an avoidable difference in metric logic.

## 9. Definition of Done

This data-readiness phase is complete when:

- [x] The minimum data scope is defined.
- [x] The six core tables needed for the teardown are selected.
- [x] The main table relationships are understood.
- [x] The stale booking-status issue is identified and a reconstruction rule is defined.
- [x] The five core metrics have working definitions.
- [x] Important business terms are aligned across the teardown.
- [x] Key data-quality risks are documented.
- [x] Assumptions and limitations are visible.
- [x] Open semantic questions are captured in a risk backlog.
- [x] The dashboard and Genie can be evaluated against the same data and metric foundation.
- [x] The technical implementation and evidence are separated into a dedicated research document.

## 10. Decision Gate

**Decision: proceed to the dashboard baseline.**

The data foundation is clear enough to build a controlled baseline for comparison.

The dashboard will act as the first reference experience for the Product Manager and will establish how the selected business metrics are presented before the Genie Agent is configured and evaluated.

### Success criteria for moving forward

The dashboard baseline should:

- Use the agreed metric definitions.
- Use the reconstructed current booking state.
- Make the main business KPIs easy to understand.
- Support the core Wanderbricks management questions.
- Provide a consistent reference point for later Genie benchmarking.
