UPDATE teams
SET country = 'Germany'
WHERE country = 'Italy'


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
, CountryPlayAndJoinDates AS (
    SELECT
        p.playerID,
        MAX(CASE WHEN t.country = 'France' THEN 1 ELSE  0 END) AS PlayedInFrance,
        MAX(CASE WHEN t.country = 'Germany' THEN 1 ELSE 0 END) AS PlayedInGermany,
        MIN(CASE WHEN t.country = 'France' THEN th.transferdate END) AS DateJoinedFrenchTeam,
        MIN(CASE WHEN t.country = 'Germany' THEN th.transferdate END) AS DateJoinedGermanTeam
        
    FROM players p
    JOIN teams t ON t.teamID = p.teamID
    LEFT JOIN transfer_history th ON th.toteamID = t.teamID AND p.playerID = th.playerID
    GROUP BY p.playerID
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
	, CountryPlayAndJoinDates.PlayedInFrance
	, CountryPlayAndJoinDates.DateJoinedFrenchTeam
	, CountryPlayAndJoinDates.PlayedInGermany
	, CountryPlayAndJoinDates.DateJoinedGermanTeam
FROM 
	CurrentTeam
	JOIN 
		PlayerTotalStats on CurrentTeam.playerID = PlayerTotalStats.playerID
	JOIN 
		PlayerMatchStats ON CurrentTeam.playerID = PlayerMatchStats.playerID
	LEFT JOIN 
		CountryPlayAndJoinDates ON CurrentTeam.playerID = CountryPlayAndJoinDates.playerID

		
		
-- Display View Data

SELECT *
FROM football_league.player_profile;


-- Refresh The View After Updates

REFRESH MATERIALIZED VIEW football_league.player_profile;

-- Create audit log table for manager_name
CREATE TABLE manager_audit_log (
    log_id SERIAL PRIMARY KEY,
    team_id INT,
    action_type VARCHAR(10),        
    old_manager_name VARCHAR(255),
    new_manager_name VARCHAR(255),
    change_date TIMESTAMPTZ DEFAULT NOW()
);

-- Create a trigger before update or delete 
CREATE OR REPLACE FUNCTION handle_manager_name_changes()
   RETURNS TRIGGER
   LANGUAGE PLPGSQL
AS
$$
BEGIN
 IF TG_OP = 'UPDATE' AND NEW.managerName IS DISTINCT FROM OLD.managername THEN
       INSERT INTO manager_audit_log (team_id, action_type, old_manager_name, new_manager_name)
       VALUES (OLD.teamID, 'UPDATE', OLD.managername, NEW.managername);
ELSIF TG_OP = 'DELETE' THEN
       INSERT INTO manager_audit_log (team_id, action_type, old_manager_name)
       VALUES (OLD.teamID, 'DELETE', OLD.managername);
END IF;   
RETURN NEW;
END;
$$


CREATE TRIGGER manager_name_trigger
BEFORE UPDATE OF managerName OR DELETE
ON teams
FOR EACH ROW
EXECUTE FUNCTION handle_manager_name_changes();

-- Test the trigger function on update

UPDATE teams
SET managerName = 'José Romero'
WHERE teamID = 1;

-- Sample insert into teams table

INSERT INTO teams (teamID, teamName, FoundedYear, HomeCity, managername, StadiumName, StadiumCapacity, Country)
VALUES (21, 'Al-Ahly', 1907, 'Cairo', 'Marcel koller', 'Al Salam', 25000, 'Egypt');

-- Test the trigger function on delete
DELETE FROM teams
WHERE teamID = 21;

