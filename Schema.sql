-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema football_league
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema football_league
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `football_league` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `football_league` ;

-- -----------------------------------------------------
-- Table `football_league`.`teams`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `football_league`.`teams` (
  `TeamID` INT NOT NULL,
  `TeamName` VARCHAR(45) NOT NULL,
  `FoundedYear` INT NOT NULL,
  `HomeCity` VARCHAR(45) NOT NULL,
  `ManagerName` VARCHAR(45) NOT NULL,
  `StadiumName` VARCHAR(45) NOT NULL,
  `StadiumCapacity` INT NOT NULL,
  `Country` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`TeamID`),
  UNIQUE INDEX `team_id_UNIQUE` (`TeamID` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `football_league`.`matches`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `football_league`.`matches` (
  `MatchId` INT NOT NULL AUTO_INCREMENT,
  `Date` DATE NOT NULL,
  `HomeTeamID` INT NOT NULL,
  `AwayTeamID` INT NOT NULL,
  `HomeTeamScore` INT NOT NULL,
  `AwayTeamScore` INT NOT NULL,
  `Stadium` VARCHAR(45) NOT NULL,
  `Referee` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`MatchID`),
  UNIQUE INDEX `MatchID_UNIQUE` (`MatchID` ASC) VISIBLE,
  INDEX `f2_team_id_idx` (`HomeTeamID` ASC) VISIBLE,
  INDEX `f3_team_id_idx` (`AwayTeamID` ASC) VISIBLE,
  CONSTRAINT `f2_team_id`
    FOREIGN KEY (`HomeTeamID`)
    REFERENCES `football_league`.`teams` (`TeamID`),
  CONSTRAINT `f3_team_id`
    FOREIGN KEY (`AwayTeamID`)
    REFERENCES `football_league`.`teams` (`TeamID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `football_league`.`players`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `football_league`.`players` (
  `PlayerID` INT NOT NULL,
  `TeamID` INT NOT NULL,
  `Name` VARCHAR(45) NOT NULL,
  `Position` VARCHAR(45) NOT NULL,
  `DateOfBirth` DATE NOT NULL,
  `Nationality` VARCHAR(45) NOT NULL,
  `ContractUntil` DATE NULL DEFAULT NULL,
  `MarketValue` INT NOT NULL,
  PRIMARY KEY (`PlayerID`),
  UNIQUE INDEX `PlayerID_UNIQUE` (`PlayerID` ASC) VISIBLE,
  INDEX `f1_team_id_idx` (`TeamID` ASC) VISIBLE,
  CONSTRAINT `f1_team_id`
    FOREIGN KEY (`TeamID`)
    REFERENCES `football_league`.`teams` (`TeamID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `football_league`.`player_stats`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `football_league`.`player_stats` (
  `StatID` INT NOT NULL AUTO_INCREMENT,
  `PlayerID` INT NOT NULL,
  `MatchID` INT NOT NULL,
  `Goals` INT NOT NULL,
  `Assists` INT NOT NULL,
  `YellowCards` INT NOT NULL,
  `RedCards` INT NOT NULL,
  `MinutesPlayed` INT NOT NULL,
  PRIMARY KEY (`StatID`),
  UNIQUE INDEX `StatID_UNIQUE` (`StatID` ASC) VISIBLE,
  INDEX `f1_player_id_idx` (`PlayerID` ASC) VISIBLE,
  INDEX `f1_match_id_idx` (`MatchID` ASC) VISIBLE,
  CONSTRAINT `f1_match_id`
    FOREIGN KEY (`MatchID`)
    REFERENCES `football_league`.`matches` (`MatchID`),
  CONSTRAINT `f1_player_id`
    FOREIGN KEY (`PlayerID`)
    REFERENCES `football_league`.`players` (`PlayerID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `football_league`.`transfer_history`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `football_league`.`transfer_history` (
  `TransferID` INT NOT NULL AUTO_INCREMENT,
  `PlayerID` INT NOT NULL,
  `FromTeamID` INT NOT NULL,
  `ToTeamID` INT NOT NULL,
  `TransferDate` DATE NOT NULL,
  `TransferFee` DECIMAL(20,0) NOT NULL,
  `ContractDuration` INT NOT NULL,
  PRIMARY KEY (`TransferID`),
  UNIQUE INDEX `TransferID_UNIQUE` (`TransferID` ASC) VISIBLE,
  INDEX `f2_player_id_idx` (`PlayerID` ASC) VISIBLE,
  INDEX `f4_team_id_idx` (`FromTeamID` ASC) VISIBLE,
  INDEX `f5_team_id_idx` (`ToTeamID` ASC) VISIBLE,
  CONSTRAINT `f2_player_id`
    FOREIGN KEY (`PlayerID`)
    REFERENCES `football_league`.`players` (`PlayerID`),
  CONSTRAINT `f4_team_id`
    FOREIGN KEY (`FromTeamID`)
    REFERENCES `football_league`.`teams` (`TeamID`),
  CONSTRAINT `f5_team_id`
    FOREIGN KEY (`ToTeamID`)
    REFERENCES `football_league`.`teams` (`TeamID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
