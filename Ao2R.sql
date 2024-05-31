/* 

ChatGPT提示词: 见Ao4R

*/

WITH temp AS (
    SELECT
        r.competitionId,
        r.personName,
        r.personId,
        MAX(CASE WHEN r.roundTypeId IN ('1', 'd') THEN r.average END) AS R1,
        MAX(CASE WHEN r.roundTypeId = 'f' THEN r.average END) AS Fi,
        COUNT(r.average) AS num_averages
    FROM
        results r
    WHERE
        r.eventId = '333' AND r.personId IN ('2019WANY36', '2016KOLA02', '2017XURU04', '2012PARK03', '2017GARR05', '2016INAB01', '2023GENG02', '2023DUYU01', '2015BORR01', '2021ZHAN01', '2023CAOQ01', '2018DULL01', '2015MILL01', '2015GRIE02', '2009ZEMD01')
    GROUP BY
        r.competitionId, r.personName, r.personId
    HAVING
        num_averages = 2
),
Ao2R AS (
    SELECT
        competitionId,
        personName,
        personId,
        CASE
            WHEN Fi <= 0 THEN -1
            ELSE ROUND((R1 + Fi) / 2)
        END AS Ao2R,
        R1,
        Fi
    FROM
        temp
)
SELECT
    Ao2R.personName,
    Ao2R.personId,
    Ao2R.Ao2R,
    Ao2R.R1,
    Ao2R.Fi,
    c.year,
    c.month,
    c.day,
    c.name
FROM
    Ao2R
JOIN
    competitions c ON Ao2R.competitionId = c.id
WHERE
    Ao2R.Ao2R  > 0
ORDER BY
    Ao2R.Ao2R; -- 按日期排 c.year, c.month, c.day;

