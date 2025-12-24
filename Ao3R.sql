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
        num_averages = 3 AND R1 > 0  -- 排除 R1 为 0 的行
),
Ao3R AS (
    SELECT
        competition_id,
        person_name,
        person_id,
        person_country_id,
        CASE
            WHEN R1 <= 0 OR R2 <= 0 OR Fi <= 0 THEN -1
            ELSE ROUND((R1 + R2 + Fi) / 3)
        END AS Ao3R,
        R1,
        R2,
        Fi
    FROM
        temp
)
SELECT
    Ao3R.person_name,
    Ao3R.Ao3R,
    NULL,
    STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') AS date,
    c.name,
    Ao3R.R1 AS value1,
    Ao3R.R2 AS value2,
    Ao3R.Fi AS value3,
    NULL,
    NULL,
    Ao3R.person_id,
    Ao3R.person_country_id
FROM
    Ao3R
JOIN
    competitions c ON Ao3R.competition_id = c.id
WHERE
    Ao3R.Ao3R > 0
ORDER BY
    Ao3R.Ao3R;

    -- 按日期排 date;


-- 333mbf需手动查询
