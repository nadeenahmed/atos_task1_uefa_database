-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema football_league
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema football_league
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS football_league;
USE `football_league` ;

-- -----------------------------------------------------
-- Table `football_league`.`teams`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS football_league.teams (
  TeamID SERIAL PRIMARY KEY,
  TeamName VARCHAR(45) NOT NULL,
  FoundedYear INT NOT NULL,
  HomeCity VARCHAR(45) NOT NULL,
  ManagerName VARCHAR(45) NOT NULL,
  StadiumName VARCHAR(45) NOT NULL,
  StadiumCapacity INT NOT NULL,
  Country VARCHAR(45) NOT NULL,
  UNIQUE (TeamID)
);



-- -----------------------------------------------------
-- Table `football_league`.`matches`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS football_league.matches (
  MatchId SERIAL PRIMARY KEY,
  Date DATE NOT NULL,
  HomeTeamID INT NOT NULL,
  AwayTeamID INT NOT NULL,
  HomeTeamScore INT NOT NULL,
  AwayTeamScore INT NOT NULL,
  Stadium VARCHAR(45) NOT NULL,
  Referee VARCHAR(45) NOT NULL,
  FOREIGN KEY (HomeTeamID) REFERENCES football_league.teams (TeamID),
  FOREIGN KEY (AwayTeamID) REFERENCES football_league.teams (TeamID)
);

-- -----------------------------------------------------
-- Table `football_league`.`players`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS football_league.players (
  PlayerID SERIAL PRIMARY KEY,
  TeamID INT NOT NULL,
  Name VARCHAR(45) NOT NULL,
  Position VARCHAR(45) NOT NULL,
  DateOfBirth DATE NOT NULL,
  Nationality VARCHAR(45) NOT NULL,
  ContractUntil DATE DEFAULT NULL,
  MarketValue INT NOT NULL,
  FOREIGN KEY (TeamID) REFERENCES football_league.teams (TeamID)
);



-- -----------------------------------------------------
-- Table `football_league`.`player_stats`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS football_league.player_stats (
  StatID SERIAL PRIMARY KEY,
  PlayerID INT NOT NULL,
  MatchID INT NOT NULL,
  Goals INT NOT NULL,
  Assists INT NOT NULL,
  YellowCards INT NOT NULL,
  RedCards INT NOT NULL,
  MinutesPlayed INT NOT NULL,
  FOREIGN KEY (MatchID) REFERENCES football_league.matches (MatchId),
  FOREIGN KEY (PlayerID) REFERENCES football_league.players (PlayerID)
);



-- -----------------------------------------------------
-- Table `football_league`.`transfer_history`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS football_league.transfer_history (
  TransferID SERIAL PRIMARY KEY,
  PlayerID INT NOT NULL,
  FromTeamID INT NOT NULL,
  ToTeamID INT NOT NULL,
  TransferDate DATE NOT NULL,
  TransferFee DECIMAL(20, 0) NOT NULL,
  ContractDuration INT NOT NULL,
  FOREIGN KEY (PlayerID) REFERENCES football_league.players (PlayerID),
  FOREIGN KEY (FromTeamID) REFERENCES football_league.teams (TeamID),
  FOREIGN KEY (ToTeamID) REFERENCES football_league.teams (TeamID)
);
ALTER TABLE football_league.player_stats
ALTER COLUMN Assists SET NOT NULL;

INSERT INTO football_league.players (PlayerID, TeamID, Name, Position, DateOfBirth, Nationality, ContractUntil, MarketValue)
VALUES (31, 16, 'Pedro González', 'Midfielder', '2002-11-25', 'Spanish', '2026-06-30', 80000000);

