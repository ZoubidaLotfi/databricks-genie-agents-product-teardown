# Dashboard Baseline

## Purpose

The completed Wanderbricks dashboard provides a fixed baseline for comparing a traditional dashboard with the Databricks Genie Agent.

The dashboard is designed to answer a predefined set of business questions using validated datasets and visualizations.

The completed dashboard provides a fixed baseline for comparing the dashboard with the Genie Agent.

The dashboard is designed to answer a predefined set of business questions using validated datasets and visualizations.

### Dashboard evidence
KPI cards:
![Wanderbricks dashboard baseline](../images/day-3/KPI cards.png)

Visualization charts:
![Wanderbricks dashboard baseline](../images/day-3/dashboard-baseline.png)

### Questions answered by the dashboard

| Business question | Dashboard element | Baseline result |
|---|---|---|
| How many bookings exist? | Total bookings KPI | 72,247 |
| How many bookings were completed? | Completed bookings KPI | 36,835 |
| How many bookings were cancelled? | Executive summary dataset | 28,428 |
| What is the cancellation rate? | Cancellation-rate KPI | 43.56% |
| What is the completed payment amount? | Completed payment amount KPI | Approximately 25.3M, with currency unspecified |
| Which destinations have the most bookings? | Top 10 destinations by bookings chart | Phuket, Gold Coast, Mallorca, Paris, and Abu Dhabi are among the highest-volume destinations |
| How are bookings changing over time? | Bookings by month line chart | Booking volume increases strongly over the available period |
| Which high-volume destinations have the highest cancellation rates? | Cancellation-rate comparison chart | Cancellation rates are closely clustered across high-volume destinations |
| Which destinations differ most from the overall average rating? | Rating-difference chart | Destination ratings vary only slightly from the overall average |

### What the dashboard answers well

The dashboard answers questions that were defined before it was built.

It provides quick access to:

- Overall booking volume
- Completed and cancelled booking counts
- The proposed cancellation rate
- Completed payment amount
- Booking trends over time
- Destination booking performance
- Destination cancellation comparisons
- Destination rating comparisons

The dashboard is useful when users repeatedly need the same metrics and comparisons.

### Dashboard limitations

The dashboard answers predefined questions, but it does not easily answer every new follow-up question.

For example, a user cannot immediately ask:

- Why did bookings increase during a particular month?
- Which property types have the highest cancellation rate?
- How do payment methods differ between countries?
- Which destinations combine high booking volume with low ratings?
- Are cancelled bookings associated with specific check-in periods?

Answering these questions would require:

1. Creating another dataset or changing an existing query
2. Adding another visualization
3. Updating and republishing the dashboard

The dashboard therefore provides reliable and consistent answers, but it offers limited flexibility for unplanned business questions.

### Filter limitations

The dashboard contains the following interactive filters:

- Country
- Destination
- Booking month

Because the dashboard uses several separate datasets, not every filter affects every visualization.

For example:

- Country and Destination primarily affect destination-based visualizations
- Booking month primarily affects the monthly booking trend
- The KPI cards display overall values unless their dataset is redesigned to include filterable dimensions

This is an important dashboard design limitation and should be considered when comparing it with the Genie Agent.

### Baseline conclusion

The dashboard is effective for monitoring a fixed set of validated business metrics.

Its main strengths are:

- Consistent metric definitions
- Fast access to common questions
- Clear visual presentation
- Low risk of users changing the underlying calculation

Its main weakness is that users remain dependent on someone modifying the dashboard when a new business question appears.

This dashboard baseline will be compared with the Genie Agent to evaluate whether natural-language analysis provides faster access to unplanned follow-up questions while maintaining reliable business definitions.
