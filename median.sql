-- Median of Ao5
-- 第一步：删除并创建 FilteredResults 表
DROP TEMPORARY TABLE IF EXISTS FilteredResults;
CREATE TEMPORARY TABLE FilteredResults AS
WITH RankedResults AS (
    SELECT
        r.personName,
        -- 计算 median
        CASE
            -- 如果5个值都大于0，返回排序后的第3个值
            WHEN r.value1 > 0 AND r.value2 > 0 AND r.value3 > 0 AND r.value4 > 0 AND r.value5 > 0 THEN
                (SELECT val 
                 FROM (SELECT r.value1 AS val UNION ALL 
                              SELECT r.value2 UNION ALL 
                              SELECT r.value3 UNION ALL 
                              SELECT r.value4 UNION ALL 
                              SELECT r.value5) AS sub
                 ORDER BY val
                 LIMIT 1 OFFSET 2)
            -- 如果恰好1个值小于等于0，返回排序后的第4个值
            WHEN (r.value1 <= 0 AND r.value2 > 0 AND r.value3 > 0 AND r.value4 > 0 AND r.value5 > 0) OR
                 (r.value2 <= 0 AND r.value1 > 0 AND r.value3 > 0 AND r.value4 > 0 AND r.value5 > 0) OR
                 (r.value3 <= 0 AND r.value1 > 0 AND r.value2 > 0 AND r.value4 > 0 AND r.value5 > 0) OR
                 (r.value4 <= 0 AND r.value1 > 0 AND r.value2 > 0 AND r.value3 > 0 AND r.value5 > 0) OR
                 (r.value5 <= 0 AND r.value1 > 0 AND r.value2 > 0 AND r.value3 > 0 AND r.value4 > 0) THEN
                (SELECT val 
                 FROM (SELECT r.value1 AS val UNION ALL 
                              SELECT r.value2 UNION ALL 
                              SELECT r.value3 UNION ALL 
                              SELECT r.value4 UNION ALL 
                              SELECT r.value5) AS sub
                 ORDER BY val
                 LIMIT 1 OFFSET 3)
            -- 如果恰好2个值小于等于0，返回排序后的第5个值
            WHEN (r.value1 <= 0 AND r.value2 <= 0 AND r.value3 > 0 AND r.value4 > 0 AND r.value5 > 0) OR
                 (r.value1 <= 0 AND r.value3 <= 0 AND r.value2 > 0 AND r.value4 > 0 AND r.value5 > 0) OR
                 (r.value1 <= 0 AND r.value4 <= 0 AND r.value2 > 0 AND r.value3 > 0 AND r.value5 > 0) OR
                 (r.value1 <= 0 AND r.value5 <= 0 AND r.value2 > 0 AND r.value3 > 0 AND r.value4 > 0) OR
                 (r.value2 <= 0 AND r.value3 <= 0 AND r.value1 > 0 AND r.value4 > 0 AND r.value5 > 0) OR
                 (r.value2 <= 0 AND r.value4 <= 0 AND r.value1 > 0 AND r.value3 > 0 AND r.value5 > 0) OR
                 (r.value2 <= 0 AND r.value5 <= 0 AND r.value1 > 0 AND r.value3 > 0 AND r.value4 > 0) OR
                 (r.value3 <= 0 AND r.value4 <= 0 AND r.value1 > 0 AND r.value2 > 0 AND r.value5 > 0) OR
                 (r.value3 <= 0 AND r.value5 <= 0 AND r.value1 > 0 AND r.value2 > 0 AND r.value4 > 0) OR
                 (r.value4 <= 0 AND r.value5 <= 0 AND r.value1 > 0 AND r.value2 > 0 AND r.value3 > 0) THEN
                (SELECT val 
                 FROM (SELECT r.value1 AS val UNION ALL 
                              SELECT r.value2 UNION ALL 
                              SELECT r.value3 UNION ALL 
                              SELECT r.value4 UNION ALL 
                              SELECT r.value5) AS sub
                 ORDER BY val
                 LIMIT 1 OFFSET 4)
            -- 其他情况，返回 NULL
            ELSE NULL
        END AS median,
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
                -- 如果5个值都大于0，返回排序后的第3个值
                WHEN r.value1 > 0 AND r.value2 > 0 AND r.value3 > 0 AND r.value4 > 0 AND r.value5 > 0 THEN
                    (SELECT val 
                     FROM (SELECT r.value1 AS val UNION ALL 
                                  SELECT r.value2 UNION ALL 
                                  SELECT r.value3 UNION ALL 
                                  SELECT r.value4 UNION ALL 
                                  SELECT r.value5) AS sub
                     ORDER BY val
                     LIMIT 1 OFFSET 2)
                -- 如果恰好1个值小于等于0，返回排序后的第4个值
                WHEN (r.value1 <= 0 AND r.value2 > 0 AND r.value3 > 0 AND r.value4 > 0 AND r.value5 > 0) OR
                     (r.value2 <= 0 AND r.value1 > 0 AND r.value3 > 0 AND r.value4 > 0 AND r.value5 > 0) OR
                     (r.value3 <= 0 AND r.value1 > 0 AND r.value2 > 0 AND r.value4 > 0 AND r.value5 > 0) OR
                     (r.value4 <= 0 AND r.value1 > 0 AND r.value2 > 0 AND r.value3 > 0 AND r.value5 > 0) OR
                     (r.value5 <= 0 AND r.value1 > 0 AND r.value2 > 0 AND r.value3 > 0 AND r.value4 > 0) THEN
                    (SELECT val 
                     FROM (SELECT r.value1 AS val UNION ALL 
                                  SELECT r.value2 UNION ALL 
                                  SELECT r.value3 UNION ALL 
                                  SELECT r.value4 UNION ALL 
                                  SELECT r.value5) AS sub
                     ORDER BY val
                     LIMIT 1 OFFSET 3)
                -- 如果恰好2个值小于等于0，返回排序后的第5个值
                WHEN (r.value1 <= 0 AND r.value2 <= 0 AND r.value3 > 0 AND r.value4 > 0 AND r.value5 > 0) OR
                     (r.value1 <= 0 AND r.value3 <= 0 AND r.value2 > 0 AND r.value4 > 0 AND r.value5 > 0) OR
                     (r.value1 <= 0 AND r.value4 <= 0 AND r.value2 > 0 AND r.value3 > 0 AND r.value5 > 0) OR
                     (r.value1 <= 0 AND r.value5 <= 0 AND r.value2 > 0 AND r.value3 > 0 AND r.value4 > 0) OR
                     (r.value2 <= 0 AND r.value3 <= 0 AND r.value1 > 0 AND r.value4 > 0 AND r.value5 > 0) OR
                     (r.value2 <= 0 AND r.value4 <= 0 AND r.value1 > 0 AND r.value3 > 0 AND r.value5 > 0) OR
                     (r.value2 <= 0 AND r.value5 <= 0 AND r.value1 > 0 AND r.value3 > 0 AND r.value4 > 0) OR
                     (r.value3 <= 0 AND r.value4 <= 0 AND r.value1 > 0 AND r.value2 > 0 AND r.value5 > 0) OR
                     (r.value3 <= 0 AND r.value5 <= 0 AND r.value1 > 0 AND r.value2 > 0 AND r.value4 > 0) OR
                     (r.value4 <= 0 AND r.value5 <= 0 AND r.value1 > 0 AND r.value2 > 0 AND r.value3 > 0) THEN
                    (SELECT val 
                     FROM (SELECT r.value1 AS val UNION ALL 
                                  SELECT r.value2 UNION ALL 
                                  SELECT r.value3 UNION ALL 
                                  SELECT r.value4 UNION ALL 
                                  SELECT r.value5) AS sub
                     ORDER BY val
                     LIMIT 1 OFFSET 4)
                -- 其他情况，返回 NULL
                ELSE NULL
            END
        ) AS rn
    FROM
        results r
    JOIN
        competitions c ON r.competitionId = c.id
    WHERE
        r.eventId = '333' AND
        CASE
            -- 如果5个值都大于0，返回排序后的第3个值
            WHEN r.value1 > 0 AND r.value2 > 0 AND r.value3 > 0 AND r.value4 > 0 AND r.value5 > 0 THEN
                (SELECT val 
                 FROM (SELECT r.value1 AS val UNION ALL 
                              SELECT r.value2 UNION ALL 
                              SELECT r.value3 UNION ALL 
                              SELECT r.value4 UNION ALL 
                              SELECT r.value5) AS sub
                 ORDER BY val
                 LIMIT 1 OFFSET 2)
            -- 如果恰好1个值小于等于0，返回排序后的第4个值
            WHEN (r.value1 <= 0 AND r.value2 > 0 AND r.value3 > 0 AND r.value4 > 0 AND r.value5 > 0) OR
                 (r.value2 <= 0 AND r.value1 > 0 AND r.value3 > 0 AND r.value4 > 0 AND r.value5 > 0) OR
                 (r.value3 <= 0 AND r.value1 > 0 AND r.value2 > 0 AND r.value4 > 0 AND r.value5 > 0) OR
                 (r.value4 <= 0 AND r.value1 > 0 AND r.value2 > 0 AND r.value3 > 0 AND r.value5 > 0) OR
                 (r.value5 <= 0 AND r.value1 > 0 AND r.value2 > 0 AND r.value3 > 0 AND r.value4 > 0) THEN
                (SELECT val 
                 FROM (SELECT r.value1 AS val UNION ALL 
                              SELECT r.value2 UNION ALL 
                              SELECT r.value3 UNION ALL 
                              SELECT r.value4 UNION ALL 
                              SELECT r.value5) AS sub
                 ORDER BY val
                 LIMIT 1 OFFSET 3)
            -- 如果恰好2个值小于等于0，返回排序后的第5个值
            WHEN (r.value1 <= 0 AND r.value2 <= 0 AND r.value3 > 0 AND r.value4 > 0 AND r.value5 > 0) OR
                 (r.value1 <= 0 AND r.value3 <= 0 AND r.value2 > 0 AND r.value4 > 0 AND r.value5 > 0) OR
                 (r.value1 <= 0 AND r.value4 <= 0 AND r.value2 > 0 AND r.value3 > 0 AND r.value5 > 0) OR
                 (r.value1 <= 0 AND r.value5 <= 0 AND r.value2 > 0 AND r.value3 > 0 AND r.value4 > 0) OR
                 (r.value2 <= 0 AND r.value3 <= 0 AND r.value1 > 0 AND r.value4 > 0 AND r.value5 > 0) OR
                 (r.value2 <= 0 AND r.value4 <= 0 AND r.value1 > 0 AND r.value3 > 0 AND r.value5 > 0) OR
                 (r.value2 <= 0 AND r.value5 <= 0 AND r.value1 > 0 AND r.value3 > 0 AND r.value4 > 0) OR
                 (r.value3 <= 0 AND r.value4 <= 0 AND r.value1 > 0 AND r.value2 > 0 AND r.value5 > 0) OR
                 (r.value3 <= 0 AND r.value5 <= 0 AND r.value1 > 0 AND r.value2 > 0 AND r.value4 > 0) OR
                 (r.value4 <= 0 AND r.value5 <= 0 AND r.value1 > 0 AND r.value2 > 0 AND r.value3 > 0) THEN
                (SELECT val 
                 FROM (SELECT r.value1 AS val UNION ALL 
                              SELECT r.value2 UNION ALL 
                              SELECT r.value3 UNION ALL 
                              SELECT r.value4 UNION ALL 
                              SELECT r.value5) AS sub
                 ORDER BY val
                 LIMIT 1 OFFSET 4)
            -- 其他情况，返回 NULL
            ELSE NULL
        END > 0
)
SELECT
    personName,
    median,
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
SET @min_median = 9999999999; -- 假设一个初始的最大值

SELECT
    personName,
    median,
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
        median,
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
        @min_median := LEAST(@min_median, median) AS current_min_median
    FROM
        FilteredResults
    ORDER BY
        date
) AS subquery
WHERE
    median <= current_min_median
ORDER BY
    date;



















-- Median of Mo3
-- 第一步：删除并创建 FilteredResults 表
DROP TEMPORARY TABLE IF EXISTS FilteredResults;
CREATE TEMPORARY TABLE FilteredResults AS
WITH RankedResults AS (
    SELECT
        r.personName,
        -- 计算中位数
        CASE
            -- 如果3个值都大于0，返回排序后的第2个值
            WHEN r.value1 > 0 AND r.value2 > 0 AND r.value3 > 0 THEN
                (SELECT val 
                 FROM (SELECT r.value1 AS val UNION ALL 
                              SELECT r.value2 UNION ALL 
                              SELECT r.value3) AS sub
                 ORDER BY val
                 LIMIT 1 OFFSET 1)
            -- 如果恰好1个值小于等于0，返回排序后的最大值
            WHEN (r.value1 <= 0 AND r.value2 > 0 AND r.value3 > 0) OR
                 (r.value2 <= 0 AND r.value1 > 0 AND r.value3 > 0) OR
                 (r.value3 <= 0 AND r.value1 > 0 AND r.value2 > 0) THEN
                GREATEST(r.value1, r.value2, r.value3)
            -- 如果恰好2个值小于等于0，返回唯一大于0的值
            WHEN (r.value1 > 0 AND r.value2 <= 0 AND r.value3 <= 0) OR
                 (r.value1 <= 0 AND r.value2 > 0 AND r.value3 <= 0) OR
                 (r.value1 <= 0 AND r.value2 <= 0 AND r.value3 > 0) THEN
                CASE
                    WHEN r.value1 > 0 THEN r.value1
                    WHEN r.value2 > 0 THEN r.value2
                    ELSE r.value3
                END
            -- 其他情况，返回 NULL
            ELSE NULL
        END AS median,
        r.value1,
        r.value2,
        r.value3,
        r.personId,
        r.personCountryId,
        c.name,
        STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') AS date,
        r.regionalAverageRecord,
        ROW_NUMBER() OVER (PARTITION BY STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') ORDER BY 
            CASE
                -- 如果3个值都大于0，返回排序后的第2个值
                WHEN r.value1 > 0 AND r.value2 > 0 AND r.value3 > 0 THEN
                    (SELECT val 
                     FROM (SELECT r.value1 AS val UNION ALL 
                                  SELECT r.value2 UNION ALL 
                                  SELECT r.value3) AS sub
                     ORDER BY val
                     LIMIT 1 OFFSET 1)
                -- 如果恰好1个值小于等于0，返回排序后的最大值
                WHEN (r.value1 <= 0 AND r.value2 > 0 AND r.value3 > 0) OR
                     (r.value2 <= 0 AND r.value1 > 0 AND r.value3 > 0) OR
                     (r.value3 <= 0 AND r.value1 > 0 AND r.value2 > 0) THEN
                    GREATEST(r.value1, r.value2, r.value3)
                -- 如果恰好2个值小于等于0，返回唯一大于0的值
                WHEN (r.value1 > 0 AND r.value2 <= 0 AND r.value3 <= 0) OR
                     (r.value1 <= 0 AND r.value2 > 0 AND r.value3 <= 0) OR
                     (r.value1 <= 0 AND r.value2 <= 0 AND r.value3 > 0) THEN
                    CASE
                        WHEN r.value1 > 0 THEN r.value1
                        WHEN r.value2 > 0 THEN r.value2
                        ELSE r.value3
                    END
                -- 其他情况，返回 NULL
                ELSE NULL
            END
        ) AS rn
    FROM
        results r
    JOIN
        competitions c ON r.competitionId = c.id
    WHERE
        r.eventId = '666' AND
        CASE
            -- 如果3个值都大于0，返回排序后的第2个值
            WHEN r.value1 > 0 AND r.value2 > 0 AND r.value3 > 0 THEN
                (SELECT val 
                 FROM (SELECT r.value1 AS val UNION ALL 
                              SELECT r.value2 UNION ALL 
                              SELECT r.value3) AS sub
                 ORDER BY val
                 LIMIT 1 OFFSET 1)
            -- 如果恰好1个值小于等于0，返回排序后的最大值
            WHEN (r.value1 <= 0 AND r.value2 > 0 AND r.value3 > 0) OR
                 (r.value2 <= 0 AND r.value1 > 0 AND r.value3 > 0) OR
                 (r.value3 <= 0 AND r.value1 > 0 AND r.value2 > 0) THEN
                GREATEST(r.value1, r.value2, r.value3)
            -- 如果恰好2个值小于等于0，返回唯一大于0的值
            WHEN (r.value1 > 0 AND r.value2 <= 0 AND r.value3 <= 0) OR
                 (r.value1 <= 0 AND r.value2 > 0 AND r.value3 <= 0) OR
                 (r.value1 <= 0 AND r.value2 <= 0 AND r.value3 > 0) THEN
                CASE
                    WHEN r.value1 > 0 THEN r.value1
                    WHEN r.value2 > 0 THEN r.value2
                    ELSE r.value3
                END
            -- 其他情况，返回 NULL
            ELSE NULL
        END > 0
)
SELECT
    personName,
    median,
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
SET @min_median = 9999999999; -- 假设一个初始的最大值

SELECT
    personName,
    median,
    regionalAverageRecord,
    date,
    name,
    value1,
    value2,
    value3,
    personId,
    personCountryId
FROM (
    SELECT
        personName,
        median,
        regionalAverageRecord,
        date,
        name,
        value1,
        value2,
        value3,
        personId,
        personCountryId,
        @min_median := LEAST(@min_median, median) AS current_min_median
    FROM
        FilteredResults
    ORDER BY
        date
) AS subquery
WHERE
    median <= current_min_median
ORDER BY
    date;

