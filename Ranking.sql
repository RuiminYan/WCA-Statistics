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
