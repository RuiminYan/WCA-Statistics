-- 第一步：删除并创建 FilteredResults 表
DROP TEMPORARY TABLE IF EXISTS FilteredResults;
CREATE TEMPORARY TABLE FilteredResults AS
WITH RankedResults AS (
    SELECT
        r.person_name,
        CASE
            WHEN r.value1 <= 0 OR r.value2 <= 0 OR r.value3 <= 0 OR r.value4 <= 0 OR r.value5 <= 0 THEN NULL
            ELSE ROUND((r.value1 + r.value2 + r.value3 + r.value4 + r.value5 - 
                        LEAST(r.value1, r.value2, r.value3, r.value4, r.value5) - 
                        (SELECT val FROM (SELECT r.value1 AS val UNION ALL SELECT r.value2 UNION ALL SELECT r.value3 UNION ALL SELECT r.value4 UNION ALL SELECT r.value5 ORDER BY val LIMIT 1, 1) AS subquery)) / 3, 0)
        END AS WAo5, -- 目标函数
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
        ROW_NUMBER() OVER (PARTITION BY STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') ORDER BY CASE
            WHEN r.value1 <= 0 OR r.value2 <= 0 OR r.value3 <= 0 OR r.value4 <= 0 OR r.value5 <= 0 THEN NULL
            ELSE ROUND((r.value1 + r.value2 + r.value3 + r.value4 + r.value5 - 
                        LEAST(r.value1, r.value2, r.value3, r.value4, r.value5) - 
                        (SELECT val FROM (SELECT r.value1 AS val UNION ALL SELECT r.value2 UNION ALL SELECT r.value3 UNION ALL SELECT r.value4 UNION ALL SELECT r.value5 ORDER BY val LIMIT 1, 1) AS subquery)) / 3, 0)
        END) AS rn -- 使用目标函数
    FROM
        results r
    JOIN
        competitions c ON r.competition_id = c.id
    WHERE
        r.event_id = '333' AND CASE
            WHEN r.value1 <= 0 OR r.value2 <= 0 OR r.value3 <= 0 OR r.value4 <= 0 OR r.value5 <= 0 THEN NULL
            ELSE ROUND((r.value1 + r.value2 + r.value3 + r.value4 + r.value5 - 
                        LEAST(r.value1, r.value2, r.value3, r.value4, r.value5) - 
                        (SELECT val FROM (SELECT r.value1 AS val UNION ALL SELECT r.value2 UNION ALL SELECT r.value3 UNION ALL SELECT r.value4 UNION ALL SELECT r.value5 ORDER BY val LIMIT 1, 1) AS subquery)) / 3, 0)
        END > 0 -- 使用目标函数
)
SELECT
    person_name,
    WAo5, -- 使用目标函数名称
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
    rn = 1; -- 如果同一个纪录在一天内多次被打破，只有最好的那个成绩被认为打破了该纪录; 这里有bug, 如果同一天有2把相同的WR, 则只会选择一个

-- 第二步：使用变量逐步跟踪最小值
SET @min_WAo5 = 9999999999; -- 假设一个初始的最大值 -- 使用目标函数名称

SELECT
    person_name,
    WAo5, -- 使用目标函数名称
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
        WAo5, -- 使用目标函数名称
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
        @min_WAo5 := LEAST(@min_WAo5, WAo5) AS current_min_WAo5 -- 使用目标函数名称
    FROM
        FilteredResults
    ORDER BY
        date
) AS subquery
WHERE
    WAo5 <= current_min_WAo5 -- 使用目标函数名称
ORDER BY
    date;
