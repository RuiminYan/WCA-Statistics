/* 新人单次WR Newcomer World Record
ChatGPT提示词
用MySQL Workbench.

有表格competitions，列名有：id, name, cityName, countryId, information, year, month, day, endMonth, endDay, cancelled, eventSpecs, wcaDelegate, organiser, venue, venueAddress, venueDetails, external_website, cellName, latitude, longitude. 其中year, month, day表示比赛的年月日.

有表格results，列名有：competitionId, eventId, roundTypeId, pos, best, average, personName, personId, personCountryId, formatId, value1, value2, value3, value4, value5, regionSingleRecord, regionAverageRecord. 

希望eventId固定为333, best都只取正数，对于每一个personId, 在competition日期最早的competition (注意日期如何比较大小) 下，取所有 best的最小值，记为firstCompSingle。
输出的列有personName，personId，firstCompSingle, 按照firstCompSingle从小到大排序

显示前10个结果即可.
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
        r.eventId = '333' AND r.best > 0
    GROUP BY 
        r.personId
)

SELECT
    r.personName,
    r.personId,
    MIN(r.best) AS firstCompSingle,
    c.year,
    c.month,
    c.day,
    c.name
FROM
    results r
JOIN
    competitions c ON r.competitionId = c.id
JOIN
    first_competition_dates fcd ON r.personId = fcd.personId AND STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') = fcd.earliest_date
WHERE
    r.eventId = '333' AND r.best > 0
GROUP BY
    r.personName, r.personId, c.year, c.month, c.day, c.name
ORDER BY
    firstCompSingle; -- 按日期排 c.year, c.month, c.day;





-- 新人平均WR
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
        r.eventId = '333' AND r.average > 0
    GROUP BY 
        r.personId
)

SELECT
    r.personName,
    r.personId,
    MIN(r.average) AS firstCompAvg,
    c.year,
    c.month,
    c.day,
    c.name
FROM
    results r
JOIN
    competitions c ON r.competitionId = c.id
JOIN
    first_competition_dates fcd ON r.personId = fcd.personId AND STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') = fcd.earliest_date
WHERE
    r.eventId = '333' AND r.average > 0
GROUP BY
    r.personName, r.personId, c.year, c.month, c.day, c.name
ORDER BY
    firstCompAvg; -- 按日期排 c.year, c.month, c.day;

