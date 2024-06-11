/* 

设置eventId为333, personId为2019WANY36, 在相同competition下, 排除掉仅有小于等于3个average的情况, 仅考虑有4个average的情况, 按照roundTypeId的以下顺序排序: 1 (或d), 2  (或e), 3  (或g), f, 将这4个average分别记为R1, R2, R3, Fi. 当Fi小于等于0时，记Ao4R为-1; 否则, 记Ao4R为它们的平均数 (四舍五入到个位).

输出列有personName, personId, Ao4R, R1, R2, R3, Fi, name, 按照Ao4R从小到大排序. 注意: 需要排除掉Ao4R为Null的数据. 加入year, month, day.

*/

WITH selected_persons AS (
    SELECT DISTINCT personName, personId, personCountryId, average
    FROM (
        SELECT r.personName, r.personId, r.personCountryId, r.average
        FROM Results r
        JOIN (
            SELECT personName, MIN(average) AS min_average
            FROM Results
            WHERE eventId = '333' AND average > 0
            GROUP BY personName
        ) sub ON r.personName = sub.personName AND r.average = sub.min_average
        ORDER BY r.average
    ) AS sorted_results
    ORDER BY average
    -- 可选 LIMIT 100
),
temp AS (
    SELECT
        r.competitionId,
        r.personName,
        r.personId,
        r.personCountryId,
        MAX(CASE WHEN r.roundTypeId IN ('1', 'd') THEN r.average END) AS R1,
        MAX(CASE WHEN r.roundTypeId IN ('2', 'e') THEN r.average END) AS R2,
        MAX(CASE WHEN r.roundTypeId IN ('3', 'g') THEN r.average END) AS R3,
        MAX(CASE WHEN r.roundTypeId = 'f' THEN r.average END) AS Fi,
        COUNT(r.average) AS num_averages
    FROM
        results r
    WHERE
        r.eventId = '333'
        AND r.personId IN (SELECT personId FROM selected_persons)
    GROUP BY
        r.competitionId, r.personName, r.personId, r.personCountryId
    HAVING
        num_averages = 4
),
Ao4R AS (
    SELECT
        competitionId,
        personName,
        personId,
        personCountryId,
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
    Ao4R.personCountryId,
    Ao4R.Ao4R,
    NULL as nothing,
	STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') AS date,
    c.name,
    Ao4R.R1 AS value1,
    Ao4R.R2 AS value2,
    Ao4R.R3 AS value3,
    Ao4R.Fi AS value4
FROM
    Ao4R
JOIN
    competitions c ON Ao4R.competitionId = c.id
WHERE
    Ao4R.Ao4R > 0
ORDER BY
	Ao3R.Ao3R;
	--- 按日期 date;
