SELECT 
    r.personName,
    r.personId,
    r.personCountryId,
    r.average,
    STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') AS comp_date,
    c.name AS competition_name
FROM 
    wca_export.Results r
JOIN 
    wca_export.Competitions c ON r.competitionId = c.id
WHERE 
    r.eventId = '333'
    AND r.average > 0
    AND STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') < '2025-01-01'
ORDER BY 
    r.average ASC
LIMIT 100;
