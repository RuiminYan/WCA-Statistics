/*
替换best为[目标函数]，确保所有涉及 best 的地方都使用新的[目标函数]计算逻辑;
将regionalAverageRecord换成regionalSingleRecord.
*/

-- 第一步：删除并创建 FilteredResults 表
DROP TEMPORARY TABLE IF EXISTS FilteredResults;
CREATE TEMPORARY TABLE FilteredResults AS
WITH RankedResults AS (
    SELECT
        r.personName,
        r.best,
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
        ROW_NUMBER() OVER (PARTITION BY STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') ORDER BY r.best) AS rn
    FROM
        results r
    JOIN
        competitions c ON r.competitionId = c.id
    WHERE
        r.eventId = '333' AND r.best > 0
)
SELECT
    personName,
    best,
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
    rn = 1; -- 9i2) 如果同一个纪录在一天内多次被打破，只有最好的那个成绩被认为打破了该纪录; 这里有bug, 如果同一天有2把相同的WR, 则只会选择一个

-- 第二步：使用变量逐步跟踪最小值
SET @min_best = 9999999999; -- 假设一个初始的最大值

SELECT
    NULL AS flag,
    personName,
    best,
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
        best,
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
        @min_best := LEAST(@min_best, best) AS current_min_best
    FROM
        FilteredResults
    ORDER BY
        date
) AS subquery
WHERE
    best <= current_min_best
ORDER BY
    date;
