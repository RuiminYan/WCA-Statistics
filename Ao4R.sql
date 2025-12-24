/* 
设置event_id为333, person_id为2019WANY36, 在相同competition下, 排除掉仅有小于等于3个average的情况, 仅考虑有4个average的情况, 按照round_type_id的以下顺序排序: 1 (或d), 2  (或e), 3  (或g), f, 将这4个average分别记为R1, R2, R3, Fi. 当Fi小于等于0时，记Ao4R为-1; 否则, 记Ao4R为它们的平均数 (四舍五入到个位).
输出列有person_name, person_id, Ao4R, R1, R2, R3, Fi, name, 按照Ao4R从小到大排序. 注意: 需要排除掉Ao4R为Null的数据. 加入year, month, day.
*/

WITH selected_persons AS (
    SELECT DISTINCT person_name, person_id, person_country_id, average
    FROM (
        SELECT r.person_name, r.person_id, r.person_country_id, r.average
        FROM Results r
        JOIN (
            SELECT person_name, MIN(average) AS min_average
            FROM Results
            WHERE event_id = '333' AND average > 0
            GROUP BY person_name
        ) sub ON r.person_name = sub.person_name AND r.average = sub.min_average
        ORDER BY r.average
    ) AS sorted_results
    ORDER BY average
    -- 可选 LIMIT 100
),
temp AS (
    SELECT
        r.competition_id,
        r.person_name,
        r.person_id,
        r.person_country_id,
        MAX(CASE WHEN r.round_type_id IN ('1', 'd') THEN r.average END) AS R1,
        MAX(CASE WHEN r.round_type_id IN ('2', 'e') THEN r.average END) AS R2,
        MAX(CASE WHEN r.round_type_id IN ('3', 'g') THEN r.average END) AS R3,
        MAX(CASE WHEN r.round_type_id = 'f' THEN r.average END) AS Fi,
        COUNT(r.average) AS num_averages
    FROM
        results r
    WHERE
        r.event_id = '333'
        AND r.person_id IN (SELECT person_id FROM selected_persons)
    GROUP BY
        r.competition_id, r.person_name, r.person_id, r.person_country_id
    HAVING
        num_averages = 4
),
Ao4R AS (
    SELECT
        competition_id,
        person_name,
        person_id,
        person_country_id,
        CASE
            WHEN R1 <= 0 OR R2 <= 0 OR R3 <= 0 OR Fi <= 0 THEN -1
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
    Ao4R.person_name,
    Ao4R.Ao4R,
    NULL,
	STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') AS date,
    c.name,
    Ao4R.R1 AS value1,
    Ao4R.R2 AS value2,
    Ao4R.R3 AS value3,
    Ao4R.Fi AS value4,
	NULL,
    Ao4R.person_id,
    Ao4R.person_country_id
FROM
    Ao4R
JOIN
    competitions c ON Ao4R.competition_id = c.id
WHERE
    Ao4R.Ao4R > 0
ORDER BY
	Ao4R.Ao4R;
	--- 按日期 date;
