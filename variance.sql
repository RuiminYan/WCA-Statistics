-- variance of Ao5
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
        r.regionalAverageRecord,
        CASE 
            WHEN r.value1 <= 0 OR r.value2 <= 0 OR r.value3 <= 0 OR r.value4 <= 0 OR r.value5 <= 0 THEN NULL
            ELSE ROUND((POW(r.value1 - (r.value1 + r.value2 + r.value3 + r.value4 + r.value5) / 5, 2) + POW(r.value2 - (r.value1 + r.value2 + r.value3 + r.value4 + r.value5) / 5, 2) + POW(r.value3 - (r.value1 + r.value2 + r.value3 + r.value4 + r.value5) / 5, 2) + POW(r.value4 - (r.value1 + r.value2 + r.value3 + r.value4 + r.value5) / 5, 2) + POW(r.value5 - (r.value1 + r.value2 + r.value3 + r.value4 + r.value5) / 5, 2)) / 4, 0)
        END AS variance,
        ROW_NUMBER() OVER (
            PARTITION BY STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') 
            ORDER BY 
            CASE 
                WHEN r.value1 <= 0 OR r.value2 <= 0 OR r.value3 <= 0 OR r.value4 <= 0 OR r.value5 <= 0 THEN NULL
                ELSE ROUND((POW(r.value1 - (r.value1 + r.value2 + r.value3 + r.value4 + r.value5) / 5, 2) + POW(r.value2 - (r.value1 + r.value2 + r.value3 + r.value4 + r.value5) / 5, 2) + POW(r.value3 - (r.value1 + r.value2 + r.value3 + r.value4 + r.value5) / 5, 2) + POW(r.value4 - (r.value1 + r.value2 + r.value3 + r.value4 + r.value5) / 5, 2) + POW(r.value5 - (r.value1 + r.value2 + r.value3 + r.value4 + r.value5) / 5, 2)) / 4, 0)
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
            ELSE ROUND((POW(r.value1 - (r.value1 + r.value2 + r.value3 + r.value4 + r.value5) / 5, 2) + POW(r.value2 - (r.value1 + r.value2 + r.value3 + r.value4 + r.value5) / 5, 2) + POW(r.value3 - (r.value1 + r.value2 + r.value3 + r.value4 + r.value5) / 5, 2) + POW(r.value4 - (r.value1 + r.value2 + r.value3 + r.value4 + r.value5) / 5, 2) + POW(r.value5 - (r.value1 + r.value2 + r.value3 + r.value4 + r.value5) / 5, 2)) / 4, 0)
        END > 0
)
SELECT
    personName,
    variance,
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
SET @min_variance = 9999999999; -- 假设一个初始的最大值

SELECT
    personName,
    variance,
    NULL,
    date,
    name,
    value1,
    value2,
    value3,
    value4,
    value5,
    personId,
    personCountryId,
    regionalAverageRecord
FROM (
    SELECT
        personName,
        variance,
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
        @min_variance := LEAST(@min_variance, variance) AS current_min_variance
    FROM
        FilteredResults
    ORDER BY
        date
) AS subquery
WHERE
    variance IS NOT NULL AND variance <= current_min_variance
ORDER BY
    date;


















-- variance of Mo3
-- 第一步：删除并创建 FilteredResults 表
DROP TEMPORARY TABLE IF EXISTS FilteredResults;
CREATE TEMPORARY TABLE FilteredResults AS
WITH RankedResults AS (
    SELECT
        r.personName,
        r.value1,
        r.value2,
        r.value3,
        r.personId,
        r.personCountryId,
        c.name,
        STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') AS date,
        r.regionalAverageRecord,
        CASE 
            WHEN r.value1 <= 0 OR r.value2 <= 0 OR r.value3 <= 0 THEN NULL
            ELSE ROUND((POW(r.value1 - (r.value1 + r.value2 + r.value3) / 3, 2) + POW(r.value2 - (r.value1 + r.value2 + r.value3) / 3, 2) + POW(r.value3 - (r.value1 + r.value2 + r.value3) / 3, 2)) / 2, 0)
        END AS variance,
        ROW_NUMBER() OVER (
            PARTITION BY STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') 
            ORDER BY 
            CASE 
                WHEN r.value1 <= 0 OR r.value2 <= 0 OR r.value3 <= 0 THEN NULL
                ELSE ROUND((POW(r.value1 - (r.value1 + r.value2 + r.value3) / 3, 2) + POW(r.value2 - (r.value1 + r.value2 + r.value3) / 3, 2) + POW(r.value3 - (r.value1 + r.value2 + r.value3) / 3, 2)) / 2, 0)
            END
        ) AS rn
    FROM
        results r
    JOIN
        competitions c ON r.competitionId = c.id
    WHERE
        r.eventId = '666' AND 
		CASE 
            WHEN r.value1 <= 0 OR r.value2 <= 0 OR r.value3 <= 0 THEN NULL
            ELSE ROUND((POW(r.value1 - (r.value1 + r.value2 + r.value3) / 3, 2) + POW(r.value2 - (r.value1 + r.value2 + r.value3) / 3, 2) + POW(r.value3 - (r.value1 + r.value2 + r.value3) / 3, 2)) / 2, 0)
        END > 0
)
SELECT
    personName,
    variance,
    regionalAverageRecord,
    date,
    name,
    value1,
    value2,
    value3,
    personId,
    personCountryId
FROM
    RankedResults
WHERE
    rn = 1;

-- 第二步：使用变量逐步跟踪最小值
SET @min_variance = 9999999999; -- 假设一个初始的最大值

SELECT
    personName,
    variance,
    NULL,
    date,
    name,
    value1,
    value2,
    value3,
    NULL,
    NULL,
    personId,
    personCountryId,
    regionalAverageRecord
FROM (
    SELECT
        personName,
        variance,
        regionalAverageRecord,
        date,
        name,
        value1,
        value2,
        value3,
        personId,
        personCountryId,
        @min_variance := LEAST(@min_variance, variance) AS current_min_variance
    FROM
        FilteredResults
    ORDER BY
        date
) AS subquery
WHERE
    variance IS NOT NULL AND variance <= current_min_variance
ORDER BY
    date;
