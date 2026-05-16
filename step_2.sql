WITH sorted_snapshots AS (
  SELECT *, ROW_NUMBER() OVER (PARTITION BY ad_id,date ORDER BY timestamp DESC) AS row_numb
  FROM sshomework1.marketing
)
, daily_snapshots AS (
  SELECT *
  FROM sorted_snapshots
  WHERE row_numb = 1
)
SELECT source
  , date 
  , ROUND(SUM(spend),2) AS total_spend
  , SUM(impressions) AS total_impressions
  , SUM(clicks) AS total_clicks
  , SUM(installs) AS total_installs
  ,	SUM(registrations) AS total_registrations
FROM daily_snapshots
GROUP BY 1,2
ORDER BY 1,2