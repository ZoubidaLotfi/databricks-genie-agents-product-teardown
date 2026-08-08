# Wanderbricks data foundation

Wanderbricks is Databricks sample travel-booking data used as the business scenario for this teardown. It represents bookings, booking updates, properties, destinations, payment attempts, and reviews so that dashboard and Genie behavior can be evaluated against the same working definitions.

The full raw source dataset is not duplicated in GitHub. It was accessed in the Databricks workspace, while this repository stores lightweight documentation and reproducible SQL. This avoids copying large platform-provided data and keeps the repository focused on the decisions needed to interpret it.

| File | What it gives you |
| --- | --- |
| [Data Dictionary](data-dictionary.md) | Table grains, fields, meanings, relationships, validation status, metric dependencies, ambiguities, quality checks, and Agent terminology guardrails. |
| [`samples/`](samples/) | Placeholder directory only; it contains no sample dataset. |

For the investigation and semantic decisions, read [Data and Semantic Model Research](../research/day-2-data-semantic-model-research.md). For the PM summary, read [Data Readiness and Semantic Decisions](../docs/02-data-readiness-and-semantic-decisions.md). The implementation SQL is in [`sql/`](../sql/).

