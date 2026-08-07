# Data

This folder contains the data artifacts used to support the Wanderbricks Databricks Genie teardown.

## Data source

The project uses the **Wanderbricks sample dataset available in Databricks**.

The raw source tables were accessed directly from the Databricks workspace and are not duplicated in this repository.

Core source tables used:

- `bookings`
- `booking_updates`
- `properties`
- `destinations`
- `payments`
- `reviews`

## Data preparation

The raw tables were reviewed and prepared before being used for the dashboard and Genie Agent.

Main preparation steps included:

- Reconstructing the latest booking status from `booking_updates`
- Checking booking and payment relationships
- Identifying payment retries
- Separating booking value from completed payment amount
- Excluding deleted reviews from rating metrics
- Defining working business metrics
- Documenting assumptions and data-quality limitations

The detailed data preparation work is documented in:

- [`../docs/02-data-readiness-and-semantic-decisions.md`](../docs/02-data-readiness-and-semantic-decisions.md)
- [`../research/02-data-semantic-model-research.md`](../research/02-data-semantic-model-research.md)
- [`../research/02-data-dictionary.md`](../research/02-data-dictionary.md)

## Curated analysis views

The Genie Agent and dashboard use three prepared views:

```text
workspace.wanderbricks_teardown.booking_analysis
workspace.wanderbricks_teardown.payment_analysis
workspace.wanderbricks_teardown.review_analysis
