/* 新人单次 Newcomer World Record
希望eventId固定为333, best都只取正数，对于每一个personId, 在competition日期最早的competition (注意日期如何比较大小) 下，取所有 best的最小值，记为firstCompSingle。
输出的列有personName，personId，firstCompSingle, 按照firstCompSingle从小到大排序
*/

-- 创建一个派生表来存储每个personId最早的比赛日期
WITH first_competition_dates AS (
    SELECT 
        r.personId, 
        MIN(STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d')) AS earliest_date
    FROM 
        results r
    JOIN 
        competitions c ON r.competitionId = c.id
    WHERE 
        r.eventId = '333'
    GROUP BY 
        r.personId
)

-- 获取首次参加比赛的第一轮成绩
SELECT
    r.personName,
    r.personId,
    r.personCountryId,
    MIN(r.best) AS firstCompSingle,
    r.regionalSingleRecord,
    CONCAT(c.year, '-', LPAD(c.month, 2, '0'), '-', LPAD(c.day, 2, '0')) AS competition_date,
    c.name
FROM
    results r
JOIN
    competitions c ON r.competitionId = c.id
JOIN
    first_competition_dates fcd ON r.personId = fcd.personId 
    AND STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') = fcd.earliest_date
WHERE
    r.eventId = '333' AND r.best > 0
GROUP BY
    r.personName, r.personId, r.personCountryId, c.year, c.month, c.day, c.name, r.regionalSingleRecord
ORDER BY
    firstCompSingle;

-- 按日期排 date;












-- 新人平均
-- 创建一个派生表来存储每个personId最早的比赛日期
WITH first_competition_dates AS (
    SELECT 
        r.personId, 
        MIN(STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d')) AS earliest_date
    FROM 
        results r
    JOIN 
        competitions c ON r.competitionId = c.id
    WHERE 
        r.eventId = '333'
    GROUP BY 
        r.personId
)

SELECT
    r.personName,
    r.personId,
    r.personCountryId,
    MIN(r.average) AS firstCompAvg,
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
JOIN
    first_competition_dates fcd ON r.personId = fcd.personId AND STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') = fcd.earliest_date
WHERE
    r.eventId = '333' AND r.average > 0
GROUP BY
    r.personName, r.personId, r.personCountryId, r.regionalAverageRecord, date, c.name, r.value1, r.value2, r.value3, r.value4, r.value5
ORDER BY
    firstCompAvg;

-- 按日期排 date;













-- 新人多盲平均
WITH first_competition_dates AS (
    SELECT 
        r.personId, 
        MIN(STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d')) AS earliest_date
    FROM 
        results r
    JOIN 
        competitions c ON r.competitionId = c.id
    WHERE 
        r.eventId = '333mbo'
    GROUP BY 
        r.personId
),
converted_values AS (
    SELECT
        r.personName,
        r.personId,
        r.personCountryId,
        c.year,
        c.month,
        c.day,
        c.name,
        CASE 
            WHEN LENGTH(r.value1) = 9 THEN CONCAT('1', LPAD(CAST(SUBSTRING(r.value1, 1, 2) AS UNSIGNED) - CAST(SUBSTRING(r.value1, 8, 2) AS UNSIGNED), 2, '0'), LPAD(99 - CAST(SUBSTRING(r.value1, 1, 2) AS UNSIGNED) + 2 * CAST(SUBSTRING(r.value1, 8, 2) AS UNSIGNED), 2, '0'), SUBSTRING(r.value1, 3, 5))
            ELSE r.value1
        END AS converted_value1,
        CASE 
            WHEN LENGTH(r.value2) = 9 THEN CONCAT('1', LPAD(CAST(SUBSTRING(r.value2, 1, 2) AS UNSIGNED) - CAST(SUBSTRING(r.value2, 8, 2) AS UNSIGNED), 2, '0'), LPAD(99 - CAST(SUBSTRING(r.value2, 1, 2) AS UNSIGNED) + 2 * CAST(SUBSTRING(r.value2, 8, 2) AS UNSIGNED), 2, '0'), SUBSTRING(r.value2, 3, 5))
            ELSE r.value2
        END AS converted_value2,
        CASE 
            WHEN LENGTH(r.value3) = 9 THEN CONCAT('1', LPAD(CAST(SUBSTRING(r.value3, 1, 2) AS UNSIGNED) - CAST(SUBSTRING(r.value3, 8, 2) AS UNSIGNED), 2, '0'), LPAD(99 - CAST(SUBSTRING(r.value3, 1, 2) AS UNSIGNED) + 2 * CAST(SUBSTRING(r.value3, 8, 2) AS UNSIGNED), 2, '0'), SUBSTRING(r.value3, 3, 5))
            ELSE r.value3
        END AS converted_value3
    FROM
        results r
    JOIN
        competitions c ON r.competitionId = c.id
    JOIN
        first_competition_dates fcd ON r.personId = fcd.personId AND STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') = fcd.earliest_date
    WHERE
        r.eventId = '333mbo' AND r.value1 > 0 AND r.value2 > 0 AND r.value3 > 0
),
values_with_parts AS (
    SELECT
        personName,
        personId,
        personCountryId,
        year,
        month,
        day,
        name,
        converted_value1 AS value1,
        converted_value2 AS value2,
        converted_value3 AS value3,
        SUBSTRING(converted_value1, 2, 2) AS ss1, SUBSTRING(converted_value1, 4, 2) AS aa1, SUBSTRING(converted_value1, 6, 5) AS ttttt1,
        SUBSTRING(converted_value2, 2, 2) AS ss2, SUBSTRING(converted_value2, 4, 2) AS aa2, SUBSTRING(converted_value2, 6, 5) AS ttttt2,
        SUBSTRING(converted_value3, 2, 2) AS ss3, SUBSTRING(converted_value3, 4, 2) AS aa3, SUBSTRING(converted_value3, 6, 5) AS ttttt3
    FROM
        converted_values
),
average_values AS (
    SELECT
        personName,
        personId,
        personCountryId,
        year,
        month,
        day,
        name,
        value1,
        value2,
        value3,
        ROUND((CAST(ss1 AS UNSIGNED) + CAST(ss2 AS UNSIGNED) + CAST(ss3 AS UNSIGNED)) / 3) AS avg_ss,
        ROUND((CAST(aa1 AS UNSIGNED) + CAST(aa2 AS UNSIGNED) + CAST(aa3 AS UNSIGNED)) / 3) AS avg_aa,
        ROUND((CAST(ttttt1 AS UNSIGNED) + CAST(ttttt2 AS UNSIGNED) + CAST(ttttt3 AS UNSIGNED)) / 3) AS avg_ttttt
    FROM
        values_with_parts
)
SELECT
    personName,
    personId,
    personCountryId,
    CONCAT('1', LPAD(avg_ss, 2, '0'), LPAD(avg_aa, 2, '0'), LPAD(avg_ttttt, 5, '0')) AS firstCompAvg,
    NULL AS nothing,
    STR_TO_DATE(CONCAT(year, '-', month, '-', day), '%Y-%m-%d') AS date,
    name,
    value1,
    value2,
    value3
FROM
    average_values
ORDER BY
    date;
