-- HTM
select length(scramble)-length(replace(scramble,' ',''))+1 HTM, scramble, eventId, competitionId, scrambleNum, isExtra from Scrambles
where eventId in ('333', '333oh', '333ft', '333fm')
order by  HTM -- DESC

-- QTM
SELECT 
    (LENGTH(scramble) - LENGTH(REPLACE(scramble, ' ', '')) + 1) +
    (LENGTH(scramble) - LENGTH(REPLACE(scramble, '2', ''))) AS QTM,
    scramble,
    eventId,
    competitionId,
    scrambleNum,
    isExtra
FROM
    Scrambles
WHERE
    eventId IN ('333', '333oh', '333ft', '333fm')
ORDER BY
    QTM;  -- DESC
