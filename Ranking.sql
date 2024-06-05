-- Single Results
SELECT * 
FROM Results 
WHERE eventId = "333" AND best > 0
ORDER BY best
LIMIT 100;


-- Average Results
SELECT * 
FROM Results 
WHERE eventId = "333" AND average > 0
ORDER BY average
LIMIT 100;


-- Single Persons
SELECT personName, MIN(best) AS best 
FROM Results 
WHERE eventId = '333' AND best > 0 
GROUP BY personName 
ORDER BY best
LIMIT 100;


-- Average Persons
SELECT personName, MIN(average) AS average 
FROM Results 
WHERE eventId = '333' AND average > 0 
GROUP BY personName 
ORDER BY average
LIMIT 100;


-- Single Persons w/ personId
SELECT DISTINCT personName, personId, best
FROM (
    SELECT r.personName, r.personId, r.best
    FROM Results r
    JOIN (
        SELECT personName, MIN(best) AS min_best
        FROM Results
        WHERE eventId = '333' AND best > 0
        GROUP BY personName
    ) sub ON r.personName = sub.personName AND r.best = sub.min_best
    ORDER BY r.best
) AS sorted_results
ORDER BY best
LIMIT 100;


-- Average Persons w/ personId
SELECT DISTINCT personName, personId, average
FROM (
    SELECT r.personName, r.personId, r.average
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
LIMIT 100;
