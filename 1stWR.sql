-- 1stWR Single
WITH FirstComp AS (
    SELECT 
        r.personId,
        MIN(STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d')) AS earliest_date
    FROM 
        Results r
    JOIN 
        Competitions c ON r.competitionId = c.id
    WHERE 
        r.eventId = '333'
    GROUP BY 
        r.personId
),
FirstRound AS (
    SELECT
        r.personId,
        r.personName,
        r.value1 AS first_single,
        STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') AS event_date
    FROM 
        Results r
    JOIN 
        Competitions c ON r.competitionId = c.id
    WHERE 
        r.eventId = '333'
        AND r.roundTypeId IN ('1', '0', 'd')
        AND r.value1 > 0
)
-- 连接上述两个子查询，获取每个人首次参加比赛的第一轮第一把成绩
SELECT
    fr.personName,
    fr.personId,
    fr.first_single,
    fc.earliest_date
FROM
    FirstComp fc
JOIN
    FirstRound fr ON fc.personId = fr.personId AND fc.earliest_date = fr.event_date
ORDER BY
    fr.first_single;




-- 1st WR Avg


