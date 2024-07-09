/*
计算 average 列中有多少个连续低于 600 的值，并舍去 consecutive_count = 1 的行，还需要给出每一个分组的开始日期和结束日期
*/

WITH ConsecutiveSubX AS (
    SELECT 
        r.average,
        STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') AS date,
        c.name,
        CASE 
            WHEN r.average < 600 AND r.average > 0 THEN 1
            ELSE 0
        END AS is_sub_X,
        ROW_NUMBER() OVER (ORDER BY STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d')) AS row_num
    FROM 
        Results r
    JOIN 
        Competitions c ON r.competitionId = c.id
    WHERE 
        r.personId = '2019WANY36'
        AND r.eventId = '333'
),
GroupedSubX AS (
    SELECT 
        average,
        date,
        name,
        is_sub_X,
        row_num,
        row_num - ROW_NUMBER() OVER (PARTITION BY is_sub_X ORDER BY row_num) AS group_num
    FROM 
        ConsecutiveSubX
),
CountSubXGroups AS (
    SELECT 
        group_num,
        MIN(date) AS start_date,
        MAX(date) AS end_date,
        COUNT(*) AS consecutive_count
    FROM 
        GroupedSubX
    WHERE 
        is_sub_X = 1
    GROUP BY 
        group_num
    HAVING 
        COUNT(*) > 1
)
SELECT DISTINCT
    cg.consecutive_count,
    cg.start_date,
    csx1.name AS start_competition,
    cg.end_date,
    csx2.name AS end_competition
FROM 
    CountSubXGroups cg
JOIN 
    GroupedSubX csx1 ON cg.start_date = csx1.date AND cg.group_num = csx1.group_num
JOIN 
    GroupedSubX csx2 ON cg.end_date = csx2.date AND cg.group_num = csx2.group_num;






















/*
计算 value 列中有多少个连续低于 600 的值，并舍去 consecutive_count = 1 的行
*/
WITH AllValues AS (
    SELECT 
        r.personName,
        r.value1 AS value,
        STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') AS date,
        c.name,
        r.roundTypeId,
        '1' AS value_order,
        r.personId
    FROM 
        Results r
    JOIN 
        Competitions c ON r.competitionId = c.id
    WHERE 
        r.personId = '2019WANY36'
        AND r.eventId = '333'
        AND r.value1 != 0

    UNION ALL

    SELECT 
        r.personName,
        r.value2 AS value,
        STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') AS date,
        c.name,
        r.roundTypeId,
        '2' AS value_order,
        r.personId
    FROM 
        Results r
    JOIN 
        Competitions c ON r.competitionId = c.id
    WHERE 
        r.personId = '2019WANY36'
        AND r.eventId = '333'
        AND r.value2 != 0

    UNION ALL

    SELECT 
        r.personName,
        r.value3 AS value,
        STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') AS date,
        c.name,
        r.roundTypeId,
        '3' AS value_order,
        r.personId
    FROM 
        Results r
    JOIN 
        Competitions c ON r.competitionId = c.id
    WHERE 
        r.personId = '2019WANY36'
        AND r.eventId = '333'
        AND r.value3 != 0

    UNION ALL

    SELECT 
        r.personName,
        r.value4 AS value,
        STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') AS date,
        c.name,
        r.roundTypeId,
        '4' AS value_order,
        r.personId
    FROM 
        Results r
    JOIN 
        Competitions c ON r.competitionId = c.id
    WHERE 
        r.personId = '2019WANY36'
        AND r.eventId = '333'
        AND r.value4 != 0

    UNION ALL

    SELECT 
        r.personName,
        r.value5 AS value,
        STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') AS date,
        c.name,
        r.roundTypeId,
        '5' AS value_order,
        r.personId
    FROM 
        Results r
    JOIN 
        Competitions c ON r.competitionId = c.id
    WHERE 
        r.personId = '2019WANY36'
        AND r.eventId = '333'
        AND r.value5 != 0
),
ConsecutiveSubX AS (
    SELECT 
        value,
        date,
        CASE 
            WHEN value < 500 THEN 1
            ELSE 0
        END AS is_sub_X,
        ROW_NUMBER() OVER (ORDER BY date, FIELD(roundTypeId, '0', '1', 'd', '2', 'e', '3', 'g', 'f', 'b', 'c'), value_order) AS row_num
    FROM 
        AllValues
),
GroupedSubX AS (
    SELECT 
        value,
        date,
        is_sub_X,
        row_num,
        row_num - ROW_NUMBER() OVER (PARTITION BY is_sub_X ORDER BY row_num) AS group_num
    FROM 
        ConsecutiveSubX
),
CountSubXGroups AS (
    SELECT 
        group_num,
        MIN(date) AS start_date,
        MAX(date) AS end_date,
        COUNT(*) AS consecutive_count
    FROM 
        GroupedSubX
    WHERE 
        is_sub_X = 1
    GROUP BY 
        group_num
    HAVING 
        COUNT(*) > 1
)
SELECT 
    consecutive_count,
    start_date,
    end_date
FROM 
    CountSubXGroups;

