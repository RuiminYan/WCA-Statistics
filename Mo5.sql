SELECT
  r.personName,
  r.personId,
  CASE 
    WHEN r.value1 <= 0 OR r.value2 <= 0 OR r.value3 <= 0 OR r.value4 <= 0 OR r.value5 <= 0 THEN -1
    ELSE ROUND((r.value1 + r.value2 + r.value3 + r.value4 + r.value5) / 5)
  END AS Mo5,
  r.value1, r.value2, r.value3, r.value4, r.value5,
  c.year,
  c.month,
  c.day,
  c.name
FROM
  Results r
JOIN
  Competitions c ON r.competitionId = c.id
WHERE
  r.eventId = '333'
HAVING
  Mo5 > 0
ORDER BY
  Mo5;
