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
        MAX(CASE WHEN r.round_type_id IN ('c', 'f') THEN r.average END) AS Fi,
        COUNT(r.average) AS num_averages
    FROM
        results r
    WHERE
        r.event_id = '333' AND r.person_id IN (SELECT person_id FROM selected_persons)
    GROUP BY
        r.competition_id, r.person_name, r.person_id, r.person_country_id
    HAVING
        num_averages = 1
),
Ao1R AS (
    SELECT
        competition_id,
        person_name,
        person_id,
        person_country_id,
        CASE
            WHEN Fi <= 0 THEN -1
            ELSE Fi
        END AS Ao1R,
        Fi
    FROM
        temp
)
SELECT
    Ao1R.person_name,
    Ao1R.Ao1R,
    NULL,
    STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') AS date,
    c.name,
    Ao1R.Fi AS value1,
    NULL,
    NULL,
    NULL,
    NULL,
    Ao1R.person_id,
    Ao1R.person_country_id
FROM
    Ao1R
JOIN
    competitions c ON Ao1R.competition_id = c.id
WHERE
    Ao1R.Ao1R > 0
ORDER BY
    Ao1R.Ao1R;

    -- 按日期排 date;




-- 333mbf的Ao1R同333mbf avg
