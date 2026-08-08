# Can Databricks Genie Agents Deliver Trustworthy Self-Service Analytics?

This Product Management teardown investigates whether Databricks Genie Agents can help business users explore governed data without waiting for every answer to be prepared by an analyst. Using Wanderbricks, a sample travel-booking business, it evaluates both analytical flexibility and the reliability of the business meaning behind each answer.

## Main product question

> Can Databricks Genie Agents help Product Managers investigate business data faster while still providing reliable answers based on well-governed enterprise data?

## Who this is for

| User | Need |
| --- | --- |
| Product Manager or business manager | Investigate business performance in natural language without regularly writing SQL. |
| Data or platform administrator | Prepare trusted data, definitions, instructions, permissions, tests, and ongoing controls. |

## What I did

| Phase | What I did | Why it mattered |
| --- | --- | --- |
| Product discovery | Defined the user, JTBD, hypothesis, scope, and evaluation criteria. | Connected the teardown to a specific decision problem. |
| Data investigation | Examined six Wanderbricks tables, relationships, quality issues, and assumptions. | Found that the original booking status was stale and financial meaning was incomplete. |
| Semantic preparation | Reconstructed current booking state, defined five working metrics, and created three curated analysis views. | Gave the dashboard and Genie the same testable foundation. |
| Dashboard baseline | Built a reference experience for recurring KPIs and known questions. | Established what consistency looks like before testing flexible analysis. |
| Genie setup and smoke test | Configured one Agent and tested eight basic questions. | Removed setup issues and exposed early risks around currency, terminology, and samples. |
| Quality benchmark | Scored 30 questions against independent SQL references. | Measured numerical, SQL, semantic, communication, and assumption quality separately. |
| Failure analysis | Classified observed failures such as threshold drift and wrong analytical populations. | Turned answer-level errors into product patterns. |
| Targeted iteration | Strengthened instructions and reran 11 affected questions. | Measured improvements and regressions without calling it a full second benchmark. |
| User journey | Mapped the business-user and administrator journeys. | Located the main trust break between asking, verifying, and deciding. |
| Competitive analysis | Compared five products using direct Genie evidence and vendor documentation for competitors. | Put the findings in a broader market context without claiming a head-to-head benchmark. |
| Strategy and prioritization | Connected evidence to platform strategy and prioritized decision confidence. | Selected the highest-evidence opportunity. |
| Proposed solution | Designed the Analytics Trust Center concept and two prototype screens. | Explored how risks could become visible before a user acts. |

## Key results

| Measure | Result |
| --- | ---: |
| Benchmark questions | **30** |
| Average score | **7.87 / 10** |
| Numerical correctness | **1.70 / 2, or 85.0% of maximum** |
| SQL correctness | **1.60 / 2, or 80.0% of maximum** |
| Business-definition compliance | **1.47 / 2, or 73.3% of maximum** |
| Reliable | **15 / 30** |
| Acceptable with minor issues | **10 / 30** |
| Requires analyst review | **1 / 30** |
| Failed | **4 / 30** |

Genie was strongest on clear, governed questions. Core metric accuracy averaged **9.00/10**. Reliability fell when Genie had to interpret revenue, thresholds, complete periods, currency, sample size, or the population used in a calculation.

The important gap was between producing a plausible result and preserving its business meaning. Examples included changing an explicit threshold of 1,000 to 10, treating the latest observed month as complete, adding unsupported currency, and presenting completed payment amount as revenue when no approved revenue definition existed.

> **Valid SQL does not automatically mean a trustworthy business answer.**

See the [benchmark findings](docs/05-genie-quality-benchmark-and-product-findings.md), [completed results CSV](research/day-5-benchmark-results.csv), and [failure analysis](evaluation/failure-analysis.md).

## What changed after configuration

Targeted instructions improved the selected 11-question subset from **5.73/10 to 7.91/10**. Seven questions improved, one was unchanged, and three regressed. Threshold, revenue, currency, and assumption handling improved, but complete-period logic, final-answer compliance, small-sample interpretation, and analytical populations remained inconsistent.

The result supports a limited conclusion: **instructions improved reliability, but did not act as a complete governance layer.** Read the [targeted retest](docs/06-targeted-reliability-retest-and-product-learning.md).

## Product insight

The teardown started by asking whether Genie could answer business questions. The more important question became:

> Can the user understand whether Genie applied the right business meaning?

The benchmark showed technically plausible answers with semantic weaknesses. The journey analysis showed that this context matters most when users verify an answer, decide, or share it.

## Final product recommendation

**Analytics Trust Center is a proposed product concept from this teardown. It is not an existing Databricks feature.**

The concept adds a lightweight review entry point only when a meaningful trust issue is detected. It could highlight definitions, proxies, thresholds, assumptions, missing currency, incomplete periods, weak samples, or other decision-relevant risks while complementing Genie's existing analysis and SQL visibility.

It does not guarantee correctness or replace governed metrics, SQL inspection, or analyst review. Its goal is to make important risks visible before a user acts.

Explore the [prototype document](docs/10-analytics-trust-center-prototype.md), [main user flow](images/main-user-flow%281%29.png), [alert screen](images/screen-one.png), and [review screen](images/screen-two.png).

## Open question: What does Agent-ready data look like?

This is an open question raised by the teardown, not a proven finding. Evaluating Genie required cleaning and understanding the data, reconstructing current booking state, separating booking value from completed payment amount, creating curated views, defining metrics and thresholds, adding semantic context, and documenting missing context.

> Could AI analytics agents change how organizations design and store data in the first place?

Should business-ready structures be created earlier in the data lifecycle? Should definitions, currency, units, date coverage, relationships, limitations, and common analytical populations travel with the data as governed metadata? Could one Agent-ready semantic foundation serve dashboards, analysts, and AI agents while reducing repeated preparation? These questions remain open for future product and data-platform research.

## Repository structure

| Folder | What it gives you |
| --- | --- |
| [`docs/`](docs/README.md) | Final PM-facing narrative, decisions, findings, strategy, and concept. |
| [`research/`](research/README.md) | Detailed discovery, data, benchmark, retest, journey, and competitive evidence. |
| [`data/`](data/README.md) | The documented Wanderbricks data foundation and semantic guardrails. |
| [`evaluation/`](evaluation/README.md) | Reusable evaluation templates, change log, and observed failure taxonomy. |
| [`images/`](images/README.md) | A visual path through the teardown and prototype. |

## Read this project quickly

| Read | What you get |
| --- | --- |
| [Product Discovery](docs/01-product-discovery-and-scope.md) | Problem, user, JTBD, hypothesis, and scope. |
| [Quality Benchmark](docs/05-genie-quality-benchmark-and-product-findings.md) | Test design, headline evidence, and main reliability gaps. |
| [Targeted Retest](docs/06-targeted-reliability-retest-and-product-learning.md) | Controlled iteration, gains, unresolved issues, and regressions. |
| [Product Strategy](docs/09-product-strategy-and-opportunity-prioritization.md) | Strategic role, opportunity prioritization, and chosen direction. |
| [Analytics Trust Center](docs/10-analytics-trust-center-prototype.md) | Proposed solution, flow, prototype, and boundaries. |

## PM skills demonstrated

| PM skill | Evidence in this teardown |
| --- | --- |
| Product discovery | Defined the target user, JTBD, hypothesis, scope, and decision gates. |
| Data-informed product thinking | Investigated data quality, metric meaning, relationships, and semantic risks. |
| Experiment design | Built a five-dimension, 30-question benchmark with independent SQL references. |
| Product iteration | Changed targeted instructions and reran the 11 affected questions. |
| Root-cause analysis | Classified recurring semantic, context, population, and visualization failures. |
| User journey analysis | Mapped trust-building and trust-breaking moments for users and administrators. |
| Competitive analysis | Compared relevant approaches while separating direct tests from vendor claims. |
| Product strategy | Connected Genie to the wider Databricks platform and evidence-backed risks. |
| Prioritization | Selected decision confidence as the P0 opportunity. |
| Product design | Proposed an exception-based Trust Center flow and two prototype screens. |

## Limitations

- Wanderbricks is sample data, not a production business dataset.
- No user interviews, adoption study, or production pilot was conducted.
- The targeted retest covered 11 affected questions, not the full 30-question benchmark.
- The proposed Trust Center was not validated with real users.
- Repeated identical prompts and multi-turn consistency were not formally evaluated.
- Production-scale setup and maintenance effort was observed qualitatively, not formally measured.
