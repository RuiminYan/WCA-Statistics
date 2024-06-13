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
    -- 可选 LIMIT 100
),
temp AS (
    SELECT
        r.competitionId,
        r.personName,
        r.personId,
        r.personCountryId,
        MAX(CASE WHEN r.roundTypeId = 'f' THEN r.average END) AS Fi,
        COUNT(r.average) AS num_averages
    FROM
        results r
    WHERE
        r.eventId = '333' AND r.personId IN (SELECT personId FROM selected_persons)
    GROUP BY
        r.competitionId, r.personName, r.personId, r.personCountryId
    HAVING
        num_averages = 1
),
Ao1R AS (
    SELECT
        competitionId,
        personName,
        personId,
        personCountryId,
        CASE
            WHEN Fi <= 0 THEN -1
            ELSE Fi
        END AS Ao1R,
        Fi
    FROM
        temp
)
SELECT
    NULL AS flag,
    Ao1R.personName,
    Ao1R.Ao1R,
    NULL as nothing,
    STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') AS date,
    c.name,
    Ao1R.Fi AS value1
    Ao1R.personId,
    Ao1R.personCountryId
FROM
    Ao1R
JOIN
    competitions c ON Ao1R.competitionId = c.id
WHERE
    Ao1R.Ao1R > 0
ORDER BY
    Ao1R.Ao1R; 

    -- 按日期排 date;
