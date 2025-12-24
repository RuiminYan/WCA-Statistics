-- 查询拥有最多333mbf 轮次的比赛
WITH RoundCounts AS (
    SELECT
        competition_id,
        COUNT(DISTINCT round_type_id) AS roundCount
    FROM
        results
    WHERE
        event_id = '333mbf'
    GROUP BY
        competition_id
)
SELECT
    rc.roundCount AS totalRounds,
	STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') AS date,
	c.name AS competitionName
FROM
    RoundCounts rc
JOIN
    competitions c ON rc.competition_id = c.id
ORDER BY
    rc.roundCount DESC
LIMIT 100


    

-- 比赛分项目轮次
SELECT event_id, SUM(distinctRoundTypes) AS totalDistinctRoundTypes
FROM (
    SELECT event_id, COUNT(DISTINCT round_type_id) AS distinctRoundTypes
    FROM results
    WHERE competition_id = 'NortheastChampionship2022'
      AND round_type_id IN ('1', '2', '3', 'f', 'd', 'e', 'g', 'b', 'c')
    GROUP BY event_id
) AS t
GROUP BY event_id;



-- 比赛轮次和
SELECT SUM(distinctRoundTypes) AS overallDistinctRoundTypes
FROM (
    SELECT event_id, COUNT(DISTINCT round_type_id) AS distinctRoundTypes
    FROM results
    WHERE competition_id = 'NortheastChampionship2022'
      AND round_type_id IN ('1', '2', '3', 'f', 'd', 'e', 'g', 'b', 'c')
    GROUP BY event_id
) AS t;


-- 最多轮比赛
SELECT competition_id, SUM(distinctRoundTypes) AS overallDistinctRoundTypes
FROM (
    SELECT competition_id, event_id, COUNT(DISTINCT round_type_id) AS distinctRoundTypes
    FROM results
    WHERE round_type_id IN ('1', '2', '3', 'f', 'd', 'e', 'g', 'b', 'c')
    GROUP BY competition_id, event_id
) AS t
GROUP BY competition_id
ORDER BY overallDistinctRoundTypes DESC;
