-- 3x3 Scramble by Movecount
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



-- 打乱按编号
SELECT scramble
FROM wca_export.scrambles
WHERE eventId in ('333', '333oh', '333ft', '333fm')
ORDER BY scrambleId
LIMIT 10000, 10000;



-- 打乱按编号，加入行号和其他信息
SELECT 
    @rownum := @rownum + 1 AS rn,
    competitionId,
    eventId,
    isExtra,
    scramble
FROM wca_export.scrambles, (SELECT @rownum := 0) AS r
WHERE eventId in ('333', '333oh', '333ft', '333fm')
ORDER BY scrambleId;
















