/* 
variance, worst, median, bpa, wpa, mo5, best_counting, worst_counting, best_average_ratio

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
  r.best,
  r.average,
  r.regionalSingleRecord,
  r.regionalAverageRecord,
  r.competitionId,
  r.value1, 
  r.value2, 
  r.value3, 
  r.value4, 
  r.value5,
  r.personId,
  r.personCountryId
FROM 
  Results r
WHERE 
  r.eventId = '333';

-- Step 2: Join with Competitions table and perform calculations
SELECT
  NULL AS flag,
  tr.personName,
  -- mo5, set to NULL if any value is <= 0
  CASE 
    WHEN tr.value1 <= 0 OR tr.value2 <= 0 OR tr.value3 <= 0 OR tr.value4 <= 0 OR tr.value5 <= 0 THEN NULL
    ELSE ROUND((tr.value1 + tr.value2 + tr.value3 + tr.value4 + tr.value5) / 5, 0)
  END AS mo5,
  -- variance
  CASE 
    WHEN tr.value1 <= 0 OR tr.value2 <= 0 OR tr.value3 <= 0 OR tr.value4 <= 0 OR tr.value5 <= 0 THEN NULL
    ELSE ROUND((POW(tr.value1 - tr.average, 2) + POW(tr.value2 - tr.average, 2) + POW(tr.value3 - tr.average, 2) + POW(tr.value4 - tr.average, 2) + POW(tr.value5 - tr.average, 2)) / 5, 0)
  END AS variance,
  -- worst
  CASE WHEN LEAST(tr.value1, tr.value2, tr.value3, tr.value4, tr.value5) <= 0 THEN NULL ELSE GREATEST(tr.value1, tr.value2, tr.value3, tr.value4, tr.value5) END AS worst,  
  
  
  -- median
  CASE
  -- 如果5个值都大于0，返回排序后的第3个值
  WHEN tr.value1 > 0 AND tr.value2 > 0 AND tr.value3 > 0 AND tr.value4 > 0 AND tr.value5 > 0 THEN
    (SELECT val 
     FROM (SELECT tr.value1 AS val UNION ALL 
                  SELECT tr.value2 UNION ALL 
                  SELECT tr.value3 UNION ALL 
                  SELECT tr.value4 UNION ALL 
                  SELECT tr.value5) AS sub
     ORDER BY val
     LIMIT 1 OFFSET 2)

  -- 如果恰好1个值小于等于0，返回排序后的第4个值
  WHEN (tr.value1 <= 0 AND tr.value2 > 0 AND tr.value3 > 0 AND tr.value4 > 0 AND tr.value5 > 0) OR
       (tr.value2 <= 0 AND tr.value1 > 0 AND tr.value3 > 0 AND tr.value4 > 0 AND tr.value5 > 0) OR
       (tr.value3 <= 0 AND tr.value1 > 0 AND tr.value2 > 0 AND tr.value4 > 0 AND tr.value5 > 0) OR
       (tr.value4 <= 0 AND tr.value1 > 0 AND tr.value2 > 0 AND tr.value3 > 0 AND tr.value5 > 0) OR
       (tr.value5 <= 0 AND tr.value1 > 0 AND tr.value2 > 0 AND tr.value3 > 0 AND tr.value4 > 0) THEN
    (SELECT val 
     FROM (SELECT tr.value1 AS val UNION ALL 
                  SELECT tr.value2 UNION ALL 
                  SELECT tr.value3 UNION ALL 
                  SELECT tr.value4 UNION ALL 
                  SELECT tr.value5) AS sub
     ORDER BY val
     LIMIT 1 OFFSET 3)

  -- 如果恰好2个值小于等于0，返回排序后的第5个值
  WHEN (tr.value1 <= 0 AND tr.value2 <= 0 AND tr.value3 > 0 AND tr.value4 > 0 AND tr.value5 > 0) OR
       (tr.value1 <= 0 AND tr.value3 <= 0 AND tr.value2 > 0 AND tr.value4 > 0 AND tr.value5 > 0) OR
       (tr.value1 <= 0 AND tr.value4 <= 0 AND tr.value2 > 0 AND tr.value3 > 0 AND tr.value5 > 0) OR
       (tr.value1 <= 0 AND tr.value5 <= 0 AND tr.value2 > 0 AND tr.value3 > 0 AND tr.value4 > 0) OR
       (tr.value2 <= 0 AND tr.value3 <= 0 AND tr.value1 > 0 AND tr.value4 > 0 AND tr.value5 > 0) OR
       (tr.value2 <= 0 AND tr.value4 <= 0 AND tr.value1 > 0 AND tr.value3 > 0 AND tr.value5 > 0) OR
       (tr.value2 <= 0 AND tr.value5 <= 0 AND tr.value1 > 0 AND tr.value3 > 0 AND tr.value4 > 0) OR
       (tr.value3 <= 0 AND tr.value4 <= 0 AND tr.value1 > 0 AND tr.value2 > 0 AND tr.value5 > 0) OR
       (tr.value3 <= 0 AND tr.value5 <= 0 AND tr.value1 > 0 AND tr.value2 > 0 AND tr.value4 > 0) OR
       (tr.value4 <= 0 AND tr.value5 <= 0 AND tr.value1 > 0 AND tr.value2 > 0 AND tr.value3 > 0) THEN
    (SELECT val 
     FROM (SELECT tr.value1 AS val UNION ALL 
                  SELECT tr.value2 UNION ALL 
                  SELECT tr.value3 UNION ALL 
                  SELECT tr.value4 UNION ALL 
                  SELECT tr.value5) AS sub
     ORDER BY val
     LIMIT 1 OFFSET 4)

  -- 其他情况，返回NULL
  ELSE NULL
END AS median,

  
  -- bpa
  CASE 
    WHEN (tr.value1 <= 0 AND tr.value2 <= 0) OR (tr.value1 <= 0 AND tr.value3 <= 0) OR (tr.value1 <= 0 AND tr.value4 <= 0) OR (tr.value2 <= 0 AND tr.value3 <= 0) OR (tr.value2 <= 0 AND tr.value4 <= 0) OR (tr.value3 <= 0 AND tr.value4 <= 0) THEN NULL
    WHEN tr.value1 <= 0 THEN ROUND((tr.value2 + tr.value3 + tr.value4) / 3, 0) 
    WHEN tr.value2 <= 0 THEN ROUND((tr.value1 + tr.value3 + tr.value4) / 3, 0)
    WHEN tr.value3 <= 0 THEN ROUND((tr.value1 + tr.value2 + tr.value4) / 3, 0)
    WHEN tr.value4 <= 0 THEN ROUND((tr.value1 + tr.value2 + tr.value3) / 3, 0)
    ELSE ROUND((tr.value1 + tr.value2 + tr.value3 + tr.value4 - GREATEST(tr.value1, tr.value2, tr.value3, tr.value4)) / 3, 0)
  END AS bpa,
  -- wpa
  CASE 
    WHEN tr.value1 <= 0 OR tr.value2 <= 0 OR tr.value3 <= 0 OR tr.value4 <= 0 THEN NULL
    ELSE ROUND((tr.value1 + tr.value2 + tr.value3 + tr.value4 - LEAST(tr.value1, tr.value2, tr.value3, tr.value4)) / 3, 0)
  END AS wpa,
  -- best_counting
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
  -- worst_counting
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
  -- best / average
  CASE 
    WHEN tr.value1 <= 0 OR tr.value2 <= 0 OR tr.value3 <= 0 OR tr.value4 <= 0 OR tr.value5 <= 0 THEN NULL -- 当5个value至少有一个小于等于0时，取best_average_ratio为NULL
    WHEN tr.average = 0 THEN NULL 
    ELSE ROUND(tr.best / tr.average, 2) 
  END AS best_average_ratio,
  tr.regionalSingleRecord,
  tr.regionalAverageRecord,
  STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') AS date,
  c.name,
  tr.value1, 
  tr.value2, 
  tr.value3, 
  tr.value4, 
  tr.value5,
  tr.personId,
  tr.personCountryId
FROM 
  TempResults tr
JOIN
  Competitions c ON tr.competitionId = c.id
ORDER BY
  date;

-- Drop the temporary table
DROP TEMPORARY TABLE IF EXISTS TempResults;




/*
ORDER BY
  best_average_ratio IS NULL, best_average_ratio;

ORDER BY
WHERE best > 0
ORDER BY
  best;
*/
