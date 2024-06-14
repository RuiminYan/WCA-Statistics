-- 查询拥有最多333mbf 轮次的比赛
WITH RoundCounts AS (
    SELECT
        competitionId,
        COUNT(DISTINCT roundTypeId) AS roundCount
    FROM
        results
    WHERE
        eventId = '333mbf'
    GROUP BY
        competitionId
)
SELECT
    rc.roundCount AS totalRounds,
	STR_TO_DATE(CONCAT(c.year, '-', c.month, '-', c.day), '%Y-%m-%d') AS date,
	c.name AS competitionName
FROM
    RoundCounts rc
JOIN
    competitions c ON rc.competitionId = c.id
ORDER BY
    rc.roundCount DESC
LIMIT 100


    

-- 比赛分项目轮次
SELECT eventId, SUM(distinctRoundTypes) AS totalDistinctRoundTypes
FROM (
    SELECT eventId, COUNT(DISTINCT roundTypeId) AS distinctRoundTypes
    FROM results
    WHERE competitionId = 'NortheastChampionship2022'
      AND roundTypeId IN ('1', '2', '3', 'f', 'd', 'e', 'g', 'b', 'c')
    GROUP BY eventId
) AS t
GROUP BY eventId;



-- 比赛轮次和
SELECT SUM(distinctRoundTypes) AS overallDistinctRoundTypes
FROM (
    SELECT eventId, COUNT(DISTINCT roundTypeId) AS distinctRoundTypes
    FROM results
    WHERE competitionId = 'NortheastChampionship2022'
      AND roundTypeId IN ('1', '2', '3', 'f', 'd', 'e', 'g', 'b', 'c')
    GROUP BY eventId
) AS t;


-- 最多轮比赛
SELECT competitionId, SUM(distinctRoundTypes) AS overallDistinctRoundTypes
FROM (
    SELECT competitionId, eventId, COUNT(DISTINCT roundTypeId) AS distinctRoundTypes
    FROM results
    WHERE roundTypeId IN ('1', '2', '3', 'f', 'd', 'e', 'g', 'b', 'c')
    GROUP BY competitionId, eventId
) AS t
GROUP BY competitionId
ORDER BY overallDistinctRoundTypes DESC;
