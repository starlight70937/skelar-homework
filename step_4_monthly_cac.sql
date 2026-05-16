WITH month_added AS (
  SELECT *, EXTRACT(MONTH from date) AS month
  FROM sshomework1.marketing
)
, sorted_snapshots AS (
  SELECT *, ROW_NUMBER() OVER (PARTITION BY ad_id, month ORDER BY timestamp DESC) AS row_numb
  FROM month_added
)
, monthly_snapshots AS (
  SELECT * 
  FROM sorted_snapshots
  WHERE row_numb = 1
)
SELECT source
  , month
  , ROUND(SUM(spend),2) AS total_spend
  , SUM(registrations) AS total_registrations
  , ROUND(SUM(spend) / SUM(registrations), 2) AS cac
FROM monthly_snapshots
GROUP BY 1,2
ORDER BY 1,2