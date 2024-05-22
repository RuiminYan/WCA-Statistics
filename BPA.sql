-- Best Possible Average
SELECT personName, countryId, competitionId, value1, value2, value3, value4, value5, average, (value1 + value2 + value3 + value4 - GREATEST(value1, value2, value3, value4))/3 AS BPA
FROM Results 
WHERE eventId = 'pyram' AND average > 0 AND value1 > 0 AND value2 > 0 AND value3 > 0 AND value4 > 0
ORDER BY BPA;
