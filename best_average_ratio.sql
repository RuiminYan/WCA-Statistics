-- 第一步：删除并创建 FilteredResults 表
DROP TEMPORARY TABLE IF EXISTS FilteredResults;
CREATE TEMPORARY TABLE FilteredResults AS
WITH RankedResults AS (
    SELECT
        r.personName,
        r.value1,
        r.value2,
        r.value3,
        r.value4,
        r.value5,
        r.average,
        r.personId,
        r.personCountryId,
        c.name,
        STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') AS date,
        r.regionalAverageRecord,
        CASE 
            WHEN r.value1 <= 0 OR r.value2 <= 0 OR r.value3 <= 0 OR r.value4 <= 0 OR r.value5 <= 0 THEN NULL
            WHEN r.average = 0 THEN NULL 
            ELSE ROUND(r.best / r.average, 2) 
        END AS best_average_ratio,
        ROW_NUMBER() OVER (
            PARTITION BY STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') 
            ORDER BY 
            CASE 
                WHEN r.value1 <= 0 OR r.value2 <= 0 OR r.value3 <= 0 OR r.value4 <= 0 OR r.value5 <= 0 THEN NULL
                WHEN r.average = 0 THEN NULL 
                ELSE ROUND(r.best / r.average, 2) 
            END
        ) AS rn
    FROM
        results r
    JOIN
        competitions c ON r.competitionId = c.id
    WHERE
        r.eventId = '333' AND 
        CASE 
            WHEN r.value1 <= 0 OR r.value2 <= 0 OR r.value3 <= 0 OR r.value4 <= 0 OR r.value5 <= 0 THEN NULL
            WHEN r.average = 0 THEN NULL 
            ELSE ROUND(r.best / r.average, 2) 
        END IS NOT NULL
)
SELECT
    personName,
    best_average_ratio,
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
SET @min_best_average_ratio = 9999999999; -- 假设一个初始的最大值

SELECT
    NULL AS flag,
    personName,
    best_average_ratio AS best,
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
        best_average_ratio,
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
        @min_best_average_ratio := LEAST(@min_best_average_ratio, best_average_ratio) AS current_min_best_average_ratio
    FROM
        FilteredResults
    ORDER BY
        date
) AS subquery
WHERE
    best_average_ratio IS NOT NULL AND best_average_ratio <= current_min_best_average_ratio
ORDER BY
    date;
