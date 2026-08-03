# Genie Agent Evaluation

## Objective and scope

Measure whether the proposed agent gives correct, transparent, usable answers for business-critical FlowSync questions and quantify correction/maintenance burden. This is a methodology, not a completed result.

## Benchmark method

Create intent groups with multiple phrasings and categories: direct retrieval, aggregation, time comparison, segmentation, multi-table analysis, metric interpretation, ambiguous terminology, unsupported requests, follow-ups, multi-step investigation, correlation versus causation, and data freshness. For each question compare expected business interpretation, gold SQL, expected result, generated SQL/answer/visualization/explanation, final correctness, and user/builder correction.

Gold answers and SQL require independent reviewer approval and result validation. Score SQL, result, metric, semantic, join, filter, and date-period correctness; ambiguity/clarification/refusal handling; visualization, explanation, transparency, latency, and consistency. SQL execution alone is insufficient: it may calculate the wrong metric, join, filter, or period.

## Testing protocol

Repeat critical prompts to measure non-determinism; rephrase each intent; record baseline versus final configuration; regression-test after every relevant change; and obtain human review for critical decisions. Use the CSV templates and failure taxonomy in `evaluation/`.

Limitations: synthetic data, pending feature access, unvalidated metric definitions, and evaluation coverage cannot prove safety outside tested cases.
