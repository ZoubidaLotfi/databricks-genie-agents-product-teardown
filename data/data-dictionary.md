# Wanderbricks Data Dictionary

## Purpose

This data dictionary documents the core Wanderbricks fields used to prepare the dashboard baseline and Databricks Genie Agent.

It focuses on:

- Business meaning
- Metric usage
- Agent terminology
- Known ambiguities
- Data-quality rules
- Validation status

> [!NOTE]
> The exact physical Databricks data type and nullability were not captured for every field during the teardown.
> Where they were not explicitly validated, this document uses a logical type or marks the field as **Not confirmed** rather than guessing.

## Validation status

| Status | Meaning |
| --- | --- |
| **Validated** | Checked directly during the teardown |
| **Validated with limitation** | Checked, but an important business or data limitation remains |
| **Partially validated** | Some behavior was checked, but not every rule or edge case |
| **Not confirmed** | Not explicitly validated during the teardown |

---

# 1. `bookings`

**Grain:** One row per original booking  
**Primary key:** `booking_id`  
**Main limitation:** `status` does not reliably represent the latest booking state.

| Column | Data type | Description | Business meaning | Example | Nullable | Primary key | Foreign key | Business rules | Metric dependencies | Agent synonyms | Agent usage | Possible ambiguity | Data-quality checks | Validation status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `booking_id` | Identifier, physical type not confirmed | Unique booking identifier | One reservation | Not recorded | Not confirmed | Yes | No | Count distinct IDs for booking metrics | Total bookings, completed bookings, cancellation rate | booking, reservation | Main booking identifier | Row count vs distinct booking count | Check uniqueness and duplicates | **Validated** |
| `user_id` | Identifier, physical type not confirmed | User who made the booking | Booking customer | Not recorded | Not confirmed | No | Not confirmed | Not used as a primary business metric in this teardown | None in current scope | customer, user, guest | Customer-level joins if needed | User may differ from booker/guest in other systems | Referential integrity not fully tested in this teardown | **Not confirmed** |
| `property_id` | Identifier, physical type not confirmed | Property being booked | Accommodation linked to the booking | Not recorded | Not confirmed | No | `properties.property_id` | Use to connect bookings to properties and destinations | Destination and property performance | property, listing, accommodation | Segmentation and joins | Property attached to an updated booking may change | Check booking-to-property relationship | **Validated** |
| `check_in` | Date, logical type | Check-in date | Start of booked stay | Not recorded | Not confirmed | No | No | Use only when the business question is about stay start | Time-based booking analysis | arrival date, check-in date | Date filter when requested | Could be confused with booking creation date | Compare with `check_out`; inspect impossible ranges | **Partially validated** |
| `check_out` | Date, logical type | Check-out date | End of booked stay | Not recorded | Not confirmed | No | No | Useful for completed-stay analysis | Completed bookings by stay period | departure date, checkout date | Date filter when requested | Could be confused with booking creation date | Used to identify stale pending/confirmed statuses | **Validated with limitation** |
| `guests_count` | Numeric, exact type not confirmed | Number of guests | Party size for the booking | Not recorded | Not confirmed | No | No | No metric rule defined in current teardown | None in current scope | guests, party size | Optional segmentation | Could represent booked guests rather than actual guests | Range/outlier validation not completed | **Not confirmed** |
| `total_amount` | Numeric, floating-point | Amount attached to the booking | **Booking value / amount due**, not collected revenue | Not recorded | Not confirmed | No | No | Do not use as collected revenue | Booking value only | booking value, booking amount, amount due | Can answer booking-value questions | Easy to confuse with collected payment amount or revenue | Check cancelled bookings retaining values; round display to 2 decimals | **Validated with limitation** |
| `status` | Text, logical type | Original or stored booking status | Historical/original booking state | `pending`, `confirmed`, `cancelled`, `completed` | Not confirmed | No | No | Do **not** use as current booking status when an update exists | None directly; replaced in current-state metrics | booking status | Avoid for current-state analysis | Appears current but is stale | Compare with checkout dates and latest booking updates | **Validated with limitation** |
| `created_at` | Timestamp, logical type | Booking creation timestamp | When the booking was created | Not recorded | Not confirmed | No | No | Recommended date for booking-volume trends | Total bookings over time | booking date, booking creation date | Preferred field for booking-created trends | Could be confused with check-in or checkout date | Check time range and missing values | **Partially validated** |
| `updated_at` | Timestamp, logical type | Last update timestamp stored in main table | Last update recorded on original booking row | Not recorded | Not confirmed | No | No | Do not assume this contains the full latest booking state | None directly | last updated | Supporting metadata | Could be confused with latest event in `booking_updates` | Compare with update-table timestamps where needed | **Partially validated** |

---

# 2. `booking_updates`

**Grain:** One row per booking update  
**Primary key:** `booking_update_id`  
**Foreign key:** `booking_id`

| Column | Data type | Description | Business meaning | Example | Nullable | Primary key | Foreign key | Business rules | Metric dependencies | Agent synonyms | Agent usage | Possible ambiguity | Data-quality checks | Validation status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `booking_update_id` | Identifier, physical type not confirmed | Unique update identifier | One booking-update event | Not recorded | Key fields inspected with no nulls | Yes | No | Use as tie-breaker with `updated_at` when selecting latest update | Current booking state | update ID | Supports latest-record logic | Sequence may not equal business chronology by itself | Check uniqueness | **Validated** |
| `booking_id` | Identifier, physical type not confirmed | Booking being updated | Reservation linked to the update | Not recorded | Key fields inspected with no nulls | No | `bookings.booking_id` | Partition by booking to find latest update | Current booking state | booking, reservation | Main join back to bookings | Multiple updates exist per booking | Check referential integrity and update counts | **Validated** |
| `check_in` | Date, logical type | Updated check-in date | Latest known stay-start date | Not recorded | Key fields inspected with no nulls | No | No | Latest update replaces original value when present | Time-based current booking analysis | arrival date, check-in date | Used in reconstructed current booking state | Could differ from original booking | Compare latest update with original record | **Validated** |
| `check_out` | Date, logical type | Updated check-out date | Latest known stay-end date | Not recorded | Key fields inspected with no nulls | No | No | Latest update replaces original value when present | Time-based current booking analysis | departure date, checkout date | Used in reconstructed current booking state | Could differ from original booking | Compare latest update with original record | **Validated** |
| `guests_count` | Numeric, exact type not confirmed | Updated number of guests | Latest known party size | Not recorded | Key fields inspected with no nulls | No | No | Latest update replaces original value when present | None in current scope | guests, party size | Supporting current-state field | May change across updates | Compare across update history | **Validated** |
| `property_id` | Identifier, physical type not confirmed | Property attached to the updated booking | Latest known accommodation | Not recorded | Key fields inspected with no nulls | No | Not explicitly validated as FK | Latest update replaces original value when present | Destination and property performance | property, listing | Current-state join field | Property may change after booking update | Validate property existence where used | **Partially validated** |
| `status` | Text, logical type | Updated booking status | Latest known booking state | `pending`, `confirmed`, `cancelled`, `completed` | Key fields inspected with no nulls | No | No | Latest update should replace original `bookings.status` | Completed bookings, cancellation rate, active bookings | current status, booking state | Primary source for current status | Must use only latest update | Check latest-record ordering and status distribution | **Validated** |
| `total_amount` | Numeric, floating-point | Updated amount due | Latest booking value | Not recorded | Key fields inspected with no nulls | No | No | Treat as booking value, not collected revenue | Booking value | booking amount, amount due | Current booking-value analysis | Can be confused with payment/revenue | Round displayed values; compare to payments separately | **Validated with limitation** |
| `updated_at` | Timestamp, logical type | Time update was created | Update chronology | Not recorded | Key fields inspected with no nulls | No | No | Order descending to select latest update | Current booking state | update time, last modified | Critical to reconstruction logic | Ties require `booking_update_id` tie-breaker | Check chronological order | **Validated** |
| `user_id` | Identifier, physical type not confirmed | User who created or updated the booking | User associated with update | Not recorded | Key fields inspected with no nulls | No | Not confirmed | Latest update replaces original value when present | None in current scope | user, customer | Supporting field | Could represent actor vs customer depending on source semantics | Semantic meaning not independently validated | **Partially validated** |

---

# 3. `properties`

**Grain:** One row per property  
**Primary key:** `property_id`  
**Foreign key:** `destination_id`

| Column | Data type | Description | Business meaning | Example | Nullable | Primary key | Foreign key | Business rules | Metric dependencies | Agent synonyms | Agent usage | Possible ambiguity | Data-quality checks | Validation status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `property_id` | Identifier, physical type not confirmed | Unique property identifier | One listed accommodation | Not recorded | Not confirmed | Yes | No | Use for property-level grouping and joins | Property performance, rating by property | property, listing, accommodation | Main property key | None material identified | Check uniqueness and booking joins | **Validated** |
| `host_id` | Identifier, physical type not confirmed | Property host | Listing owner/host | Not recorded | Not confirmed | No | Not confirmed | No business rule defined in teardown | None in current scope | host, owner | Not used in current benchmark | Could represent account vs actual host | Not tested | **Not confirmed** |
| `destination_id` | Identifier, physical type not confirmed | Destination connected to property | Geographic parent of property | Not recorded | Not confirmed | No | `destinations.destination_id` | Use to map properties and bookings to destinations | Destination performance | destination ID, location ID | Main geography join | None material identified | Check referential integrity | **Validated** |
| `title` | Text, logical type | Property listing title | User-facing property name | Not recorded | Not confirmed | No | No | Not used in metric calculations | None | property name, listing name | Display and search context | Titles may not be unique | Check duplicates only if used as identifier | **Partially validated** |
| `description` | Text, logical type | Property description | Free-text listing information | Not recorded | Not confirmed | No | No | Not used in current metrics | None | property description | Context only | Free text may contain inconsistent wording | Not tested | **Not confirmed** |
| `base_price` | Numeric, floating-point | Base booking price | Listed starting price | Not recorded | Not confirmed | No | No | Do not confuse with booking value or collected payment | None in current benchmark | base price, listing price | Optional price analysis | May differ from final booking amount | Round display; compare with booking/payment amounts if used | **Validated with limitation** |
| `property_type` | Text, logical type | Property category | Type of accommodation | `house`, `apartment`, other values possible | Not confirmed | No | No | Group consistently by stored category | Completed bookings by property type | accommodation type, listing type | Segmentation | Category naming may vary | Check distinct values | **Partially validated** |
| `max_guests` | Numeric, exact type not confirmed | Maximum guest capacity | Property capacity | Not recorded | Not confirmed | No | No | No metric rule defined | None in current scope | capacity, max guests | Optional segmentation | Maximum allowed vs actual occupancy | Range checks not completed | **Not confirmed** |
| `bedrooms` | Numeric, exact type not confirmed | Number of bedrooms | Property size attribute | Not recorded | Not confirmed | No | No | No metric rule defined | None in current scope | bedrooms | Optional segmentation | Studio/zero-bedroom handling not reviewed | Range checks not completed | **Not confirmed** |
| `bathrooms` | Numeric, exact type not confirmed | Number of bathrooms | Property amenity/size attribute | Not recorded | Not confirmed | No | No | No metric rule defined | None in current scope | bathrooms | Optional segmentation | Half-bath handling not reviewed | Range checks not completed | **Not confirmed** |
| `created_at` | Timestamp, logical type | Date property was listed | Property creation/listing date | Not recorded | Not confirmed | No | No | Not used in current metrics | None | listing date, property created date | Optional time analysis | Could be confused with booking dates | Not tested | **Not confirmed** |

---

# 4. `destinations`

**Grain:** One row per destination  
**Primary key:** `destination_id`

| Column | Data type | Description | Business meaning | Example | Nullable | Primary key | Foreign key | Business rules | Metric dependencies | Agent synonyms | Agent usage | Possible ambiguity | Data-quality checks | Validation status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `destination_id` | Identifier, physical type not confirmed | Unique destination identifier | One geographic destination | Not recorded | Not confirmed | Yes | No | Use through `properties.destination_id` | Destination metrics | destination ID, location ID | Main geography key | None material identified | Check uniqueness and property joins | **Validated** |
| `destination` | Text, logical type | Destination name | Business-facing destination | Phuket, Gold Coast, Mallorca, Paris, Abu Dhabi | Not confirmed | No | No | Use for destination-level grouping/display | Booking volume, cancellation rate, payments, ratings | destination, location, city | Primary geographic dimension | Destination may not always equal city | Check duplicate names and grouping | **Validated** |
| `country` | Text, logical type | Country name | Country containing destination | Thailand, other observed countries | Not confirmed | No | No | Use for country-level grouping | Top countries by booking volume | country, market | Geographic filter and segmentation | Country naming conventions may vary | Check distinct naming | **Validated** |
| `state_or_province` | Text, logical type | State, province, or region | Regional geography | Not recorded | Not confirmed | No | No | No metric rule defined | None in current benchmark | region, state, province | Optional geography | Meaning varies by country | Not tested | **Not confirmed** |
| `state_or_province_code` | Text, logical type | Region code | Short regional identifier | Not recorded | Not confirmed | No | No | No metric rule defined | None in current benchmark | region code, state code | Optional geography | Code standard not validated | Not tested | **Not confirmed** |
| `description` | Text, logical type | Destination description | Free-text geographic context | Not recorded | Not confirmed | No | No | Not used in metrics | None | destination description | Context only | Free text may be inconsistent | Not tested | **Not confirmed** |

---

# 5. `payments`

**Grain:** One row per payment attempt  
**Primary key:** `payment_id`  
**Foreign key:** `booking_id`

| Column | Data type | Description | Business meaning | Example | Nullable | Primary key | Foreign key | Business rules | Metric dependencies | Agent synonyms | Agent usage | Possible ambiguity | Data-quality checks | Validation status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `payment_id` | Identifier, physical type not confirmed | Unique payment-attempt identifier | One payment attempt | Not recorded | Not confirmed | Yes | No | Do not count rows as paying bookings without checking retries | Payment-attempt analysis | payment, transaction attempt | Payment-level key | Multiple attempts can belong to one booking | Check uniqueness | **Validated** |
| `booking_id` | Identifier, physical type not confirmed | Booking connected to payment | Reservation being paid | Not recorded | Not confirmed | No | `bookings.booking_id` | Use distinct booking IDs when counting paid bookings | Paid bookings, payment analysis | booking, reservation | Main payment-to-booking join | One booking can have multiple attempts | Check referential integrity and retry counts | **Validated** |
| `amount` | Numeric, floating-point | Payment amount | Amount attached to this payment attempt | Not recorded | Not confirmed | No | No | Sum only completed payments for collected payment amount | Collected payment amount | payment amount, collected amount | Main payment metric | **Currency is not defined**; not the same as approved revenue | Check status before summing; round display to 2 decimals | **Validated with limitation** |
| `payment_method` | Text, logical type | Payment method | How customer attempted to pay | credit card, PayPal, bank transfer | Not confirmed | No | No | No current metric rule | Optional payment-method analysis | payment type, payment method | Segmentation if requested | Category names may vary | Check distinct values before grouping | **Partially validated** |
| `status` | Text, logical type | Payment status | Outcome/state of payment attempt | `completed`; other statuses exist but were not fully catalogued | Not confirmed | No | No | Only `completed` counts toward collected payment amount | Collected payment amount | payment status, transaction status | Required filter | Full status taxonomy not documented | Inspect distinct statuses before new analyses | **Validated with limitation** |
| `payment_date` | Timestamp, logical type | Payment timestamp | When payment attempt occurred | Not recorded | Not confirmed | No | No | Use for payment-trend questions | Payment amount over time | payment date, transaction date | Preferred payment time field | Could be confused with booking/stay dates | Check time coverage and complete periods | **Partially validated** |

### Payment-level findings

- 45,958 bookings have payment records.
- 3,680 bookings have more than one payment attempt.
- No inspected booking had more than one completed payment.
- Maximum observed payment attempts per booking: 2.
- Refund/reversal logic was not validated.
- Currency is not available in the documented schema.

---

# 6. `reviews`

**Grain:** One row per review  
**Primary key:** `review_id`

| Column | Data type | Description | Business meaning | Example | Nullable | Primary key | Foreign key | Business rules | Metric dependencies | Agent synonyms | Agent usage | Possible ambiguity | Data-quality checks | Validation status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `review_id` | Identifier, physical type not confirmed | Unique review identifier | One submitted review | Not recorded | Not confirmed | Yes | No | Use one row per active review | Review counts, average rating | review | Main review key | None material identified | Check uniqueness | **Validated** |
| `booking_id` | Identifier, physical type not confirmed | Booking that was reviewed | Reservation linked to review | Not recorded | Not confirmed | No | `bookings.booking_id` | Not every booking has a review | Review coverage | booking, reservation | Join review to booking | Zero-to-many relationship; review coverage is incomplete | Check referential integrity and reviews per booking | **Validated with limitation** |
| `property_id` | Identifier, physical type not confirmed | Property that was reviewed | Accommodation receiving the review | Not recorded | Not confirmed | No | `properties.property_id` | Use for property-level rating analysis | Average rating by property/destination | property, listing | Main review-to-property join | Property may also be reached through booking | Check consistency between review and booking property if needed | **Validated** |
| `user_id` | Identifier, physical type not confirmed | User who wrote review | Reviewer | Not recorded | Not confirmed | No | `users.user_id` | Not used as a current metric | None in current scope | reviewer, customer, user | Optional reviewer analysis | Reviewer is not the full customer population | Referential integrity not fully explored | **Partially validated** |
| `rating` | Numeric, logical scale 1–5 | Customer rating | Satisfaction signal from reviewer | 1.0 to 5.0; observed destination averages around 3.0 | Not confirmed | No | No | Average only active/non-deleted reviews | Average rating | rating, score, customer satisfaction | Main satisfaction metric | Small samples can make rankings misleading | Validate 1–5 range and review counts | **Validated with limitation** |
| `comment` | Text, logical type | Written review | Free-text customer feedback | Not recorded | Not confirmed | No | No | Not used in current quantitative metrics | None | comment, review text, feedback | Future qualitative analysis | Free text may need NLP/cleaning | Not tested | **Not confirmed** |
| `is_deleted` | Boolean, logical type | Whether review was deleted | Review visibility/status | `false` for active reviews | Not confirmed | No | No | Exclude deleted reviews from satisfaction metrics | Average rating, review count | active review, deleted review | Required filter in prepared review view | Deleted does not necessarily mean invalid data historically | Check filter is applied | **Validated** |
| `created_at` | Timestamp, logical type | Review creation timestamp | When review was submitted | Not recorded | Not confirmed | No | No | Recommended date for rating trends | Rating over time | review date, feedback date | Time filter for reviews | Could be confused with booking dates | Check time coverage | **Partially validated** |
| `updated_at` | Timestamp, logical type | Review update timestamp | Last review modification | Not recorded | Not confirmed | No | No | No current metric rule | None | review updated date | Supporting metadata | Update may not mean rating changed | Not tested | **Not confirmed** |

### Review-level limitation

Average rating represents **customers who submitted active reviews**, not the full customer population.

Small review counts should be shown or warned about when ranking destinations or properties.

---

# 7. Agent-facing curated views

The Genie Agent was configured on curated views instead of raw source tables.

| View | Purpose | Main business rules already applied | Agent usage |
| --- | --- | --- | --- |
| `workspace.wanderbricks_teardown.booking_analysis` | Booking and current-state analysis | Reconstructed latest booking state; booking/property/destination context | Booking counts, status, cancellations, trends, destination analysis |
| `workspace.wanderbricks_teardown.payment_analysis` | Payment analysis | Payment attempts linked to property/destination context | Completed payment amount, payment trends, destination payment analysis |
| `workspace.wanderbricks_teardown.review_analysis` | Customer-rating analysis | Deleted reviews excluded; property/destination context included | Average rating, review counts, destination/property satisfaction |

> [!IMPORTANT]
> The full column-level physical schema of these three curated views was not captured in the source data-model document.
> This dictionary therefore does not invent view columns that were not explicitly documented.

---

# 8. Core metric dependencies

| Metric | Main fields | Working rule | Main limitation |
| --- | --- | --- | --- |
| **Total bookings** | `booking_id` | `COUNT(DISTINCT booking_id)` | Duplicate/test-booking policy not formally defined |
| **Completed bookings** | latest `status` / `current_status`, `booking_id` | Count distinct bookings whose latest state is `completed` | Reporting date must be chosen consistently |
| **Cancellation rate** | latest `status` / `current_status` | Cancelled / (Completed + Cancelled) | This denominator is a teardown definition, not a production-approved rule |
| **Collected payment amount** | `payments.amount`, `payments.status` | Sum `amount` where payment status is `completed` | Currency, refunds, reversals, taxes, and accounting treatment not confirmed |
| **Average rating** | `reviews.rating`, `reviews.is_deleted` | Average rating where review is not deleted | Reviewers are a subset of customers; small samples can mislead |

---

# 9. Agent terminology guardrails

| Preferred term | Avoid / clarify | Reason |
| --- | --- | --- |
| **Booking value** | Revenue | `total_amount` is attached to a booking and can remain on cancelled bookings |
| **Completed payment amount** | Revenue, unless an approved revenue definition exists | Completed payments were not reconciled against accounting rules |
| **Current booking state** | Raw `bookings.status` | Original booking status was found to be stale |
| **Terminal booking** | All bookings | In this teardown, terminal means `completed` or `cancelled` |
| **Customer satisfaction** | Satisfaction of all customers | Ratings represent only users who submitted active reviews |
| **High volume** | Any implicit threshold | Threshold must be stated or requested |
| **Complete month** | Current-calendar assumption | Completeness should be checked against the latest observed data period |

---

# 10. Remaining known limitations

The data dictionary should not be interpreted as a production-certified semantic model.

Known gaps include:

- Exact physical data types were not captured for every column.
- Nullability was not validated for every source field.
- Currency is not defined.
- Refund and reversal treatment is not documented.
- Production revenue recognition is outside scope.
- Full payment-status taxonomy was not documented.
- Review coverage is incomplete by nature.
- Some geographic and user-level relationships were not fully tested.
