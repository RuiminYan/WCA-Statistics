-- WR
SELECT
    r.personName,
    r.personId,
    r.personCountryId,
    r.best AS single,
    r.regionalSingleRecord,
    STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') AS date,
    c.name
FROM
    results r
JOIN
    competitions c ON r.competitionId = c.id
WHERE
    r.eventId = '333' AND r.regionalSingleRecord = "WR"
ORDER BY
    date;




-- 333ft
SELECT
    r.personName,
    r.personId,
    r.personCountryId,
    -- 计算 value1, value2, value3 中最小的正数作为 single
    LEAST(
        CASE WHEN r.value1 > 0 THEN r.value1 ELSE 9999999999 END,
        CASE WHEN r.value2 > 0 THEN r.value2 ELSE 9999999999 END,
        CASE WHEN r.value3 > 0 THEN r.value3 ELSE 9999999999 END,
        CASE WHEN r.value4 > 0 THEN r.value4 ELSE 9999999999 END,
        CASE WHEN r.value5 > 0 THEN r.value5 ELSE 9999999999 END
    ) AS single,
    NULL AS nothing,
    -- 将比赛日期转换为日期格式
    STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') AS date,
    c.name
FROM
    results r
JOIN
    competitions c ON r.competitionId = c.id
WHERE
    r.eventId = '333ft'
    AND (r.value1 > 0 OR r.value2 > 0 OR r.value3 > 0 OR r.value4 > 0 OR r.value5 > 0)  -- 确保至少一个 value 大于0
HAVING
    single != 9999999999  -- 确保 single 不为极大值，排除无效记录
ORDER BY
    date;





-- 333mbo
SELECT
    r.personName,
    r.personId,
    r.personCountryId,
    r.best AS single,
    r.regionalSingleRecord,
    STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') AS date,
    c.name
FROM
    results r
JOIN
    competitions c ON r.competitionId = c.id
WHERE
    r.eventId = '333mbo'
    AND r.regionalSingleRecord = 'WR'
ORDER BY
    date;
