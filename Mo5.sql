-- 第一步：删除并创建 FilteredResults 表
DROP TEMPORARY TABLE IF EXISTS FilteredResults;
CREATE TEMPORARY TABLE FilteredResults AS
WITH RankedResults AS (
    SELECT
        r.person_name,
        -- 计算 mo5
        CASE 
            WHEN r.value1 <= 0 OR r.value2 <= 0 OR r.value3 <= 0 OR r.value4 <= 0 OR r.value5 <= 0 THEN NULL
            ELSE ROUND((r.value1 + r.value2 + r.value3 + r.value4 + r.value5) / 5, 0)
        END AS mo5,
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
        ROW_NUMBER() OVER (PARTITION BY STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') ORDER BY 
            CASE 
                WHEN r.value1 <= 0 OR r.value2 <= 0 OR r.value3 <= 0 OR r.value4 <= 0 OR r.value5 <= 0 THEN NULL
                ELSE ROUND((r.value1 + r.value2 + r.value3 + r.value4 + r.value5) / 5, 0)
            END
        ) AS rn
    FROM
        results r
    JOIN
        competitions c ON r.competition_id = c.id
    WHERE
        r.event_id = '333' AND
        CASE 
            WHEN r.value1 <= 0 OR r.value2 <= 0 OR r.value3 <= 0 OR r.value4 <= 0 OR r.value5 <= 0 THEN NULL
            ELSE ROUND((r.value1 + r.value2 + r.value3 + r.value4 + r.value5) / 5, 0)
        END > 0
)
SELECT
    person_name,
    mo5,
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
SET @min_mo5 = 9999999999; -- 假设一个初始的最大值

SELECT
    person_name,
    mo5,
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
        mo5,
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
        @min_mo5 := LEAST(@min_mo5, mo5) AS current_min_mo5
    FROM
        FilteredResults
    ORDER BY
        date
) AS subquery
WHERE
    mo5 <= current_min_mo5
ORDER BY
    date;
