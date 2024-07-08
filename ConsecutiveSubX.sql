/*
计算 average 列中有多少个连续低于 600 的值，并舍去 consecutive_count = 1 的行，还需要给出每一个分组的开始日期和结束日期
*/

WITH ConsecutiveSubX AS (
    SELECT 
        r.average,
        STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') AS date,
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

