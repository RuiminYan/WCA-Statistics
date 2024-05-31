/* 

ChatGPT提示词

用MySQL Workbench.

有表格competitions，列名有：id, name, cityName, countryId, information, year, month, day, endMonth, endDay, cancelled, eventSpecs, wcaDelegate, organiser, venue, venueAddress, venueDetails, external_website, cellName, latitude, longitude. 其中year, month, day表示比赛的年月日.

有表格results，列名有：competitionId, eventId, roundTypeId, pos, best, average, personName, personId, personCountryId, formatId, value1, value2, value3, value4, value5, regionSingleRecord, regionAverageRecord. 

设置eventId为333, personId为2019WANY36, 在相同competition下, 排除掉仅有小于等于3个average的情况, 仅考虑有4个average的情况, 按照roundTypeId的以下顺序排序: 1 (或d), 2  (或e), 3  (或g), f, 将这4个average分别记为R1, R2, R3, Fi. 当Fi小于等于0时，记Ao4R为-1; 否则, 记Ao4R为它们的平均数 (四舍五入到个位).

输出列有personName, personId, Ao4R, R1, R2, R3, Fi, name, 按照Ao4R从小到大排序. 注意: 需要排除掉Ao4R为Null的数据.

*/

WITH temp AS (
    SELECT
        r.competitionId,
        r.personName,
        r.personId,
        MAX(CASE WHEN r.roundTypeId IN ('1', 'd') THEN r.average END) AS R1,
        MAX(CASE WHEN r.roundTypeId IN ('2', 'e') THEN r.average END) AS R2,
        MAX(CASE WHEN r.roundTypeId IN ('3', 'g') THEN r.average END) AS R3,
        MAX(CASE WHEN r.roundTypeId = 'f' THEN r.average END) AS Fi,
        COUNT(r.average) AS num_averages
    FROM
        results r
    WHERE
        r.eventId = '333' AND r.personId = '2016KOLA02'
    GROUP BY
        r.competitionId, r.personName, r.personId
    HAVING
        num_averages = 4
),
Ao4R AS (
    SELECT
        competitionId,
        personName,
        personId,
        CASE
            WHEN Fi <= 0 THEN -1
            ELSE ROUND((R1 + R2 + R3 + Fi) / 4)
        END AS Ao4R,
        R1,
        R2,
        R3,
        Fi
    FROM
        temp
)
SELECT
    Ao4R.personName,
    Ao4R.personId,
    Ao4R.Ao4R,
    Ao4R.R1,
    Ao4R.R2,
    Ao4R.R3,
    Ao4R.Fi,
    c.name
FROM
    Ao4R
JOIN
    competitions c ON Ao4R.competitionId = c.id
WHERE
    Ao4R.Ao4R IS NOT NULL
ORDER BY
    Ao4R.Ao4R;
