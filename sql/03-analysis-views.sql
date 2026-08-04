-- ============================================================================
-- File: sql/03-analysis-views.sql
-- Project: Databricks Genie Agents Product Teardown
-- Source dataset: samples.wanderbricks
-- Destination schema: workspace.wanderbricks_teardown
--
-- Purpose:
--   Create three persistent, reusable analysis views for the Day 3 dashboard
--   and Databricks Genie Agent:
--
--     1. workspace.wanderbricks_teardown.booking_analysis
--     2. workspace.wanderbricks_teardown.payment_analysis
--     3. workspace.wanderbricks_teardown.review_analysis
--
-- Why persistent views:
--   The Day 2 current_bookings object was a temporary view used for analysis
--   and validation. Temporary views are session-scoped and are not a stable
--   dependency for dashboards or Genie Agents.
--
-- This script reads from samples.wanderbricks. It does not copy the source
-- data. It saves reusable query logic as persistent views.
-- ============================================================================


-- ============================================================================
-- SETUP: Create the writable schema for this teardown
--
-- The three analysis views will be stored in:
--   workspace.wanderbricks_teardown
-- ============================================================================

CREATE SCHEMA IF NOT EXISTS workspace.wanderbricks_teardown
COMMENT 'Curated analysis views for the Wanderbricks Genie Agent teardown';


-- ============================================================================
-- VIEW 1: booking_analysis
--
-- Grain:
--   One row per booking.
--
-- Purpose:
--   Provide the latest known booking state together with property and
--   destination information.
--
-- Logic:
--   Original booking
--          +
--   Latest booking update, when available
--          =
--   Current booking state
--
-- The latest booking_updates row is selected using:
--   1. updated_at descending
--   2. booking_update_id descending as a tie-breaker
--
-- Business use:
--   - Total bookings
--   - Completed bookings
--   - Current booking-status distribution
--   - Proposed cancellation rate
--   - Booking trends
--   - Destination and property performance
--
-- Important:
--   booking_value is the latest amount attached to the booking. It must not
--   automatically be described as collected revenue.
-- ============================================================================

CREATE OR REPLACE VIEW workspace.wanderbricks_teardown.booking_analysis
COMMENT 'One row per booking using the latest booking update, enriched with property and destination information'
AS
WITH latest_booking_updates AS (
    SELECT
        booking_id,
        booking_update_id,
        user_id,
        property_id,
        check_in,
        check_out,
        guests_count,
        total_amount,
        status,
        updated_at,
        ROW_NUMBER() OVER (
            PARTITION BY booking_id
            ORDER BY updated_at DESC, booking_update_id DESC
        ) AS row_number
    FROM samples.wanderbricks.booking_updates
),

current_booking_state AS (
    SELECT
        b.booking_id,
        COALESCE(u.user_id, b.user_id) AS user_id,
        COALESCE(u.property_id, b.property_id) AS property_id,
        COALESCE(u.check_in, b.check_in) AS check_in,
        COALESCE(u.check_out, b.check_out) AS check_out,
        COALESCE(u.guests_count, b.guests_count) AS guests_count,
        COALESCE(u.total_amount, b.total_amount) AS booking_value,
        COALESCE(u.status, b.status) AS current_status,
        b.created_at AS booking_created_at,
        COALESCE(u.updated_at, b.updated_at) AS latest_updated_at,
        CASE
            WHEN u.booking_id IS NOT NULL THEN TRUE
            ELSE FALSE
        END AS has_booking_update
    FROM samples.wanderbricks.bookings AS b
    LEFT JOIN latest_booking_updates AS u
        ON b.booking_id = u.booking_id
        AND u.row_number = 1
)

SELECT
    cb.booking_id,
    cb.user_id,
    cb.current_status,
    cb.booking_created_at,
    cb.check_in,
    cb.check_out,
    cb.guests_count,
    cb.booking_value,
    cb.latest_updated_at,
    cb.has_booking_update,
    p.property_id,
    p.title AS property_title,
    p.property_type,
    p.base_price,
    p.max_guests,
    d.destination_id,
    d.destination,
    d.country,
    d.state_or_province
FROM current_booking_state AS cb
INNER JOIN samples.wanderbricks.properties AS p
    ON cb.property_id = p.property_id
INNER JOIN samples.wanderbricks.destinations AS d
    ON p.destination_id = d.destination_id;


-- ============================================================================
-- VIEW 2: payment_analysis
--
-- Grain:
--   One row per payment attempt.
--
-- Purpose:
--   Provide payment data together with current booking, property, and
--   destination information.
--
-- Business use:
--   - Completed payment amount
--   - Payment method analysis
--   - Payment trends
--   - Completed payment amount by property or destination
--
-- Important:
--   This view contains every payment status. Queries measuring completed
--   payment amount must filter payment_status = 'completed'.
-- ============================================================================

CREATE OR REPLACE VIEW workspace.wanderbricks_teardown.payment_analysis
COMMENT 'One row per payment attempt enriched with current booking, property, and destination information'
AS
SELECT
    pay.payment_id,
    pay.booking_id,
    pay.amount AS payment_amount,
    pay.payment_method,
    pay.status AS payment_status,
    pay.payment_date,
    ba.current_status AS current_booking_status,
    ba.property_id,
    ba.property_title,
    ba.property_type,
    ba.destination_id,
    ba.destination,
    ba.country
FROM samples.wanderbricks.payments AS pay
INNER JOIN workspace.wanderbricks_teardown.booking_analysis AS ba
    ON pay.booking_id = ba.booking_id;


-- ============================================================================
-- VIEW 3: review_analysis
--
-- Grain:
--   One row per active, non-deleted review.
--
-- Purpose:
--   Provide customer ratings together with property and destination context.
--
-- Business use:
--   - Average rating
--   - Review volume
--   - Rating by destination
--   - Rating by property
--
-- Filtering rule:
--   Deleted reviews are excluded directly in this view.
--
-- Important:
--   Average rating represents customers who chose to leave a review. It does
--   not represent every booking or customer.
-- ============================================================================

CREATE OR REPLACE VIEW workspace.wanderbricks_teardown.review_analysis
COMMENT 'One row per active review enriched with property and destination information'
AS
SELECT
    r.review_id,
    r.booking_id,
    r.user_id,
    r.rating,
    r.comment AS review_comment,
    r.created_at AS review_date,
    r.updated_at AS review_updated_at,
    p.property_id,
    p.title AS property_title,
    p.property_type,
    d.destination_id,
    d.destination,
    d.country
FROM samples.wanderbricks.reviews AS r
INNER JOIN samples.wanderbricks.properties AS p
    ON r.property_id = p.property_id
INNER JOIN samples.wanderbricks.destinations AS d
    ON p.destination_id = d.destination_id
WHERE r.is_deleted = false;


-- ============================================================================
-- VERIFICATION 1: Confirm booking_analysis has one row per booking
--
-- Expected:
--   total_rows = 72,247
--   unique_bookings = 72,247
--   duplicate_rows = 0
-- ============================================================================

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT booking_id) AS unique_bookings,
    COUNT(*) - COUNT(DISTINCT booking_id) AS duplicate_rows
FROM workspace.wanderbricks_teardown.booking_analysis;


-- ============================================================================
-- VERIFICATION 2: Confirm the current booking-status distribution
--
-- Expected Day 2 baseline:
--   completed = 36,835
--   cancelled = 28,428
--   confirmed = 5,768
--   pending   = 1,216
-- ============================================================================

SELECT
    current_status,
    COUNT(*) AS booking_count
FROM workspace.wanderbricks_teardown.booking_analysis
GROUP BY current_status
ORDER BY booking_count DESC;


-- ============================================================================
-- VERIFICATION 3: Inspect payment_analysis
--
-- Expected:
--   Payment rows include property and destination information.
-- ============================================================================

SELECT
    payment_id,
    booking_id,
    payment_amount,
    payment_status,
    payment_date,
    property_title,
    destination,
    country
FROM workspace.wanderbricks_teardown.payment_analysis
LIMIT 20;


-- ============================================================================
-- VERIFICATION 4: Inspect review_analysis
--
-- Expected:
--   Active review rows include property and destination information.
-- ============================================================================

SELECT
    review_id,
    booking_id,
    rating,
    review_date,
    property_title,
    destination,
    country
FROM workspace.wanderbricks_teardown.review_analysis
LIMIT 20;


-- ============================================================================
-- VERIFICATION 5: Confirm no deleted reviews appear
--
-- Expected:
--   deleted_reviews_present = 0
-- ============================================================================

SELECT
    COUNT(*) AS deleted_reviews_present
FROM workspace.wanderbricks_teardown.review_analysis AS ra
INNER JOIN samples.wanderbricks.reviews AS r
    ON ra.review_id = r.review_id
WHERE r.is_deleted = true;


-- ============================================================================
-- Final persistent view names
--
-- workspace.wanderbricks_teardown.booking_analysis
-- workspace.wanderbricks_teardown.payment_analysis
-- workspace.wanderbricks_teardown.review_analysis
-- ============================================================================
