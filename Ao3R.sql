/* 

ChatGPT提示词: 见Ao4R

*/

WITH temp AS (
    SELECT
        r.competitionId,
        r.personName,
        r.personId,
        MAX(CASE WHEN r.roundTypeId IN ('1', 'd') THEN r.average END) AS R1,
        MAX(CASE WHEN r.roundTypeId IN ('2', 'e') THEN r.average END) AS R2,
        MAX(CASE WHEN r.roundTypeId = 'f' THEN r.average END) AS Fi,
        COUNT(r.average) AS num_averages
    FROM
        results r
    WHERE
        r.eventId = '333' AND r.personId = '2019WANY36'
    GROUP BY
        r.competitionId, r.personName, r.personId
    HAVING
        num_averages = 3
),
Ao3R AS (
    SELECT
        competitionId,
        personName,
        personId,
        CASE
            WHEN Fi <= 0 THEN 'DNF'
            ELSE ROUND((R1 + R2 + Fi) / 3)
        END AS Ao3R,
        R1,
        R2,
        Fi
    FROM
        temp
)
SELECT
    Ao3R.personName,
    Ao3R.personId,
    Ao3R.Ao3R,
    Ao3R.R1,
    Ao3R.R2,
    Ao3R.Fi,
    c.name
FROM
    Ao3R
JOIN
    competitions c ON Ao3R.competitionId = c.id
ORDER BY
    Ao3R.Ao3R;
