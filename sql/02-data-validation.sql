-- ============================================================================
-- File: sql/02-data-validation.sql
-- Project: Databricks Genie Agents Product Teardown
-- Dataset: samples.wanderbricks
--
-- Purpose:
--   Run six focused validation checks for the Day 2 Wanderbricks semantic model.
--
-- Result format:
--   Each validation query returns:
--     - check_name
--     - check_status: PASS or FAIL
--     - the values used to evaluate the check
--
-- Important:
--   This file recreates the current_bookings temporary view so it can be run
--   independently from sql/01-core-business-metrics.sql.
-- ============================================================================


-- ============================================================================
-- SETUP: Reconstruct the latest known state of every booking
--
-- Why this is needed:
--   The status and other values in the main bookings table may be stale.
--   The latest booking_updates row is used when one exists.
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
    COALESCE(u.updated_at, b.updated_at) AS latest_updated_at
FROM samples.wanderbricks.bookings AS b
LEFT JOIN latest_updates AS u
    ON b.booking_id = u.booking_id
    AND u.row_number = 1;


-- ============================================================================
-- CHECK 1: current_bookings contains exactly 72,247 unique bookings
--
-- What this checks:
--   Confirms that reconstructing the latest booking state did not lose or add
--   bookings.
--
-- Expected result:
--   unique_booking_count = 72,247
--   check_status = PASS
-- ============================================================================

SELECT
    'current_bookings has exactly 72,247 unique bookings' AS check_name,
    CASE
        WHEN COUNT(DISTINCT booking_id) = 72247 THEN 'PASS'
        ELSE 'FAIL'
    END AS check_status,
    72247 AS expected_unique_booking_count,
    COUNT(DISTINCT booking_id) AS actual_unique_booking_count
FROM current_bookings;


-- ============================================================================
-- CHECK 2: No duplicate booking_id exists in current_bookings
--
-- What this checks:
--   Confirms that the reconstructed dataset has one row per booking.
--
-- Expected result:
--   duplicate_booking_ids = 0
--   check_status = PASS
-- ============================================================================

WITH duplicate_booking_ids AS (
    SELECT
        booking_id,
        COUNT(*) AS row_count
    FROM current_bookings
    GROUP BY booking_id
    HAVING COUNT(*) > 1
)

SELECT
    'No duplicate booking_id exists in current_bookings' AS check_name,
    CASE
        WHEN COUNT(*) = 0 THEN 'PASS'
        ELSE 'FAIL'
    END AS check_status,
    0 AS expected_duplicate_booking_ids,
    COUNT(*) AS actual_duplicate_booking_ids
FROM duplicate_booking_ids;


-- ============================================================================
-- CHECK 3: Every booking property exists in properties
--
-- What this checks:
--   Confirms that every property_id used by current_bookings matches an
--   existing property in samples.wanderbricks.properties.
--
-- Expected result:
--   bookings_with_missing_property = 0
--   check_status = PASS
-- ============================================================================

SELECT
    'Every booking property exists in properties' AS check_name,
    CASE
        WHEN COUNT(*) = 0 THEN 'PASS'
        ELSE 'FAIL'
    END AS check_status,
    0 AS expected_bookings_with_missing_property,
    COUNT(*) AS actual_bookings_with_missing_property
FROM current_bookings AS cb
LEFT JOIN samples.wanderbricks.properties AS p
    ON cb.property_id = p.property_id
WHERE cb.property_id IS NULL
   OR p.property_id IS NULL;


-- ============================================================================
-- CHECK 4: Every property destination exists in destinations
--
-- What this checks:
--   Confirms that every destination_id used by properties matches an existing
--   destination in samples.wanderbricks.destinations.
--
-- Expected result:
--   properties_with_missing_destination = 0
--   check_status = PASS
-- ============================================================================

SELECT
    'Every property destination exists in destinations' AS check_name,
    CASE
        WHEN COUNT(*) = 0 THEN 'PASS'
        ELSE 'FAIL'
    END AS check_status,
    0 AS expected_properties_with_missing_destination,
    COUNT(*) AS actual_properties_with_missing_destination
FROM samples.wanderbricks.properties AS p
LEFT JOIN samples.wanderbricks.destinations AS d
    ON p.destination_id = d.destination_id
WHERE p.destination_id IS NULL
   OR d.destination_id IS NULL;


-- ============================================================================
-- CHECK 5: No booking has more than one completed payment
--
-- What this checks:
--   Confirms that completed payment amounts will not be double-counted when
--   grouped by booking.
--
-- Expected result:
--   bookings_with_multiple_completed_payments = 0
--   check_status = PASS
-- ============================================================================

WITH completed_payments_per_booking AS (
    SELECT
        booking_id,
        COUNT(*) AS completed_payment_count
    FROM samples.wanderbricks.payments
    WHERE status = 'completed'
    GROUP BY booking_id
),

bookings_with_multiple_completed_payments AS (
    SELECT
        booking_id,
        completed_payment_count
    FROM completed_payments_per_booking
    WHERE completed_payment_count > 1
)

SELECT
    'No booking has more than one completed payment' AS check_name,
    CASE
        WHEN COUNT(*) = 0 THEN 'PASS'
        ELSE 'FAIL'
    END AS check_status,
    0 AS expected_bookings_with_multiple_completed_payments,
    COUNT(*) AS actual_bookings_with_multiple_completed_payments
FROM bookings_with_multiple_completed_payments;


-- ============================================================================
-- CHECK 6: Active review ratings stay between 1 and 5
--
-- What this checks:
--   Confirms that every non-deleted review has a non-null rating within the
--   documented rating scale of 1.0 to 5.0.
--
-- Expected result:
--   invalid_active_review_ratings = 0
--   check_status = PASS
-- ============================================================================

SELECT
    'Active review ratings stay between 1 and 5' AS check_name,
    CASE
        WHEN COUNT(*) = 0 THEN 'PASS'
        ELSE 'FAIL'
    END AS check_status,
    0 AS expected_invalid_active_review_ratings,
    COUNT(*) AS actual_invalid_active_review_ratings
FROM samples.wanderbricks.reviews
WHERE is_deleted = false
  AND (
        rating IS NULL
        OR rating < 1
        OR rating > 5
      );


-- ============================================================================
-- OPTIONAL SUMMARY: Return all six validation results in one table
--
-- Purpose:
--   Provides a compact PASS/FAIL summary after the individual checks above.
--
-- Note:
--   This section repeats the validation logic so that all results can be viewed
--   together in one query result.
-- ============================================================================

WITH
booking_count_check AS (
    SELECT
        '1. Unique booking count' AS check_name,
        CASE
            WHEN COUNT(DISTINCT booking_id) = 72247 THEN 'PASS'
            ELSE 'FAIL'
        END AS check_status
    FROM current_bookings
),

duplicate_booking_check AS (
    SELECT
        '2. Duplicate booking IDs' AS check_name,
        CASE
            WHEN COUNT(*) = 0 THEN 'PASS'
            ELSE 'FAIL'
        END AS check_status
    FROM (
        SELECT booking_id
        FROM current_bookings
        GROUP BY booking_id
        HAVING COUNT(*) > 1
    )
),

booking_property_check AS (
    SELECT
        '3. Booking property references' AS check_name,
        CASE
            WHEN COUNT(*) = 0 THEN 'PASS'
            ELSE 'FAIL'
        END AS check_status
    FROM current_bookings AS cb
    LEFT JOIN samples.wanderbricks.properties AS p
        ON cb.property_id = p.property_id
    WHERE cb.property_id IS NULL
       OR p.property_id IS NULL
),

property_destination_check AS (
    SELECT
        '4. Property destination references' AS check_name,
        CASE
            WHEN COUNT(*) = 0 THEN 'PASS'
            ELSE 'FAIL'
        END AS check_status
    FROM samples.wanderbricks.properties AS p
    LEFT JOIN samples.wanderbricks.destinations AS d
        ON p.destination_id = d.destination_id
    WHERE p.destination_id IS NULL
       OR d.destination_id IS NULL
),

completed_payment_check AS (
    SELECT
        '5. Multiple completed payments' AS check_name,
        CASE
            WHEN COUNT(*) = 0 THEN 'PASS'
            ELSE 'FAIL'
        END AS check_status
    FROM (
        SELECT booking_id
        FROM samples.wanderbricks.payments
        WHERE status = 'completed'
        GROUP BY booking_id
        HAVING COUNT(*) > 1
    )
),

review_rating_check AS (
    SELECT
        '6. Active review rating range' AS check_name,
        CASE
            WHEN COUNT(*) = 0 THEN 'PASS'
            ELSE 'FAIL'
        END AS check_status
    FROM samples.wanderbricks.reviews
    WHERE is_deleted = false
      AND (
            rating IS NULL
            OR rating < 1
            OR rating > 5
          )
)

SELECT * FROM booking_count_check
UNION ALL
SELECT * FROM duplicate_booking_check
UNION ALL
SELECT * FROM booking_property_check
UNION ALL
SELECT * FROM property_destination_check
UNION ALL
SELECT * FROM completed_payment_check
UNION ALL
SELECT * FROM review_rating_check;
