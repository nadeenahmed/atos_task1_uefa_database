CREATE MATERIALIZED VIEW player_profile AS
WITH CurrentTeam AS(
					SELECT 
							p.playerID
						   ,t.teamName
						   ,p.name
					FROM 
						teams t 
					JOIN 
						players p ON t.teamID = p.teamID
)
, TotalGoals AS(
					SELECT 
							p.playerID
							, SUM(ps.Goals) TotalGoals
					FROM 
						player_stats ps 
					JOIN 
						players p ON p.playerID = ps.playerID
					GROUP BY 
						p.playerID
					)
, TotalAssists AS(
					SELECT
							p.playerID
							, SUM(ps.Assists) TotalAssists
					FROM 
						player_stats ps 
					JOIN 
						players p ON p.playerID = ps.playerID
					GROUP BY 
						p.playerID
					)
, AverageMinutesPlayed AS(
					SELECT
							p.playerID
							, AVG(ps.MinutesPlayed) AverageMinutesPlayed
					FROM 
						player_stats ps 
					JOIN 
						players p ON p.playerID = ps.playerID
					GROUP BY 
						p.playerID
					)
, PlayedOver300Min AS(
					SELECT
							p.playerID
							, CASE
								WHEN SUM(ps.MinutesPlayed) > 300 THEN B'1'
								ELSE B'0'
							END AS PlayedOver300Min				
					FROM 
						player_stats ps 
					JOIN 
						players p ON p.playerID = ps.playerID
					GROUP BY 
						p.playerID
					)
, AgeBetween25And30 AS(
					SELECT
							p.playerID
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
, Scored3PlusGoalsInMatch AS(
					SELECT
							p.playerID
							, CASE
								WHEN MAX(Goals) >= 3 THEN B'1'
								ELSE B'0'
							END AS Scored3PlusGoalsInMatch				
					FROM 
						player_stats ps 
					JOIN 
						players p ON p.playerID = ps.playerID
					JOIN 
						matches m ON m.matchID = ps.matchID
					GROUP BY 
						p.playerID
					)
, EstimatedMatchesPlayed AS(
					SELECT
							p.playerID
							,CONCAT(SUM(minutesplayed) / 90, ' match', SUM(minutesplayed) % 90, ' min') AS EstimatedMatchesPlayed 				
					FROM 
						player_stats ps 
					JOIN 
						players p ON p.playerID = ps.playerID
					JOIN 
						matches m ON m.matchID = ps.matchID
					GROUP BY 
						p.playerID
					)
, PlayedInFrance AS(
					SELECT
							p.playerID
							,CASE
								WHEN t.country = 'France' THEN B'1'
								ELSE B'0' 
							END AS PlayedInFrance
					FROM 
						players p
					JOIN 
						teams t ON t.teamID = p.teamID
					)
, DateJoinedFrenchTeam AS(
					SELECT
							p.playerID
							,MIN(th.transferdate) AS DateJoinedFrenchTeam
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
, PlayedInGermany AS(
					SELECT
							p.playerID
							,CASE
								WHEN t.country = 'Germany' THEN B'1'
								ELSE B'0' 
							END AS PlayedInGermany
					FROM 
						players p
					JOIN 	
						teams t ON t.teamID = p.teamID
					)
, DateJoinedGermanTeam AS(
					SELECT
							p.playerID
							,MIN(th.transferdate) AS DateJoinedGermanTeam
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
	, TotalGoals.TotalGoals
	, TotalAssists.TotalAssists
	, AverageMinutesPlayed.AverageMinutesPlayed
	, PlayedOver300Min.PlayedOver300Min
	, AgeBetween25And30.AgeBetween25And30
	, Scored3PlusGoalsInMatch.Scored3PlusGoalsInMatch
	, EstimatedMatchesPlayed.EstimatedMatchesPlayed
	, PlayedInFrance.PlayedInFrance
	, DateJoinedFrenchTeam.DateJoinedFrenchTeam
	, PlayedInGermany.PlayedInGermany
	, DateJoinedGermanTeam.DateJoinedGermanTeam
FROM 
	CurrentTeam
	JOIN 
		TotalGoals ON CurrentTeam.playerid = TotalGoals.playerid
	JOIN 
		TotalAssists ON CurrentTeam.playerid = TotalAssists.playerid
	JOIN 
		AverageMinutesPlayed ON CurrentTeam.playerid = AverageMinutesPlayed.playerid
	JOIN 
		PlayedOver300Min ON CurrentTeam.playerid = PlayedOver300Min.playerid
	JOIN 
		AgeBetween25And30 ON CurrentTeam.playerid = AgeBetween25And30.playerid
	JOIN 
		Scored3PlusGoalsInMatch ON CurrentTeam.playerid = Scored3PlusGoalsInMatch.playerid
	JOIN 
		EstimatedMatchesPlayed ON CurrentTeam.playerid = EstimatedMatchesPlayed.playerid
	JOIN 
		PlayedInFrance ON CurrentTeam.playerid = PlayedInFrance.playerid
	LEFT JOIN 	
		DateJoinedFrenchTeam ON CurrentTeam.playerid = DateJoinedFrenchTeam.playerid
	JOIN 
		PlayedInGermany ON CurrentTeam.playerid = PlayedInGermany.playerid
	LEFT JOIN 
		DateJoinedGermanTeam ON CurrentTeam.playerid = DateJoinedGermanTeam.playerid
	
SELECT *
FROM football_league.player_profile;
