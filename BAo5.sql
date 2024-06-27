/*
BAo5的方法如下：
如果5个value有超过2个≤0，则BAo5取为NULL
如果5个value有2个≤0，则BAo5取为剩下3个value的平均
如果5个value有1个≤0，则BAo5取为剩下4个value的和减去最大value,再除以3
如果5个value没有≤0，则BAo5取为5个value的和减去最大value, 再减去第二大value, 再除以3
*/

-- 第一步：删除并创建 FilteredResults 表
DROP TEMPORARY TABLE IF EXISTS FilteredResults;
CREATE TEMPORARY TABLE FilteredResults AS
WITH RankedResults AS (
    SELECT
        r.personName,
        CASE
            WHEN (r.value1 <= 0 AND r.value2 <= 0 AND r.value3 <= 0) OR 
                 (r.value1 <= 0 AND r.value2 <= 0 AND r.value4 <= 0) OR 
                 (r.value1 <= 0 AND r.value2 <= 0 AND r.value5 <= 0) OR 
                 (r.value1 <= 0 AND r.value3 <= 0 AND r.value4 <= 0) OR 
                 (r.value1 <= 0 AND r.value3 <= 0 AND r.value5 <= 0) OR 
                 (r.value1 <= 0 AND r.value4 <= 0 AND r.value5 <= 0) OR 
                 (r.value2 <= 0 AND r.value3 <= 0 AND r.value4 <= 0) OR 
                 (r.value2 <= 0 AND r.value3 <= 0 AND r.value5 <= 0) OR 
                 (r.value2 <= 0 AND r.value4 <= 0 AND r.value5 <= 0) OR 
                 (r.value3 <= 0 AND r.value4 <= 0 AND r.value5 <= 0) THEN NULL
            WHEN (r.value1 <= 0 AND r.value2 <= 0) OR 
                 (r.value1 <= 0 AND r.value3 <= 0) OR 
                 (r.value1 <= 0 AND r.value4 <= 0) OR 
                 (r.value1 <= 0 AND r.value5 <= 0) OR 
                 (r.value2 <= 0 AND r.value3 <= 0) OR 
                 (r.value2 <= 0 AND r.value4 <= 0) OR 
                 (r.value2 <= 0 AND r.value5 <= 0) OR 
                 (r.value3 <= 0 AND r.value4 <= 0) OR 
                 (r.value3 <= 0 AND r.value5 <= 0) OR 
                 (r.value4 <= 0 AND r.value5 <= 0) THEN 
                 ROUND((CASE WHEN r.value1 > 0 THEN r.value1 ELSE 0 END + 
                       CASE WHEN r.value2 > 0 THEN r.value2 ELSE 0 END + 
                       CASE WHEN r.value3 > 0 THEN r.value3 ELSE 0 END + 
                       CASE WHEN r.value4 > 0 THEN r.value4 ELSE 0 END + 
                       CASE WHEN r.value5 > 0 THEN r.value5 ELSE 0 END) / 3, 0)
            WHEN r.value1 <= 0 OR r.value2 <= 0 OR r.value3 <= 0 OR r.value4 <= 0 OR r.value5 <= 0 THEN 
                 ROUND((r.value1 + r.value2 + r.value3 + r.value4 + r.value5 - 
                        GREATEST(r.value1, r.value2, r.value3, r.value4, r.value5) - 
                        CASE WHEN r.value1 <= 0 THEN r.value1 
                             WHEN r.value2 <= 0 THEN r.value2 
                             WHEN r.value3 <= 0 THEN r.value3 
                             WHEN r.value4 <= 0 THEN r.value4 
                             ELSE r.value5 END) / 3, 0)
            ELSE ROUND((r.value1 + r.value2 + r.value3 + r.value4 + r.value5 - 
                       GREATEST(r.value1, r.value2, r.value3, r.value4, r.value5) - 
                       (SELECT val FROM (SELECT r.value1 AS val UNION ALL SELECT r.value2 UNION ALL SELECT r.value3 UNION ALL SELECT r.value4 UNION ALL SELECT r.value5 ORDER BY val DESC LIMIT 1, 1) AS subquery)) / 3, 0)
        END AS BAo5, -- 替换为目标函数
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
        ROW_NUMBER() OVER (PARTITION BY STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') ORDER BY CASE
            WHEN (r.value1 <= 0 AND r.value2 <= 0 AND r.value3 <= 0) OR 
                 (r.value1 <= 0 AND r.value2 <= 0 AND r.value4 <= 0) OR 
                 (r.value1 <= 0 AND r.value2 <= 0 AND r.value5 <= 0) OR 
                 (r.value1 <= 0 AND r.value3 <= 0 AND r.value4 <= 0) OR 
                 (r.value1 <= 0 AND r.value3 <= 0 AND r.value5 <= 0) OR 
                 (r.value1 <= 0 AND r.value4 <= 0 AND r.value5 <= 0) OR 
                 (r.value2 <= 0 AND r.value3 <= 0 AND r.value4 <= 0) OR 
                 (r.value2 <= 0 AND r.value3 <= 0 AND r.value5 <= 0) OR 
                 (r.value2 <= 0 AND r.value4 <= 0 AND r.value5 <= 0) OR 
                 (r.value3 <= 0 AND r.value4 <= 0 AND r.value5 <= 0) THEN NULL
            WHEN (r.value1 <= 0 AND r.value2 <= 0) OR 
                 (r.value1 <= 0 AND r.value3 <= 0) OR 
                 (r.value1 <= 0 AND r.value4 <= 0) OR 
                 (r.value1 <= 0 AND r.value5 <= 0) OR 
                 (r.value2 <= 0 AND r.value3 <= 0) OR 
                 (r.value2 <= 0 AND r.value4 <= 0) OR 
                 (r.value2 <= 0 AND r.value5 <= 0) OR 
                 (r.value3 <= 0 AND r.value4 <= 0) OR 
                 (r.value3 <= 0 AND r.value5 <= 0) OR 
                 (r.value4 <= 0 AND r.value5 <= 0) THEN 
                 ROUND((CASE WHEN r.value1 > 0 THEN r.value1 ELSE 0 END + 
                       CASE WHEN r.value2 > 0 THEN r.value2 ELSE 0 END + 
                       CASE WHEN r.value3 > 0 THEN r.value3 ELSE 0 END + 
                       CASE WHEN r.value4 > 0 THEN r.value4 ELSE 0 END + 
                       CASE WHEN r.value5 > 0 THEN r.value5 ELSE 0 END) / 3, 0)
            WHEN r.value1 <= 0 OR r.value2 <= 0 OR r.value3 <= 0 OR r.value4 <= 0 OR r.value5 <= 0 THEN 
                 ROUND((r.value1 + r.value2 + r.value3 + r.value4 + r.value5 - 
                        GREATEST(r.value1, r.value2, r.value3, r.value4, r.value5) - 
                        CASE WHEN r.value1 <= 0 THEN r.value1 
                             WHEN r.value2 <= 0 THEN r.value2 
                             WHEN r.value3 <= 0 THEN r.value3 
                             WHEN r.value4 <= 0 THEN r.value4 
                             ELSE r.value5 END) / 3, 0)
            ELSE ROUND((r.value1 + r.value2 + r.value3 + r.value4 + r.value5 - 
                       GREATEST(r.value1, r.value2, r.value3, r.value4, r.value5) - 
                       (SELECT val FROM (SELECT r.value1 AS val UNION ALL SELECT r.value2 UNION ALL SELECT r.value3 UNION ALL SELECT r.value4 UNION ALL SELECT r.value5 ORDER BY val DESC LIMIT 1, 1) AS subquery)) / 3, 0)
        END) AS rn -- 替换为目标函数
    FROM
        results r
    JOIN
        competitions c ON r.competitionId = c.id
    WHERE
        r.eventId = '333' AND CASE
            WHEN (r.value1 <= 0 AND r.value2 <= 0 AND r.value3 <= 0) OR 
                 (r.value1 <= 0 AND r.value2 <= 0 AND r.value4 <= 0) OR 
                 (r.value1 <= 0 AND r.value2 <= 0 AND r.value5 <= 0) OR 
                 (r.value1 <= 0 AND r.value3 <= 0 AND r.value4 <= 0) OR 
                 (r.value1 <= 0 AND r.value3 <= 0 AND r.value5 <= 0) OR 
                 (r.value1 <= 0 AND r.value4 <= 0 AND r.value5 <= 0) OR 
                 (r.value2 <= 0 AND r.value3 <= 0 AND r.value4 <= 0) OR 
                 (r.value2 <= 0 AND r.value3 <= 0 AND r.value5 <= 0) OR 
                 (r.value2 <= 0 AND r.value4 <= 0 AND r.value5 <=
                 0) OR 
                 (r.value3 <= 0 AND r.value4 <= 0 AND r.value5 <= 0) THEN NULL
            WHEN (r.value1 <= 0 AND r.value2 <= 0) OR 
                 (r.value1 <= 0 AND r.value3 <= 0) OR 
                 (r.value1 <= 0 AND r.value4 <= 0) OR 
                 (r.value1 <= 0 AND r.value5 <= 0) OR 
                 (r.value2 <= 0 AND r.value3 <= 0) OR 
                 (r.value2 <= 0 AND r.value4 <= 0) OR 
                 (r.value2 <= 0 AND r.value5 <= 0) OR 
                 (r.value3 <= 0 AND r.value4 <= 0) OR 
                 (r.value3 <= 0 AND r.value5 <= 0) OR 
                 (r.value4 <= 0 AND r.value5 <= 0) THEN 
                 ROUND((CASE WHEN r.value1 > 0 THEN r.value1 ELSE 0 END + 
                       CASE WHEN r.value2 > 0 THEN r.value2 ELSE 0 END + 
                       CASE WHEN r.value3 > 0 THEN r.value3 ELSE 0 END + 
                       CASE WHEN r.value4 > 0 THEN r.value4 ELSE 0 END + 
                       CASE WHEN r.value5 > 0 THEN r.value5 ELSE 0 END) / 3, 0)
            WHEN r.value1 <= 0 OR r.value2 <= 0 OR r.value3 <= 0 OR r.value4 <= 0 OR r.value5 <= 0 THEN 
                 ROUND((r.value1 + r.value2 + r.value3 + r.value4 + r.value5 - 
                        GREATEST(r.value1, r.value2, r.value3, r.value4, r.value5) - 
                        CASE WHEN r.value1 <= 0 THEN r.value1 
                             WHEN r.value2 <= 0 THEN r.value2 
                             WHEN r.value3 <= 0 THEN r.value3 
                             WHEN r.value4 <= 0 THEN r.value4 
                             ELSE r.value5 END) / 3, 0)
            ELSE ROUND((r.value1 + r.value2 + r.value3 + r.value4 + r.value5 - 
                       GREATEST(r.value1, r.value2, r.value3, r.value4, r.value5) - 
                       (SELECT val FROM (SELECT r.value1 AS val UNION ALL SELECT r.value2 UNION ALL SELECT r.value3 UNION ALL SELECT r.value4 UNION ALL SELECT r.value5 ORDER BY val DESC LIMIT 1, 1) AS subquery)) / 3, 0)
        END > 0 -- 替换为目标函数
)
SELECT
    personName,
    BAo5, -- 替换为目标函数名称
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
SET @min_BAo5 = 9999999999; -- 假设一个初始的最大值 -- 替换为目标函数名称

SELECT
    NULL AS flag,
    personName,
    BAo5, -- 替换为目标函数名称
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
        BAo5, -- 替换为目标函数名称
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
        @min_BAo5 := LEAST(@min_BAo5, BAo5) AS current_min_BAo5 -- 替换为目标函数名称
    FROM
        FilteredResults
    ORDER BY
        date
) AS subquery
WHERE
    BAo5 <= current_min_BAo5
ORDER BY
    date;
