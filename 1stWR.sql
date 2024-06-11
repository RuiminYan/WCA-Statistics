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















