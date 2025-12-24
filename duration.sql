SELECT id AS competition_id,
       CASE
           WHEN DATEDIFF(CONCAT(year, '-', LPAD(endMonth, 2, '00'), '-', LPAD(endDay, 2, '00')), CONCAT(year, '-', LPAD(month, 2, '00'), '-', LPAD(day, 2, '00'))) + 1 <= 0
               THEN DATEDIFF(CONCAT(year + 1, '-', LPAD(endMonth, 2, '00'), '-', LPAD(endDay, 2, '00')), CONCAT(year, '-', LPAD(month, 2, '00'), '-', LPAD(day, 2, '00'))) + 1
           ELSE DATEDIFF(CONCAT(year, '-', LPAD(endMonth, 2, '00'), '-', LPAD(endDay, 2, '00')), CONCAT(year, '-', LPAD(month, 2, '00'), '-', LPAD(day, 2, '00'))) + 1
       END AS duration
FROM competitions
ORDER BY duration DESC;
