-- 谁第一次破纪录（不管是单次还是平均，也不管是什么项目）就是WR

WITH all_records AS (
  SELECT
    person_id,
    person_name,
    event_id,
    competition_id,
    STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') AS date,
    'single' AS record_type,
    best AS result,
    regional_single_record AS record
  FROM Results r
  JOIN Competitions c ON r.competition_id = c.id
  WHERE regional_single_record IS NOT NULL

  UNION ALL

  SELECT
    person_id,
    person_name,
    event_id,
    competition_id,
    STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') AS date,
    'average' AS record_type,
    average AS result,
    regional_average_record AS record
  FROM Results r
  JOIN Competitions c ON r.competition_id = c.id
  WHERE regional_average_record IS NOT NULL
),
first_record_per_person AS (
  SELECT *
  FROM (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY person_id ORDER BY date) AS rn
    FROM all_records
  ) ranked
  WHERE rn = 1
)
SELECT
  person_name,
  person_id,
  event_id,
  record_type,
  result,
  competition_id,
  date,
  record
FROM first_record_per_person
WHERE record = 'WR'
ORDER BY date;
