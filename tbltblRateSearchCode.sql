CREATE TABLE `tblRateSearchCode` (
	`RateSearchCodeID` INT(11) NOT NULL AUTO_INCREMENT,
	`CodedeckID` INT(11) NOT NULL,
	`CompanyID` INT(11) NOT NULL,
	`RowNo` INT(11) NOT NULL,
	`RowCode` VARCHAR(50) NOT NULL COLLATE 'utf8_unicode_ci',
	`Code` VARCHAR(50) NOT NULL COLLATE 'utf8_unicode_ci',
	PRIMARY KEY (`RateSearchCodeID`),
	INDEX `RowCode` (`RowCode`)
)
COLLATE='utf8_unicode_ci'
ENGINE=InnoDB;


----------------------------------------------------------------------------------------------------------------
tblRateSearchCode
----------------------------------------------------------------------------------------------------------------
RowNo    RowCode     Code        x Description             CodedeckID 
----------------------------------------------------------------------------------------------------------------
  1      9124        9124        India-Fixed              1
  2      9124        912         India-Fixed              1
  3      9124        91          India-Fixed              1
----------------------------------------------------------------------------------------------------------------
  1      9124843     9124843     India-Fixed-Mobile       1
  2      9124843     912484      India-Fixed-Mobile       1
  3      9124843     91248       India-Fixed-Mobile       1
  4      9124843     9124        India-Fixed-Mobile       1
  5      9124843     912         India-Fixed-Mobile       1
  6      9124843     91          India-Fixed-Mobile       1
----------------------------------------------------------------------------------------------------------------
  1      912         912         India-Landline           1
  2      912         91          India-Landline           1
----------------------------------------------------------------------------------------------------------------
  1      91          91          India                    1
----------------------------------------------------------------------------------------------------------------



-------------------  NEW QUERY LCR ----------------------------------
IF (@p_ShowAllVendorCodes = 1) THEN

    insert into tmp_search_code_ (RowCode,Code)
        SELECT  DISTINCT rsc.RowCode, rsc.Code FROM tbltblRateSearchCode rsc
        INNER JOIN tblRate r on r.Code = rsc.RowCode AND 
        WHERE r.CompanyID = @p_companyid      -- no codedeck condition.
            AND
            (
                (
                    ( CHAR_LENGTH(RTRIM(@p_code)) = 0  OR r.Code LIKE REPLACE(@p_code,'*', '%') )
                    AND ( @p_Description = ''  OR r.Description LIKE REPLACE(@p_Description,'*', '%') )
                )
                
            )
       order by Code   desc;

ELSE

    insert into tmp_search_code_ ( RowCode, Code )
        SELECT  DISTINCT RowCode , Code  FROM tbltblRateSearchCode
        INNER JOIN tblRate r on r.Code = rsc.RowCode 
        WHERE r.CompanyID = @p_companyid  AND r.CodeDeckId = @p_codedeckID    -- codedeck condition.
            AND
            (
                (
                    ( CHAR_LENGTH(RTRIM(@p_code)) = 0  OR r.Code LIKE REPLACE(@p_code,'*', '%') )
                    AND ( @p_Description = ''  OR r.Description LIKE REPLACE(@p_Description,'*', '%') )
                )
                
            )
        order by Code   desc;

END IF;

IF @p_ShowAllVendorCodes = 1 THEN

   -- can use same tmp_search_code_ table instead of tmp_all_code_ .


    /*insert into tmp_all_code_ (RowCode,Code,RowNo)
        select RowCode , loopCode,RowNo
        from (
                        select   RowCode , loopCode,
                            @RowNo := ( CASE WHEN ( @prev_Code = tbl1.RowCode  ) THEN @RowNo + 1
                                                    ELSE 1
                                                    END

                            )      as RowNo,
                            @prev_Code := tbl1.RowCode
                        from (
                                    SELECT distinct f.Code as RowCode, LEFT(f.Code, x.RowNo) as loopCode FROM (
                                            SELECT @RowNo  := @RowNo + 1 as RowNo
                                            FROM mysql.help_category
                                                ,(SELECT @RowNo := 0 ) x
                                            limit 15
                                        ) x
                                        INNER JOIN tmp_search_code_ AS f
                                            ON  x.RowNo   <= LENGTH(f.Code)
                                                    
                                        
                                    order by RowCode desc,  LENGTH(loopCode) DESC
                                ) tbl1
                            , ( Select @RowNo := 0 ) x
                    ) tbl order by RowCode desc,  LENGTH(loopCode) DESC ;
    */

ELSE
   -- can use same tmp_search_code_ table instead of tmp_all_code_ .

    /* insert into tmp_all_code_ (RowCode,Code,RowNo)
        select RowCode , loopCode,RowNo
        from (
                        select   RowCode , loopCode,
                            @RowNo := ( CASE WHEN ( @prev_Code = tbl1.RowCode  ) THEN @RowNo + 1
                                                    ELSE 1
                                                    END

                            )      as RowNo,
                            @prev_Code := tbl1.RowCode
                        from (
                                    SELECT distinct f.Code as RowCode, LEFT(f.Code, x.RowNo) as loopCode FROM (
                                            SELECT @RowNo  := @RowNo + 1 as RowNo
                                            FROM mysql.help_category
                                                ,(SELECT @RowNo := 0 ) x
                                            limit 15
                                        ) x
                                        INNER JOIN tmp_search_code_ AS f
                                            ON  x.RowNo   <= LENGTH(f.Code)
                                                    AND
                                                    (
                                                        (
                                                            ( CHAR_LENGTH(RTRIM(@p_code)) = 0  OR f.Code LIKE REPLACE(@p_code,'*', '%') )
                                                        )

                                                    )
                                        INNER JOIN tblRate as tr on  tr.CodeDeckId = @p_codedeckID AND f.Code=tr.Code 
                                        INNER JOIN tblRate as tr1 on tr1.CodeDeckId = @p_codedeckID AND LEFT(f.Code, x.RowNo) = tr1.Code

                                    order by RowCode desc,  LENGTH(loopCode) DESC
                                ) tbl1
                            , ( Select @RowNo := 0 ) x
                    ) tbl order by RowCode desc,  LENGTH(loopCode) DESC ;
    */
    
END IF;


-- new RG Query 
insert into tmp_code_ ( RowCode, Code )
SELECT DISTINCT RowCode , Code
from tbltblRateSearchCode rsc
JOIN tmp_Raterules_ rr
    ON   ( fn_IsEmpty(rr.code) OR (rsc.Code LIKE (REPLACE(rr.code,'*', '%%')) ))
            AND
    ( fn_IsEmpty(rr.DestinationType)  OR ( rsc.`Type` = rr.DestinationType ))
            AND
    ( fn_IsEmpty(rr.DestinationCountryID) OR (rsc.`CountryID` = rr.DestinationCountryID ))
where  rsc.CodeDeckId = @v_codedeckid_
	order by Code,RowCode   desc;


		insert into tmp_code_origination
			SELECT tblRate.code
				FROM tblRate
				JOIN tmp_Raterules_ rr
					ON ( fn_IsEmpty(rr.OriginationCode) OR  (tblRate.Code LIKE (REPLACE(rr.OriginationCode,'*', '%%'))) )
							AND
						( fn_IsEmpty(rr.OriginationType) OR ( tblRate.`Type` = rr.OriginationType ))
								AND
						( fn_IsEmpty(rr.OriginationCountryID) OR (tblRate.`CountryID` = rr.OriginationCountryID ))
			 where  tblRate.CodeDeckId = @v_codedeckid_
			Order by tblRate.code ;


-------------------  OLD LCR QUERY ----------------------------------

IF (@p_ShowAllVendorCodes = 1) THEN

    insert into tmp_search_code_
        SELECT  DISTINCT LEFT(f.Code, x.RowNo) as loopCode FROM (
                    SELECT @RowNo  := @RowNo + 1 as RowNo
                    FROM mysql.help_category
                        ,(SELECT @RowNo := 0 ) x
                    limit 15
                ) x

            INNER JOIN (
                                        SELECT distinct Code , Description from tblRate
                                        WHERE CompanyID = @p_companyid 
                                                    AND
                                                    (
                                                        (
                                                            ( CHAR_LENGTH(RTRIM(@p_code)) = 0  OR Code LIKE REPLACE(@p_code,'*', '%') )
                                                            AND ( @p_Description = ''  OR Description LIKE REPLACE(@p_Description,'*', '%') )
                                                        )
                                                        
                                                    )
                                    ) f
                ON x.RowNo   <= LENGTH(f.Code) 
        order by loopCode   desc;


ELSE

    insert into tmp_search_code_
        SELECT  DISTINCT LEFT(f.Code, x.RowNo) as loopCode FROM (
                SELECT @RowNo  := @RowNo + 1 as RowNo
                FROM mysql.help_category
                    ,(SELECT @RowNo := 0 ) x
                limit 15
            ) x
            INNER JOIN tblRate AS f
                ON f.CompanyID = @p_companyid  AND f.CodeDeckId = @p_codedeckID 

                        AND
                        (
                            (
                                ( CHAR_LENGTH(RTRIM(@p_code)) = 0  OR f.Code LIKE REPLACE(@p_code,'*', '%') )
                                AND ( fn_IsEmpty(@p_Description) OR f.Description LIKE REPLACE(@p_Description,'*', '%') )
                            )
                            
                        )
                        AND x.RowNo   <= LENGTH(f.Code)

        order by loopCode   desc;

END IF;




IF @p_ShowAllVendorCodes = 1 THEN

    insert into tmp_all_code_ (RowCode,Code,RowNo)
        select RowCode , loopCode,RowNo
        from (
                        select   RowCode , loopCode,
                            @RowNo := ( CASE WHEN ( @prev_Code = tbl1.RowCode  ) THEN @RowNo + 1
                                                    ELSE 1
                                                    END

                            )      as RowNo,
                            @prev_Code := tbl1.RowCode
                        from (
                                    SELECT distinct f.Code as RowCode, LEFT(f.Code, x.RowNo) as loopCode FROM (
                                            SELECT @RowNo  := @RowNo + 1 as RowNo
                                            FROM mysql.help_category
                                                ,(SELECT @RowNo := 0 ) x
                                            limit 15
                                        ) x
                                        INNER JOIN tmp_search_code_ AS f
                                            ON  x.RowNo   <= LENGTH(f.Code)
                                                    
                                        
                                    order by RowCode desc,  LENGTH(loopCode) DESC
                                ) tbl1
                            , ( Select @RowNo := 0 ) x
                    ) tbl order by RowCode desc,  LENGTH(loopCode) DESC ;


ELSE

    insert into tmp_all_code_ (RowCode,Code,RowNo)
        select RowCode , loopCode,RowNo
        from (
                        select   RowCode , loopCode,
                            @RowNo := ( CASE WHEN ( @prev_Code = tbl1.RowCode  ) THEN @RowNo + 1
                                                    ELSE 1
                                                    END

                            )      as RowNo,
                            @prev_Code := tbl1.RowCode
                        from (
                                    SELECT distinct f.Code as RowCode, LEFT(f.Code, x.RowNo) as loopCode FROM (
                                            SELECT @RowNo  := @RowNo + 1 as RowNo
                                            FROM mysql.help_category
                                                ,(SELECT @RowNo := 0 ) x
                                            limit 15
                                        ) x
                                        INNER JOIN tmp_search_code_ AS f
                                            ON  x.RowNo   <= LENGTH(f.Code)
                                                    AND
                                                    (
                                                        (
                                                            ( CHAR_LENGTH(RTRIM(@p_code)) = 0  OR f.Code LIKE REPLACE(@p_code,'*', '%') )
                                                        )

                                                    )
                                        INNER JOIN tblRate as tr on  tr.CodeDeckId = @p_codedeckID AND f.Code=tr.Code 
                                        INNER JOIN tblRate as tr1 on tr1.CodeDeckId = @p_codedeckID AND LEFT(f.Code, x.RowNo) = tr1.Code

                                    order by RowCode desc,  LENGTH(loopCode) DESC
                                ) tbl1
                            , ( Select @RowNo := 0 ) x
                    ) tbl order by RowCode desc,  LENGTH(loopCode) DESC ;

END IF;

----------------------------- RG OLD Query 

		insert into tmp_code_
			SELECT  DISTINCT LEFT(f.Code, x.RowNo) as loopCode
			FROM (
						 SELECT @RowNo  := @RowNo + 1 as RowNo
						 FROM mysql.help_category
							 ,(SELECT @RowNo := 0 ) x
						 limit 15
					 ) x
				INNER JOIN
				(
					SELECT
					 distinct
					 tblRate.code
				 FROM tblRate
					 JOIN tmp_Raterules_ rr
						 ON   ( fn_IsEmpty(rr.code) OR (tblRate.Code LIKE (REPLACE(rr.code,'*', '%%')) ))
									AND
						    ( fn_IsEmpty(rr.DestinationType)  OR ( tblRate.`Type` = rr.DestinationType ))
									AND
						    ( fn_IsEmpty(rr.DestinationCountryID) OR (tblRate.`CountryID` = rr.DestinationCountryID ))
				 where  tblRate.CodeDeckId = @v_codedeckid_
				 					

				 Order by tblRate.code

				) as f
				ON   x.RowNo   <= LENGTH(f.Code) AND f.Code = LEFT(f.Code, x.RowNo) -- Added 14-06-19
			order by loopCode   desc;


		insert into tmp_code_origination
			SELECT tblRate.code
				FROM tblRate
				JOIN tmp_Raterules_ rr
					ON ( fn_IsEmpty(rr.OriginationCode) OR  (tblRate.Code LIKE (REPLACE(rr.OriginationCode,'*', '%%'))) )
							AND
						( fn_IsEmpty(rr.OriginationType) OR ( tblRate.`Type` = rr.OriginationType ))
								AND
						( fn_IsEmpty(rr.OriginationCountryID) OR (tblRate.`CountryID` = rr.OriginationCountryID ))
			 where  tblRate.CodeDeckId = @v_codedeckid_
			Order by tblRate.code ;
