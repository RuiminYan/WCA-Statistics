SELECT 
    r.person_name,
    r.person_id,
    r.person_country_id,
    r.average,
    STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') AS comp_date,
    c.name AS competition_name
FROM 
    wca_export.Results r
JOIN 
    wca_export.Competitions c ON r.competition_id = c.id
WHERE 
    r.event_id = '333'
    AND r.average > 0
    AND STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') <= '2025-01-01'
ORDER BY 
    r.average ASC
LIMIT 100;





***统计席位***
SELECT COUNT(*) AS count_Yiheng
FROM (
    SELECT 
        r.person_name,
        r.person_id,
        r.person_country_id,
        r.average,
        STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') AS comp_date,
        c.name AS competition_name
    FROM wca_export.Results r
    JOIN wca_export.Competitions c ON r.competition_id = c.id
    WHERE r.event_id = '333'
      AND r.average > 0
      AND STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') <= '2024-08-25'
    ORDER BY r.average ASC
    LIMIT 100
) t
WHERE t.person_name = 'Yiheng Wang (王艺衡)';
