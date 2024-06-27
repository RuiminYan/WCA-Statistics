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
        ROW_NUMBER() OVER (PARTITION BY STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') ORDER BY 
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
        END
        ) AS rn
    FROM
        results r
    JOIN
        competitions c ON r.competitionId = c.id
    WHERE
        r.eventId = '333' AND 
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
        END > 0
)
SELECT
    personName,
    worst_counting,
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
SET @min_worst_counting = 9999999999; -- 假设一个初始的最大值

SELECT
    personName,
    worst_counting,
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
        worst_counting,
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
        @min_worst_counting := LEAST(@min_worst_counting, worst_counting) AS current_min_worst_counting
    FROM
        FilteredResults
    ORDER BY
        date
) AS subquery
WHERE
    worst_counting <= current_min_worst_counting AND worst_counting != 9999999999
ORDER BY
    date;
