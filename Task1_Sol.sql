-- Materialized View Creation

CREATE MATERIALIZED VIEW player_profile AS
WITH CurrentTeam AS(
					SELECT 
							p.playerID
						   , t.teamName
						   , p.name
					FROM 
						teams t 
					JOIN 
						players p ON t.teamID = p.teamID
)
, PlayerTotalStats AS(
					SELECT 
							p.playerID
							, SUM(ps.Goals) TotalGoals
							, SUM(ps.Assists) TotalAssists
							, AVG(ps.MinutesPlayed) AverageMinutesPlayed
							, CASE
								WHEN SUM(ps.MinutesPlayed) > 300 THEN B'1'
								ELSE B'0'
							END AS PlayedOver300Min		
							, CASE
								WHEN (EXTRACT(YEAR FROM AGE(NOW(), p.dateofbirth)) BETWEEN 25 AND 30) THEN B'1'
								ELSE B'0'
							END AS AgeBetween25And30		
					FROM 
						player_stats ps 
					JOIN 
						players p ON p.playerID = ps.playerID
					GROUP BY 
						p.playerID
					)

, PlayerMatchStats AS(
					SELECT
							p.playerID
							, CASE
								WHEN MAX(Goals) >= 3 THEN B'1'
								ELSE B'0'
							END AS Scored3PlusGoalsInMatch	
							, CONCAT(SUM(minutesplayed) / 90, ' match', SUM(minutesplayed) % 90, ' min') AS EstimatedMatchesPlayed 
					FROM 
						player_stats ps 
					JOIN 
						players p ON p.playerID = ps.playerID
					JOIN 
						matches m ON m.matchID = ps.matchID
					GROUP BY 
						p.playerID
					)
, PlayedInFranceOrGermany AS(
					SELECT
							p.playerID
							, CASE
								WHEN t.country = 'France' THEN B'1'
								ELSE B'0' 
							END AS PlayedInFrance
							, CASE
								WHEN t.country = 'Germany' THEN B'1'
								ELSE B'0' 
							END AS PlayedInGermany
					FROM 
						players p
					JOIN 
						teams t ON t.teamID = p.teamID
					)
, DateJoinedFrenchTeam AS(
					SELECT
							p.playerID
							, MIN(th.transferdate) AS DateJoinedFrenchTeam
					FROM 
						players p
					JOIN 
						teams t ON t.teamID = p.teamID
					JOIN 
						transfer_history th ON th.toteamID = t.teamID AND p.playerID = th.playerID
					WHERE 
						t.country = 'France'
					GROUP BY 
						p.playerID
					)
, DateJoinedGermanTeam AS(
					SELECT
							p.playerID
							, MIN(th.transferdate) AS DateJoinedGermanTeam
					FROM 
						players p
					JOIN 
						teams t ON t.teamID = p.teamID
					JOIN 
						transfer_history th ON th.toteamID = t.teamID AND p.playerID = th.playerID
					WHERE 
						t.country = 'Germany'
					GROUP BY 
						p.playerID
					)
SELECT 
	CurrentTeam.PlayerID
	, CurrentTeam.Name
	, CurrentTeam.TeamName
	, PlayerTotalStats.TotalGoals
	, PlayerTotalStats.TotalAssists
	, PlayerTotalStats.AverageMinutesPlayed
	, PlayerTotalStats.PlayedOver300Min
	, PlayerTotalStats.AgeBetween25And30
	, PlayerMatchStats.Scored3PlusGoalsInMatch
	, PlayerMatchStats.EstimatedMatchesPlayed
	, PlayedInFranceOrGermany.PlayedInFrance
	, DateJoinedFrenchTeam.DateJoinedFrenchTeam
	, PlayedInFranceOrGermany.PlayedInGermany
	, DateJoinedGermanTeam.DateJoinedGermanTeam
FROM 
	CurrentTeam
	JOIN 
		PlayerTotalStats on CurrentTeam.playerID = PlayerTotalStats.playerID
	JOIN 
		PlayerMatchStats ON CurrentTeam.playerID = PlayerMatchStats.playerID
	JOIN 
		PlayedInFranceOrGermany ON CurrentTeam.playerID = PlayedInFranceOrGermany.playerID
	LEFT JOIN 	
		DateJoinedFrenchTeam ON CurrentTeam.playerID = DateJoinedFrenchTeam.playerID
	LEFT JOIN 
		DateJoinedGermanTeam ON CurrentTeam.playerID = DateJoinedGermanTeam.playerID

		
		
-- Display View Data

SELECT *
FROM football_league.player_profile;


-- Refresh The View After Updates

REFRESH MATERIALIZED VIEW football_league.player_profile;

