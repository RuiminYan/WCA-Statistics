-- 谁第一次破纪录（不管是单次还是平均，也不管是什么项目）就是WR

WITH all_records AS (
  SELECT
    personId,
    personName,
    eventId,
    competitionId,
    STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') AS date,
    'single' AS record_type,
    best AS result,
    regionalSingleRecord AS record
  FROM Results r
  JOIN Competitions c ON r.competitionId = c.id
  WHERE regionalSingleRecord IS NOT NULL

  UNION ALL

  SELECT
    personId,
    personName,
    eventId,
    competitionId,
    STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') AS date,
    'average' AS record_type,
    average AS result,
    regionalAverageRecord AS record
  FROM Results r
  JOIN Competitions c ON r.competitionId = c.id
  WHERE regionalAverageRecord IS NOT NULL
),
first_record_per_person AS (
  SELECT *
  FROM (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY personId ORDER BY date) AS rn
    FROM all_records
  ) ranked
  WHERE rn = 1
)
SELECT
  personName,
  personId,
  eventId,
  record_type,
  result,
  competitionId,
  date,
  record
FROM first_record_per_person
WHERE record = 'WR'
ORDER BY date;
