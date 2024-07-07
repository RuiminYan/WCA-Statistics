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
    r.personId = "2019WANY36" 
    AND r.eventId = "333";
