# Product Context

## Confirmed framing

Databricks Genie Agents are the primary product under evaluation. TODO: add official documentation, screenshots, and direct workspace evidence before treating product behavior as confirmed.

## Problem and product framing

A general conversational analytics interface answers broad questions from available data. A configured domain-specific Genie Agent should instead apply a defined business domain, governed data, semantic context, instructions, approved examples, and trusted assets. The aim is useful self-service analytics without weakening control.

Governed data (for example through Unity Catalog and governed tables) can constrain access and lineage. Semantic context, business definitions, synonyms, joins, and metric views can align language to data. Instructions define behavior; example SQL and trusted assets provide preferred logic; monitoring and benchmarks expose regressions; human oversight resolves risky, ambiguous, or unsupported conclusions.

## People and ecosystem

The business user investigates product and customer health. The agent builder configures, tests, governs, monitors, and maintains the agent. Unity Catalog, metric views, governed tables, SQL warehouses, AI/BI Dashboards, and Genie Code are supporting components—not primary teardown products.

## Scope, exclusions, and hypothesis

**Scope:** FlowSync product analytics questions, proposed configuration, benchmark design, and operating burden. **Exclusions:** a platform-wide Databricks review, production deployment claims, and unverified product comparisons.

**Initial hypothesis:** trusted answers require more than executable SQL; they require maintained business logic and review. **Main question:** can this be done with manageable operations work?

## Criteria, risks, and open questions

Evaluate correctness, transparency, ambiguity handling, speed, consistency, governance, and maintenance burden. Risks include valid-but-wrong SQL, stale data, metric drift, unsafe inference, unclear ownership, and false confidence.

TODO: verify available controls, agent setup workflow, monitoring, and access constraints from official sources.
