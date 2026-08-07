# Databricks Genie Agents Product Discovery & Scope

## Objective

In this document I will establishe what Databricks Genie Agents are, who uses them, and the user problem they address. I will define the main teardown question, hypothesis, evaluation areas, Wanderbricks business scenario, and where the agent fits within the broader data product.

## 1. Workspace status

- GitHub repository created.
- Databricks Free Edition workspace created.
- Wanderbricks sample data explored.
- Initial dataset tables selected.

## 2. Understanding the product

| Question | Beginner-friendly answer |
| --- | --- |
| Who uses Databricks Genie Agents? | Business users who understand the company but may not write SQL, such as product, finance, sales, or operations teams. Data analysts or domain experts configure the agent. |
| What problem does the product solve? | It lets business users ask questions about company data without waiting for an analyst to create every query or report. |
| What data does it need? | Relevant company tables or views, plus clear names and descriptions that explain what the data means. |
| What does a business user ask it? | Questions such as “Which destination had the most bookings?” or “Why did cancellations increase?” |
| How does it generate an answer? | It interprets the question, selects relevant data, generates and runs SQL, then returns an answer, table, or visualization. |
| How does it differ from a dashboard? | A dashboard answers prepared questions through predefined charts. A Genie Agent supports new and follow-up questions in natural language. |
| What must the data team configure? | A clear data catalogue containing tables, columns, relationships, business definitions, and metadata. |
| Where could the product fail? | Failures can come from outdated, incomplete, duplicated, poorly cleaned, or badly described data; wrong joins, filters, metrics, or date periods; and misunderstood business terms. |

Source: [Databricks documentation](https://docs.databricks.com/aws/en/genie/monitor)

## 3. Simple product flow

The related [product map](../research/product-map.md) shows the same high-level flow.

```text
Business user
  ↓
Natural-language question
  ↓
Genie Agent
  ↓
Business definitions and instructions
  ↓
Governed company data
  ↓
Generated SQL
  ↓
Answer, table, or visualization
```

## 4. Target user

Primary user: Product Manager or business manager who understands the business but does not regularly write SQL.

This user wants faster answers without waiting for a data analyst.

## 5. Current analytics workflow

The current workflow, drawn from the [product brief](../research/product-brief.md), is:

![Current analytics workflow](../images/current-analytics-workflow.png)

This creates delays and makes follow-up questions dependent on the data team.

## 6. User frustrations

- Waiting for data analysts
- Limited dashboard flexibility
- Difficulty asking follow-up questions
- Inconsistent metric definitions
- Low confidence in AI-generated answers
- Difficulty knowing which data was used
- Dependence on technical teams

## 7. Job to be done

When business performance changes, I want to investigate governed business data using natural language so that I can make informed decisions quickly and trust the answers I receive.

## 8. Main teardown question

Can Databricks Genie Agents help Product Managers investigate business data faster while still providing reliable answers based on well-governed enterprise data?

All later work will help answer this question.

## 9. Hypothesis

Databricks Genie Agents can reduce the time Product Managers spend waiting for analysts, but the reliability of their answers depends on clear business definitions, accurate and updated data, strong metadata, and proper data governance.

## 10. Evaluation areas

| Area | What will be evaluated |
|---|---|
| **Answer correctness** | Whether Genie returned the correct result, used the right SQL, and answered the intended question. |
| **Business definitions and assumptions** | Whether Genie used the right metric definitions, thresholds, filters, and assumptions. |
| **Data quality and context** | Whether issues such as stale data, incomplete periods, duplicate records, missing currency, or small samples could affect the answer. |
| **Response time** | How long Genie took to return an answer during the benchmark and retest. |
| **Setup and maintenance effort** | The work needed to prepare the data, configure Genie, test answers, fix issues, and retest changes. |

## 11. Practical scope

Before evaluating Genie, I needed a realistic business scenario and dataset to test it against. For this teardown, I use **Wanderbricks**, a sample travel-booking business, to simulate the types of questions a Product Manager might ask about bookings, cancellations, payments, and customer ratings.

Wanderbricks is the practical example for this teardown. The scope covers:

- Travel booking analytics
- Booking volume
- Cancellations
- One simple revenue metric
- Customer satisfaction
- One AI/BI dashboard as a baseline
- One Genie Agent
- Data quality and governance
- Business definitions and metadata
- A simple review of answer speed, reliability, and trust

## 12. Wanderbricks business scenario

A manager at Wanderbricks wants to understand booking performance, cancellations, revenue, and customer satisfaction without waiting for a data analyst.

| Decision | Example question |
| --- | --- |
| Which destinations to prioritize | Which destinations generate the most bookings and revenue? |
| Where cancellations are a problem | Which destinations or properties have the highest cancellation rate? |
| Which properties need attention | Which properties have low ratings or declining bookings? |
| How booking performance is changing | Are bookings increasing or decreasing over time? |
| Which customer issues matter most | Where are poor reviews or support problems concentrated? |
| Which areas may need action | Which destinations have high demand but poor customer satisfaction? |
| What managers should investigate next | What explains a recent drop in bookings or revenue? |

## 13. Project architecture

![Databricks Genie Agent architecture](../images/genie-agent-architecture.png)

The Genie Agent is the user-facing layer, but it is not the entire data product. Reliable answers depend on the business definitions, metadata, governance, permissions, and clean, updated enterprise data underneath it. The data team prepares and maintains these supporting layers.

| Layer | Role |
| --- | --- |
| Business User | Asks business questions in natural language |
| Databricks Genie Agent | Interprets the question, generates SQL, and presents an answer |
| Business Context | Provides metrics, definitions, metadata, relationships, and instructions |
| Data Governance | Controls quality rules, ownership, permissions, and catalogue information |
| Enterprise Data | Provides the clean and updated business tables |
| Data Team | Prepares and maintains the data, definitions, metadata, and permissions |


## 14. Definition of Done

This discovery and scoping phase is complete when:

- [x] The product and its role in the analytics workflow are understood.
- [x] The primary target user is defined.
- [x] The current analytics workflow and main user frustrations are identified.
- [x] The initial Job to be Done is defined.
- [x] The main teardown question is clear.
- [x] The initial product hypothesis is documented.
- [x] The evaluation areas are defined.
- [x] Wanderbricks is selected as the practical test scenario.
- [x] The main business questions and decisions to investigate are identified.
- [x] The Genie architecture and its dependency on business context, governance, and enterprise data are understood.
- [x] The role of the data team is identified.
- [x] The scope is clear enough to define the data and semantic model required for testing.

### Out of scope for this phase

The following work belongs to later stages of the teardown:

- [ ] Select and validate the data used by the teardown.
- [ ] Define table relationships and business metrics.
- [ ] Investigate data-quality issues and assumptions.
- [ ] Build the dashboard baseline.
- [ ] Configure the Genie Agent.
- [ ] Run the benchmark and analyze failures.
- [ ] Improve and retest the Agent.
- [ ] Develop and validate the product recommendation.

### Decision gate

**Decision: proceed to data and semantic modeling.**

The product, user, hypothesis, business scenario, evaluation criteria, and scope
are clear enough to define the data foundation that Genie will rely on.

The next phase will determine:

- Which Wanderbricks tables are needed
- How those tables relate to each other
- Which business metrics need clear definitions
- Which data-quality issues could affect answers
- Which assumptions must be documented before testing Genie
