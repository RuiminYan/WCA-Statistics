-- 第一步：删除并创建 FilteredResults 表
DROP TEMPORARY TABLE IF EXISTS FilteredResults;
CREATE TEMPORARY TABLE FilteredResults AS
WITH RankedResults AS (
    SELECT
        r.personName,
        -- 计算 best_counting
        CASE
            WHEN r.value1 <= 0 AND r.value2 <= 0 THEN 
                (SELECT MIN(val) FROM (SELECT r.value3 AS val UNION ALL SELECT r.value4 UNION ALL SELECT r.value5) sub)
            WHEN r.value1 <= 0 AND r.value3 <= 0 THEN 
                (SELECT MIN(val) FROM (SELECT r.value2 AS val UNION ALL SELECT r.value4 UNION ALL SELECT r.value5) sub)
            WHEN r.value1 <= 0 AND r.value4 <= 0 THEN 
                (SELECT MIN(val) FROM (SELECT r.value2 AS val UNION ALL SELECT r.value3 UNION ALL SELECT r.value5) sub)
            WHEN r.value2 <= 0 AND r.value3 <= 0 THEN 
                (SELECT MIN(val) FROM (SELECT r.value1 AS val UNION ALL SELECT r.value4 UNION ALL SELECT r.value5) sub)
            WHEN r.value2 <= 0 AND r.value4 <= 0 THEN 
                (SELECT MIN(val) FROM (SELECT r.value1 AS val UNION ALL SELECT r.value3 UNION ALL SELECT r.value5) sub)
            WHEN r.value3 <= 0 AND r.value4 <= 0 THEN 
                (SELECT MIN(val) FROM (SELECT r.value1 AS val UNION ALL SELECT r.value2 UNION ALL SELECT r.value5) sub)
            ELSE 
                (SELECT MIN(val) FROM (SELECT r.value1 AS val UNION ALL SELECT r.value2 UNION ALL SELECT r.value3 UNION ALL SELECT r.value4 UNION ALL SELECT r.value5 ORDER BY val LIMIT 1 OFFSET 1) sub)
        END AS best_counting,
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
            CASE
                WHEN r.value1 <= 0 AND r.value2 <= 0 THEN 
                    (SELECT MIN(val) FROM (SELECT r.value3 AS val UNION ALL SELECT r.value4 UNION ALL SELECT r.value5) sub)
                WHEN r.value1 <= 0 AND r.value3 <= 0 THEN 
                    (SELECT MIN(val) FROM (SELECT r.value2 AS val UNION ALL SELECT r.value4 UNION ALL SELECT r.value5) sub)
                WHEN r.value1 <= 0 AND r.value4 <= 0 THEN 
                    (SELECT MIN(val) FROM (SELECT r.value2 AS val UNION ALL SELECT r.value3 UNION ALL SELECT r.value5) sub)
                WHEN r.value2 <= 0 AND r.value3 <= 0 THEN 
                    (SELECT MIN(val) FROM (SELECT r.value1 AS val UNION ALL SELECT r.value4 UNION ALL SELECT r.value5) sub)
                WHEN r.value2 <= 0 AND r.value4 <= 0 THEN 
                    (SELECT MIN(val) FROM (SELECT r.value1 AS val UNION ALL SELECT r.value3 UNION ALL SELECT r.value5) sub)
                WHEN r.value3 <= 0 AND r.value4 <= 0 THEN 
                    (SELECT MIN(val) FROM (SELECT r.value1 AS val UNION ALL SELECT r.value2 UNION ALL SELECT r.value5) sub)
                ELSE 
                    (SELECT MIN(val) FROM (SELECT r.value1 AS val UNION ALL SELECT r.value2 UNION ALL SELECT r.value3 UNION ALL SELECT r.value4 UNION ALL SELECT r.value5 ORDER BY val LIMIT 1 OFFSET 1) sub)
            END
        ) AS rn
    FROM
        results r
    JOIN
        competitions c ON r.competitionId = c.id
    WHERE
        r.eventId = '333' AND
        CASE
            WHEN r.value1 <= 0 AND r.value2 <= 0 THEN 
                (SELECT MIN(val) FROM (SELECT r.value3 AS val UNION ALL SELECT r.value4 UNION ALL SELECT r.value5) sub)
            WHEN r.value1 <= 0 AND r.value3 <= 0 THEN 
                (SELECT MIN(val) FROM (SELECT r.value2 AS val UNION ALL SELECT r.value4 UNION ALL SELECT r.value5) sub)
            WHEN r.value1 <= 0 AND r.value4 <= 0 THEN 
                (SELECT MIN(val) FROM (SELECT r.value2 AS val UNION ALL SELECT r.value3 UNION ALL SELECT r.value5) sub)
            WHEN r.value2 <= 0 AND r.value3 <= 0 THEN 
                (SELECT MIN(val) FROM (SELECT r.value1 AS val UNION ALL SELECT r.value4 UNION ALL SELECT r.value5) sub)
            WHEN r.value2 <= 0 AND r.value4 <= 0 THEN 
                (SELECT MIN(val) FROM (SELECT r.value1 AS val UNION ALL SELECT r.value3 UNION ALL SELECT r.value5) sub)
            WHEN r.value3 <= 0 AND r.value4 <= 0 THEN 
                (SELECT MIN(val) FROM (SELECT r.value1 AS val UNION ALL SELECT r.value2 UNION ALL SELECT r.value5) sub)
            ELSE 
                (SELECT MIN(val) FROM (SELECT r.value1 AS val UNION ALL SELECT r.value2 UNION ALL SELECT r.value3 UNION ALL SELECT r.value4 UNION ALL SELECT r.value5 ORDER BY val LIMIT 1 OFFSET 1) sub)
        END > 0
)
SELECT
    personName,
    best_counting,
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
SET @min_best_counting = 9999999999; -- 假设一个初始的最大值

SELECT
    NULL AS flag,
    personName,
    best_counting,
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
        best_counting,
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
        @min_best_counting := LEAST(@min_best_counting, best_counting) AS current_min_best_counting
    FROM
        FilteredResults
    ORDER BY
        date
) AS subquery
WHERE
    best_counting <= current_min_best_counting
ORDER BY
    date;
