# Supporting research and evidence

This folder contains the detailed evidence behind the lighter PM documents in [`docs/`](../docs/README.md). Start with the benchmark CSV and failure analysis for direct test evidence; use the discovery and market files for context, assumptions, and documented inference.

## Strongest direct evidence

| File | What it gives you | Supports |
| --- | --- | --- |
| [Benchmark results CSV](day-5-benchmark-results.csv) | Question-level trusted results, Agent answers and SQL, five dimension scores, totals, and issue notes for all 30 questions. | [Quality Benchmark](../docs/05-genie-quality-benchmark-and-product-findings.md) |
| [Genie Quality Benchmark Research](day-5-genie-quality-benchmark-research.md) | Method, scoring rubric, category results, divergences, failure patterns, and improvement priorities. | [Quality Benchmark](../docs/05-genie-quality-benchmark-and-product-findings.md) |
| [Targeted Instruction Retest Research](day-6-targeted-instruction-retest-research.md) | Instruction changes and before-versus-after evidence for the targeted 11-question retest. | [Targeted Retest](../docs/06-targeted-reliability-retest-and-product-learning.md) |
| [Genie Setup and Smoke Test Research](day-4-genie-agent-setup-and-smoke-test-research.md) | Configuration choices, examples, screenshots, eight smoke-test questions, and early reliability risks. | [Genie Readiness](../docs/04-genie-agent-readiness-and-smoke-test.md) |

## Product discovery

| File | What it gives you | Supports |
| --- | --- | --- |
| [Product Discovery Research](day-1-product-discovery-research.md) | Early product questions, evidence sources, scope choices, and links to assumptions. | [Product Discovery](../docs/01-product-discovery-and-scope.md) |
| [Assumptions and Validation Research](day-1-assumptions-and-validation-research.md) | What was supported, partially supported, or not validated by the completed work. | [Product Discovery](../docs/01-product-discovery-and-scope.md) |
| [Product Brief](product-brief.md) | The starting dashboard-to-analyst workflow and repeated follow-up delay. | [Product Discovery](../docs/01-product-discovery-and-scope.md) |
| [Product Map](product-map.md) | A compact view of the question-to-SQL-to-answer product flow. | [Product Discovery](../docs/01-product-discovery-and-scope.md) |
| [Glossary](glossary.md) | Starter terms, including entries still marked for official verification. | General reference |

## Data and semantic research

| File | What it gives you | Supports |
| --- | --- | --- |
| [Data and Semantic Model Research](day-2-data-semantic-model-research.md) | Six-table analysis, relationships, quality checks, SQL, metric contracts, assumptions, and curated-view decisions. | [Data Readiness](../docs/02-data-readiness-and-semantic-decisions.md) |
| [Open Questions](open-questions.md) | Future questions about Agent-ready architecture, metadata, data quality, semantics, and ownership. | Root README open question |

The companion [data dictionary](../data/data-dictionary.md) provides field-level meaning, validation status, ambiguity, quality checks, and Agent terminology guardrails.

## User and market evidence

| File | What it gives you | Supports |
| --- | --- | --- |
| [User Journey Evidence Research](day-7-user-journey-evidence-research.md) | Journey matrices grounded in workspace and benchmark observations, with unvalidated user expectations clearly labeled. | [User Journey](../docs/07-user-journey-trust-and-operating-model.md) |
| [Competitive Analysis Research](day-8-competitive-analysis-research.md) | Weighted method, evidence-confidence rules, product findings, substitute analysis, and positioning. | [Competitive Landscape](../docs/08-competitive-landscape-and-strategic-positioning.md) |
| [Competitive Analysis CSV](day-5-competitive-analysis.csv) | Product-level scores, claims, sources, access dates, confidence, and notes. | [Competitive Landscape](../docs/08-competitive-landscape-and-strategic-positioning.md) |

Competitors were researched primarily through official vendor documentation. Only Genie was tested directly, so the comparison is directional rather than an independently benchmarked head-to-head result.

## Working artifact

| File | Role |
| --- | --- |
| [Research Log](research-log.md) | An unfilled daily research template with `TODO` placeholders, not completed evidence. |

