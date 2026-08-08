# Reusable evaluation framework

This folder contains the reusable framework for evaluating Genie, plus the observed failure taxonomy and configuration log. The completed 30-question results live in [`research/`](../research/README.md), not in the blank templates.

## Scoring model

Each answer is scored from **0 to 2** on numerical correctness, SQL correctness, definition compliance, clarity, and assumption handling, for a total out of 10.

| Total | Classification |
| ---: | --- |
| 9 to 10 | Reliable |
| 7 to 8 | Acceptable with minor issues |
| 5 to 6 | Requires analyst review |
| 0 to 4 | Failed |

| File | Purpose | When to use it |
| --- | --- | --- |
| [Benchmark Template](benchmark-template.csv) | Blank 30-case structure with trusted results, Agent evidence, scores, and classification. | Design a benchmark before running the Agent. |
| [Results Template](results-template.csv) | Blank run-level schema with versions, latency, failure type, and baseline change. | Record repeatable runs and compare configurations. |
| [Configuration Change Log](configuration-change-log.csv) | Seven completed changes linking observed problems to effects, affected questions, and regressions. | Trace what changed and decide which questions need regression testing. |
| [Failure Analysis](failure-analysis.md) | Taxonomy of failures observed in the benchmark or targeted retest. | Diagnose semantic, context, population, period, transparency, or visualization risks. |

Completed evidence:

- [30-question results CSV](../research/day-5-benchmark-results.csv)
- [Benchmark research](../research/day-5-genie-quality-benchmark-research.md)
- [Targeted 11-question retest](../research/day-6-targeted-instruction-retest-research.md)
- [Independent SQL reference answers](../sql/04-benchmark-reference-answers.sql)

Trusted answers require independent validation. A configuration change should identify affected questions and rerun them for both improvements and regressions.
