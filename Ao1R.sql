/* 

ChatGPT提示词: 见Ao4R

*/

WITH selected_persons AS (
    SELECT r.personId
    FROM Results r
    JOIN (
        SELECT personName, MIN(best) AS min_best
        FROM Results
        WHERE eventId = '333' AND best > 0
        GROUP BY personName
    ) sub ON r.personName = sub.personName AND r.best = sub.min_best
    ORDER BY r.best
    LIMIT 100
),
temp AS (
    SELECT
        r.competitionId,
        r.personName,
        r.personId,
        MAX(CASE WHEN r.roundTypeId = 'f' THEN r.average END) AS Fi,
        COUNT(r.average) AS num_averages
    FROM
        results r
    WHERE
        r.eventId = '333' AND r.personId IN (SELECT personId FROM selected_persons)
    GROUP BY
        r.competitionId, r.personName, r.personId
    HAVING
        num_averages = 1
),
Ao1R AS (
    SELECT
        competitionId,
        personName,
        personId,
        CASE
            WHEN Fi <= 0 THEN -1
            ELSE Fi
        END AS Ao1R,
        Fi
    FROM
        temp
)
SELECT
    Ao1R.personName,
    Ao1R.personId,
    Ao1R.Ao1R,
    Ao1R.Fi,
    c.year,
    c.month,
    c.day,
    c.name
FROM
    Ao1R
JOIN
    competitions c ON Ao1R.competitionId = c.id
WHERE
    Ao1R.Ao1R  > 0
ORDER BY
    Ao1R.Ao1R; -- 按日期排 c.year, c.month, c.day;
