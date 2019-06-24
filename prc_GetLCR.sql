use speakintelligentRM;
-- --------------------------------------------------------
-- Host:                         78.129.140.6
-- Server version:               5.7.25 - MySQL Community Server (GPL)
-- Server OS:                    Linux
-- HeidiSQL Version:             9.5.0.5196
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Dumping structure for procedure speakintelligentRM.prc_GetLCR
DROP PROCEDURE IF EXISTS `prc_GetLCR`;
DELIMITER //
CREATE PROCEDURE `prc_GetLCR`(
	IN `p_companyid` INT,
	IN `p_trunkID` INT,
	IN `p_TimezonesID` VARCHAR(50),
	IN `p_codedeckID` INT,
	IN `p_CurrencyID` INT,
	IN `p_Originationcode` VARCHAR(50),
	IN `p_OriginationDescription` VARCHAR(250),
	IN `p_code` VARCHAR(50),
	IN `p_Description` VARCHAR(250),
	IN `p_AccountIds` TEXT,
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_SortOrder` VARCHAR(50),
	IN `p_Preference` INT,
	IN `p_Position` INT,
	IN `p_vendor_block` INT,
	IN `p_groupby` VARCHAR(50),
	IN `p_SelectedEffectiveDate` DATE,
	IN `p_ShowAllVendorCodes` INT,
	IN `p_merge_timezones` INT,
	IN `p_TakePrice` INT,
	IN `p_isExport` INT





































)
ThisSP:BEGIN


        SET @p_companyid                    = p_companyid;
        SET @p_trunkID                      = p_trunkID;
        SET @p_TimezonesID                  = p_TimezonesID;
        SET @p_codedeckID                   = p_codedeckID;
        SET @p_CurrencyID                   = p_CurrencyID;
        SET @p_Originationcode              = p_Originationcode;
        SET @p_OriginationDescription       = p_OriginationDescription;
        SET @p_code                         = p_code;
        SET @p_Description                  = p_Description;
        SET @p_AccountIds                   = p_AccountIds;
        SET @p_PageNumber                   = p_PageNumber;
        SET @p_RowspPage                    = p_RowspPage;
        SET @p_SortOrder                    = p_SortOrder;
        SET @p_Preference                   = p_Preference;
        SET @p_Position                     = p_Position;
        SET @p_vendor_block                 = p_vendor_block;
        SET @p_groupby                      = p_groupby;
        SET @p_SelectedEffectiveDate        = p_SelectedEffectiveDate;
        SET @p_ShowAllVendorCodes           = p_ShowAllVendorCodes;
        SET @p_merge_timezones              = p_merge_timezones;
        SET @p_TakePrice                    = p_TakePrice;
        SET @p_isExport                     = p_isExport;



        SET	@v_RateTypeID = 1;	-- //1 - Termination 2 - DID 3 - Package
        set @v_AppliedToCustomer = 1; 
        set @v_AppliedToVendor = 2; 
        set @v_AppliedToReseller = 3; 



		SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

		SET @@session.collation_connection='utf8_unicode_ci';
		SET @@session.character_set_results='utf8';



		SET @v_OffSet_ = (@p_PageNumber * @p_RowspPage) - @p_RowspPage;

 		DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_stage_;
		CREATE TEMPORARY TABLE tmp_VendorRate_stage_ (
			RateTableRateID int,
			RowCode VARCHAR(50) ,
			VendorConnectionID INT ,
			Blocked INT DEFAULT 0,
			VendorConnectionName VARCHAR(100) ,
			OriginationCode VARCHAR(50) ,
			Code VARCHAR(50) ,
			Rate DECIMAL(18,8) ,
			ConnectionFee DECIMAL(18,8) ,
			EffectiveDate DATETIME ,
			OriginationDescription VARCHAR(255),
			Description VARCHAR(255),
			Preference INT,
			MaxMatchRank int ,
			prev_OriginationCode VARCHAR(255),
			prev_RowCode VARCHAR(50),
			prev_VendorConnectionID int
		)
		;

		DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_stage2_;
		CREATE TEMPORARY TABLE tmp_VendorRate_stage2_ (
			RateTableRateID int,
			
			RowCode VARCHAR(50) ,
			VendorConnectionID INT ,
			Blocked INT DEFAULT 0,
			VendorConnectionName VARCHAR(100) ,
			OriginationCode VARCHAR(50) ,
			Code VARCHAR(50) ,
			Rate DECIMAL(18,8) ,
			ConnectionFee DECIMAL(18,8) ,
			EffectiveDate DATETIME ,
			OriginationDescription VARCHAR(255),
			Description VARCHAR(255),
			Preference INT,
			MaxMatchRank int ,
			prev_prev_RowCode VARCHAR(50),
			prev_VendorConnectionID int
		)
		;

		DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_;
		CREATE TEMPORARY TABLE tmp_VendorRate_ (
			RateTableRateID int,
			
			VendorConnectionID INT ,
			Blocked INT DEFAULT 0,
			VendorConnectionName VARCHAR(100) ,
			OriginationCode VARCHAR(50) ,
			Code VARCHAR(50) ,
			Rate DECIMAL(18,8) ,
			ConnectionFee DECIMAL(18,8) ,
			EffectiveDate DATETIME ,
			OriginationDescription VARCHAR(255),
			Description VARCHAR(255),
			Preference INT,
			RowCode VARCHAR(50)
		)
		;

		DROP TEMPORARY TABLE IF EXISTS tmp_final_VendorRate_;
		CREATE TEMPORARY TABLE tmp_final_VendorRate_ (
			RateTableRateID int,
			
			VendorConnectionID INT ,
			Blocked INT DEFAULT 0,
			VendorConnectionName VARCHAR(100) ,
			OriginationCode VARCHAR(50) ,
			Code VARCHAR(50) ,
			Rate DECIMAL(18,8) ,
			ConnectionFee DECIMAL(18,8) ,
			EffectiveDate DATETIME ,
			OriginationDescription VARCHAR(255),
			Description VARCHAR(255),
			Preference INT,
			RowCode VARCHAR(50),
			FinalRankNumber int
		)
		;



		DROP TEMPORARY TABLE IF EXISTS tmp_search_code_;
		CREATE TEMPORARY TABLE tmp_search_code_ (
			Code  varchar(50),
			INDEX Index1 (Code)
		);



		DROP TEMPORARY TABLE IF EXISTS tmp_search_code_dup;
		CREATE TEMPORARY TABLE tmp_search_code_dup (
			Code  varchar(50),
			INDEX Index1 (Code)
		);



		DROP TEMPORARY TABLE IF EXISTS tmp_code_;
		CREATE TEMPORARY TABLE tmp_code_ (
			RowCode  varchar(50),
			Code  varchar(50),
			RowNo int,
			INDEX Index1 (Code)
		);


		DROP TEMPORARY TABLE IF EXISTS tmp_all_code_;
		CREATE TEMPORARY TABLE tmp_all_code_ (
			RowCode  varchar(50),
			Code  varchar(50),
			RowNo int,
			INDEX Index2 (Code)
		);

		DROP TEMPORARY TABLE IF EXISTS tmp_all_code_dup;
		CREATE TEMPORARY TABLE tmp_all_code_dup (
			RowCode  varchar(50),
			Code  varchar(50),
			RowNo int,
			INDEX Index2 (Code)
		);


		DROP TEMPORARY TABLE IF EXISTS tmp_VendorCurrentRates_;
		CREATE TEMPORARY TABLE IF NOT EXISTS tmp_VendorCurrentRates_(
			RateTableRateID int,
			
			VendorConnectionID int,
			Blocked INT DEFAULT 0,
			VendorConnectionName varchar(200),
			OriginationCode varchar(50),
			Code varchar(50),
			OriginationDescription varchar(200),
			Description varchar(200),
			Rate DECIMAL(18,8) ,
			ConnectionFee DECIMAL(18,8) ,
			EffectiveDate date,
			TrunkID int,
			CountryID int,
			RateID int,
			Preference int,
			INDEX IX_Code (Code)
		)
		;

		DROP TEMPORARY TABLE IF EXISTS tmp_VendorCurrentRates1_;
		CREATE TEMPORARY TABLE IF NOT EXISTS tmp_VendorCurrentRates1_(
			RateTableRateID int,
			
			VendorConnectionID int,
			Blocked INT DEFAULT 0,
			VendorConnectionName varchar(200),
			OriginationCode varchar(50),
			Code varchar(50),
			OriginationDescription varchar(200),
			Description varchar(200),
			Rate DECIMAL(18,8) ,
			ConnectionFee DECIMAL(18,8) ,
			EffectiveDate date,
			TrunkID int,
			CountryID int,
			OriginationRateID int,
			RateID int,
			Preference int,
			INDEX IX_Code (Code),
			INDEX tmp_VendorCurrentRates_VendorConnectionID (`VendorConnectionID`,`TrunkID`,`RateId`,`EffectiveDate`)
		)
		;

		DROP TEMPORARY TABLE IF EXISTS tmp_VendorRateByRank_;
		CREATE TEMPORARY TABLE tmp_VendorRateByRank_ (
			RateTableRateID int,
			
			VendorConnectionID INT ,
			Blocked INT DEFAULT 0,
			VendorConnectionName VARCHAR(100) ,
			OriginationCode VARCHAR(50) ,
			Code VARCHAR(50) ,
			Rate DECIMAL(18,8) ,
			ConnectionFee DECIMAL(18,8) ,
			EffectiveDate DATETIME ,
			OriginationDescription VARCHAR(255),
			Description VARCHAR(255),
			Preference INT,
			rankname INT,
			INDEX IX_Code (Code,rankname)
		);

		SELECT CurrencyId INTO @v_CompanyCurrencyID_ FROM  tblCompany WHERE CompanyID = @p_companyid;


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
						ON x.RowNo   <= LENGTH(f.Code) and  f.Code = LEFT(f.Code, x.RowNo) -- Added 14-06-19
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
						ON f.CompanyID = @p_companyid  AND f.CodeDeckId = @p_codedeckID and f.Code = LEFT(f.Code, x.RowNo) -- Added 14-06-19

							 AND
							 (
								 (
									 ( CHAR_LENGTH(RTRIM(@p_code)) = 0  OR f.Code LIKE REPLACE(@p_code,'*', '%') )
									 AND ( @p_Description = ''  OR f.Description LIKE REPLACE(@p_Description,'*', '%') )
								 )
								 
							 )
							 AND x.RowNo   <= LENGTH(f.Code)

				order by loopCode   desc;

		END IF;


		insert into tmp_search_code_dup select * from tmp_search_code_;

		SET @num := 0, @VendorConnectionID := '', @TrunkID := '', @RateID := '';

		SET @stm_show_all_vendor_codes1 = CONCAT("INNER JOIN (SELECT Code,Description FROM tblRate WHERE CodeDeckId=",@p_codedeckID,") tmpselectedcd ON tmpselectedcd.Code=tblRate.Code");
		SET @stm_show_all_vendor_codes2 = CONCAT('( CHAR_LENGTH(RTRIM("',@p_code,'")) = 0 OR tblRate.Code LIKE REPLACE("',@p_code,'","*", "%") )
													AND ("',@p_Description,'"="" OR tblRate.Description LIKE REPLACE("',@p_Description,'","*","%"))
													AND ');




		SET @stm_filter_oringation_code = CONCAT('INNER JOIN tblRate r2 ON r2.CompanyID = ',@p_companyid,' AND tblRateTableRate.OriginationRateID = r2.RateID
		INNER JOIN tmp_search_code_dup SplitCode2 ON r2.Code = SplitCode2.Code
						AND ( CHAR_LENGTH(RTRIM("',@p_Originationcode,'")) = 0 OR r2.Code LIKE REPLACE("',@p_Originationcode,'","*", "%") )
						AND ( "',@p_OriginationDescription,'"=""  OR r2.Description LIKE REPLACE("',@p_OriginationDescription,'","*", "%") )
				');




		SET @stm = CONCAT('
			INSERT INTO tmp_VendorCurrentRates1_
			',
											IF (@p_merge_timezones = 1,"
				Select DISTINCT
					RateTableRateID,

					VendorConnectionID,
					Blocked,
					VendorConnectionName,
					OriginationCode,
					Code,
					OriginationDescription,
					Description,
					Rate,
					ConnectionFee,
					EffectiveDate,
					TrunkID,
					CountryID,
					OriginationRateID,
					RateID,
					Preference
				FROM (
			",""),'

				Select DISTINCT
					RateTableRateID,

					VendorConnectionID,
					Blocked,
					VendorConnectionName,
					OriginationCode,
					Code,
					OriginationDescription,
					Description,
					Rate,
					ConnectionFee,
					EffectiveDate,
					TrunkID,
					CountryID,
					OriginationRateID,
					RateID,
					Preference
					',IF (@p_merge_timezones = 1,",
						@num := if(@VendorConnectionID = VendorConnectionID AND @TrunkID = TrunkID AND @RateID = RateID, @num + 1, 1) as row_number,
						@VendorConnectionID := VendorConnectionID,
						@TrunkID := TrunkID,
						@RateID := RateID
					",""),'
				FROM (
					 SELECT distinct
						RateTableRateID,

						vt.VendorConnectionID,
						tblRateTableRate.Blocked,
						vt.Name as VendorConnectionName,
						IFNULL(r2.Code,"") as OriginationCode,
						tblRate.Code,
						IFNULL(r2.Description,"") as OriginationDescription ,
						tblRate.Description,
						CASE WHEN  tblRateTableRate.RateCurrency IS NOT NULL 
                        THEN
                            CASE WHEN  tblRateTableRate.RateCurrency = ',@p_CurrencyID,'
                            THEN
                                tblRateTableRate.Rate
                            ELSE
                            (
                                -- Convert to base currrncy and x by RateGenerator Exhange
                                (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = ',@p_CurrencyID,' and  CompanyID = ',@p_companyid,' )
                                * (tblRateTableRate.rate  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = tblRateTableRate.RateCurrency and  CompanyID = ',@p_companyid,' ))
                            )
                            END
                        ELSE 
                            (
                                (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = ',@p_CurrencyID,' and  CompanyID = ',@p_companyid,' )
                                * (tblRateTableRate.rate  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = ',@v_CompanyCurrencyID_,' and  CompanyID = ',@p_companyid,' ))
                            )
                        END    
                        as Rate,
						CASE WHEN  tblRateTableRate.RateCurrency IS NOT NULL 
                        THEN
                            CASE WHEN  tblRateTableRate.RateCurrency = ',@p_CurrencyID,'
                            THEN
                                tblRateTableRate.ConnectionFee
                            ELSE
                            (
                                -- Convert to base currrncy and x by RateGenerator Exhange
                                (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = ',@p_CurrencyID,' and  CompanyID = ',@p_companyid,' )
                                * (tblRateTableRate.ConnectionFee  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = tblRateTableRate.RateCurrency and  CompanyID = ',@p_companyid,' ))
                            )
                            END
                        ELSE 
                            (
                                (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = ',@p_CurrencyID,' and  CompanyID = ',@p_companyid,' )
                                * (tblRateTableRate.ConnectionFee  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = ',@v_CompanyCurrencyID_,' and  CompanyID = ',@p_companyid,' ))
                            )
                        END    
                        as ConnectionFee,
						DATE_FORMAT (tblRateTableRate.EffectiveDate, "%Y-%m-%d") AS EffectiveDate, 
                        vt.TrunkID, 
                        tblRate.CountryID,
						r2.RateID as OriginationRateID,
						tblRate.RateID,
                        IFNULL(Preference, 5) AS Preference
					FROM
						tblRateTableRate
                    INNER JOIN tblRateTable ON tblRateTable.RateTableID = tblRateTableRate.RateTableID AND  tblRateTable.CompanyID = ',@p_companyid,' AND tblRateTable.Type = @v_RateTypeID AND tblRateTable.AppliedTo = @v_AppliedToVendor
					INNER JOIN tblVendorConnection vt ON vt.CompanyID = ',@p_companyid,' and vt.RateTableID = tblRateTableRate.RateTableID  and vt.RateTypeID = 1   and vt.Active = 1 and vt.TrunkID = ',@p_trunkID,'
					INNER JOIN tblAccount ON tblAccount.AccountID = vt.AccountId AND  tblAccount.CompanyID = ',@p_companyid,' AND vt.AccountId = tblAccount.AccountID
					INNER JOIN tblRate ON tblRate.CompanyID = ',@p_companyid,' AND tblRateTableRate.RateId = tblRate.RateID -- AND vt.CodeDeckId = tblRate.CodeDeckId


					',
											IF (@p_ShowAllVendorCodes = 1,"",@stm_show_all_vendor_codes1)
		,'

						LEFT JOIN tblRate r2 ON r2.CompanyID = ',@p_companyid,' AND tblRateTableRate.OriginationRateID = r2.RateID
						LEFT JOIN tmp_search_code_dup SplitCode2 ON r2.Code = SplitCode2.Code

					WHERE
						',
        		IF (@p_ShowAllVendorCodes = 1,@stm_show_all_vendor_codes2,"")
		,'
						( EffectiveDate <= DATE("',@p_SelectedEffectiveDate,'") )

						AND ( CHAR_LENGTH(RTRIM("',@p_Originationcode,'")) = 0 OR r2.Code LIKE REPLACE("',@p_Originationcode,'","*", "%") )
						AND ( "',@p_OriginationDescription,'"=""  OR r2.Description LIKE REPLACE("',@p_OriginationDescription,'","*", "%") )


						AND ( "',@p_Originationcode,'" = ""  OR  ( r2.RateID IS NOT NULL  ) )
						AND ( "',@p_OriginationDescription,'" = ""  OR  ( r2.RateID IS NOT NULL  ) )


						AND ( tblRateTableRate.EndDate IS NULL OR  tblRateTableRate.EndDate > Now() )   -- rate should not end Today
						AND ("',@p_AccountIds,'"="" OR FIND_IN_SET(tblAccount.AccountID,"',@p_AccountIds,'") != 0 )
						AND tblAccount.IsVendor = 1
						AND tblAccount.Status = 1
						AND (
							(',@p_merge_timezones,' = 0 AND tblRateTableRate.TimezonesID = "',@p_TimezonesID,'") OR
							(',@p_merge_timezones,' = 1 AND FIND_IN_SET(tblRateTableRate.TimezonesID, "',@p_TimezonesID,'"))
						)
                        AND
						(
							(',@p_vendor_block,' = 1 )
							OR
							(',@p_vendor_block,' = 0 AND tblRateTableRate.Blocked = 0	)
						)					',
											IF (@p_merge_timezones = 1,CONCAT("ORDER BY VendorConnectionID, TrunkID, RateID, Rate ",IF(@p_TakePrice=1,"DESC","ASC")),"")
		,'
				) tbl
			',
											IF (@p_merge_timezones = 1,") AS x WHERE x.row_number <= 1","")
		,'
			;
		');




		PREPARE stmt FROM @stm;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;



		

		IF @p_groupby = 'description' THEN

			INSERT INTO tmp_VendorCurrentRates_
				Select max(RateTableRateID),max(VendorConnectionID),max(Blocked),max(VendorConnectionName),max(OriginationCode),max(Code),OriginationDescription,Description, MAX(Rate),max(ConnectionFee),max(EffectiveDate),max(TrunkID),max(CountryID),max(RateID),max(Preference)
				FROM (

							 SELECT * ,
								 @row_num := IF(@prev_RateTableRateID = RateTableRateID AND @prev_VendorConnectionID = VendorConnectionID AND @prev_TrunkID = TrunkID AND @prev_OriginationDescription = OriginationDescription AND @prev_Description = Description AND @prev_EffectiveDate >= EffectiveDate, @row_num + 1, 1) AS RowID,
								 @prev_RateTableRateID := RateTableRateID,
								 @prev_VendorConnectionID := VendorConnectionID,
								 @prev_TrunkID := TrunkID,
								 @prev_OriginationDescription := OriginationDescription,
								 @prev_Description := Description,
								 @prev_EffectiveDate := EffectiveDate
							 FROM tmp_VendorCurrentRates1_
								 ,(SELECT @row_num := 1, @prev_RateTableRateID := '', @prev_VendorConnectionID := '',@prev_TrunkID := '', @prev_OriginationDescription := '', @prev_Description := '', @prev_OriginationRateID := '',@prev_RateId := '', @prev_EffectiveDate := '') x

							 ORDER BY VendorConnectionID, TrunkID, OriginationDescription,Description, EffectiveDate DESC
						 ) tbl
				WHERE RowID = 1
				group BY VendorConnectionID, TrunkID, OriginationDescription,Description
			;

		ELSE

			INSERT INTO tmp_VendorCurrentRates_
				Select RateTableRateID,VendorConnectionID,Blocked,VendorConnectionName,OriginationCode,Code,OriginationDescription,Description, Rate,ConnectionFee,EffectiveDate,TrunkID,CountryID,RateID,Preference
				FROM (
							 SELECT * ,
								 @row_num := IF(@prev_RateTableRateID = RateTableRateID AND @prev_VendorConnectionID = VendorConnectionID AND @prev_TrunkID = TrunkID AND @prev_OriginationRateID = OriginationRateID AND  @prev_RateId = RateID AND @prev_EffectiveDate >= EffectiveDate, @row_num + 1, 1) AS RowID,
								 @prev_RateTableRateID := RateTableRateID,
								 @prev_VendorConnectionID := VendorConnectionID,
								 @prev_TrunkID := TrunkID,
								 @prev_OriginationRateID := OriginationRateID,
								 @prev_RateId := RateID,
								 @prev_EffectiveDate := EffectiveDate
							 FROM tmp_VendorCurrentRates1_
								 ,(SELECT @row_num := 1, @prev_RateTableRateID := '',  @prev_VendorConnectionID := '',@prev_TrunkID := '', @prev_OriginationRateID := '', @prev_RateId := '', @prev_EffectiveDate := '') x
							 ORDER BY VendorConnectionID, TrunkID, OriginationRateID,RateId, EffectiveDate , RateTableRateID DESC
						 ) tbl
				WHERE RowID = 1
			;

		END IF;

		-- delete codes not exits in tmp_VendorCurrentRates_
		delete s from tmp_search_code_ s
		left join  tmp_VendorCurrentRates_ v on s.Code = v.Code 
		where v.Code is null;


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





		IF @p_Preference = 1 THEN



			INSERT IGNORE INTO tmp_VendorRateByRank_
				SELECT
					RateTableRateID,

					VendorConnectionID,
					Blocked,
					VendorConnectionName,
					OriginationCode,
					Code,
					Rate,
					ConnectionFee,
					EffectiveDate,
					OriginationDescription,
					Description,
					Preference,
					preference_rank
				FROM (SELECT
								RateTableRateID,

								VendorConnectionID,
								Blocked,
								VendorConnectionName,
								OriginationCode,
								Code,
								Rate,
								ConnectionFee,
								EffectiveDate,
								OriginationDescription,
								Description,
								Preference,
								CASE WHEN @p_groupby = 'description' THEN
									@preference_rank := 			CASE WHEN (@prev_OriginationDescription = OriginationDescription AND @prev_Description     = Description AND @prev_Preference > Preference  ) THEN @preference_rank + 1
																					 WHEN (@prev_OriginationDescription = OriginationDescription AND @prev_Description     = Description AND @prev_Preference = Preference AND @prev_Rate < Rate) THEN @preference_rank + 1
																					 WHEN (@prev_OriginationDescription = OriginationDescription AND @prev_Description    = Description AND @prev_Preference = Preference AND @prev_Rate = Rate) THEN @preference_rank
																					 ELSE 1
																					 END
								ELSE
									@preference_rank := 		   CASE WHEN (@prev_OriginationCode    = OriginationCode AND @prev_Code     = Code AND @prev_Preference > Preference  ) THEN @preference_rank + 1
																						WHEN (@prev_OriginationCode    = OriginationCode AND @prev_Code     = Code AND @prev_Preference = Preference AND @prev_Rate < Rate) THEN @preference_rank + 1
																						WHEN (@prev_OriginationCode    = OriginationCode AND @prev_Code    = Code AND @prev_Preference = Preference AND @prev_Rate = Rate) THEN @preference_rank
																						ELSE 1
																						END
								END AS preference_rank,

								@prev_OriginationCode := OriginationCode,
								@prev_Code := Code,
								@prev_OriginationDescription := OriginationDescription ,
								@prev_Description := Description,
								@prev_Preference := IFNULL(Preference, 5),
								@prev_Rate := Rate
							FROM tmp_VendorCurrentRates_ AS preference,
								(SELECT @preference_rank := 0 , @prev_OriginationCode := '', @prev_Code := ''  , @prev_OriginationDescription := '' , @prev_Description := ''  , @prev_Preference := 5,  @prev_Rate := 0) x
							ORDER BY
								CASE WHEN @p_groupby = 'description' THEN
									preference.OriginationDescription
								ELSE
									preference.OriginationCode
								END ,

								CASE WHEN @p_groupby = 'description' THEN
									preference.Description
								ELSE
									preference.Code
								END ASC ,
								preference.Preference DESC, preference.Rate ASC,preference.VendorConnectionID ASC
						 ) tbl
				WHERE (@p_isExport = 1 OR @p_isExport = 2) OR (@p_isExport = 0 AND preference_rank <= @p_Position)
			;

		ELSE



			INSERT IGNORE INTO tmp_VendorRateByRank_
				SELECT
					RateTableRateID,

					VendorConnectionID,
					Blocked,
					VendorConnectionName,
					OriginationCode,
					Code,
					Rate,
					ConnectionFee,
					EffectiveDate,
					OriginationDescription,
					Description,
					Preference,
					RateRank
				FROM (SELECT
								RateTableRateID,

								VendorConnectionID,
								Blocked,
								VendorConnectionName,
								OriginationCode,
								Code,
								Rate,
								ConnectionFee,
								EffectiveDate,
								OriginationDescription,
								Description,
								Preference,
								CASE WHEN @p_groupby = 'description' THEN
									@rank := 	CASE WHEN (@prev_OriginationDescription = OriginationDescription AND  @prev_Description    = Description AND @prev_Rate < Rate) THEN @rank + 1
														WHEN (@prev_OriginationDescription = OriginationDescription AND  @prev_Description    = Description AND @prev_Rate = Rate) THEN @rank
														ELSE 1
														END
								ELSE
									@rank :=    CASE WHEN (@prev_OriginationCode    = OriginationCode AND  @prev_Code    = Code AND @prev_Rate < Rate) THEN @rank + 1
															WHEN (@prev_OriginationCode    = OriginationCode AND  @prev_Code    = Code AND @prev_Rate = Rate) THEN @rank
															ELSE 1
															END
								END
									AS RateRank,
								@prev_OriginationCode := OriginationCode,
								@prev_Code := Code,
								@prev_OriginationDescription := OriginationDescription ,
								@prev_Description := Description,
								@prev_Rate := Rate
							FROM tmp_VendorCurrentRates_ AS rank,
								(SELECT @rank := 0 , @prev_Code := '' ,  @prev_OriginationDescription := ''  ,@prev_OriginationCode := ''  , @prev_Description := '' , @prev_Rate := 0) f
							ORDER BY
								CASE WHEN @p_groupby = 'description' THEN
									rank.OriginationDescription
								ELSE
									rank.OriginationCode
								END ,
								CASE WHEN @p_groupby = 'description' THEN
									rank.Description
								ELSE
									rank.Code
								END ,
								rank.Rate,rank.VendorConnectionID

						 ) tbl
				WHERE (@p_isExport = 1 OR @p_isExport = 2) OR (@p_isExport = 0 AND RateRank <= @p_Position)
			;

		END IF;





		DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_stage_1;
		CREATE TEMPORARY TABLE IF NOT EXISTS tmp_VendorRate_stage_1 as (select * from tmp_VendorRate_stage_);


		IF @p_ShowAllVendorCodes = 1 THEN

			insert ignore into tmp_VendorRate_stage_1 (
				RateTableRateID,
				RowCode,
				OriginationDescription ,
				Description ,
				VendorConnectionID ,
				Blocked,
				VendorConnectionName ,
				OriginationCode ,
				Code ,
				Rate ,
				ConnectionFee,
				EffectiveDate ,
				Preference
			)
				SELECT
					distinct
					RateTableRateID,
					RowCode,
					IFNULL(OriginationDescription,'') ,
					Description ,
					VendorConnectionID ,
					Blocked,
					VendorConnectionName ,
					IFNULL(OriginationCode,'') ,
					Code ,
					Rate ,
					ConnectionFee,
					EffectiveDate ,
					Preference

				from (
							 select
								 RateTableRateID,

								 CASE WHEN (tr.Code is not null OR tr.Code like concat(v.Code,'%')) THEN
									 tr.Code
								 ELSE
									 v.Code
								 END 	as RowCode,
								 CASE WHEN (tr1.Code is not null OR tr1.Code like concat(v.OriginationCode,'%')) THEN
									 tr1.Description
								 ELSE
									 concat(v.OriginationDescription,'*')
								 END
											as OriginationDescription,
								 CASE WHEN (tr.Code is not null OR tr.Code like concat(v.Code,'%')) THEN
									 tr.Description
								 ELSE
									 concat(v.Description,'*')
								 END
											as Description,
								 v.VendorConnectionID ,
								 v.Blocked,
								 v.VendorConnectionName ,
								 v.OriginationCode ,
								 v.Code ,
								 v.Rate ,
								 v.ConnectionFee,
								 v.EffectiveDate ,
								 v.Preference
							 FROM tmp_VendorRateByRank_ v

								 left join  tmp_all_code_ 		SplitCode   on v.Code = SplitCode.Code
								 left join  tmp_all_code_dup 	SplitCode2  on v.OriginationCode != '' AND v.OriginationCode = SplitCode2.Code

								 LEFT JOIN (	select Code,Description from tblRate where CodeDeckId=@p_codedeckID
													AND
													(
														(
															( CHAR_LENGTH(RTRIM(@p_code)) = 0  OR Code LIKE REPLACE(@p_code,'*', '%') )
															AND ( @p_Description = ''  OR Description LIKE REPLACE(@p_Description,'*', '%') )
														)

													)

								) tr on tr.Code=SplitCode.Code

								 LEFT JOIN (	select Code,Description from tblRate where CodeDeckId=@p_codedeckID
											AND
											(
												(

													( CHAR_LENGTH(RTRIM(@p_Originationcode)) = 0  OR Code LIKE REPLACE(@p_Originationcode,'*', '%') )
													AND ( @p_OriginationDescription = ''  OR Description LIKE REPLACE(@p_OriginationDescription,'*', '%') )

												)
											)

								) tr1 on tr1.Code=SplitCode2.Code


							 where  SplitCode.Code is not null AND  (@p_isExport = 1 OR @p_isExport = 2  OR (@p_isExport = 0 AND rankname <= @p_Position))

						 ) tmp
			;

		ELSE

			insert ignore into tmp_VendorRate_stage_1 (
				RateTableRateID,

				RowCode,
				VendorConnectionID ,
				Blocked,
				VendorConnectionName ,
				OriginationCode ,
				Code ,
				Rate ,
				ConnectionFee,
				EffectiveDate ,
				OriginationDescription ,
				Description ,
				Preference
			)
				SELECT
					distinct
					RateTableRateID,
					SplitCode.RowCode,
					v.VendorConnectionID ,
					Blocked,
					v.VendorConnectionName ,
					IFNULL(v.OriginationCode,''),
					v.Code,
					v.Rate,
					v.ConnectionFee,
					v.EffectiveDate,
					IFNULL(tr1.Description,'') as OriginationDescription,
					tr.Description,
					v.Preference

				FROM tmp_VendorRateByRank_ v

				left join  tmp_all_code_ 		SplitCode   on v.Code = SplitCode.Code
				left join  tmp_all_code_dup 	SplitCode2  on v.OriginationCode != '' AND v.OriginationCode = SplitCode2.Code

				LEFT JOIN (	select Code,Description from tblRate where CodeDeckId=@p_codedeckID
								AND
								(
									(
										( CHAR_LENGTH(RTRIM(@p_code)) = 0  OR Code LIKE REPLACE(@p_code,'*', '%') )
										AND ( @p_Description = ''  OR Description LIKE REPLACE(@p_Description,'*', '%') )
									)

								)

				) tr on tr.Code=SplitCode.Code

					LEFT JOIN (	select Code,Description from tblRate where CodeDeckId=@p_codedeckID
							AND
							(
								(

									( CHAR_LENGTH(RTRIM(@p_Originationcode)) = 0  OR Code LIKE REPLACE(@p_Originationcode,'*', '%') )
									AND ( @p_OriginationDescription = ''  OR Description LIKE REPLACE(@p_OriginationDescription,'*', '%') )

								)
							)

			) tr1 on tr1.Code=SplitCode2.Code
				where  SplitCode.Code is not null and ((@p_isExport = 1  OR @p_isExport = 2) OR (@p_isExport = 0 AND rankname <= @p_Position))

			;

		END IF;

		insert ignore into tmp_VendorRate_stage_
			SELECT
				RateTableRateID,
				RowCode,
				v.VendorConnectionID ,
				Blocked,
				v.VendorConnectionName ,
				v.OriginationCode ,
				v.Code ,
				v.Rate ,
				v.ConnectionFee,
				v.EffectiveDate ,
				v.OriginationDescription,
				v.Description,
				v.Preference,
				@rank := ( CASE WHEN(@prev_OriginationCode = OriginationCode and @prev_RowCode = RowCode  AND @prev_VendorConnectionID = v.VendorConnectionID     )
					THEN  @rank + 1
									 ELSE 1
									 END
				) AS MaxMatchRank,
				@prev_OriginationCode := v.OriginationCode,
				@prev_RowCode := RowCode	 ,
				@prev_VendorConnectionID := v.VendorConnectionID

			FROM tmp_VendorRate_stage_1 v
				, (SELECT  @prev_OriginationCode := NUll , @prev_RowCode := '',  @rank := 0 , @prev_Code := '' , @prev_VendorConnectionID := Null) f
			order by  RowCode ,OriginationCode,VendorConnectionID , Code desc ;


		IF @p_groupby = 'description' THEN

			insert ignore into tmp_VendorRate_
				select
					distinct
					max(RateTableRateID),

					VendorConnectionID ,
					max(Blocked) ,
					max(VendorConnectionName) ,
					max(OriginationCode) ,
					max(Code) ,
					max(Rate) ,
					max(ConnectionFee),
					max(EffectiveDate) ,
					OriginationDescription ,
					Description ,
					max(Preference),
					max(RowCode)
				from tmp_VendorRate_stage_
				where MaxMatchRank = 1
				group by VendorConnectionID,OriginationDescription,Description
			;

		ELSE

			insert ignore into tmp_VendorRate_
				select
					distinct
					RateTableRateID,

					VendorConnectionID ,
					Blocked,
					VendorConnectionName ,
					OriginationCode ,
					Code ,
					Rate ,
					ConnectionFee,
					EffectiveDate ,
					OriginationDescription ,
					Description ,
					Preference,
					RowCode
				from tmp_VendorRate_stage_
				where MaxMatchRank = 1
			;
		END IF;






		IF( @p_Preference = 0 )
		THEN

			IF @p_groupby = 'description' THEN


				insert into tmp_final_VendorRate_
					SELECT
						RateTableRateID,
						VendorConnectionID ,
						Blocked,
						VendorConnectionName ,
						OriginationCode ,
						Code ,
						Rate ,
						ConnectionFee,
						EffectiveDate ,
						OriginationDescription ,
						Description ,
						Preference,
						RowCode,
						FinalRankNumber
					from
						(
							SELECT
								RateTableRateID,

								VendorConnectionID ,
								Blocked,
								VendorConnectionName ,
								OriginationCode ,
								Code ,
								Rate ,
								ConnectionFee,
								EffectiveDate ,
								OriginationDescription ,
								Description ,
								Preference,
								RowCode,
								@rank := CASE WHEN (@prev_OriginationDescription = OriginationDescription AND @prev_Description    = Description AND  @prev_Rate <  Rate ) THEN @rank+1
												 WHEN (@prev_OriginationDescription = OriginationDescription AND @prev_Description    = Description AND  @prev_Rate = Rate ) THEN @rank
												 ELSE
													 1
												 END
									AS FinalRankNumber,
								@prev_OriginationDescription := OriginationDescription ,
								@prev_Description  := Description,
								@prev_Rate  := Rate
							from tmp_VendorRate_
								,( SELECT @rank := 0 , @prev_OriginationDescription := ''  , @prev_Description := '' , @prev_Rate := 0 ) x
							order by OriginationDescription,Description,Rate,VendorConnectionID ASC

						) tbl1
					where
						(@p_isExport = 1  OR @p_isExport = 2) OR (@p_isExport = 0 AND FinalRankNumber <= @p_Position);
			ELSE


				insert into tmp_final_VendorRate_
					SELECT
						RateTableRateID,

						VendorConnectionID ,
						Blocked,
						VendorConnectionName ,
						OriginationCode ,
						Code ,
						Rate ,
						ConnectionFee,
						EffectiveDate ,
						OriginationDescription ,
						Description ,
						Preference,
						RowCode,
						FinalRankNumber
					from
						(
							SELECT
								RateTableRateID,

								VendorConnectionID ,
								Blocked,
								VendorConnectionName ,
								OriginationCode ,
								Code ,
								Rate ,
								ConnectionFee,
								EffectiveDate ,
								OriginationDescription ,
								Description ,
								Preference,
								RowCode,
								@rank := CASE WHEN ( @prev_OriginationCode    = OriginationCode AND  @prev_RowCode     = RowCode AND @prev_Rate <  Rate ) THEN @rank+1
												 WHEN (@prev_OriginationCode    = OriginationCode AND   @prev_RowCode    = RowCode AND @prev_Rate = Rate ) THEN @rank
												 ELSE
													 1
												 END
									AS FinalRankNumber,
								@prev_OriginationCode  := OriginationCode,
								@prev_RowCode  := RowCode,
								@prev_Rate  := Rate
							from tmp_VendorRate_
								,( SELECT @rank := 0 , @prev_RowCode := '' , @prev_Rate := 0 ) x
							order by OriginationCode,RowCode,Rate,VendorConnectionID ASC

						) tbl1
					where
						(@p_isExport = 1  OR @p_isExport = 2) OR (@p_isExport = 0 AND FinalRankNumber <= @p_Position);

			END IF;

		ELSE

			IF @p_groupby = 'description' THEN

				insert into tmp_final_VendorRate_
					SELECT
						RateTableRateID,

						VendorConnectionID ,
						Blocked,
						VendorConnectionName ,
						OriginationCode ,
						Code ,
						Rate ,
						ConnectionFee,
						EffectiveDate ,
						OriginationDescription ,
						Description ,
						Preference,
						RowCode,
						FinalRankNumber
					from
						(
							SELECT
								RateTableRateID,

								VendorConnectionID ,
								Blocked,
								VendorConnectionName ,
								OriginationCode ,
								Code ,
								Rate ,
								ConnectionFee,
								EffectiveDate ,
								OriginationDescription ,
								Description ,
								Preference,
								RowCode,
								@preference_rank := CASE WHEN (@prev_OriginationDescription    = OriginationDescription AND @prev_Description     = Description AND @prev_Preference > Preference  )   THEN @preference_rank + 1
																		WHEN (@prev_OriginationDescription    = OriginationDescription AND @prev_Description     = Description AND @prev_Preference = Preference AND @prev_Rate < Rate) THEN @preference_rank + 1
																		WHEN (@prev_OriginationDescription    = OriginationDescription AND @prev_Description    = Description AND @prev_Preference = Preference AND @prev_Rate = Rate) THEN @preference_rank
																		ELSE 1 END AS FinalRankNumber,
								@prev_OriginationDescription := OriginationDescription,
								@prev_Description := Description,
								@prev_Preference := Preference,
								@prev_Rate := Rate
							from tmp_VendorRate_
								,(SELECT @preference_rank := 0 , @prev_OriginationDescription := ''  ,  @prev_Description := ''  , @prev_Preference := 5,  @prev_Rate := 0) x
							order by OriginationDescription,Description ASC ,Preference DESC ,Rate ASC ,VendorConnectionID ASC

						) tbl1
					where
						(@p_isExport = 1  OR @p_isExport = 2 ) OR (@p_isExport = 0 AND FinalRankNumber <= @p_Position);
			ELSE

				insert into tmp_final_VendorRate_
					SELECT
						RateTableRateID,

						VendorConnectionID ,
						Blocked,
						VendorConnectionName ,
						OriginationCode ,
						Code ,
						Rate ,
						ConnectionFee,
						EffectiveDate ,
						OriginationDescription ,
						Description ,
						Preference,
						RowCode,
						FinalRankNumber
					from
						(
							SELECT
								RateTableRateID,

								VendorConnectionID ,
								Blocked,
								VendorConnectionName ,
								OriginationCode ,
								Code ,
								Rate ,
								ConnectionFee,
								EffectiveDate ,
								OriginationDescription ,
								Description ,
								Preference,
								RowCode,
								@preference_rank := CASE WHEN (@prev_OriginationCode    = OriginationCode AND  @prev_Code     = RowCode AND @prev_Preference > Preference  )   THEN @preference_rank + 1
																		WHEN (@prev_OriginationCode    = OriginationCode AND  @prev_Code     = RowCode AND @prev_Preference = Preference AND @prev_Rate < Rate) THEN @preference_rank + 1
																		WHEN (@prev_OriginationCode    = OriginationCode AND  @prev_Code    = RowCode AND @prev_Preference = Preference AND @prev_Rate = Rate) THEN @preference_rank
																		ELSE 1 END AS FinalRankNumber,
								@prev_OriginationCode := OriginationCode,
								@prev_Code := RowCode,
								@prev_Preference := Preference,
								@prev_Rate := Rate
							from tmp_VendorRate_
								,(SELECT @preference_rank := 0 , @prev_OriginationCode := ''  , @prev_Code := ''  , @prev_Preference := 5,  @prev_Rate := 0) x
							order by OriginationCode,RowCode ASC ,Preference DESC ,Rate ASC ,VendorConnectionID  ASC

						) tbl1
					where
						(@p_isExport = 1  OR @p_isExport = 2 ) OR (@p_isExport = 0 AND FinalRankNumber <= @p_Position);
			END IF;

		END IF;


		SET @stm_columns = "";


		IF @p_isExport = 0 AND @p_Position > 10 THEN
			SET @p_Position = 10;
		END IF;



		
		IF @p_isExport = 2
		THEN

			IF @p_groupby = 'description' THEN

				SELECT
					distinct
					ANY_VALUE(RateTableRateID) as RateTableRateID,
					ANY_VALUE(VendorConnectionID) as VendorConnectionID,
					ANY_VALUE(Blocked) as Blocked,
					ANY_VALUE(VendorConnectionName) as VendorConnectionName,
					ANY_VALUE(OriginationCode) as OriginationCode,
					ANY_VALUE(Code) as Code,
					ANY_VALUE(Rate) as Rate,
					ANY_VALUE(ConnectionFee) as ConnectionFee,
					ANY_VALUE(EffectiveDate ) as EffectiveDate,
					OriginationDescription as OriginationDescription,
					Description as Description,
					ANY_VALUE(Preference) as Preference,
					ANY_VALUE(RowCode) as RowCode,
					ANY_VALUE(FinalRankNumber) as FinalRankNumber
				from tmp_final_VendorRate_
				GROUP BY  OriginationDescription,Description ORDER BY OriginationDescription,Description ASC;


			ELSE


				SELECT
					distinct
					ANY_VALUE(RateTableRateID) as RateTableRateID,
					ANY_VALUE(VendorConnectionID) as VendorConnectionID,
					ANY_VALUE(Blocked) as Blocked,
					ANY_VALUE(VendorConnectionName) as VendorConnectionName,
					OriginationCode as OriginationCode,
					ANY_VALUE(Code) as Code,
					ANY_VALUE(Rate) as Rate,
					ANY_VALUE(ConnectionFee) as ConnectionFee,
					ANY_VALUE(EffectiveDate ) as EffectiveDate,
					ANY_VALUE(OriginationDescription) as OriginationDescription,
					ANY_VALUE(Description) as Description,
					ANY_VALUE(Preference) as Preference,
					RowCode as RowCode,
					ANY_VALUE(FinalRankNumber) as FinalRankNumber
				from tmp_final_VendorRate_
				GROUP BY  OriginationCode,RowCode ORDER BY OriginationCode,RowCode ASC;


			END IF;


		ELSE

			


			IF @p_isExport = 1  OR @p_isExport = 2 THEN
				SELECT MAX(FinalRankNumber) INTO @p_Position FROM tmp_final_VendorRate_;
			END IF;



			SET @v_pointer_=1;
			WHILE @v_pointer_ <= @p_Position
			DO

				IF (@p_isExport = 0)
				THEN
					SET @stm_columns = CONCAT(@stm_columns, "GROUP_CONCAT(if(ANY_VALUE(FinalRankNumber) = ",@v_pointer_,", CONCAT(ANY_VALUE(OriginationCode), '<br>', ANY_VALUE(OriginationDescription), '<br>',ANY_VALUE(Code), '<br>', ANY_VALUE(Description), '<br>', ANY_VALUE(Rate), '<br>', ANY_VALUE(VendorConnectionName), '<br>', DATE_FORMAT (ANY_VALUE(EffectiveDate), '%d/%m/%Y'),'', '=', ANY_VALUE(RateTableRateID), '-', ANY_VALUE(VendorConnectionID), '-', ANY_VALUE(Code), '-', ANY_VALUE(Blocked) , '-', ANY_VALUE(Preference)  ), NULL)) AS `POSITION ",@v_pointer_,"`,");
				ELSE
					SET @stm_columns = CONCAT(@stm_columns, "GROUP_CONCAT(if(ANY_VALUE(FinalRankNumber) = ",@v_pointer_,", CONCAT(ANY_VALUE(Code), '<br>', ANY_VALUE(Description), '<br>', ANY_VALUE(Rate), '<br>', ANY_VALUE(VendorConnectionName), '<br>', DATE_FORMAT (ANY_VALUE(EffectiveDate), '%d/%m/%Y')), NULL))  AS `POSITION ",@v_pointer_,"`,");
				END IF;

				SET @v_pointer_ = @v_pointer_ + 1;

			END WHILE;

			SET @stm_columns = TRIM(TRAILING ',' FROM @stm_columns);



			IF (@p_isExport = 0)
			THEN

				IF @p_groupby = 'description' THEN

					SET @stm_query = CONCAT("SELECT CONCAT(OriginationDescription , ' <br> => ' , Description) as Destination,",@stm_columns," FROM tmp_final_VendorRate_  GROUP BY  OriginationDescription,Description ORDER BY OriginationDescription, Description ASC LIMIT ",@p_RowspPage," OFFSET ",@v_OffSet_," ;");

						select count(Description) as totalcount from ( SELECT Description from tmp_final_VendorRate_  GROUP BY OriginationDescription,Description ) tmp ;

				ELSE

					SET @stm_query = CONCAT("SELECT CONCAT(OriginationCode , ' : ' , ANY_VALUE(OriginationDescription), ' <br> => '  , RowCode , ' : ' , ANY_VALUE(Description)) as Destination,", @stm_columns," FROM tmp_final_VendorRate_  GROUP BY  OriginationCode,RowCode ORDER BY OriginationCode,RowCode ASC LIMIT ",@p_RowspPage," OFFSET ",@v_OffSet_," ;");

						select count(RowCode) as totalcount from ( SELECT RowCode from tmp_final_VendorRate_ GROUP BY OriginationCode, RowCode) tmp;

				END IF;


			END IF;

			IF @p_isExport = 1
			THEN

				IF @p_groupby = 'description' THEN

					SET @stm_query = CONCAT("SELECT CONCAT(OriginationDescription , '  => ' , Description) as Destination,",@stm_columns," FROM tmp_final_VendorRate_   GROUP BY  OriginationDescription,Description ORDER BY Description ASC ;");


				ELSE

					SET @stm_query = CONCAT("SELECT CONCAT(OriginationCode , ' : ' , ANY_VALUE(OriginationDescription), '  => '  , RowCode , ' : ' , ANY_VALUE(Description)) as Destination,", @stm_columns," FROM tmp_final_VendorRate_   GROUP BY  OriginationCode,RowCode ORDER BY RowCode ASC;");


				END IF;


			END IF;




			PREPARE stm_query FROM @stm_query;
			EXECUTE stm_query;
			DEALLOCATE PREPARE stm_query;

		END IF;


		SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

	END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
