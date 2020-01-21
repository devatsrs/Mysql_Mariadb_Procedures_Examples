use speakintelligentRM;
-- --------------------------------------------------------
-- Host:                         localhost
-- Server version:               5.7.23-log - MySQL Community Server (GPL)
-- Server OS:                    Win64
-- HeidiSQL Version:             9.5.0.5196
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Dumping structure for function speakintelligentRM.fn_Round
DROP FUNCTION IF EXISTS `fn_Round`;
DELIMITER //
CREATE FUNCTION `fn_Round`(
	`p_Value` DECIMAL(18,10),
	`p_RoundChargedAmount` INT
) RETURNS decimal(18,10)
BEGIN

set @POWER_ = CAST(POWER(10,IFNULL(p_RoundChargedAmount,6)) AS DECIMAL);

RETURN	ROUND((CEIL(p_Value * @POWER_ )/@POWER_ ),IFNULL(p_RoundChargedAmount,6));

END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
