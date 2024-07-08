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
  
  
  -- median of Ao5
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








  -- median of Mo3
        CASE
            -- 如果3个值都大于0，返回排序后的第2个值
            WHEN r.value1 > 0 AND r.value2 > 0 AND r.value3 > 0 THEN
                (SELECT val 
                 FROM (SELECT r.value1 AS val UNION ALL 
                              SELECT r.value2 UNION ALL 
                              SELECT r.value3) AS sub
                 ORDER BY val
                 LIMIT 1 OFFSET 1)
            -- 如果1个值小于0, 2个值大于0,返回排序后的最大值
            WHEN (r.value1 < 0 AND r.value2 > 0 AND r.value3 > 0) OR
                 (r.value2 < 0 AND r.value1 > 0 AND r.value3 > 0) OR
                 (r.value3 < 0 AND r.value1 > 0 AND r.value2 > 0) THEN
                GREATEST(r.value1, r.value2, r.value3)
            -- 其他情况，返回 NULL
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


  -- BAo5
  /*
如果5个value有超过2个≤0，则BAo5取为NULL
如果5个value有2个≤0，则BAo5取为剩下3个value的平均
如果5个value有1个≤0，则BAo5取为剩下4个value的和减去最大value,再除以3
如果5个value没有≤0，则BAo5取为5个value的和减去最大value, 再减去第二大value, 再除以3
*/
  CASE
            WHEN (r.value1 <= 0 AND r.value2 <= 0 AND r.value3 <= 0) OR 
                 (r.value1 <= 0 AND r.value2 <= 0 AND r.value4 <= 0) OR 
                 (r.value1 <= 0 AND r.value2 <= 0 AND r.value5 <= 0) OR 
                 (r.value1 <= 0 AND r.value3 <= 0 AND r.value4 <= 0) OR 
                 (r.value1 <= 0 AND r.value3 <= 0 AND r.value5 <= 0) OR 
                 (r.value1 <= 0 AND r.value4 <= 0 AND r.value5 <= 0) OR 
                 (r.value2 <= 0 AND r.value3 <= 0 AND r.value4 <= 0) OR 
                 (r.value2 <= 0 AND r.value3 <= 0 AND r.value5 <= 0) OR 
                 (r.value2 <= 0 AND r.value4 <= 0 AND r.value5 <= 0) OR 
                 (r.value3 <= 0 AND r.value4 <= 0 AND r.value5 <= 0) THEN NULL
            WHEN (r.value1 <= 0 AND r.value2 <= 0) OR 
                 (r.value1 <= 0 AND r.value3 <= 0) OR 
                 (r.value1 <= 0 AND r.value4 <= 0) OR 
                 (r.value1 <= 0 AND r.value5 <= 0) OR 
                 (r.value2 <= 0 AND r.value3 <= 0) OR 
                 (r.value2 <= 0 AND r.value4 <= 0) OR 
                 (r.value2 <= 0 AND r.value5 <= 0) OR 
                 (r.value3 <= 0 AND r.value4 <= 0) OR 
                 (r.value3 <= 0 AND r.value5 <= 0) OR 
                 (r.value4 <= 0 AND r.value5 <= 0) THEN 
                 ROUND((CASE WHEN r.value1 > 0 THEN r.value1 ELSE 0 END + 
                       CASE WHEN r.value2 > 0 THEN r.value2 ELSE 0 END + 
                       CASE WHEN r.value3 > 0 THEN r.value3 ELSE 0 END + 
                       CASE WHEN r.value4 > 0 THEN r.value4 ELSE 0 END + 
                       CASE WHEN r.value5 > 0 THEN r.value5 ELSE 0 END) / 3, 0)
            WHEN r.value1 <= 0 OR r.value2 <= 0 OR r.value3 <= 0 OR r.value4 <= 0 OR r.value5 <= 0 THEN 
                 ROUND((r.value1 + r.value2 + r.value3 + r.value4 + r.value5 - 
                        GREATEST(r.value1, r.value2, r.value3, r.value4, r.value5) - 
                        CASE WHEN r.value1 <= 0 THEN r.value1 
                             WHEN r.value2 <= 0 THEN r.value2 
                             WHEN r.value3 <= 0 THEN r.value3 
                             WHEN r.value4 <= 0 THEN r.value4 
                             ELSE r.value5 END) / 3, 0)
            ELSE ROUND((r.value1 + r.value2 + r.value3 + r.value4 + r.value5 - 
                       GREATEST(r.value1, r.value2, r.value3, r.value4, r.value5) - 
                       (SELECT val FROM (SELECT r.value1 AS val UNION ALL SELECT r.value2 UNION ALL SELECT r.value3 UNION ALL SELECT r.value4 UNION ALL SELECT r.value5 ORDER BY val DESC LIMIT 1, 1) AS subquery)) / 3, 0)
        END AS BAo5,


  -- WAo5
  /*
如果5个value至少有1个≤0，则WAo5取为NULL
如果5个value没有≤0，则WAo5取为5个value的和减去最小value, 再减去第二小value, 再除以3
*/
CASE
    WHEN r.value1 <= 0 OR r.value2 <= 0 OR r.value3 <= 0 OR r.value4 <= 0 OR r.value5 <= 0 THEN NULL
    ELSE ROUND((r.value1 + r.value2 + r.value3 + r.value4 + r.value5 - 
                LEAST(r.value1, r.value2, r.value3, r.value4, r.value5) - 
                (SELECT val FROM (SELECT r.value1 AS val UNION ALL SELECT r.value2 UNION ALL SELECT r.value3 UNION ALL SELECT r.value4 UNION ALL SELECT r.value5 ORDER BY val LIMIT 1, 1) AS subquery)) / 3, 0)
END AS WAo5



  
  
  -- best_counting
  -- 如果value中有非正数，则先将这些非正数取为9999999999. 然后计算5个value中第二小的数作为best_counting
  CASE
      WHEN r.value1 <= 0 OR r.value2 <= 0 OR r.value3 <= 0 OR r.value4 <= 0 OR r.value5 <= 0 THEN
          GREATEST(
              LEAST(IF(r.value1 <= 0, 9999999999, r.value1), IF(r.value2 <= 0, 9999999999, r.value2), IF(r.value3 <= 0, 9999999999, r.value3), IF(r.value4 <= 0, 9999999999, r.value4)),
              LEAST(IF(r.value1 <= 0, 9999999999, r.value1), IF(r.value2 <= 0, 9999999999, r.value2), IF(r.value3 <= 0, 9999999999, r.value3), IF(r.value5 <= 0, 9999999999, r.value5)),
              LEAST(IF(r.value1 <= 0, 9999999999, r.value1), IF(r.value2 <= 0, 9999999999, r.value2), IF(r.value4 <= 0, 9999999999, r.value4), IF(r.value5 <= 0, 9999999999, r.value5)),
              LEAST(IF(r.value1 <= 0, 9999999999, r.value1), IF(r.value3 <= 0, 9999999999, r.value3), IF(r.value4 <= 0, 9999999999, r.value4), IF(r.value5 <= 0, 9999999999, r.value5)),
              LEAST(IF(r.value2 <= 0, 9999999999, r.value2), IF(r.value3 <= 0, 9999999999, r.value3), IF(r.value4 <= 0, 9999999999, r.value4), IF(r.value5 <= 0, 9999999999, r.value5))
          )
      ELSE GREATEST(
          LEAST(r.value1, r.value2, r.value3, r.value4),
          LEAST(r.value1, r.value2, r.value3, r.value5),
          LEAST(r.value1, r.value2, r.value4, r.value5),
          LEAST(r.value1, r.value3, r.value4, r.value5),
          LEAST(r.value2, r.value3, r.value4, r.value5)
      )
  END AS best_counting,
    

  
  -- worst_counting
  -- 如果value中有非正数，则先将这些非正数取为9999999999. 然后计算5个value中第二大的数作为worst_counting
  CASE
      WHEN r.value1 <= 0 OR r.value2 <= 0 OR r.value3 <= 0 OR r.value4 <= 0 OR r.value5 <= 0 THEN
          LEAST(
              GREATEST(IF(r.value1 <= 0, 9999999999, r.value1), IF(r.value2 <= 0, 9999999999, r.value2), IF(r.value3 <= 0, 9999999999, r.value3), IF(r.value4 <= 0, 9999999999, r.value4)),
              GREATEST(IF(r.value1 <= 0, 9999999999, r.value1), IF(r.value2 <= 0, 9999999999, r.value2), IF(r.value3 <= 0, 9999999999, r.value3), IF(r.value5 <= 0, 9999999999, r.value5)),
              GREATEST(IF(r.value1 <= 0, 9999999999, r.value1), IF(r.value2 <= 0, 9999999999, r.value2), IF(r.value4 <= 0, 9999999999, r.value4), IF(r.value5 <= 0, 9999999999, r.value5)),
              GREATEST(IF(r.value1 <= 0, 9999999999, r.value1), IF(r.value3 <= 0, 9999999999, r.value3), IF(r.value4 <= 0, 9999999999, r.value4), IF(r.value5 <= 0, 9999999999, r.value5)),
              GREATEST(IF(r.value2 <= 0, 9999999999, r.value2), IF(r.value3 <= 0, 9999999999, r.value3), IF(r.value4 <= 0, 9999999999, r.value4), IF(r.value5 <= 0, 9999999999, r.value5))
          )
      ELSE LEAST(
          GREATEST(r.value1, r.value2, r.value3, r.value4),
          GREATEST(r.value1, r.value2, r.value3, r.value5),
          GREATEST(r.value1, r.value2, r.value4, r.value5),
          GREATEST(r.value1, r.value3, r.value4, r.value5),
          GREATEST(r.value2, r.value3, r.value4, r.value5)
      )
  END AS worst_counting,

  
  -- best_average_ratio
  -- 当5个value至少有一个≤0时，取best_average_ratio为NULL
  CASE 
    WHEN tr.value1 <= 0 OR tr.value2 <= 0 OR tr.value3 <= 0 OR tr.value4 <= 0 OR tr.value5 <= 0 THEN NULL
    WHEN tr.average = 0 THEN NULL 
    ELSE ROUND(tr.best / tr.average, 2) 
  END AS best_average_ratio,

  
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
