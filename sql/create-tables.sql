-- Proposed FlowSync synthetic-table definitions. Do not run as production DDL.
-- TODO: confirm SQL dialect, storage/catalog/schema, data types, constraints, and access model.

-- TODO: CREATE TABLE dim_accounts (account_id ..., segment ..., plan ..., status ...);
-- TODO: CREATE TABLE dim_users (user_id ..., account_id ..., created_at ...);
-- TODO: CREATE TABLE dim_features (feature_id ..., name ..., category ...);
-- TODO: CREATE TABLE fact_product_events (event_id ..., user_id ..., account_id ..., feature_id ..., event_at ...);
-- TODO: CREATE TABLE fact_subscriptions_monthly (account_id ..., month ..., mrr ..., status ...);
-- TODO: CREATE TABLE fact_support_tickets (ticket_id ..., account_id ..., opened_at ..., priority ..., status ...);
-- TODO: validate proposed primary/foreign keys, uniqueness, referential integrity, and test-account marker.
