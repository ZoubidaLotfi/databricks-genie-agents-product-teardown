# User Problem

## Fictional scenario

**FlowSync** sells B2B workflow and project-management software. Weekly active usage is declining and churn is increasing in some customer segments. A Senior Product Manager needs follow-up analysis without waiting for a data analyst; a Data Product Manager or Analytics Engineer must build an agent that uses approved metrics, correct data, and safe interpretations.

| Persona | Responsibilities | Frustrations |
| --- | --- | --- |
| Senior Product Manager | Investigate activation, adoption, retention, churn, revenue, health, and support | Slow analyst queue; static dashboards; unclear definitions |
| Agent builder | Configure data, semantic context, tests, governance, and maintenance | Metric ambiguity; brittle joins; unclear ownership; regression risk |

## Workflows and jobs

Today the PM opens dashboards, applies filters, requests analyses, then asks follow-ups. The builder gathers requirements, maps tables/terms, creates logic and examples, tests, monitors, and revises it.

**Business-user job:** understand product/customer health quickly enough to make a responsible decision. **Builder job:** enable that exploration while preventing unsupported answers.

## Decisions and boundaries

The future agent may address activation, WAU/MAU, stickiness, feature adoption, retention, logo/revenue churn, MRR/NRR, health, support volume, at-risk accounts, segments, and usage trends. It must not claim causation from correlation, expose unavailable data, or silently choose among materially different definitions.

Key assumptions to test: users can phrase questions clearly enough; semantic configuration reduces errors; clarification is accepted; and incorrect answers do not create disproportionate decision risk. Misleading answers could misprioritize roadmap work, customer outreach, or revenue forecasts.
