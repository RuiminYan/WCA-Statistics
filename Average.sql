-- magic, mmagic
SELECT
    r.personName,
    r.personId,
    r.personCountryId,
    ROUND((r.value1 + r.value2 + r.value3 + r.value4 + r.value5 - 
           GREATEST(r.value1, r.value2, r.value3, r.value4, r.value5) - 
           LEAST(r.value1, r.value2, r.value3, r.value4, r.value5)) / 3, 0) AS average,
    NULL AS nothing,
    STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') AS date,
    c.name,
    r.value1,
    r.value2,
    r.value3,
    r.value4,
    r.value5
FROM
    results r
JOIN
    competitions c ON r.competitionId = c.id
WHERE
    r.eventId = 'magic'
    AND r.value4 != 0
    AND r.value5 != 0
HAVING
    -- average > 0
    ROUND((r.value1 + r.value2 + r.value3 + r.value4 + r.value5 - 
           GREATEST(r.value1, r.value2, r.value3, r.value4, r.value5) - 
           LEAST(r.value1, r.value2, r.value3, r.value4, r.value5)) / 3, 0) > 0
ORDER BY
    date;









-- 333mbf avg
SELECT
    r.personName,
    r.personId,
    r.personCountryId,
    ROUND((r.value1 + r.value2 + r.value3) / 3, 0) AS average,
    NULL AS nothing,
	STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') AS date,
    c.name,
    r.value1,
    r.value2,
    r.value3
FROM
    results r
JOIN
    competitions c ON r.competitionId = c.id
WHERE
    r.eventId = 'magic' 
    AND r.value1 > 0 
    AND r.value2 > 0 
    AND r.value3 > 0
ORDER BY
    date;
