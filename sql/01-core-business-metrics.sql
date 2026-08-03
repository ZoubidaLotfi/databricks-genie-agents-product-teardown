-- ============================================================================
-- File: sql/01-core-business-metrics.sql
-- Project: Databricks Genie Agents Product Teardown
-- Dataset: samples.wanderbricks
--
-- Purpose:
--   Create a small, reusable set of SQL queries for the Day 2 Wanderbricks
--   semantic model and the first dashboard baseline.
--
-- Important assumptions:
--   1. The latest row in booking_updates represents the current booking state.
--   2. If a booking has no update, the original bookings row is used.
--   3. completed and cancelled are treated as terminal booking statuses.
--   4. The proposed cancellation rate excludes pending and confirmed bookings.
--   5. Completed payments are treated as collected payment amount.
--   6. Deleted reviews are excluded from rating metrics.
--
-- This is a teardown project, not a production financial model.
-- ============================================================================


-- ============================================================================
-- QUERY 1: Reconstruct the latest known state of every booking
--
-- Purpose:
--   The status stored in samples.wanderbricks.bookings is often stale.
--   This temporary view uses the most recent booking_updates row when one
--   exists and otherwise keeps the original booking record.
--
-- Output:
--   One current row per booking.
-- ============================================================================

CREATE OR REPLACE TEMP VIEW current_bookings AS
WITH latest_updates AS (
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
)

SELECT
    b.booking_id,
    COALESCE(u.user_id, b.user_id) AS user_id,
    COALESCE(u.property_id, b.property_id) AS property_id,
    COALESCE(u.check_in, b.check_in) AS check_in,
    COALESCE(u.check_out, b.check_out) AS check_out,
    COALESCE(u.guests_count, b.guests_count) AS guests_count,
    COALESCE(u.total_amount, b.total_amount) AS booking_value,
    COALESCE(u.status, b.status) AS current_status,
    b.created_at,
    COALESCE(u.updated_at, b.updated_at) AS latest_updated_at,
    CASE
        WHEN u.booking_id IS NOT NULL THEN TRUE
        ELSE FALSE
    END AS has_booking_update
FROM samples.wanderbricks.bookings AS b
LEFT JOIN latest_updates AS u
    ON b.booking_id = u.booking_id
    AND u.row_number = 1;


-- ============================================================================
-- QUERY 2: Validate the reconstructed booking status distribution
--
-- Purpose:
--   Confirm that the temporary view contains all bookings and inspect the
--   latest status distribution before using it in business metrics.
-- ============================================================================

SELECT
    current_status,
    COUNT(*) AS booking_count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS share_of_bookings_pct,
    ROUND(AVG(booking_value), 2) AS average_booking_value,
    ROUND(SUM(booking_value), 2) AS total_booking_value
FROM current_bookings
GROUP BY current_status
ORDER BY booking_count DESC;


-- ============================================================================
-- QUERY 3: Total bookings
--
-- Purpose:
--   Count the number of distinct bookings in the reconstructed current-booking
--   dataset.
--
-- Metric definition:
--   Total bookings = COUNT(DISTINCT booking_id)
-- ============================================================================

SELECT
    COUNT(DISTINCT booking_id) AS total_bookings
FROM current_bookings;


-- ============================================================================
-- QUERY 4: Completed bookings
--
-- Purpose:
--   Count bookings whose latest known status is completed.
--
-- Metric definition:
--   Completed bookings = distinct bookings where current_status = 'completed'
-- ============================================================================

SELECT
    COUNT(DISTINCT booking_id) AS completed_bookings
FROM current_bookings
WHERE current_status = 'completed';


-- ============================================================================
-- QUERY 5: Proposed cancellation rate
--
-- Purpose:
--   Calculate the percentage of terminal bookings that ended in cancellation.
--
-- Proposed metric definition:
--   Cancelled bookings / (Completed bookings + Cancelled bookings)
--
-- Pending and confirmed bookings are excluded because they have not reached a
-- terminal status.
-- ============================================================================

WITH terminal_booking_counts AS (
    SELECT
        SUM(
            CASE
                WHEN current_status = 'cancelled' THEN 1
                ELSE 0
            END
        ) AS cancelled_bookings,

        SUM(
            CASE
                WHEN current_status = 'completed' THEN 1
                ELSE 0
            END
        ) AS completed_bookings
    FROM current_bookings
)

SELECT
    cancelled_bookings,
    completed_bookings,
    cancelled_bookings + completed_bookings AS terminal_bookings,
    ROUND(
        100.0 * cancelled_bookings
        / NULLIF(cancelled_bookings + completed_bookings, 0),
        2
    ) AS cancellation_rate_pct
FROM terminal_booking_counts;


-- ============================================================================
-- QUERY 6: Completed payment amount
--
-- Purpose:
--   Measure the amount attached to completed payment records.
--
-- Proposed metric definition:
--   Sum of payments.amount where payments.status = 'completed'
--
-- Important:
--   This is called completed payment amount or collected payment amount in the
--   teardown. It is not presented as production-approved recognized revenue.
-- ============================================================================

SELECT
    COUNT(*) AS completed_payment_records,
    COUNT(DISTINCT booking_id) AS bookings_with_completed_payment,
    ROUND(SUM(amount), 2) AS completed_payment_amount,
    ROUND(AVG(amount), 2) AS average_completed_payment_amount,
    MIN(payment_date) AS first_completed_payment_date,
    MAX(payment_date) AS latest_completed_payment_date
FROM samples.wanderbricks.payments
WHERE status = 'completed';


-- ============================================================================
-- QUERY 7: Average customer rating
--
-- Purpose:
--   Measure customer satisfaction using active, non-deleted reviews.
--
-- Metric definition:
--   Average of reviews.rating where is_deleted = false
--
-- Important:
--   This metric represents customers who chose to leave a review, not all
--   customers.
-- ============================================================================

SELECT
    COUNT(*) AS active_review_count,
    COUNT(DISTINCT booking_id) AS reviewed_bookings,
    ROUND(AVG(rating), 2) AS average_rating,
    MIN(rating) AS minimum_rating,
    MAX(rating) AS maximum_rating
FROM samples.wanderbricks.reviews
WHERE is_deleted = false
  AND rating IS NOT NULL;


-- ============================================================================
-- QUERY 8: Monthly booking trend
--
-- Purpose:
--   Create a simple dashboard trend showing how many bookings were created
--   each month.
--
-- Date choice:
--   Uses bookings.created_at because this query measures booking creation.
-- ============================================================================

SELECT
    DATE_TRUNC('month', created_at) AS booking_month,
    COUNT(DISTINCT booking_id) AS total_bookings,
    SUM(
        CASE
            WHEN current_status = 'completed' THEN 1
            ELSE 0
        END
    ) AS completed_bookings,
    SUM(
        CASE
            WHEN current_status = 'cancelled' THEN 1
            ELSE 0
        END
    ) AS cancelled_bookings
FROM current_bookings
GROUP BY DATE_TRUNC('month', created_at)
ORDER BY booking_month;


-- ============================================================================
-- QUERY 9: Booking performance by destination
--
-- Purpose:
--   Compare destinations using booking volume and latest booking status.
--
-- Relationships:
--   current_bookings.property_id -> properties.property_id
--   properties.destination_id    -> destinations.destination_id
-- ============================================================================

SELECT
    d.destination,
    d.country,
    COUNT(DISTINCT cb.booking_id) AS total_bookings,
    SUM(
        CASE
            WHEN cb.current_status = 'completed' THEN 1
            ELSE 0
        END
    ) AS completed_bookings,
    SUM(
        CASE
            WHEN cb.current_status = 'cancelled' THEN 1
            ELSE 0
        END
    ) AS cancelled_bookings,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN cb.current_status = 'cancelled' THEN 1
                ELSE 0
            END
        )
        / NULLIF(
            SUM(
                CASE
                    WHEN cb.current_status IN ('completed', 'cancelled') THEN 1
                    ELSE 0
                END
            ),
            0
        ),
        2
    ) AS cancellation_rate_pct
FROM current_bookings AS cb
INNER JOIN samples.wanderbricks.properties AS p
    ON cb.property_id = p.property_id
INNER JOIN samples.wanderbricks.destinations AS d
    ON p.destination_id = d.destination_id
GROUP BY
    d.destination,
    d.country
ORDER BY total_bookings DESC;


-- ============================================================================
-- QUERY 10: Completed payment amount by destination
--
-- Purpose:
--   Compare destinations using completed payment amount.
--
-- Important:
--   This uses payment_date for payment timing and includes only payment records
--   whose status is completed.
-- ============================================================================

SELECT
    d.destination,
    d.country,
    COUNT(DISTINCT pay.booking_id) AS paid_bookings,
    ROUND(SUM(pay.amount), 2) AS completed_payment_amount,
    ROUND(AVG(pay.amount), 2) AS average_completed_payment_amount
FROM samples.wanderbricks.payments AS pay
INNER JOIN current_bookings AS cb
    ON pay.booking_id = cb.booking_id
INNER JOIN samples.wanderbricks.properties AS p
    ON cb.property_id = p.property_id
INNER JOIN samples.wanderbricks.destinations AS d
    ON p.destination_id = d.destination_id
WHERE pay.status = 'completed'
GROUP BY
    d.destination,
    d.country
ORDER BY completed_payment_amount DESC;


-- ============================================================================
-- QUERY 11: Average rating by destination
--
-- Purpose:
--   Compare customer satisfaction across destinations.
--
-- Important:
--   Deleted reviews and null ratings are excluded.
-- ============================================================================

SELECT
    d.destination,
    d.country,
    COUNT(*) AS active_review_count,
    ROUND(AVG(r.rating), 2) AS average_rating
FROM samples.wanderbricks.reviews AS r
INNER JOIN samples.wanderbricks.properties AS p
    ON r.property_id = p.property_id
INNER JOIN samples.wanderbricks.destinations AS d
    ON p.destination_id = d.destination_id
WHERE r.is_deleted = false
  AND r.rating IS NOT NULL
GROUP BY
    d.destination,
    d.country
ORDER BY
    average_rating DESC,
    active_review_count DESC;


-- ============================================================================
-- QUERY 12: Combined destination overview
--
-- Purpose:
--   Produce one compact destination-level dataset for a simple dashboard.
--
-- Includes:
--   - Total bookings
--   - Completed bookings
--   - Cancelled bookings
--   - Proposed cancellation rate
--   - Completed payment amount
--   - Average rating
-- ============================================================================

WITH booking_metrics AS (
    SELECT
        p.destination_id,
        COUNT(DISTINCT cb.booking_id) AS total_bookings,

        SUM(
            CASE
                WHEN cb.current_status = 'completed' THEN 1
                ELSE 0
            END
        ) AS completed_bookings,

        SUM(
            CASE
                WHEN cb.current_status = 'cancelled' THEN 1
                ELSE 0
            END
        ) AS cancelled_bookings,

        ROUND(
            100.0 * SUM(
                CASE
                    WHEN cb.current_status = 'cancelled' THEN 1
                    ELSE 0
                END
            )
            / NULLIF(
                SUM(
                    CASE
                        WHEN cb.current_status IN ('completed', 'cancelled')
                            THEN 1
                        ELSE 0
                    END
                ),
                0
            ),
            2
        ) AS cancellation_rate_pct

    FROM current_bookings AS cb
    INNER JOIN samples.wanderbricks.properties AS p
        ON cb.property_id = p.property_id
    GROUP BY p.destination_id
),

payment_metrics AS (
    SELECT
        p.destination_id,
        COUNT(DISTINCT pay.booking_id) AS paid_bookings,
        ROUND(SUM(pay.amount), 2) AS completed_payment_amount
    FROM samples.wanderbricks.payments AS pay
    INNER JOIN current_bookings AS cb
        ON pay.booking_id = cb.booking_id
    INNER JOIN samples.wanderbricks.properties AS p
        ON cb.property_id = p.property_id
    WHERE pay.status = 'completed'
    GROUP BY p.destination_id
),

review_metrics AS (
    SELECT
        p.destination_id,
        COUNT(*) AS active_review_count,
        ROUND(AVG(r.rating), 2) AS average_rating
    FROM samples.wanderbricks.reviews AS r
    INNER JOIN samples.wanderbricks.properties AS p
        ON r.property_id = p.property_id
    WHERE r.is_deleted = false
      AND r.rating IS NOT NULL
    GROUP BY p.destination_id
)

SELECT
    d.destination_id,
    d.destination,
    d.country,
    b.total_bookings,
    b.completed_bookings,
    b.cancelled_bookings,
    b.cancellation_rate_pct,
    COALESCE(pay.paid_bookings, 0) AS paid_bookings,
    COALESCE(pay.completed_payment_amount, 0) AS completed_payment_amount,
    COALESCE(rev.active_review_count, 0) AS active_review_count,
    rev.average_rating
FROM booking_metrics AS b
INNER JOIN samples.wanderbricks.destinations AS d
    ON b.destination_id = d.destination_id
LEFT JOIN payment_metrics AS pay
    ON b.destination_id = pay.destination_id
LEFT JOIN review_metrics AS rev
    ON b.destination_id = rev.destination_id
ORDER BY b.total_bookings DESC;
