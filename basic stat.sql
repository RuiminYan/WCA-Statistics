/* 
best, average, 
variance, worst, median, bpa, wpa, mo5, best_counting, worst_counting

当恰好有n个value≤0时，将这n个值排除掉，然后在剩下的值中取best_counting为5个value中第二小的； 
其他情况，取best_counting为5个value中第二小的

当至少有2个value≤0时，取worst_counting为NULL； 
当恰好有1个value≤0时，取worst_counting为5个value中最大的； 
其他情况，取worst_counting为5个value中第二大的

*/


-- Step 1: Create a temporary table
CREATE TEMPORARY TABLE TempResults AS
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
  r.competitionId
FROM 
  Results r
WHERE 
  r.eventId = '333';

-- Step 2: Join with Competitions table and perform calculations
SELECT
  tr.personName,
  tr.personId,
  tr.personCountryId,
  tr.value1, 
  tr.value2, 
  tr.value3, 
  tr.value4, 
  tr.value5,
  tr.best,
  tr.average,
  tr.regionalSingleRecord,
  tr.regionalAverageRecord,
  c.year,
  c.month,
  c.day,
  c.name,
  -- Calculate mo5 as the average of the 5 values, set to NULL if any value is <= 0
  CASE 
    WHEN tr.value1 <= 0 OR tr.value2 <= 0 OR tr.value3 <= 0 OR tr.value4 <= 0 OR tr.value5 <= 0 THEN NULL
    ELSE ROUND((tr.value1 + tr.value2 + tr.value3 + tr.value4 + tr.value5) / 5, 0)
  END AS mo5,
  -- Calculate variance
  CASE 
    WHEN tr.value1 <= 0 OR tr.value2 <= 0 OR tr.value3 <= 0 OR tr.value4 <= 0 OR tr.value5 <= 0 THEN NULL
    ELSE ROUND((POW(tr.value1 - tr.average, 2) + POW(tr.value2 - tr.average, 2) + POW(tr.value3 - tr.average, 2) + POW(tr.value4 - tr.average, 2) + POW(tr.value5 - tr.average, 2)) / 5, 0)
  END AS variance,
  -- Calculate worst
  CASE WHEN LEAST(tr.value1, tr.value2, tr.value3, tr.value4, tr.value5) <= 0 THEN NULL ELSE GREATEST(tr.value1, tr.value2, tr.value3, tr.value4, tr.value5) END AS worst,  
  -- Calculate median
  CASE WHEN 
    (SELECT ROUND(AVG(val), 2) 
     FROM (SELECT val 
           FROM (SELECT tr.value1 AS val UNION ALL SELECT tr.value2 UNION ALL SELECT tr.value3 UNION ALL SELECT tr.value4 UNION ALL SELECT tr.value5) sub 
           ORDER BY val 
           LIMIT 3, 1) median) <= 0
  THEN NULL ELSE 
    (SELECT ROUND(AVG(val), 2) 
     FROM (SELECT val 
           FROM (SELECT tr.value1 AS val UNION ALL SELECT tr.value2 UNION ALL SELECT tr.value3 UNION ALL SELECT tr.value4 UNION ALL SELECT tr.value5) sub 
           ORDER BY val 
           LIMIT 3, 1) median)
  END AS median,
  -- Calculate bpa and wpa
  CASE 
    WHEN (tr.value1 <= 0 AND tr.value2 <= 0) OR (tr.value1 <= 0 AND tr.value3 <= 0) OR (tr.value1 <= 0 AND tr.value4 <= 0) OR (tr.value2 <= 0 AND tr.value3 <= 0) OR (tr.value2 <= 0 AND tr.value4 <= 0) OR (tr.value3 <= 0 AND tr.value4 <= 0) THEN NULL
    WHEN tr.value1 <= 0 THEN ROUND((tr.value2 + tr.value3 + tr.value4) / 3, 0) 
    WHEN tr.value2 <= 0 THEN ROUND((tr.value1 + tr.value3 + tr.value4) / 3, 0)
    WHEN tr.value3 <= 0 THEN ROUND((tr.value1 + tr.value2 + tr.value4) / 3, 0)
    WHEN tr.value4 <= 0 THEN ROUND((tr.value1 + tr.value2 + tr.value3) / 3, 0)
    ELSE ROUND((tr.value1 + tr.value2 + tr.value3 + tr.value4 - GREATEST(tr.value1, tr.value2, tr.value3, tr.value4)) / 3, 0)
  END AS bpa,
  CASE 
    WHEN tr.value1 <= 0 OR tr.value2 <= 0 OR tr.value3 <= 0 OR tr.value4 <= 0 THEN NULL
    ELSE ROUND((tr.value1 + tr.value2 + tr.value3 + tr.value4 - LEAST(tr.value1, tr.value2, tr.value3, tr.value4)) / 3, 0)
  END AS wpa,
  -- Calculate best_counting
  CASE
    WHEN tr.value1 <= 0 AND tr.value2 <= 0 THEN 
      (SELECT MIN(val) FROM (SELECT tr.value3 AS val UNION ALL SELECT tr.value4 UNION ALL SELECT tr.value5) sub)
    WHEN tr.value1 <= 0 AND tr.value3 <= 0 THEN 
      (SELECT MIN(val) FROM (SELECT tr.value2 AS val UNION ALL SELECT tr.value4 UNION ALL SELECT tr.value5) sub)
    WHEN tr.value1 <= 0 AND tr.value4 <= 0 THEN 
      (SELECT MIN(val) FROM (SELECT tr.value2 AS val UNION ALL SELECT tr.value3 UNION ALL SELECT tr.value5) sub)
    WHEN tr.value2 <= 0 AND tr.value3 <= 0 THEN 
      (SELECT MIN(val) FROM (SELECT tr.value1 AS val UNION ALL SELECT tr.value4 UNION ALL SELECT tr.value5) sub)
    WHEN tr.value2 <= 0 AND tr.value4 <= 0 THEN 
      (SELECT MIN(val) FROM (SELECT tr.value1 AS val UNION ALL SELECT tr.value3 UNION ALL SELECT tr.value5) sub)
    WHEN tr.value3 <= 0 AND tr.value4 <= 0 THEN 
      (SELECT MIN(val) FROM (SELECT tr.value1 AS val UNION ALL SELECT tr.value2 UNION ALL SELECT tr.value5) sub)
    ELSE 
      (SELECT MIN(val) FROM (SELECT tr.value1 AS val UNION ALL SELECT tr.value2 UNION ALL SELECT tr.value3 UNION ALL SELECT tr.value4 UNION ALL SELECT tr.value5 ORDER BY val LIMIT 1, 1) sub)
  END AS best_counting,
  -- Calculate worst_counting
  CASE
    WHEN tr.value1 <= 0 AND tr.value2 <= 0 THEN NULL
    WHEN tr.value1 <= 0 AND tr.value3 <= 0 THEN NULL
    WHEN tr.value1 <= 0 AND tr.value4 <= 0 THEN NULL
    WHEN tr.value2 <= 0 AND tr.value3 <= 0 THEN NULL
    WHEN tr.value2 <= 0 AND tr.value4 <= 0 THEN NULL
    WHEN tr.value3 <= 0 AND tr.value4 <= 0 THEN NULL
    WHEN tr.value1 <= 0 THEN GREATEST(tr.value2, tr.value3, tr.value4, tr.value5)
    WHEN tr.value2 <= 0 THEN GREATEST(tr.value1, tr.value3, tr.value4, tr.value5)
    WHEN tr.value3 <= 0 THEN GREATEST(tr.value1, tr.value2, tr.value4, tr.value5)
    WHEN tr.value4 <= 0 THEN GREATEST(tr.value1, tr.value2, tr.value3, tr.value5)
    ELSE 
      (SELECT MAX(val) FROM (SELECT tr.value1 AS val UNION ALL SELECT tr.value2 UNION ALL SELECT tr.value3 UNION ALL SELECT tr.value4 UNION ALL SELECT tr.value5 ORDER BY val DESC LIMIT 1, 1) sub)
  END AS worst_counting,
  -- Calculate best / average
  CASE 
    WHEN tr.value1 <= 0 OR tr.value2 <= 0 OR tr.value3 <= 0 OR tr.value4 <= 0 OR tr.value5 <= 0 THEN NULL -- 当5个value至少有一个小于等于0时，取best_average_ratio为NULL
    WHEN tr.average = 0 THEN NULL 
    ELSE ROUND(tr.best / tr.average, 2) 
  END AS best_average_ratio
FROM 
  TempResults tr
JOIN
  Competitions c ON tr.competitionId = c.id
ORDER BY
  best_average_ratio IS NULL, best_average_ratio;

-- Drop the temporary table
DROP TEMPORARY TABLE IF EXISTS TempResults;



/*
WHERE best > 0
ORDER BY
  best;
*/
