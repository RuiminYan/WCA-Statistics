/* 

ChatGPT提示词: 见Ao4R

*/

WITH temp AS (
    SELECT
        r.competitionId,
        r.personName,
        r.personId,
        MAX(CASE WHEN r.roundTypeId IN ('1', 'd') THEN r.average END) AS R1,
        MAX(CASE WHEN r.roundTypeId IN ('2', 'e') THEN r.average END) AS R2,
        MAX(CASE WHEN r.roundTypeId = 'f' THEN r.average END) AS Fi,
        COUNT(r.average) AS num_averages
    FROM
        results r
    WHERE
        r.eventId = '333' AND r.personId IN ('2019WANY36', '2016KOLA02', '2017XURU04', '2012PARK03', '2017GARR05', '2016INAB01', '2023GENG02', '2023DUYU01', '2015BORR01', '2021ZHAN01', '2023CAOQ01', '2018DULL01', '2015MILL01', '2015GRIE02', '2009ZEMD01')
    GROUP BY
        r.competitionId, r.personName, r.personId
    HAVING
        num_averages = 3
),
Ao3R AS (
    SELECT
        competitionId,
        personName,
        personId,
        CASE
            WHEN Fi <= 0 THEN -1
            ELSE ROUND((R1 + R2 + Fi) / 3)
        END AS Ao3R,
        R1,
        R2,
        Fi
    FROM
        temp
)
SELECT
    Ao3R.personName,
    Ao3R.personId,
    Ao3R.Ao3R,
    Ao3R.R1,
    Ao3R.R2,
    Ao3R.Fi,
    c.year,
    c.month,
    c.day,
    c.name
FROM
    Ao3R
JOIN
    competitions c ON Ao3R.competitionId = c.id
WHERE
    Ao3R.Ao3R  > 0
ORDER BY
    Ao3R.Ao3R;

/* 按日期排
ORDER BY
    c.year, c.month, c.day;
*/
