WITH all_data AS (
  SELECT COUNT(id_user) AS users_registered
    , COUNT(CASE WHEN date_spent_15_credits is NOT NULL THEN id_user END) AS users_reminded
    , COUNT(DISTINCT CASE WHEN date_first_payment >= date_spent_15_credits 
        AND date_spent_15_credits IS NOT NULL THEN id_user END) AS users_paid_after_reminder
    , COUNT(DISTINCT CAST(date_reg AS date)) AS total_days_registered
    , COUNT(DISTINCT CAST(date_first_payment AS date)) AS total_days_paid
    , COUNT(DISTINCT CAST(date_spent_15_credits AS date)) AS total_days_reminded
    , MAX(CAST(date_first_payment AS DATE)) AS latest_payment_date
    , MAX(CAST(date_spent_15_credits AS DATE)) AS latest_reminder
  FROM sshomework3.ab_historical
)
SELECT users_registered
  , TRUNC(users_registered / total_days_registered) AS users_per_day_registered
  , users_reminded
  , ROUND(users_reminded / users_registered * 100.0, 2) AS cr_to_reminder_pct
  , users_paid_after_reminder
  , ROUND(users_paid_after_reminder/ users_reminded * 100.0, 2) AS cr_to_payment1_pct
FROM all_data
