SELECT
  CASE 
    WHEN value1 <= 0 OR value2 <= 0 OR value3 <= 0 OR value4 <= 0 OR value5 <= 0 THEN -1
    ELSE ROUND((value1 + value2 + value3 + value4 + value5) / 5)
  END AS Mo5,
  value1, value2, value3, value4, value5
FROM
  Results
WHERE
  personId = '2019WANY36' AND eventId = '333';
