












-- Ranking
-- Step 1: Create a temporary table
CREATE TEMPORARY TABLE TempResults AS
SELECT 
  r.personName,
  r.best,
  r.average,
  r.regionalAverageRecord,
  r.competitionId,
  r.value1, 
  r.value2, 
  r.value3, 
  r.value4, 
  r.value5,
  r.personId,
  r.personCountryId
FROM 
  Results r
WHERE 
  r.eventId = '333';

-- Step 2: Join with Competitions table and perform calculations
SELECT
  NULL AS flag,
  tr.personName,
  
  -- variance
  CASE 
    WHEN tr.value1 <= 0 OR tr.value2 <= 0 OR tr.value3 <= 0 OR tr.value4 <= 0 OR tr.value5 <= 0 THEN NULL
    ELSE ROUND((POW(tr.value1 - tr.average, 2) + POW(tr.value2 - tr.average, 2) + POW(tr.value3 - tr.average, 2) + POW(tr.value4 - tr.average, 2) + POW(tr.value5 - tr.average, 2)) / 5, 0)
  END AS variance,

  tr.regionalAverageRecord,
  STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') AS date,
  c.name,
  tr.value1, 
  tr.value2, 
  tr.value3, 
  tr.value4, 
  tr.value5,
  tr.personId,
  tr.personCountryId
FROM 
  TempResults tr
JOIN
  Competitions c ON tr.competitionId = c.id
ORDER BY
  variance IS NULL, variance;

-- Drop the temporary table
DROP TEMPORARY TABLE IF EXISTS TempResults;
