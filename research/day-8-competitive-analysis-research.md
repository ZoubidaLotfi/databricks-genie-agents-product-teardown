# Competitive Analysis Research

## Research purpose

This file preserves the detailed competitive evidence behind the PM-facing competitive landscape document.

It contains the scoring method, weighted criteria, evidence-confidence rules, competitive patterns, product-level findings, substitute analysis, and positioning conclusions.

---

## 1. Objective

This analysis compares Databricks Genie Agent with four enterprise analytics assistants:

| Product | Competitive type |
| --- | --- |
| Databricks Genie Agent | Product under study |
| Snowflake Cortex Analyst | Direct competitor |
| Microsoft Fabric Data Agent | Direct competitor |
| ThoughtSpot Spotter | Direct competitor |
| Tableau Agent | Adjacent competitor |

The comparison asks:

> How well does each product help a business user move from a natural-language question to a trustworthy, actionable answer from enterprise data?

A manual analyst using SQL is discussed separately as a substitute workflow.

---

## 2. Scoring method

Each product is scored from `1` to `5`.

| Score | Meaning |
| ---: | --- |
| 1 | Very weak or unavailable |
| 2 | Limited |
| 3 | Adequate |
| 4 | Strong |
| 5 | Leading |

Weighted points are calculated as:

```text
Weighted points = (score / 5) × criterion weight
```

### Weighted criteria

| Criterion | Weight | What is examined |
| --- | ---: | --- |
| Natural-language experience | 15% | Ease of asking, refining, and following up |
| Answer reliability | 20% | Accuracy, grounding, ambiguity handling, and consistency |
| Semantic governance | 15% | Metric definitions, business vocabulary, and semantic layer |
| Transparency | 10% | Query logic, sources, assumptions, and limitations |
| Data-platform integration | 10% | Access to governed warehouse, lakehouse, BI, and enterprise data |
| Setup effort | 10% | Ease of reaching a useful first deployment |
| Visualization and sharing | 5% | Charts, dashboards, exports, and collaboration |
| Administration and control | 5% | Permissions, monitoring, testing, and configuration |
| Extensibility | 5% | APIs, embedding, agents, and workflows |
| Product maturity | 5% | Documentation, release status, stability, and enterprise readiness |

For setup effort:

```text
5 = easiest setup
1 = heaviest setup
```

---

## 3. Evidence rules and limitations

Databricks Genie Agent was tested directly through:

- A 30-question benchmark against trusted SQL Editor results
- An 11-question targeted instruction-improvement retest
- Hands-on setup of curated views, instructions, permissions, and monitoring

The competing products were not benchmarked directly.

Their scores are based on official documentation and vendor product materials available on 2026-08-06.

### Confidence

- **Databricks:** High
- **Competitors:** Medium

The ranking is therefore a **provisional product analysis**, not a controlled head-to-head performance test.

---

## 4. Evidence and interpretation matrix

| Product | Documented fact | Direct teardown evidence | Interpretation | Confidence |
| --- | --- | --- | --- | --- |
| **Databricks Genie Agent** | Natural-language analysis, generated SQL, governed data, instructions, monitoring, APIs | 30-question benchmark + 11-question retest | Strong inside Databricks, but reliable use requires careful setup and testing | **High** |
| **Snowflake Cortex Analyst** | Semantic Views, verified queries, generated SQL, monitoring, evaluations | Not tested directly | Strong documented governance and validation workflow | **Medium** |
| **Microsoft Fabric Data Agent** | Multiple Fabric sources, instructions, evaluations, diagnostics, integrations | Not tested directly | Broad ecosystem integration, but potentially complex setup | **Medium** |
| **ThoughtSpot Spotter** | Conversational analysis, semantic governance, visualizations, workflow actions | Not tested directly | Strong business-user experience based on vendor evidence | **Medium** |
| **Tableau Agent** | Natural-language visual exploration, calculations, dashboard summaries, embedding | Not tested directly | Strong visualization experience, less SQL-level transparency | **Medium** |

---

## 5. Competitive patterns

| Pattern | Products | Main advantage | Main trade-off |
| --- | --- | --- | --- |
| Platform-native | Databricks Genie, Snowflake Cortex Analyst, Microsoft Fabric Data Agent | Strong governance, security, and native data integration | Best value often requires deeper platform adoption |
| BI-native | Tableau Agent | Strong dashboards, visualization, and sharing | Depends heavily on prepared BI content and semantic models |
| Analytics-native | ThoughtSpot Spotter | Business-user conversational exploration and visual analytics | Reliability claims were not tested directly here |
| Human substitute | Analyst using SQL | Strong clarification, context, and flexibility | Slower and less scalable |
| General AI substitute | General AI connected to data | Flexible interaction and broad reasoning | Weaker governance and reproducibility without enterprise controls |

---

## 6. Weighted scorecard

| Product | NL | Reliability | Semantics | Transparency | Integration | Setup | Visualization | Admin | Extensibility | Maturity | Total |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| ThoughtSpot Spotter | 5 | 4 | 5 | 5 | 4 | 4 | 5 | 4 | 5 | 4 | **90.0** |
| Snowflake Cortex Analyst | 4 | 4 | 5 | 5 | 4 | 3 | 2 | 5 | 5 | 4 | **83.0** |
| Microsoft Fabric Data Agent | 4 | 4 | 4 | 4 | 5 | 3 | 3 | 5 | 5 | 3 | **80.0** |
| Databricks Genie Agent | 4 | 3 | 4 | 4 | 5 | 2 | 3 | 4 | 5 | 4 | **74.0** |
| Tableau Agent | 4 | 3 | 3 | 3 | 4 | 2 | 5 | 4 | 5 | 3 | **68.0** |

---

## 7. Overall ranking

| Rank | Product | Weighted score | Main advantage |
| ---: | --- | ---: | --- |
| 1 | ThoughtSpot Spotter | **90.0/100** | Business-user conversational analytics and visual self-service |
| 2 | Snowflake Cortex Analyst | **83.0/100** | Semantic governance, verified queries, and evaluation workflow |
| 3 | Microsoft Fabric Data Agent | **80.0/100** | Broad Microsoft ecosystem and data-source coverage |
| 4 | Databricks Genie Agent | **74.0/100** | Deep Unity Catalog and Databricks platform integration |
| 5 | Tableau Agent | **68.0/100** | Visual analysis, dashboards, sharing, and embedding |

The weighted score is an orientation tool, not an objective winner.

---

## 8. Main findings

### 8.1 Governance and validation matter more than chat

All five products offer natural-language interaction.

The stronger differentiation lies in:

- Governed metric definitions
- Semantic models
- Verified/example queries
- Query transparency
- Monitoring and evaluation
- Access control
- Regression testing

### 8.2 ThoughtSpot

Appears strongest for business-user conversational analytics and visual self-service.

Confidence remains medium because it was not independently benchmarked.

### 8.3 Snowflake

Has the strongest documented verification workflow in this comparison.

Relevant capabilities include:

- Semantic Views
- Verified Query Repository
- Generated SQL
- Confidence metadata
- Monitoring
- Evaluation and regression tracking

### 8.4 Microsoft Fabric

Offers the broadest ecosystem integration across Microsoft data and Copilot products.

The trade-off is complexity and an evolving product surface.

### 8.5 Databricks

Strongest inside the lakehouse ecosystem.

Direct testing showed stronger performance on clear metrics and more risk around ambiguity, period logic, thresholds, financial definitions, sample sizes, and multi-source logic.

### 8.6 Tableau

Strongest in visualization-first workflows.

It is less directly comparable to Genie because the experience is centered more heavily on visual analytics and Tableau content.

---

## 9. Category leaders

| Category | Leading product(s) | Reason |
| --- | --- | --- |
| Natural-language experience | ThoughtSpot Spotter | Conversational exploration and business-user focus |
| Answer reliability | Snowflake, Fabric, ThoughtSpot | Strong documented controls, not independently benchmarked |
| Semantic governance | Snowflake, ThoughtSpot | Rich semantic layers and reusable business logic |
| Transparency | Snowflake, ThoughtSpot | Generated SQL or traceable query logic |
| Data-platform integration | Databricks, Microsoft Fabric | Deep native platform integration |
| Ease of setup | ThoughtSpot | Focused setup guidance |
| Visualization and sharing | ThoughtSpot, Tableau | Strong visual and sharing workflows |
| Administration and control | Snowflake, Microsoft Fabric | Evaluation, monitoring, and lifecycle controls |
| Extensibility | All five | APIs, embedding, and workflow integration |
| Product maturity | Databricks, Snowflake, ThoughtSpot | Established enterprise platforms |

---

## 10. Manual analyst as a substitute

| Criterion | Analytics agent | Manual analyst |
| --- | --- | --- |
| Speed | Fast for routine questions | Slower due to queues and handoffs |
| Clarification | Can be inconsistent | Usually asks follow-up questions |
| Business context | Depends on configuration | Can use wider organizational context |
| Scalability | Supports many users | Limited by analyst capacity |
| Trust | Requires governance and validation | Often higher after expert review |
| Flexibility | Limited by configured data and tools | High |
| Follow-up cost | Low after setup | Requires more analyst time |
| Reproducibility | Query and conversation can be saved | Depends on documentation habits |
| Cost profile | Higher setup, lower marginal cost | Lower setup, higher ongoing human cost |

The strategic value of analytics agents is not to remove analysts completely. It is to reduce repetitive requests and reserve analyst time for higher-complexity work.

---

## 11. Competitive positioning

### Databricks Genie Agent

Best fit when organizations:

- Already centralize data in Databricks
- Use Unity Catalog
- Want analytics connected to dashboards, applications, and agents
- Can invest in curated views, instructions, and testing

### Snowflake Cortex Analyst

Best fit when organizations:

- Use Snowflake as their main warehouse
- Prioritize semantic views and verified SQL
- Want built-in evaluation and monitoring
- Need a strong API-first structured-data assistant

### Microsoft Fabric Data Agent

Best fit when organizations:

- Use Fabric and Power BI broadly
- Need one agent across multiple data engines
- Want deep Microsoft ecosystem integration
- Can manage a more complex platform

### ThoughtSpot Spotter

Best fit when organizations:

- Prioritize business-user self-service
- Want conversational and visual analytics
- Need governed semantic logic and workflow actions
- Prefer an analytics-native experience

### Tableau Agent

Best fit when organizations:

- Already rely on Tableau
- Prioritize visual exploration and dashboard creation
- Want natural-language support for authors and consumers
- Do not require SQL-level transparency as the primary experience

---

## 12. Research conclusion

There is no universal winner.

The strongest choice depends on existing platform investment and primary user need.

The analysis supports three market-level conclusions:

1. **Natural-language querying is no longer a sufficient differentiator.**
2. **Semantic governance, evaluation, and transparency are stronger trust differentiators.**
3. **Platform integration strongly influences adoption and product fit.**

For Databricks, the strategic advantage is the combination of Genie, Unity Catalog, SQL, dashboards, applications, and agent workflows.

The main risk remains semantic reliability: technically valid answers can still apply the wrong business meaning unless the Agent is carefully configured, tested, and governed.
