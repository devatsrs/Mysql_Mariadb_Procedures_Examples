DROP PROCEDURE IF EXISTS `prc_Debug`;
DELIMITER //
CREATE PROCEDURE `prc_Debug`(
	IN `p_JobID` INT,
   	IN `Text` TEXT
)
BEGIN

INSERT INTO prc_WSGenerateRateTable_debug (JobID,query ) SELECT p_JobID, Text;

END//
DELIMITER ;
