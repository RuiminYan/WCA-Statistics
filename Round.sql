-- 比赛分项目轮次
SELECT eventId, SUM(distinctRoundTypes) AS totalDistinctRoundTypes
FROM (
    SELECT eventId, COUNT(DISTINCT roundTypeId) AS distinctRoundTypes
    FROM results
    WHERE competitionId = 'WC2023'
      AND roundTypeId IN ('1', '2', '3', 'f')
    GROUP BY eventId
) AS t
GROUP BY eventId;



-- 比赛轮次和
SELECT SUM(distinctRoundTypes) AS overallDistinctRoundTypes
FROM (
    SELECT eventId, COUNT(DISTINCT roundTypeId) AS distinctRoundTypes
    FROM results
    WHERE competitionId = 'WC2023'
      AND roundTypeId IN ('1', '2', '3', 'f')
    GROUP BY eventId
) AS t;


-- 最多轮比赛
SELECT competitionId, SUM(distinctRoundTypes) AS overallDistinctRoundTypes
FROM (
    SELECT competitionId, eventId, COUNT(DISTINCT roundTypeId) AS distinctRoundTypes
    FROM results
    WHERE roundTypeId IN ('1', '2', '3', 'f')
    GROUP BY competitionId, eventId
) AS t
GROUP BY competitionId
ORDER BY overallDistinctRoundTypes DESC;
