新人WR
新人单次WR
ChatGPT提示词
我在用MySQL Workbench,
有表格competitions，列名有：id, year, month, day. 其中year, month, day表示比赛的年月日。
有表格results，列名有：competitionId, eventId, personName, personId, best. 其中year, month, day表示比赛的年月日。
现在，我希望eventId固定为skewb, best都只取正数，对于每一个personId, 在competition日期最早的competition (注意日期如何比较大小) 下，取所有 best的最小值，记为firstCompSingle。
输出的列有personName，personId，firstCompSingle, 按照firstCompSingle从小到大排序

-- 创建一个派生表来存储每个personId最早的比赛日期
WITH first_competition_dates AS (
    SELECT 
        r.personId, 
        MIN(STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d')) AS earliest_date
    FROM 
        results r
    JOIN 
        competitions c ON r.competitionId = c.id
    WHERE 
        r.eventId = '333' AND r.best > 0
    GROUP BY 
        r.personId
)

SELECT
    r.personName,
    r.personId,
    MIN(r.best) AS firstCompSingle
FROM
    results r
JOIN
    competitions c ON r.competitionId = c.id
JOIN
    first_competition_dates fcd ON r.personId = fcd.personId AND STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') = fcd.earliest_date
WHERE
    r.eventId = '333' AND r.best > 0
GROUP BY
    r.personName, r.personId
ORDER BY
    firstCompSingle
LIMIT 10;

新人平均WR
-- 创建一个派生表来存储每个personId最早的比赛日期
WITH first_competition_dates AS (
    SELECT 
        r.personId, 
        MIN(STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d')) AS earliest_date
    FROM 
        results r
    JOIN 
        competitions c ON r.competitionId = c.id
    WHERE 
        r.eventId = 'skewb' AND r.average > 0
    GROUP BY 
        r.personId
)

SELECT
    r.personName,
    r.personId,
    MIN(r.average) AS firstCompAvg
FROM
    results r
JOIN
    competitions c ON r.competitionId = c.id
JOIN
    first_competition_dates fcd ON r.personId = fcd.personId AND STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') = fcd.earliest_date
WHERE
    r.eventId = 'skewb' AND r.average > 0
GROUP BY
    r.personName, r.personId
ORDER BY
    firstCompAvg
LIMIT 10;
