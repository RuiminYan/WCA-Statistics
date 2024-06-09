-- best, average, variance, worst, median, bpa, wpa 

SELECT
  r.personName,
  r.personId,
  r.personCountryId,
  r.value1, 
  r.value2, 
  r.value3, 
  r.value4, 
  r.value5,
  r.best,
  r.average,
  r.regionalSingleRecord,
  r.regionalAverageRecord,
  c.year,
  c.month,
  c.day,
  c.name,
  -- Calculate variance
  CASE -- 当5个value中至少有一个≤0时，variance取NULL
    WHEN r.value1 <= 0 OR r.value2 <= 0 OR r.value3 <= 0 OR r.value4 <= 0 OR r.value5 <= 0 THEN NULL
    ELSE ROUND((POW(r.value1 - r.average, 2) + POW(r.value2 - r.average, 2) + POW(r.value3 - r.average, 2) + POW(r.value4 - r.average, 2) + POW(r.value5 - r.average, 2)) / 5, 0)
  END AS variance,
  -- Calculate worst
  CASE WHEN LEAST(r.value1, r.value2, r.value3, r.value4, r.value5) <= 0 THEN NULL ELSE GREATEST(r.value1, r.value2, r.value3, r.value4, r.value5) END AS worst,  
  -- Calculate median
  CASE WHEN 
    (SELECT ROUND(AVG(val), 2) 
     FROM (SELECT val 
           FROM (SELECT r.value1 AS val UNION ALL SELECT r.value2 UNION ALL SELECT r.value3 UNION ALL SELECT r.value4 UNION ALL SELECT r.value5) sub 
           ORDER BY val 
           LIMIT 3, 1) median) <= 0
  THEN NULL ELSE -- 当计算出的median≤0时，median取NULL
    (SELECT ROUND(AVG(val), 2) 
     FROM (SELECT val 
           FROM (SELECT r.value1 AS val UNION ALL SELECT r.value2 UNION ALL SELECT r.value3 UNION ALL SELECT r.value4 UNION ALL SELECT r.value5) sub 
           ORDER BY val 
           LIMIT 3, 1) median)
  END AS median,
  -- Calculate bpa and wpa
  CASE -- 当value1~4至少有2个≤0时，bpa取NULL
    WHEN (r.value1 <= 0 AND r.value2 <= 0) OR (r.value1 <= 0 AND r.value3 <= 0) OR (r.value1 <= 0 AND r.value4 <= 0) OR (r.value2 <= 0 AND r.value3 <= 0) OR (r.value2 <= 0 AND r.value4 <= 0) OR (r.value3 <= 0 AND r.value4 <= 0) THEN NULL
    WHEN r.value1 <= 0 THEN ROUND((r.value2 + r.value3 + r.value4) / 3, 0) -- 当value1~4恰好有1个≤0时，bpa取value1~4排除掉这个≤0的值后剩下的3个数的平均值
    WHEN r.value2 <= 0 THEN ROUND((r.value1 + r.value3 + r.value4) / 3, 0)
    WHEN r.value3 <= 0 THEN ROUND((r.value1 + r.value2 + r.value4) / 3, 0)
    WHEN r.value4 <= 0 THEN ROUND((r.value1 + r.value2 + r.value3) / 3, 0)
    ELSE ROUND((r.value1 + r.value2 + r.value3 + r.value4 - GREATEST(r.value1, r.value2, r.value3, r.value4)) / 3, 0)
  END AS bpa,
  CASE -- 当value1~4至少有1个≤0时，wpa取NULL
    WHEN r.value1 <= 0 OR r.value2 <= 0 OR r.value3 <= 0 OR r.value4 <= 0 THEN NULL
    ELSE ROUND((r.value1 + r.value2 + r.value3 + r.value4 - LEAST(r.value1, r.value2, r.value3, r.value4)) / 3, 0)
  END AS wpa
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
    best,
    average,
    regionalSingleRecord,
    regionalAverageRecord,
    competitionId
  FROM 
    Results
  WHERE 
    eventId = '333'
) r
JOIN
  Competitions c ON r.competitionId = c.id
ORDER BY
  wpa IS NULL, wpa;

/*
WHERE best > 0
ORDER BY
  best;
*/
