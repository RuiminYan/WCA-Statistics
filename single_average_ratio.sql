-- single_average_ratio of Ao5
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
        r.average,
        r.person_id,
        r.person_country_id,
        c.name,
        STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') AS date,
        r.regional_average_record,
        CASE 
            WHEN r.value1 <= 0 OR r.value2 <= 0 OR r.value3 <= 0 OR r.value4 <= 0 OR r.value5 <= 0 THEN NULL
            ELSE ROUND(r.best / r.average, 2) 
        END AS single_average_ratio,
        ROW_NUMBER() OVER (
            PARTITION BY STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') 
            ORDER BY 
            CASE 
                WHEN r.value1 <= 0 OR r.value2 <= 0 OR r.value3 <= 0 OR r.value4 <= 0 OR r.value5 <= 0 THEN NULL
                ELSE ROUND(r.best / r.average, 2) 
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
            ELSE ROUND(r.best / r.average, 2) 
        END IS NOT NULL
)
SELECT
    person_name,
    single_average_ratio,
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
SET @min_single_average_ratio = 9999999999; -- 假设一个初始的最大值

SELECT
    person_name,
    single_average_ratio,
    NULL,
    date,
    name,
    value1,
    value2,
    value3,
    value4,
    value5,
    person_id,
    person_country_id,
    regional_average_record
FROM (
    SELECT
        person_name,
        single_average_ratio,
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
        @min_single_average_ratio := LEAST(@min_single_average_ratio, single_average_ratio) AS current_min_single_average_ratio
    FROM
        FilteredResults
    ORDER BY
        date
) AS subquery
WHERE
    single_average_ratio IS NOT NULL AND single_average_ratio <= current_min_single_average_ratio
ORDER BY
    date;

















-- single_average_ratio of Mo3
-- 333fm: ROUND(r.best / r.average, 2) -> ROUND(r.best / r.average, 8)
-- 第一步：删除并创建 FilteredResults 表
DROP TEMPORARY TABLE IF EXISTS FilteredResults;
CREATE TEMPORARY TABLE FilteredResults AS
WITH RankedResults AS (
    SELECT
        r.person_name,
        r.value1,
        r.value2,
        r.value3,
        r.average,
        r.person_id,
        r.person_country_id,
        c.name,
        STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') AS date,
        r.regional_average_record,
        CASE 
            WHEN r.value1 <= 0 OR r.value2 <= 0 OR r.value3 <= 0 OR r.average = 0 THEN NULL
            ELSE ROUND(r.best / r.average, 2) 
        END AS single_average_ratio,
        ROW_NUMBER() OVER (
            PARTITION BY STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') 
            ORDER BY 
            CASE 
                WHEN r.value1 <= 0 OR r.value2 <= 0 OR r.value3 <= 0 OR r.average = 0 THEN NULL
                ELSE ROUND(r.best / r.average, 2) 
            END
        ) AS rn
    FROM
        results r
    JOIN
        competitions c ON r.competition_id = c.id
    WHERE
        r.event_id = '666' AND 
        CASE 
            WHEN r.value1 <= 0 OR r.value2 <= 0 OR r.value3 <= 0 OR r.average = 0 THEN NULL
            ELSE ROUND(r.best / r.average, 2) 
        END IS NOT NULL
)
SELECT
    person_name,
    single_average_ratio,
    regional_average_record,
    date,
    name,
    value1,
    value2,
    value3,
    person_id,
    person_country_id
FROM
    RankedResults
WHERE
    rn = 1;

-- 第二步：使用变量逐步跟踪最小值
SET @min_single_average_ratio = 9999999999; -- 假设一个初始的最大值

SELECT
    person_name,
    single_average_ratio,
    NULL,
    date,
    name,
    value1,
    value2,
    value3,
    NULL,
    NULL,
    person_id,
    person_country_id,
    regional_average_record
FROM (
    SELECT
        person_name,
        single_average_ratio,
        regional_average_record,
        date,
        name,
        value1,
        value2,
        value3,
        person_id,
        person_country_id,
        @min_single_average_ratio := LEAST(@min_single_average_ratio, single_average_ratio) AS current_min_single_average_ratio
    FROM
        FilteredResults
    ORDER BY
        date
) AS subquery
WHERE
    single_average_ratio IS NOT NULL AND single_average_ratio <= current_min_single_average_ratio
ORDER BY
    date;


