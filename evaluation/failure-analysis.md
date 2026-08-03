# Failure Analysis

Record observed failures; the categories below are a taxonomy, not claims that failures occurred.

| Category | Definition / example | User impact | Likely cause | Configuration fix | Product opportunity | Severity | Detection |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Schema discovery failure | Cannot locate relevant schema/table | No answer or wrong scope | Missing context | Add governed metadata | Better discovery UX | TBD | Benchmark/review |
| Incorrect table selection | Uses unsuitable source | Wrong result | Weak grounding | Trusted assets | Source provenance | TBD | Gold SQL |
| Incorrect join | Bad cardinality/key | Inflated/omitted data | Join ambiguity | Approved joins | Join preview | TBD | Reconciliation |
| Incorrect aggregation | Wrong grouping/denominator | Misleading KPI | Metric gap | Metric view | Metric trace | TBD | Gold SQL |
| Metric-definition failure | Uses wrong business definition | Wrong decision | Unapproved formula | Definition contract | Interpretation UI | TBD | Reviewer |
| Semantic-interpretation failure | Misreads business term | Wrong intent | Synonym ambiguity | Clarify/synonyms | Alternatives UI | TBD | Rephrases |
| Date-period failure | Wrong window | Incorrect trend | Calendar ambiguity | Period instruction | Period preview | TBD | Gold SQL |
| Missing filter | Omits required exclusion | Contaminated result | Hidden rules | Verified SQL | Filter trace | TBD | Validation |
| Ambiguity failure | Chooses without clarification | Uncalibrated answer | Multiple definitions | Ask question | Ambiguity detection | TBD | Review |
| Clarification failure | Asks poor/no clarification | User friction/error | Weak policy | Prompt tests | Clarification UX | TBD | Benchmark |
| Unsupported inference | Claims unavailable insight | Unsafe decision | Overreach | Refusal rule | Evidence warning | TBD | Review |
| Unsupported-request failure | Mishandles unavailable request | Confusion | Boundary gap | Coverage map | Capability state | TBD | Benchmark |
| Refusal failure | Refuses poorly or incorrectly | Lost trust | Policy mismatch | Refusal examples | Safe alternatives | TBD | Review |
| Correlation-versus-causation failure | Presents correlation as cause | Bad prioritization | Reasoning overreach | Causality instruction | Claim labels | TBD | Review |
| Data-freshness failure | Ignores stale data | Outdated action | Missing metadata | Freshness display | Freshness warning | TBD | Validation |
| Visualization failure | Chart misleads/does not fit | Misreading | Poor defaults | Chart guidance | Chart review | TBD | UX test |
| Explanation failure | Does not explain logic | Low trust | Missing provenance | Explanation template | Trace panel | TBD | Review |
| Transparency failure | Hides assumptions/filters | Unverifiable answer | Weak UI/prompt | Required trace | Trust panel | TBD | Audit |
| Non-deterministic result | Same prompt differs materially | Unreliable workflow | Model variability | Repeat tests | Stability controls | TBD | Repeats |
| Multi-step reasoning failure | Loses prior analytical state | Incomplete investigation | Context failure | Staged prompts | Investigation state | TBD | Scenario test |
| Trusted-asset mismatch | Bypasses/conflicts with asset | Wrong approved logic | Retrieval/config issue | Asset tests | Asset status | TBD | Gold SQL |
| Agent-instruction conflict | Instructions collide | Inconsistent behavior | Policy design | Prioritize rules | Conflict detection | TBD | Regression |
| Regression after configuration change | Prior result worsens | Rework/lost trust | Unscoped change | Affected-test rerun | Regression alerts | TBD | Baseline comparison |
