WITH sorted_snapshots AS (
  SELECT *, ROW_NUMBER() OVER (PARTITION BY ad_id ORDER BY timestamp DESC) AS row_numb
  FROM sshomework1.marketing
  ORDER BY timestamp DESC
)
SELECT source
  , SUM(spend) AS total_spend
  , ROUND(SUM(spend) / SUM(impressions) * 1000.0, 2) AS cpm
  , ROUND(SUM(clicks) / SUM(impressions) * 100.0, 2) AS ctr_pct
  , ROUND(SUM(installs) / SUM(clicks) * 100.0, 2) AS cr_click_install_pct
  , ROUND(SUM(registrations) / SUM(installs) * 100.0, 2) AS cr_install_reg_pct
  , ROUND(SUM(spend) / SUM(registrations), 2) AS cac
FROM sorted_snapshots
WHERE  row_numb = 1
GROUP BY 1
ORDER BY 1