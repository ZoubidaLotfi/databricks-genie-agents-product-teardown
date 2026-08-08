# Open Questions

These questions explore how analytics agents like Genie could influence the way organizations design and store data in the future.

## Data architecture

- Should data be structured for both human analysts and AI agents from the beginning?
- Should business-ready tables and views be created during data ingestion instead of later during Agent setup?
- Should commonly used analytical populations, dimensions, and relationships be stored explicitly rather than reconstructed for each use case?
- Could better upstream data design reduce the amount of cleaning and preparation required before configuring an Agent?

## Semantic information

- Should metric definitions be stored alongside the data instead of being added later in Agent instructions?
- Should fields such as currency, units, valid date periods, and business meaning become standard metadata?
- Should concepts such as revenue, active customer, high volume, or cancellation rate have governed definitions directly connected to the data model?
- How should multiple valid definitions of the same business term be represented?

## Data quality by design

- Should data pipelines automatically flag incomplete periods, stale records, duplicates, or weak sample sizes?
- Could known data-quality limitations be stored as metadata that an Agent can read before answering?
- Should analytical datasets include quality indicators that tell the Agent whether a result is safe to use?

## Agent-ready data models

- What would an **Agent-ready data model** look like?
- Should tables include clearer relationships, descriptions, synonyms, and approved analytical rules by default?
- Could organizations create a reusable semantic layer that supports dashboards, analysts, and AI agents at the same time?
- How much Agent configuration could disappear if the underlying data model were designed for AI consumption from the start?

## Governance

- Who should own Agent-ready definitions and metadata: data engineering, analytics, business teams, or a shared governance function?
- How should changes to data definitions automatically propagate to Agents?
- Should changes to important metrics or schemas automatically trigger Agent regression tests?
- How can organizations ensure that the same business definition is used across dashboards, SQL analysis, and AI Agents?
