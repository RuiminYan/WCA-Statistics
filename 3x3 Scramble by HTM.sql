select length(scramble)-length(replace(scramble,' ',''))+1 HTM, scramble, eventId, competitionId, scrambleNum, isExtra from Scrambles
where eventId in ('333', '333oh', '333ft', '333fm')
order by  HTM -- DESC
