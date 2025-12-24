-- variance of Ao5
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
        competitions c ON r.competition_id = c.id
    WHERE
        r.event_id = '333' AND 
		CASE 
            WHEN r.value1 <= 0 OR r.value2 <= 0 OR r.value3 <= 0 OR r.value4 <= 0 OR r.value5 <= 0 THEN NULL
            ELSE ROUND((POW(r.value1 - (r.value1 + r.value2 + r.value3 + r.value4 + r.value5) / 5, 2) + POW(r.value2 - (r.value1 + r.value2 + r.value3 + r.value4 + r.value5) / 5, 2) + POW(r.value3 - (r.value1 + r.value2 + r.value3 + r.value4 + r.value5) / 5, 2) + POW(r.value4 - (r.value1 + r.value2 + r.value3 + r.value4 + r.value5) / 5, 2) + POW(r.value5 - (r.value1 + r.value2 + r.value3 + r.value4 + r.value5) / 5, 2)) / 4, 0)
        END > 0
)
SELECT
    person_name,
    variance,
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
SET @min_variance = 9999999999; -- 假设一个初始的最大值

SELECT
    person_name,
    variance,
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
        variance,
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
        r.person_name,
        r.value1,
        r.value2,
        r.value3,
        r.person_id,
        r.person_country_id,
        c.name,
        STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') AS date,
        r.regional_average_record,
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
        competitions c ON r.competition_id = c.id
    WHERE
        r.event_id = '666' AND 
		CASE 
            WHEN r.value1 <= 0 OR r.value2 <= 0 OR r.value3 <= 0 THEN NULL
            ELSE ROUND((POW(r.value1 - (r.value1 + r.value2 + r.value3) / 3, 2) + POW(r.value2 - (r.value1 + r.value2 + r.value3) / 3, 2) + POW(r.value3 - (r.value1 + r.value2 + r.value3) / 3, 2)) / 2, 0)
        END > 0
)
SELECT
    person_name,
    variance,
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
SET @min_variance = 9999999999; -- 假设一个初始的最大值

SELECT
    person_name,
    variance,
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
        variance,
        regional_average_record,
        date,
        name,
        value1,
        value2,
        value3,
        person_id,
        person_country_id,
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
