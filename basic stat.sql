SELECT
  r.personName,
  r.personId,
  r.personCountryId,
  r.value1, 
  r.value2, 
  r.value3, 
  r.value4, 
  r.value5,
  r.average,
  r.regionalSingleRecord,
  r.regionalAverageRecord,
  c.year,
  c.month,
  c.day,
  c.name,
  -- Calculate variance
  ROUND((POW(r.value1 - avg_val, 2) + POW(r.value2 - avg_val, 2) + POW(r.value3 - avg_val, 2) + POW(r.value4 - avg_val, 2) + POW(r.value5 - avg_val, 2)) / 5, 2) AS variance,
  -- Calculate best, worst
  GREATEST(r.value1, r.value2, r.value3, r.value4, r.value5) AS best,
  LEAST(r.value1, r.value2, r.value3, r.value4, r.value5) AS worst,
  -- Calculate median
  (SELECT ROUND(AVG(val), 2) 
   FROM (SELECT val 
         FROM (SELECT r.value1 AS val UNION ALL SELECT r.value2 UNION ALL SELECT r.value3 UNION ALL SELECT r.value4 UNION ALL SELECT r.value5) sub 
         ORDER BY val 
         LIMIT 3, 1) median) AS median,
  -- Calculate bpa and wpa
  ROUND((r.value1 + r.value2 + r.value3 + r.value4 - GREATEST(r.value1, r.value2, r.value3, r.value4)) / 3, 2) AS bpa,
  ROUND((r.value1 + r.value2 + r.value3 + r.value4 - LEAST(r.value1, r.value2, r.value3, r.value4)) / 3, 2) AS wpa
FROM (
  SELECT 
    personName,
    personId,
    personCountryId,
    value1,
    value2,
    value3,
    value4,
    value5,
    average,
    regionalSingleRecord,
    regionalAverageRecord,
    (value1 + value2 + value3 + value4 + value5) / 5.0 AS avg_val,
    competitionId
  FROM 
    Results
  WHERE 
    eventId = '333'
) r
JOIN
  Competitions c ON r.competitionId = c.id
WHERE
  r.value1 > 0 AND r.value2 > 0 AND r.value3 > 0 AND r.value4 > 0 AND r.value5 > 0
ORDER BY
  best;

 -- 按日期排 c.year, c.month, c.day;
