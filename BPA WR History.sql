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
        r.personId,
        r.personCountryId,
        c.name,
        STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') AS date,
        -- 计算 bpa
        CASE 
            WHEN (r.value1 <= 0 AND r.value2 <= 0) OR (r.value1 <= 0 AND r.value3 <= 0) OR (r.value1 <= 0 AND r.value4 <= 0) OR (r.value2 <= 0 AND r.value3 <= 0) OR (r.value2 <= 0 AND r.value4 <= 0) OR (r.value3 <= 0 AND r.value4 <= 0) THEN NULL
            WHEN r.value1 <= 0 THEN ROUND((r.value2 + r.value3 + r.value4) / 3, 0) 
            WHEN r.value2 <= 0 THEN ROUND((r.value1 + r.value3 + r.value4) / 3, 0)
            WHEN r.value3 <= 0 THEN ROUND((r.value1 + r.value2 + r.value4) / 3, 0)
            WHEN r.value4 <= 0 THEN ROUND((r.value1 + r.value2 + r.value3) / 3, 0)
            ELSE ROUND((r.value1 + r.value2 + r.value3 + r.value4 - GREATEST(r.value1, r.value2, r.value3, r.value4)) / 3, 0)
        END AS bpa,
        ROW_NUMBER() OVER (PARTITION BY STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') ORDER BY 
            CASE 
                WHEN (r.value1 <= 0 AND r.value2 <= 0) OR (r.value1 <= 0 AND r.value3 <= 0) OR (r.value1 <= 0 AND r.value4 <= 0) OR (r.value2 <= 0 AND r.value3 <= 0) OR (r.value2 <= 0 AND r.value4 <= 0) OR (r.value3 <= 0 AND r.value4 <= 0) THEN NULL
                WHEN r.value1 <= 0 THEN ROUND((r.value2 + r.value3 + r.value4) / 3, 0) 
                WHEN r.value2 <= 0 THEN ROUND((r.value1 + r.value3 + r.value4) / 3, 0)
                WHEN r.value3 <= 0 THEN ROUND((r.value1 + r.value2 + r.value4) / 3, 0)
                WHEN r.value4 <= 0 THEN ROUND((r.value1 + r.value2 + r.value3) / 3, 0)
                ELSE ROUND((r.value1 + r.value2 + r.value3 + r.value4 - GREATEST(r.value1, r.value2, r.value3, r.value4)) / 3, 0)
            END
        ) AS rn
    FROM
        results r
    JOIN
        competitions c ON r.competitionId = c.id
    WHERE
        r.eventId = '333' AND
        CASE 
            WHEN (r.value1 <= 0 AND r.value2 <= 0) OR (r.value1 <= 0 AND r.value3 <= 0) OR (r.value1 <= 0 AND r.value4 <= 0) OR (r.value2 <= 0 AND r.value3 <= 0) OR (r.value2 <= 0 AND r.value4 <= 0) OR (r.value3 <= 0 AND r.value4 <= 0) THEN NULL
            WHEN r.value1 <= 0 THEN ROUND((r.value2 + r.value3 + r.value4) / 3, 0) 
            WHEN r.value2 <= 0 THEN ROUND((r.value1 + r.value3 + r.value4) / 3, 0)
            WHEN r.value3 <= 0 THEN ROUND((r.value1 + r.value2 + r.value4) / 3, 0)
            WHEN r.value4 <= 0 THEN ROUND((r.value1 + r.value2 + r.value3) / 3, 0)
            ELSE ROUND((r.value1 + r.value2 + r.value3 + r.value4 - GREATEST(r.value1, r.value2, r.value3, r.value4)) / 3, 0)
        END > 0
)
SELECT
    personName,
    bpa,
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
SET @min_bpa = 9999999999; -- 假设一个初始的最大值

SELECT
    NULL AS flag,
    personName,
    bpa,
    NULL AS nothing,
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
        bpa,
        date,
        name,
        value1,
        value2,
        value3,
        value4,
        value5,
        personId,
        personCountryId,
        @min_bpa := LEAST(@min_bpa, bpa) AS current_min_bpa
    FROM
        FilteredResults
    ORDER BY
        date
) AS subquery
WHERE
    bpa <= current_min_bpa
ORDER BY
    date;
