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
        MAX(CASE WHEN r.roundTypeId IN ('1', 'd') THEN r.average END) AS R1,
        MAX(CASE WHEN r.roundTypeId IN ('2', 'e') THEN r.average END) AS R2,
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
        num_averages = 3 AND R1 > 0  -- 排除 R1 为 0 的行
),
Ao3R AS (
    SELECT
        competitionId,
        personName,
        personId,
        personCountryId,
        CASE
            WHEN R1 <= 0 OR R2 <= 0 OR Fi <= 0 THEN -1
            ELSE ROUND((R1 + R2 + Fi) / 3)
        END AS Ao3R,
        R1,
        R2,
        Fi
    FROM
        temp
)
SELECT
    NULL AS flag,
    Ao3R.personName,
    Ao3R.Ao3R,
    NULL as nothing,
    STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') AS date,
    c.name,
    Ao3R.R1 AS value1,
    Ao3R.R2 AS value2,
    Ao3R.Fi AS value3,
    NULL AS nothing,
    NULL AS nothing,
    Ao3R.personId,
    Ao3R.personCountryId
FROM
    Ao3R
JOIN
    competitions c ON Ao3R.competitionId = c.id
WHERE
    Ao3R.Ao3R > 0
ORDER BY
    Ao3R.Ao3R;

    -- 按日期排 date;


-- 333mbf需手动查询
