WITH test_users AS (
  SELECT id_user
    , match
    , CASE WHEN date_spent_15_credits IS NOT NULL THEN 1 ELSE 0 END AS is_triggered
    , CASE WHEN date_first_payment >= date_spent_15_credits AND date_spent_15_credits IS NOT NULL THEN 1 ELSE 0 END AS is_paid_after_trigger
  FROM `sshomework3.ab_test`
)

SELECT CASE WHEN match = 0 THEN 'Control Group' ELSE 'Test Group' END AS group_name
  , CAST(match AS STRING) AS split_group
  , COUNT(DISTINCT id_user) AS total_users
  , COUNT(DISTINCT CASE WHEN is_triggered = 1 THEN id_user END) AS users_reached_trigger
  , COUNT(DISTINCT CASE WHEN is_paid_after_trigger = 1 THEN id_user END) AS users_paid
  , ROUND(COUNT(DISTINCT CASE WHEN is_paid_after_trigger = 1 THEN id_user END) / 
        NULLIF(COUNT(DISTINCT CASE WHEN is_triggered = 1 THEN id_user END), 0) * 100, 2) AS conversion_rate_pct
FROM test_users
GROUP BY match

UNION ALL

SELECT 'Total' AS group_name
  , '-' AS split_group
  , COUNT(DISTINCT id_user) AS total_users
  , COUNT(DISTINCT CASE WHEN is_triggered = 1 THEN id_user END) AS users_reached_trigger
  , COUNT(DISTINCT CASE WHEN is_paid_after_trigger = 1 THEN id_user END) AS users_paid
  , ROUND(COUNT(DISTINCT CASE WHEN is_paid_after_trigger = 1 THEN id_user END) / 
        NULLIF(COUNT(DISTINCT CASE WHEN is_triggered = 1 THEN id_user END), 0) * 100, 2) AS conversion_rate_pct
FROM test_users