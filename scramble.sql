-- 3x3 Scramble by Movecount
-- HTM
select length(scramble)-length(replace(scramble,' ',''))+1 HTM, scramble, event_id, competition_id, scramble_num, is_extra from Scrambles
where event_id in ('333', '333oh', '333ft', '333fm')
order by  HTM -- DESC

-- QTM
SELECT 
    (LENGTH(scramble) - LENGTH(REPLACE(scramble, ' ', '')) + 1) +
    (LENGTH(scramble) - LENGTH(REPLACE(scramble, '2', ''))) AS QTM,
    scramble,
    event_id,
    competition_id,
    scramble_num,
    is_extra
FROM
    Scrambles
WHERE
    event_id IN ('333', '333oh', '333ft', '333fm')
ORDER BY
    QTM;  -- DESC



-- 打乱
SELECT id, scramble
FROM wca_export.scrambles
WHERE event_id in ('333', '333bf', '333oh', '333ft', '333fm')
-- LIMIT 10000, 10000; -- 偏移量10000



-- 打乱和信息
SELECT
-- 行号 ROW_NUMBER() OVER (ORDER BY id) AS row_num,
    id,
    scramble,
    competition_id,
    event_id,
    is_extra
FROM
    wca_export.scrambles
WHERE
    event_id IN ('333', '333bf', '333oh', '333ft', '333fm')
    AND id > 5259372















