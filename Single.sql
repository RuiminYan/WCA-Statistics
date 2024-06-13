-- 333ft (under mo3)
SELECT
    r.personName,
    r.personId,
    r.personCountryId,
    -- 计算 value1, value2, value3 中最小的正数作为 single
    CASE
        WHEN r.value1 > 0 AND (r.value1 <= r.value2 OR r.value2 <= 0) AND (r.value1 <= r.value3 OR r.value3 <= 0) THEN r.value1
        WHEN r.value2 > 0 AND (r.value2 <= r.value1 OR r.value1 <= 0) AND (r.value2 <= r.value3 OR r.value3 <= 0) THEN r.value2
        WHEN r.value3 > 0 AND (r.value3 <= r.value1 OR r.value1 <= 0) AND (r.value3 <= r.value2 OR r.value2 <= 0) THEN r.value3
        ELSE NULL
    END AS single,
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
    AND (r.value1 > 0 OR r.value2 > 0 OR r.value3 > 0)  -- 确保至少一个 value 大于0
    AND r.value4 = 0 AND r.value5 = 0
ORDER BY
    date;
