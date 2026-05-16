WITH sorted_snapshot AS(
  SELECT *, ROW_NUMBER() OVER (PARTITION BY ad_id ORDER BY timestamp DESC) AS row_numb
  FROM sshomework1.marketing
)
SELECT * EXCEPT (row_numb)
FROM sorted_snapshot
WHERE row_numb = 1
ORDER BY source, spend DESC