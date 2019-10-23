DROP PROCEDURE IF EXISTS `prc_InsertIntoRateSearchCode`;
DELIMITER //
CREATE PROCEDURE `prc_InsertIntoRateSearchCode`(
	IN `p_CompanyID` INT,
   	IN `p_CodedeckID` INT,
   	IN `p_Code` VARCHAR(50)

)
BEGIN

		SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

        SET @p_CompanyID                 = p_CompanyID;
        SET @p_CodedeckID                = p_CodedeckID;
        SET @p_Code                      = p_Code;

        DROP TEMPORARY TABLE IF EXISTS tmp_codedecks;
        CREATE TEMPORARY TABLE tmp_codedecks (
            ID int auto_increment,
            CodeDeckID int,
            primary key (ID)
        );



        SET @v_TerminationType = (SELECT RateTypeID from tblRateType where Slug = 'voicecall');

		insert into tmp_codedecks (CodeDeckID) select CodeDeckID from tblCodeDeck where CompanyID = @p_CompanyID AND CodeDeckID =  @p_CodedeckID AND Type = @v_TerminationType;

		SET @v_rowCount_ = ( SELECT COUNT(*) FROM tmp_codedecks );
        SET @v_pointer_ = 1;

        WHILE @v_pointer_ <= @v_rowCount_
        DO

			SET @p_codedeckID = ( SELECT CodeDeckID FROM tmp_codedecks WHERE ID = @v_pointer_ );

            DROP TEMPORARY TABLE IF EXISTS tmp_codes;
            CREATE TEMPORARY TABLE tmp_codes (
                ID int auto_increment,
                Code VARCHAR(50),
                primary key (ID)
            );
            
            -- delete codes which are not exits in selected codedeck.
            delete  rsc from tblRateSearchCode rsc
            left join tblRate r on rsc.CompanyID = r.CompanyID AND rsc.CodeDeckId = r.CodeDeckId and rsc.RowCodeRateID = r.RateID
            where rsc.CompanyID = @p_CompanyID  and (fn_IsEmpty(@p_Code) OR @p_Code = r.Code ) and rsc.CodeDeckId = @p_codedeckID AND r.RateID is null;

            -- collect codes which are not exits in tblRateSearchCode
            insert into tmp_codes ( Code )
            select distinct r.Code from tblRate  r
            left join tblRateSearchCode rsc on r.CompanyID = rsc.CompanyID and r.RateID = rsc.RowCodeRateID AND r.CodeDeckId = rsc.CodeDeckId  AND rsc.CodeDeckId = @p_codedeckID
            WHERE r.CompanyID = @p_CompanyID  and (fn_IsEmpty(@p_Code) OR @p_Code = r.Code ) and r.CodeDeckId = @p_codedeckID AND rsc.RateSearchCodeID is null;

            select count(*) into @v_row_count from tmp_codes ;

			IF @v_row_count  > 0 THEN

                        
                        SET @v_v_pointer_ = 1;
                        SET @v_limit = 50000;   -- loop of 50 K 
                        SET @v_v_rowCount_ = ceil(@v_row_count/@v_limit) ;

                        WHILE @v_v_pointer_ <= @v_v_rowCount_
                        DO

                            SET @v_OffSet_ = (@v_v_pointer_ * @v_limit) - @v_limit;

                            SET @stm_query = CONCAT("
                                    insert IGNORE into tblRateSearchCode (CompanyID, CountryID, RowCodeRateID,RowCode,Code,CodeRateID,CodedeckID)
                                    SELECT distinct  ", @p_CompanyID  , " as CompanyID , tr1.CountryID, tr2.RateID as RowCodeRateID, f.Code as RowCode,   LEFT(f.Code, x.RowNo) as loopCode , tr1.RateID as CodeRateID ,", @p_codedeckID  , " as CodedeckID
                                    FROM (
                                            SELECT @RowNo  := @RowNo + 1 as RowNo
                                            FROM mysql.help_category
                                                ,(SELECT @RowNo := 0 ) x
                                            limit 15
                                        ) x
                                        
                                        INNER JOIN (
                                                select distinct Code from tmp_codes limit " , @v_limit , "  OFFSET " ,   @v_OffSet_ , "
                                        ) AS f ON x.RowNo   <= LENGTH(f.Code)

                                        INNER JOIN tblRate as tr1 on tr1.CodeDeckId = @p_codedeckID AND LEFT(f.Code, x.RowNo) = tr1.Code
                                        INNER JOIN tblRate as tr2 on tr1.CodeDeckId = @p_codedeckID AND f.Code  = tr2.Code

                                    order by RowCode desc,  LENGTH(loopCode) DESC
                                    ");

                        PREPARE stm_query FROM @stm_query;
                        EXECUTE stm_query;
                        DEALLOCATE PREPARE stm_query;

                        SET @v_v_pointer_ = @v_v_pointer_ + 1;

                    END WHILE;


            end if;

            SET @v_pointer_ = @v_pointer_ + 1;

        END WHILE;


		SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;
