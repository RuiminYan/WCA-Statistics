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






-- 新人新旧多盲平均
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
values_with_parts AS (
    SELECT
        r.personName,
        r.personId,
        r.personCountryId,
        c.year,
        c.month,
        c.day,
        c.name,
        r.value1,
        r.value2,
        r.value3,
        SUBSTRING(r.value1, 1, 2) AS dd1, SUBSTRING(r.value1, 3, 5) AS ttttt1, SUBSTRING(r.value1, 8, 2) AS mm1,
        SUBSTRING(r.value2, 1, 2) AS dd2, SUBSTRING(r.value2, 3, 5) AS ttttt2, SUBSTRING(r.value2, 8, 2) AS mm2,
        SUBSTRING(r.value3, 1, 2) AS dd3, SUBSTRING(r.value3, 3, 5) AS ttttt3, SUBSTRING(r.value3, 8, 2) AS mm3
    FROM
        results r
    JOIN
        competitions c ON r.competitionId = c.id
    JOIN
        first_competition_dates fcd ON r.personId = fcd.personId AND STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') = fcd.earliest_date
    WHERE
        r.eventId = '333mbo' AND r.value1 > 0 AND r.value2 > 0 AND r.value3 > 0
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
        ROUND((CAST(dd1 AS UNSIGNED) + CAST(dd2 AS UNSIGNED) + CAST(dd3 AS UNSIGNED)) / 3) AS avg_dd,
        ROUND((CAST(ttttt1 AS UNSIGNED) + CAST(ttttt2 AS UNSIGNED) + CAST(ttttt3 AS UNSIGNED)) / 3) AS avg_ttttt,
        ROUND((CAST(mm1 AS UNSIGNED) + CAST(mm2 AS UNSIGNED) + CAST(mm3 AS UNSIGNED)) / 3) AS avg_mm
    FROM
        values_with_parts
)
SELECT
    personName,
    personId,
    personCountryId,
    CONCAT(LPAD(avg_dd, 2, '0'), LPAD(avg_ttttt, 5, '0'), LPAD(avg_mm, 2, '0')) AS firstCompAvg,
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
values_with_parts AS (
    SELECT
        r.personName,
        r.personId,
        r.personCountryId,
        c.year,
        c.month,
        c.day,
        c.name,
        CASE
            WHEN LENGTH(r.value1) = 9 THEN CONCAT(LPAD(99 - (99 - SUBSTRING(r.value1, 1, 2) + SUBSTRING(r.value1, 8, 2)), 2, '0'), SUBSTRING(r.value1, 3, 5), SUBSTRING(r.value1, 8, 2))
            ELSE r.value1
        END AS value1,
        CASE
            WHEN LENGTH(r.value2) = 9 THEN CONCAT(LPAD(99 - (99 - SUBSTRING(r.value2, 1, 2) + SUBSTRING(r.value2, 8, 2)), 2, '0'), SUBSTRING(r.value2, 3, 5), SUBSTRING(r.value2, 8, 2))
            ELSE r.value2
        END AS value2,
        CASE
            WHEN LENGTH(r.value3) = 9 THEN CONCAT(LPAD(99 - (99 - SUBSTRING(r.value3, 1, 2) + SUBSTRING(r.value3, 8, 2)), 2, '0'), SUBSTRING(r.value3, 3, 5), SUBSTRING(r.value3, 8, 2))
            ELSE r.value3
        END AS value3,
        SUBSTRING(
            CASE
                WHEN LENGTH(r.value1) = 9 THEN CONCAT(LPAD(99 - (99 - SUBSTRING(r.value1, 1, 2) + SUBSTRING(r.value1, 8, 2)), 2, '0'), SUBSTRING(r.value1, 3, 5), SUBSTRING(r.value1, 8, 2))
                ELSE r.value1
            END, 1, 2) AS dd1, 
        SUBSTRING(
            CASE
                WHEN LENGTH(r.value1) = 9 THEN CONCAT(LPAD(99 - (99 - SUBSTRING(r.value1, 1, 2) + SUBSTRING(r.value1, 8, 2)), 2, '0'), SUBSTRING(r.value1, 3, 5), SUBSTRING(r.value1, 8, 2))
                ELSE r.value1
            END, 3, 5) AS ttttt1, 
        SUBSTRING(
            CASE
                WHEN LENGTH(r.value1) = 9 THEN CONCAT(LPAD(99 - (99 - SUBSTRING(r.value1, 1, 2) + SUBSTRING(r.value1, 8, 2)), 2, '0'), SUBSTRING(r.value1, 3, 5), SUBSTRING(r.value1, 8, 2))
                ELSE r.value1
            END, 8, 2) AS mm1,
        SUBSTRING(
            CASE
                WHEN LENGTH(r.value2) = 9 THEN CONCAT(LPAD(99 - (99 - SUBSTRING(r.value2, 1, 2) + SUBSTRING(r.value2, 8, 2)), 2, '0'), SUBSTRING(r.value2, 3, 5), SUBSTRING(r.value2, 8, 2))
                ELSE r.value2
            END, 1, 2) AS dd2, 
        SUBSTRING(
            CASE
                WHEN LENGTH(r.value2) = 9 THEN CONCAT(LPAD(99 - (99 - SUBSTRING(r.value2, 1, 2) + SUBSTRING(r.value2, 8, 2)), 2, '0'), SUBSTRING(r.value2, 3, 5), SUBSTRING(r.value2, 8, 2))
                ELSE r.value2
            END, 3, 5) AS ttttt2, 
        SUBSTRING(
            CASE
                WHEN LENGTH(r.value2) = 9 THEN CONCAT(LPAD(99 - (99 - SUBSTRING(r.value2, 1, 2) + SUBSTRING(r.value2, 8, 2)), 2, '0'), SUBSTRING(r.value2, 3, 5), SUBSTRING(r.value2, 8, 2))
                ELSE r.value2
            END, 8, 2) AS mm2,
        SUBSTRING(
            CASE
                WHEN LENGTH(r.value3) = 9 THEN CONCAT(LPAD(99 - (99 - SUBSTRING(r.value3, 1, 2) + SUBSTRING(r.value3, 8, 2)), 2, '0'), SUBSTRING(r.value3, 3, 5), SUBSTRING(r.value3, 8, 2))
                ELSE r.value3
            END, 1, 2) AS dd3, 
        SUBSTRING(
            CASE
                WHEN LENGTH(r.value3) = 9 THEN CONCAT(LPAD(99 - (99 - SUBSTRING(r.value3, 1, 2) + SUBSTRING(r.value3, 8, 2)), 2, '0'), SUBSTRING(r.value3, 3, 5), SUBSTRING(r.value3, 8, 2))
                ELSE r.value3
            END, 3, 5) AS ttttt3, 
        SUBSTRING(
            CASE
                WHEN LENGTH(r.value3) = 9 THEN CONCAT(LPAD(99 - (99 - SUBSTRING(r.value3, 1, 2) + SUBSTRING(r.value3, 8, 2)), 2, '0'), SUBSTRING(r.value3, 3, 5), SUBSTRING(r.value3, 8, 2))
                ELSE r.value3
            END, 8, 2) AS mm3
    FROM
        results r
    JOIN
        competitions c ON r.competitionId = c.id
    JOIN
        first_competition_dates fcd ON r.personId = fcd.personId AND STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') = fcd.earliest_date
    WHERE
        r.eventId = '333mbo' AND r.value1 > 0 AND r.value2 > 0 AND r.value3 > 0
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
        ROUND((CAST(dd1 AS UNSIGNED) + CAST(dd2 AS UNSIGNED) + CAST(dd3 AS UNSIGNED)) / 3) AS avg_dd,
        ROUND((CAST(ttttt1 AS UNSIGNED) + CAST(ttttt2 AS UNSIGNED) + CAST(ttttt3 AS UNSIGNED)) / 3) AS avg_ttttt,
        ROUND((CAST(mm1 AS UNSIGNED) + CAST(mm2 AS UNSIGNED) + CAST(mm3 AS UNSIGNED)) / 3) AS avg_mm
    FROM
        values_with_parts
)
SELECT
    personName,
    personId,
    personCountryId,
    CONCAT(LPAD(avg_dd, 2, '0'), LPAD(avg_ttttt, 5, '0'), LPAD(avg_mm, 2, '0')) AS firstCompAvg,
    NULL AS nothing,
    STR_TO_DATE(CONCAT(year, '-', LPAD(month, 2, '0'), '-', LPAD(day, 2, '0')), '%Y-%m-%d') AS date,
    name,
    value1,
    value2,
    value3
FROM
    average_values
ORDER BY
    date;













