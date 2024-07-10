SELECT * -- value1, value2, value3, value4, value5
FROM Results
WHERE personId = "2019WANY36" AND eventId = "333";



-- 含date
SELECT 
    r.*,
    STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') AS date
FROM 
    Results r
JOIN 
    Competitions c ON r.competitionId = c.id
WHERE 
    r.personId = '2019WANY36'
    AND r.eventId = '333'
ORDER BY 
    date,
    FIELD(r.roundTypeId, '0', '1', 'd', '2', 'e', '3', 'g', 'f', 'b', 'c');










/*
单次成绩
用一列value输出所有value，先按日期排，然后按roundTypeId排，然后按value1,value2.value3,value4,value5排
*/
WITH AllValues AS (
    SELECT 
        r.personName,
		r.value1 AS value,
        STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') AS date,
		c.name,
        r.roundTypeId,
        '1' AS value_order,
		r.personId
    FROM 
        Results r
    JOIN 
        Competitions c ON r.competitionId = c.id
    WHERE 
        r.personId = '2019WANY36'
        AND r.eventId = '333'
        AND r.value1 != 0

    UNION ALL

    SELECT 
        r.personName,
        r.value2 AS value,
        STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') AS date,
		c.name,
        r.roundTypeId,
        '2' AS value_order,
		r.personId
    FROM 
        Results r
    JOIN 
        Competitions c ON r.competitionId = c.id
    WHERE 
        r.personId = '2019WANY36'
        AND r.eventId = '333'
        AND r.value2 != 0

    UNION ALL

    SELECT 
        r.personName,
        r.value3 AS value,
        STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') AS date,
		c.name,
        r.roundTypeId,
        '3' AS value_order,
		r.personId
    FROM 
        Results r
    JOIN 
        Competitions c ON r.competitionId = c.id
    WHERE 
        r.personId = '2019WANY36'
        AND r.eventId = '333'
        AND r.value3 != 0

    UNION ALL

    SELECT 
        r.personName,
        r.value4 AS value,
        STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') AS date,
		c.name,
        r.roundTypeId,
        '4' AS value_order,
		r.personId
    FROM 
        Results r
    JOIN 
        Competitions c ON r.competitionId = c.id
    WHERE 
        r.personId = '2019WANY36'
        AND r.eventId = '333'
        AND r.value4 != 0

    UNION ALL

    SELECT 
        r.personName,
        r.value5 AS value,
        STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') AS date,
		c.name,
        r.roundTypeId,
        '5' AS value_order,
		r.personId
    FROM 
        Results r
    JOIN 
        Competitions c ON r.competitionId = c.id
    WHERE 
        r.personId = '2019WANY36'
        AND r.eventId = '333'
        AND r.value5 != 0
)

SELECT *
FROM AllValues
ORDER BY 
    date,
    FIELD(roundTypeId, '0', '1', 'd', '2', 'e', '3', 'g', 'f', 'b', 'c'),
    value_order;
