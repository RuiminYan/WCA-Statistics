-- 1stWR Single
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
FirstRound1 AS (
    SELECT
        r.personId,
        r.personName,
        r.personCountryId,
        r.value1 AS firstSingle,
        r.regionalSingleRecord,
        STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') AS event_date,
        c.name
    FROM 
        Results r
    JOIN 
        Competitions c ON r.competitionId = c.id
    WHERE 
        r.eventId = '333'
        AND r.roundTypeId IN ('1', '0', 'd')
        AND r.value1 > 0
),
FirstRound2 AS (
    SELECT
        r.personId,
        r.personName,
        r.personCountryId,
        r.value1 AS firstSingle,
        r.regionalSingleRecord,
        STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') AS event_date,
        c.name
    FROM 
        Results r
    JOIN 
        Competitions c ON r.competitionId = c.id
    WHERE 
        r.eventId = '333'
        AND r.roundTypeId IN ('f', 'b', 'c')
        AND r.value1 > 0
)

SELECT
    fr.personName,
    fr.personId,
    fr.personCountryId,
    fr.firstSingle,
    fr.regionalSingleRecord,
    fc.earliest_date AS date,
    fr.name
FROM
    FirstComp fc
JOIN
    (
        SELECT * FROM FirstRound1
        UNION ALL
        SELECT * FROM FirstRound2
        WHERE personId NOT IN (SELECT personId FROM FirstRound1)
    ) fr ON fc.personId = fr.personId AND fc.earliest_date = fr.event_date
ORDER BY
    fr.firstSingle;

-- 按日期排 fc.earliest_date;











-- 1stWR Average
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
FirstRound1 AS (
    SELECT
        r.personId,
        r.personName,
        r.personCountryId,
        r.average AS firstAvg,
        r.regionalAverageRecord,
        STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') AS event_date,
        c.name
    FROM 
        Results r
    JOIN 
        Competitions c ON r.competitionId = c.id
    WHERE 
        r.eventId = '333'
        AND r.roundTypeId IN ('1', '0', 'd')
        AND r.average > 0
),
FirstRound2 AS (
    SELECT
        r.personId,
        r.personName,
        r.personCountryId,
        r.average AS firstAvg,
        r.regionalAverageRecord,
        STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') AS event_date,
        c.name
    FROM 
        Results r
    JOIN 
        Competitions c ON r.competitionId = c.id
    WHERE 
        r.eventId = '333'
        AND r.roundTypeId IN ('f', 'b', 'c')
        AND r.average > 0
)

SELECT
    fr.personName,
    fr.personId,
    fr.personCountryId,
    fr.firstAvg,
    fr.regionalAverageRecord,
    fc.earliest_date AS date,
    fr.name
FROM
    FirstComp fc
JOIN
    (
        SELECT * FROM FirstRound1
        UNION ALL
        SELECT * FROM FirstRound2
        WHERE personId NOT IN (SELECT personId FROM FirstRound1)
    ) fr ON fc.personId = fr.personId AND fc.earliest_date = fr.event_date
ORDER BY
    fr.firstAvg;

-- 按日期排 fc.earliest_date;













-- MBLD 1st WR Avg
WITH first_competition_dates AS (
    SELECT 
        r.personId, 
        MIN(STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d')) AS earliest_date
    FROM 
        results r
    JOIN 
        competitions c ON r.competitionId = c.id
    WHERE 
        r.eventId = '333mbf'
    GROUP BY 
        r.personId
),
values_with_parts1 AS (
    SELECT
        r.personName,
        r.personId,
        r.personCountryId,
        c.year,
        c.month,
        c.day,
        c.name,
        r.value1,
        r.value2,
        r.value3,
        r.regionalAverageRecord,
        SUBSTRING(r.value1, 1, 2) AS dd1, SUBSTRING(r.value1, 3, 5) AS ttttt1, SUBSTRING(r.value1, 8, 2) AS mm1,
        SUBSTRING(r.value2, 1, 2) AS dd2, SUBSTRING(r.value2, 3, 5) AS ttttt2, SUBSTRING(r.value2, 8, 2) AS mm2,
        SUBSTRING(r.value3, 1, 2) AS dd3, SUBSTRING(r.value3, 3, 5) AS ttttt3, SUBSTRING(r.value3, 8, 2) AS mm3
    FROM
        results r
    JOIN
        competitions c ON r.competitionId = c.id
    JOIN
        first_competition_dates fcd ON r.personId = fcd.personId AND STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') = fcd.earliest_date
    WHERE
        r.eventId = '333mbf' AND r.roundTypeId IN ('1', '0', 'd') AND r.value1 > 0 AND r.value2 > 0 AND r.value3 > 0
),
values_with_parts2 AS (
    SELECT
        r.personName,
        r.personId,
        r.personCountryId,
        c.year,
        c.month,
        c.day,
        c.name,
        r.value1,
        r.value2,
        r.value3,
        r.regionalAverageRecord,
        SUBSTRING(r.value1, 1, 2) AS dd1, SUBSTRING(r.value1, 3, 5) AS ttttt1, SUBSTRING(r.value1, 8, 2) AS mm1,
        SUBSTRING(r.value2, 1, 2) AS dd2, SUBSTRING(r.value2, 3, 5) AS ttttt2, SUBSTRING(r.value2, 8, 2) AS mm2,
        SUBSTRING(r.value3, 1, 2) AS dd3, SUBSTRING(r.value3, 3, 5) AS ttttt3, SUBSTRING(r.value3, 8, 2) AS mm3
    FROM
        results r
    JOIN
        competitions c ON r.competitionId = c.id
    JOIN
        first_competition_dates fcd ON r.personId = fcd.personId AND STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') = fcd.earliest_date
    WHERE
        r.eventId = '333mbf' AND r.roundTypeId IN ('f', 'b', 'c') AND r.value1 > 0 AND r.value2 > 0 AND r.value3 > 0
),
average_values AS (
    SELECT
        personName,
        personId,
        personCountryId,
        CONCAT(year, '-', LPAD(month, 2, '0'), '-', LPAD(day, 2, '0')) AS date,
        name,
        value1,
        value2,
        value3,
        regionalAverageRecord,
        ROUND((CAST(dd1 AS UNSIGNED) + CAST(dd2 AS UNSIGNED) + CAST(dd3 AS UNSIGNED)) / 3) AS avg_dd,
        ROUND((CAST(ttttt1 AS UNSIGNED) + CAST(ttttt2 AS UNSIGNED) + CAST(ttttt3 AS UNSIGNED)) / 3) AS avg_ttttt,
        ROUND((CAST(mm1 AS UNSIGNED) + CAST(mm2 AS UNSIGNED) + CAST(mm3 AS UNSIGNED)) / 3) AS avg_mm
    FROM
        (SELECT * FROM values_with_parts1
         UNION ALL
         SELECT * FROM values_with_parts2
         WHERE personId NOT IN (SELECT personId FROM values_with_parts1)
        ) AS combined_values
)
SELECT
    personName,
    personId,
    personCountryId,
    CONCAT(LPAD(avg_dd, 2, '0'), LPAD(avg_ttttt, 5, '0'), LPAD(avg_mm, 2, '0')) AS firstAvg,
    regionalAverageRecord,
    date,
    name,
    value1,
    value2,
    value3
FROM
    average_values
ORDER BY
    date;

