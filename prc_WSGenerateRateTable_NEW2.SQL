DROP PROCEDURE IF EXISTS `prc_WSGenerateRateTable_NEW2`;
DELIMITER //
CREATE PROCEDURE `prc_WSGenerateRateTable_NEW2`(
	IN `p_jobId` INT,
	IN `p_RateGeneratorId` INT,
	IN `p_RateTableId` INT,
	IN `p_rateTableName` VARCHAR(200),
	IN `p_EffectiveDate` VARCHAR(10),
	IN `p_delete_exiting_rate` INT,
	IN `p_EffectiveRate` VARCHAR(50),
	IN `p_ModifiedBy` VARCHAR(50)






)
GenerateRateTable:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SHOW WARNINGS;
			ROLLBACK;
			INSERT INTO tmp_JobLog_ (Message) VALUES ('RateTable generation failed');
			

		END;

		SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;


		DROP TEMPORARY TABLE IF EXISTS tmp_JobLog_;
		CREATE TEMPORARY TABLE tmp_JobLog_ (
			Message longtext
		);

		SET @@session.collation_connection='utf8_unicode_ci';
		SET @@session.character_set_client='utf8';
		SET SESSION group_concat_max_len = 1000000; 


		SET @p_jobId						= 	p_jobId;
		SET @p_RateGeneratorId			= 	p_RateGeneratorId;
		SET @p_RateTableId				= 	p_RateTableId;
		-- SET @p_TimezonesID				= 	p_TimezonesID;
		SET @p_rateTableName				= 	p_rateTableName;
		SET @p_EffectiveDate				= 	p_EffectiveDate;
		SET @p_delete_exiting_rate		= 	p_delete_exiting_rate;
		SET @p_EffectiveRate				= 	p_EffectiveRate;
		-- SET @p_GroupBy					= 	p_GroupBy;
		SET @p_ModifiedBy				= 	p_ModifiedBy;
		-- SET @p_IsMerge					= 	p_IsMerge;
		-- SET @p_TakePrice					= 	p_TakePrice;
		-- SET @p_MergeInto					= 	p_MergeInto;


		SET @v_RATE_STATUS_AWAITING  = 0;
		SET @v_RATE_STATUS_APPROVED  = 1;
		SET @v_RATE_STATUS_REJECTED  = 2;
		SET @v_RATE_STATUS_DELETE    = 3;
	
		SET @v_RoundChargedAmount = 6;

    -- 1 - Termination 2 - DID 3 - Package
		SET	@v_RateTypeID = 1;
        set @v_AppliedToCustomer = 1; 
        set @v_AppliedToVendor = 2; 
        set @v_AppliedToReseller = 3; 
		SET @v_default_TimezonesID = 1;


		SET @p_EffectiveDate = CAST(@p_EffectiveDate AS DATE);
		-- SET @v_TimezonesID = IF(@p_IsMerge=1,@p_MergeInto,@p_TimezonesID);

		IF @p_rateTableName IS NOT NULL
		THEN


			SET @v_RTRowCount_ = (SELECT
														 COUNT(*)
													 FROM tblRateTable
													 WHERE RateTableName = @p_rateTableName
																 AND CompanyId = (SELECT
																										CompanyId
																									FROM tblRateGenerator
																									WHERE RateGeneratorID = @p_RateGeneratorId));

			IF @v_RTRowCount_ > 0
			THEN
				INSERT INTO tmp_JobLog_ (Message) VALUES ('RateTable Name is already exist, Please try using another RateTable Name');
				select * from tmp_JobLog_;
				LEAVE GenerateRateTable;
			END IF;
		END IF;


		 

		DROP TEMPORARY TABLE IF EXISTS tmp_Codedecks_;
		CREATE TEMPORARY TABLE tmp_Codedecks_ (
			CodeDeckId INT
		);

		DROP TEMPORARY TABLE IF EXISTS tmp_Raterules_codes;
		CREATE TEMPORARY TABLE tmp_Raterules_codes  (
			code VARCHAR(50) COLLATE utf8_unicode_ci,
			DestinationType VARCHAR(200) COLLATE utf8_unicode_ci,
			DestinationCountryID INT
		);


		DROP TEMPORARY TABLE IF EXISTS tmp_Raterules_;
		CREATE TEMPORARY TABLE tmp_Raterules_  (
 			rateruleid INT,
			Originationcode VARCHAR(50) COLLATE utf8_unicode_ci,
			-- Originationdescription VARCHAR(200) COLLATE utf8_unicode_ci,
			OriginationType VARCHAR(200) COLLATE utf8_unicode_ci,
			OriginationCountryID INT,
			DestinationType VARCHAR(200) COLLATE utf8_unicode_ci,
			DestinationCountryID INT,
			code VARCHAR(50) COLLATE utf8_unicode_ci,
			-- description VARCHAR(200) COLLATE utf8_unicode_ci,
			RowNo INT,
			`Order` INT,
			INDEX tmp_Raterules_code (`code`),
			INDEX tmp_Raterules_rateruleid (`rateruleid`),
			INDEX tmp_Raterules_RowNo (`RowNo`)
		);

		DROP TEMPORARY TABLE IF EXISTS tmp_Raterules_dup;
		CREATE TEMPORARY TABLE tmp_Raterules_dup  (
			rateruleid INT,
			Originationcode VARCHAR(50) COLLATE utf8_unicode_ci,
			-- Originationdescription VARCHAR(200) COLLATE utf8_unicode_ci,
			OriginationType VARCHAR(200) COLLATE utf8_unicode_ci,
			OriginationCountryID INT,
			DestinationType VARCHAR(200) COLLATE utf8_unicode_ci,
			DestinationCountryID INT,
			code VARCHAR(50) COLLATE utf8_unicode_ci,
			-- description VARCHAR(200) COLLATE utf8_unicode_ci,
			RowNo INT,
			`Order` INT,
			INDEX tmp_Raterules_code (`code`),
			INDEX tmp_Raterules_rateruleid (`rateruleid`),
			INDEX tmp_Raterules_RowNo (`RowNo`)
		);
		


		DROP TEMPORARY TABLE IF EXISTS tmp_Vendorrates_;
		CREATE TEMPORARY TABLE tmp_Vendorrates_  (
			OriginationCode varchar(50),
			OriginationDescription varchar(200),
			code VARCHAR(50) COLLATE utf8_unicode_ci,
			rate DECIMAL(18, 8),
			rateN DECIMAL(18, 8),
			ConnectionFee DECIMAL(18, 8),
			VendorConnectionID INT,
			TimezonesID int,
			AccountID INT,
			RowNo INT,
			PreferenceRank INT,
			RateCurrency int,
			ConnectionFeeCurrency int,
			MinimumDuration int,
			INDEX tmp_Vendorrates_code (`code`),
			INDEX tmp_Vendorrates_rate (`rate`)
		);

		DROP TEMPORARY TABLE IF EXISTS tmp_Rates_;
		CREATE TEMPORARY TABLE tmp_Rates_  (
  				TimezonesID INT,
				VendorConnectionID INT,
				AccountID INT,
				OriginationCodeID INT,
				CodeID INT,
				Rate DECIMAL(18,6)  ,
				RateN DECIMAL(18,6) ,
				ConnectionFee DECIMAL(18,6)  ,
				MinimumDuration INT
		);


		DROP TEMPORARY TABLE IF EXISTS tmp_Rates2_;
		CREATE TEMPORARY TABLE tmp_Rates2_  (
  				TimezonesID INT,
				VendorConnectionID INT,
				AccountID INT,
				OriginationCodeID INT,
				CodeID INT,
				Rate DECIMAL(18,6)  ,
				RateN DECIMAL(18,6) ,
				ConnectionFee DECIMAL(18,6)  ,
				MinimumDuration INT
		);


		
		
		
		DROP TEMPORARY TABLE IF EXISTS tmp_VRatesstage2_;
		CREATE TEMPORARY TABLE tmp_VRatesstage2_  (
  				TimezonesID INT,
				VendorConnectionID INT,
				AccountID INT,
				OriginationCodeID INT,
				CodeID INT,
				Rate DECIMAL(18,6)  ,
				RateN DECIMAL(18,6) ,
				ConnectionFee DECIMAL(18,6)  ,
				MinimumDuration INT,
				FinalRankNumber INT,

			 INDEX tmp_Vendorrates_stage2__code (`RowCodeID`)
		);
		DROP TEMPORARY TABLE IF EXISTS tmp_dupVRatesstage2_;
		CREATE TEMPORARY TABLE tmp_dupVRatesstage2_  (
		
			TimezonesID int,
			OriginationCodeID int 
			RowCodeID int,
			FinalRankNumber int,
			INDEX tmp_dupVendorrates_stage2__code (`RowCodeID`)
		);
		DROP TEMPORARY TABLE IF EXISTS tmp_Vendorrates_stage3_;
		CREATE TEMPORARY TABLE tmp_Vendorrates_stage3_  (
			
			
			
				TimezonesID INT,
				VendorConnectionID INT,
				AccountID INT,
				RowCodeID int,
				OriginationCodeID INT,
				CodeID INT,
				Rate DECIMAL(18,6)  ,
				RateN DECIMAL(18,6) ,
				ConnectionFee DECIMAL(18,6)  ,
				MinimumDuration INT,
				
 			INDEX tmp_Vendorrates_stage2__code (`RowCodeID`)
		);

		DROP TEMPORARY TABLE IF EXISTS tmp_code_;
		CREATE TEMPORARY TABLE tmp_code_  (
			CodeID INT auto_increment,
			RateID INT,
			Code VARCHAR(50),
			Type VARCHAR(50),
			CountryID INT,
			INDEX INDEX1(RateID),
			PRIMARY KEY (CodeID)
		);
		DROP TEMPORARY TABLE IF EXISTS tmp_code_dup;
		CREATE TEMPORARY TABLE tmp_code_dup  (
			CodeID INT auto_increment,
			RateID INT,
			Code VARCHAR(50),
			Type VARCHAR(50),
			CountryID INT,
			INDEX INDEX1(RateID),
			PRIMARY KEY (CodeID)
		);
		DROP TEMPORARY TABLE IF EXISTS tmp_code_dup2;
		CREATE TEMPORARY TABLE tmp_code_dup2 (
			CodeID INT auto_increment,
			RateID INT,
			Code VARCHAR(50),
			Type VARCHAR(50),
			CountryID INT,
			INDEX INDEX1(RateID),
			PRIMARY KEY (CodeID)
		);

		
		DROP TEMPORARY TABLE IF EXISTS tmp_search_code_;
		CREATE TEMPORARY TABLE tmp_search_code_ (
			RowCodeID int ,
			CodeID  INT
		);


		DROP TEMPORARY TABLE IF EXISTS tmp_code_origination;
		CREATE TEMPORARY TABLE tmp_code_origination  (
			RateID INT,
			-- CountryID int,
			-- code VARCHAR(50) COLLATE utf8_unicode_ci,
			INDEX tmp_code_code (`RateID`)
		);

		 


		DROP TEMPORARY TABLE IF EXISTS tmp_tblAccounts;
		CREATE TEMPORARY TABLE tmp_tblAccounts (
			AccountID INT(11) ,
			RateTableID INT(11) ,
			VendorConnectionID INT(11) ,
			VendorConnectionName VARCHAR(200)
		);


		DROP TEMPORARY TABLE IF EXISTS tmp_tblRateTableRate;
		CREATE TEMPORARY TABLE tmp_tblRateTableRate (
			TimezonesID INT(11)  ,
 			VendorConnectionID INT,
			AccountID INT,
			OriginationRateID BIGINT(20)  ,
			RateID INT(11) ,
			Rate DECIMAL(18,6)  ,
			RateN DECIMAL(18,6) ,
			ConnectionFee DECIMAL(18,6)  ,
			Preference INT(11),
			MinimumDuration INT(11),
			INDEX Index1 (OriginationRateID),
			INDEX Index2 (RateID)

		);
 		

 
		DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_stage_1;
		CREATE TEMPORARY TABLE tmp_VendorRate_stage_1 (
			TimezonesID int,
			VendorConnectionID int,
			RowCodeID int,
			OriginationCodeID int,
			CodeID int
  		);

		DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_detail;
		CREATE TEMPORARY TABLE IF NOT EXISTS tmp_VendorRate_detail(
			TimezonesID int,
			VendorConnectionID int,
			AccountID int,
			OriginationCodeID int,
			CodeID int,
			Rate DECIMAL(18, 8) ,
			RateN DECIMAL(18, 8) ,
			ConnectionFee DECIMAL(18, 8) ,
			Preference int,
			MinimumDuration int,
			INDEX IX_Code (CodeID)
		);



		DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_stage_1_DEFAULT;
		 CREATE TEMPORARY TABLE tmp_VendorRate_stage_1_DEFAULT (
 
			TimezonesID int,
			VendorConnectionID int,
			RowCodeID int,
			OriginationCodeID int,
			CodeID int
		);

		DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_stage_1_dup;
		 CREATE TEMPORARY TABLE tmp_VendorRate_stage_1_dup (
 
			TimezonesID int,
			VendorConnectionID int,
			RowCodeID int,
			OriginationCodeID int,
			CodeID int,
			INDEX Index1 (VendorConnectionID),
			INDEX Index2 (TimezonesID,OriginationCodeID,RowCodeID)

		);

		DROP TEMPORARY TABLE IF EXISTS tmp_timezones;
		CREATE TEMPORARY TABLE tmp_timezones (
			ID int auto_increment,
			TimezonesID int,
			primary key (ID)
		);
		



 


		DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_;
		CREATE TEMPORARY TABLE tmp_VendorRate_ (
  				TimezonesID INT,
				VendorConnectionID INT,
				AccountID INT,
				RowCodeID INT,
				OriginationCodeID INT,
				CodeID INT,
				Rate DECIMAL(18,6)  ,
				RateN DECIMAL(18,6) ,
				ConnectionFee DECIMAL(18,6)  ,
				MinimumDuration INT,
				
				INDEX Index1 (TimezonesID),
				INDEX Index2 (OriginationCodeID,RowCodeID,AccountID)

		);

  
  
		
		 DROP TEMPORARY TABLE IF EXISTS tmp_final_VendorRate_;
		 CREATE TEMPORARY TABLE tmp_final_VendorRate_ (


  				TimezonesID INT,
				VendorConnectionID INT,
				AccountID INT,
				RowCodeID INT,
				OriginationCodeID INT,
				CodeID INT,
				Rate DECIMAL(18,6)  ,
				RateN DECIMAL(18,6) ,
				ConnectionFee DECIMAL(18,6)  ,
				MinimumDuration INT
				FinalRankNumber INT ,

			INDEX IX_CODE (TimezonesID,OriginationCodeID,CodeID)

		);

		 

	 DROP TEMPORARY TABLE IF EXISTS tmp_ALL_RateTableRate_;
	 CREATE TEMPORARY TABLE IF NOT EXISTS tmp_ALL_RateTableRate_(

 
				`RateTableRateAAID` BIGINT(20) NOT NULL ,
				`RateTableRateID` BIGINT(20) NOT NULL DEFAULT '0',
				`OriginationRateID` BIGINT(20) NOT NULL DEFAULT '0',
				`RateID` INT(11) NOT NULL,
				`RateTableId` BIGINT(20) NOT NULL,
				`TimezonesID` INT(11) NOT NULL DEFAULT '1',
				`Rate` DECIMAL(18, 8) NOT NULL DEFAULT '0.000000',
				`RateN` DECIMAL(18, 8) NOT NULL DEFAULT '0.000000',
				`EffectiveDate` DATE NOT NULL,
				`EndDate` DATE NULL DEFAULT NULL,
				`created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
				`updated_at` DATETIME NULL DEFAULT NULL,
				`CreatedBy` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
				`ModifiedBy` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
				`PreviousRate` DECIMAL(18, 8) NULL DEFAULT NULL,
				`Interval1` INT(11) NULL DEFAULT NULL,
				`IntervalN` INT(11) NULL DEFAULT NULL,
				`MinimumDuration` INT(11) NULL DEFAULT NULL,
				`ConnectionFee` DECIMAL(18, 8) NULL DEFAULT NULL,
				`RoutingCategoryID` INT(11) NULL DEFAULT NULL,
				`Preference` INT(11) NULL DEFAULT NULL,
				`Blocked` TINYINT(4) NOT NULL DEFAULT '0',
				`ApprovedStatus` TINYINT(4) NOT NULL DEFAULT '1',
				`ApprovedBy` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
				`ApprovedDate` DATETIME NULL DEFAULT NULL,
				`RateCurrency` INT(11) NULL DEFAULT NULL,
				`ConnectionFeeCurrency` INT(11) NULL DEFAULT NULL,
				`VendorID` INT(11) NULL DEFAULT NULL,

				INDEX `IX_RateTableRateID` (`RateTableRateID`),
				INDEX `IX_TimezonesID` (`TimezonesID`)
		);


		SELECT CurrencyID INTO @v_CurrencyID_ FROM  tblRateGenerator WHERE RateGeneratorId = @p_RateGeneratorId;



		
		SELECT IFNULL(REPLACE(JSON_EXTRACT(Options, '$.IncreaseEffectiveDate'),'"',''), @p_EffectiveDate) , IFNULL(REPLACE(JSON_EXTRACT(Options, '$.DecreaseEffectiveDate'),'"',''), @p_EffectiveDate)   INTO @v_IncreaseEffectiveDate_ , @v_DecreaseEffectiveDate_  FROM tblJob WHERE Jobid = @p_jobId;


		IF @v_IncreaseEffectiveDate_ is null OR @v_IncreaseEffectiveDate_ = '' THEN

			SET @v_IncreaseEffectiveDate_ = @p_EffectiveDate;

		END IF;

		IF @v_DecreaseEffectiveDate_ is null OR @v_DecreaseEffectiveDate_ = '' THEN

			SET @v_DecreaseEffectiveDate_ = @p_EffectiveDate;

		END IF;


		SELECT
			UsePreference,
			rateposition,
			companyid ,
			CodeDeckId,
			tblRateGenerator.TrunkID,
			tblRateGenerator.UseAverage  ,
			tblRateGenerator.RateGeneratorName,
			IF( LessThenRate = '' OR LessThenRate is null 		,0, LessThenRate   ),
			IF( ChargeRate  = '' OR ChargeRate is null			,0, ChargeRate     ),
			IF( percentageRate = '' OR percentageRate is null	,0, percentageRate ),
			IFNULL(AppliedTo,''),
			IFNULL(Reseller,'')
		

			INTO @v_Use_Preference_, @v_RatePosition_, @v_CompanyId_, @v_codedeckid_, @v_trunk_, @v_Average_, @v_RateGeneratorName_,@v_LessThenRate,@v_ChargeRate,@v_percentageRate, @v_AppliedTo, @v_Reseller
		FROM tblRateGenerator
		WHERE RateGeneratorId = @p_RateGeneratorId;


		SELECT CurrencyId INTO @v_CompanyCurrencyID_ FROM  tblCompany WHERE CompanyID = @v_CompanyId_;

		SELECT IFNULL(Value,0) INTO @v_RateApprovalProcess_ FROM tblCompanySetting WHERE CompanyID = @v_CompanyId_ AND `Key`='RateApprovalProcess';
		
		-- SELECT IFNULL(Value,0) INTO @v_UseVendorCurrencyInRateGenerator_ FROM tblCompanySetting WHERE CompanyID = @v_CompanyId_ AND `Key`='UseVendorCurrencyInRateGenerator';

        Select Value INTO @v_DestinationCurrencyConversionRate from tblCurrencyConversion where tblCurrencyConversion.CurrencyId =  @v_CurrencyID_  and  CompanyID = @v_CompanyId_;

        Select Value INTO @v_CompanyCurrencyConversionRate from tblCurrencyConversion where tblCurrencyConversion.CurrencyId =  @v_CompanyCurrencyID_  and  CompanyID = @v_CompanyId_;


		INSERT INTO tmp_Raterules_(
										rateruleid,
										Originationcode,
										-- Originationdescription,
										OriginationType,
										OriginationCountryID,
										DestinationType,
										DestinationCountryID,
										code,
										-- description,
										RowNo,
										`Order`
								)
			SELECT
				rateruleid,
				IF(Originationcode='',NULL,Originationcode),
				-- IF(Originationdescription='',NULL,Originationdescription),
				IF(OriginationType='',NULL,OriginationType),
				IF(OriginationCountryID='',NULL,OriginationCountryID),
				IF(DestinationType='',NULL,DestinationType),
				IF(DestinationCountryID='',NULL,DestinationCountryID),
				IF(code='',NULL,code),
				-- IF(description='',NULL,description),
				@row_num := @row_num+1 AS RowID,
				`Order`
			FROM tblRateRule,(SELECT @row_num := 0) x
			WHERE rategeneratorid = @p_RateGeneratorId
			ORDER BY `Order` ASC;  


									 		
			insert into tmp_Raterules_dup  	select 	*	from tmp_Raterules_;

		insert into tmp_code_ ( RateID, Code, Type, CountryID )
		SELECT RateID, Code, Type, CountryID from  tblRate WHERE CodeDeckID = @v_codedeckid_ ORDER BY Code ASC;
		
		insert into tmp_code_dup select * from 	tmp_code_;
		insert into tmp_code_dup2 select * from 	tmp_code_;

			insert into tmp_search_code_ ( RowCodeID,CodeID )
			SELECT DISTINCT r.CodeID as RowCodeID ,r2.CodeID as CodeID
			from tblRateSearchCode rsc
			INNER JOIN tmp_code_ r on    r.RateID = rsc.RowCodeRateID 
			INNER JOIN tmp_code_dup r2 on    r2.RateID = rsc.CodeRateID 
		 	INNER JOIN tmp_Raterules_ rr
				ON   ( fn_IsEmpty(rr.code)  OR rr.code = '*' OR (r.Code LIKE (REPLACE(rr.code,'*', '%%')) ))
						AND
				( fn_IsEmpty(rr.DestinationType)  OR ( r.`Type` = rr.DestinationType ))
						AND
				( fn_IsEmpty(rr.DestinationCountryID) OR (r.`CountryID` = rr.DestinationCountryID ))
			where rsc.CodeDeckID =  @v_codedeckid_;






		SELECT CurrencyId INTO @v_CompanyCurrencyID_ FROM  tblCompany WHERE CompanyID = @v_CompanyId_;

		SET @IncludeAccountIDs = (SELECT GROUP_CONCAT(AccountID) from tblRateRule rr inner join  tblRateRuleSource rrs on rr.RateRuleId = rrs.RateRuleId where rr.RateGeneratorId = @p_RateGeneratorId ) ;


		INSERT INTO tmp_tblAccounts ( AccountID,RateTableID, VendorConnectionID,VendorConnectionName )
		select distinct vt.AccountId,vt.RateTableID, vt.VendorConnectionID,vt.Name
		from tblVendorConnection vt
		inner join  tblRateTable ON   tblRateTable.CompanyID = vt.CompanyID  AND  tblRateTable.Type = vt.RateTypeID AND tblRateTable.AppliedTo = @v_AppliedToVendor 
		INNER JOIN tblAccount ON tblAccount.AccountID = vt.AccountId AND  tblAccount.CompanyID = tblRateTable.CompanyID AND vt.AccountId = tblAccount.AccountID
		where 		
		vt.CompanyID = @v_CompanyId_ 
		and vt.RateTypeID = @v_RateTypeID   
		and vt.Active = 1 
		and vt.TrunkID = @v_trunk_
		AND (fn_IsEmpty(@IncludeAccountIDs) OR FIND_IN_SET(tblAccount.AccountID,@IncludeAccountIDs) != 0 ) 
		AND tblAccount.IsVendor = 1 AND tblAccount.Status = 1;




		INSERT INTO tmp_tblRateTableRate (
			TimezonesID,
			VendorConnectionID,
			AccountID,
			OriginationRateID,
			RateID,
			Rate,
			RateN,
			ConnectionFee,
			Preference,
			MinimumDuration 
			)
			select 
				rtr.TimezonesID,VendorConnectionID,a.AccountID,OriginationRateID,RateID,
				CASE WHEN  rtr.RateCurrency IS NOT NULL 
				THEN
					CASE WHEN  rtr.RateCurrency = @v_CurrencyID_
					THEN
						rtr.Rate
					ELSE
					(
						-- Convert to base currrncy and x by RateGenerator Exhange
						(@v_DestinationCurrencyConversionRate )
						* (rtr.rate  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = rtr.RateCurrency and  CompanyID = @v_CompanyId_ ))
					)
					END
				ELSE 
					(
						(@v_DestinationCurrencyConversionRate )
						* (rtr.rate  / (@v_CompanyCurrencyConversionRate ))
					)
				END    
				as Rate,
				CASE WHEN  rtr.RateCurrency IS NOT NULL 
				THEN
					CASE WHEN  rtr.RateCurrency = @v_CurrencyID_
					THEN
						rtr.RateN
					ELSE
					(
						-- Convert to base currrncy and x by RateGenerator Exhange
						(@v_DestinationCurrencyConversionRate )
						* (rtr.RateN  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = rtr.RateCurrency and  CompanyID = @v_CompanyId_ ))
					)
					END
				ELSE 
					(
						(@v_DestinationCurrencyConversionRate )
						* (rtr.RateN  / (@v_CompanyCurrencyConversionRate ))
					)
				END    
				as RateN,
				CASE WHEN  rtr.ConnectionFeeCurrency IS NOT NULL 
				THEN
					CASE WHEN  rtr.ConnectionFeeCurrency = @v_CurrencyID_
					THEN
						rtr.ConnectionFee
					ELSE
					(
						-- Convert to base currrncy and x by RateGenerator Exhange
						(@v_DestinationCurrencyConversionRate )
						* (rtr.ConnectionFee  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = rtr.ConnectionFeeCurrency and  CompanyID = @v_CompanyId_ ))
					)
					END
				ELSE 
					(
						(@v_DestinationCurrencyConversionRate )
						* (rtr.ConnectionFee  / (@v_CompanyCurrencyConversionRate ))
					)
				END    
				as ConnectionFee,
				-- DATE(EffectiveDate) as EffectiveDate, 
				-- Interval1,
				-- IntervalN,
				IFNULL(Preference, 5) AS Preference,
				-- @v_CurrencyID_ as RateCurrency,
				-- @v_CurrencyID_ as ConnectionFeeCurrency,
				MinimumDuration

				from tblRateTableRate rtr
				INNER JOIN tmp_tblAccounts a on a.RateTableID = rtr.RateTableID
				where 
				(
					(@p_EffectiveRate = 'now' AND EffectiveDate <= NOW())
					OR
					(@p_EffectiveRate = 'future' AND EffectiveDate > NOW()  )
					OR
					(	 @p_EffectiveRate = 'effective' AND EffectiveDate <= @p_EffectiveDate
							AND ( rtr.EndDate IS NULL OR (rtr.EndDate > DATE(@p_EffectiveDate)) )
					)  
				)
				AND ( rtr.EndDate IS NULL OR rtr.EndDate > now() )  
				-- AND rtr.TimezonesID = @v_TimezonesID
				AND rtr.Blocked = 0;
  
 		  
				INSERT INTO tmp_VendorRate_detail 				
				(		TimezonesID,VendorConnectionID,AccountID,OriginationCodeID,CodeID,Rate, RateN,ConnectionFee,Preference,MinimumDuration )
				Select TimezonesID,VendorConnectionID,AccountID,OriginationCodeID,CodeID,Rate, RateN,ConnectionFee,Preference,MinimumDuration
				FROM (
						SELECT 
						
							TimezonesID,VendorConnectionID,AccountID,r2.CodeID as OriginationCodeID,r.CodeID as  CodeID,Rate,RateN,ConnectionFee,Preference,MinimumDuration,
							@row_num := IF(@prev_VendorConnectionID = VendorConnectionID AND @prev_TimezonesID = TimezonesID AND @prev_OriginationRateID = OriginationRateID AND @prev_RateID = RateID AND @prev_EffectiveDate >= EffectiveDate, @row_num + 1, 1) AS RowID,
							@prev_VendorConnectionID := VendorConnectionID,
							-- @prev_TrunkID := TrunkID,
							@prev_TimezonesID := TimezonesID,
							@prev_OriginationRateID := OriginationRateID,
							@prev_RateID := RateID,
							@prev_EffectiveDate := EffectiveDate
						FROM tmp_tblRateTableRate v
						INNER JOIN tmp_code_ r ON  r.RateId = v.RateID 
						LEFT JOIN tmp_code_dup r2 ON r2.RateId = v.OriginationRateID 
							,(SELECT @row_num := 1,  @prev_VendorConnectionID := 0 ,@prev_TimezonesID := 0, @prev_OriginationRateID := 0,@prev_RateID := 0, @prev_EffectiveDate := '') x
						ORDER BY v.VendorConnectionID, v.TimezonesID, r2.Code, r.Code, v.EffectiveDate DESC
					) tbl
				WHERE RowID = 1;
				

   
			insert into tmp_VendorRate_stage_1  
			SELECT
						distinct
						TimezonesID,
						VendorConnectionID,
						RowCodeID,
						OriginationCodeID,
						CodeID
			FROM (
	
						SELECT
						v.TimezonesID,
						v.VendorConnectionID,
						SplitCode.RowCodeID,
						v.OriginationCodeID,
						v.CodeID,
						@SingleRowCode := ( CASE WHEN( @prev_RowCodeRateID = RowCodeRateID  AND @prev_TimezonesID = TimezonesID  AND @prev_VendorConnectionID = VendorConnectionID     )
							THEN @SingleRowCode + 1
							ELSE 1  END ) AS SingleRowCode,
						@prev_RowCodeRateID := RowCodeRateID	 ,
						@prev_VendorConnectionID := VendorConnectionID ,
						@prev_TimezonesID := TimezonesID	 

					FROM tmp_VendorRate_detail v
					Inner join  tmp_search_code_ SplitCode on r.CodeID = SplitCode.CodeID

					, (SELECT   @prev_RowCodeRateID := '',  @SingleRowCode := 0 , @prev_VendorConnectionID := Null) f
					order by  v.TimezonesID,v.VendorConnectionID,SplitCode.RowCodeID,v.OriginationCodeID,v.CodeID desc
			)tmp  where SingleRowCode = 1;


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
		SET @v_rowCount_ = ( SELECT COUNT(TimezonesID) FROM ( SELECT DISTINCT TimezonesID FROM tmp_VendorRate_stage_1 WHERE TimezonesID != @v_default_TimezonesID group by TimezonesID ) tmp );
		SET @v_pointer_ = 1;
		
		IF @v_rowCount_ > 0 THEN 

				INSERT INTO tmp_VendorRate_stage_1_DEFAULT (
												TimezonesID,
												VendorConnectionID,
												RowCodeID,
												OriginationCodeID,
												CodeID

											)
											SELECT 
												TimezonesID,
												VendorConnectionID,
												RowCodeID,
												OriginationCodeID,
												CodeID
				FROM tmp_VendorRate_stage_1 
				WHERE TimezonesID = @v_default_TimezonesID;


				DELETE  FROM tmp_VendorRate_stage_1 WHERE TimezonesID = @v_default_TimezonesID;


				--	Query OK, 30,69,136 rows affected (50.03 sec)
				INSERT INTO tmp_VendorRate_stage_1_dup (
						TimezonesID,
						VendorConnectionID,
						RowCodeID,
						OriginationCodeID,
						CodeID


				)
				SELECT 
						TimezonesID,
						VendorConnectionID,
						RowCodeID,
						OriginationCodeID,
						CodeID
				FROM tmp_VendorRate_stage_1;

				insert into tmp_timezones (TimezonesID) select distinct TimezonesID from tmp_VendorRate_stage_1 WHERE TimezonesID != @v_default_TimezonesID;
				-- select GROUP_CONCAT(TimezonesID) INTO @v_rest_TimezonesIDs from tblTimezones WHERE TimezonesID != @v_default_TimezonesID;


				-- Query OK, 0 rows affected (22.90 sec)
				delete vd 
				from tmp_VendorRate_stage_1_dup vd
				INNER JOIN  tmp_VendorRate_stage_1_DEFAULT v
				ON v.VendorConnectionID = vd.VendorConnectionID AND
				-- v.TimezonesID  = vd.TimezonesID AND
				vd.OriginationCodeID = v.OriginationCodeID AND
				vd.RowCodeID = v.RowCodeID;


				WHILE @v_pointer_ <= @v_rowCount_
				DO

					SET @v_v_TimezonesID = ( SELECT TimezonesID FROM tmp_timezones WHERE ID = @v_pointer_ );

					INSERT INTO tmp_VendorRate_stage_1 (
						TimezonesID,
						VendorConnectionID,
						RowCodeID,
						OriginationCodeID,
						CodeID

					)
					SELECT 

						DISTINCT 
						@v_v_TimezonesID as TimezonesID , -- v.TimezonesID,
						VendorConnectionID,
						RowCodeID,
						OriginationCodeID,
						CodeID

 					FROM tmp_VendorRate_stage_1_DEFAULT vd
					LEFT JOIN tmp_VendorRate_stage_1_dup v on 
										-- v.VendorConnectionID != vd.VendorConnectionID AND
										v.TimezonesID  = @v_v_TimezonesID AND
 										vd.OriginationCodeID = v.OriginationCodeID AND
										vd.RowCodeID = v.RowCodeID;

					SET @v_pointer_ = @v_pointer_ + 1;

				END WHILE;
				
		END IF;



		-- LEAVE GenerateRateTable;
		
		INSERT INTO tmp_VendorRate_ (
				TimezonesID,
				VendorConnectionID,
				AccountID,
				RowCodeID,
				OriginationCodeID,
				CodeID,
				Rate,
				RateN,
				ConnectionFee,
				MinimumDuration
		)
		SELECT 
				DISTINCT
				vd.TimezonesID,
				vd.VendorConnectionID,
				vd.AccountID,
				vd.RowCodeID,
				vd.OriginationCodeID,
				vd.CodeID,
				v.Rate,
				v.RateN,
				v.ConnectionFee,
				v.MinimumDuration
		FROM tmp_VendorRate_stage_1 vd
		Inner JOIN tmp_VendorRate_detail v on 
			v.VendorConnectionID = vd.VendorConnectionID AND
			v.TimezonesID  = vd.TimezonesID AND
			vd.OriginationCodeID = v.OriginationCodeID AND
			vd.RowCodeID = v.RowCodeID;




		truncate table tmp_timezones;
		insert into tmp_timezones (TimezonesID) select distinct TimezonesID from tmp_VendorRate_;

		SET @v_t_pointer_ = 1;
		SET @v_t_rowCount_ = ( SELECT COUNT(TimezonesID) FROM tmp_timezones );

		-- need to add tiemzone in rate rule.
		WHILE @v_t_pointer_ <= @v_t_rowCount_
		DO

				SET @v_TimezonesID_ = ( SELECT TimezonesID FROM tmp_timezones WHERE ID = @v_t_pointer_ );

				SET @v_r_pointer_ = 1;
				SET @v_r_rowCount_ = ( SELECT COUNT(rateruleid) FROM tmp_Raterules_ );

				-- need to add tiemzone in rate rule.
				WHILE @v_r_pointer_ <= @v_r_rowCount_
				DO

					SET @v_rateRuleId_ = (SELECT rateruleid FROM tmp_Raterules_ rr WHERE rr.RowNo = @v_r_pointer_);

						truncate table tmp_Rates2_;
						INSERT INTO tmp_Rates2_ (
                        TimezonesID,
                        VendorConnectionID,
                        AccountID,
                        OriginationCodeID,
                        CodeID,
                        Rate,
                        RateN,
                        ConnectionFee,
                        MinimumDuration

							)
						select
                        TimezonesID,
                        VendorConnectionID,
                        AccountID,
                        OriginationCodeID,
                        CodeID,
                        Rate,
                        RateN,
                        ConnectionFee,
                        MinimumDuration

						from tmp_Rates_ where TimezonesID = @v_TimezonesID_;
 


					truncate tmp_final_VendorRate_;

					IF( @v_Use_Preference_ = 0 )
					THEN

						insert into tmp_final_VendorRate_
							SELECT
								DISTINCT
                      TimezonesID,
                      VendorConnectionID,
                      AccountID,
                      RowCodeID,
                      OriginationCodeID,
                      CodeID,
                      Rate,
                      RateN,
                      ConnectionFee,
                      MinimumDuration,
											FinalRankNumber
 								
							from
								(
									SELECT
                        DISTINCT
                        TimezonesID,
                        VendorConnectionID,
                        AccountID,
                        RowCodeID,
                        OriginationCodeID,
                        CodeID,
                        Rate,
                        RateN,
                        ConnectionFee,
                        MinimumDuration,
										@rank := CASE WHEN ( @prev_TimezonesID = vr.TimezonesID  AND  @prev_OriginationCodeID = vr.OriginationCodeID  AND  @prev_RowCodeID = vr.RowCodeID  AND @prev_Rate <  vr.Rate  AND (@v_percentageRate = 0 OR  (@v_percentageRate > 0 AND fn_Round((((vr.Rate - @prev_Rate) / @prev_Rate) * 100),2) > @v_percentageRate) ) ) THEN @rank+1
															WHEN ( @prev_TimezonesID = vr.TimezonesID  AND @prev_OriginationCodeID = vr.OriginationCodeID  AND  @prev_RowCodeID = vr.RowCodeID  AND @prev_Rate <  vr.Rate  AND (@v_percentageRate = 0 OR  (@v_percentageRate > 0 AND fn_Round((((vr.Rate - @prev_Rate) / @prev_Rate) * 100),2) <= @v_percentageRate) ) ) THEN -1 -- remove
															
															WHEN ( @prev_TimezonesID = vr.TimezonesID  AND @prev_OriginationCodeID = vr.OriginationCodeID  AND  @prev_RowCodeID = vr.RowCodeID  AND @prev_Rate =  vr.Rate  AND (@v_percentageRate = 0 OR  (@v_percentageRate > 0 AND fn_Round((((vr.Rate - @prev_Rate) / @prev_Rate) * 100),2) > @v_percentageRate) ) ) THEN @rank+1
															WHEN ( @prev_TimezonesID = vr.TimezonesID  AND @prev_OriginationCodeID = vr.OriginationCodeID  AND  @prev_RowCodeID = vr.RowCodeID  AND @prev_Rate =  vr.Rate  AND (@v_percentageRate = 0 OR  (@v_percentageRate > 0 AND fn_Round((((vr.Rate - @prev_Rate) / @prev_Rate) * 100),2) <= @v_percentageRate) ) ) THEN -1
															ELSE
																1
															END
										AS FinalRankNumber,
										@prev_OriginationCodeID  := vr.OriginationCodeID,
										@prev_RowCodeID  := vr.RowCodeID,
  										@prev_TimezonesID  := vr.TimezonesID,
										@prev_Rate  := vr.Rate
									from (
												select distinct tmpvr.*
												from tmp_VendorRate_  tmpvr
												Inner join  tmp_code_ r on tmpvr.TimezonesID = @v_TimezonesID_  AND r.CodeID = tmpvr.CodeID
												left join  tmp_code_dup r2   on   r2.CodeID = tmpvr.OriginationCodeID
												Inner join  tmp_code_dup2 RowCode   on RowCode.CodeID = tmpvr.RowCodeID

												inner JOIN tmp_Raterules_ rr ON rr.RateRuleId = @v_rateRuleId_
												AND (
													( fn_IsEmpty(rr.OriginationCode)  OR  (rr.OriginationCode = '*') OR ( r2.Code  LIKE (REPLACE(rr.OriginationCode,'*', '%%')) ) )
													AND
													( fn_IsEmpty(rr.OriginationType) OR ( r2.`Type` = rr.OriginationType ))
													AND
													( fn_IsEmpty(rr.OriginationCountryID) OR (r2.`CountryID` = rr.OriginationCountryID ))
												)
												AND																											
												(
														( fn_IsEmpty(rr.code) OR (rr.code = '*') OR ( RowCode.Code LIKE (REPLACE(rr.code,'*', '%%')) ))
														
														AND
														( fn_IsEmpty(rr.DestinationType) OR ( r.`Type` = rr.DestinationType ))
														AND
														( fn_IsEmpty(rr.DestinationCountryID) OR (r.`CountryID` = rr.DestinationCountryID ))
												)
												left JOIN tmp_Raterules_dup rr2 ON rr2.Order > rr.Order
												AND (
													( fn_IsEmpty(rr2.OriginationCode)  OR  (rr2.OriginationCode = '*') OR ( r2.Code  LIKE (REPLACE(rr2.OriginationCode,'*', '%%')) ) )
													AND
													( fn_IsEmpty(rr2.OriginationType) OR ( r2.`Type` = rr2.OriginationType ))
													AND
													( fn_IsEmpty(rr2.OriginationCountryID) OR (r2.`CountryID` = rr2.OriginationCountryID ))

												)
												AND
												(
													( fn_IsEmpty(rr2.code) OR (rr2.code = '*') OR ( RowCode.Code LIKE (REPLACE(rr2.code,'*', '%%')) ))

													AND
													( fn_IsEmpty(rr2.DestinationType) OR ( r.`Type` = rr2.DestinationType ))
													AND
													( fn_IsEmpty(rr2.DestinationCountryID) OR (r.`CountryID` = rr2.DestinationCountryID ))
												)
												inner JOIN tblRateRuleSource rrs ON  rrs.RateRuleId = rr.rateruleid  and rrs.AccountID = tmpvr.AccountID
												WHERE tmpvr.TimezonesID = @v_TimezonesID_ AND rr2.RateRuleId is null

											) vr
                    ,( SELECT @rank := 0 ,@prev_TimezonesID  := '', @prev_OriginationRateID := ''  , @prev_RowCodeID := '' ,  @prev_Rate := 0  ) x
									order by
                    vr.OriginationCodeID,vr.RowCodeID, vr.Rate,vr.VendorConnectionID,vr.TimezonesID
								) tbl1
							where FinalRankNumber <= @v_RatePosition_ AND FinalRankNumber != -1;

					ELSE


						insert into tmp_final_VendorRate_

							SELECT

								DISTINCT

                TimezonesID,
                VendorConnectionID,
                AccountID,
                RowCodeID,
                OriginationCodeID,
                CodeID,
                Rate,
                RateN,
                ConnectionFee,
                MinimumDuration,
                FinalRankNumber
							from
								(
									SELECT
                    TimezonesID,
                    VendorConnectionID,
                    AccountID,
                    RowCodeID,
                    OriginationCodeID,
                    CodeID,
                    Rate,
                    RateN,
                    ConnectionFee,
                    MinimumDuration,
                    MinimumDuration,

											@preference_rank := CASE WHEN (@prev_TimezonesID = vr.TimezonesID  AND @prev_OriginationCodeID    = vr.OriginationCodeID AND @prev_Code  = vr.RowCodeID  AND @prev_Preference > vr.Preference  )   THEN @preference_rank + 1
																	WHEN (@prev_TimezonesID = vr.TimezonesID  AND @prev_OriginationCodeID    = vr.OriginationCodeID AND @prev_Code  = vr.RowCodeID  AND @prev_Preference = vr.Preference AND @prev_Rate <= vr.Rate   AND  (@v_percentageRate = 0 OR  (@v_percentageRate > 0 AND fn_Round((((vr.Rate - @prev_Rate) / @prev_Rate) * 100),2) > @v_percentageRate) ) ) THEN @preference_rank + 1
																	WHEN (@prev_TimezonesID = vr.TimezonesID  AND @prev_OriginationCodeID    = vr.OriginationCodeID AND @prev_Code  = vr.RowCodeID  AND @prev_Preference = vr.Preference AND @prev_Rate <= vr.Rate   AND  (@v_percentageRate = 0 OR  (@v_percentageRate > 0 AND fn_Round((((vr.Rate - @prev_Rate) / @prev_Rate) * 100),2) <= @v_percentageRate) ) ) THEN -1 -- remove
																	ELSE 1 END

										AS FinalRankNumber,
										@prev_TimezonesID  := vr.TimezonesID,
										@prev_RowCodeID := vr.RowCodeID,
										@prev_OriginationCodeID := vr.OriginationCodeID,
 										@prev_Preference := vr.Preference,
										@prev_Rate := vr.Rate
									from (
                         select distinct tmpvr.*
                         from tmp_VendorRate_  tmpvr
                           Inner join  tmp_code_ r on tmpvr.TimezonesID = @v_TimezonesID_  AND r.CodeID = tmpvr.CodeID
                           left join  tmp_code_dup r2   on   r2.CodeID = tmpvr.OriginationCodeID
                           Inner join  tmp_code_dup2 RowCode   on RowCode.CodeID = tmpvr.RowCodeID

                           inner JOIN tmp_Raterules_ rr ON rr.RateRuleId = @v_rateRuleId_
                                   AND (
                                     ( fn_IsEmpty(rr.OriginationCode)  OR  (rr.OriginationCode = '*') OR ( r2.Code  LIKE (REPLACE(rr.OriginationCode,'*', '%%')) ) )
                                     AND
                                     ( fn_IsEmpty(rr.OriginationType) OR ( r2.`Type` = rr.OriginationType ))
                                     AND
                                     ( fn_IsEmpty(rr.OriginationCountryID) OR (r2.`CountryID` = rr.OriginationCountryID ))
                                   )
                                   AND
                                   (
                                     ( fn_IsEmpty(rr.code) OR (rr.code = '*') OR ( RowCode.Code LIKE (REPLACE(rr.code,'*', '%%')) ))

                                     AND
                                     ( fn_IsEmpty(rr.DestinationType) OR ( r.`Type` = rr.DestinationType ))
                                     AND
                                     ( fn_IsEmpty(rr.DestinationCountryID) OR (r.`CountryID` = rr.DestinationCountryID ))
                                   )
                           left JOIN tmp_Raterules_dup rr2 ON rr2.Order > rr.Order
                                    AND (
                                      ( fn_IsEmpty(rr2.OriginationCode)  OR  (rr2.OriginationCode = '*') OR ( r2.Code  LIKE (REPLACE(rr2.OriginationCode,'*', '%%')) ) )
                                      AND
                                      ( fn_IsEmpty(rr2.OriginationType) OR ( r2.`Type` = rr2.OriginationType ))
                                      AND
                                      ( fn_IsEmpty(rr2.OriginationCountryID) OR (r2.`CountryID` = rr2.OriginationCountryID ))

                                    )
                                    AND
                                    (
                                      ( fn_IsEmpty(rr2.code) OR (rr2.code = '*') OR ( RowCode.Code LIKE (REPLACE(rr2.code,'*', '%%')) ))

                                      AND
                                      ( fn_IsEmpty(rr2.DestinationType) OR ( r.`Type` = rr2.DestinationType ))
                                      AND
                                      ( fn_IsEmpty(rr2.DestinationCountryID) OR (r.`CountryID` = rr2.DestinationCountryID ))
                                    )
                           inner JOIN tblRateRuleSource rrs ON  rrs.RateRuleId = rr.rateruleid  and rrs.AccountID = tmpvr.AccountID
                           WHERE tmpvr.TimezonesID = @v_TimezonesID_ AND rr2.RateRuleId is null


                       ) vr
											,(SELECT @preference_rank := 0 , @prev_TimezonesID  := '' , @prev_OriginationCodeID := ''  ,  @prev_RowCodeID := ''  ,  @prev_Preference := 5,  @prev_Rate := 0 ) x
									order by
										vr.OriginationCodeID, vr.RowCodeID, vr.Preference DESC ,vr.Rate ASC ,vr.VendorConnectionID,vr.TimezonesID ASC
								) tbl1
							where FinalRankNumber <= @v_RatePosition_ AND FinalRankNumber != -1;


					END IF;



          truncate  table  tmp_VRatesstage2_;
          INSERT INTO tmp_VRatesstage2_
            SELECT
              DISTINCT

              vr.TimezonesID,
              vr.VendorConnectionID,
              vr.AccountID,
              vr.RowCodeID,
              vr.OriginationCodeID,
              vr.CodeID,
              vr.Rate,
              vr.RateN,
              vr.ConnectionFee,
              vr.MinimumDuration,
              vr.FinalRankNumber

            FROM tmp_final_VendorRate_ vr
              left join tmp_Rates2_ rate on rate.TimezonesID = vr.TimezonesID AND rate.CodeID = vr.CodeID AND rate.OriginationCodeID = vr.OriginationCodeID
            WHERE  rate.CodeID is null
            order by vr.FinalRankNumber desc ;



					IF @v_Average_ = 0
					THEN


            truncate tmp_dupVRatesstage2_;

            truncate tmp_dupVRatesstage2_;

            insert into tmp_dupVRatesstage2_
              SELECT DISTINCT
                  TimezonesID,
                  OriginationCodeID ,
                  RowCodeID,
                  MAX(FinalRankNumber) AS MaxFinalRankNumber
              FROM tmp_VRatesstage2_ GROUP BY TimezonesID,OriginationCodeID, RowCodeID;

            truncate tmp_Vendorrates_stage3_;
            INSERT INTO tmp_Vendorrates_stage3_
              select DISTINCT

                vr.TimezonesID,
                vr.VendorConnectionID,
                vr.AccountID,
                vr.RowCodeID,
                vr.OriginationCodeID,
                vr.CodeID,
                vr.Rate,
                vr.RateN,
                vr.ConnectionFee,
                vr.MinimumDuration,
                vr.FinalRankNumber
              from tmp_VRatesstage2_ vr
                INNER JOIN tmp_dupVRatesstage2_ vr2
                  ON ( vr.TimezonesID = vr2.TimezonesID AND vr.OriginationCodeID = vr2.OriginationCodeID  AND vr.RowCodeID = vr2.RowCodeID AND  vr.FinalRankNumber = vr2.FinalRankNumber );

						-- END IF;


            INSERT IGNORE INTO tmp_Rates_ (
              TimezonesID,
              VendorConnectionID,
              AccountID,
              OriginationCodeID,
              CodeID,
              Rate,
              RateN,
              ConnectionFee,
              MinimumDuration
            )
              SELECT 	DISTINCT
                TimezonesID,
                VendorConnectionID,
                AccountID,
                OriginationCodeID,
                RowCodeID as CodeID,
                CASE WHEN rule_mgn1.RateRuleId is not null
								THEN
									CASE WHEN trim(IFNULL(rule_mgn1.AddMargin,"")) != '' THEN
										vRate.rate + (CASE WHEN rule_mgn1.addmargin LIKE '%p' THEN ((CAST(REPLACE(rule_mgn1.addmargin, 'p', '') AS DECIMAL(18, 2)) / 100) * vRate.rate) ELSE rule_mgn1.addmargin END)
									WHEN trim(IFNULL(rule_mgn1.FixedValue,"")) != '' THEN
										rule_mgn1.FixedValue
									ELSE
										vRate.rate
									END
							ELSE
								vRate.rate
							END as Rate,
							CASE WHEN rule_mgn2.RateRuleId is not null
								THEN
									CASE WHEN trim(IFNULL(rule_mgn2.AddMargin,"")) != '' THEN
										vRate.rateN + (CASE WHEN rule_mgn2.addmargin LIKE '%p' THEN ((CAST(REPLACE(rule_mgn2.addmargin, 'p', '') AS DECIMAL(18, 2)) / 100) * vRate.rateN) ELSE rule_mgn2.addmargin END)
									WHEN trim(IFNULL(rule_mgn2.FixedValue,"")) != '' THEN
										rule_mgn2.FixedValue
									ELSE
										vRate.rateN
									END
							ELSE
								vRate.rateN
							END as RateN,
                 ConnectionFee,
                MinimumDuration

						FROM tmp_Vendorrates_stage3_ vRate
						LEFT join tblRateRuleMargin rule_mgn1 on  rule_mgn1.RateRuleId = @v_rateRuleId_ and ( (rule_mgn1.MinRate is null AND  rule_mgn1.MaxRate is null)   OR (vRate.rate Between rule_mgn1.MinRate and rule_mgn1.MaxRate) )
						LEFT join tblRateRuleMargin rule_mgn2 on  rule_mgn2.RateRuleId = @v_rateRuleId_ and ( (rule_mgn2.MinRate is null AND  rule_mgn2.MaxRate is null)   OR (vRate.rateN Between rule_mgn2.MinRate and rule_mgn2.MaxRate) );

					ELSE

            INSERT IGNORE INTO tmp_Rates_ (
              TimezonesID,
              VendorConnectionID,
              AccountID,
              OriginationCodeID,
              CodeID,
              Rate,
              RateN,
              ConnectionFee,
              MinimumDuration
            )
              SELECT 	DISTINCT
                TimezonesID,
                VendorConnectionID,
                AccountID,
                OriginationCodeID,
                RowCodeID as CodeID,
                CASE WHEN rule_mgn1.RateRuleId is not null
								THEN
									CASE WHEN trim(IFNULL(rule_mgn1.AddMargin,"")) != '' THEN
										vRate.rate + (CASE WHEN rule_mgn1.addmargin LIKE '%p' THEN ((CAST(REPLACE(rule_mgn1.addmargin, 'p', '') AS DECIMAL(18, 2)) / 100) * vRate.rate) ELSE rule_mgn1.addmargin END)
									WHEN trim(IFNULL(rule_mgn1.FixedValue,"")) != '' THEN
										rule_mgn1.FixedValue
									ELSE
										vRate.rate
									END
							ELSE
								vRate.rate
							END as Rate,
							CASE WHEN rule_mgn2.RateRuleId is not null
								THEN
									CASE WHEN trim(IFNULL(rule_mgn2.AddMargin,"")) != '' THEN
										vRate.rateN + (CASE WHEN rule_mgn2.addmargin LIKE '%p' THEN ((CAST(REPLACE(rule_mgn2.addmargin, 'p', '') AS DECIMAL(18, 2)) / 100) * vRate.rateN) ELSE rule_mgn2.addmargin END)
									WHEN trim(IFNULL(rule_mgn2.FixedValue,"")) != '' THEN
										rule_mgn2.FixedValue
									ELSE
										vRate.rateN
									END
							ELSE
								vRate.rateN
							END as RateN,
               ConnectionFee,
              MinimumDuration

						FROM
						(


							select
								DISTINCT


                DISTINCT
                RowCodeID AS RowCodeID,
                max(AccountID) as AccountID,
                OriginationCodeID,
                AVG(Rate) as Rate,
                AVG(RateN) as RateN,
                AVG(ConnectionFee) as ConnectionFee,
                max(VendorConnectionID) as VendorConnectionID,
                TimezonesID,
                max(MinimumDuration) as MinimumDuration

								from tmp_VRatesstage2_
								group by TimezonesID, OriginationCodeID , RowCodeID

						)  vRate
						LEFT join tblRateRuleMargin rule_mgn1 on  rule_mgn1.RateRuleId = @v_rateRuleId_ and ( (rule_mgn1.MinRate is null AND  rule_mgn1.MaxRate is null)   OR (vRate.rate Between rule_mgn1.MinRate and rule_mgn1.MaxRate) )
						LEFT join tblRateRuleMargin rule_mgn2 on  rule_mgn2.RateRuleId = @v_rateRuleId_ and ( (rule_mgn2.MinRate is null AND  rule_mgn2.MaxRate is null)   OR (vRate.rateN Between rule_mgn2.MinRate and rule_mgn2.MaxRate) );


					END IF;


					SET @v_r_pointer_ = @v_r_pointer_ + 1;


				END WHILE;

		SET @v_t_pointer_ = @v_t_pointer_ + 1;


	END WHILE;
		 


		IF @v_LessThenRate > 0 AND @v_ChargeRate > 0 THEN
		
			update tmp_Rates_
			SET Rate = @v_ChargeRate
			WHERE  Rate <  @v_LessThenRate;
			
			update tmp_Rates_
			SET RateN = @v_ChargeRate
			WHERE  RateN <  @v_LessThenRate;
			
		END IF;


		
		
		-- round before insert
		update tmp_Rates_
		SET 
		Rate = fn_Round(Rate,@v_RoundChargedAmount),
		RateN = fn_Round(RateN,@v_RoundChargedAmount),
		ConnectionFee = fn_Round(ConnectionFee,@v_RoundChargedAmount),
		EffectiveDate = @p_EffectiveDate;
		

--		leave GenerateRateTable; 




    /*
          COLLECT ALL DETAIL HERE AND MERGE INTO ONE TABLE.
        */

    DROP TEMPORARY TABLE IF EXISTS tmp_Rate_final ;
    CREATE TEMPORARY TABLE tmp_Rate_final (
      OriginationRateID INT,
      RateID INT  ,
      RateTableId INT,
      TimezonesID INT,
      Rate DECIMAL(18, 8),
      RateN DECIMAL(18, 8),
      PreviousRate DECIMAL(18, 8),
      ConnectionFee DECIMAL(18, 8),
      EffectiveDate DATE,
      Interval1 INT,
      IntervalN INT,
      -- ApprovedStatus INT,
      AccountID int,
      RateCurrency INT,
      ConnectionFeeCurrency INT,
      MinimumDuration int,
      INDEX INDEX1 (Rate),
      INDEX INDEX2 (TimezonesID),
      INDEX INDEX3 (EffectiveDate),
      INDEX INDEX4 (RateID,EffectiveDate)
    );

    INSERT INTO tmp_Rate_final
      SELECT
        distinct
        oc.RateID as OriginationRateID,
        c.RateID,
        @p_RateTableId,
        r.TimezonesID,
        r.Rate,
        r.RateN,
        r.Rate as PreviousRate,
        fn_Round(ve.ConnectionFee,@v_RoundChargedAmount) AS ConnectionFee,
        @p_EffectiveDate,
        tblRate.Interval1,
        tblRate.IntervalN,
        -- @v_RATE_STATUS_AWAITING as ApprovedStatus,
        ve.AccountID,
        @v_CurrencyID_ as RateCurrency,
        @v_CurrencyID_ as ConnectionFeeCurrency,
        ve.MinimumDuration
      FROM tmp_Rates_ r
        INNER JOIN tmp_code_  c on r.CodeID = c.CodeID
        INNER JOIN tmp_code_dup oc on r.OriginationCodeID = oc.CodeID

        INNER JOIN tblRate on tblRate.CodeDeckID = @v_codedeckid_  AND tblRate.RateID = c.RateID
        INNER JOIN tmp_OriginationCodes oc on oc.OriginationCodesID = vr.OriginationCodesID
        INNER JOIN tmp_VendorRate_ExtraFields ve on ve.VendorRate_ExtraFieldsID = vr.VendorRate_ExtraFieldsID;



    /*
      1. IF p_RateTableId = -1
      2. 		insert into tblRateTable
      3. 		INSERT INTO tblRateTableRate
      4. ELSE
      5.		IF p_delete_exiting_rate = 1
      6.			delete and archive
          END
      7.		UPDATE tmp_Rates_ SET EffectiveDate = p_EffectiveDate;
      8.		update PreviousRate
      9.		update v_IncreaseEffectiveDate_ and v_DecreaseEffectiveDate_
      10.		update EndDate rates which are existing in tmp_Rates_ with same code and timezone and rates are differents (rate.rate != tblRateTableRate.Rate).
      11.		archive
      12.		INSERT INTO tblRateTableRate
      13.		update EndDate which code is not existing in tmp_Rates_ (Remove codes which are not exists in tmp_Rates_)  and archive
      14.    	.
        END
      15.	update temp table tmp_ALL_RateTableRate_ temp.EndDate = EffectiveDate where rtr.EffectiveDate>temp.EffectiveDate
      16.	copy end date of tmp_ALL_RateTableRate_ to tblRateTableRate
      17.	update tblRateTable with RateGeneratorID , TrunkID, CodeDeckId, updated_at.
      18.	INSERT INTO tmp_JobLog_ (Message) VALUES (p_RateTableId);
        SELECT * FROM tmp_JobLog_;
        COMMIT;




    */


	START TRANSACTION;


	IF @p_RateTableId = -1
	THEN

		-- insert into tblRateTable
		SET @v_TerminationType = 1;

		INSERT INTO tblRateTable (Type,CompanyId, RateTableName, RateGeneratorID, TrunkID, CodeDeckId,CurrencyID,RoundChargedAmount,AppliedTo,Reseller)
		VALUES (@v_TerminationType, @v_CompanyId_, @p_rateTableName, @p_RateGeneratorId, @v_trunk_, @v_codedeckid_,@v_CurrencyID_,@v_RoundChargedAmount,@v_AppliedTo,@v_Reseller);


		SET @p_RateTableId = LAST_INSERT_ID();

		
		IF (@v_RateApprovalProcess_ = 1 ) THEN 
								
								INSERT INTO tblRateTableRateAA (
											OriginationRateID,
											RateID,
											RateTableId,
											TimezonesID,
											Rate,
											RateN,
											EffectiveDate,
											PreviousRate,
											Interval1,
											IntervalN,
											ConnectionFee,
											ApprovedStatus,
											VendorID,
											RateCurrency,
											ConnectionFeeCurrency,
											MinimumDuration
											)
									SELECT DISTINCT
										IFNULL(r.RateID,0) as OriginationRateID,
										tblRate.RateId,
										@p_RateTableId,
										rate.TimezonesID,
										rate.Rate,
										rate.RateN,
										@p_EffectiveDate,
										rate.Rate,
										tblRate.Interval1,
										tblRate.IntervalN,
										rate.ConnectionFee,
										@v_RATE_STATUS_AWAITING as ApprovedStatus,
										rate.AccountID,
										rate.RateCurrency,
										rate.ConnectionFeeCurrency,
										rate.MinimumDuration
										
									FROM tmp_Rates_ rate
										INNER JOIN tblRate
											ON rate.code  = tblRate.Code
										LEFT JOIN tblRate r
											ON rate.OriginationCode  = r.Code AND  r.CodeDeckId = tblRate.CodeDeckId
											
									WHERE tblRate.CodeDeckId = @v_codedeckid_;

				
			ELSE 
				
					INSERT INTO tblRateTableRate (
											OriginationRateID,
											RateID,
											RateTableId,
											TimezonesID,
											Rate,
											RateN,
											EffectiveDate,
											PreviousRate,
											Interval1,
											IntervalN,
											ConnectionFee,
											ApprovedStatus,
											VendorID,
											RateCurrency,
											ConnectionFeeCurrency,
											MinimumDuration
										)
					SELECT DISTINCT
										IFNULL(r.RateID,0) as OriginationRateID,
										tblRate.RateId,
										@p_RateTableId,
										rate.TimezonesID,
										rate.Rate,
										rate.RateN,
										@p_EffectiveDate,
										rate.Rate,
										tblRate.Interval1,
										tblRate.IntervalN,
										rate.ConnectionFee,
										@v_RATE_STATUS_APPROVED as ApprovedStatus,
										rate.AccountID,
										rate.RateCurrency,
										rate.ConnectionFeeCurrency,
										rate.MinimumDuration
							
						FROM tmp_Rates_ rate
							INNER JOIN tblRate
								ON rate.code  = tblRate.Code
							LEFT JOIN tblRate r
								ON rate.OriginationCode  = r.Code AND  r.CodeDeckId = tblRate.CodeDeckId
								
						WHERE tblRate.CodeDeckId = @v_codedeckid_;
						

			END IF;		
			
			
	ELSE 

			-- delete existing rates 
			IF @p_delete_exiting_rate = 1
			THEN
				
				IF (@v_RateApprovalProcess_ = 1 ) THEN 

					UPDATE
						tblRateTableRateAA
					SET
						EndDate = NOW()
					WHERE
						RateTableId = @p_RateTableId ; -- AND TimezonesID = @v_TimezonesID;
				
					
					CALL prc_ArchiveOldRateTableRateAA(@p_RateTableId,NULL,CONCAT(@p_ModifiedBy,'|RateGenerator')); 
				
				ELSE 

					UPDATE
						tblRateTableRate
					SET
						EndDate = NOW()
					WHERE
						RateTableId = @p_RateTableId ; -- AND TimezonesID = @v_TimezonesID;

					
					CALL prc_ArchiveOldRateTableRate(@p_RateTableId,NULL,CONCAT(@p_ModifiedBy,'|RateGenerator')); 
				
					
				END IF;
				
				
			END IF;	
			
			
			IF (@v_RateApprovalProcess_ = 1 ) THEN 

				UPDATE
					tmp_Rates_ tr
				SET
					PreviousRate = (SELECT rtr.Rate FROM tblRateTableRateAA rtr JOIN tblRate r ON r.RateID=rtr.RateID WHERE rtr.RateTableID=@p_RateTableId AND rtr.TimezonesID=tr.TimezonesID AND r.Code=tr.Code AND rtr.EffectiveDate<tr.EffectiveDate ORDER BY rtr.EffectiveDate DESC,rtr.RateTableRateID DESC LIMIT 1);

				UPDATE
					tmp_Rates_ tr
				SET
					PreviousRate = (SELECT rtr.Rate FROM tblRateTableRateArchive rtr JOIN tblRate r ON r.RateID=rtr.RateID WHERE rtr.RateTableID=@p_RateTableId AND rtr.TimezonesID=tr.TimezonesID AND r.Code=tr.Code AND rtr.EffectiveDate<tr.EffectiveDate ORDER BY rtr.EffectiveDate DESC,rtr.RateTableRateID DESC LIMIT 1)
				WHERE
					PreviousRate is null;

			ELSE 

					UPDATE
						tmp_Rates_ tr
					SET
						PreviousRate = (SELECT rtr.Rate FROM tblRateTableRate rtr JOIN tblRate r ON r.RateID=rtr.RateID WHERE rtr.RateTableID=@p_RateTableId AND rtr.TimezonesID=tr.TimezonesID AND r.Code=tr.Code AND rtr.EffectiveDate<tr.EffectiveDate ORDER BY rtr.EffectiveDate DESC,rtr.RateTableRateID DESC LIMIT 1);

					UPDATE
						tmp_Rates_ tr
					SET
						PreviousRate = (SELECT rtr.Rate FROM tblRateTableRateArchive rtr JOIN tblRate r ON r.RateID=rtr.RateID WHERE rtr.RateTableID=@p_RateTableId AND rtr.TimezonesID=tr.TimezonesID AND r.Code=tr.Code AND rtr.EffectiveDate<tr.EffectiveDate ORDER BY rtr.EffectiveDate DESC,rtr.RateTableRateID DESC LIMIT 1)
					WHERE
						PreviousRate is null;

						
			END IF;

					
			IF @v_IncreaseEffectiveDate_ != @v_DecreaseEffectiveDate_ THEN

				UPDATE tmp_Rates_
				SET
					EffectiveDate =		CASE WHEN PreviousRate < Rate 
											THEN
												@v_IncreaseEffectiveDate_
											WHEN PreviousRate > Rate THEN
												@v_DecreaseEffectiveDate_
											ELSE @p_EffectiveDate
										END;

			END IF;	
			
			-- delete same rates 
			IF (@v_RateApprovalProcess_ = 1 ) THEN 

				UPDATE
					tblRateTableRateAA rtr
				INNER JOIN
					tblRate ON tblRate.RateId = rtr.RateId
						AND rtr.RateTableId = @p_RateTableId
					
				INNER JOIN
					tmp_Rates_ rate ON

					
					rtr.EffectiveDate = @p_EffectiveDate 
				SET
					rtr.EndDate = NOW()
				WHERE
					(
						( /*@p_GroupBy != 'Desc'  AND*/ rate.code = tblRate.Code )

						-- OR						(@p_GroupBy = 'Desc' AND rate.description = tblRate.description )
					)
					AND
					rtr.TimezonesID = rate.TimezonesID AND
					rtr.RateTableId = @p_RateTableId AND
					tblRate.CodeDeckId = @v_codedeckid_ AND
					rate.rate != rtr.Rate;

				CALL prc_ArchiveOldRateTableRateAA(@p_RateTableId,NULL,CONCAT(@p_ModifiedBy,'|RateGenerator')); 

			ELSE 
			
				
				
				UPDATE
					tblRateTableRate rtr
				INNER JOIN
					tblRate ON tblRate.RateId = rtr.RateId
						AND rtr.RateTableId = @p_RateTableId
					
				INNER JOIN
					tmp_Rates_ as rate ON

					
					rtr.EffectiveDate = @p_EffectiveDate 
				SET
					rtr.EndDate = NOW()
				WHERE
					(
						(/*@p_GroupBy != 'Desc'  AND*/ rate.code = tblRate.Code )

						-- OR						(@p_GroupBy = 'Desc' AND rate.description = tblRate.description )
					)
					AND
					rtr.TimezonesID = rate.TimezonesID AND
					rtr.RateTableId = @p_RateTableId AND
					tblRate.CodeDeckId = @v_codedeckid_ AND
					rate.rate != rtr.Rate;
	
				CALL prc_ArchiveOldRateTableRate(@p_RateTableId,NULL,CONCAT(@p_ModifiedBy,'|RateGenerator')); 

			
			END IF; 
	
			IF (@v_RateApprovalProcess_ = 1 ) THEN 
				
				
					INSERT INTO tblRateTableRateAA (
						OriginationRateID,
						RateID,
						RateTableId,
						TimezonesID,
						Rate,
						RateN,
						EffectiveDate,
						PreviousRate,
						Interval1,
						IntervalN,
						ConnectionFee,
						ApprovedStatus,
						VendorID,
						RateCurrency,
						ConnectionFeeCurrency,
						MinimumDuration 
					)
						
					SELECT DISTINCT
							IFNULL(r.RateID,0) as OriginationRateID,
							tblRate.RateId,
							@p_RateTableId AS RateTableId,
							rate.TimezonesID AS TimezonesID,
							rate.Rate,
							rate.RateN,
							rate.EffectiveDate,
							rate.PreviousRate,
							tblRate.Interval1,
							tblRate.IntervalN,
							rate.ConnectionFee,
							@v_RATE_STATUS_AWAITING as ApprovedStatus,
							rate.AccountID,
							rate.RateCurrency,
							rate.ConnectionFeeCurrency,
							rate.MinimumDuration
							
						FROM tmp_Rates_ rate
							INNER JOIN tblRate
								ON rate.code  = tblRate.Code
							LEFT JOIN tblRate r
								ON rate.OriginationCode  = r.Code AND  r.CodeDeckId = tblRate.CodeDeckId
								
							LEFT JOIN tblRateTableRateAA tbl1
								ON tblRate.RateId = tbl1.RateId
									AND tbl1.RateTableId = @p_RateTableId
									AND tbl1.TimezonesID = rate.TimezonesID
							LEFT JOIN tblRateTableRateAA tbl2
								ON tblRate.RateId = tbl2.RateId
									and tbl2.EffectiveDate = rate.EffectiveDate
									AND tbl2.RateTableId = @p_RateTableId
									AND tbl2.TimezonesID = rate.TimezonesID
						WHERE  (    tbl1.RateTableRateID IS NULL
										OR
										(
											tbl2.RateTableRateID IS NULL
											AND  tbl1.EffectiveDate != rate.EffectiveDate

										)
							)
							AND tblRate.CodeDeckId = @v_codedeckid_;

					-- delete rate not exists in tmp_Rates_
					UPDATE
						tblRateTableRateAA rtr
					INNER JOIN
						tblRate ON rtr.RateId  = tblRate.RateId
					LEFT JOIN
						tmp_Rates_ rate ON rate.Code=tblRate.Code
					SET
						rtr.EndDate = NOW()
					WHERE
						rate.Code is null 
						AND rtr.RateTableId = @p_RateTableId 
						AND rtr.TimezonesID = rate.TimezonesID 
						AND rtr.EffectiveDate = rate.EffectiveDate 
						AND tblRate.CodeDeckId = @v_codedeckid_;

					

					CALL prc_ArchiveOldRateTableRateAA(@p_RateTableId,NULL,CONCAT(@p_ModifiedBy,'|RateGenerator')); 

			ELSE 
			
					
					INSERT INTO tblRateTableRate 
					(
						OriginationRateID,
						RateID,
						RateTableId,
						TimezonesID,
						Rate,
						RateN,
						EffectiveDate,
						PreviousRate,
						Interval1,
						IntervalN,
						ConnectionFee,
						ApprovedStatus,
						VendorID,
						RateCurrency,
						ConnectionFeeCurrency,
						MinimumDuration 
					)
						
					SELECT DISTINCT
							IFNULL(r.RateID,0) as OriginationRateID,
							tblRate.RateId,
							@p_RateTableId AS RateTableId,
							rate.TimezonesID AS TimezonesID,
							rate.Rate,
							rate.RateN,
							rate.EffectiveDate,
							rate.PreviousRate,
							tblRate.Interval1,
							tblRate.IntervalN,
							rate.ConnectionFee,
							@v_RATE_STATUS_APPROVED as ApprovedStatus,
							rate.AccountID,
							rate.RateCurrency,
							rate.ConnectionFeeCurrency,
							rate.MinimumDuration
						FROM tmp_Rates_ rate
							INNER JOIN tblRate
								ON rate.code  = tblRate.Code
							LEFT JOIN tblRate r
								ON rate.OriginationCode  = r.Code AND  r.CodeDeckId = tblRate.CodeDeckId
								
							LEFT JOIN tblRateTableRate tbl1
								ON tblRate.RateId = tbl1.RateId
									AND tbl1.RateTableId = @p_RateTableId
									AND tbl1.TimezonesID = rate.TimezonesID
							LEFT JOIN tblRateTableRate tbl2
								ON tblRate.RateId = tbl2.RateId
									and tbl2.EffectiveDate = rate.EffectiveDate
									AND tbl2.RateTableId = @p_RateTableId
									AND tbl2.TimezonesID = rate.TimezonesID
						WHERE  (    tbl1.RateTableRateID IS NULL
										OR
										(
											tbl2.RateTableRateID IS NULL
											AND  tbl1.EffectiveDate != rate.EffectiveDate

										)
							)
							AND tblRate.CodeDeckId = @v_codedeckid_;

			-- delete rate not exists in tmp_Rates_
			UPDATE
				tblRateTableRate rtr
			INNER JOIN
				tblRate ON rtr.RateId  = tblRate.RateId
			LEFT JOIN
				tmp_Rates_ rate ON rate.Code=tblRate.Code
			SET
				rtr.EndDate = NOW()
			WHERE
				rate.Code is null 
				AND rtr.RateTableId = @p_RateTableId 
				AND rtr.TimezonesID = rate.TimezonesID 
				AND rtr.EffectiveDate = rate.EffectiveDate 
				AND tblRate.CodeDeckId = @v_codedeckid_;
	

			CALL prc_ArchiveOldRateTableRate(@p_RateTableId,NULL,CONCAT(@p_ModifiedBy,'|RateGenerator')); 

			
		END IF;



			
			
		-- insert EndDate = EffectiveDate of future same rate 
		IF (@v_RateApprovalProcess_ = 1 ) THEN 

			
				INSERT INTO tmp_ALL_RateTableRate_ 
				SELECT * FROM tblRateTableRateAA WHERE RateTableID=@p_RateTableId ; -- AND TimezonesID=@v_TimezonesID;


				UPDATE
					tmp_ALL_RateTableRate_ temp
				SET
					EndDate = ( SELECT EffectiveDate 
								FROM tblRateTableRateAA rtr 
								WHERE rtr.RateTableID=@p_RateTableId 
								AND rtr.TimezonesID=temp.TimezonesID 
								AND rtr.RateID=temp.RateID 
								AND rtr.EffectiveDate > temp.EffectiveDate 
								ORDER BY rtr.EffectiveDate ASC, rtr.TimezonesID , rtr.RateID  ASC LIMIT 1
							)
				WHERE
					temp.RateTableId = @p_RateTableId; -- AND temp.TimezonesID = @v_TimezonesID;

				UPDATE
					tblRateTableRateAA rtr
				INNER JOIN
					tmp_ALL_RateTableRate_ temp ON 
						rtr.RateTableID=temp.RateTableID 
					AND rtr.TimezonesID=temp.TimezonesID 
					AND rtr.RateID = temp.RateID 
					AND rtr.EffectiveDate = temp.EffectiveDate
				SET
					rtr.EndDate=temp.EndDate,
					rtr.ApprovedStatus = @v_RATE_STATUS_AWAITING
				WHERE
					rtr.RateTableId=@p_RateTableId ; -- AND		rtr.TimezonesID=@v_TimezonesID;
				
				
				CALL prc_ArchiveOldRateTableRateAA(@p_RateTableId,NULL,CONCAT(@p_ModifiedBy,'|RateGenerator')); 


		ELSE	

				INSERT INTO tmp_ALL_RateTableRate_ 
				SELECT * FROM tblRateTableRate WHERE RateTableID=@p_RateTableId; -- AND TimezonesID=@v_TimezonesID;


				UPDATE
					tmp_ALL_RateTableRate_ temp
				SET
					EndDate = (SELECT EffectiveDate FROM tblRateTableRate rtr WHERE rtr.RateTableID=@p_RateTableId AND rtr.TimezonesID=temp.TimezonesID AND rtr.RateID=temp.RateID AND rtr.EffectiveDate>temp.EffectiveDate ORDER BY rtr.EffectiveDate ASC,rtr.RateTableRateID ASC LIMIT 1)
				WHERE
					temp.RateTableId = @p_RateTableId ; -- AND temp.TimezonesID = @v_TimezonesID;

				UPDATE
					tblRateTableRate rtr
				INNER JOIN
					tmp_ALL_RateTableRate_ temp ON rtr.RateTableRateID=temp.RateTableRateID AND rtr.TimezonesID=temp.TimezonesID
				SET
					rtr.EndDate=temp.EndDate,
					rtr.ApprovedStatus = @v_RATE_STATUS_APPROVED
				WHERE
					rtr.RateTableId=@p_RateTableId ; -- AND					rtr.TimezonesID=@v_TimezonesID;
				

				
				CALL prc_ArchiveOldRateTableRate(@p_RateTableId,NULL,CONCAT(@p_ModifiedBy,'|RateGenerator')); 


		END IF;

	END IF;

	UPDATE tblRateTable
	SET RateGeneratorID = @p_RateGeneratorId,
		TrunkID = @v_trunk_,
		CodeDeckId = @v_codedeckid_,
		updated_at = now()
	WHERE RateTableID = @p_RateTableId;


	IF(@p_RateTableId > 0 ) THEN

		INSERT INTO tmp_JobLog_ (Message) VALUES (@p_RateTableId);

	ELSE 
		INSERT INTO tmp_JobLog_ (Message) VALUES ('No data found');

	END IF;

	SELECT * FROM tmp_JobLog_;

	COMMIT;


	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;


	END//
DELIMITER ;
