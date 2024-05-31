/* 

ChatGPT提示词: 见Ao4R

*/

WITH temp AS (
    SELECT
        r.competitionId,
        r.personName,
        r.personId,
        MAX(CASE WHEN r.roundTypeId = 'f' THEN r.average END) AS Fi,
        COUNT(r.average) AS num_averages
    FROM
        results r
    WHERE
        r.eventId = '333' AND r.personId IN ('2019WANY36', '2016KOLA02', '2017XURU04', '2012PARK03', '2017GARR05', '2016INAB01', '2023GENG02', '2023DUYU01', '2015BORR01', '2021ZHAN01', '2023CAOQ01', '2018DULL01', '2015MILL01', '2015GRIE02', '2009ZEMD01')
    GROUP BY
        r.competitionId, r.personName, r.personId
    HAVING
        num_averages = 1
),
Ao1R AS (
    SELECT
        competitionId,
        personName,
        personId,
        CASE
            WHEN Fi <= 0 THEN -1
            ELSE Fi
        END AS Ao1R,
        Fi
    FROM
        temp
)
SELECT
    Ao1R.personName,
    Ao1R.personId,
    Ao1R.Ao1R,
    Ao1R.Fi,
    c.year,
    c.month,
    c.day,
    c.name
FROM
    Ao1R
JOIN
    competitions c ON Ao1R.competitionId = c.id
WHERE
    Ao1R.Ao1R  > 0
ORDER BY
    Ao1R.Ao1R; -- 按日期排 c.year, c.month, c.day;
