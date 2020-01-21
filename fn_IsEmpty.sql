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
DROP FUNCTION IF EXISTS `fn_IsEmpty`;
DELIMITER //
CREATE FUNCTION `fn_IsEmpty`(
	`p_Value` TEXT
	
) RETURNS TINYINT
BEGIN

SET @v_isNumber =  if(p_Value REGEXP '^[+-]?[0-9]*([0-9]\\.|[0-9]|\\.[0-9])[0-9]*(e[+-]?[0-9]+)?$' ,1,0);

/*
col1   |  casted | isNumeric
-------|---------|----------
00.00  |       0 |         1
+1     |       1 |         1
.123   |   0.123 |         1
-.23e4 |   -2300 |         1
12.e-5 | 0.00012 |         1
3.5e+6 | 3500000 |         1
a      |       0 |         0
e6     |       0 |         0
+e0    |       0 |         0

*/
IF ( p_Value IS NULL OR trim(p_Value) = '' OR  (@v_isNumber = 1 and  p_Value = 0) OR p_Value = '0' ) THEN 
    RETURN 1;
END IF;

 RETURN 0;
 
END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
