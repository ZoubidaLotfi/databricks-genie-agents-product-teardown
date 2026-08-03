# Databricks Genie Agents Product Teardown

## Objective
Evaluate whether **Databricks Genie Agents** can provide trustworthy, domain-specific self-service analytics for SaaS product teams without excessive configuration, governance, monitoring, and maintenance work for data teams.

- **Primary product:** Databricks Genie Agents
- **Main question:** Can Databricks Genie Agents deliver trustworthy domain-specific self-service analytics while keeping setup and ongoing maintenance manageable for data teams?
- **Business user:** Senior Product Manager at a B2B SaaS company
- **Builder/operator:** Data Product Manager, Analytics Engineer, Data Analyst, or Data Engineer
- **Hypothesis:** Domain-specific conversational analytics may reduce time to insight, but trust depends on governed data, approved metrics, semantic context, instructions, verified SQL, trusted assets, continuous evaluation, and human oversight.

## Why Genie Agents

The teardown focuses on a configured agent rather than a generic conversational interface: it can be grounded in a product domain and evaluated against a repeatable benchmark. Unity Catalog, metric views, governed tables, SQL warehouses, AI/BI Dashboards, and Genie Code are supporting components only when they enable or assess the agent.

## What will be built and evaluated

1. Synthetic FlowSync SaaS data model, proposed metric definitions, and validation SQL.
2. A proposed `FlowSync Product Intelligence Agent` configuration and a dashboard baseline.
3. A benchmark with gold SQL/answers, repeated runs, failure analysis, and configuration history.

Evaluation dimensions: answer, SQL, metric, semantic, join, filter, and date correctness; ambiguity/refusal quality; transparency; consistency; latency; and user/builder correction effort.

## Seven-day overview

| Day | Focus |
| --- | --- |
| 1 | Product context, access, official evidence |
| 2 | Synthetic data model and metrics |
| 3 | Dashboard baseline |
| 4 | Proposed agent configuration |
| 5 | Benchmark and gold references |
| 6 | Test, diagnose, iterate |
| 7 | Recommendation and case study |

## Documentation

- [Product context](docs/01-product-context.md)
- [User problem](docs/02-user-problem.md)
- [Data and semantic model](docs/03-data-and-semantic-model.md)
- [Dashboard baseline](docs/04-dashboard-baseline.md)
- [Genie Agent setup](docs/05-genie-agent-setup.md)
- [Genie Agent evaluation](docs/06-genie-agent-evaluation.md)
- [Product recommendation](docs/07-product-recommendation.md)
- [Final case-study outline](docs/final-case-study.md)
- [Research log](research/research-log.md), [glossary](research/glossary.md), [assumptions](research/assumptions.md), [open questions](research/open-questions.md)
- [Evaluation workspace](evaluation/README.md)

## Status and limitations

**Status: scaffold only.** No product testing, external research, user feedback, or benchmark results have been completed. All configurations, formulas, and examples are proposals pending validation.

This project uses synthetic data; it is an independent product study, not Databricks guidance or endorsement. Features may vary by workspace, edition, region, and preview availability.

## Repository map

`docs/` contains the narrative; `data/` the synthetic-data design; `sql/` proposed logic; `evaluation/` test artifacts; `research/` evidence and questions; and `images/`, `presentation/`, and `notebooks/` hold supporting assets.
