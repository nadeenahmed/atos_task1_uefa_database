-- Players who transferred to another team before their contract ends

SELECT 
    th.PlayerID
    , p.Name AS PlayerName
    , ft.TeamName AS FromTeamName
    , tt.TeamName AS ToTeamName
    , th.TransferDate
    , p.ContractUntil
FROM 
    Transfer_History th
JOIN 
    Players p ON th.PlayerID = p.PlayerID
JOIN 
    Teams ft ON th.FromTeamID = ft.TeamID
JOIN 
    Teams tt ON th.ToTeamID = tt.TeamID
WHERE 
    th.TransferDate < p.ContractUntil
ORDER BY 
	p.playerid 

   
   
   
-- Goalkeepers who scored goals   
   
   SELECT 
    ps.PlayerID,
    p.Name,
    p.Position,
    SUM(ps.Goals) AS TotalGoals
FROM 
    Player_Stats ps
JOIN 
    Players p ON ps.PlayerID = p.PlayerID
WHERE 
    p.Position = 'Goalkeeper' AND ps.Goals > 0
GROUP BY 
    ps.PlayerID, p.Name, p.Position
HAVING 
    SUM(ps.Goals) > 5



   
   
-- Players with duplicate names
   
   
SELECT 
    p.Name,
    COUNT(*) AS NameCount
FROM 
    Players p
GROUP BY 
    p.Name
HAVING 
    COUNT(p.Name) > 1
