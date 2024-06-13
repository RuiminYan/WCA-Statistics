-- WR
SELECT
    r.personName,
    r.personId,
    r.personCountryId,
    r.average AS average,
    r.regionalAverageRecord,
    STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') AS date,
    c.name,
	r.value1,
	r.value2,
	r.value3,
	r.value4,
	r.value5
FROM
    results r
JOIN
    competitions c ON r.competitionId = c.id
WHERE
    r.eventId = '333ft' AND r.regionalAverageRecord = "WR"
ORDER BY
    date;


-- magic, mmagic, 333ft ao5   有错误，不再使用
SELECT
    r.personName,
    r.personId,
    r.personCountryId,
    -- 计算去掉最大值和最小值后的平均值
    CASE -- 如果value中至少有2个≤0，则average= -1
        WHEN (
            (r.value1 <= 0 AND r.value2 <= 0) OR
            (r.value1 <= 0 AND r.value3 <= 0) OR
            (r.value1 <= 0 AND r.value4 <= 0) OR
            (r.value1 <= 0 AND r.value5 <= 0) OR
            (r.value2 <= 0 AND r.value3 <= 0) OR
            (r.value2 <= 0 AND r.value4 <= 0) OR
            (r.value2 <= 0 AND r.value5 <= 0) OR
            (r.value3 <= 0 AND r.value4 <= 0) OR
            (r.value3 <= 0 AND r.value5 <= 0) OR
            (r.value4 <= 0 AND r.value5 <= 0)
        )
        THEN -1
        ELSE ROUND((r.value1 + r.value2 + r.value3 + r.value4 + r.value5 - 
                    GREATEST(r.value1, r.value2, r.value3, r.value4, r.value5) - 
                    LEAST(r.value1, r.value2, r.value3, r.value4, r.value5)) / 3, 0)
    END AS average,
    NULL AS nothing,
    -- 将比赛日期转换为日期格式
    STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') AS date,
    c.name,
    r.value1,
    r.value2,
    r.value3,
    r.value4,
    r.value5
FROM
    results r
JOIN
    competitions c ON r.competitionId = c.id
WHERE
    r.eventId = 'magic'
    AND r.value4 != 0
    AND r.value5 != 0
HAVING
    -- 应用 average > 0 的过滤条件，考虑到平均值为 -1 的情况
    CASE
        WHEN (
            (r.value1 <= 0 AND r.value2 <= 0) OR
            (r.value1 <= 0 AND r.value3 <= 0) OR
            (r.value1 <= 0 AND r.value4 <= 0) OR
            (r.value1 <= 0 AND r.value5 <= 0) OR
            (r.value2 <= 0 AND r.value3 <= 0) OR
            (r.value2 <= 0 AND r.value4 <= 0) OR
            (r.value2 <= 0 AND r.value5 <= 0) OR
            (r.value3 <= 0 AND r.value4 <= 0) OR
            (r.value3 <= 0 AND r.value5 <= 0) OR
            (r.value4 <= 0 AND r.value5 <= 0)
        )
        THEN -1
        ELSE ROUND((r.value1 + r.value2 + r.value3 + r.value4 + r.value5 - 
                    GREATEST(r.value1, r.value2, r.value3, r.value4, r.value5) - 
                    LEAST(r.value1, r.value2, r.value3, r.value4, r.value5)) / 3, 0)
    END > 0
ORDER BY
    date;









-- 333ft mo3     有错误，不再使用
SELECT
    r.personName,
    r.personId,
    r.personCountryId,
    ROUND((r.value1 + r.value2 + r.value3) / 3, 0) AS average,
    NULL AS nothing,
	STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') AS date,
    c.name,
    r.value1,
    r.value2,
    r.value3
FROM
    results r
JOIN
    competitions c ON r.competitionId = c.id
WHERE
    r.eventId = '333ft' 
    AND r.value1 > 0 
    AND r.value2 > 0 
    AND r.value3 > 0
    AND r.value4 = 0
    AND r.value5 = 0
ORDER BY
    date;






--- 333mbf mo3
SELECT
    r.personName,
    r.personId,
    r.personCountryId,
    -- 计算 DD, TTTTT, MM 的平均值，并将其合并成新的 DDTTTTTMM 格式的 average
    CONCAT(
        LPAD(ROUND((CAST(SUBSTRING(r.value1, 1, 2) AS UNSIGNED) + 
                    CAST(SUBSTRING(r.value2, 1, 2) AS UNSIGNED) + 
                    CAST(SUBSTRING(r.value3, 1, 2) AS UNSIGNED)) / 3), 2, '0'),
        LPAD(ROUND((CAST(SUBSTRING(r.value1, 3, 5) AS UNSIGNED) + 
                    CAST(SUBSTRING(r.value2, 3, 5) AS UNSIGNED) + 
                    CAST(SUBSTRING(r.value3, 3, 5) AS UNSIGNED)) / 3), 5, '0'),
        LPAD(ROUND((CAST(SUBSTRING(r.value1, -2) AS UNSIGNED) + 
                    CAST(SUBSTRING(r.value2, -2) AS UNSIGNED) + 
                    CAST(SUBSTRING(r.value3, -2) AS UNSIGNED)) / 3), 2, '0')
    ) AS average,
    NULL AS nothing,
    -- 将比赛日期转换为日期格式
    STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') AS date,
    c.name,
    r.value1,
    r.value2,
    r.value3
FROM
    results r
JOIN
    competitions c ON r.competitionId = c.id
WHERE
    r.eventId = '333mbf' 
    AND r.value1 > 0 
    AND r.value2 > 0 
    AND r.value3 > 0
GROUP BY
    r.personName, r.personId, r.personCountryId, c.year, c.month, c.day, c.name,
    r.value1, r.value2, r.value3
ORDER BY
    date;







-- 333mbo mo3. 查询后，自己算平均
SELECT
    r.personName,
    r.personId,
    r.personCountryId,
    r.best AS single,
    r.regionalSingleRecord,
    STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') AS date,
    c.name,
    r.value1,
    r.value2,
    r.value3
FROM
    results r
JOIN
    competitions c ON r.competitionId = c.id
WHERE
    r.eventId = '333mbo' AND r.value1 > 0 AND r.value2 > 0 AND r.value3 > 0 
ORDER BY
    date;
