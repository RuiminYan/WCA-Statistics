-- 第一步：删除并创建 FilteredResults 表
DROP TEMPORARY TABLE IF EXISTS FilteredResults;
CREATE TEMPORARY TABLE FilteredResults AS
WITH RankedResults AS (
    SELECT
        r.personName,
        -- 计算 median
        CASE WHEN 
            (SELECT ROUND(AVG(val), 2) 
             FROM (SELECT val 
                   FROM (SELECT r.value1 AS val UNION ALL SELECT r.value2 UNION ALL SELECT r.value3 UNION ALL SELECT r.value4 UNION ALL SELECT r.value5) sub 
                   ORDER BY val 
                   LIMIT 3, 1) median) <= 0
        THEN NULL ELSE 
            (SELECT ROUND(AVG(val), 2) 
             FROM (SELECT val 
                   FROM (SELECT r.value1 AS val UNION ALL SELECT r.value2 UNION ALL SELECT r.value3 UNION ALL SELECT r.value4 UNION ALL SELECT r.value5) sub 
                   ORDER BY val 
                   LIMIT 3, 1) median)
        END AS median,
        r.value1,
        r.value2,
        r.value3,
        r.value4,
        r.value5,
        r.personId,
        r.personCountryId,
        c.name,
        STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') AS date,
        r.regionalAverageRecord,
        ROW_NUMBER() OVER (PARTITION BY STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') ORDER BY 
            CASE WHEN 
                (SELECT ROUND(AVG(val), 2) 
                 FROM (SELECT val 
                       FROM (SELECT r.value1 AS val UNION ALL SELECT r.value2 UNION ALL SELECT r.value3 UNION ALL SELECT r.value4 UNION ALL SELECT r.value5) sub 
                       ORDER BY val 
                       LIMIT 3, 1) median) <= 0
            THEN NULL ELSE 
                (SELECT ROUND(AVG(val), 2) 
                 FROM (SELECT val 
                       FROM (SELECT r.value1 AS val UNION ALL SELECT r.value2 UNION ALL SELECT r.value3 UNION ALL SELECT r.value4 UNION ALL SELECT r.value5) sub 
                       ORDER BY val 
                       LIMIT 3, 1) median)
            END
        ) AS rn
    FROM
        results r
    JOIN
        competitions c ON r.competitionId = c.id
    WHERE
        r.eventId = '333' AND
        CASE WHEN 
            (SELECT ROUND(AVG(val), 2) 
             FROM (SELECT val 
                   FROM (SELECT r.value1 AS val UNION ALL SELECT r.value2 UNION ALL SELECT r.value3 UNION ALL SELECT r.value4 UNION ALL SELECT r.value5) sub 
                   ORDER BY val 
                   LIMIT 3, 1) median) <= 0
        THEN NULL ELSE 
            (SELECT ROUND(AVG(val), 2) 
             FROM (SELECT val 
                   FROM (SELECT r.value1 AS val UNION ALL SELECT r.value2 UNION ALL SELECT r.value3 UNION ALL SELECT r.value4 UNION ALL SELECT r.value5) sub 
                   ORDER BY val 
                   LIMIT 3, 1) median)
        END > 0
)
SELECT
    personName,
    median,
    regionalAverageRecord,
    date,
    name,
    value1,
    value2,
    value3,
    value4,
    value5,
    personId,
    personCountryId
FROM
    RankedResults
WHERE
    rn = 1;

-- 第二步：使用变量逐步跟踪最小值
SET @min_median = 9999999999; -- 假设一个初始的最大值

SELECT
    NULL AS flag,
    personName,
    median,
    regionalAverageRecord,
    date,
    name,
    value1,
    value2,
    value3,
    value4,
    value5,
    personId,
    personCountryId
FROM (
    SELECT
        personName,
        median,
        regionalAverageRecord,
        date,
        name,
        value1,
        value2,
        value3,
        value4,
        value5,
        personId,
        personCountryId,
        @min_median := LEAST(@min_median, median) AS current_min_median
    FROM
        FilteredResults
    ORDER BY
        date
) AS subquery
WHERE
    median <= current_min_median
ORDER BY
    date;
