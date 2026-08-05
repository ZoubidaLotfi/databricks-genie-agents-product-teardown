-- ============================================================================
-- File: sql/04-benchmark-reference-answers.sql
-- Project: Databricks Genie Agents Product Teardown
-- Purpose: Independent answer key for the 30-question Genie benchmark.
--
-- Rules:
--   - Run these queries outside the Genie Agent.
--   - Do not add them as Agent examples.
--   - Use completed payment amount, not revenue.
--   - Do not assume a currency.
-- ============================================================================

-- ============================================================================
-- CATEGORY 1: CORE METRIC ACCURACY
-- ============================================================================

-- Q01: How many total bookings are there?
-- Expected: 72,247.
SELECT COUNT(DISTINCT booking_id) AS total_bookings
FROM workspace.wanderbricks_teardown.booking_analysis;

-- Q02: How many bookings are completed?
-- Expected: 36,835.
SELECT COUNT(DISTINCT booking_id) AS completed_bookings
FROM workspace.wanderbricks_teardown.booking_analysis
WHERE current_status = 'completed';

-- Q03: How many bookings are cancelled?
-- Expected: 28,428.
SELECT COUNT(DISTINCT booking_id) AS cancelled_bookings
FROM workspace.wanderbricks_teardown.booking_analysis
WHERE current_status = 'cancelled';

-- Q04: What is the cancellation rate?
-- Expected definition:
-- cancelled / (completed + cancelled)
-- Pending and confirmed must be excluded.
-- Expected: 43.56%.
WITH counts AS (
    SELECT
        COUNT(DISTINCT CASE WHEN current_status = 'cancelled' THEN booking_id END) AS cancelled_bookings,
        COUNT(DISTINCT CASE WHEN current_status = 'completed' THEN booking_id END) AS completed_bookings
    FROM workspace.wanderbricks_teardown.booking_analysis
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
FROM counts;

-- Q05: What is the total completed payment amount?
-- Expected explanation:
-- Call this completed payment amount.
-- Do not call it revenue.
-- Do not add a currency symbol.
SELECT
    COUNT(*) AS completed_payment_records,
    COUNT(DISTINCT booking_id) AS bookings_with_completed_payment,
    ROUND(SUM(payment_amount), 2) AS completed_payment_amount
FROM workspace.wanderbricks_teardown.payment_analysis
WHERE payment_status = 'completed';

-- Q06: What is the overall average rating?
-- Expected explanation:
-- This reflects active reviews only, not every booking or customer.
SELECT
    COUNT(*) AS active_review_count,
    COUNT(DISTINCT booking_id) AS reviewed_bookings,
    ROUND(AVG(rating), 2) AS overall_average_rating
FROM workspace.wanderbricks_teardown.review_analysis
WHERE rating IS NOT NULL;


-- ============================================================================
-- CATEGORY 2: TIME AND TREND ANALYSIS
-- ============================================================================

-- Q07: Show bookings by booking creation month.
-- Expected explanation:
-- State that booking_created_at is used.
SELECT
    DATE_TRUNC('month', booking_created_at) AS booking_month,
    COUNT(DISTINCT booking_id) AS total_bookings
FROM workspace.wanderbricks_teardown.booking_analysis
GROUP BY DATE_TRUNC('month', booking_created_at)
ORDER BY booking_month;

-- Q08: Which month had the most bookings?
-- Expected explanation:
-- State that booking creation month is used.
WITH monthly AS (
    SELECT
        DATE_TRUNC('month', booking_created_at) AS booking_month,
        COUNT(DISTINCT booking_id) AS total_bookings
    FROM workspace.wanderbricks_teardown.booking_analysis
    GROUP BY DATE_TRUNC('month', booking_created_at)
)
SELECT booking_month, total_bookings
FROM monthly
ORDER BY total_bookings DESC, booking_month DESC
LIMIT 1;

-- Q09: Show completed bookings by check-in month.
-- Expected explanation:
-- State that check_in is used, not booking_created_at.
SELECT
    DATE_TRUNC('month', check_in) AS check_in_month,
    COUNT(DISTINCT booking_id) AS completed_bookings
FROM workspace.wanderbricks_teardown.booking_analysis
WHERE current_status = 'completed'
  AND check_in IS NOT NULL
GROUP BY DATE_TRUNC('month', check_in)
ORDER BY check_in_month;

-- Q10: How have completed payment amounts changed by payment month?
-- Expected explanation:
-- State that payment_date is used.
-- Do not call the metric revenue or add a currency.
WITH monthly AS (
    SELECT
        DATE_TRUNC('month', payment_date) AS payment_month,
        SUM(payment_amount) AS completed_payment_amount
    FROM workspace.wanderbricks_teardown.payment_analysis
    WHERE payment_status = 'completed'
      AND payment_date IS NOT NULL
    GROUP BY DATE_TRUNC('month', payment_date)
),
lagged AS (
    SELECT
        payment_month,
        completed_payment_amount,
        LAG(completed_payment_amount) OVER (ORDER BY payment_month) AS previous_month_amount
    FROM monthly
)
SELECT
    payment_month,
    ROUND(completed_payment_amount, 2) AS completed_payment_amount,
    ROUND(previous_month_amount, 2) AS previous_month_amount,
    ROUND(completed_payment_amount - previous_month_amount, 2) AS change_amount,
    ROUND(
        100.0 * (completed_payment_amount - previous_month_amount)
        / NULLIF(previous_month_amount, 0),
        2
    ) AS change_pct
FROM lagged
ORDER BY payment_month;

-- Q11: Which month had the highest cancellation rate?
-- Expected explanation:
-- State that booking creation month is used.
-- Use cancelled / (completed + cancelled).
WITH monthly AS (
    SELECT
        DATE_TRUNC('month', booking_created_at) AS booking_month,
        COUNT(DISTINCT CASE WHEN current_status = 'cancelled' THEN booking_id END) AS cancelled_bookings,
        COUNT(DISTINCT CASE WHEN current_status = 'completed' THEN booking_id END) AS completed_bookings
    FROM workspace.wanderbricks_teardown.booking_analysis
    GROUP BY DATE_TRUNC('month', booking_created_at)
)
SELECT
    booking_month,
    cancelled_bookings,
    completed_bookings,
    ROUND(
        100.0 * cancelled_bookings
        / NULLIF(cancelled_bookings + completed_bookings, 0),
        2
    ) AS cancellation_rate_pct
FROM monthly
WHERE cancelled_bookings + completed_bookings > 0
ORDER BY cancellation_rate_pct DESC, booking_month
LIMIT 1;

-- Q12: Compare booking volume in the latest three complete months.
-- Reference definition:
-- Exclude the month containing MAX(booking_created_at).
-- Use the three full months immediately before it.
-- Expected explanation:
-- State how complete month was defined.
WITH boundary AS (
    SELECT DATE_TRUNC('month', MAX(booking_created_at)) AS latest_observed_month
    FROM workspace.wanderbricks_teardown.booking_analysis
),
monthly AS (
    SELECT
        DATE_TRUNC('month', b.booking_created_at) AS booking_month,
        COUNT(DISTINCT b.booking_id) AS total_bookings
    FROM workspace.wanderbricks_teardown.booking_analysis b
    CROSS JOIN boundary d
    WHERE b.booking_created_at >= ADD_MONTHS(d.latest_observed_month, -3)
      AND b.booking_created_at < d.latest_observed_month
    GROUP BY DATE_TRUNC('month', b.booking_created_at)
),
lagged AS (
    SELECT
        booking_month,
        total_bookings,
        LAG(total_bookings) OVER (ORDER BY booking_month) AS previous_month_bookings
    FROM monthly
)
SELECT
    booking_month,
    total_bookings,
    previous_month_bookings,
    total_bookings - previous_month_bookings AS change_in_bookings,
    ROUND(
        100.0 * (total_bookings - previous_month_bookings)
        / NULLIF(previous_month_bookings, 0),
        2
    ) AS change_pct
FROM lagged
ORDER BY booking_month;


-- ============================================================================
-- CATEGORY 3: SEGMENTATION AND RANKING
-- ============================================================================

-- Q13: Which destination has the most bookings?
SELECT
    destination,
    country,
    COUNT(DISTINCT booking_id) AS total_bookings
FROM workspace.wanderbricks_teardown.booking_analysis
GROUP BY destination, country
ORDER BY total_bookings DESC, destination
LIMIT 1;

-- Q14: Show the top five countries by booking volume.
WITH country_totals AS (
    SELECT
        country,
        COUNT(DISTINCT booking_id) AS total_bookings
    FROM workspace.wanderbricks_teardown.booking_analysis
    GROUP BY country
)
SELECT
    country,
    total_bookings,
    ROUND(
        100.0 * total_bookings / SUM(total_bookings) OVER (),
        2
    ) AS share_of_bookings_pct
FROM country_totals
ORDER BY total_bookings DESC, country
LIMIT 5;

-- Q15: Which property type has the most completed bookings?
SELECT
    property_type,
    COUNT(DISTINCT booking_id) AS completed_bookings
FROM workspace.wanderbricks_teardown.booking_analysis
WHERE current_status = 'completed'
GROUP BY property_type
ORDER BY completed_bookings DESC, property_type
LIMIT 1;

-- Q16: Which destinations have the highest completed payment amount?
-- Expected explanation:
-- Use completed payment amount, not revenue.
-- Do not add a currency symbol.
SELECT
    destination,
    country,
    COUNT(DISTINCT booking_id) AS bookings_with_completed_payment,
    ROUND(SUM(payment_amount), 2) AS completed_payment_amount
FROM workspace.wanderbricks_teardown.payment_analysis
WHERE payment_status = 'completed'
GROUP BY destination, country
ORDER BY completed_payment_amount DESC, destination
LIMIT 10;

-- Q17: Which destinations have the lowest cancellation rate among those with
-- at least 1,000 bookings?
WITH metrics AS (
    SELECT
        destination,
        country,
        COUNT(DISTINCT booking_id) AS total_bookings,
        COUNT(DISTINCT CASE WHEN current_status = 'cancelled' THEN booking_id END) AS cancelled_bookings,
        COUNT(DISTINCT CASE WHEN current_status = 'completed' THEN booking_id END) AS completed_bookings
    FROM workspace.wanderbricks_teardown.booking_analysis
    GROUP BY destination, country
)
SELECT
    destination,
    country,
    total_bookings,
    cancelled_bookings,
    completed_bookings,
    ROUND(
        100.0 * cancelled_bookings
        / NULLIF(cancelled_bookings + completed_bookings, 0),
        2
    ) AS cancellation_rate_pct
FROM metrics
WHERE total_bookings >= 1000
ORDER BY cancellation_rate_pct ASC, total_bookings DESC;

-- Q18: Which destinations have the lowest average rating among those with at
-- least 1,000 reviews?
-- Expected explanation:
-- State the 1,000-review threshold and include review_count.
SELECT
    destination,
    country,
    COUNT(*) AS review_count,
    ROUND(AVG(rating), 2) AS average_rating
FROM workspace.wanderbricks_teardown.review_analysis
WHERE rating IS NOT NULL
GROUP BY destination, country
HAVING COUNT(*) >= 1000
ORDER BY average_rating ASC, review_count DESC;


-- ============================================================================
-- CATEGORY 4: DATA QUALITY AND AMBIGUITY
-- ============================================================================

-- Q19: What is Wanderbricks revenue?
-- Expected explanation:
-- The dataset has no production-approved revenue definition.
-- booking_value is not confirmed collected revenue.
-- completed payment amount may be shown as a payment-based proxy, but it must
-- not be presented as recognized revenue.
-- Ask which definition is intended or show separate candidate measures.
WITH booking_values AS (
    SELECT
        ROUND(SUM(booking_value), 2) AS total_booking_value,
        ROUND(SUM(CASE WHEN current_status = 'completed' THEN booking_value ELSE 0 END), 2)
            AS completed_booking_value
    FROM workspace.wanderbricks_teardown.booking_analysis
),
payments AS (
    SELECT
        ROUND(SUM(CASE WHEN payment_status = 'completed' THEN payment_amount ELSE 0 END), 2)
            AS completed_payment_amount
    FROM workspace.wanderbricks_teardown.payment_analysis
)
SELECT
    b.total_booking_value,
    b.completed_booking_value,
    p.completed_payment_amount
FROM booking_values b
CROSS JOIN payments p;

-- Q20: What currency are completed payment amounts recorded in?
-- Expected explanation:
-- No confirmed currency field exists in the available payment data.
-- The Agent must not assume USD, EUR, or another currency.
-- No numeric answer is required.
SELECT
    table_catalog,
    table_schema,
    table_name,
    column_name,
    data_type
FROM workspace.information_schema.columns
WHERE table_schema = 'wanderbricks_teardown'
  AND table_name = 'payment_analysis'
ORDER BY ordinal_position;

-- Q21: Which destination has the highest average rating?
-- Expected explanation:
-- Include review_count and warn that the raw winner may have very few reviews.
-- Show both the raw winner and the winner among destinations with >= 1,000 reviews.
WITH ratings AS (
    SELECT
        destination,
        country,
        COUNT(*) AS review_count,
        AVG(rating) AS average_rating
    FROM workspace.wanderbricks_teardown.review_analysis
    WHERE rating IS NOT NULL
    GROUP BY destination, country
),
raw_ranked AS (
    SELECT *,
           ROW_NUMBER() OVER (
               ORDER BY average_rating DESC, review_count DESC, destination
           ) AS rn
    FROM ratings
),
filtered_ranked AS (
    SELECT *,
           ROW_NUMBER() OVER (
               ORDER BY average_rating DESC, review_count DESC, destination
           ) AS rn
    FROM ratings
    WHERE review_count >= 1000
)
SELECT
    'raw_highest_average' AS result_type,
    destination,
    country,
    review_count,
    ROUND(average_rating, 2) AS average_rating
FROM raw_ranked
WHERE rn = 1
UNION ALL
SELECT
    'highest_with_at_least_1000_reviews',
    destination,
    country,
    review_count,
    ROUND(average_rating, 2)
FROM filtered_ranked
WHERE rn = 1;

-- Q22: Which high-volume destination has the lowest rating?
-- Expected explanation:
-- High volume is undefined.
-- Ask for clarification or state the threshold used.
-- Benchmark assumption: at least 1,000 active reviews.
SELECT
    destination,
    country,
    COUNT(*) AS review_count,
    ROUND(AVG(rating), 2) AS average_rating
FROM workspace.wanderbricks_teardown.review_analysis
WHERE rating IS NOT NULL
GROUP BY destination, country
HAVING COUNT(*) >= 1000
ORDER BY average_rating ASC, review_count DESC
LIMIT 1;

-- Q23: Which destination performs best?
-- Expected explanation:
-- "Best" is undefined.
-- Ask which metric matters or compare multiple metrics.
-- Do not present one destination as objectively best without criteria.
WITH bookings AS (
    SELECT
        destination,
        country,
        COUNT(DISTINCT booking_id) AS total_bookings,
        COUNT(DISTINCT CASE WHEN current_status = 'completed' THEN booking_id END) AS completed_bookings,
        ROUND(
            100.0 * COUNT(DISTINCT CASE WHEN current_status = 'cancelled' THEN booking_id END)
            / NULLIF(
                COUNT(DISTINCT CASE WHEN current_status IN ('completed', 'cancelled') THEN booking_id END),
                0
            ),
            2
        ) AS cancellation_rate_pct
    FROM workspace.wanderbricks_teardown.booking_analysis
    GROUP BY destination, country
),
payments AS (
    SELECT
        destination,
        country,
        ROUND(SUM(payment_amount), 2) AS completed_payment_amount
    FROM workspace.wanderbricks_teardown.payment_analysis
    WHERE payment_status = 'completed'
    GROUP BY destination, country
),
ratings AS (
    SELECT
        destination,
        country,
        COUNT(*) AS review_count,
        ROUND(AVG(rating), 2) AS average_rating
    FROM workspace.wanderbricks_teardown.review_analysis
    WHERE rating IS NOT NULL
    GROUP BY destination, country
)
SELECT
    b.destination,
    b.country,
    b.total_bookings,
    b.completed_bookings,
    b.cancellation_rate_pct,
    COALESCE(p.completed_payment_amount, 0) AS completed_payment_amount,
    COALESCE(r.review_count, 0) AS review_count,
    r.average_rating
FROM bookings b
LEFT JOIN payments p
    ON b.destination = p.destination AND b.country = p.country
LEFT JOIN ratings r
    ON b.destination = r.destination AND b.country = r.country
ORDER BY b.total_bookings DESC;

-- Q24: How many active bookings are there?
-- Expected explanation:
-- "Active" is undefined.
-- Ask whether it means pending, confirmed, or both.
-- Benchmark assumption: active = pending + confirmed.
SELECT
    COUNT(DISTINCT CASE WHEN current_status = 'pending' THEN booking_id END) AS pending_bookings,
    COUNT(DISTINCT CASE WHEN current_status = 'confirmed' THEN booking_id END) AS confirmed_bookings,
    COUNT(DISTINCT CASE WHEN current_status IN ('pending', 'confirmed') THEN booking_id END)
        AS proposed_active_bookings
FROM workspace.wanderbricks_teardown.booking_analysis;


-- ============================================================================
-- CATEGORY 5: MULTI-STEP AND FOLLOW-UP ANALYSIS
-- ============================================================================

-- Q25: Which destinations combine high booking volume with below-average ratings?
-- Benchmark assumptions:
-- High booking volume = at least 1,000 bookings.
-- Below average = below the overall active-review average.
-- Expected explanation:
-- State the threshold and include review_count.
WITH bookings AS (
    SELECT
        destination,
        country,
        COUNT(DISTINCT booking_id) AS total_bookings
    FROM workspace.wanderbricks_teardown.booking_analysis
    GROUP BY destination, country
),
ratings AS (
    SELECT
        destination,
        country,
        COUNT(*) AS review_count,
        AVG(rating) AS average_rating
    FROM workspace.wanderbricks_teardown.review_analysis
    WHERE rating IS NOT NULL
    GROUP BY destination, country
),
overall AS (
    SELECT AVG(rating) AS overall_average_rating
    FROM workspace.wanderbricks_teardown.review_analysis
    WHERE rating IS NOT NULL
)
SELECT
    b.destination,
    b.country,
    b.total_bookings,
    r.review_count,
    ROUND(r.average_rating, 2) AS average_rating,
    ROUND(o.overall_average_rating, 2) AS overall_average_rating,
    ROUND(r.average_rating - o.overall_average_rating, 3) AS rating_difference
FROM bookings b
JOIN ratings r
    ON b.destination = r.destination AND b.country = r.country
CROSS JOIN overall o
WHERE b.total_bookings >= 1000
  AND r.average_rating < o.overall_average_rating
ORDER BY r.average_rating ASC, b.total_bookings DESC;

-- Q26: Which destinations have both above-average cancellation rates and
-- above-average payment amounts?
-- Reference definition:
-- Compare each destination with the unweighted average across destinations.
-- Expected explanation:
-- State how "average" was calculated.
WITH bookings AS (
    SELECT
        destination,
        country,
        COUNT(DISTINCT booking_id) AS total_bookings,
        100.0 * COUNT(DISTINCT CASE WHEN current_status = 'cancelled' THEN booking_id END)
        / NULLIF(
            COUNT(DISTINCT CASE WHEN current_status IN ('completed', 'cancelled') THEN booking_id END),
            0
        ) AS cancellation_rate_pct
    FROM workspace.wanderbricks_teardown.booking_analysis
    GROUP BY destination, country
),
payments AS (
    SELECT
        destination,
        country,
        SUM(payment_amount) AS completed_payment_amount
    FROM workspace.wanderbricks_teardown.payment_analysis
    WHERE payment_status = 'completed'
    GROUP BY destination, country
),
combined AS (
    SELECT
        b.destination,
        b.country,
        b.total_bookings,
        b.cancellation_rate_pct,
        COALESCE(p.completed_payment_amount, 0) AS completed_payment_amount
    FROM bookings b
    LEFT JOIN payments p
        ON b.destination = p.destination AND b.country = p.country
),
averages AS (
    SELECT
        AVG(cancellation_rate_pct) AS avg_cancellation_rate,
        AVG(completed_payment_amount) AS avg_payment_amount
    FROM combined
)
SELECT
    c.destination,
    c.country,
    c.total_bookings,
    ROUND(c.cancellation_rate_pct, 2) AS cancellation_rate_pct,
    ROUND(a.avg_cancellation_rate, 2) AS average_destination_cancellation_rate,
    ROUND(c.completed_payment_amount, 2) AS completed_payment_amount,
    ROUND(a.avg_payment_amount, 2) AS average_destination_payment_amount
FROM combined c
CROSS JOIN averages a
WHERE c.cancellation_rate_pct > a.avg_cancellation_rate
  AND c.completed_payment_amount > a.avg_payment_amount
ORDER BY c.cancellation_rate_pct DESC, c.completed_payment_amount DESC;

-- Q27: Compare Phuket and Gold Coast across bookings, cancellations, payments,
-- and ratings.
-- Expected explanation:
-- Aggregate each view separately before joining.
WITH bookings AS (
    SELECT
        destination,
        country,
        COUNT(DISTINCT booking_id) AS total_bookings,
        COUNT(DISTINCT CASE WHEN current_status = 'completed' THEN booking_id END) AS completed_bookings,
        COUNT(DISTINCT CASE WHEN current_status = 'cancelled' THEN booking_id END) AS cancelled_bookings,
        ROUND(
            100.0 * COUNT(DISTINCT CASE WHEN current_status = 'cancelled' THEN booking_id END)
            / NULLIF(
                COUNT(DISTINCT CASE WHEN current_status IN ('completed', 'cancelled') THEN booking_id END),
                0
            ),
            2
        ) AS cancellation_rate_pct
    FROM workspace.wanderbricks_teardown.booking_analysis
    WHERE destination IN ('Phuket', 'Gold Coast')
    GROUP BY destination, country
),
payments AS (
    SELECT
        destination,
        country,
        COUNT(DISTINCT booking_id) AS bookings_with_completed_payment,
        ROUND(SUM(payment_amount), 2) AS completed_payment_amount
    FROM workspace.wanderbricks_teardown.payment_analysis
    WHERE payment_status = 'completed'
      AND destination IN ('Phuket', 'Gold Coast')
    GROUP BY destination, country
),
ratings AS (
    SELECT
        destination,
        country,
        COUNT(*) AS review_count,
        ROUND(AVG(rating), 2) AS average_rating
    FROM workspace.wanderbricks_teardown.review_analysis
    WHERE rating IS NOT NULL
      AND destination IN ('Phuket', 'Gold Coast')
    GROUP BY destination, country
)
SELECT
    b.destination,
    b.country,
    b.total_bookings,
    b.completed_bookings,
    b.cancelled_bookings,
    b.cancellation_rate_pct,
    COALESCE(p.bookings_with_completed_payment, 0) AS bookings_with_completed_payment,
    COALESCE(p.completed_payment_amount, 0) AS completed_payment_amount,
    COALESCE(r.review_count, 0) AS review_count,
    r.average_rating
FROM bookings b
LEFT JOIN payments p
    ON b.destination = p.destination AND b.country = p.country
LEFT JOIN ratings r
    ON b.destination = r.destination AND b.country = r.country
ORDER BY b.destination;

-- Q28: Which countries contribute most to completed bookings?
WITH country_completed AS (
    SELECT
        country,
        COUNT(DISTINCT booking_id) AS completed_bookings
    FROM workspace.wanderbricks_teardown.booking_analysis
    WHERE current_status = 'completed'
    GROUP BY country
)
SELECT
    country,
    completed_bookings,
    ROUND(
        100.0 * completed_bookings / SUM(completed_bookings) OVER (),
        2
    ) AS share_of_completed_bookings_pct
FROM country_completed
ORDER BY completed_bookings DESC, country;

-- Q29: Among the top ten destinations by bookings, which have the lowest ratings?
-- Expected explanation:
-- Include review_count.
WITH booking_counts AS (
    SELECT
        destination,
        country,
        COUNT(DISTINCT booking_id) AS total_bookings
    FROM workspace.wanderbricks_teardown.booking_analysis
    GROUP BY destination, country
),
top_ten AS (
    SELECT *
    FROM booking_counts
    ORDER BY total_bookings DESC, destination
    LIMIT 10
),
ratings AS (
    SELECT
        destination,
        country,
        COUNT(*) AS review_count,
        AVG(rating) AS average_rating
    FROM workspace.wanderbricks_teardown.review_analysis
    WHERE rating IS NOT NULL
    GROUP BY destination, country
)
SELECT
    t.destination,
    t.country,
    t.total_bookings,
    r.review_count,
    ROUND(r.average_rating, 2) AS average_rating
FROM top_ten t
LEFT JOIN ratings r
    ON t.destination = r.destination AND t.country = r.country
ORDER BY r.average_rating ASC, t.total_bookings DESC;

-- Q30: Which destination appears to need the most management attention, and why?
-- Expected explanation:
-- This is judgment, not an objective fact.
-- The Agent must explain its criteria.
--
-- Proposed benchmark heuristic:
-- +1 above overall cancellation rate
-- +1 below overall average rating
-- +1 above average destination booking volume
-- +1 above average destination completed payment amount
-- Require at least 500 active reviews.
-- This is a teardown heuristic, not a production-approved KPI.
WITH bookings AS (
    SELECT
        destination,
        country,
        COUNT(DISTINCT booking_id) AS total_bookings,
        COUNT(DISTINCT CASE WHEN current_status = 'completed' THEN booking_id END) AS completed_bookings,
        COUNT(DISTINCT CASE WHEN current_status = 'cancelled' THEN booking_id END) AS cancelled_bookings,
        100.0 * COUNT(DISTINCT CASE WHEN current_status = 'cancelled' THEN booking_id END)
        / NULLIF(
            COUNT(DISTINCT CASE WHEN current_status IN ('completed', 'cancelled') THEN booking_id END),
            0
        ) AS cancellation_rate_pct
    FROM workspace.wanderbricks_teardown.booking_analysis
    GROUP BY destination, country
),
payments AS (
    SELECT
        destination,
        country,
        SUM(payment_amount) AS completed_payment_amount
    FROM workspace.wanderbricks_teardown.payment_analysis
    WHERE payment_status = 'completed'
    GROUP BY destination, country
),
ratings AS (
    SELECT
        destination,
        country,
        COUNT(*) AS review_count,
        AVG(rating) AS average_rating
    FROM workspace.wanderbricks_teardown.review_analysis
    WHERE rating IS NOT NULL
    GROUP BY destination, country
),
combined AS (
    SELECT
        b.destination,
        b.country,
        b.total_bookings,
        b.completed_bookings,
        b.cancelled_bookings,
        b.cancellation_rate_pct,
        COALESCE(p.completed_payment_amount, 0) AS completed_payment_amount,
        COALESCE(r.review_count, 0) AS review_count,
        r.average_rating
    FROM bookings b
    LEFT JOIN payments p
        ON b.destination = p.destination AND b.country = p.country
    LEFT JOIN ratings r
        ON b.destination = r.destination AND b.country = r.country
),
benchmarks AS (
    SELECT
        AVG(total_bookings) AS avg_destination_bookings,
        AVG(completed_payment_amount) AS avg_destination_payment_amount,
        100.0 * SUM(cancelled_bookings)
            / NULLIF(SUM(cancelled_bookings) + SUM(completed_bookings), 0)
            AS overall_cancellation_rate,
        SUM(average_rating * review_count)
            / NULLIF(SUM(review_count), 0)
            AS overall_average_rating
    FROM combined
),
scored AS (
    SELECT
        c.*,
        b.avg_destination_bookings,
        b.avg_destination_payment_amount,
        b.overall_cancellation_rate,
        b.overall_average_rating,
        CASE WHEN c.cancellation_rate_pct > b.overall_cancellation_rate THEN 1 ELSE 0 END
            AS above_average_cancellation_flag,
        CASE WHEN c.average_rating < b.overall_average_rating THEN 1 ELSE 0 END
            AS below_average_rating_flag,
        CASE WHEN c.total_bookings > b.avg_destination_bookings THEN 1 ELSE 0 END
            AS above_average_booking_volume_flag,
        CASE WHEN c.completed_payment_amount > b.avg_destination_payment_amount THEN 1 ELSE 0 END
            AS above_average_payment_exposure_flag
    FROM combined c
    CROSS JOIN benchmarks b
    WHERE c.review_count >= 500
)
SELECT
    destination,
    country,
    total_bookings,
    completed_bookings,
    cancelled_bookings,
    ROUND(cancellation_rate_pct, 2) AS cancellation_rate_pct,
    ROUND(overall_cancellation_rate, 2) AS overall_cancellation_rate,
    ROUND(completed_payment_amount, 2) AS completed_payment_amount,
    review_count,
    ROUND(average_rating, 2) AS average_rating,
    ROUND(overall_average_rating, 2) AS overall_average_rating,
    above_average_cancellation_flag,
    below_average_rating_flag,
    above_average_booking_volume_flag,
    above_average_payment_exposure_flag,
    (
        above_average_cancellation_flag
        + below_average_rating_flag
        + above_average_booking_volume_flag
        + above_average_payment_exposure_flag
    ) AS attention_priority_score
FROM scored
ORDER BY
    attention_priority_score DESC,
    above_average_cancellation_flag DESC,
    below_average_rating_flag DESC,
    total_bookings DESC
LIMIT 10;

-- ============================================================================
-- END
-- ============================================================================
