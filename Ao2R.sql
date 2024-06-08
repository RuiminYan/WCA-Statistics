/* 

ChatGPT提示词: 见Ao4R

*/

WITH selected_persons AS (
    SELECT DISTINCT personName, personId, personCountryId, average
    FROM (
        SELECT r.personName, r.personId, r.personCountryId, r.average
        FROM Results r
        JOIN (
            SELECT personName, MIN(average) AS min_average
            FROM Results
            WHERE eventId = '333' AND average > 0
            GROUP BY personName
        ) sub ON r.personName = sub.personName AND r.average = sub.min_average
        ORDER BY r.average
    ) AS sorted_results
    ORDER BY average
    LIMIT 100
),
temp AS (
    SELECT
        r.competitionId,
        r.personName,
        r.personId,
        r.personCountryId,
        MAX(CASE WHEN r.roundTypeId IN ('1', 'd') THEN r.average END) AS R1,
        MAX(CASE WHEN r.roundTypeId = 'f' THEN r.average END) AS Fi,
        COUNT(r.average) AS num_averages
    FROM
        results r
    WHERE
        r.eventId = '333'
        AND r.personId IN (SELECT personId FROM selected_persons)
    GROUP BY
        r.competitionId, r.personName, r.personId, r.personCountryId
    HAVING
        num_averages = 2
),
Ao2R AS (
    SELECT
        competitionId,
        personName,
        personId,
        personCountryId,
        CASE
            WHEN Fi <= 0 THEN -1
            ELSE ROUND((R1 + Fi) / 2)
        END AS Ao2R,
        R1,
        Fi
    FROM
        temp
)
SELECT
    Ao2R.personName,
    Ao2R.personId,
    Ao2R.personCountryId,
    Ao2R.Ao2R,
    Ao2R.R1,
    Ao2R.Fi,
    c.year,
    c.month,
    c.day,
    c.name
FROM
    Ao2R
JOIN
    competitions c ON Ao2R.competitionId = c.id
WHERE
    Ao2R.Ao2R > 0
ORDER BY
    Ao2R.Ao2R; -- 按日期排 c.year, c.month, c.day;

