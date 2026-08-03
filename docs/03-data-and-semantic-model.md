# Data and Semantic Model

## Proposed tables

| Table | Purpose / grain / key | Important columns and relationships | Supports / risks / limits |
| --- | --- | --- | --- |
| `dim_accounts` | One row per account; `account_id` | segment, plan, status; joins users, subscriptions, tickets | Account/segment questions; stale status; not event causality |
| `dim_users` | One row per user; `user_id` | account_id, role, created_at; joins events | Activation/active-user cohorts; duplicate identities; not revenue truth |
| `dim_features` | One row per feature; `feature_id` | name, category; joins events | Feature adoption; taxonomy drift; not customer sentiment |
| `fact_product_events` | One event; `event_id` | user_id, account_id, feature_id, event_at | Usage/adoption; missing instrumentation; not billing |
| `fact_subscriptions_monthly` | Account-month; account_id + month | MRR, status, plan | MRR/churn/NRR; restatements; not daily usage |
| `fact_support_tickets` | One ticket; `ticket_id` | account_id, opened_at, priority, status | Support burden; inconsistent tagging; not root cause |

Relationship map: `dim_accounts` 1→many `dim_users`, `fact_subscriptions_monthly`, and `fact_support_tickets`; `dim_users` 1→many `fact_product_events`; `dim_features` 1→many `fact_product_events`. TODO: validate cardinality and date alignment.

## Proposed metric registry—review required

Every definition and formula below is proposed and must be reviewed/validated later. Default owner: Data Product Manager; validation status: **unvalidated**.

| Metric | Proposed formula / grain / date | Filters, exclusions, synonyms, ambiguity | Source |
| --- | --- | --- | --- |
| MRR | Sum month-end recurring revenue; account-month; `month` | Exclude tests; “revenue”; contracted vs recognized ambiguous | subscriptions |
| Logo churn | Lost active accounts / opening active accounts; month | Exclude tests; “customer churn”; voluntary vs total ambiguous | subscriptions |
| Revenue churn | Lost MRR / opening MRR; month | Exclude tests; gross vs net ambiguous | subscriptions |
| NRR | (opening MRR + expansion − contraction − churn)/opening MRR; cohort-month | Exclude tests; “retention”; treatment of reactivation ambiguous | subscriptions |
| Activation rate | Activated new accounts / eligible new accounts; cohort | Define activation event/window; “onboarding” ambiguous | users/events |
| WAU / MAU | Distinct eligible active users in week/month | Exclude tests; activity threshold ambiguous | events/users |
| Stickiness | WAU / MAU; reporting period | Calendar vs rolling period ambiguous | events/users |
| Feature adoption | Eligible accounts/users using feature / eligible population | Define usage event/window; “use” ambiguous | events/features |
| Support burden | Tickets per active account; month | Include resolved? “volume” ambiguous | tickets/accounts |
| Customer health | Proposed composite score; account-month | Weighting/thresholds TBD; “health” ambiguous | all sources |
| At-risk accounts | Accounts meeting approved risk rules; account-week/month | Thresholds TBD; “risk” ambiguous | all sources |

Unclear definitions can create incorrect agent answers even when SQL is technically valid: the query may faithfully calculate an unintended denominator, cohort, period, or churn interpretation. TODO: approve a formal metric contract per metric.
