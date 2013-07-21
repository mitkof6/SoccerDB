SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

DROP SCHEMA IF EXISTS `soccerDB` ;
CREATE SCHEMA IF NOT EXISTS `soccerDB` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
USE `soccerDB` ;

-- -----------------------------------------------------
-- Table `soccerDB`.`Team`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `soccerDB`.`Team` ;

CREATE  TABLE IF NOT EXISTS `soccerDB`.`Team` (
  `name` VARCHAR(45) NOT NULL ,
  `league` VARCHAR(10) NOT NULL ,
  UNIQUE INDEX `name_UNIQUE` (`name` ASC) ,
  PRIMARY KEY (`name`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `soccerDB`.`Game`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `soccerDB`.`Game` ;

CREATE  TABLE IF NOT EXISTS `soccerDB`.`Game` (
  `round` INT NOT NULL ,
  `inTeam` VARCHAR(45) NOT NULL ,
  `outTeam` VARCHAR(45) NOT NULL ,
  `resultFH` CHAR NULL ,
  `resultSH` CHAR NOT NULL ,
  `inGoalFH` INT NULL ,
  `outGoalFH` INT NULL ,
  `inGoalSH` INT NOT NULL ,
  `outGoalSH` INT NOT NULL ,
  `oneCoeff` FLOAT NULL ,
  `xCoeff` FLOAT NULL ,
  `twoCoeff` FLOAT NULL ,
  `oneCoeffFH` FLOAT NULL ,
  `xCoeffFH` FLOAT NULL ,
  `twoCoeffFH` FLOAT NULL ,
  PRIMARY KEY (`inTeam`, `outTeam`) ,
  INDEX `inTeam_idx` (`inTeam` ASC) ,
  INDEX `outTeam_idx` (`outTeam` ASC) ,
  CONSTRAINT `inTeam`
    FOREIGN KEY (`inTeam` )
    REFERENCES `soccerDB`.`Team` (`name` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `outTeam`
    FOREIGN KEY (`outTeam` )
    REFERENCES `soccerDB`.`Team` (`name` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `soccerDB`.`Statistics`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `soccerDB`.`Statistics` ;

CREATE  TABLE IF NOT EXISTS `soccerDB`.`Statistics` (
  `round` INT NOT NULL ,
  `league` VARCHAR(10) NOT NULL ,
  `fh` TINYINT(1) NOT NULL ,
  `real` VARCHAR(15) NOT NULL ,
  `logic` VARCHAR(15) NOT NULL ,
  `min` FLOAT NOT NULL ,
  `max` FLOAT NOT NULL ,
  `coeff` FLOAT NOT NULL ,
  `percentage` FLOAT NOT NULL ,
  `s1r` INT NOT NULL ,
  `sxr` INT NOT NULL ,
  `s2r` INT NOT NULL ,
  `str` INT NOT NULL ,
  `s1l` INT NOT NULL ,
  `sxl` INT NOT NULL ,
  `s2l` INT NOT NULL ,
  `stl` INT NOT NULL ,
  `perr` VARCHAR(10) NOT NULL ,
  `perl` VARCHAR(10) NOT NULL ,
  `nr` INT NOT NULL ,
  `nl` INT NOT NULL ,
  `sp1` INT NOT NULL ,
  `sp2` INT NOT NULL ,
  PRIMARY KEY (`round`, `league`, `fh`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Placeholder table for view `soccerDB`.`League`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `soccerDB`.`League` (`"Team"` INT, `"P"` INT, `"W"` INT, `"D"` INT, `"L"` INT, `"GF"` INT, `"GA"` INT, `"Dif"` INT, `"Pts"` INT, `"PPG"` INT, `"PP"` INT);

-- -----------------------------------------------------
-- Placeholder table for view `soccerDB`.`Home`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `soccerDB`.`Home` (`"Team"` INT, `"P"` INT, `"W"` INT, `"D"` INT, `"L"` INT, `"GF"` INT, `"GA"` INT, `"Dif"` INT, `"Pts"` INT, `"O"` INT, `"U"` INT, `"GG"` INT, `"NG"` INT, `"WP"` INT, `"DP"` INT, `"LP"` INT, `"OP"` INT, `"UP"` INT, `"GGP"` INT, `"NGP"` INT);

-- -----------------------------------------------------
-- Placeholder table for view `soccerDB`.`Away`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `soccerDB`.`Away` (`"Team"` INT, `"P"` INT, `"W"` INT, `"D"` INT, `"L"` INT, `"GF"` INT, `"GA"` INT, `"Dif"` INT, `"Pts"` INT, `"O"` INT, `"U"` INT, `"GG"` INT, `"NG"` INT, `"WP"` INT, `"DP"` INT, `"LP"` INT, `"OP"` INT, `"UP"` INT, `"GGP"` INT, `"NGP"` INT);

-- -----------------------------------------------------
-- Placeholder table for view `soccerDB`.`HomeFH`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `soccerDB`.`HomeFH` (`"Team"` INT, `"P"` INT, `"W"` INT, `"D"` INT, `"L"` INT, `"GF"` INT, `"GA"` INT, `"Dif"` INT, `"Pts"` INT, `"O"` INT, `"U"` INT, `"WP"` INT, `"DP"` INT, `"LP"` INT, `"OP"` INT, `"UP"` INT);

-- -----------------------------------------------------
-- Placeholder table for view `soccerDB`.`AwayFH`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `soccerDB`.`AwayFH` (`"Team"` INT, `"P"` INT, `"W"` INT, `"D"` INT, `"L"` INT, `"GF"` INT, `"GA"` INT, `"Dif"` INT, `"Pts"` INT, `"O"` INT, `"U"` INT, `"WP"` INT, `"DP"` INT, `"LP"` INT, `"OP"` INT, `"UP"` INT);

-- -----------------------------------------------------
-- function count_for_result
-- -----------------------------------------------------

USE `soccerDB`;
DROP function IF EXISTS `soccerDB`.`count_for_result`;

DELIMITER $$
USE `soccerDB`$$
CREATE FUNCTION count_for_result(
	pattern CHAR,
	team VARCHAR(45),
	inTeamBool BOOL,
	halfBool BOOL) 
	RETURNS INT
BEGIN
	DECLARE ret_var INT;
	SELECT Count(IF(halfBool=0, resultSH, resultFH)) INTO ret_var 
	FROM Game WHERE IF(halfBool=0, resultSH, resultFH) LIKE pattern 
	AND IF(inTeamBool = 1, inTeam , outTeam) = team;
	RETURN ret_var;
END;
$$

DELIMITER ;

-- -----------------------------------------------------
-- function sum_goal_for
-- -----------------------------------------------------

USE `soccerDB`;
DROP function IF EXISTS `soccerDB`.`sum_goal_for`;

DELIMITER $$
USE `soccerDB`$$
CREATE FUNCTION sum_goal_for(
	team VARCHAR(45),
	inTeamBool BOOL,
	halfBool BOOL) 
	RETURNS INT
BEGIN
	DECLARE ret_var INT;
	SET ret_var = 0;
	SELECT Sum(IF(halfBool = 0, IF(inTeamBool = 1, inGoalFH+inGoalSH, outGoalFH+outGoalSH),
	IF(inTeamBool = 1, inGoalFH, outGoalSH))) INTO ret_var 
	FROM Game WHERE IF(inTeamBool = 1, inTeam, outTeam) = team;
	RETURN ret_var;
END;
$$

DELIMITER ;

-- -----------------------------------------------------
-- function sum_goal_against
-- -----------------------------------------------------

USE `soccerDB`;
DROP function IF EXISTS `soccerDB`.`sum_goal_against`;

DELIMITER $$
USE `soccerDB`$$
CREATE FUNCTION sum_goal_against(
	team VARCHAR(45),
	inTeamBool BOOL,
	halfBool BOOL) 
	RETURNS INT
BEGIN
	DECLARE ret_var INT;
	SET ret_var = 0;
	SELECT sum(IF(halfBool = 0,IF(inTeamBool = 1,outGoalFH+outGoalSH,inGoalFH+inGoalSH),
	IF(inTeamBool = 1, outGoalFH, inGoalFH))) INTO ret_var 
	FROM Game WHERE IF(inTeamBool = 1, inTeam, outTeam) = team;
	RETURN ret_var;
END;
$$

DELIMITER ;

-- -----------------------------------------------------
-- function count_over
-- -----------------------------------------------------

USE `soccerDB`;
DROP function IF EXISTS `soccerDB`.`count_over`;

DELIMITER $$
USE `soccerDB`$$
CREATE FUNCTION `soccerDB`.`count_over` (
	team VARCHAR(45),
	inTeamBool BOOL,
	halfBool BOOL)
	RETURNS INT

BEGIN
	DECLARE var_res INT;
	SET var_res = 0;
	SELECT Count(*) INTO var_res
	FROM Game
	WHERE IF(inTeamBool = 1, inTeam, outTeam) = team
	HAVING IF(halfBool = 0, Sum(inGoalFH+outGoalFH+inGoalSH+outGoalSH), Sum(inGoalFH+outGoalFH)) > 2;
	RETURN var_res;
END;
$$

DELIMITER ;

-- -----------------------------------------------------
-- function count_goal_goal
-- -----------------------------------------------------

USE `soccerDB`;
DROP function IF EXISTS `soccerDB`.`count_goal_goal`;

DELIMITER $$
USE `soccerDB`$$
CREATE FUNCTION `soccerDB`.`count_goal_goal` (
	team VARCHAR(45),
	inTeamBool BOOL)
	RETURNS INT
BEGIN
	DECLARE var_ret INT;
	SET var_ret = 0;
	SELECT Count(*) INTO var_ret
	FROM Game
	WHERE IF(inTeamBool = 1, inTeam, outTeam) = team
	AND (inGoalFH+inGoalSH) > 0 AND (outGoalFH+outGoalSH) > 0;
	RETURN var_ret;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function total_game_played
-- -----------------------------------------------------

USE `soccerDB`;
DROP function IF EXISTS `soccerDB`.`total_game_played`;

DELIMITER $$
USE `soccerDB`$$
CREATE FUNCTION `soccerDB`.`total_game_played` (
	team VARCHAR(45))
	RETURNS INT
BEGIN
	DECLARE ret_var INT;
	SET ret_var = 0;
	SELECT Count(*) INTO ret_var
	FROM Game
	WHERE team = inTeam OR team = outTeam;
	RETURN ret_var;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function count_total_win
-- -----------------------------------------------------

USE `soccerDB`;
DROP function IF EXISTS `soccerDB`.`count_total_win`;

DELIMITER $$
USE `soccerDB`$$
CREATE FUNCTION `soccerDB`.`count_total_win` (
	team VARCHAR(45))
	RETURNS INT
BEGIN
	RETURN count_for_result('1',team,1,0)+count_for_result('2',team,0,0);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function count_total_draw
-- -----------------------------------------------------

USE `soccerDB`;
DROP function IF EXISTS `soccerDB`.`count_total_draw`;

DELIMITER $$
USE `soccerDB`$$
CREATE FUNCTION `soccerDB`.`count_total_draw` (
	team VARCHAR(45))
	RETURNS INT
BEGIN
	RETURN count_for_result('x',team,1,0) + count_for_result('x',team,0,0);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function count_total_lost
-- -----------------------------------------------------

USE `soccerDB`;
DROP function IF EXISTS `soccerDB`.`count_total_lost`;

DELIMITER $$
USE `soccerDB`$$
CREATE FUNCTION `soccerDB`.`count_total_lost` (
	team VARCHAR(45))
	RETURNS INT
BEGIN
	RETURN count_for_result('2',team,1,0) + count_for_result('1',team,0,0);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function count_total_goal_for
-- -----------------------------------------------------

USE `soccerDB`;
DROP function IF EXISTS `soccerDB`.`count_total_goal_for`;

DELIMITER $$
USE `soccerDB`$$
CREATE FUNCTION `soccerDB`.`count_total_goal_for` (
	team VARCHAR(45))
	RETURNS INT
BEGIN
	RETURN sum_goal_for(team,1,0)+sum_goal_for(team,0,0);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function count_total_goal_against
-- -----------------------------------------------------

USE `soccerDB`;
DROP function IF EXISTS `soccerDB`.`count_total_goal_against`;

DELIMITER $$
USE `soccerDB`$$
CREATE FUNCTION `soccerDB`.`count_total_goal_against` (
	team VARCHAR(45))
	RETURNS INT
BEGIN
	RETURN sum_goal_against(team, 1, 0)+sum_goal_against(team, 0, 0);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure home_away_statistics
-- -----------------------------------------------------

USE `soccerDB`;
DROP procedure IF EXISTS `soccerDB`.`home_away_statistics`;

DELIMITER $$
USE `soccerDB`$$
CREATE PROCEDURE `soccerDB`.`home_away_statistics` (
	team1 VARCHAR(45),
	team2 VARCHAR(45))

BEGIN
	DECLARE WP1, WP2, DP1, DP2, LP1, LP2, GGP1, GGP2, NGP1, NGP2, UP1, UP2, OP1, OP2 FLOAT;
	DECLARE P1, P2, GF1, GF2, GA1, GA2 INT;
	
	SELECT P, WP, DP, LP, GF, GA, UP, OP, GGP, NGP INTO P1, WP1, DP1, LP1, GF1, GA1, UP1, OP1, GGP1, NGP1
	FROM Home
	WHERE Team = team1;

	SELECT P, WP, DP, LP, GF, GA, UP, OP, GGP, NGP INTO P2, WP2, DP2, LP2, GF2, GA2, UP2, OP2, GGP2, NGP2
	FROM Away
	WHERE Team = team2;

	SELECT 
	P1, P2,
	Round((WP1+LP2)/2,2) AS "1",
	Round((DP1+DP2)/2,2) AS "x",
	Round((LP1+WP2)/2,2) AS "2",
	Round(GF1/P1,2) AS "GFA1", 
	Round(GA1/P1,2) AS "GAA1", 
	Round(GF2/P2,2) AS "GFA2", 
	Round(GA2/P2,2) AS "GAA2", 
	Round(UP1,2) AS "UP1",
	Round(OP1,2) AS "OP1", 
	Round(UP2,2) AS "UP2", 
	Round(OP2,2) AS "OP2",
	Round(GGP1,2) AS "GGP1", 
	Round(NGP1,2) AS "NGP1", 
	Round(GGP2,2) AS "GGP2", 
	Round(NGP2,2) AS "NGP2"
	FROM Team
	LIMIT 0,1;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure awayFH
-- -----------------------------------------------------

USE `soccerDB`;
DROP procedure IF EXISTS `soccerDB`.`awayFH`;

DELIMITER $$
USE `soccerDB`$$
CREATE PROCEDURE `soccerDB`.`awayFH` (
	league VARCHAR(10))
BEGIN
	SELECT Team, P, W, D, L, GA, GF, Dif, Pts, O, U, WP, DP, LP, OP, UP
	FROM AwayFH Join Team ON Team = name
	WHERE Team.league = league
	ORDER BY Pts DESC;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure homeFH
-- -----------------------------------------------------

USE `soccerDB`;
DROP procedure IF EXISTS `soccerDB`.`homeFH`;

DELIMITER $$
USE `soccerDB`$$
CREATE PROCEDURE `soccerDB`.`homeFH` (
	league VARCHAR(10))
BEGIN
	SELECT Team, P, W, D, L, GA, GF, Dif, Pts, O, U, WP, DP, LP, OP, UP
	FROM HomeFH Join Team ON Team = name
	WHERE Team.league = league
	ORDER BY Pts DESC;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure home
-- -----------------------------------------------------

USE `soccerDB`;
DROP procedure IF EXISTS `soccerDB`.`home`;

DELIMITER $$
USE `soccerDB`$$
CREATE PROCEDURE `soccerDB`.`home` (
	league VARCHAR(10))
BEGIN
	SELECT Team, P, W, D, L, GA, GF, Dif, Pts, O, U, GG, NG, WP, DP, LP, OP, UP, GGP, NGP
	FROM Home Join Team ON Team = name
	WHERE Team.league = league
	ORDER BY Pts DESC;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure away
-- -----------------------------------------------------

USE `soccerDB`;
DROP procedure IF EXISTS `soccerDB`.`away`;

DELIMITER $$
USE `soccerDB`$$
CREATE PROCEDURE `soccerDB`.`away` (
	league VARCHAR(10))
BEGIN
	SELECT Team, P, W, D, L, GA, GF, Dif, Pts, O, U, GG, NG, WP, DP, LP, OP, UP, GGP, NGP
	FROM Away Join Team ON Team = name
	WHERE Team.league = league
	ORDER BY Pts DESC;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure league
-- -----------------------------------------------------

USE `soccerDB`;
DROP procedure IF EXISTS `soccerDB`.`league`;

DELIMITER $$
USE `soccerDB`$$
CREATE PROCEDURE `soccerDB`.`league` (
	league VARCHAR(10))
BEGIN
	SELECT Team, P, W, D, L, GA, GF, Dif, Pts, PPG, PP
	FROM League Join Team ON Team = name
	WHERE Team.league = league
	ORDER BY PP DESC;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- View `soccerDB`.`League`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `soccerDB`.`League` ;
DROP TABLE IF EXISTS `soccerDB`.`League`;
USE `soccerDB`;
CREATE  OR REPLACE VIEW `soccerDB`.`League` AS
SELECT name AS "Team", 
total_game_played(name) AS "P",
count_total_win(name) AS "W",
count_total_draw(name) AS "D",
count_total_lost(name) AS "L",
count_total_goal_for(name) AS "GF",
count_total_goal_against(name) AS "GA", 
(count_total_goal_for(name) - count_total_goal_against(name)) AS "Dif",
(count_total_win(name)*3+count_total_draw(name)) AS "Pts",
Round((count_total_win(name)*3+count_total_draw(name))/total_game_played(name),2) AS "PPG",
Round((count_total_win(name)*3+count_total_draw(name))/(total_game_played(name)*3),2) AS "PP"
FROM Team
ORDER BY PP DESC
;

-- -----------------------------------------------------
-- View `soccerDB`.`Home`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `soccerDB`.`Home` ;
DROP TABLE IF EXISTS `soccerDB`.`Home`;
USE `soccerDB`;
CREATE  OR REPLACE VIEW `soccerDB`.`Home` AS
SELECT inTeam AS "Team",
Count(*) AS "P",
count_for_result('1',inTeam,1,0) AS "W",
count_for_result('x',inTeam,1,0) AS "D",
count_for_result('2',inTeam,1,0) AS "L",
sum_goal_for(inTeam,1,0) AS "GF",
sum_goal_against(inTeam,1,0) AS "GA",
(sum_goal_for(inTeam,1,0)-sum_goal_against(inTeam,1,0)) AS "Dif",
(count_for_result('1',inTeam,1,0)*3+count_for_result('x',inTeam,1,0)) AS "Pts",
count_over(inTeam,1,0) AS "O",
(Count(*) - count_over(inTeam,1,0)) AS "U",
count_goal_goal(inTeam,1) AS "GG",
(Count(*) - count_goal_goal(inTeam,1)) AS "NG",
Round(count_for_result('1',inTeam,1,0)/Count(*),2) AS "WP",
Round(count_for_result('x',inTeam,1,0)/Count(*),2) AS "DP",
Round(count_for_result('2',inTeam,1,0)/Count(*),2) AS "LP",
Round(count_over(inTeam,1,0)/Count(*),2) AS "OP",
Round((count(*) - count_over(inTeam,1,0))/Count(*),2) AS "UP",
Round(count_goal_goal(inTeam,1)/Count(*),2) AS "GGP",
Round((Count(*) - count_goal_goal(inTeam,1))/Count(*),2) AS "NGP"
FROM Game
GROUP BY inTeam
ORDER BY Pts DESC;

-- -----------------------------------------------------
-- View `soccerDB`.`Away`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `soccerDB`.`Away` ;
DROP TABLE IF EXISTS `soccerDB`.`Away`;
USE `soccerDB`;
CREATE  OR REPLACE VIEW `soccerDB`.`Away` AS
SELECT outTeam AS "Team",
Count(*) AS "P",
count_for_result('2',outTeam,0,0) AS "W",
count_for_result('x',outTeam,0,0) AS "D",
count_for_result('1',outTeam,0,0) AS "L",
sum_goal_for(outTeam,0,0) AS "GF",
sum_goal_against(outTeam,0,0) AS "GA",
(sum_goal_for(outTeam,0,0)-sum_goal_against(outTeam,0,0)) AS "Dif",
(count_for_result('2',outTeam,0,0)*3+count_for_result('x',outTeam,0,0)) AS "Pts",
count_over(outTeam,0,0) AS "O",
(count(*) - count_over(outTeam,0,0)) AS "U",
count_goal_goal(inTeam,0) AS "GG",
(Count(*) - count_goal_goal(inTeam,0)) AS "NG",
Round(count_for_result('2',outTeam,0,0)/Count(*),2) AS "WP",
Round(count_for_result('x',outTeam,0,0)/Count(*),2) AS "DP",
Round(count_for_result('1',outTeam,0,0)/Count(*),2) AS "LP",
Round(count_over(outTeam,0,0)/Count(*),2) AS "OP",
Round((count(*)-count_over(outTeam,0,0))/Count(*),2) AS "UP",
Round(count_goal_goal(inTeam,0)/Count(*),2) AS "GGP",
Round((Count(*) - count_goal_goal(inTeam,0))/Count(*),2) AS "NGP"
FROM Game
GROUP BY outTeam
ORDER BY Pts DESC
;

-- -----------------------------------------------------
-- View `soccerDB`.`HomeFH`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `soccerDB`.`HomeFH` ;
DROP TABLE IF EXISTS `soccerDB`.`HomeFH`;
USE `soccerDB`;
CREATE  OR REPLACE VIEW `soccerDB`.`HomeFH` AS
SELECT inTeam AS "Team",
Count(*) AS "P",
count_for_result('1',inTeam,1,1) AS "W",
count_for_result('x',inTeam,1,1) AS "D",
count_for_result('2',inTeam,1,1) AS "L",
sum_goal_for(inTeam,1,1) AS "GF",
sum_goal_against(inTeam,1,1) AS "GA",
(sum_goal_for(inTeam,1,1)-sum_goal_against(inTeam,1,1)) AS "Dif",
(count_for_result('1',inTeam,1,1)*3+count_for_result('x',inTeam,1,1)) AS "Pts",
count_over(inTeam,1,1) AS "O",
(count(*) - count_over(inTeam,1,1)) AS "U",
Round(count_for_result('1',inTeam,1,1)/Count(*),2) AS "WP",
Round(count_for_result('x',inTeam,1,1)/Count(*),2) AS "DP",
Round(count_for_result('2',inTeam,1,1)/Count(*),2) AS "LP",
Round(count_over(inTeam,1,1)/Count(*),2) AS "OP",
Round((count(*) - count_over(inTeam,1,1))/Count(*),2) AS "UP"
FROM Game
GROUP BY inTeam
ORDER BY Pts DESC;

-- -----------------------------------------------------
-- View `soccerDB`.`AwayFH`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `soccerDB`.`AwayFH` ;
DROP TABLE IF EXISTS `soccerDB`.`AwayFH`;
USE `soccerDB`;
CREATE  OR REPLACE VIEW `soccerDB`.`AwayFH` AS
SELECT outTeam AS "Team",
Count(*) AS "P",
count_for_result('2',outTeam,0,1) AS "W",
count_for_result('x',outTeam,0,1) AS "D",
count_for_result('1',outTeam,0,1) AS "L",
sum_goal_for(outTeam,0,1) AS "GF",
sum_goal_against(outTeam,0,1) AS "GA",
(sum_goal_for(outTeam,0,1)-sum_goal_against(outTeam,0,1)) AS "Dif",
(count_for_result('2',outTeam,0,1)*3+count_for_result('x',outTeam,0,1)) AS "Pts",
count_over(outTeam,0,1) AS "O",
(count(*) - count_over(outTeam,0,1)) AS "U",
Round(count_for_result('2',outTeam,0,1)/Count(*),2) AS "WP",
Round(count_for_result('x',outTeam,0,1)/Count(*),2) AS "DP",
Round(count_for_result('1',outTeam,0,1)/Count(*),2) AS "LP",
Round(count_over(outTeam,0,1)/Count(*),2) AS "OP",
Round((count(*) - count_over(outTeam,0,1))/Count(*),2) AS "UP"
FROM Game
GROUP BY outTeam
ORDER BY Pts DESC
;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Data for table `soccerDB`.`Team`
-- -----------------------------------------------------
START TRANSACTION;
USE `soccerDB`;
INSERT INTO `soccerDB`.`Team` (`name`, `league`) VALUES ('Molde', 'NO');
INSERT INTO `soccerDB`.`Team` (`name`, `league`) VALUES ('Viking FK', 'NO');
INSERT INTO `soccerDB`.`Team` (`name`, `league`) VALUES ('Aalesunds FK', 'NO');
INSERT INTO `soccerDB`.`Team` (`name`, `league`) VALUES ('Haugesund', 'NO');
INSERT INTO `soccerDB`.`Team` (`name`, `league`) VALUES ('SK Brann', 'NO');
INSERT INTO `soccerDB`.`Team` (`name`, `league`) VALUES ('Valerenga', 'NO');
INSERT INTO `soccerDB`.`Team` (`name`, `league`) VALUES ('Lillestrom SK', 'NO');
INSERT INTO `soccerDB`.`Team` (`name`, `league`) VALUES ('Sarpsborg', 'NO');
INSERT INTO `soccerDB`.`Team` (`name`, `league`) VALUES ('Odd Grenland', 'NO');
INSERT INTO `soccerDB`.`Team` (`name`, `league`) VALUES ('Rosenborg', 'NO');
INSERT INTO `soccerDB`.`Team` (`name`, `league`) VALUES ('Sogndal', 'NO');
INSERT INTO `soccerDB`.`Team` (`name`, `league`) VALUES ('Tromso IL', 'NO');
INSERT INTO `soccerDB`.`Team` (`name`, `league`) VALUES ('Stromsgodset', 'NO');
INSERT INTO `soccerDB`.`Team` (`name`, `league`) VALUES ('Sandnes Ulf', 'NO');
INSERT INTO `soccerDB`.`Team` (`name`, `league`) VALUES ('Start', 'NO');
INSERT INTO `soccerDB`.`Team` (`name`, `league`) VALUES ('Honefoss', 'NO');

COMMIT;

-- -----------------------------------------------------
-- Data for table `soccerDB`.`Game`
-- -----------------------------------------------------
START TRANSACTION;
USE `soccerDB`;
INSERT INTO `soccerDB`.`Game` (`round`, `inTeam`, `outTeam`, `resultFH`, `resultSH`, `inGoalFH`, `outGoalFH`, `inGoalSH`, `outGoalSH`, `oneCoeff`, `xCoeff`, `twoCoeff`, `oneCoeffFH`, `xCoeffFH`, `twoCoeffFH`) VALUES (1, 'Viking FK', 'Molde', 'x', '1', 0, 0, 2, 1, 1, 1, 1, NULL, NULL, NULL);
INSERT INTO `soccerDB`.`Game` (`round`, `inTeam`, `outTeam`, `resultFH`, `resultSH`, `inGoalFH`, `outGoalFH`, `inGoalSH`, `outGoalSH`, `oneCoeff`, `xCoeff`, `twoCoeff`, `oneCoeffFH`, `xCoeffFH`, `twoCoeffFH`) VALUES (1, 'Aalesunds FK', 'Haugesund', 'x', '1', 0, 0, 3, 0, 1, 1, 1, NULL, NULL, NULL);
INSERT INTO `soccerDB`.`Game` (`round`, `inTeam`, `outTeam`, `resultFH`, `resultSH`, `inGoalFH`, `outGoalFH`, `inGoalSH`, `outGoalSH`, `oneCoeff`, `xCoeff`, `twoCoeff`, `oneCoeffFH`, `xCoeffFH`, `twoCoeffFH`) VALUES (1, 'SK Brann', 'Valerenga', 'x', '1', 0, 0, 3, 1, 1, 1, 1, NULL, NULL, NULL);
INSERT INTO `soccerDB`.`Game` (`round`, `inTeam`, `outTeam`, `resultFH`, `resultSH`, `inGoalFH`, `outGoalFH`, `inGoalSH`, `outGoalSH`, `oneCoeff`, `xCoeff`, `twoCoeff`, `oneCoeffFH`, `xCoeffFH`, `twoCoeffFH`) VALUES (1, 'Lillestrom SK', 'Sarpsborg', 'x', 'x', 0, 0, 2, 2, 1, 1, 1, NULL, NULL, NULL);
INSERT INTO `soccerDB`.`Game` (`round`, `inTeam`, `outTeam`, `resultFH`, `resultSH`, `inGoalFH`, `outGoalFH`, `inGoalSH`, `outGoalSH`, `oneCoeff`, `xCoeff`, `twoCoeff`, `oneCoeffFH`, `xCoeffFH`, `twoCoeffFH`) VALUES (1, 'Odd Grenland', 'Rosenborg', 'x', '2', 0, 0, 0, 1, 1, 1, 1, NULL, NULL, NULL);
INSERT INTO `soccerDB`.`Game` (`round`, `inTeam`, `outTeam`, `resultFH`, `resultSH`, `inGoalFH`, `outGoalFH`, `inGoalSH`, `outGoalSH`, `oneCoeff`, `xCoeff`, `twoCoeff`, `oneCoeffFH`, `xCoeffFH`, `twoCoeffFH`) VALUES (1, 'Sogndal', 'Tromso IL', 'x', 'x', 0, 0, 2, 2, 1, 1, 1, NULL, NULL, NULL);
INSERT INTO `soccerDB`.`Game` (`round`, `inTeam`, `outTeam`, `resultFH`, `resultSH`, `inGoalFH`, `outGoalFH`, `inGoalSH`, `outGoalSH`, `oneCoeff`, `xCoeff`, `twoCoeff`, `oneCoeffFH`, `xCoeffFH`, `twoCoeffFH`) VALUES (1, 'Stromsgodset', 'Sandnes Ulf', 'x', '1', 0, 0, 2, 0, 1, 1, 1, NULL, NULL, NULL);
INSERT INTO `soccerDB`.`Game` (`round`, `inTeam`, `outTeam`, `resultFH`, `resultSH`, `inGoalFH`, `outGoalFH`, `inGoalSH`, `outGoalSH`, `oneCoeff`, `xCoeff`, `twoCoeff`, `oneCoeffFH`, `xCoeffFH`, `twoCoeffFH`) VALUES (1, 'Start', 'Honefoss', 'x', '1', 0, 0, 3, 2, 1, 1, 1, NULL, NULL, NULL);
INSERT INTO `soccerDB`.`Game` (`round`, `inTeam`, `outTeam`, `resultFH`, `resultSH`, `inGoalFH`, `outGoalFH`, `inGoalSH`, `outGoalSH`, `oneCoeff`, `xCoeff`, `twoCoeff`, `oneCoeffFH`, `xCoeffFH`, `twoCoeffFH`) VALUES (2, 'Rosenborg', 'SK Brann', 'x', '1', 0, 0, 4, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `soccerDB`.`Game` (`round`, `inTeam`, `outTeam`, `resultFH`, `resultSH`, `inGoalFH`, `outGoalFH`, `inGoalSH`, `outGoalSH`, `oneCoeff`, `xCoeff`, `twoCoeff`, `oneCoeffFH`, `xCoeffFH`, `twoCoeffFH`) VALUES (2, 'Sandnes Ulf', 'Aalesunds FK', 'x', '2', 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `soccerDB`.`Game` (`round`, `inTeam`, `outTeam`, `resultFH`, `resultSH`, `inGoalFH`, `outGoalFH`, `inGoalSH`, `outGoalSH`, `oneCoeff`, `xCoeff`, `twoCoeff`, `oneCoeffFH`, `xCoeffFH`, `twoCoeffFH`) VALUES (2, 'Tromso IL', 'Odd Grenland', 'x', '1', 0, 0, 2, 1, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `soccerDB`.`Game` (`round`, `inTeam`, `outTeam`, `resultFH`, `resultSH`, `inGoalFH`, `outGoalFH`, `inGoalSH`, `outGoalSH`, `oneCoeff`, `xCoeff`, `twoCoeff`, `oneCoeffFH`, `xCoeffFH`, `twoCoeffFH`) VALUES (2, 'Valerenga', 'Sogndal', 'x', '1', 0, 0, 1, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `soccerDB`.`Game` (`round`, `inTeam`, `outTeam`, `resultFH`, `resultSH`, `inGoalFH`, `outGoalFH`, `inGoalSH`, `outGoalSH`, `oneCoeff`, `xCoeff`, `twoCoeff`, `oneCoeffFH`, `xCoeffFH`, `twoCoeffFH`) VALUES (2, 'Sarpsborg', 'Viking FK', 'x', '1', 0, 0, 2, 1, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `soccerDB`.`Game` (`round`, `inTeam`, `outTeam`, `resultFH`, `resultSH`, `inGoalFH`, `outGoalFH`, `inGoalSH`, `outGoalSH`, `oneCoeff`, `xCoeff`, `twoCoeff`, `oneCoeffFH`, `xCoeffFH`, `twoCoeffFH`) VALUES (2, 'Honefoss', 'Stromsgodset', 'x', '1', 0, 0, 2, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `soccerDB`.`Game` (`round`, `inTeam`, `outTeam`, `resultFH`, `resultSH`, `inGoalFH`, `outGoalFH`, `inGoalSH`, `outGoalSH`, `oneCoeff`, `xCoeff`, `twoCoeff`, `oneCoeffFH`, `xCoeffFH`, `twoCoeffFH`) VALUES (2, 'Molde', 'Lillestrom SK', 'x', '2', 0, 0, 1, 2, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `soccerDB`.`Game` (`round`, `inTeam`, `outTeam`, `resultFH`, `resultSH`, `inGoalFH`, `outGoalFH`, `inGoalSH`, `outGoalSH`, `oneCoeff`, `xCoeff`, `twoCoeff`, `oneCoeffFH`, `xCoeffFH`, `twoCoeffFH`) VALUES (2, 'Haugesund', 'Start', 'x', '1', 0, 0, 3, 2, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `soccerDB`.`Game` (`round`, `inTeam`, `outTeam`, `resultFH`, `resultSH`, `inGoalFH`, `outGoalFH`, `inGoalSH`, `outGoalSH`, `oneCoeff`, `xCoeff`, `twoCoeff`, `oneCoeffFH`, `xCoeffFH`, `twoCoeffFH`) VALUES (3, 'Odd Grenland', 'Valerenga', 'x', '1', 0, 0, 2, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `soccerDB`.`Game` (`round`, `inTeam`, `outTeam`, `resultFH`, `resultSH`, `inGoalFH`, `outGoalFH`, `inGoalSH`, `outGoalSH`, `oneCoeff`, `xCoeff`, `twoCoeff`, `oneCoeffFH`, `xCoeffFH`, `twoCoeffFH`) VALUES (3, 'SK Brann', 'Molde', 'x', '1', 0, 0, 1, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `soccerDB`.`Game` (`round`, `inTeam`, `outTeam`, `resultFH`, `resultSH`, `inGoalFH`, `outGoalFH`, `inGoalSH`, `outGoalSH`, `oneCoeff`, `xCoeff`, `twoCoeff`, `oneCoeffFH`, `xCoeffFH`, `twoCoeffFH`) VALUES (3, 'Start', 'Tromso IL', 'x', 'x', 0, 0, 2, 2, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `soccerDB`.`Game` (`round`, `inTeam`, `outTeam`, `resultFH`, `resultSH`, `inGoalFH`, `outGoalFH`, `inGoalSH`, `outGoalSH`, `oneCoeff`, `xCoeff`, `twoCoeff`, `oneCoeffFH`, `xCoeffFH`, `twoCoeffFH`) VALUES (3, 'Aalesunds FK', 'Honefoss', 'x', '1', 0, 0, 4, 3, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `soccerDB`.`Game` (`round`, `inTeam`, `outTeam`, `resultFH`, `resultSH`, `inGoalFH`, `outGoalFH`, `inGoalSH`, `outGoalSH`, `oneCoeff`, `xCoeff`, `twoCoeff`, `oneCoeffFH`, `xCoeffFH`, `twoCoeffFH`) VALUES (3, 'Lillestrom SK', 'Viking FK', 'x', '2', 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `soccerDB`.`Game` (`round`, `inTeam`, `outTeam`, `resultFH`, `resultSH`, `inGoalFH`, `outGoalFH`, `inGoalSH`, `outGoalSH`, `oneCoeff`, `xCoeff`, `twoCoeff`, `oneCoeffFH`, `xCoeffFH`, `twoCoeffFH`) VALUES (3, 'Sandnes Ulf', 'Haugesund', 'x', 'x', 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `soccerDB`.`Game` (`round`, `inTeam`, `outTeam`, `resultFH`, `resultSH`, `inGoalFH`, `outGoalFH`, `inGoalSH`, `outGoalSH`, `oneCoeff`, `xCoeff`, `twoCoeff`, `oneCoeffFH`, `xCoeffFH`, `twoCoeffFH`) VALUES (3, 'Sogndal', 'Rosenborg', 'x', '2', 0, 0, 0, 4, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `soccerDB`.`Game` (`round`, `inTeam`, `outTeam`, `resultFH`, `resultSH`, `inGoalFH`, `outGoalFH`, `inGoalSH`, `outGoalSH`, `oneCoeff`, `xCoeff`, `twoCoeff`, `oneCoeffFH`, `xCoeffFH`, `twoCoeffFH`) VALUES (3, 'Stromsgodset', 'Sarpsborg', 'x', 'x', 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `soccerDB`.`Game` (`round`, `inTeam`, `outTeam`, `resultFH`, `resultSH`, `inGoalFH`, `outGoalFH`, `inGoalSH`, `outGoalSH`, `oneCoeff`, `xCoeff`, `twoCoeff`, `oneCoeffFH`, `xCoeffFH`, `twoCoeffFH`) VALUES (4, 'Rosenborg', 'Start', 'x', 'x', 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `soccerDB`.`Game` (`round`, `inTeam`, `outTeam`, `resultFH`, `resultSH`, `inGoalFH`, `outGoalFH`, `inGoalSH`, `outGoalSH`, `oneCoeff`, `xCoeff`, `twoCoeff`, `oneCoeffFH`, `xCoeffFH`, `twoCoeffFH`) VALUES (4, 'Molde', 'Sogndal', 'x', '2', 0, 0, 1, 2, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `soccerDB`.`Game` (`round`, `inTeam`, `outTeam`, `resultFH`, `resultSH`, `inGoalFH`, `outGoalFH`, `inGoalSH`, `outGoalSH`, `oneCoeff`, `xCoeff`, `twoCoeff`, `oneCoeffFH`, `xCoeffFH`, `twoCoeffFH`) VALUES (4, 'Valerenga', 'Stromsgodset', 'x', '2', 0, 0, 0, 3, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `soccerDB`.`Game` (`round`, `inTeam`, `outTeam`, `resultFH`, `resultSH`, `inGoalFH`, `outGoalFH`, `inGoalSH`, `outGoalSH`, `oneCoeff`, `xCoeff`, `twoCoeff`, `oneCoeffFH`, `xCoeffFH`, `twoCoeffFH`) VALUES (4, 'Honefoss', 'Haugesund', 'x', '2', 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `soccerDB`.`Game` (`round`, `inTeam`, `outTeam`, `resultFH`, `resultSH`, `inGoalFH`, `outGoalFH`, `inGoalSH`, `outGoalSH`, `oneCoeff`, `xCoeff`, `twoCoeff`, `oneCoeffFH`, `xCoeffFH`, `twoCoeffFH`) VALUES (4, 'Lillestrom SK', 'SK Brann', 'x', '1', 0, 0, 2, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `soccerDB`.`Game` (`round`, `inTeam`, `outTeam`, `resultFH`, `resultSH`, `inGoalFH`, `outGoalFH`, `inGoalSH`, `outGoalSH`, `oneCoeff`, `xCoeff`, `twoCoeff`, `oneCoeffFH`, `xCoeffFH`, `twoCoeffFH`) VALUES (4, 'Tromso IL', 'Sandnes Ulf', 'x', '2', 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `soccerDB`.`Game` (`round`, `inTeam`, `outTeam`, `resultFH`, `resultSH`, `inGoalFH`, `outGoalFH`, `inGoalSH`, `outGoalSH`, `oneCoeff`, `xCoeff`, `twoCoeff`, `oneCoeffFH`, `xCoeffFH`, `twoCoeffFH`) VALUES (4, 'Viking FK', 'Odd Grenland', 'x', '1', 0, 0, 1, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `soccerDB`.`Game` (`round`, `inTeam`, `outTeam`, `resultFH`, `resultSH`, `inGoalFH`, `outGoalFH`, `inGoalSH`, `outGoalSH`, `oneCoeff`, `xCoeff`, `twoCoeff`, `oneCoeffFH`, `xCoeffFH`, `twoCoeffFH`) VALUES (4, 'Sarpsborg', 'Aalesunds FK', 'x', '2', 0, 0, 0, 2, NULL, NULL, NULL, NULL, NULL, NULL);

COMMIT;
