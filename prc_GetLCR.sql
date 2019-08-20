use speakintelligentRM;
DROP PROCEDURE IF EXISTS `prc_GetLCR_TEST`;
DELIMITER //
CREATE PROCEDURE `prc_GetLCR_TEST`(
	IN `p_companyid` INT,
	IN `p_trunkID` INT,
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
	IN `p_SelectedEffectiveDate` DATE,
	IN `p_isExport` INT





































)
ThisSP:BEGIN


        SET @p_companyid                    = p_companyid;
        SET @p_trunkID                      = p_trunkID;
        -- SET @p_TimezonesID                  = p_TimezonesID;
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
        -- SET @p_groupby                      = p_groupby;
        SET @p_SelectedEffectiveDate        = p_SelectedEffectiveDate;
        -- SET @p_ShowAllVendorCodes           = p_ShowAllVendorCodes;
        -- SET @p_merge_timezones              = p_merge_timezones;
        -- SET @p_TakePrice                    = p_TakePrice;
        SET @p_isExport                     = p_isExport;



        SET	@v_RateTypeID = 1;	-- //1 - Termination 2 - DID 3 - Package
        set @v_AppliedToCustomer = 1; 
        set @v_AppliedToVendor = 2; 
        set @v_AppliedToReseller = 3; 


		SET @v_default_TimezonesID = 1; 

		SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

		SET @@session.collation_connection='utf8_unicode_ci';
		SET @@session.character_set_results='utf8';



		SET @v_OffSet_ = (@p_PageNumber * @p_RowspPage) - @p_RowspPage;


		
		DROP TEMPORARY TABLE IF EXISTS tmp_tblAccounts;
		CREATE TEMPORARY TABLE tmp_tblAccounts (
			AccountID INT(11) ,
			RateTableID INT(11) ,
			VendorConnectionID INT(11) ,
			VendorConnectionName VARCHAR(200)
		);


		DROP TEMPORARY TABLE IF EXISTS tmp_tblRateTableRate;
		CREATE TEMPORARY TABLE tmp_tblRateTableRate (
		
			RateTableRateID BIGINT(20),
			VendorConnectionID INT,
			VendorConnectionName VARCHAR(200),
			OriginationRateID BIGINT(20)  ,
			RateID INT(11) ,
			RateTableId BIGINT(20),
			TimezonesID INT(11)  ,
			Rate DECIMAL(18,6)  ,
			RateN DECIMAL(18,6) ,
			ConnectionFee DECIMAL(18,6)  ,
			EffectiveDate DATE ,
			EndDate DATE   ,
			Interval1 INT(11)  ,
			IntervalN INT(11)  ,
			MinimumDuration INT(11),
			Preference INT(11)   ,
			Blocked TINYINT(4) ,
			RateCurrency INT(11)   ,
			ConnectionFeeCurrency INT(11)  ,

			INDEX Index1 (OriginationRateID),
			INDEX Index2 (RateID)

		);

		DROP TEMPORARY TABLE IF EXISTS tmp_timezones;
		CREATE TEMPORARY TABLE tmp_timezones (
			ID int auto_increment,
			TimezonesID int,
			primary key (ID)
		);

 		DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_stage_;
		CREATE TEMPORARY TABLE tmp_VendorRate_stage_ (
			RateTableRateID int,
			RowCode VARCHAR(50) ,
			VendorConnectionID INT ,
			TimezonesID int,
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
			prev_VendorConnectionID int,
			prev_TimezonesID int,
			INDEX Index1 ( RowCode,TimezonesID,VendorConnectionID ),
			INDEX Index2 ( OriginationCode, Code ),
			INDEX Index3 ( MaxMatchRank )

		);

 		DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_stage_1;
		CREATE TEMPORARY TABLE tmp_VendorRate_stage_1 (
			-- ID INT AUTO_INCREMENT,
			RateTableRateID int,
			RowCode VARCHAR(50) ,
			VendorConnectionID INT ,
			TimezonesID int,
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
			INDEX Index1 (TimezonesID),
			INDEX Index2 (RowCode,TimezonesID,VendorConnectionID , OriginationCode,Code)
			-- INDEX Index3 (RowCode,TimezonesID,VendorConnectionID,OriginationCode,Code)
			
		
		);


 		DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_stage_2;
		CREATE TEMPORARY TABLE tmp_VendorRate_stage_2 (
			-- ID INT AUTO_INCREMENT,
			RateTableRateID int,
			RowCode VARCHAR(50) ,
			VendorConnectionID INT ,
			TimezonesID int,
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
			INDEX Index2 (RowCode,TimezonesID,VendorConnectionID , OriginationCode,Code)
		);

 		DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_stage_1_DEFAULT;
		CREATE TEMPORARY TABLE tmp_VendorRate_stage_1_DEFAULT (
			-- ID INT AUTO_INCREMENT,
			RateTableRateID int,
			RowCode VARCHAR(50) ,
			VendorConnectionID INT ,
			TimezonesID int,
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
			INDEX Index1 (VendorConnectionID),
			INDEX Index2 (OriginationCode,RowCode)
 

		);


 		DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_stage_1_dup;
		CREATE TEMPORARY TABLE tmp_VendorRate_stage_1_dup (
			-- ID INT AUTO_INCREMENT,
			RateTableRateID int,
			RowCode VARCHAR(50) ,
			VendorConnectionID INT ,
			TimezonesID int,
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
			INDEX Index1 (VendorConnectionID),
			INDEX Index2 (OriginationCode,RowCode)
 			
		);

		DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_stage2_;
		CREATE TEMPORARY TABLE tmp_VendorRate_stage2_ (
			RateTableRateID int,
			
			RowCode VARCHAR(50) ,
			VendorConnectionID INT ,
			TimezonesID int,
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
			prev_VendorConnectionID int,
			prev_TimezonesID int			
		);

		DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_;
		CREATE TEMPORARY TABLE tmp_VendorRate_ (
			-- ID INT AUTO_INCREMENT,
			RateTableRateID int,
			VendorConnectionID INT ,
			TimezonesID int,
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

		);

		DROP TEMPORARY TABLE IF EXISTS tmp_final_VendorRate_;
		CREATE TEMPORARY TABLE tmp_final_VendorRate_ (
			RateTableRateID int,
			VendorConnectionID INT ,
			TimezonesID int,
			TimezoneName VARCHAR(100) ,
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
			FinalRankNumber int,
			INDEX Index1 (TimezoneName,OriginationCode,RowCode)

		);

		DROP TEMPORARY TABLE IF EXISTS tmp_search_code_;
		CREATE TEMPORARY TABLE tmp_search_code_ (
			RowCodeRateID  INT,
			CodeRateID  INT,
			Code  varchar(50),
			Description varchar(200),
			RowCode  varchar(50),
			INDEX Index1 (RowCodeRateID),
			INDEX Index2 (CodeRateID),
			INDEX Index3 (Code)


			/*RateID  INT,
			Code  varchar(50),
			Description varchar(200),
			RowCode  varchar(50),
			RateID INT,
			INDEX Index1 (RateID),
			INDEX Index2 (Code)*/
		);



		/*DROP TEMPORARY TABLE IF EXISTS tmp_search_code_dup;
		CREATE TEMPORARY TABLE tmp_search_code_dup (

			RowCodeRateID  INT,
			CodeRateID  INT,
			Code  varchar(50),
			Description varchar(200),
			RowCode  varchar(50),
			INDEX Index1 (RowCodeRateID),
			INDEX Index2 (CodeRateID),
			INDEX Index3 (Code)



			/*RateID  INT,
			Code  varchar(50),
			Description varchar(200),
			RowCode  varchar(50),
			RateID INT,
			INDEX Index1 (RateID),
			INDEX Index2 (Code)*/
		/*);*/

 
		DROP TEMPORARY TABLE IF EXISTS tmp_VendorCurrentRates_;
		CREATE TEMPORARY TABLE IF NOT EXISTS tmp_VendorCurrentRates_(
			RateTableRateID int,
			VendorConnectionID int,
			TimezonesID int,
			Blocked INT DEFAULT 0,
			VendorConnectionName varchar(200),
			OriginationCode varchar(50),
			Code varchar(50),
			OriginationDescription varchar(200),
			Description varchar(200),
			Rate DECIMAL(18,8) ,
			ConnectionFee DECIMAL(18,8) ,
			EffectiveDate date,
			-- TrunkID int,
			-- CountryID int,
			RateID int,
			Preference int,
			INDEX IX_Code (OriginationCode,Code)
		)
		;

		DROP TEMPORARY TABLE IF EXISTS tmp_VendorCurrentRates1_;
		CREATE TEMPORARY TABLE IF NOT EXISTS tmp_VendorCurrentRates1_(
			RateTableRateID int,
			VendorConnectionID int,
			TimezonesID int,
			Blocked INT DEFAULT 0,
			VendorConnectionName varchar(200),
			OriginationCode varchar(50),
			Code varchar(50),
			OriginationRateID int,
			OriginationDescription varchar(200),
			Description varchar(200),
			Rate DECIMAL(18,8) ,
			ConnectionFee DECIMAL(18,8) ,
			EffectiveDate date,
			RateID int,
			Preference int,
			INDEX tmp_VendorCurrentRates_VendorConnectionID ( VendorConnectionID,TimezonesID,OriginationCode,Code, EffectiveDate , RateTableRateID )
		);

		DROP TEMPORARY TABLE IF EXISTS tmp_VendorRateByRank_;
		CREATE TEMPORARY TABLE tmp_VendorRateByRank_ (
			RateTableRateID int,
			VendorConnectionID INT ,
			TimezonesID int,
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


		-- SELECT CurrencyId INTO @v_CompanyCurrencyID_ FROM  tblCompany WHERE CompanyID = @p_companyid;



		-- @Assume : there will be only one termination codedeck amongs all vendors
		insert into tmp_search_code_ ( RowCodeRateID,CodeRateID,Code,Description,RowCode )
		SELECT  DISTINCT rsc.RowCodeRateID, rsc.CodeRateID, rsc.Code ,r.Description, rsc.RowCode
				FROM tblRateSearchCode rsc
				INNER JOIN tblRate r on r.CompanyID = rsc.CompanyID AND r.RateID = rsc.RowCodeRateID AND r.CodeDeckID = rsc.CodeDeckID
				WHERE r.CompanyID = @p_companyid  AND r.CodeDeckId = @p_codedeckID    -- codedeck condition.
					AND
					(
						(
							( CHAR_LENGTH(RTRIM(@p_code)) = 0 OR @p_code = '*'  OR r.Code LIKE REPLACE(@p_code,'*', '%') )
							AND ( @p_Description = ''  OR @p_Description = '*' OR  r.Description LIKE REPLACE(@p_Description,'*', '%') )
						)
						
					);
		-- order by rsc.RowCode, rsc.Code desc;
		
 

		-- insert into tmp_search_code_dup select * from tmp_search_code_;

		SELECT CurrencyId INTO @v_CompanyCurrencyID_ FROM  tblCompany WHERE CompanyID = @p_companyid;

        Select Value INTO @v_DestinationCurrencyConversionRate from tblCurrencyConversion where tblCurrencyConversion.CurrencyId =  @p_CurrencyID  and  CompanyID = @p_companyid;

        Select Value INTO @v_CompanyCurrencyConversionRate from tblCurrencyConversion where tblCurrencyConversion.CurrencyId =  @v_CompanyCurrencyID_  and  CompanyID = @p_companyid;


		-- leave ThisSP;
		-- when search with *
		-- IF fn_IsEmpty(@p_Originationcode) AND @p_code = '*' AND fn_IsEmpty(@p_OriginationDescription) AND fn_IsEmpty(@p_Description)THEN 
			
			INSERT INTO tmp_tblAccounts ( AccountID,RateTableID, VendorConnectionID , VendorConnectionName )
			select distinct vt.AccountId,vt.RateTableID, vt.VendorConnectionID , vt.Name
			from tblVendorConnection vt
        	inner join  tblRateTable ON   tblRateTable.CompanyID = vt.CompanyID  AND  tblRateTable.Type = vt.RateTypeID AND tblRateTable.AppliedTo = @v_AppliedToVendor 
			INNER JOIN tblAccount ON tblAccount.AccountID = vt.AccountId AND  tblAccount.CompanyID = tblRateTable.CompanyID AND vt.AccountId = tblAccount.AccountID
			where 		
			 vt.CompanyID = @p_companyid and vt.RateTypeID = @v_RateTypeID   and vt.Active = 1 and vt.TrunkID = @p_trunkID
  			 AND (fn_IsEmpty(@p_AccountIds) OR FIND_IN_SET(tblAccount.AccountID,@p_AccountIds) != 0 ) AND tblAccount.IsVendor = 1 AND tblAccount.Status = 1;
						 
			
			INSERT INTO tmp_tblRateTableRate ( 
				RateTableRateID,
				VendorConnectionID,
				VendorConnectionName,
				TimezonesID,
				OriginationRateID,
				RateID,
				-- RateTableId,
				Rate,
				-- ConnectionFee,
				EffectiveDate,
				-- EndDate,
				-- Interval1,
				-- IntervalN,
				-- MinimumDuration,
				Preference,
				Blocked
				-- RateCurrency,
				-- ConnectionFeeCurrency
			)
			select RateTableRateID,
				   VendorConnectionID,
				   VendorConnectionName,
				   TimezonesID,
				   OriginationRateID,
				   RateID,
				   -- rtr.RateTableId,
				   -- ConnectionFee,
				   CASE WHEN  rtr.RateCurrency IS NOT NULL 
					THEN
						CASE WHEN  rtr.RateCurrency = @p_CurrencyID
						THEN
							rtr.Rate
						ELSE
						(
							-- Convert to base currrncy and x by RateGenerator Exhange
							(@v_DestinationCurrencyConversionRate  ) *
							 (rtr.rate  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = rtr.RateCurrency and  CompanyID = @p_companyid))
						)
						END
					ELSE 
						(
							( @v_DestinationCurrencyConversionRate ) * ( rtr.rate  / (@v_CompanyCurrencyConversionRate ) )
						)
					END    
					as Rate,
					/*CASE WHEN  rtr.ConnectionFeeCurrency IS NOT NULL 
					THEN
						CASE WHEN  rtr.ConnectionFeeCurrency = @p_CurrencyID
						THEN
							rtr.ConnectionFee
						ELSE
						(
							-- Convert to base currrncy and x by RateGenerator Exhange
							(@v_DestinationCurrencyConversionRate  ) 
							* (rtr.ConnectionFee  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = rtr.ConnectionFeeCurrency and  CompanyID = @p_companyid ))
						)
						END
					ELSE 
						(
							(@v_DestinationCurrencyConversionRate  ) 
							* (rtr.ConnectionFee  / (@v_CompanyCurrencyConversionRate ))
						)
					END    
					as*/
					-- ConnectionFee,
				
				DATE(EffectiveDate) as EffectiveDate, 
				-- EndDate,
				-- Interval1,
				-- IntervalN,
				-- MinimumDuration,
				IFNULL(Preference, 5) AS Preference,
				Blocked
				-- RateCurrency,
				-- ConnectionFeeCurrency 
			
			from tblRateTableRate rtr
			INNER JOIN tmp_tblAccounts a on a.RateTableID = rtr.RateTableID
			where 
						( EffectiveDate <= DATE(@p_SelectedEffectiveDate) )
						AND ( rtr.EndDate IS NULL OR  rtr.EndDate > Now() )   -- rate should not end Today
                        AND
						(
							( @p_vendor_block = 1 )
							OR
							( @p_vendor_block = 0 AND rtr.Blocked = 0	)
						);

			SELECT CurrencyId INTO @v_CompanyCurrencyID_ FROM  tblCompany WHERE CompanyID = @p_companyid;
	        Select Value INTO @v_DestinationCurrencyConversionRate from tblCurrencyConversion where tblCurrencyConversion.CurrencyId =  @p_CurrencyID  and  CompanyID = @p_companyid;
	        Select Value INTO @v_CompanyCurrencyConversionRate from tblCurrencyConversion where tblCurrencyConversion.CurrencyId =  @v_CompanyCurrencyID_  and  CompanyID = @p_companyid;

			INSERT INTO tmp_VendorCurrentRates1_
					(	RateTableRateID,
					VendorConnectionID,
					VendorConnectionName,
					TimezonesID,
					Blocked,
					OriginationRateID,
					OriginationCode,
					Code,
					OriginationDescription,
					Description,
					Rate,
					-- ConnectionFee,
					EffectiveDate,
					RateID,
					Preference	)

					SELECT distinct
					RateTableRateID,
					VendorConnectionID,
					VendorConnectionName,
					TimezonesID,
					Blocked,
					OriginationRateID,
					'' as OriginationCode, -- IFNULL(r2.Code,"") as OriginationCode,
					tblRate.Code,
					'' as OriginationDescription , -- IFNULL(r2.Description,"") as OriginationDescription ,
					tblRate.Description,
					Rate,
					-- ConnectionFee,
					EffectiveDate, 
					tblRate.CodeRateID,
					Preference
					FROM tmp_tblRateTableRate rtr
					INNER JOIN tmp_search_code_ tblRate ON rtr.RateId = tblRate.CodeRateID;

					-- LEFT JOIN tmp_search_code_dup r2 ON rtr.OriginationRateID = r2.RateID
				/* where 
							( fn_IsEmpty(@p_Originationcode)  OR r2.Code LIKE REPLACE(@p_Originationcode,"*", "%") )
						AND ( fn_IsEmpty(@p_OriginationDescription)  OR r2.Description LIKE REPLACE(@p_OriginationDescription,"*", "%") )


						AND ( fn_IsEmpty(@p_Originationcode)  OR  ( r2.Code IS NOT NULL  ) )
						AND ( fn_IsEmpty(@p_OriginationDescription)  OR  ( r2.Code IS NOT NULL  ) );
				*/		


				update tmp_VendorCurrentRates1_ rtr
				INNER JOIN tmp_search_code_ r2 ON rtr.OriginationRateID = r2.CodeRateID
				SET OriginationCode  = r2.Code ,
				OriginationDescription = r2.Description;

		/*ELSE 
			-- Remove this once above code tested
			INSERT INTO tmp_VendorCurrentRates1_
				 
					 SELECT distinct
						RateTableRateID,
						vt.VendorConnectionID,
						tblRateTableRate.TimezonesID,
						tblRateTableRate.Blocked,
						vt.Name as VendorConnectionName,
						IFNULL(r2.Code,"") as OriginationCode,
						tblRate.Code,
						IFNULL(r2.Description,"") as OriginationDescription ,
						tblRate.Description,
						CASE WHEN  tblRateTableRate.RateCurrency IS NOT NULL 
                        THEN
                            CASE WHEN  tblRateTableRate.RateCurrency = @p_CurrencyID
                            THEN
                                tblRateTableRate.Rate
                            ELSE
                            (
                                -- Convert to base currrncy and x by RateGenerator Exhange
                                (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = @p_CurrencyID and  CompanyID = @p_companyid )
                                * (tblRateTableRate.rate  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = tblRateTableRate.RateCurrency and  CompanyID = @p_companyid ))
                            )
                            END
                        ELSE 
                            (
                                (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = @p_CurrencyID and  CompanyID = @p_companyid )
                                * (tblRateTableRate.rate  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = @p_CurrencyID and  CompanyID = @p_companyid ))
                            )
                        END    
                        as Rate,
						CASE WHEN  tblRateTableRate.RateCurrency IS NOT NULL 
                        THEN
                            CASE WHEN  tblRateTableRate.RateCurrency = @p_CurrencyID
                            THEN
                                tblRateTableRate.ConnectionFee
                            ELSE
                            (
                                -- Convert to base currrncy and x by RateGenerator Exhange
                                (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = @p_CurrencyID and  CompanyID = @p_companyid )
                                * (tblRateTableRate.ConnectionFee  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = tblRateTableRate.RateCurrency and  CompanyID = @p_companyid ))
                            )
                            END
                        ELSE 
                            (
                                (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = @p_CurrencyID and  CompanyID = @p_companyid )
                                * (tblRateTableRate.ConnectionFee  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = @p_CurrencyID and  CompanyID = @p_companyid ))
                            )
                        END    
                        as ConnectionFee,
						DATE_FORMAT (tblRateTableRate.EffectiveDate, "%Y-%m-%d") AS EffectiveDate, 
                        vt.TrunkID, 
                        -- tblRate.CountryID,
						-- r2.RateID as OriginationRateID,
						-- tblRate.RateID,
                        IFNULL(Preference, 5) AS Preference
					FROM
						tblRateTableRate
                    INNER JOIN tblRateTable ON tblRateTable.RateTableID = tblRateTableRate.RateTableID AND  tblRateTable.CompanyID = @p_companyid AND tblRateTable.Type = @v_RateTypeID AND tblRateTable.AppliedTo = @v_AppliedToVendor
					INNER JOIN tblVendorConnection vt ON vt.CompanyID = @p_companyid and vt.RateTableID = tblRateTableRate.RateTableID  and vt.RateTypeID = 1   and vt.Active = 1 and vt.TrunkID = @p_trunkID
					INNER JOIN tblAccount ON tblAccount.AccountID = vt.AccountId AND  tblAccount.CompanyID = @p_companyid AND vt.AccountId = tblAccount.AccountID
					INNER JOIN tmp_search_code_ tblRate ON tblRateTableRate.RateId = tblRate.CodeRateID
					LEFT JOIN tmp_search_code_dup r2 ON tblRateTableRate.OriginationRateID = r2.RateID

					
					-- INNER JOIN tblRate ON tblRate.CompanyID = @p_companyid AND  tblRate.CodeDeckId = @p_codedeckID  AND tblRateTableRate.RateId = tblRate.RateID -- AND vt.CodeDeckId = tblRate.CodeDeckId
					-- INNER JOIN ( select distinct Code from tmp_search_code_ ) SplitCode ON tblRate.Code = SplitCode.Code
					-- INNER JOIN tmp_search_code_ SplitCode ON tblRate.Code = SplitCode.Code
					
					-- LEFT JOIN tblRate r2 ON r2.CompanyID = @p_companyid AND  r2.CodeDeckId = @p_codedeckID  AND tblRateTableRate.OriginationRateID = r2.RateID

					WHERE
						
						( EffectiveDate <= DATE(@p_SelectedEffectiveDate) )

						AND ( fn_IsEmpty(@p_Originationcode)  OR r2.Code LIKE REPLACE(@p_Originationcode,"*", "%") )
						AND ( fn_IsEmpty(@p_OriginationDescription)  OR r2.Description LIKE REPLACE(@p_OriginationDescription,"*", "%") )


						AND ( fn_IsEmpty(@p_Originationcode)  OR  ( r2.Code IS NOT NULL  ) )
						AND ( fn_IsEmpty(@p_OriginationDescription)  OR  ( r2.Code IS NOT NULL  ) )


						AND ( tblRateTableRate.EndDate IS NULL OR  tblRateTableRate.EndDate > Now() )   -- rate should not end Today
						AND (fn_IsEmpty(@p_AccountIds) OR FIND_IN_SET(tblAccount.AccountID,@p_AccountIds) != 0 )
						AND tblAccount.IsVendor = 1
						AND tblAccount.Status = 1
						 
                        AND
						(
							( @p_vendor_block = 1 )
							OR
							( @p_vendor_block = 0 AND tblRateTableRate.Blocked = 0	)
						);
			END IF;	
			*/

			INSERT INTO tmp_VendorCurrentRates_
			Select RateTableRateID,VendorConnectionID,TimezonesID,Blocked,VendorConnectionName,OriginationCode,Code,OriginationDescription,Description, Rate,ConnectionFee,EffectiveDate,RateID,Preference
				FROM (
						SELECT * ,
							@row_num := IF(@prev_RateTableRateID = RateTableRateID AND @prev_VendorConnectionID = VendorConnectionID AND  @prev_TimezonesID = TimezonesID AND @prev_OriginationCode = OriginationCode AND  @prev_Code = Code AND @prev_EffectiveDate >= EffectiveDate, @row_num + 1, 1) AS RowID,
							@prev_RateTableRateID := RateTableRateID,
							@prev_VendorConnectionID := VendorConnectionID,
							@prev_TimezonesID := TimezonesID,
							-- @prev_TrunkID := TrunkID,
							@prev_OriginationCode := OriginationCode,
							@prev_Code := Code,
							@prev_EffectiveDate := EffectiveDate
						FROM tmp_VendorCurrentRates1_
							,(SELECT @row_num := 1, @prev_RateTableRateID := '',  @prev_VendorConnectionID := '', @prev_TimezonesID := '', @prev_OriginationCode := '', @prev_Code := '', @prev_EffectiveDate := '') x
						ORDER BY VendorConnectionID,TimezonesID,OriginationCode,Code, EffectiveDate , RateTableRateID DESC
				) tbl
				WHERE RowID = 1;
  



		/*IF @p_Preference = 1 THEN



			INSERT IGNORE INTO tmp_VendorRateByRank_
				SELECT
					RateTableRateID,
					VendorConnectionID,
					TimezonesID,
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
				FROM (			SELECT
								RateTableRateID,
								VendorConnectionID,
								TimezonesID,
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
								@preference_rank := CASE WHEN (@prev_TimezonesID = TimezonesID AND @prev_OriginationCode    = OriginationCode AND @prev_Code     = Code AND @prev_Preference > Preference  ) THEN @preference_rank + 1
														WHEN (@prev_TimezonesID = TimezonesID AND @prev_OriginationCode    = OriginationCode AND @prev_Code     = Code AND @prev_Preference = Preference AND @prev_Rate < Rate) THEN @preference_rank + 1
														WHEN (@prev_TimezonesID = TimezonesID AND @prev_OriginationCode    = OriginationCode AND @prev_Code    = Code AND @prev_Preference = Preference AND @prev_Rate = Rate) THEN @preference_rank
														ELSE 1
								END AS preference_rank,
								@prev_TimezonesID := TimezonesID,
								@prev_OriginationCode := OriginationCode,
								@prev_Code := Code,
								@prev_OriginationDescription := OriginationDescription ,
								@prev_Description := Description,
								@prev_Preference := IFNULL(Preference, 5),
								@prev_Rate := Rate
							FROM tmp_VendorCurrentRates_ AS preference,
								(SELECT @preference_rank := 0 , @prev_TimezonesID := '', @prev_OriginationCode := '', @prev_Code := ''  , @prev_OriginationDescription := '' , @prev_Description := ''  , @prev_Preference := 5,  @prev_Rate := 0) x
							ORDER BY
								preference.OriginationCode,preference.Code , preference.Preference DESC, preference.Rate ASC,preference.TimezonesID,preference.VendorConnectionID ASC
						 ) tbl
				WHERE (@p_isExport = 1 OR @p_isExport = 2) OR (@p_isExport = 0 AND preference_rank <= @p_Position)
			;

		ELSE



			INSERT IGNORE INTO tmp_VendorRateByRank_
				SELECT
					RateTableRateID,
					VendorConnectionID,
					TimezonesID,
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
								TimezonesID,
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
								@rank := CASE WHEN (@prev_TimezonesID = TimezonesID AND @prev_OriginationCode    = OriginationCode AND  @prev_Code    = Code AND @prev_Rate < Rate) THEN @rank + 1
											WHEN (@prev_TimezonesID = TimezonesID AND @prev_OriginationCode    = OriginationCode AND  @prev_Code    = Code AND @prev_Rate = Rate) THEN @rank
											ELSE 1
											END
								AS RateRank,
								@prev_TimezonesID := TimezonesID,
								@prev_OriginationCode := OriginationCode,
								@prev_Code := Code,
								@prev_OriginationDescription := OriginationDescription ,
								@prev_Description := Description,
								@prev_Rate := Rate
							FROM tmp_VendorCurrentRates_ AS rank,
								(SELECT @rank := 0 , @prev_Code := '' ,   @prev_TimezonesID := '', @prev_OriginationDescription := ''  ,@prev_OriginationCode := ''  , @prev_Description := '' , @prev_Rate := 0) f
							ORDER BY
								rank.OriginationCode, rank.Code, rank.Rate,rank.TimezonesID,rank.VendorConnectionID

						 ) tbl
				WHERE (@p_isExport = 1 OR @p_isExport = 2) OR (@p_isExport = 0 AND RateRank <= @p_Position)
			;

		END IF;

*/
			/*SET @_query = CONCAT("select max(RowCode) , TimezonesID
			FROM tmp_VendorCurrentRates_ v
			INNER join  tmp_search_code_ 	SplitCode   on v.Code = SplitCode.Code
			having count(VendorConnectionID) > 0
			group by Code ,  TimezonesID LIMIT ",@p_RowspPage," OFFSET ",@v_OffSet_," ;");

			leave ThisSP;*/
 

		-- 3 min
		insert ignore into tmp_VendorRate_stage_1 (
			RateTableRateID,
			RowCode,
			VendorConnectionID ,
			TimezonesID,
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
			v.TimezonesID,
			Blocked,
			v.VendorConnectionName ,
			v.OriginationCode,
			v.Code,
			v.Rate,
			v.ConnectionFee,
			v.EffectiveDate,
			OriginationDescription,
			SplitCode.Description,
			v.Preference

		FROM tmp_VendorCurrentRates_ v
		INNER join  tmp_search_code_ SplitCode on v.RateID = SplitCode.CodeRateID;
			

			-- left join  tmp_search_code_dup 	SplitCode2  on v.OriginationCode != '' AND v.OriginationCode = SplitCode2.Code;
 
		-- update timezone Title
		update tmp_VendorRate_stage_1 v 
		INNER JOIN tblTimezones t on v.TimezonesID = t.TimezonesID
		SET  v.VendorConnectionName = concat(v.VendorConnectionName ,' - ' , t.Title  );

 
		/*
			Purchase CASE 1
			Vendor A, destination 31:
			-	Default: 0.01
			Vendor B, destination 31:
			-	Peak: 0.025
			-	Off peak: 0.017
			-	Weekend 
			Vendor C, destination 31:
			-	Default: 0.015
			Routing
			Call comes in during peak: Vendor A, C, B
			Call comes in during Off peak: Vendor A, C, B
			Comparison
			In case there is a single Vendor involved with non-Default pricing (as given in this example):
			

			Destination	Time of day	Position 1  		Position 2			Position 3
			31 			Peak		Vendor A (0.01)		Vendor C (0.015)	Vendor B (0.025)
			31 			Off peak	Vendor A (0.01)		Vendor C (0.015)	Vendor B (0.017)


			Purchase - CASE 2 
			Vendor A, destination 42:
			-	Default: 0.01
			Vendor B, destination 42:
			-	Peak: 0.02
			-	Off peak: 0.005
			Vendor C, destination 42:
			-	Default: 0.015
			Routing
			Call comes in during peak: Vendor A, C, B
			Call comes in during Off peak: Vendor B, A, C
			Comparison
			In case there is a single Vendor involved with non-Default pricing (as given in this example):
		
			Destination	Time of day	Position 1			Position 2			Position 3
			42 			Peak		Vendor A (0.01) 	Vendor C (0.015)	Vendor B (0.02)
			42 			Off peak	Vendor B (0.005)	Vendor A (0.01)		Vendor C (0.015)

			lOGIC : when all vendors are not giving default rates
			ASSUMPTION : VENDOR CANT HAVE PEAK OR OFF PEAK WITH DEFAULT RATES.
			STEP 1 COLLECT ALL DEFAULT TIMEZONE RATES INTO TEMP TABLE tmp_VendorRate_stage_1_DEFAULT
			STEP 2 DELETE ALL DEFAULT TIMEZONE RATES FROM ORIGINAL TABLE tmp_VendorRate_stage_1
			STEP 3 INSERT INTO ORIGINAL TABLE WITH ALL DEFAULT AS PEAK 
			STEP 4 INSERT INTO ORIGINAL TABLE WITH ALL DEFAULT AS OFF PEAK AND SO ON

			Note: In case all Vendors only have Default pricing, the destination can be shown on one line and it can state in the Time of day column ‘Default’.


		*/

		-- leave ThisSP;
		SET @v_rowCount_ = ( SELECT COUNT(TimezonesID) FROM ( SELECT DISTINCT TimezonesID FROM tmp_VendorRate_stage_1 WHERE TimezonesID != @v_default_TimezonesID group by TimezonesID ) tmp );
		SET @v_pointer_ = 1;
		
		IF @v_rowCount_ > 0 THEN 
				
				INSERT INTO tmp_VendorRate_stage_1_DEFAULT
				SELECT * FROM tmp_VendorRate_stage_1 WHERE TimezonesID = @v_default_TimezonesID;

				DELETE  FROM tmp_VendorRate_stage_1 WHERE TimezonesID = @v_default_TimezonesID;

				INSERT INTO tmp_VendorRate_stage_1_dup SELECT * FROM tmp_VendorRate_stage_1;

				 truncate table tmp_timezones;
				 insert into tmp_timezones (TimezonesID) select distinct TimezonesID from tmp_VendorRate_stage_1 WHERE TimezonesID != @v_default_TimezonesID;
				-- select GROUP_CONCAT(TimezonesID) INTO @v_rest_TimezonesIDs from tblTimezones WHERE TimezonesID != @v_default_TimezonesID;

				delete vd 
				from tmp_VendorRate_stage_1_dup vd
				INNER JOIN  tmp_VendorRate_stage_1_DEFAULT v
				ON v.VendorConnectionID = vd.VendorConnectionID AND
				-- v.TimezonesID  = vd.TimezonesID AND
				vd.OriginationCode = v.OriginationCode AND
				vd.RowCode = v.RowCode;


				WHILE @v_pointer_ <= @v_rowCount_
				DO

					SET @v_TimezonesID = ( SELECT TimezonesID FROM tmp_timezones WHERE ID = @v_pointer_ );

					INSERT INTO tmp_VendorRate_stage_1 (
						RateTableRateID,
						RowCode,
						VendorConnectionID ,
						TimezonesID,
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
						vd.RateTableRateID,
						vd.RowCode,
						vd.VendorConnectionID ,
						@v_TimezonesID,
						vd.Blocked,
						vd.VendorConnectionName ,
						vd.OriginationCode ,
						vd.Code ,
						vd.Rate ,
						vd.ConnectionFee,
						vd.EffectiveDate ,
						vd.OriginationDescription ,
						vd.Description ,
						vd.Preference

					FROM tmp_VendorRate_stage_1_DEFAULT vd
					INNER JOIN tmp_VendorRate_stage_1_dup v on 
										-- v.VendorConnectionID != vd.VendorConnectionID AND
										v.TimezonesID  = @v_TimezonesID AND
									-- FIND_IN_SET(v.TimezonesID, @v_rest_TimezonesIDs) != 0 AND
										vd.OriginationCode = v.OriginationCode AND
										vd.RowCode = v.RowCode;

					SET @v_pointer_ = @v_pointer_ + 1;

				END WHILE;
				
		END IF;

		-- leave ThisSP;

		-- SET GLOBAL key_buffer_size = 1024*1024*1024;
		-- SET GLOBAL sort_buffer_size = 1024*1024*1024;

 


		truncate table tmp_timezones;
		INSERT INTO tmp_timezones (TimezonesID)	SELECT DISTINCT TimezonesID FROM tmp_VendorRate_stage_1;

		SET @v_t_rowCount_ = ( SELECT COUNT(*) FROM tmp_timezones );
		SET @v_t_pointer_ = 1;
		
		IF @v_t_rowCount_ > 0 THEN 

			WHILE @v_t_pointer_ <= @v_t_rowCount_
			DO

				SET @v_TimezonesID = ( SELECT TimezonesID FROM tmp_timezones WHERE ID = @v_t_pointer_ );

				truncate table tmp_VendorRate_stage_2;
				INSERT INTO tmp_VendorRate_stage_2 (
							RateTableRateID,
							RowCode,
							VendorConnectionID,
							TimezonesID,
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
							MaxMatchRank
				)	
				SELECT
							DISTINCT
							RateTableRateID,
							RowCode,
							VendorConnectionID,
							TimezonesID,
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
							MaxMatchRank 
				FROM tmp_VendorRate_stage_1
				WHERE TimezonesID = @v_TimezonesID
				order by  RowCode,TimezonesID,VendorConnectionID,OriginationCode,Code desc;



				truncate table tmp_VendorRate_stage_;
				-- remove multiple vendor per rowcode
				insert  into tmp_VendorRate_stage_
				(
					RateTableRateID,
					RowCode,
					VendorConnectionID,
					TimezonesID,
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
					MaxMatchRank,
					prev_OriginationCode,
					prev_RowCode,
					prev_VendorConnectionID,
					prev_TimezonesID
				)
					SELECT
						RateTableRateID,
						RowCode,
						v.VendorConnectionID ,
						v.TimezonesID,
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
						@rank := ( CASE WHEN ( ( @prev_TimezonesID = v.TimezonesID ) AND @prev_OriginationCode = v.OriginationCode and  @prev_RowCode = RowCode  AND @prev_VendorConnectionID = v.VendorConnectionID ) THEN  @rank + 1
										ELSE 1
										END
						) AS MaxMatchRank,
						@prev_OriginationCode := v.OriginationCode,
						@prev_RowCode := RowCode	 ,
						@prev_VendorConnectionID := v.VendorConnectionID,
						@prev_TimezonesID := v.TimezonesID
					FROM tmp_VendorRate_stage_2 v
					, ( SELECT  @prev_OriginationCode := '' , @prev_RowCode := '',  @rank := 0 ,  @prev_TimezonesID := '' , @prev_VendorConnectionID := 0 ) x
					-- WHERE v.TimezonesID = @v_TimezonesID
					order by  RowCode,TimezonesID,VendorConnectionID,OriginationCode,Code desc;



					IF( @p_Preference = 0 )
					THEN

							truncate table tmp_VendorRate_;
							insert into tmp_VendorRate_(
												RateTableRateID,
												VendorConnectionID,
												TimezonesID,
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
												RowCode
							)
							select
								distinct
								RateTableRateID,
								VendorConnectionID ,
								TimezonesID,
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
							order by OriginationCode,RowCode,TimezonesID,Rate,VendorConnectionID ASC;
						
						
							insert into tmp_final_VendorRate_ (
									RateTableRateID,
									VendorConnectionID ,
									TimezonesID,
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
							)
								SELECT
									RateTableRateID,
									VendorConnectionID ,
									TimezonesID,
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
											TimezonesID,
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
											@rank := CASE WHEN ( ( @prev_TimezonesID = TimezonesID ) AND @prev_OriginationCode    = OriginationCode AND  @prev_RowCode     = RowCode AND @prev_Rate <  Rate ) THEN @rank+1
														WHEN ( ( @prev_TimezonesID = TimezonesID ) AND @prev_OriginationCode    = OriginationCode AND   @prev_RowCode    = RowCode AND @prev_Rate = Rate ) THEN @rank 
														ELSE
															1
														END
												AS FinalRankNumber,
											@prev_TimezonesID  := TimezonesID,
											@prev_OriginationCode  := OriginationCode,
											@prev_RowCode  := RowCode,
											@prev_Rate  := Rate
										from tmp_VendorRate_
										,( SELECT @rank := 0 , @prev_RowCode := '' , @prev_TimezonesID := '', @prev_OriginationCode := '', @prev_Rate := 0 ) x
										order by OriginationCode,RowCode,Rate,TimezonesID,VendorConnectionID ASC

									) tbl1
								where
									(@p_isExport = 1  OR @p_isExport = 2) OR (@p_isExport = 0 AND FinalRankNumber <= @p_Position);

			
					ELSE

						
							truncate table tmp_VendorRate_;
							insert into tmp_VendorRate_(
												RateTableRateID,
												VendorConnectionID,
												TimezonesID,
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
												RowCode
							)
							select
								distinct
								RateTableRateID,
								VendorConnectionID ,
								TimezonesID,
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
							ORDER BY OriginationCode,RowCode,TimezonesID asc ,Preference desc ,VendorConnectionID ASC;
				
							insert into tmp_final_VendorRate_
									(
											RateTableRateID,
											VendorConnectionID ,
											TimezonesID,
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
									)
								SELECT
									RateTableRateID,
									VendorConnectionID ,
									TimezonesID,
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
											TimezonesID,
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
											@preference_rank := CASE WHEN (	( @prev_TimezonesID = TimezonesID ) AND @prev_OriginationCode    = OriginationCode AND  @prev_Code     = RowCode AND @prev_Preference > Preference  )   THEN @preference_rank + 1
																	WHEN (( @prev_TimezonesID = TimezonesID ) AND @prev_OriginationCode    = OriginationCode AND  @prev_Code     = RowCode AND @prev_Preference = Preference AND @prev_Rate < Rate) THEN @preference_rank + 1
																	WHEN (( @prev_TimezonesID = TimezonesID ) AND @prev_OriginationCode    = OriginationCode AND  @prev_Code    = RowCode AND @prev_Preference = Preference AND @prev_Rate = Rate) THEN @preference_rank
																	ELSE 1 END AS FinalRankNumber,
											@prev_TimezonesID := TimezonesID,
											@prev_OriginationCode := OriginationCode,
											@prev_Code := RowCode,
											@prev_Preference := Preference,
											@prev_Rate := Rate
										from tmp_VendorRate_
										,(SELECT @preference_rank := 0 ,@prev_TimezonesID := '', @prev_OriginationCode := ''  , @prev_Code := ''  , @prev_Preference := 5,  @prev_Rate := 0) x
										 order by OriginationCode,RowCode ASC ,Preference DESC ,Rate ASC , TimezonesID, VendorConnectionID  ASC

									) tbl1
								where
									(@p_isExport = 1  OR @p_isExport = 2 ) OR (@p_isExport = 0 AND FinalRankNumber <= @p_Position);
			
					END IF;


				SET @v_t_pointer_ = @v_t_pointer_ + 1;


			END WHILE;
				
		END IF;

		SET @stm_columns = "";


		IF @p_isExport = 0 AND @p_Position > 10 THEN
			SET @p_Position = 10;
		END IF;

		-- description with , comma will give error in display.
		update tmp_final_VendorRate_
			SET
			 OriginationDescription = ifnull(REPLACE(OriginationDescription,",","-"),''),
			 Description = ifnull(REPLACE(Description,",","-"),'');

				-- update timezone Title
		update tmp_final_VendorRate_ v 
		INNER JOIN tblTimezones t on v.TimezonesID = t.TimezonesID
		SET  v.TimezoneName = t.Title;


		delete from tmp_final_VendorRate_ where Rate is null;


		IF @p_isExport = 2
		THEN
 
				SELECT
					distinct
					ANY_VALUE(RateTableRateID) as RateTableRateID,
					ANY_VALUE(VendorConnectionID) as VendorConnectionID,
					TimezoneName as TimezoneName,
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
				GROUP BY  TimezoneName,OriginationCode,RowCode ORDER BY TimezoneName,OriginationCode,RowCode ASC;

		ELSE


			IF @p_isExport = 1  OR @p_isExport = 2 THEN
				SELECT MAX(FinalRankNumber) INTO @p_Position FROM tmp_final_VendorRate_;
			END IF;


			SET @v_pointer_=1;
			WHILE @v_pointer_ <= @p_Position
			DO

				IF (@p_isExport = 0)
				THEN
					SET @stm_columns = CONCAT(@stm_columns, "GROUP_CONCAT(if(ANY_VALUE(FinalRankNumber) = ",@v_pointer_,", CONCAT(ANY_VALUE(OriginationCode), '<br>', ANY_VALUE(OriginationDescription), '<br>',ANY_VALUE(Code), '<br>', ANY_VALUE(Description), '<br>', ANY_VALUE(Rate), '<br>', ANY_VALUE(VendorConnectionName), '<br>', DATE_FORMAT (ANY_VALUE(EffectiveDate), '%d/%m/%Y'),'', '=', ANY_VALUE(RateTableRateID), '-', ANY_VALUE(VendorConnectionID), '-', ANY_VALUE(Code), '-', ANY_VALUE(Blocked) , '-', ANY_VALUE(Preference), '-', ANY_VALUE(TimezonesID)  ), NULL) , '<BR>') AS `POSITION ",@v_pointer_,"`,");
				ELSE
					SET @stm_columns = CONCAT(@stm_columns, "GROUP_CONCAT(if(ANY_VALUE(FinalRankNumber) = ",@v_pointer_,", CONCAT(ANY_VALUE(Code), '<br>', ANY_VALUE(Description), '<br>', ANY_VALUE(Rate), '<br>', ANY_VALUE(VendorConnectionName), '<br>', DATE_FORMAT (ANY_VALUE(EffectiveDate), '%d/%m/%Y')), NULL) SEPARATOR '<br>' )  AS `POSITION ",@v_pointer_,"`,");
				END IF;

				SET @v_pointer_ = @v_pointer_ + 1;

			END WHILE;

			SET @stm_columns = TRIM(TRAILING ',' FROM @stm_columns);



			IF ( @p_isExport = 0 )
			THEN

 
					SET @stm_query = CONCAT("SELECT CONCAT(OriginationCode , ' : ' , ANY_VALUE(OriginationDescription), ' <br> => '  , RowCode , ' : ' , ANY_VALUE(Description)) as Destination, TimezoneName as Timezone, ", @stm_columns," FROM tmp_final_VendorRate_  GROUP BY  OriginationCode,RowCode,TimezoneName ORDER BY OriginationCode,RowCode,TimezoneName ASC LIMIT ",@p_RowspPage," OFFSET ",@v_OffSet_," ;");

					select count(RowCode) as totalcount  from ( SELECT RowCode  from tmp_final_VendorRate_ GROUP BY OriginationCode, RowCode,TimezoneName ) tmp;

 

			END IF;

			IF @p_isExport = 1
			THEN

 
					SET @stm_query = CONCAT("SELECT CONCAT(OriginationCode , ' : ' , ANY_VALUE(OriginationDescription), '  => '  , RowCode , ' : ' , ANY_VALUE(Description)) as Destination, TimezoneName as Timezone ", @stm_columns," FROM tmp_final_VendorRate_   GROUP BY  OriginationCode,RowCode ORDER BY RowCode ASC;");


 

			END IF;




			PREPARE stm_query FROM @stm_query;
			EXECUTE stm_query;
			DEALLOCATE PREPARE stm_query;

		END IF;


		SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

	END//
DELIMITER ;