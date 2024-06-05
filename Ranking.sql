-- Results
SELECT * 
FROM Results 
WHERE eventId = "333" AND best > 0
ORDER BY best
LIMIT 100;

-- Persons
SELECT personName, MIN(best) AS best 
FROM Results 
WHERE eventId = '333' AND best > 0 
GROUP BY personName 
ORDER BY best
LIMIT 100;

-- Persons w/ personId
SELECT r.personName, r.personId, r.best
FROM Results r
JOIN (
    SELECT personName, MIN(best) AS min_best
    FROM Results
    WHERE eventId = '333' AND best > 0
    GROUP BY personName
) sub ON r.personName = sub.personName AND r.best = sub.min_best
ORDER BY r.best
LIMIT 100;
