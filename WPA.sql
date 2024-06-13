-- 第一步：删除并创建 FilteredResults 表
DROP TEMPORARY TABLE IF EXISTS FilteredResults;
CREATE TEMPORARY TABLE FilteredResults AS
WITH RankedResults AS (
    SELECT
        r.personName,
        -- 计算 wpa
        CASE 
            WHEN r.value1 <= 0 OR r.value2 <= 0 OR r.value3 <= 0 OR r.value4 <= 0 THEN NULL
            ELSE ROUND((r.value1 + r.value2 + r.value3 + r.value4 - LEAST(r.value1, r.value2, r.value3, r.value4)) / 3, 0)
        END AS wpa,
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
                WHEN r.value1 <= 0 OR r.value2 <= 0 OR r.value3 <= 0 OR r.value4 <= 0 THEN NULL
                ELSE ROUND((r.value1 + r.value2 + r.value3 + r.value4 - LEAST(r.value1, r.value2, r.value3, r.value4)) / 3, 0)
            END
        ) AS rn
    FROM
        results r
    JOIN
        competitions c ON r.competitionId = c.id
    WHERE
        r.eventId = '333' AND
        CASE 
            WHEN r.value1 <= 0 OR r.value2 <= 0 OR r.value3 <= 0 OR r.value4 <= 0 THEN NULL
            ELSE ROUND((r.value1 + r.value2 + r.value3 + r.value4 - LEAST(r.value1, r.value2, r.value3, r.value4)) / 3, 0)
        END > 0
)
SELECT
    personName,
    wpa,
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
SET @min_wpa = 9999999999; -- 假设一个初始的最大值

SELECT
    NULL AS flag,
    personName,
    wpa,
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
        wpa,
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
        @min_wpa := LEAST(@min_wpa, wpa) AS current_min_wpa
    FROM
        FilteredResults
    ORDER BY
        date
) AS subquery
WHERE
    wpa <= current_min_wpa
ORDER BY
    date;
