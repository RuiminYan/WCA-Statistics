-- 1stWR Single
WITH FirstComp AS (
    SELECT 
        r.person_id,
        MIN(STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d')) AS earliest_date
    FROM 
        Results r
    JOIN 
        Competitions c ON r.competition_id = c.id
    WHERE 
        r.event_id = '333'
    GROUP BY 
        r.person_id
),
FirstRound1 AS (
    SELECT
        r.person_id,
        r.person_name,
        r.person_country_id,
        r.value1 AS firstSingle,
        r.regional_single_record,
        STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') AS event_date,
        c.name
    FROM 
        Results r
    JOIN 
        Competitions c ON r.competition_id = c.id
    WHERE 
        r.event_id = '333'
        AND r.round_type_id IN ('1', '0', 'd')
        AND r.value1 > 0
),
FirstRound2 AS (
    SELECT
        r.person_id,
        r.person_name,
        r.person_country_id,
        r.value1 AS firstSingle,
        r.regional_single_record,
        STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') AS event_date,
        c.name
    FROM 
        Results r
    JOIN 
        Competitions c ON r.competition_id = c.id
    WHERE 
        r.event_id = '333'
        AND r.round_type_id IN ('f', 'b', 'c')
        AND r.value1 > 0
)

SELECT
    fr.person_name,
    fr.firstSingle,
    fr.regional_single_record,
    fc.earliest_date AS date,
    fr.name,
    NULL AS nothing,
    NULL AS nothing,
    NULL AS nothing,
    NULL AS nothing,
    NULL AS nothing,
    fr.person_id,
    fr.person_country_id
FROM
    FirstComp fc
JOIN
    (
        SELECT * FROM FirstRound1
        UNION ALL
        SELECT * FROM FirstRound2
        WHERE person_id NOT IN (SELECT person_id FROM FirstRound1)
    ) fr ON fc.person_id = fr.person_id AND fc.earliest_date = fr.event_date
ORDER BY
    fr.firstSingle;

-- 按日期排 fc.earliest_date;











-- 1stWR Average
WITH FirstComp AS (
    SELECT 
        r.person_id,
        MIN(STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d')) AS earliest_date
    FROM 
        Results r
    JOIN 
        Competitions c ON r.competition_id = c.id
    WHERE 
        r.event_id = '333'
    GROUP BY 
        r.person_id
),
FirstRound1 AS (
    SELECT
        r.person_id,
        r.person_name,
        r.person_country_id,
        r.average AS firstAvg,
        r.regional_average_record,
        r.value1,
        r.value2,
        r.value3,
        r.value4,
        r.value5,
        STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') AS event_date,
        c.name
    FROM 
        Results r
    JOIN 
        Competitions c ON r.competition_id = c.id
    WHERE 
        r.event_id = '333'
        AND r.round_type_id IN ('1', '0', 'd')
        AND r.average > 0
),
FirstRound2 AS (
    SELECT
        r.person_id,
        r.person_name,
        r.person_country_id,
        r.average AS firstAvg,
        r.regional_average_record,
        r.value1,
        r.value2,
        r.value3,
        r.value4,
        r.value5,
        STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') AS event_date,
        c.name
    FROM 
        Results r
    JOIN 
        Competitions c ON r.competition_id = c.id
    WHERE 
        r.event_id = '333'
        AND r.round_type_id IN ('f', 'b', 'c')
        AND r.average > 0
)

SELECT
    fr.person_name,
    fr.firstAvg,
    fr.regional_average_record,
    fc.earliest_date AS date,
    fr.name,
    fr.value1,
    fr.value2,
    fr.value3,
    fr.value4,
    fr.value5,
    fr.person_id,
    fr.person_country_id
FROM
    FirstComp fc
JOIN
    (
        SELECT * FROM FirstRound1
        UNION ALL
        SELECT * FROM FirstRound2
        WHERE person_id NOT IN (SELECT person_id FROM FirstRound1)
    ) fr ON fc.person_id = fr.person_id AND fc.earliest_date = fr.event_date
ORDER BY
    fr.firstAvg;

-- 按日期排 fc.earliest_date;






-- 333mbf 1st WR Avg
WITH first_competition_dates AS (
    SELECT 
        r.person_id, 
        MIN(STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d')) AS earliest_date
    FROM 
        results r
    JOIN 
        competitions c ON r.competition_id = c.id
    WHERE 
        r.event_id = '333mbf'
    GROUP BY 
        r.person_id
),
values_with_parts1 AS (
    SELECT
        r.person_name,
        r.person_id,
        r.person_country_id,
        c.year,
        c.month,
        c.day,
        c.name,
        r.value1,
        r.value2,
        r.value3,
        r.regional_average_record,
        SUBSTRING(r.value1, 1, 2) AS dd1, SUBSTRING(r.value1, 3, 5) AS ttttt1, SUBSTRING(r.value1, 8, 2) AS mm1,
        SUBSTRING(r.value2, 1, 2) AS dd2, SUBSTRING(r.value2, 3, 5) AS ttttt2, SUBSTRING(r.value2, 8, 2) AS mm2,
        SUBSTRING(r.value3, 1, 2) AS dd3, SUBSTRING(r.value3, 3, 5) AS ttttt3, SUBSTRING(r.value3, 8, 2) AS mm3
    FROM
        results r
    JOIN
        competitions c ON r.competition_id = c.id
    JOIN
        first_competition_dates fcd ON r.person_id = fcd.person_id AND STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') = fcd.earliest_date
    WHERE
        r.event_id = '333mbf' AND r.round_type_id IN ('1', '0', 'd') AND r.value1 > 0 AND r.value2 > 0 AND r.value3 > 0
),
values_with_parts2 AS (
    SELECT
        r.person_name,
        r.person_id,
        r.person_country_id,
        c.year,
        c.month,
        c.day,
        c.name,
        r.value1,
        r.value2,
        r.value3,
        r.regional_average_record,
        SUBSTRING(r.value1, 1, 2) AS dd1, SUBSTRING(r.value1, 3, 5) AS ttttt1, SUBSTRING(r.value1, 8, 2) AS mm1,
        SUBSTRING(r.value2, 1, 2) AS dd2, SUBSTRING(r.value2, 3, 5) AS ttttt2, SUBSTRING(r.value2, 8, 2) AS mm2,
        SUBSTRING(r.value3, 1, 2) AS dd3, SUBSTRING(r.value3, 3, 5) AS ttttt3, SUBSTRING(r.value3, 8, 2) AS mm3
    FROM
        results r
    JOIN
        competitions c ON r.competition_id = c.id
    JOIN
        first_competition_dates fcd ON r.person_id = fcd.person_id AND STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') = fcd.earliest_date
    WHERE
        r.event_id = '333mbf' AND r.round_type_id IN ('f', 'b', 'c') AND r.value1 > 0 AND r.value2 > 0 AND r.value3 > 0
),
average_values AS (
    SELECT
        person_name,
        person_id,
        person_country_id,
        CONCAT(year, '-', LPAD(month, 2, '0'), '-', LPAD(day, 2, '0')) AS date,
        name,
        value1,
        value2,
        value3,
        regional_average_record,
        ROUND((CAST(dd1 AS UNSIGNED) + CAST(dd2 AS UNSIGNED) + CAST(dd3 AS UNSIGNED)) / 3) AS avg_dd,
        ROUND((CAST(ttttt1 AS UNSIGNED) + CAST(ttttt2 AS UNSIGNED) + CAST(ttttt3 AS UNSIGNED)) / 3) AS avg_ttttt,
        ROUND((CAST(mm1 AS UNSIGNED) + CAST(mm2 AS UNSIGNED) + CAST(mm3 AS UNSIGNED)) / 3) AS avg_mm
    FROM
        (SELECT * FROM values_with_parts1
         UNION ALL
         SELECT * FROM values_with_parts2
         WHERE person_id NOT IN (SELECT person_id FROM values_with_parts1)
        ) AS combined_values
)
SELECT
    person_name,
    CONCAT(LPAD(avg_dd, 2, '0'), LPAD(avg_ttttt, 5, '0'), LPAD(avg_mm, 2, '0')) AS firstAvg,
    regional_average_record,
    date,
    name,
    value1,
    value2,
    value3,
    NULL AS nothing,
    NULL AS nothing,
    person_id,
    person_country_id
FROM
    average_values
ORDER BY
    date;









-- 333mbo 1st WR Avg
WITH first_competition_dates AS (
    SELECT 
        r.person_id, 
        MIN(STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d')) AS earliest_date
    FROM 
        results r
    JOIN 
        competitions c ON r.competition_id = c.id
    WHERE 
        r.event_id = '333mbo'
    GROUP BY 
        r.person_id
),
converted_values1 AS (
    SELECT
        r.person_name,
        r.person_id,
        r.person_country_id,
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
        END AS converted_value3,
        r.regional_average_record
    FROM
        results r
    JOIN
        competitions c ON r.competition_id = c.id
    JOIN
        first_competition_dates fcd ON r.person_id = fcd.person_id AND STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') = fcd.earliest_date
    WHERE
        r.event_id = '333mbo' AND r.round_type_id IN ('1', '0', 'd') AND r.value1 > 0 AND r.value2 > 0 AND r.value3 > 0
),
converted_values2 AS (
    SELECT
        r.person_name,
        r.person_id,
        r.person_country_id,
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
        END AS converted_value3,
        r.regional_average_record
    FROM
        results r
    JOIN
        competitions c ON r.competition_id = c.id
    JOIN
        first_competition_dates fcd ON r.person_id = fcd.person_id AND STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') = fcd.earliest_date
    WHERE
        r.event_id = '333mbo' AND r.round_type_id IN ('f', 'b', 'c') AND r.value1 > 0 AND r.value2 > 0 AND r.value3 > 0
),
values_with_parts AS (
    SELECT
        person_name,
        person_id,
        person_country_id,
        year,
        month,
        day,
        name,
        converted_value1 AS value1,
        converted_value2 AS value2,
        converted_value3 AS value3,
        regional_average_record,
        SUBSTRING(converted_value1, 2, 2) AS ss1, SUBSTRING(converted_value1, 4, 2) AS aa1, SUBSTRING(converted_value1, 6, 5) AS ttttt1,
        SUBSTRING(converted_value2, 2, 2) AS ss2, SUBSTRING(converted_value2, 4, 2) AS aa2, SUBSTRING(converted_value2, 6, 5) AS ttttt2,
        SUBSTRING(converted_value3, 2, 2) AS ss3, SUBSTRING(converted_value3, 4, 2) AS aa3, SUBSTRING(converted_value3, 6, 5) AS ttttt3
    FROM
        (SELECT * FROM converted_values1
         UNION ALL
         SELECT * FROM converted_values2
         WHERE person_id NOT IN (SELECT person_id FROM converted_values1)
        ) AS combined_values
),
average_values AS (
    SELECT
        person_name,
        person_id,
        person_country_id,
        CONCAT(year, '-', LPAD(month, 2, '0'), '-', LPAD(day, 2, '0')) AS date,
        name,
        value1,
        value2,
        value3,
        regional_average_record,
        ROUND((CAST(ss1 AS UNSIGNED) + CAST(ss2 AS UNSIGNED) + CAST(ss3 AS UNSIGNED)) / 3) AS avg_ss,
        ROUND((CAST(aa1 AS UNSIGNED) + CAST(aa2 AS UNSIGNED) + CAST(aa3 AS UNSIGNED)) / 3) AS avg_aa,
        ROUND((CAST(ttttt1 AS UNSIGNED) + CAST(ttttt2 AS UNSIGNED) + CAST(ttttt3 AS UNSIGNED)) / 3) AS avg_ttttt
    FROM
        values_with_parts
)
SELECT
    person_name,
    CONCAT('1', LPAD(avg_ss, 2, '0'), LPAD(avg_aa, 2, '0'), LPAD(avg_ttttt, 5, '0')) AS firstAvg,
    regional_average_record,
    date,
    name,
    value1,
    value2,
    value3,
    NULL AS nothing,
    NULL AS nothing,
    person_id,
    person_country_id
FROM
    average_values
ORDER BY
    date;




