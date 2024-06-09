-- 查询competitionId为WakefieldAutumn2022的这场比赛项目为333的有多少种不同的轮次类型，例如当333的roundTypeId有12,3,f时，取值为4，不考虑roundTypeId为0,b,c,d,e,g,h的
SELECT COUNT(DISTINCT roundTypeId) AS distinctRoundTypes
FROM results
WHERE competitionId = 'WC2023'
  AND eventId = '333'
  AND roundTypeId IN ('1', '2', '3', 'f');
