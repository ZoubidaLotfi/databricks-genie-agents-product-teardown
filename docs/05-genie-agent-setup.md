# Genie Agent Setup

## Proposed configuration—must be tested

- **Name:** FlowSync Product Intelligence Agent
- **Objective/domain:** trustworthy conversational product and customer analytics for FlowSync.
- **Users:** Senior Product Managers and approved business partners.
- **Owner:** Data Product Manager with Analytics Engineering support.
- **Decisions:** adoption, churn, revenue, support, health, prioritization, and outreach.
- **Sources:** proposed FlowSync dimensions/facts, approved metric views, and trusted analytical assets. TODO: verify actual available objects and access controls.

## Semantic configuration

Configure business definitions, synonyms, join relationships, SQL expressions, calendar periods, internal-test exclusion, and approved metric logic. Add verified SQL examples and trusted assets for critical questions; record suggested questions and generated SQL review. Proposed question set: logo churn by segment; retained-enterprise feature use; WAU decline; low-adoption/high-ticket accounts; activation by plan; weekly Customer Success targets; NRR factors; low enterprise-feature adoption; activated versus non-activated churn; large usage declines.

## Proposed instructions—must be tested

Use approved metric definitions; use calendar months unless requested otherwise; state interpretations for ambiguous terms; never infer causation from correlation; exclude internal test accounts; ask clarification when valid definitions materially change results; say when data is unavailable; do not fabricate; prefer trusted assets/verified logic for critical questions; and surface filters and periods.

## Behavior and operations

Support bounded multi-step investigation, SQL/visualization review, and transparent explanations. Refuse unsupported inferences and data requests; clarify ambiguous questions. Log configuration changes, monitor critical benchmarks and feedback, triage owner escalations, and document limitations. Ownership covers data quality, metric approval, tests, access, periodic review, and regression response.
