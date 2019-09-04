DROP PROCEDURE IF EXISTS `prc_WSGenerateRateTable`;
DELIMITER //
CREATE PROCEDURE `prc_WSGenerateRateTable`(
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


		SET	@v_RateTypeID = 1;	-- //1 - Termination 2 - DID 3 - Package
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

		DROP TEMPORARY TABLE IF EXISTS tmp_Rates_;
		CREATE TEMPORARY TABLE tmp_Rates_  (
			Originationcode VARCHAR(50) COLLATE utf8_unicode_ci,
			Originationdescription VARCHAR(200) COLLATE utf8_unicode_ci,
			code VARCHAR(50) COLLATE utf8_unicode_ci,
			description VARCHAR(200) COLLATE utf8_unicode_ci,
			rate DECIMAL(18, 8),
			rateN DECIMAL(18, 8),
			ConnectionFee DECIMAL(18, 8),
			PreviousRate DECIMAL(18, 8),
			EffectiveDate DATE DEFAULT NULL,
			AccountID int,
			VendorConnectionID int,
			TimezonesID int,
			RateCurrency int,
			ConnectionFeeCurrency int,
			MinimumDuration int,
			INDEX tmp_Rates_code (`code`),
			INDEX  tmp_Rates_description (`description`)
			-- UNIQUE KEY `unique_code` (`code`)

		);


		DROP TEMPORARY TABLE IF EXISTS tmp_Rates2_;
		CREATE TEMPORARY TABLE tmp_Rates2_  (
			OriginationCode VARCHAR(50) COLLATE utf8_unicode_ci,
			Originationdescription VARCHAR(200) COLLATE utf8_unicode_ci,
			code VARCHAR(50) COLLATE utf8_unicode_ci,
			description VARCHAR(200) COLLATE utf8_unicode_ci,
			rate DECIMAL(18, 8),
			rateN DECIMAL(18, 8),
			ConnectionFee DECIMAL(18, 8),
			PreviousRate DECIMAL(18, 8),
			EffectiveDate DATE DEFAULT NULL,
			AccountID int,
			VendorConnectionID int,
			TimezonesID int,
			RateCurrency int,
			ConnectionFeeCurrency int,
			MinimumDuration int,
			INDEX tmp_Rates2_code (`code`),
			INDEX  tmp_Rates_description (`description`)
		);


		DROP TEMPORARY TABLE IF EXISTS tmp_Rates3_;
		CREATE TEMPORARY TABLE tmp_Rates3_  (
			OriginationCode VARCHAR(50) COLLATE utf8_unicode_ci,
			Originationdescription VARCHAR(200) COLLATE utf8_unicode_ci,
			code VARCHAR(50) COLLATE utf8_unicode_ci,
			description VARCHAR(200) COLLATE utf8_unicode_ci,
			-- UNIQUE KEY `unique_code` (`code`),
			INDEX  tmp_Rates_description (`description`)
		);


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
			Originationdescription VARCHAR(200) COLLATE utf8_unicode_ci,
			OriginationType VARCHAR(200) COLLATE utf8_unicode_ci,
			OriginationCountryID INT,
			DestinationType VARCHAR(200) COLLATE utf8_unicode_ci,
			DestinationCountryID INT,
			code VARCHAR(50) COLLATE utf8_unicode_ci,
			description VARCHAR(200) COLLATE utf8_unicode_ci,
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
			Originationdescription VARCHAR(200) COLLATE utf8_unicode_ci,
			OriginationType VARCHAR(200) COLLATE utf8_unicode_ci,
			OriginationCountryID INT,
			DestinationType VARCHAR(200) COLLATE utf8_unicode_ci,
			DestinationCountryID INT,
			code VARCHAR(50) COLLATE utf8_unicode_ci,
			description VARCHAR(200) COLLATE utf8_unicode_ci,
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


		DROP TEMPORARY TABLE IF EXISTS tmp_VRatesstage2_;
		CREATE TEMPORARY TABLE tmp_VRatesstage2_  (
			RowCode VARCHAR(50) COLLATE utf8_unicode_ci,
			OriginationCode varchar(50),
			OriginationDescription varchar(200),
			code VARCHAR(50) COLLATE utf8_unicode_ci,
			description VARCHAR(200) COLLATE utf8_unicode_ci,
			rate DECIMAL(18, 8),
			rateN DECIMAL(18, 8),
			ConnectionFee DECIMAL(18, 8),
			FinalRankNumber int,
			VendorConnectionID int,
			TimezonesID int,
			AccountID INT,
			RateCurrency int,
			ConnectionFeeCurrency int,
			MinimumDuration int,
			INDEX tmp_Vendorrates_stage2__code (`RowCode`)
		);
		DROP TEMPORARY TABLE IF EXISTS tmp_dupVRatesstage2_;
		CREATE TEMPORARY TABLE tmp_dupVRatesstage2_  (
			TimezonesID int,
			OriginationCode VARCHAR(50) COLLATE utf8_unicode_ci,
			OriginationDescription VARCHAR(200) COLLATE utf8_unicode_ci,
			RowCode VARCHAR(50)  COLLATE utf8_unicode_ci,
			description VARCHAR(200) COLLATE utf8_unicode_ci,
			FinalRankNumber int,
			INDEX tmp_dupVendorrates_stage2__code (`RowCode`)
		);
		DROP TEMPORARY TABLE IF EXISTS tmp_Vendorrates_stage3_;
		CREATE TEMPORARY TABLE tmp_Vendorrates_stage3_  (
			OriginationCode VARCHAR(50) COLLATE utf8_unicode_ci,
			OriginationDescription VARCHAR(200) COLLATE utf8_unicode_ci,
			RowCode VARCHAR(50) COLLATE utf8_unicode_ci,
			description VARCHAR(200) COLLATE utf8_unicode_ci,
			rate DECIMAL(18, 8),
			rateN DECIMAL(18, 8),
			ConnectionFee DECIMAL(18, 8),
			VendorConnectionID int,
			TimezonesID int,
			AccountID INT,
			RateCurrency int,
			ConnectionFeeCurrency int,
			MinimumDuration int,
			INDEX tmp_Vendorrates_stage2__code (`RowCode`)
		);

		/*DROP TEMPORARY TABLE IF EXISTS tmp_code_;
		CREATE TEMPORARY TABLE tmp_code_  (
			RowCode VARCHAR(50) COLLATE utf8_unicode_ci,
			code VARCHAR(50) COLLATE utf8_unicode_ci,
			INDEX tmp_code_code1 (`RowCode`),
			INDEX tmp_code_code2 (`code`)
		);*/
		
		
		DROP TEMPORARY TABLE IF EXISTS tmp_search_code_;
		CREATE TEMPORARY TABLE tmp_search_code_ (
			RowCodeRateID  INT,
			CodeRateID  INT,
			CountryID int,
			Code  varchar(50),
			RowCode  varchar(50),
			INDEX Index1 (RowCodeRateID),
			INDEX Index2 (CodeRateID),
			INDEX Index3 (Code)
		);


		DROP TEMPORARY TABLE IF EXISTS tmp_code_origination;
		CREATE TEMPORARY TABLE tmp_code_origination  (
			RateID INT,
			-- CountryID int,
			-- code VARCHAR(50) COLLATE utf8_unicode_ci,
			INDEX tmp_code_code (`RateID`)
		);

		
		/*DROP TEMPORARY TABLE IF EXISTS tmp_all_code_;
		CREATE TEMPORARY TABLE tmp_all_code_ (
			RowCode  varchar(50) COLLATE utf8_unicode_ci,
			Code  varchar(50) COLLATE utf8_unicode_ci,
			RowNo int,
			INDEX Index2 (Code)
		);*/



		DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_stage_;
		CREATE TEMPORARY TABLE tmp_VendorRate_stage_ (
			RowCode VARCHAR(50) COLLATE utf8_unicode_ci,
			VendorConnectionID INT ,
			TimezonesID int,
			AccountID INT,
			VendorConnectionName VARCHAR(100) ,
			OriginationCode varchar(50),
			OriginationDescription varchar(200),
			Code VARCHAR(50) COLLATE utf8_unicode_ci,
			Rate DECIMAL(18, 8) ,
			RateN DECIMAL(18, 8) ,
			ConnectionFee DECIMAL(18, 8) ,
			EffectiveDate DATETIME ,
			Description VARCHAR(255),
			Preference INT,
			RateCurrency int,
			ConnectionFeeCurrency int,
			MinimumDuration int,
			MaxMatchRank int ,
			prev_prev_OriginationCode VARCHAR(50),
			prev_prev_RowCode VARCHAR(50),
			prev_VendorConnectionID int,
			prev_TimezonesID int,
			INDEX Index1 (MaxMatchRank)


		);

		DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_stage_1;
		CREATE TEMPORARY TABLE tmp_VendorRate_stage_1 (
			RowCode VARCHAR(50) COLLATE utf8_unicode_ci,
			RowCodeRateID int,
			VendorConnectionID INT ,
			TimezonesID int,
			AccountID INT,
			VendorConnectionName VARCHAR(100) ,
			OriginationCode varchar(50),
			OriginationDescription varchar(200),
			RateID int,
			Code VARCHAR(50) COLLATE utf8_unicode_ci,
			Rate DECIMAL(18, 8) ,
			RateN DECIMAL(18, 8) ,
			ConnectionFee DECIMAL(18, 8) ,
			EffectiveDate DATETIME ,
			Description VARCHAR(255),
			Preference INT,
			RateCurrency int,
			ConnectionFeeCurrency int,
			MinimumDuration int,
			MaxMatchRank int ,
			prev_prev_OriginationCode VARCHAR(50),
			prev_prev_RowCode VARCHAR(50),
			prev_VendorConnectionID int,
			prev_TimezonesID int,
			INDEX Index1 (TimezonesID),
			-- INDEX Index2 (Code),
			INDEX Index2 (RowCode,TimezonesID,VendorConnectionID , OriginationCode,Code)


		);

		DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_stage_1_dup;
		CREATE TEMPORARY TABLE tmp_VendorRate_stage_1_dup (
			RowCode VARCHAR(50) COLLATE utf8_unicode_ci,
			RowCodeRateID int,
			VendorConnectionID INT ,
			TimezonesID int,
			AccountID INT,
			VendorConnectionName VARCHAR(100) ,
			OriginationCode varchar(50),
			OriginationDescription varchar(200),
			RateID int,
			Code VARCHAR(50) COLLATE utf8_unicode_ci,
			Rate DECIMAL(18, 8) ,
			RateN DECIMAL(18, 8) ,
			ConnectionFee DECIMAL(18, 8) ,
			EffectiveDate DATETIME ,
			Description VARCHAR(255),
			Preference INT,
			RateCurrency int,
			ConnectionFeeCurrency int,
			MinimumDuration int,
			MaxMatchRank int ,
			INDEX Index1 (VendorConnectionID),
			INDEX Index2 (TimezonesID,OriginationCode,RowCodeRateID)
 

		);

		DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_stage_1_DEFAULT;
		CREATE TEMPORARY TABLE tmp_VendorRate_stage_1_DEFAULT (
			RowCode VARCHAR(50) COLLATE utf8_unicode_ci,
			RowCodeRateID int,
			VendorConnectionID INT ,
			TimezonesID int,
			AccountID INT,
			VendorConnectionName VARCHAR(100) ,
			OriginationCode varchar(50),
			OriginationDescription varchar(200),
			RateID int,
			Code VARCHAR(50) COLLATE utf8_unicode_ci,
			Rate DECIMAL(18, 8) ,
			RateN DECIMAL(18, 8) ,
			ConnectionFee DECIMAL(18, 8) ,
			EffectiveDate DATETIME ,
			Description VARCHAR(255),
			Preference INT,
			RateCurrency int,
			ConnectionFeeCurrency int,
			MinimumDuration int,
			MaxMatchRank int ,
			INDEX Index1 (VendorConnectionID),
			INDEX Index2 (TimezonesID),
			INDEX Index3 (OriginationCode,RowCodeRateID)
		);

		

		DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_;
		CREATE TEMPORARY TABLE tmp_VendorRate_ (
			VendorConnectionID INT ,
			TimezonesID int,
			AccountID INT,
			VendorConnectionName VARCHAR(100) ,
			OriginationCode varchar(50),
			OriginationDescription varchar(200),
			Code VARCHAR(50) COLLATE utf8_unicode_ci,
			Rate DECIMAL(18, 8) ,
			RateN DECIMAL(18, 8) ,
			ConnectionFee DECIMAL(18, 8) ,
			EffectiveDate DATETIME ,
			Description VARCHAR(255),
			Preference INT,
			RateCurrency int,
			ConnectionFeeCurrency int,
			MinimumDuration int,
			RowCode VARCHAR(50) COLLATE utf8_unicode_ci,
			INDEX Index1 (TimezonesID),
			INDEX Index2 (OriginationCode,RowCode,AccountID)


		);
		DROP TEMPORARY TABLE IF EXISTS tmp_final_VendorRate_;
		CREATE TEMPORARY TABLE tmp_final_VendorRate_ (
			VendorConnectionID INT ,
			TimezonesID int,
			AccountID INT,
			VendorConnectionName VARCHAR(100) ,
			OriginationCode varchar(50),
			OriginationDescription varchar(200),
			Code VARCHAR(50) COLLATE utf8_unicode_ci,
			Rate DECIMAL(18, 8) ,
			RateN DECIMAL(18, 8) ,
			ConnectionFee DECIMAL(18, 8) ,
			EffectiveDate DATETIME ,
			Description VARCHAR(255),
			Preference INT,
			RateCurrency int,
			ConnectionFeeCurrency int,
			MinimumDuration int,
			FinalRankNumber int,
			RowCode VARCHAR(50) COLLATE utf8_unicode_ci,
			INDEX IX_CODE (TimezonesID,Code,OriginationCode)

		);

		
		DROP TEMPORARY TABLE IF EXISTS tmp_VendorCurrentRates_GroupBy_;
		CREATE TEMPORARY TABLE IF NOT EXISTS tmp_VendorCurrentRates_GroupBy_(
			VendorConnectionID int,
			TimezonesID int,
			AccountID INT,
			VendorConnectionName varchar(200),
			OriginationCode varchar(50),
			OriginationDescription varchar(200),
			Code LONGTEXT,
			Description varchar(200) ,
			Rate DECIMAL(18, 8) ,
			RateN DECIMAL(18, 8) ,
			ConnectionFee DECIMAL(18, 8) ,
			EffectiveDate date,
			TrunkID int,
			-- TimezonesID int,
			CountryID int,
			RateID int,
			Preference int,
			RateCurrency int,
			ConnectionFeeCurrency int,
			MinimumDuration int
			
		);

		DROP TEMPORARY TABLE IF EXISTS tmp_VendorCurrentRates_;
		CREATE TEMPORARY TABLE IF NOT EXISTS tmp_VendorCurrentRates_(
			VendorConnectionID int,
			TimezonesID int,
			AccountID INT,
			VendorConnectionName varchar(200),
			OriginationCode varchar(50),
			OriginationDescription varchar(200),
			Code varchar(50) COLLATE utf8_unicode_ci,
			Description varchar(200) ,
			Rate DECIMAL(18, 8) ,
			RateN DECIMAL(18, 8) ,
			ConnectionFee DECIMAL(18, 8) ,
			EffectiveDate date,
			TrunkID int,
			-- TimezonesID int,
			CountryID int,
			RateID int,
			Preference int,
			RateCurrency int,
			ConnectionFeeCurrency int,
			MinimumDuration int,
			INDEX IX_Code (RateID)
		);

		DROP TEMPORARY TABLE IF EXISTS tmp_VendorCurrentRates1_;
		CREATE TEMPORARY TABLE IF NOT EXISTS tmp_VendorCurrentRates1_(
			VendorConnectionID int,
			TimezonesID int,
			AccountID INT,
			VendorConnectionName varchar(200),
			OriginationRateID int,
			OriginationCode varchar(50),
			OriginationDescription varchar(200),
			Code varchar(50),
			Description varchar(200),
			Rate DECIMAL(18, 8) ,
			RateN DECIMAL(18, 8) ,
			ConnectionFee DECIMAL(18, 8) ,
			EffectiveDate date,
			TrunkID int,
			-- TimezonesID int,
			CountryID int,
			RateID int,
			Preference int,
			RateCurrency int,
			ConnectionFeeCurrency int,
			MinimumDuration int,
			INDEX tmp_OriginationRateID (OriginationRateID),
			INDEX tmp_VendorCurrentRates_VendorConnectionID (VendorConnectionID,TimezonesID,OriginationCode,Code,EffectiveDate)
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
			AccountID int,
			Rate DECIMAL(18,6)  ,
			RateN DECIMAL(18,6) ,
			ConnectionFee DECIMAL(18,6)  ,
			EffectiveDate DATE ,
			-- EndDate DATE   ,
			Interval1 INT(11)  ,
			IntervalN INT(11)  ,
			MinimumDuration INT(11),
			Preference INT(11)   ,
			-- Blocked TINYINT(4) ,
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

			/*INSERT INTO tmp_Codedecks_
			SELECT DISTINCT
				tblRateTable.CodeDeckId
			FROM tblRateRule
				INNER JOIN tblRateRuleSource
					ON tblRateRule.RateRuleId = tblRateRuleSource.RateRuleId
				INNER JOIN tblAccount
					ON tblAccount.AccountID = tblRateRuleSource.AccountID and tblAccount.IsVendor = 1
				JOIN tblVendorConnection
					ON tblAccount.AccountID = tblVendorConnection.AccountID
						 AND  tblVendorConnection.TrunkID = @v_trunk_
						 AND tblVendorConnection.Active = 1
						 AND tblVendorConnection.RateTypeID = 1  
				inner join tblRateTable on  tblRateTable.RateTableId = tblVendorConnection.RateTableID
			WHERE tblRateRule.RateGeneratorId = @p_RateGeneratorId;
*/



		-- @Assume : there will be only one termination codedeck amongs all vendors
		-- if ( select count(RateID) from tmp_search_code_  ) = 0 THEN

			-- insert into tmp_Raterules_codes 
			-- select distinct Code,DestinationType,DestinationCountryID from	tmp_Raterules_	;
			-- call prc_InsertIntoRateSearchCode(@v_CompanyId_,@v_codedeckid_,'');

			insert into tmp_search_code_ ( RowCodeRateID,CodeRateID,CountryID,RowCode, Code )
			SELECT DISTINCT rsc.RowCodeRateID,rsc.CodeRateID,rsc.CountryID,rsc.RowCode, rsc.Code
			from tblRateSearchCode rsc
			INNER JOIN tblRate r on r.CodeDeckID = rsc.CodeDeckID AND r.CompanyID = rsc.CompanyID and r.RateID = rsc.RowCodeRateID 
		 	INNER JOIN tmp_Raterules_ rr
				ON   ( fn_IsEmpty(rr.code)  OR rr.code = '*' OR (r.Code LIKE (REPLACE(rr.code,'*', '%%')) ))
						AND
				( fn_IsEmpty(rr.DestinationType)  OR ( r.`Type` = rr.DestinationType ))
						AND
				( fn_IsEmpty(rr.DestinationCountryID) OR (r.`CountryID` = rr.DestinationCountryID ))
			where r.CodeDeckId = @v_codedeckid_			
			order by rsc.RowCode , rsc.Code   desc;

			-- update CodeRateID
			/*UPDATE tmp_search_code_ rsc
			INNER JOIN tblRate r on r.CodeDeckID = @v_codedeckid_ AND r.Code = rsc.Code 
			set CodeRateID = r.RateID
			where r.CodeDeckId = @v_codedeckid_	;
			*/	 

			
		-- END IF;

		/*-- OLD QUERY -------------------------------
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
		*/

		/*insert into tmp_code_origination (RateID)
			SELECT tblRate.RateID
				FROM tblRate
				JOIN tmp_Raterules_ rr
					ON ( fn_IsEmpty(rr.OriginationCode) OR  (tblRate.Code LIKE (REPLACE(rr.OriginationCode,'*', '%%'))) )
							AND
						( fn_IsEmpty(rr.OriginationType) OR ( tblRate.`Type` = rr.OriginationType ))
								AND
						( fn_IsEmpty(rr.OriginationCountryID) OR (tblRate.`CountryID` = rr.OriginationCountryID ))
			 where  tblRate.CodeDeckId = @v_codedeckid_
			Order by tblRate.code ;
			*/





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
			RateTableRateID, 
			VendorConnectionID,	
			OriginationRateID,
			RateID,
			RateTableId,
			TimezonesID,
			AccountID,
			Rate,
			RateN,
			ConnectionFee,
			EffectiveDate,
			Interval1,
			IntervalN,
			Preference,
			RateCurrency,
			ConnectionFeeCurrency,
			MinimumDuration )
			select RateTableRateID,VendorConnectionID, OriginationRateID,RateID,rtr.RateTableId,rtr.TimezonesID,a.AccountID,
				
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
				DATE(EffectiveDate) as EffectiveDate, 
				Interval1,
				IntervalN,
				IFNULL(Preference, 5) AS Preference,
				@v_CurrencyID_ as RateCurrency,
				@v_CurrencyID_ as ConnectionFeeCurrency,
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
 


				INSERT INTO tmp_VendorCurrentRates1_ ( 
					VendorConnectionID,TimezonesID,AccountID,OriginationRateID, OriginationCode,OriginationDescription,Code,Description,
					Rate,RateN,ConnectionFee,EffectiveDate,CountryID,RateID,Preference,RateCurrency,ConnectionFeeCurrency,MinimumDuration )
				Select DISTINCT 
					VendorConnectionID,
					TimezonesID,
					AccountID,
					OriginationRateID,
					'' as OriginationCode, -- IFNULL(r2.Code,"") as OriginationCode,
					'' as OriginationDescription , -- IFNULL(r2.Description,"") as OriginationDescription ,
					tblRate.Code,
					'' as Description,
 					Rate,
					RateN,
					IFNULL(ConnectionFee,0),
					EffectiveDate,
					tblRate.CountryID,
					tblRate.CodeRateID,
					Preference,
					RateCurrency,
					ConnectionFeeCurrency,
					MinimumDuration

					FROM tmp_tblRateTableRate rtr
					INNER JOIN tmp_search_code_ tblRate ON rtr.RateId = tblRate.CodeRateID;


				/*
				TESTING
				INSERT INTO tmp_tblRateTableRate (VendorConnectionID,TimezonesID,AccountID,OriginationRateID, OriginationCode,OriginationDescription,Code,Description,
					Rate,RateN,ConnectionFee,EffectiveDate,CountryID,RateID,Preference,RateCurrency,ConnectionFeeCurrency,MinimumDuration) 
					values 
				(27  , 1 , 77 , NULL , NULL , NULL , '91','India',0.1,0.1,0,'2019-08-14',100,1273880,5,9,9,1),
				(27  , 3 , 77 , NULL , NULL , NULL , '91','India',0.1,0.1,0,'2019-08-14',100,1273880,5,9,9,1),
				(27  , 7 , 77 , NULL , NULL , NULL , '91','India',0.1,0.1,0,'2019-08-14',100,1273880,5,9,9,1),
				(27  , 9 , 77 , NULL , NULL , NULL , '91','India',0.1,0.1,0,'2019-08-14',100,1273880,5,9,9,1),
				
				(26  , 1 , 12 , NULL , NULL , NULL , '91','India',0.1,0.1,0,'2019-08-14',100,1273880,5,9,9,1),
				(26  , 3 , 12 , NULL , NULL , NULL , '91','India',0.1,0.1,0,'2019-08-14',100,1273880,5,9,9,1),
				(26  , 7 , 12 , NULL , NULL , NULL , '91','India',0.1,0.1,0,'2019-08-14',100,1273880,5,9,9,1),
				(26  , 9 , 12 , NULL , NULL , NULL , '91','India',0.1,0.1,0,'2019-08-14',100,1273880,5,9,9,1);	
				*/

								
				-- select count(*) from tmp_VendorCurrentRates1_ WHERE OriginationRateID is not null;
				-- 29,05,305
				-- Query OK, 20,43,140 rows affected (40 min 48.15 sec)
				-- Rows matched: 20,43,140  Changed: 2043140  Warnings: 0

				update tmp_VendorCurrentRates1_ rtr
				INNER JOIN tmp_search_code_ r2  FORCE INDEX (Index2) ON rtr.OriginationRateID = r2.CodeRateID
				SET OriginationCode  = r2.Code 
				WHERE rtr.OriginationRateID > 0;

				-- OriginationDescription = r2.Description;

				-- Query OK, 2905305 rows affected (2 min 1.22 sec)
				-- take first record (current or future ) from now  
				INSERT INTO tmp_VendorCurrentRates_ 				
				(				VendorConnectionID,AccountID,VendorConnectionName,OriginationCode,OriginationDescription,Code,Description, Rate, RateN,ConnectionFee,EffectiveDate,TrunkID,TimezonesID,CountryID,RateID,Preference,RateCurrency,ConnectionFeeCurrency,MinimumDuration	 )
				Select VendorConnectionID,AccountID,VendorConnectionName,OriginationCode,OriginationDescription,Code,Description, Rate, RateN,ConnectionFee,EffectiveDate,TrunkID,TimezonesID,CountryID,RateID,Preference,RateCurrency,ConnectionFeeCurrency,MinimumDuration
				FROM (
						SELECT * ,
							@row_num := IF(@prev_VendorConnectionID = VendorConnectionID AND @prev_TimezonesID = TimezonesID AND @prev_OriginationCode = OriginationCode AND @prev_Code = Code AND @prev_EffectiveDate >= EffectiveDate, @row_num + 1, 1) AS RowID,
							@prev_VendorConnectionID := VendorConnectionID,
							-- @prev_TrunkID := TrunkID,
							@prev_TimezonesID := TimezonesID,
							@prev_OriginationCode := OriginationCode,
							@prev_Code := Code,
							@prev_EffectiveDate := EffectiveDate
						FROM tmp_VendorCurrentRates1_
							,(SELECT @row_num := 1,  @prev_VendorConnectionID := 0 ,@prev_TimezonesID := 0, @prev_OriginationCode := 0,@prev_Code := 0, @prev_EffectiveDate := '') x
						ORDER BY VendorConnectionID, TimezonesID, OriginationCode, Code, EffectiveDate DESC
					) tbl
				WHERE RowID = 1;
				-- order by VendorConnectionID, TimezonesID, OriginationCode, Code asc;


		/*IF @p_GroupBy = 'Desc' 
		THEN
			
			INSERT INTO tmp_VendorCurrentRates_GroupBy_
			Select VendorConnectionID,max(AccountID),max(VendorConnectionName),max(OriginationCode),OriginationDescription,max(Code),Description,max(Rate),max(RateN),max(ConnectionFee),max(EffectiveDate),TrunkID,TimezonesID,max(CountryID),max(RateID),max(Preference),max(RateCurrency) as RateCurrency ,max(ConnectionFeeCurrency) as  ConnectionFeeCurrency, max(MinimumDuration) as MinimumDuration
			FROM tmp_VendorCurrentRates_ 
			GROUP BY VendorConnectionID, TrunkID, TimezonesID, Description,OriginationDescription
			order by Description asc;

			truncate table tmp_VendorCurrentRates_;

			INSERT INTO tmp_VendorCurrentRates_ (VendorConnectionID,AccountID,VendorConnectionName,OriginationCode,OriginationDescription,Code,Description, Rate, RateN,ConnectionFee,EffectiveDate,TrunkID,TimezonesID,CountryID,RateID,Preference,RateCurrency,ConnectionFeeCurrency,MinimumDuration)
			SELECT VendorConnectionID,AccountID,VendorConnectionName,OriginationCode,OriginationDescription,Code,Description, Rate, RateN,ConnectionFee,EffectiveDate,TrunkID,TimezonesID,CountryID,RateID,Preference,RateCurrency,ConnectionFeeCurrency,MinimumDuration
			FROM tmp_VendorCurrentRates_GroupBy_;


		END IF; */
		

		/*insert into tmp_all_code_ (RowCode,Code,RowNo)
			select RowCode , loopCode,RowNo
			from (
						 select   RowCode , loopCode,
							 @RowNo := ( CASE WHEN (@prev_Code  = tbl1.RowCode  ) THEN @RowNo + 1
													 ELSE 1
													 END

							 )      as RowNo,
							 @prev_Code := tbl1.RowCode

						 from (
										SELECT distinct f.Code as RowCode, LEFT(f.Code, x.RowNo) as loopCode
										FROM (
													 SELECT @RowNo  := @RowNo + 1 as RowNo
													 FROM mysql.help_category
														 ,(SELECT @RowNo := 0 ) x
													 limit 15
												 ) x
												INNER JOIN tmp_code_ AS f ON  x.RowNo   <= LENGTH(f.Code)
												INNER JOIN tblRate as tr1 on tr1.CodeDeckId = @v_codedeckid_ AND LEFT(f.Code, x.RowNo) = tr1.Code

										order by RowCode desc,  LENGTH(loopCode) DESC
								) tbl1
								
							 , ( Select @RowNo := 0 ) x
					 ) tbl order by RowCode desc,  LENGTH(loopCode) DESC ;
		*/	
 




		

		-- insert into  tmp_VendorRate_stage_1 select * from tmp_VendorRate_stage_;
		-- Query OK, 1,96,91,171 rows affected (13 min 34.26 sec)
		-- Records: 19691171  Duplicates: 0  Warnings: 0

		insert into tmp_VendorRate_stage_1 (
			RowCode,
			RowCodeRateID,
			VendorConnectionID ,
			TimezonesID,
			AccountID,
			VendorConnectionName ,
			OriginationCode,
			OriginationDescription,
			RateID,
			Code ,
			Rate ,
			RateN ,
			ConnectionFee,
			EffectiveDate ,
			Description ,
			Preference,
			RateCurrency,
			ConnectionFeeCurrency,
			MinimumDuration
		)
			SELECT
				distinct
				RowCode,
				RowCodeRateID,
				v.VendorConnectionID ,
				v.TimezonesID,
				v.AccountID,
				v.VendorConnectionName ,
				v.OriginationCode,
				v.OriginationDescription,
				v.RateID,
				v.Code ,
				v.Rate ,
				v.RateN ,
				v.ConnectionFee,
				v.EffectiveDate ,
				v.Description ,
				v.Preference,
				v.RateCurrency,
				v.ConnectionFeeCurrency,
				v.MinimumDuration

			FROM tmp_VendorCurrentRates_ v
			Inner join  tmp_search_code_ SplitCode on v.RateID = SplitCode.CodeRateID;
			-- where  SplitCode.Code is not null
			-- order by VendorConnectionID,TimezonesID, SplitCode.RowCode desc ,LENGTH(SplitCode.RowCode), v.Code desc, LENGTH(v.Code)  desc;


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

				-- Query OK, 1,66,22,035 rows affected (5 min 51.04 sec)
				INSERT INTO tmp_VendorRate_stage_1_DEFAULT ( RowCode,RowCodeRateID,VendorConnectionID,TimezonesID,AccountID,VendorConnectionName,OriginationCode,OriginationDescription,RateID,Code,Rate,RateN,ConnectionFee,EffectiveDate,Description,Preference,RateCurrency,ConnectionFeeCurrency,MinimumDuration,MaxMatchRank )
				SELECT RowCode,RowCodeRateID,VendorConnectionID,TimezonesID,AccountID,VendorConnectionName,OriginationCode,OriginationDescription,RateID,Code,Rate,RateN,ConnectionFee,EffectiveDate,Description,Preference,RateCurrency,ConnectionFeeCurrency,MinimumDuration,MaxMatchRank 
				FROM tmp_VendorRate_stage_1 WHERE TimezonesID = @v_default_TimezonesID;


				-- Query OK, 16622035 rows affected (4 min 41.59 sec)
				DELETE  FROM tmp_VendorRate_stage_1 WHERE TimezonesID = @v_default_TimezonesID;


				--	Query OK, 30,69,136 rows affected (50.03 sec)
				INSERT INTO tmp_VendorRate_stage_1_dup (RowCode,RowCodeRateID,VendorConnectionID,TimezonesID,AccountID,VendorConnectionName,OriginationCode,OriginationDescription,RateID,Code,Rate,RateN,ConnectionFee,EffectiveDate,Description,Preference,RateCurrency,ConnectionFeeCurrency,MinimumDuration,MaxMatchRank)
				SELECT RowCode,RowCodeRateID,VendorConnectionID,TimezonesID,AccountID,VendorConnectionName,OriginationCode,OriginationDescription,RateID,Code,Rate,RateN,ConnectionFee,EffectiveDate,Description,Preference,RateCurrency,ConnectionFeeCurrency,MinimumDuration,MaxMatchRank 
				FROM tmp_VendorRate_stage_1;

				insert into tmp_timezones (TimezonesID) select distinct TimezonesID from tmp_VendorRate_stage_1 WHERE TimezonesID != @v_default_TimezonesID;
				-- select GROUP_CONCAT(TimezonesID) INTO @v_rest_TimezonesIDs from tblTimezones WHERE TimezonesID != @v_default_TimezonesID;


				-- Query OK, 0 rows affected (22.90 sec)
				delete vd 
				from tmp_VendorRate_stage_1_dup vd
				INNER JOIN  tmp_VendorRate_stage_1_DEFAULT v
				ON v.VendorConnectionID = vd.VendorConnectionID AND
				-- v.TimezonesID  = vd.TimezonesID AND
				vd.OriginationCode = v.OriginationCode AND
				vd.RowCodeRateID = v.RowCodeRateID;


				WHILE @v_pointer_ <= @v_rowCount_
				DO

					SET @v_v_TimezonesID = ( SELECT TimezonesID FROM tmp_timezones WHERE ID = @v_pointer_ );

					INSERT INTO tmp_VendorRate_stage_1 (
							RowCode,
							RowCodeRateID,
							VendorConnectionID,
							TimezonesID,
							AccountID,
							VendorConnectionName,
							OriginationCode,
							OriginationDescription,
							RateID,
							Code,
							Rate,
							RateN,
							ConnectionFee,
							EffectiveDate,
							Description,
							Preference,
							RateCurrency,
							ConnectionFeeCurrency,
							MinimumDuration,
							MaxMatchRank
					)
					SELECT 

						DISTINCT 
						vd.RowCode,
						vd.RowCodeRateID,
						vd.VendorConnectionID,
						@v_v_TimezonesID as TimezonesID , -- v.TimezonesID,
						vd.AccountID,
						vd.VendorConnectionName,
						vd.OriginationCode,
						vd.OriginationDescription,
						vd.RateID,
						vd.Code,
						vd.Rate,
						vd.RateN,
						vd.ConnectionFee,
						vd.EffectiveDate,
						vd.Description,
						vd.Preference,
						vd.RateCurrency,
						vd.ConnectionFeeCurrency,
						vd.MinimumDuration,
						vd.MaxMatchRank
						
					FROM tmp_VendorRate_stage_1_DEFAULT vd
					LEFT JOIN tmp_VendorRate_stage_1_dup v on 
										-- v.VendorConnectionID != vd.VendorConnectionID AND
										v.TimezonesID  = @v_v_TimezonesID AND
									-- FIND_IN_SET(v.TimezonesID, @v_rest_TimezonesIDs) != 0 AND
										vd.OriginationCode = v.OriginationCode AND
										vd.RowCodeRateID = v.RowCodeRateID;

					SET @v_pointer_ = @v_pointer_ + 1;

				END WHILE;
				
		END IF;

		-- looop to optimize query .
		truncate table tmp_timezones;
		INSERT INTO tmp_timezones (TimezonesID)	SELECT DISTINCT TimezonesID FROM tmp_VendorRate_stage_1;

		SET @v_t_rowCount_ = ( SELECT COUNT(*) FROM tmp_timezones );
		SET @v_t_pointer_ = 1;
		
		IF @v_t_rowCount_ > 0 THEN 

			WHILE @v_t_pointer_ <= @v_t_rowCount_
			DO

				SET @v_TimezonesID = ( SELECT TimezonesID FROM tmp_timezones WHERE ID = @v_t_pointer_ );

				-- IF ( (SELECT COUNT(TimezonesID) from tmp_VendorRate_stage_1 WHERE TimezonesID = @v_TimezonesID ) > 0 ) THEN
			
						-- remove multiple vendor per rowcode
						truncate table tmp_VendorRate_stage_;
						insert into tmp_VendorRate_stage_  
							SELECT
								RowCode,
								VendorConnectionID ,
								TimezonesID,
								AccountID,
								VendorConnectionName ,
								OriginationCode,
								OriginationDescription,
								Code ,
								Rate ,
								RateN ,
								ConnectionFee,
								EffectiveDate ,
								Description ,
								Preference,
								RateCurrency,
								ConnectionFeeCurrency,
								MinimumDuration,
								@rank := ( CASE WHEN( @prev_RowCodeRateID = RowCodeRateID  AND @prev_TimezonesID = TimezonesID  AND @prev_VendorConnectionID = VendorConnectionID     )
									THEN @rank + 1
									ELSE 1  END ) AS MaxMatchRank,
								@prev_OriginationCode := ifnull(OriginationCode,''),
								@prev_RowCodeRateID := RowCodeRateID	 as prev_Code,
								@prev_VendorConnectionID := VendorConnectionID as prev_VendorConnectionID,
								@prev_TimezonesID := TimezonesID	 as prev_TimezonesID
							FROM tmp_VendorRate_stage_1 
								, (SELECT  @prev_OriginationCode := NUll , @prev_RowCode := '',  @rank := 0 , @prev_Code := '' , @prev_VendorConnectionID := Null) f
							WHERE TimezonesID = @v_TimezonesID 
							-- order by VendorConnectionID,OriginationCode,RowCode desc ;
							order by  RowCode,TimezonesID,VendorConnectionID , OriginationCode,Code   desc ;


							insert into tmp_VendorRate_
								select
									DISTINCT

									VendorConnectionID ,
									TimezonesID,
									AccountID,
									VendorConnectionName ,
									IFNULL(OriginationCode,''),
									OriginationDescription,
									Code ,
									Rate ,
									RateN ,
									ConnectionFee,
									EffectiveDate ,
									Description ,
									Preference,
									RateCurrency,
									ConnectionFeeCurrency,
									MinimumDuration,
									RowCode
								from tmp_VendorRate_stage_
								where MaxMatchRank = 1; -- order by TimezonesID,RowCode,Code desc;

								 

				-- END IF;

				SET @v_t_pointer_ = @v_t_pointer_ + 1;

			END WHILE;
				
		END IF;



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
						INSERT INTO tmp_Rates2_ (OriginationCode,OriginationDescription,code,description,rate,rateN,ConnectionFee,VendorConnectionID,TimezonesID,AccountID,RateCurrency,ConnectionFeeCurrency,MinimumDuration)
						select  OriginationCode,OriginationDescription,code,description,rate,rateN,ConnectionFee,VendorConnectionID,TimezonesID,AccountID,RateCurrency,ConnectionFeeCurrency,MinimumDuration 
						from tmp_Rates_ where TimezonesID = @v_TimezonesID_;


						/*IF @p_GroupBy = 'Desc' 
						THEN

								
								INSERT IGNORE INTO tmp_Rates3_ (OriginationCode,OriginationDescription,code,description)
								select distinct tmpvr.OriginationCode,tmpvr.OriginationDescription,r.code,r.description
								from tmp_VendorCurrentRates1_  tmpvr
								Inner join  tblRate r   on r.CodeDeckId = @v_codedeckid_ AND r.Code = tmpvr.Code
								left join  tblRate r2   on r2.CodeDeckId = @v_codedeckid_ AND r2.Code = tmpvr.OriginationCode
								inner JOIN tmp_Raterules_ rr ON rr.RateRuleId = @v_rateRuleId_ and
									(
										( fn_IsEmpty(rr.OriginationCode)  OR ( tmpvr.OriginationCode  LIKE (REPLACE(rr.OriginationCode,'*', '%%')) ) )
											AND
										( fn_IsEmpty(rr.OriginationType) OR ( r2.`Type` = rr.OriginationType ))
											AND
										( fn_IsEmpty(rr.OriginationCountryID) OR (r2.`CountryID` = rr.OriginationCountryID ))
											
									)
									AND																											
									(
											( fn_IsEmpty(rr.code) OR ( tmpvr.RowCode LIKE (REPLACE(rr.code,'*', '%%')) ))
											
											AND
											( fn_IsEmpty(rr.DestinationType) OR ( r.`Type` = rr.DestinationType ))
											AND
											( fn_IsEmpty(rr.DestinationCountryID) OR (r.`CountryID` = rr.DestinationCountryID ))
											
									)
									left JOIN tmp_Raterules_dup rr2 ON rr2.Order > rr.Order and
									(
											( fn_IsEmpty(rr2.OriginationCode)  OR ( tmpvr.OriginationCode  LIKE (REPLACE(rr2.OriginationCode,'*', '%%'))))
											AND
											( fn_IsEmpty(rr2.OriginationType) OR ( r2.`Type` = rr2.OriginationType ))
											AND
											( fn_IsEmpty(rr2.OriginationCountryID) OR (r2.`CountryID` = rr2.OriginationCountryID ))
									)
									AND																											
									(
										( fn_IsEmpty(rr2.code) OR ( tmpvr.RowCode  LIKE (REPLACE(rr2.code,'*', '%%')) ))
											
										AND
										( fn_IsEmpty(rr2.DestinationType) OR ( r.`Type` = rr2.DestinationType ))
										AND
										( fn_IsEmpty(rr2.DestinationCountryID) OR (r.`CountryID` = rr2.DestinationCountryID ))
									)
								inner JOIN tblRateRuleSource rrs ON  rrs.RateRuleId = rr.rateruleid  and rrs.AccountID = tmpvr.AccountID
								where rr2.RateRuleId is null;

						END IF;*/



					truncate tmp_final_VendorRate_;

					IF( @v_Use_Preference_ = 0 )
					THEN

						insert into tmp_final_VendorRate_
							SELECT
								DISTINCT 
								VendorConnectionID ,
								TimezonesID,
								AccountID,
								VendorConnectionName ,
								OriginationCode ,
								OriginationDescription ,
								Code ,
								Rate ,
								RateN ,
								ConnectionFee,
								EffectiveDate ,
								Description ,
								Preference,
								RateCurrency,
								ConnectionFeeCurrency,
								MinimumDuration,
								FinalRankNumber,
								RowCode			
								
							from
								(
									SELECT
										vr.VendorConnectionID ,
										vr.TimezonesID,
										vr.AccountID,
										vr.VendorConnectionName ,
										vr.OriginationCode ,
										vr.OriginationDescription ,
										vr.Code ,
										vr.Rate ,
										vr.RateN ,
										vr.ConnectionFee,
										vr.EffectiveDate ,
										vr.Description ,
										vr.Preference,
										vr.RowCode,
										vr.RateCurrency,
										vr.ConnectionFeeCurrency,
										vr.MinimumDuration,
										@rank := CASE WHEN ( @prev_TimezonesID = vr.TimezonesID  AND  @prev_OriginationCode = vr.OriginationCode  AND  @prev_RowCode = vr.RowCode  AND @prev_Rate <  vr.Rate  AND (@v_percentageRate = 0 OR  (@v_percentageRate > 0 AND fn_Round((((vr.Rate - @prev_Rate) / @prev_Rate) * 100),2) > @v_percentageRate) ) ) THEN @rank+1
															WHEN ( @prev_TimezonesID = vr.TimezonesID  AND @prev_OriginationCode = vr.OriginationCode  AND  @prev_RowCode = vr.RowCode  AND @prev_Rate <  vr.Rate  AND (@v_percentageRate = 0 OR  (@v_percentageRate > 0 AND fn_Round((((vr.Rate - @prev_Rate) / @prev_Rate) * 100),2) <= @v_percentageRate) ) ) THEN -1 -- remove
															
															WHEN ( @prev_TimezonesID = vr.TimezonesID  AND @prev_OriginationCode = vr.OriginationCode  AND  @prev_RowCode = vr.RowCode  AND @prev_Rate =  vr.Rate  AND (@v_percentageRate = 0 OR  (@v_percentageRate > 0 AND fn_Round((((vr.Rate - @prev_Rate) / @prev_Rate) * 100),2) > @v_percentageRate) ) ) THEN @rank+1
															WHEN ( @prev_TimezonesID = vr.TimezonesID  AND @prev_OriginationCode = vr.OriginationCode  AND  @prev_RowCode = vr.RowCode  AND @prev_Rate =  vr.Rate  AND (@v_percentageRate = 0 OR  (@v_percentageRate > 0 AND fn_Round((((vr.Rate - @prev_Rate) / @prev_Rate) * 100),2) <= @v_percentageRate) ) ) THEN -1
															ELSE
																1
															END
										AS FinalRankNumber,
										@prev_OriginationCode  := vr.OriginationCode,
										@prev_RowCode  := vr.RowCode,
										@prev_Description  := vr.Description,
										-- @prev_OriginationDescription  := vr.OriginationDescription,
										@prev_TimezonesID  := vr.TimezonesID,
										@prev_Rate  := vr.Rate
									from (
												select distinct tmpvr.*
												from tmp_VendorRate_  tmpvr
												Inner join  tblRate r   on tmpvr.TimezonesID = @v_TimezonesID_ AND r.CodeDeckId = @v_codedeckid_ AND r.Code = tmpvr.Code
												left join  tblRate r2   on r2.CodeDeckId = @v_codedeckid_ AND r2.Code = tmpvr.OriginationCode
												inner JOIN tmp_Raterules_ rr ON rr.RateRuleId = @v_rateRuleId_
												AND (
													( fn_IsEmpty(rr.OriginationCode)  OR  (rr.OriginationCode = '*') OR ( tmpvr.OriginationCode != '' AND tmpvr.OriginationCode  LIKE (REPLACE(rr.OriginationCode,'*', '%%')) ) )
														AND
													( fn_IsEmpty(rr.OriginationType) OR ( r2.`Type` = rr.OriginationType ))
														AND
													( fn_IsEmpty(rr.OriginationCountryID) OR (r2.`CountryID` = rr.OriginationCountryID ))
														
												)
												AND																											
												(
														( fn_IsEmpty(rr.code) OR (rr.code = '*') OR ( tmpvr.RowCode LIKE (REPLACE(rr.code,'*', '%%')) ))
														
														AND
														( fn_IsEmpty(rr.DestinationType) OR ( r.`Type` = rr.DestinationType ))
														AND
														( fn_IsEmpty(rr.DestinationCountryID) OR (r.`CountryID` = rr.DestinationCountryID ))
														
												)
												left JOIN tmp_Raterules_dup rr2 ON rr2.Order > rr.Order and
												(
														( fn_IsEmpty(rr2.OriginationCode)  OR (rr2.OriginationCode = '*') OR  ( tmpvr.OriginationCode != '' AND tmpvr.OriginationCode  LIKE (REPLACE(rr2.OriginationCode,'*', '%%'))))
														AND
														( fn_IsEmpty(rr2.OriginationType) OR ( r2.`Type` = rr2.OriginationType ))
														AND
														( fn_IsEmpty(rr2.OriginationCountryID) OR (r2.`CountryID` = rr2.OriginationCountryID ))
												)
												AND																											
												(
													( fn_IsEmpty(rr2.code) OR  (rr2.code = '*') OR ( tmpvr.RowCode  LIKE (REPLACE(rr2.code,'*', '%%')) ))
														
													AND
													( fn_IsEmpty(rr2.DestinationType) OR ( r.`Type` = rr2.DestinationType ))
													AND
													( fn_IsEmpty(rr2.DestinationCountryID) OR (r.`CountryID` = rr2.DestinationCountryID ))
												)
												inner JOIN tblRateRuleSource rrs ON  rrs.RateRuleId = rr.rateruleid  and rrs.AccountID = tmpvr.AccountID
												
												WHERE tmpvr.TimezonesID = @v_TimezonesID_ AND rr2.RateRuleId is null

											) vr
										,(SELECT @rank := 0 ,@prev_TimezonesID  := '', @prev_OriginationCode := ''  , @prev_RowCode := '' , @prev_OriginationDescription := ''  , @prev_Description := '' ,  @prev_Rate := 0  ) x
									order by
										/*CASE WHEN @p_GroupBy = 'Desc'  THEN
											vr.OriginationDescription
										ELSE
											vr.OriginationCode
										END ,
										CASE WHEN @p_GroupBy = 'Desc'  THEN
											vr.Description
										ELSE
											vr.RowCode
										END , */
										vr.OriginationCode,vr.RowCode, vr.Rate,vr.VendorConnectionID,vr.TimezonesID

								) tbl1
							where FinalRankNumber <= @v_RatePosition_ AND FinalRankNumber != -1;

					ELSE


						insert into tmp_final_VendorRate_
							SELECT
								DISTINCT 
								VendorConnectionID ,
								TimezonesID,
								AccountID,
								VendorConnectionName ,
								OriginationCode ,
								OriginationDescription ,
								Code ,
								Rate ,
								RateN ,
								ConnectionFee,
								EffectiveDate ,
								Description ,
								Preference,
								RateCurrency,
								ConnectionFeeCurrency,
								MinimumDuration,
								FinalRankNumber,
								RowCode


							from
								(
									SELECT
										vr.VendorConnectionID ,
										vr.TimezonesID,
										vr.AccountID,
										vr.VendorConnectionName ,
										vr.OriginationCode ,
										vr.OriginationDescription ,
										vr.Code ,
										vr.Rate ,
										vr.RateN ,
										vr.ConnectionFee,
										vr.EffectiveDate ,
										vr.Description ,
										vr.Preference,
										vr.RowCode,
										vr.RateCurrency,
										vr.ConnectionFeeCurrency,
										vr.MinimumDuration,
										/*CASE WHEN @p_GroupBy = 'Desc'  THEN

											@preference_rank := CASE WHEN (@prev_OriginationDescription    = vr.OriginationDescription AND @prev_Description  = vr.Description  AND @prev_Preference > vr.Preference  )   THEN @preference_rank + 1
																	WHEN (@prev_OriginationDescription    = vr.OriginationDescription AND @prev_Description  = vr.Description  AND @prev_Preference = vr.Preference AND @prev_Rate <= vr.Rate  AND  (@v_percentageRate = 0 OR  (@v_percentageRate > 0 AND fn_Round((((vr.Rate - @prev_Rate) / @prev_Rate) * 100),2) > @v_percentageRate) )  ) THEN @preference_rank + 1
																	WHEN (@prev_OriginationDescription    = vr.OriginationDescription AND @prev_Description  = vr.Description  AND @prev_Preference = vr.Preference AND @prev_Rate <= vr.Rate  AND  (@v_percentageRate = 0 OR  (@v_percentageRate > 0 AND fn_Round((((vr.Rate - @prev_Rate) / @prev_Rate) * 100),2) <= @v_percentageRate) )  ) THEN -1 -- remove
																	ELSE 1 END
										ELSE */
											@preference_rank := CASE WHEN (@prev_TimezonesID = vr.TimezonesID  AND @prev_OriginationCode    = vr.OriginationCode AND @prev_Code  = vr.RowCode  AND @prev_Preference > vr.Preference  )   THEN @preference_rank + 1
																	WHEN (@prev_TimezonesID = vr.TimezonesID  AND @prev_OriginationCode    = vr.OriginationCode AND @prev_Code  = vr.RowCode  AND @prev_Preference = vr.Preference AND @prev_Rate <= vr.Rate   AND  (@v_percentageRate = 0 OR  (@v_percentageRate > 0 AND fn_Round((((vr.Rate - @prev_Rate) / @prev_Rate) * 100),2) > @v_percentageRate) ) ) THEN @preference_rank + 1
																	WHEN (@prev_TimezonesID = vr.TimezonesID  AND @prev_OriginationCode    = vr.OriginationCode AND @prev_Code  = vr.RowCode  AND @prev_Preference = vr.Preference AND @prev_Rate <= vr.Rate   AND  (@v_percentageRate = 0 OR  (@v_percentageRate > 0 AND fn_Round((((vr.Rate - @prev_Rate) / @prev_Rate) * 100),2) <= @v_percentageRate) ) ) THEN -1 -- remove
																	ELSE 1 END
										-- END

										AS FinalRankNumber,
										@prev_TimezonesID  := vr.TimezonesID,
										@prev_Code := vr.RowCode,
										@prev_OriginationCode := vr.OriginationCode,
										@prev_Description  := vr.Description,
										-- @prev_OriginationDescription  := vr.OriginationDescription,
										@prev_Preference := vr.Preference,
										@prev_Rate := vr.Rate
									from (
												select distinct tmpvr.*
												from tmp_VendorRate_  tmpvr
												Inner join  tblRate r   on tmpvr.TimezonesID = @v_TimezonesID_ AND r.CodeDeckId = @v_codedeckid_ AND r.Code = tmpvr.Code
												left join  tblRate r2   on r2.CodeDeckId = @v_codedeckid_ AND r2.Code = tmpvr.OriginationCode
												inner JOIN tmp_Raterules_ rr ON rr.RateRuleId = @v_rateRuleId_ 
												AND (
													( fn_IsEmpty(rr.OriginationCode)  OR  (rr.OriginationCode = '*') OR ( tmpvr.OriginationCode != '' AND tmpvr.OriginationCode  LIKE (REPLACE(rr.OriginationCode,'*', '%%')) ) )
														AND
													( fn_IsEmpty(rr.OriginationType) OR ( r2.`Type` = rr.OriginationType ))
														AND
													( fn_IsEmpty(rr.OriginationCountryID) OR (r2.`CountryID` = rr.OriginationCountryID ))
														
												)
												AND																											
												(
														( fn_IsEmpty(rr.code) OR (rr.code = '*') OR ( tmpvr.RowCode LIKE (REPLACE(rr.code,'*', '%%')) ))
														
														AND
														( fn_IsEmpty(rr.DestinationType) OR ( r.`Type` = rr.DestinationType ))
														AND
														( fn_IsEmpty(rr.DestinationCountryID) OR (r.`CountryID` = rr.DestinationCountryID ))
														
												)
												left JOIN tmp_Raterules_dup rr2 ON rr2.Order > rr.Order and
												(
														( fn_IsEmpty(rr2.OriginationCode)  OR (rr2.OriginationCode = '*') OR  ( tmpvr.OriginationCode != '' AND tmpvr.OriginationCode  LIKE (REPLACE(rr2.OriginationCode,'*', '%%'))))
														AND
														( fn_IsEmpty(rr2.OriginationType) OR ( r2.`Type` = rr2.OriginationType ))
														AND
														( fn_IsEmpty(rr2.OriginationCountryID) OR (r2.`CountryID` = rr2.OriginationCountryID ))
												)
												AND																											
												(
													( fn_IsEmpty(rr2.code) OR  (rr2.code = '*') OR ( tmpvr.RowCode  LIKE (REPLACE(rr2.code,'*', '%%')) ))
														
													AND
													( fn_IsEmpty(rr2.DestinationType) OR ( r.`Type` = rr2.DestinationType ))
													AND
													( fn_IsEmpty(rr2.DestinationCountryID) OR (r.`CountryID` = rr2.DestinationCountryID ))
												)
													inner JOIN tblRateRuleSource rrs ON  rrs.RateRuleId = rr.rateruleid  and rrs.AccountID = tmpvr.AccountID
												where tmpvr.TimezonesID = @v_TimezonesID_ AND rr2.RateRuleId is null

											) vr

											,(SELECT @preference_rank := 0 , @prev_TimezonesID  := '' , @prev_OriginationCode := ''  ,  @prev_Code := ''  , @prev_OriginationDescription := '', @prev_Description := '', @prev_Preference := 5,  @prev_Rate := 0 ) x

									order by 
									/*CASE WHEN @p_GroupBy = 'Desc'  THEN
											vr.OriginationDescription
										ELSE
											vr.OriginationCode
										END ,
									CASE WHEN @p_GroupBy = 'Desc'  THEN
											vr.Description
										ELSE
											vr.RowCode
										END , */
										vr.OriginationCode, vr.RowCode, vr.Preference DESC ,vr.Rate ASC ,vr.VendorConnectionID,vr.TimezonesID ASC
								) tbl1
							where FinalRankNumber <= @v_RatePosition_ AND FinalRankNumber != -1;


					END IF;

					

					truncate  table  tmp_VRatesstage2_;

					INSERT INTO tmp_VRatesstage2_
						SELECT
							DISTINCT 
							vr.RowCode,
							vr.OriginationCode ,
							vr.OriginationDescription ,
							vr.code,
							vr.description,
							vr.rate,
							vr.rateN,
							vr.ConnectionFee,
							vr.FinalRankNumber,
							vr.VendorConnectionID,
							vr.TimezonesID,
							vr.AccountID,
							vr.RateCurrency,
							vr.ConnectionFeeCurrency,
							vr.MinimumDuration
						FROM tmp_final_VendorRate_ vr
						left join tmp_Rates2_ rate on rate.TimezonesID = vr.TimezonesID AND rate.Code = vr.Code AND rate.OriginationCode = vr.OriginationCode
						WHERE  rate.code is null
						order by vr.FinalRankNumber desc ;



					IF @v_Average_ = 0
					THEN


						/*IF @p_GroupBy = 'Desc' 
						THEN
							truncate tmp_dupVRatesstage2_;

								insert into tmp_dupVRatesstage2_
								SELECT max(OriginationCode) , OriginationDescription, max(RowCode) , description,   MAX(FinalRankNumber) AS MaxFinalRankNumber
								FROM tmp_VRatesstage2_ GROUP BY OriginationDescription , description;

							truncate tmp_Vendorrates_stage3_;
							INSERT INTO tmp_Vendorrates_stage3_
								select  vr.OriginationCode ,vr.OriginationDescription , vr.RowCode as RowCode ,vr.description , vr.rate as rate , vr.rateN as rateN , vr.ConnectionFee as  ConnectionFee,vr.VendorConnectionID,vr.AccountID,vr.RateCurrency,vr.ConnectionFeeCurrency,vr.MinimumDuration
								from tmp_VRatesstage2_ vr
									INNER JOIN tmp_dupVRatesstage2_ vr2
										ON (vr.description = vr2.description AND  vr.FinalRankNumber = vr2.FinalRankNumber);


						ELSE */
							truncate tmp_dupVRatesstage2_;

							insert into tmp_dupVRatesstage2_
								SELECT DISTINCT TimezonesID, OriginationCode , MAX(OriginationDescription), RowCode , MAX(description),   MAX(FinalRankNumber) AS MaxFinalRankNumber
								FROM tmp_VRatesstage2_ GROUP BY TimezonesID,OriginationCode, RowCode;

							truncate tmp_Vendorrates_stage3_;
							INSERT INTO tmp_Vendorrates_stage3_
								select DISTINCT vr.OriginationCode ,vr.OriginationDescription , vr.RowCode as RowCode ,vr.description , vr.rate as rate , vr.rateN as rateN , vr.ConnectionFee as  ConnectionFee,vr.VendorConnectionID,vr.TimezonesID,vr.AccountID,vr.RateCurrency,vr.ConnectionFeeCurrency,vr.MinimumDuration
								from tmp_VRatesstage2_ vr
									INNER JOIN tmp_dupVRatesstage2_ vr2
										ON ( vr.TimezonesID = vr2.TimezonesID AND vr.RowCode = vr2.RowCode AND  vr.FinalRankNumber = vr2.FinalRankNumber );

						-- END IF;


						INSERT IGNORE INTO tmp_Rates_ (OriginationCode ,OriginationDescription,code,description,rate,rateN,ConnectionFee,PreviousRate,VendorConnectionID,TimezonesID,AccountID,RateCurrency,ConnectionFeeCurrency,MinimumDuration)
						SELECT 	DISTINCT
								OriginationCode,
								OriginationDescription,
								RowCode,
								description,
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
							null AS PreviousRate,
								VendorConnectionID,
								TimezonesID,
								AccountID,
								RateCurrency,
								ConnectionFeeCurrency,
								MinimumDuration

						FROM tmp_Vendorrates_stage3_ vRate
						LEFT join tblRateRuleMargin rule_mgn1 on  rule_mgn1.RateRuleId = @v_rateRuleId_ and ( (rule_mgn1.MinRate is null AND  rule_mgn1.MaxRate is null)   OR (vRate.rate Between rule_mgn1.MinRate and rule_mgn1.MaxRate) )
						LEFT join tblRateRuleMargin rule_mgn2 on  rule_mgn2.RateRuleId = @v_rateRuleId_ and ( (rule_mgn2.MinRate is null AND  rule_mgn2.MaxRate is null)   OR (vRate.rateN Between rule_mgn2.MinRate and rule_mgn2.MaxRate) );

					ELSE

						INSERT IGNORE INTO tmp_Rates_ (OriginationCode ,OriginationDescription,code,description,rate,rateN,ConnectionFee,PreviousRate,VendorConnectionID,TimezonesID,AccountID,RateCurrency,ConnectionFeeCurrency,MinimumDuration)
						SELECT 	DISTINCT
								OriginationCode ,
								OriginationDescription,
								RowCode,
								description,
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
							null AS PreviousRate,
							VendorConnectionID,
							TimezonesID,
							AccountID,
							RateCurrency,
							ConnectionFeeCurrency,
							MinimumDuration

						FROM
						(
							select
								DISTINCT
								RowCode AS RowCode,
								OriginationCode as OriginationCode,
								max(OriginationDescription) as OriginationDescription,
								max(description) AS description,
								AVG(Rate) as Rate,
								AVG(RateN) as RateN,
								AVG(ConnectionFee) as ConnectionFee,
								max(VendorConnectionID) as VendorConnectionID,
								TimezonesID as TimezonesID,
								max(AccountID) as AccountID,
								max(RateCurrency) as RateCurrency,
								max(ConnectionFeeCurrency) as ConnectionFeeCurrency,
								max(MinimumDuration) as MinimumDuration

								from tmp_VRatesstage2_
								group by
								/*CASE WHEN @p_GroupBy = 'Desc' THEN
								OriginationDescription
								ELSE
									OriginationCode
								END,
								CASE WHEN @p_GroupBy = 'Desc' THEN
								description
								ELSE  RowCode
								END*/
								TimezonesID, OriginationCode , RowCode

						)  vRate
						LEFT join tblRateRuleMargin rule_mgn1 on  rule_mgn1.RateRuleId = @v_rateRuleId_ and ( (rule_mgn1.MinRate is null AND  rule_mgn1.MaxRate is null)   OR (vRate.rate Between rule_mgn1.MinRate and rule_mgn1.MaxRate) )
						LEFT join tblRateRuleMargin rule_mgn2 on  rule_mgn2.RateRuleId = @v_rateRuleId_ and ( (rule_mgn2.MinRate is null AND  rule_mgn2.MaxRate is null)   OR (vRate.rateN Between rule_mgn2.MinRate and rule_mgn2.MaxRate) );


					END IF;


					SET @v_r_pointer_ = @v_r_pointer_ + 1;


				END WHILE;

		SET @v_t_pointer_ = @v_t_pointer_ + 1;


	END WHILE;
		/*IF @p_GroupBy = 'Desc' 
		THEN

			truncate table tmp_Rates2_;
			insert into tmp_Rates2_ select * from tmp_Rates_;

				insert ignore into tmp_Rates_ (OriginationCode ,OriginationDescription,code,description,rate,rateN,ConnectionFee,PreviousRate,VendorConnectionID,AccountID,RateCurrency,ConnectionFeeCurrency,MinimumDuration)
				select
				distinct
					vr.OriginationCode,
					vr.OriginationDescription,
					vr.Code,
					vr.Description,
					vd.rate,
					vd.rateN,
					vd.ConnectionFee,
					vd.PreviousRate,
					vd.VendorConnectionID,
					vd.AccountID,
					vd.RateCurrency,
					vd.ConnectionFeeCurrency,
					vd.MinimumDuration
				from  tmp_Rates3_ vr
				inner JOIN tmp_Rates2_ vd on   vd.OriginationDescription = vr.OriginationDescription AND vd.Description = vr.Description and vd.Code != vr.Code
				where vd.Rate is not null;

		END IF;
		*/


		IF @v_LessThenRate > 0 AND @v_ChargeRate > 0 THEN
		
			update tmp_Rates_
			SET Rate = @v_ChargeRate
			WHERE  Rate <  @v_LessThenRate;
			
			update tmp_Rates_
			SET RateN = @v_ChargeRate
			WHERE  RateN <  @v_LessThenRate;
			
		END IF;

		
		/*IF @v_UseVendorCurrencyInRateGenerator_  = 1 THEN
		
			update tmp_Rates_
			
			SET 
				Rate =  
										CASE WHEN  RateCurrency = @v_CurrencyID_ THEN
												Rate
										ELSE
											(

												(Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = RateCurrency and  CompanyID = @v_CompanyId_ )
												* (Rate  / (@v_DestinationCurrencyConversionRate ))
											)
										END,	
				
				RateN =
									CASE WHEN  RateCurrency = @v_CurrencyID_ THEN
												RateN
										ELSE
											(

												(Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = RateCurrency and  CompanyID = @v_CompanyId_ )
												* (RateN  / (@v_DestinationCurrencyConversionRate ))
											)
										END,
				ConnectionFee = 
									CASE WHEN  ConnectionFeeCurrency = @v_CurrencyID_ THEN
												ConnectionFee
										ELSE
											(

												(Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = RateCurrency and  CompanyID = @v_CompanyId_ )
												* (ConnectionFee  / (@v_DestinationCurrencyConversionRate ))
											)
										END
			;
		
		END IF;
		*/

		
		
		-- round before insert
		update tmp_Rates_
		SET 
		Rate = fn_Round(Rate,@v_RoundChargedAmount),
		RateN = fn_Round(RateN,@v_RoundChargedAmount),
		ConnectionFee = fn_Round(ConnectionFee,@v_RoundChargedAmount),
		EffectiveDate = @p_EffectiveDate;
		

--		leave GenerateRateTable; 
		
	
		


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
