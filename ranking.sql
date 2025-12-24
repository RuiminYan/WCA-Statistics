-- Single Results
SELECT * 
FROM Results 
WHERE event_id = "333" AND best > 0
ORDER BY best
LIMIT 100;


-- Average Results
SELECT * 
FROM Results 
WHERE event_id = "333" AND average > 0
ORDER BY average
LIMIT 100;


-- Single Persons
SELECT person_name, MIN(best) AS best 
FROM Results 
WHERE event_id = '333' AND best > 0 
GROUP BY person_name 
ORDER BY best
LIMIT 100;


-- Average Persons
SELECT person_name, MIN(average) AS average 
FROM Results 
WHERE event_id = '333' AND average > 0 
GROUP BY person_name 
ORDER BY average
LIMIT 100;


-- Single Persons w/ person_id
SELECT DISTINCT person_name, person_id, best
FROM (
    SELECT r.person_name, r.person_id, r.best
    FROM Results r
    JOIN (
        SELECT person_name, MIN(best) AS min_best
        FROM Results
        WHERE event_id = '333' AND best > 0
        GROUP BY person_name
    ) sub ON r.person_name = sub.person_name AND r.best = sub.min_best
    ORDER BY r.best
) AS sorted_results
ORDER BY best
LIMIT 100;


-- Average Persons w/ person_id
SELECT DISTINCT person_name, person_id, average
FROM (
    SELECT r.person_name, r.person_id, r.average
    FROM Results r
    JOIN (
        SELECT person_name, MIN(average) AS min_average
        FROM Results
        WHERE event_id = '333' AND average > 0
        GROUP BY person_name
    ) sub ON r.person_name = sub.person_name AND r.average = sub.min_average
    ORDER BY r.average
) AS sorted_results
ORDER BY average
LIMIT 100;
