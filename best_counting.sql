-- 第一步：删除并创建 FilteredResults 表
DROP TEMPORARY TABLE IF EXISTS FilteredResults;
CREATE TEMPORARY TABLE FilteredResults AS
WITH RankedResults AS (
    SELECT
        r.person_name,
        r.value1,
        r.value2,
        r.value3,
        r.value4,
        r.value5,
        r.person_id,
        r.person_country_id,
        c.name,
        STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') AS date,
        r.regional_average_record,
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
        ROW_NUMBER() OVER (PARTITION BY STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') ORDER BY 
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
        END
        ) AS rn
    FROM
        results r
    JOIN
        competitions c ON r.competition_id = c.id
    WHERE
        r.event_id = '333' AND
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
    END > 0
)
SELECT
    person_name,
    best_counting,
    regional_average_record,
    date,
    name,
    value1,
    value2,
    value3,
    value4,
    value5,
    person_id,
    person_country_id
FROM
    RankedResults
WHERE
    rn = 1;

-- 第二步：使用变量逐步跟踪最小值
SET @min_best_counting = 9999999999; -- 假设一个初始的最大值

SELECT
    person_name,
    best_counting,
    regional_average_record,
    date,
    name,
    value1,
    value2,
    value3,
    value4,
    value5,
    person_id,
    person_country_id
FROM (
    SELECT
        person_name,
        best_counting,
        regional_average_record,
        date,
        name,
        value1,
        value2,
        value3,
        value4,
        value5,
        person_id,
        person_country_id,
        @min_best_counting := LEAST(@min_best_counting, best_counting) AS current_min_best_counting
    FROM
        FilteredResults
    ORDER BY
        date
) AS subquery
WHERE
    best_counting <= current_min_best_counting AND best_counting < 9999999999
ORDER BY
    date;
