use speakintelligentRM;
DROP PROCEDURE IF EXISTS `prc_WSGenerateRateTableWithPrefix`;
DELIMITER //
CREATE PROCEDURE `prc_WSGenerateRateTableWithPrefix`(
	IN `p_jobId` INT,
	IN `p_RateGeneratorId` INT,
	IN `p_RateTableId` INT,
	IN `p_TimezonesID` VARCHAR(50),
	IN `p_rateTableName` VARCHAR(200),
	IN `p_EffectiveDate` VARCHAR(10),
	IN `p_delete_exiting_rate` INT,
	IN `p_EffectiveRate` VARCHAR(50),
	IN `p_GroupBy` VARCHAR(50),
	IN `p_ModifiedBy` VARCHAR(50),
	IN `p_IsMerge` INT,
	IN `p_TakePrice` INT,
	IN `p_MergeInto` INT
)
GenerateRateTable:BEGIN




		




 /*	
	--	DECLARE i INTEGER;
--		DECLARE @v_RTRowCount_ INT;
--		DECLARE @v_RatePosition_ INT;
	--	DECLARE @v_Use_Preference_ INT;
	--	DECLARE @v_CurrencyID_ INT;
	--	DECLARE @v_CompanyCurrencyID_ INT;
		-- DECLARE @v_Average_ TINYINT;
		-- DECLARE @v_CompanyId_ INT;
	--	DECLARE @v_codedeckid_ INT;
		-- DECLARE @v_trunk_ INT;
--		DECLARE @v_rateRuleId_ INT;
	--	DECLARE @v_RateGeneratorName_ VARCHAR(200);
--		DECLARE @v_pointer_ INT ;
--		DECLARE @v_rowCount_ INT ;
	--	DECLARE @v_percentageRate INT ;

		DECLARE @v_LessThenRate  DECIMAL(18, 8);
		DECLARE @v_ChargeRate  DECIMAL(18, 8);
		

		DECLARE @v_IncreaseEffectiveDate_ DATETIME ;
		DECLARE @v_DecreaseEffectiveDate_ DATETIME ;


		DECLARE @v_tmp_code_cnt int ;
		DECLARE @v_tmp_code_pointer int;
		DECLARE @v_p_code varchar(50);
		DECLARE @v_Codlen_ int;
		DECLARE @v_p_code__ VARCHAR(50);
		DECLARE @v_Commit int;
		DECLARE @v_TimezonesID int;
*/

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			show warnings;
			ROLLBACK;
			INSERT INTO tmp_JobLog_ (Message) VALUES ('RateTable generation failed');
			

		END;

		SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

		SET @p_jobId						= 	p_jobId;
		SET @p_RateGeneratorId			= 	p_RateGeneratorId;
		SET @p_RateTableId				= 	p_RateTableId;
		SET @p_TimezonesID				= 	p_TimezonesID;
		SET @p_rateTableName				= 	p_rateTableName;
		SET @p_EffectiveDate				= 	p_EffectiveDate;
		SET @p_delete_exiting_rate		= 	p_delete_exiting_rate;
		SET @p_EffectiveRate				= 	p_EffectiveRate;
		SET @p_GroupBy					= 	p_GroupBy;
		SET @p_ModifiedBy				= 	p_ModifiedBy;
		SET @p_IsMerge					= 	p_IsMerge;
		SET @p_TakePrice					= 	p_TakePrice;
		SET @p_MergeInto					= 	p_MergeInto;

		DROP TEMPORARY TABLE IF EXISTS tmp_JobLog_;
		CREATE TEMPORARY TABLE tmp_JobLog_ (
			Message longtext
		);

		SET @@session.collation_connection='utf8_unicode_ci';
		SET @@session.character_set_client='utf8';
		SET SESSION group_concat_max_len = 1000000; 




		SET @p_EffectiveDate = CAST(@p_EffectiveDate AS DATE);
		SET @v_TimezonesID = IF(@p_IsMerge=1,@p_MergeInto,@p_TimezonesID);

		SET @v_RATE_STATUS_AWAITING  = 0;
		SET @v_RATE_STATUS_APPROVED  = 1;
		SET @v_RATE_STATUS_REJECTED  = 2;
		SET @v_RATE_STATUS_DELETE    = 3;

		SET @v_RoundChargedAmount = 6;
	
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
			VendorConnectionID int,
			AccountID int,
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
			VendorConnectionID int,
			AccountID int,
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
		
		DROP TEMPORARY TABLE IF EXISTS tmp_Raterules_dup2;
		CREATE TEMPORARY TABLE tmp_Raterules_dup2  (
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
			AccountID int,
			RateCurrency int,
			ConnectionFeeCurrency int,
			MinimumDuration int,

			INDEX tmp_Vendorrates_stage2__code (`RowCode`)
		);
		DROP TEMPORARY TABLE IF EXISTS tmp_dupVRatesstage2_;
		CREATE TEMPORARY TABLE tmp_dupVRatesstage2_  (
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
			rate DECIMAL(18,8),
			rateN DECIMAL(18,8),
			ConnectionFee DECIMAL(18,8),
			VendorConnectionID int,
			AccountID int,
			RateCurrency int,
			ConnectionFeeCurrency int,
			MinimumDuration int,

			INDEX tmp_Vendorrates_stage2__code (`RowCode`)
		);

		DROP TEMPORARY TABLE IF EXISTS tmp_code_;
		CREATE TEMPORARY TABLE tmp_code_  (
			code VARCHAR(50) COLLATE utf8_unicode_ci,
			INDEX tmp_code_code (`code`)
		);

		DROP TEMPORARY TABLE IF EXISTS tmp_code_origination;
		CREATE TEMPORARY TABLE tmp_code_origination  (
			code VARCHAR(50) COLLATE utf8_unicode_ci,
			INDEX tmp_code_code (`code`)
		);

		DROP TEMPORARY TABLE IF EXISTS tmp_all_code_;
		CREATE TEMPORARY TABLE tmp_all_code_ (
			RowCode  varchar(50) COLLATE utf8_unicode_ci,
			Code  varchar(50) COLLATE utf8_unicode_ci,
			RowNo int,
			INDEX Index2 (Code)
		);



		DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_stage_;
		CREATE TEMPORARY TABLE tmp_VendorRate_stage_ (
			RowCode VARCHAR(50) COLLATE utf8_unicode_ci,
			VendorConnectionID INT ,
			AccountID int,
			VendorConnectionName VARCHAR(100) ,
			OriginationCode varchar(50),
			OriginationDescription varchar(200),
			Code VARCHAR(50) COLLATE utf8_unicode_ci,
			Rate DECIMAL(18,8) ,
			RateN DECIMAL(18,8) ,
			ConnectionFee DECIMAL(18,8) ,
			EffectiveDate DATETIME ,
			Description VARCHAR(255),
			Preference INT,
			RateCurrency int,
			ConnectionFeeCurrency int,
			MinimumDuration int,

			MaxMatchRank int ,
			prev_prev_RowCode VARCHAR(50),
			prev_VendorConnectionID int
		);

		DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_;
		CREATE TEMPORARY TABLE tmp_VendorRate_ (
			VendorConnectionID INT ,
			AccountID int,
			VendorConnectionName VARCHAR(100) ,
			OriginationCode varchar(50),
			OriginationDescription varchar(200),
			Code VARCHAR(50) COLLATE utf8_unicode_ci,
			Rate DECIMAL(18,8) ,
			RateN DECIMAL(18,8) ,
			ConnectionFee DECIMAL(18,8) ,
			EffectiveDate DATETIME ,
			Description VARCHAR(255),
			Preference INT,
			RateCurrency int,
			ConnectionFeeCurrency int,
			MinimumDuration int,

			RowCode VARCHAR(50) COLLATE utf8_unicode_ci
		);
		DROP TEMPORARY TABLE IF EXISTS tmp_final_VendorRate_;
		CREATE TEMPORARY TABLE tmp_final_VendorRate_ (
			VendorConnectionID INT ,
			AccountID int,
			VendorConnectionName VARCHAR(100) ,
			OriginationCode varchar(50),
			OriginationDescription varchar(200),
			Code VARCHAR(50) COLLATE utf8_unicode_ci,
			Rate DECIMAL(18,8) ,
			RateN DECIMAL(18,8) ,
			ConnectionFee DECIMAL(18,8) ,
			EffectiveDate DATETIME ,
			Description VARCHAR(255),
			Preference INT,
			RateCurrency int,
			ConnectionFeeCurrency int,
			MinimumDuration int,

			RowCode VARCHAR(50) COLLATE utf8_unicode_ci,
			FinalRankNumber int,
			INDEX IX_CODE (RowCode)
		);

		
		DROP TEMPORARY TABLE IF EXISTS tmp_VendorCurrentRates_GroupBy_;
		CREATE TEMPORARY TABLE IF NOT EXISTS tmp_VendorCurrentRates_GroupBy_(
			VendorConnectionID int,
			AccountID int,
			VendorConnectionName varchar(200),
			OriginationCode varchar(50),
			OriginationDescription varchar(200),
			Code LONGTEXT,
			Description varchar(200) ,
			Rate DECIMAL(18,8) ,
			RateN DECIMAL(18,8) ,
			ConnectionFee DECIMAL(18,8) ,
			EffectiveDate date,
			TrunkID int,
			TimezonesID int,
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
			AccountID int,
			VendorConnectionName varchar(200),
			OriginationCode varchar(50),
			OriginationDescription varchar(200),
			Code varchar(50) COLLATE utf8_unicode_ci,
			Description varchar(200) ,
			Rate DECIMAL(18,8) ,
			RateN DECIMAL(18,8) ,
			ConnectionFee DECIMAL(18,8) ,
			EffectiveDate date,
			TrunkID int,
			TimezonesID int,
			CountryID int,
			RateID int,
			Preference int,
			RateCurrency int,
			ConnectionFeeCurrency int,
			MinimumDuration int,

			INDEX IX_CODE (Code)
		);
		DROP TEMPORARY TABLE IF EXISTS tmp_VendorCurrentRates1_;
		CREATE TEMPORARY TABLE IF NOT EXISTS tmp_VendorCurrentRates1_(
			VendorConnectionID int,
			AccountID int,
			VendorConnectionName varchar(200),
			OriginationCode varchar(50),
			OriginationDescription varchar(200),
			Code varchar(50),
			Description varchar(200),
			Rate DECIMAL(18,8) ,
			RateN DECIMAL(18,8) ,
			ConnectionFee DECIMAL(18,8) ,
			EffectiveDate date,
			TrunkID int,
			TimezonesID int,
			CountryID int,
			RateID int,
			Preference int,
			RateCurrency int,
			ConnectionFeeCurrency int,
			MinimumDuration int,

			INDEX IX_Code (Code),
			INDEX tmp_VendorCurrentRates_VendorConnectionID (`VendorConnectionID`,`TrunkID`,`RateId`,`EffectiveDate`)
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

		SELECT IFNULL(Value,0)  INTO @v_RateApprovalProcess_ FROM tblCompanySetting WHERE CompanyID = @v_CompanyId_ AND `Key`='RateApprovalProcess';
		
		-- SELECT IFNULL(Value,0) INTO @v_UseVendorCurrencyInRateGenerator_ FROM tblCompanySetting WHERE CompanyID = @v_CompanyId_ AND `Key`='UseVendorCurrencyInRateGenerator';

        Select Value INTO @v_DestinationCurrencyConversionRate from tblCurrencyConversion where tblCurrencyConversion.CurrencyId =  @v_CurrencyID_  and  CompanyID = @v_CompanyId_;

        Select Value INTO @v_CompanyCurrencyConversionRate from tblCurrencyConversion where tblCurrencyConversion.CurrencyId =  @v_CompanyCurrencyID_  and  CompanyID = @v_CompanyId_;

		
		INSERT INTO tmp_Raterules_(
										rateruleid,
										Originationcode,
										Originationdescription,
										OriginationType,
										OriginationCountryID,
										DestinationType,
										DestinationCountryID,
										code,
										description,
										RowNo,
										`Order`
								)
			SELECT
				rateruleid,
				IF(Originationcode='',NULL,Originationcode),
				IF(Originationdescription='',NULL,Originationdescription),
				IF(OriginationType='',NULL,OriginationType),
				IF(OriginationCountryID='',NULL,OriginationCountryID),
				IF(DestinationType='',NULL,DestinationType),
				IF(DestinationCountryID='',NULL,DestinationCountryID),
				IF(code='',NULL,code),
				IF(description='',NULL,description),
				@row_num := @row_num+1 AS RowID,
				`Order`
			FROM tblRateRule,(SELECT @row_num := 0) x
			WHERE rategeneratorid = @p_RateGeneratorId
			ORDER BY `Order` ASC;  

		
			insert into tmp_Raterules_dup (				
										rateruleid,
										Originationcode,
										Originationdescription,
										OriginationType,
										OriginationCountryID,
										DestinationType,
										DestinationCountryID,
										code,
										description,
										RowNo,
										`Order`
									)
			select 							rateruleid,
										Originationcode,
										Originationdescription,
										OriginationType,
										OriginationCountryID,
										DestinationType,
										DestinationCountryID,
										code,
										description,
										RowNo,
										`Order`
			from tmp_Raterules_;


			insert into tmp_Raterules_dup2 (				
										rateruleid,
										Originationcode,
										Originationdescription,
										OriginationType,
										OriginationCountryID,
										DestinationType,
										DestinationCountryID,
										code,
										description,
										RowNo,
										`Order`
									)
			select 							rateruleid,
										Originationcode,
										Originationdescription,
										OriginationType,
										OriginationCountryID,
										DestinationType,
										DestinationCountryID,
										code,
										description,
										RowNo,
										`Order`
			from tmp_Raterules_;





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


		SET @v_pointer_ = 1;
		SET @v_rowCount_ = (SELECT COUNT(rateruleid) FROM tmp_Raterules_);







		insert into tmp_code_
			SELECT
				tblRate.code
			FROM tblRate
				JOIN tmp_Raterules_ rr
					ON ( rr.code is null or (tblRate.Code LIKE (REPLACE(rr.code,'*', '%%'))) )
								AND
						( rr.DestinationType is null OR ( tblRate.`Type` = rr.DestinationType ) )
								AND
						( rr.DestinationCountryID is null  OR (tblRate.`CountryID` = rr.DestinationCountryID ) )
		 where  tblRate.CodeDeckId = @v_codedeckid_
		Order by tblRate.code ;


		insert into tmp_code_origination
			SELECT
				tblRate.code
			FROM tblRate
				JOIN tmp_Raterules_ rr
					ON ( rr.OriginationCode != '' AND tblRate.Code LIKE (REPLACE(rr.OriginationCode,'*', '%%')) )
						AND
						( rr.OriginationType = '' OR ( tblRate.`Type` = OriginationType ))
						AND
						( rr.OriginationCountryID is null OR (tblRate.`CountryID` = OriginationCountryID ))
		 where  tblRate.CodeDeckId = @v_codedeckid_
		Order by tblRate.code ;









		SELECT CurrencyId INTO @v_CompanyCurrencyID_ FROM  tblCompany WHERE CompanyID = @v_CompanyId_;
		SET @IncludeAccountIDs = (SELECT GROUP_CONCAT(AccountID) from tblRateRule rr inner join  tblRateRuleSource rrs on rr.RateRuleId = rrs.RateRuleId where rr.RateGeneratorId = @p_RateGeneratorId ) ;



		IF(@p_IsMerge = 1) 
		THEN
			
			
			

			INSERT INTO tmp_VendorCurrentRates1_
				Select DISTINCT VendorConnectionID,max(AccountID),MAX(VendorConnectionName) AS VendorConnectionName,MAX(OriginationCode) AS OriginationCode,MAX(OriginationDescription) AS OriginationDescription,MAX(Code) AS Code,MAX(Description) AS Description, IF(@p_TakePrice=1,MAX(Rate),MIN(Rate)) AS Rate, IF(@p_TakePrice=1,MAX(RateN),MIN(RateN)) AS RateN,IF(@p_TakePrice=1,MAX(ConnectionFee),MIN(ConnectionFee)) AS ConnectionFee,EffectiveDate,TrunkID,@p_MergeInto AS TimezonesID,MAX(CountryID) AS CountryID,RateID,MAX(Preference) AS Preference, max(RateCurrency) as RateCurrency ,max(ConnectionFeeCurrency) as  ConnectionFeeCurrency, max(MinimumDuration) as MinimumDuration
				FROM (
							 SELECT  vt.VendorConnectionID,tblAccount.AccountID,vt.Name as VendorConnectionName, r2.Code as OriginationCode, r2.Description as OriginationDescription,tblRate.Code, tblRate.Description, @v_CurrencyID_ as RateCurrency ,@v_CurrencyID_  as ConnectionFeeCurrency,tblRateTableRate.MinimumDuration,
									
									CASE WHEN  tblRateTableRate.RateCurrency IS NOT NULL 
									THEN
										CASE WHEN  tblRateTableRate.RateCurrency = @v_CurrencyID_
										THEN
											tblRateTableRate.Rate
										ELSE
										(
											-- Convert to base currrncy and x by RateGenerator Exhange
											(@v_DestinationCurrencyConversionRate )
											* (tblRateTableRate.rate  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = tblRateTableRate.RateCurrency and  CompanyID = @v_CompanyId_ ))
										)
										END
									ELSE 
										(
											(@v_DestinationCurrencyConversionRate )
											* (tblRateTableRate.rate  / (@v_CompanyCurrencyConversionRate ))
										)
									END    
									as Rate,
									CASE WHEN  tblRateTableRate.RateCurrency IS NOT NULL 
									THEN
										CASE WHEN  tblRateTableRate.RateCurrency = @v_CurrencyID_
										THEN
											tblRateTableRate.RateN
										ELSE
										(
											-- Convert to base currrncy and x by RateGenerator Exhange
											(@v_DestinationCurrencyConversionRate )
											* (tblRateTableRate.RateN  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = tblRateTableRate.RateCurrency and  CompanyID = @v_CompanyId_ ))
										)
										END
									ELSE 
										(
											(@v_DestinationCurrencyConversionRate )
											* (tblRateTableRate.RateN  / (@v_CompanyCurrencyConversionRate ))
										)
									END    
									as RateN,
									CASE WHEN  tblRateTableRate.RateCurrency IS NOT NULL 
									THEN
										CASE WHEN  tblRateTableRate.RateCurrency = @v_CurrencyID_
										THEN
											tblRateTableRate.ConnectionFee
										ELSE
										(
											-- Convert to base currrncy and x by RateGenerator Exhange
											(@v_DestinationCurrencyConversionRate )
											* (tblRateTableRate.ConnectionFee  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = tblRateTableRate.RateCurrency and  CompanyID = @v_CompanyId_ ))
										)
										END
									ELSE 
										(
											(@v_DestinationCurrencyConversionRate )
											* (tblRateTableRate.ConnectionFee  / (@v_CompanyCurrencyConversionRate ))
										)
									END    
									as ConnectionFee,


									DATE_FORMAT (tblRateTableRate.EffectiveDate, '%Y-%m-%d') AS EffectiveDate,
								 vt.TrunkID, 
								 tblRateTableRate.TimezonesID, tblRate.CountryID, tblRate.RateID,IFNULL(Preference, 5) AS Preference,
								
	 							@row_num := IF(@prev_VendorConnectionID = vt.VendorConnectionID AND @prev_TrunkID = vt.TrunkID AND @prev_OriginationCode = r2.Code AND @prev_Code = tblRate.Code AND @prev_EffectiveDate >= tblRateTableRate.EffectiveDate, @row_num + 1, 1) AS RowID,

								@prev_VendorConnectionID := vt.VendorConnectionID,
								@prev_TrunkID := vt.TrunkID,
								@prev_TimezonesID := tblRateTableRate.TimezonesID,
								@prev_OriginationCode := r2.Code,
								@prev_Code := tblRate.Code,
								@prev_EffectiveDate := tblRateTableRate.EffectiveDate

							 FROM tblRateTableRate
								 Inner join tblRateTable rt on  rt.CompanyID = @v_CompanyId_ and rt.RateTableID = tblRateTableRate.RateTableID
								Inner join tblVendorConnection vt on vt.CompanyID = @v_CompanyId_ AND vt.RateTableID = tblRateTableRate.RateTableID  and vt.RateTypeID = 1  and vt.Active = 1  and vt.TrunkID =  @v_trunk_
								
								 Inner join tblTimezones t on t.TimezonesID = tblRateTableRate.TimezonesID AND t.Status = 1
								 -- inner join tmp_Codedecks_ tcd on rt.CodeDeckId = tcd.CodeDeckId
								 INNER JOIN tblAccount   ON  tblAccount.AccountID = vt.AccountID AND tblAccount.CompanyID = @v_CompanyId_ and tblAccount.IsVendor = 1
								 INNER JOIN tblRate ON tblRate.CompanyID = @v_CompanyId_  AND tblRate.CodeDeckId = rt.CodeDeckId  AND    tblRateTableRate.RateId = tblRate.RateID
								 INNER JOIN tmp_code_ tcode ON tcode.Code  = tblRate.Code

 								 LEFT JOIN tblRate r2 ON r2.CompanyID = @v_CompanyId_  AND r2.CodeDeckId = rt.CodeDeckId  AND    tblRateTableRate.OriginationRateId = r2.RateID
								 LEFT JOIN tmp_code_origination tcode2 ON tcode2.Code  = r2.Code
								 
								 
	 							,(SELECT @row_num := 1,  @prev_VendorConnectionID := '',@prev_TrunkID := '',@prev_TimezonesID := '', @prev_OriginationCode := '',  @prev_Code := '', @prev_EffectiveDate := '') x

							 WHERE
								 (
									 (@p_EffectiveRate = 'now' AND EffectiveDate <= NOW())
									 OR
									 (@p_EffectiveRate = 'future' AND EffectiveDate > NOW()  )
									 OR
									 (	 @p_EffectiveRate = 'effective' AND EffectiveDate <= @p_EffectiveDate
											 AND ( tblRateTableRate.EndDate IS NULL OR (tblRateTableRate.EndDate > DATE(@p_EffectiveDate)) )
									 )  
								 )
								
								 AND ( tblRateTableRate.EndDate IS NULL OR tblRateTableRate.EndDate > now() )  
								 AND tblAccount.IsVendor = 1
								 AND tblAccount.Status = 1
								 AND tblAccount.CurrencyId is not NULL
								 AND vt.TrunkID = @v_trunk_
								 AND FIND_IN_SET(tblRateTableRate.TimezonesID,@p_TimezonesID) != 0
								 AND tblRateTableRate.Blocked = 0	
								 AND ( @IncludeAccountIDs = NULL
											 OR ( @IncludeAccountIDs IS NOT NULL
														AND FIND_IN_SET(vt.AccountID,@IncludeAccountIDs) > 0
											 )
								 )
								ORDER BY vt.VendorConnectionID, vt.TrunkID, tblRateTableRate.TimezonesID, r2.Code,tblRate.Code, tblRateTableRate.EffectiveDate DESC

						 ) tbl
				GROUP BY VendorConnectionID, TrunkID,OriginationCode, Code,EffectiveDate
				order by VendorConnectionID, TrunkID,OriginationCode, Code,EffectiveDate asc;

		ELSE

			INSERT INTO tmp_VendorCurrentRates1_
				Select DISTINCT VendorConnectionID,AccountID,VendorConnectionName,OriginationCode,OriginationDescription,Code,Description, Rate, RateN,ConnectionFee,EffectiveDate,TrunkID,TimezonesID,CountryID,RateID,Preference,RateCurrency,ConnectionFeeCurrency,MinimumDuration
				FROM (
 							 SELECT  vt.VendorConnectionID,tblAccount.AccountID,vt.Name as VendorConnectionName, r2.Code as OriginationCode, r2.Description as OriginationDescription,tblRate.Code, tblRate.Description,@v_CurrencyID_ as RateCurrency ,@v_CurrencyID_  as ConnectionFeeCurrency,tblRateTableRate.MinimumDuration,

								CASE WHEN  tblRateTableRate.RateCurrency IS NOT NULL 
									THEN
										CASE WHEN  tblRateTableRate.RateCurrency = @v_CurrencyID_
										THEN
											tblRateTableRate.Rate
										ELSE
										(
											-- Convert to base currrncy and x by RateGenerator Exhange
											(@v_DestinationCurrencyConversionRate )
											* (tblRateTableRate.rate  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = tblRateTableRate.RateCurrency and  CompanyID = @v_CompanyId_ ))
										)
										END
									ELSE 
										(
											(@v_DestinationCurrencyConversionRate )
											* (tblRateTableRate.rate  / (@v_CompanyCurrencyConversionRate ))
										)
									END    
									as Rate,
									CASE WHEN  tblRateTableRate.RateCurrency IS NOT NULL 
									THEN
										CASE WHEN  tblRateTableRate.RateCurrency = @v_CurrencyID_
										THEN
											tblRateTableRate.RateN
										ELSE
										(
											-- Convert to base currrncy and x by RateGenerator Exhange
											(@v_DestinationCurrencyConversionRate )
											* (tblRateTableRate.RateN  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = tblRateTableRate.RateCurrency and  CompanyID = @v_CompanyId_ ))
										)
										END
									ELSE 
										(
											(@v_DestinationCurrencyConversionRate )
											* (tblRateTableRate.RateN  / (@v_CompanyCurrencyConversionRate ))
										)
									END    
									as RateN,
									CASE WHEN  tblRateTableRate.RateCurrency IS NOT NULL 
									THEN
										CASE WHEN  tblRateTableRate.RateCurrency = @v_CurrencyID_
										THEN
											tblRateTableRate.ConnectionFee
										ELSE
										(
											-- Convert to base currrncy and x by RateGenerator Exhange
											(@v_DestinationCurrencyConversionRate )
											* (tblRateTableRate.ConnectionFee  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = tblRateTableRate.RateCurrency and  CompanyID = @v_CompanyId_ ))
										)
										END
									ELSE 
										(
											(@v_DestinationCurrencyConversionRate )
											* (tblRateTableRate.ConnectionFee  / (@v_CompanyCurrencyConversionRate ))
										)
									END    
									as ConnectionFee,

								DATE_FORMAT (tblRateTableRate.EffectiveDate, '%Y-%m-%d') AS EffectiveDate,
								 vt.TrunkID, 
								 tblRateTableRate.TimezonesID, 
								 tblRate.CountryID, 
								 tblRate.RateID,
								 IFNULL(Preference, 5) AS Preference,
								 
								@row_num := IF(@prev_VendorConnectionID = vt.VendorConnectionID AND @prev_TrunkID = vt.TrunkID AND @prev_OriginationCode = r2.Code AND @prev_Code = tblRate.Code AND @prev_EffectiveDate >= tblRateTableRate.EffectiveDate, @row_num + 1, 1) AS RowID,

								@prev_VendorConnectionID := vt.VendorConnectionID,
								@prev_TrunkID := vt.TrunkID,
								@prev_TimezonesID := tblRateTableRate.TimezonesID,
								@prev_OriginationCode := r2.Code,
								@prev_Code := tblRate.Code,
								@prev_EffectiveDate := tblRateTableRate.EffectiveDate

							


							 FROM tblRateTableRate
								Inner join  tblRateTable rt on  rt.CompanyID = @v_CompanyId_ and rt.RateTableID = tblRateTableRate.RateTableID
								Inner join tblVendorConnection vt on vt.CompanyID = @v_CompanyId_ AND vt.RateTableID = tblRateTableRate.RateTableID  and vt.RateTypeID = 1  and vt.Active = 1  and vt.TrunkID =  @v_trunk_
								 Inner join tblTimezones t on t.TimezonesID = tblRateTableRate.TimezonesID AND t.Status = 1
								 -- inner join tmp_Codedecks_ tcd on rt.CodeDeckId = tcd.CodeDeckId
								 INNER JOIN tblAccount   ON  tblAccount.AccountID = vt.AccountID AND tblAccount.CompanyID = @v_CompanyId_ and tblAccount.IsVendor = 1
								 INNER JOIN tblRate ON tblRate.CompanyID = @v_CompanyId_  AND tblRate.CodeDeckId = rt.CodeDeckId  AND    tblRateTableRate.RateId = tblRate.RateID
								 INNER JOIN tmp_code_ tcode ON tcode.Code  = tblRate.Code

 								 LEFT JOIN tblRate r2 ON r2.CompanyID = @v_CompanyId_  AND r2.CodeDeckId = rt.CodeDeckId  AND    tblRateTableRate.OriginationRateId = r2.RateID
								 LEFT JOIN tmp_code_origination tcode2 ON tcode2.Code  = r2.Code
								 
								,(SELECT @row_num := 1,  @prev_VendorConnectionID := '',@prev_TrunkID := '',@prev_TimezonesID := '', @prev_OriginationCode := '',  @prev_Code := '', @prev_EffectiveDate := '') x

							 WHERE
								 (
									 (@p_EffectiveRate = 'now' AND EffectiveDate <= NOW())
									 OR
									 (@p_EffectiveRate = 'future' AND EffectiveDate > NOW()  )
									 OR
									 (	 @p_EffectiveRate = 'effective' AND EffectiveDate <= @p_EffectiveDate
											 AND ( tblRateTableRate.EndDate IS NULL OR (tblRateTableRate.EndDate > DATE(@p_EffectiveDate)) )
									 )  
								 )
								
								 
								 AND ( tblRateTableRate.EndDate IS NULL OR tblRateTableRate.EndDate > now() )  
								 AND tblAccount.IsVendor = 1
								 AND tblAccount.Status = 1
								 AND tblAccount.CurrencyId is not NULL
								 AND vt.TrunkID = @v_trunk_
								 AND tblRateTableRate.TimezonesID = @v_TimezonesID
								 AND tblRateTableRate.Blocked = 0	
								 AND ( @IncludeAccountIDs = NULL
											 OR ( @IncludeAccountIDs IS NOT NULL
														AND FIND_IN_SET(vt.AccountID,@IncludeAccountIDs) > 0
											 )
								 )
								ORDER BY vt.VendorConnectionID, vt.TrunkID, tblRateTableRate.TimezonesID, r2.Code,tblRate.Code, tblRateTableRate.EffectiveDate DESC
						 ) tbl

						order by VendorConnectionID,TrunkID,OriginationCode, Code,EffectiveDate asc;

		END IF;
 

		INSERT INTO tmp_VendorCurrentRates_
		Select VendorConnectionID,AccountID,VendorConnectionName,OriginationCode,OriginationDescription,Code,Description, Rate, RateN,ConnectionFee,EffectiveDate,TrunkID,TimezonesID,CountryID,RateID,Preference,RateCurrency,ConnectionFeeCurrency,MinimumDuration
		FROM (
					 SELECT * ,
						 @row_num := IF(@prev_VendorConnectionID = VendorConnectionID AND @prev_TrunkID = TrunkID AND @prev_TimezonesID = TimezonesID AND @prev_OriginationCode = OriginationCode AND  @prev_Code = Code AND @prev_EffectiveDate >= EffectiveDate, @row_num + 1, 1) AS RowID,
						 @prev_VendorConnectionID := VendorConnectionID,
						 @prev_TrunkID := TrunkID,
						 @prev_TimezonesID := TimezonesID,
						 @prev_Code := Code,
						 @prev_OriginationCode := OriginationCode,
						 @prev_EffectiveDate := EffectiveDate
					 FROM tmp_VendorCurrentRates1_
						 ,(SELECT @row_num := 1,  @prev_VendorConnectionID := 0 ,@prev_TrunkID := 0 ,@prev_TimezonesID := 0, @prev_Code := 0,@prev_OriginationCode := 0, @prev_EffectiveDate := '') x
					 ORDER BY VendorConnectionID, TrunkID, TimezonesID, OriginationCode, Code, EffectiveDate DESC
				 ) tbl
		WHERE RowID = 1
		order by VendorConnectionID, TrunkID, TimezonesID, OriginationCode, Code, EffectiveDate asc;



		IF @p_GroupBy = 'Desc' 
		THEN
 			
			INSERT INTO tmp_VendorCurrentRates_GroupBy_
			Select VendorConnectionID,max(AccountID),max(VendorConnectionName),max(OriginationCode),OriginationDescription,max(Code),Description,max(Rate),max(RateN),max(ConnectionFee),max(EffectiveDate),TrunkID,TimezonesID,max(CountryID),max(RateID),max(Preference),max(RateCurrency) as RateCurrency ,max(ConnectionFeeCurrency) as  ConnectionFeeCurrency, max(MinimumDuration) as MinimumDuration
			FROM tmp_VendorCurrentRates_ 
			GROUP BY VendorConnectionID, TrunkID, TimezonesID, OriginationDescription, Description
			order by VendorConnectionID, TrunkID, TimezonesID, OriginationDescription, Description asc;

			truncate table tmp_VendorCurrentRates_;

			INSERT INTO tmp_VendorCurrentRates_ (VendorConnectionID,AccountID,VendorConnectionName,OriginationCode,OriginationDescription,Code,Description, Rate, RateN,ConnectionFee,EffectiveDate,TrunkID,TimezonesID,CountryID,RateID,Preference,RateCurrency,ConnectionFeeCurrency,MinimumDuration)
			SELECT VendorConnectionID,AccountID,VendorConnectionName,OriginationCode,OriginationDescription,Code,Description, Rate, RateN,ConnectionFee,EffectiveDate,TrunkID,TimezonesID,CountryID,RateID,Preference,RateCurrency,ConnectionFeeCurrency,MinimumDuration
			FROM tmp_VendorCurrentRates_GroupBy_;



		END IF;


		insert into tmp_VendorRate_ (
				VendorConnectionID ,
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
				
				RowCode

		)
			select
				VendorConnectionID ,
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
				
				Code as RowCode
			from tmp_VendorCurrentRates_;
			
		--	select * from tmp_VendorRate_;

		WHILE @v_pointer_ <= @v_rowCount_
		DO

			SET @v_rateRuleId_ = (SELECT rateruleid FROM tmp_Raterules_ rr WHERE rr.RowNo = @v_pointer_);


	--	SELECT @v_rateRuleId_;
			truncate tmp_Rates2_;
			INSERT INTO tmp_Rates2_ (OriginationCode,OriginationDescription,code,description,rate,rateN,ConnectionFee,VendorConnectionID,AccountID,RateCurrency,ConnectionFeeCurrency,MinimumDuration)
				select  OriginationCode,OriginationDescription,code,description,rate,rateN,ConnectionFee,VendorConnectionID,AccountID,RateCurrency,ConnectionFeeCurrency,MinimumDuration from tmp_Rates_;

				IF @p_GroupBy = 'Desc' 
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

				END IF;

			truncate tmp_final_VendorRate_;

			IF( @v_Use_Preference_ = 0 ) THEN


				insert into tmp_final_VendorRate_
					SELECT
						VendorConnectionID ,
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
						
						RowCode,
						FinalRankNumber
					from
						(
							SELECT
								vr.VendorConnectionID ,
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
								
								CASE WHEN @p_GroupBy = 'Desc'  THEN 
										@rank := CASE WHEN ( @prev_OriginationDescription = vr.OriginationDescription  AND @prev_Description = vr.Description  AND @prev_Rate <=  vr.Rate AND (@v_percentageRate = 0 OR  (@prev_Rate > 0 AND fn_Round((((vr.Rate - @prev_Rate) / @prev_Rate) * 100),2) > @v_percentageRate) )  ) THEN @rank+1
													 ELSE
														 1
													 END

								ELSE	@rank := CASE WHEN (  @prev_OriginationCode = vr.OriginationCode  AND @prev_RowCode = vr.RowCode  AND @prev_Rate <=  vr.Rate  AND   (@v_percentageRate = 0 OR  (@prev_Rate > 0 AND fn_Round((((vr.Rate - @prev_Rate) / @prev_Rate) * 100),2) > @v_percentageRate) ) ) THEN @rank+1
													  WHEN (  @prev_OriginationCode = vr.OriginationCode  AND @prev_RowCode = vr.RowCode  AND @prev_Rate <=  vr.Rate  AND   (@v_percentageRate = 0 OR  (@prev_Rate > 0 AND fn_Round((((vr.Rate - @prev_Rate) / @prev_Rate) * 100),2) <= @v_percentageRate) ) ) THEN -1 -- remove -1 records
													  
													  WHEN (  @prev_OriginationCode = vr.OriginationCode  AND @prev_RowCode = vr.RowCode  AND @prev_Rate =  vr.Rate  AND   (@v_percentageRate = 0 OR  (@prev_Rate > 0 AND fn_Round((((vr.Rate - @prev_Rate) / @prev_Rate) * 100),2) > @v_percentageRate) ) ) THEN @rank
													  WHEN (  @prev_OriginationCode = vr.OriginationCode  AND @prev_RowCode = vr.RowCode  AND @prev_Rate =  vr.Rate  AND   (@v_percentageRate = 0 OR  (@prev_Rate > 0 AND fn_Round((((vr.Rate - @prev_Rate) / @prev_Rate) * 100),2) <= @v_percentageRate) ) ) THEN -1

													 ELSE
														 1
													 END
								END
									AS FinalRankNumber,
								@prev_RowCode  := vr.RowCode,
								@prev_OriginationCode  := vr.OriginationCode,
								@prev_OriginationDescription  := vr.OriginationDescription,
								@prev_Description  := vr.Description,
								@prev_Rate  := vr.Rate
							from (
										 select distinct tmpvr.*
										 from tmp_VendorRate_  tmpvr
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
										
										 where rr2.RateRuleId is null

									 ) vr
								,(SELECT @rank := 0 ,@prev_OriginationCode := ''  , @prev_RowCode := '' , @prev_OriginationDescription := ''  , @prev_Description := '' ,  @prev_Rate := 0  ) x
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
								END ,*/
								 vr.OriginationCode,vr.RowCode, vr.Rate,vr.VendorConnectionID

						) tbl1
					where FinalRankNumber <= @v_RatePosition_ AND FinalRankNumber != -1;

					
			ELSE

				insert into tmp_final_VendorRate_
					SELECT
						VendorConnectionID ,
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
						RowCode,
						FinalRankNumber
					from
						(
							SELECT
								vr.VendorConnectionID ,
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

								CASE WHEN @p_GroupBy = 'Desc'  THEN

									@preference_rank := CASE WHEN (@prev_OriginationDescription    = vr.OriginationDescription AND @prev_Description  = vr.Description  AND @prev_Preference > vr.Preference  )   THEN @preference_rank + 1
															 WHEN (@prev_OriginationDescription    = vr.OriginationDescription AND @prev_Description  = vr.Description  AND @prev_Preference = vr.Preference AND @prev_Rate <= vr.Rate  AND  (@v_percentageRate = 0 OR  (@prev_Rate > 0 AND fn_Round((((vr.Rate - @prev_Rate) / @prev_Rate) * 100),2) > @v_percentageRate) )  ) THEN @preference_rank + 1
															 WHEN (@prev_OriginationDescription    = vr.OriginationDescription AND @prev_Description  = vr.Description  AND @prev_Preference = vr.Preference AND @prev_Rate <= vr.Rate  AND  (@v_percentageRate = 0 OR  (@prev_Rate > 0 AND fn_Round((((vr.Rate - @prev_Rate) / @prev_Rate) * 100),2) <= @v_percentageRate) )  ) THEN -1 -- remove -1 records
															ELSE 1 END
								ELSE
									@preference_rank := CASE WHEN (@prev_OriginationCode    = vr.OriginationCode AND @prev_Code  = vr.RowCode  AND @prev_Preference > vr.Preference  )   THEN @preference_rank + 1
															WHEN (@prev_OriginationCode    = vr.OriginationCode AND @prev_Code  = vr.RowCode  AND @prev_Preference = vr.Preference AND @prev_Rate <= vr.Rate   AND  (@v_percentageRate = 0 OR  (@prev_Rate > 0 AND fn_Round((((vr.Rate - @prev_Rate) / @prev_Rate) * 100),2) > @v_percentageRate) ) ) THEN @preference_rank + 1
															WHEN (@prev_OriginationCode    = vr.OriginationCode AND @prev_Code  = vr.RowCode  AND @prev_Preference = vr.Preference AND @prev_Rate <= vr.Rate   AND  (@v_percentageRate = 0 OR  (@prev_Rate > 0 AND fn_Round((((vr.Rate - @prev_Rate) / @prev_Rate) * 100),2) <= @v_percentageRate) ) ) THEN -1 -- remove -1 records
															ELSE 1 END
								END

								AS FinalRankNumber,
								@prev_Code := vr.RowCode,
								@prev_OriginationCode := vr.OriginationCode,
								@prev_Description  := vr.Description,
								@prev_OriginationDescription  := vr.OriginationDescription,
								@prev_Preference := vr.Preference,
								@prev_Rate := vr.Rate
							from (
										 select distinct tmpvr.*
										 from tmp_VendorRate_  tmpvr
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
										 where rr2.RateRuleId is null

									 ) vr

								,(SELECT @preference_rank := 0 , @prev_OriginationCode := ''  ,  @prev_Code := ''  , @prev_OriginationDescription := '', @prev_Description := '', @prev_Preference := 5,  @prev_Rate := 0 ) x
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
								END ,*/
								vr.OriginationCode,vr.RowCode, vr.Preference DESC ,vr.Rate ASC ,vr.VendorConnectionID ASC
						) tbl1
					where FinalRankNumber <= @v_RatePosition_ AND FinalRankNumber != -1;

			END IF;


			truncate   tmp_VRatesstage2_;

			INSERT INTO tmp_VRatesstage2_ 
				SELECT
					vr.RowCode,
					vr.OriginationCode,
					vr.OriginationDescription,
					vr.code,
					vr.description,
					vr.rate,
					vr.rateN,
					vr.ConnectionFee,
					vr.FinalRankNumber,
					vr.VendorConnectionID,
					vr.AccountID,
					vr.RateCurrency,
					vr.ConnectionFeeCurrency,
					vr.MinimumDuration
					
				FROM tmp_final_VendorRate_ vr
				left join tmp_Rates2_ rate on rate.Code = vr.Code AND rate.OriginationCode = vr.OriginationCode
				WHERE  rate.code is null
				order by vr.FinalRankNumber desc ;



			IF @v_Average_ = 0
			THEN


				IF @p_GroupBy = 'Desc' 
				THEN

						truncate table tmp_dupVRatesstage2_;

						insert into tmp_dupVRatesstage2_
						SELECT max(OriginationCode) , OriginationDescription,max(RowCode) , description,   MAX(FinalRankNumber) AS MaxFinalRankNumber
						FROM tmp_VRatesstage2_ GROUP BY OriginationDescription, description;

					truncate tmp_Vendorrates_stage3_;
					INSERT INTO tmp_Vendorrates_stage3_
						select  vr.OriginationCode ,vr.OriginationDescription ,  vr.RowCode as RowCode ,vr.description , vr.rate as rate , vr.rateN as rateN , vr.ConnectionFee as  ConnectionFee,vr.VendorConnectionID,vr.AccountID,vr.RateCurrency,vr.ConnectionFeeCurrency,vr.MinimumDuration
						from tmp_VRatesstage2_ vr
							INNER JOIN tmp_dupVRatesstage2_ vr2
								ON (vr.OriginationDescription = vr2.OriginationDescription AND vr.description = vr2.description AND  vr.FinalRankNumber = vr2.FinalRankNumber);


				ELSE
					truncate tmp_dupVRatesstage2_;
					insert into tmp_dupVRatesstage2_
						SELECT OriginationCode , MAX(OriginationDescription), RowCode , MAX(description),   MAX(FinalRankNumber) AS MaxFinalRankNumber
						FROM tmp_VRatesstage2_ GROUP BY OriginationCode,RowCode;

					truncate tmp_Vendorrates_stage3_;
					INSERT INTO tmp_Vendorrates_stage3_
						select  vr.OriginationCode ,vr.OriginationDescription , vr.RowCode as RowCode ,vr.description , vr.rate as rate , vr.rateN as rateN , vr.ConnectionFee as  ConnectionFee,vr.VendorConnectionID,vr.AccountID,vr.RateCurrency,vr.ConnectionFeeCurrency,vr.MinimumDuration
						from tmp_VRatesstage2_ vr
							INNER JOIN tmp_dupVRatesstage2_ vr2
								ON (vr.RowCode = vr2.RowCode AND vr.OriginationCode = vr2.OriginationCode AND  vr.FinalRankNumber = vr2.FinalRankNumber);

				END IF;


				INSERT IGNORE INTO tmp_Rates_ (OriginationCode ,OriginationDescription,code,description,rate,rateN,ConnectionFee,PreviousRate,VendorConnectionID,AccountID,RateCurrency,ConnectionFeeCurrency,MinimumDuration)
                SELECT 
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
					AccountID,
					RateCurrency,
					ConnectionFeeCurrency,
					MinimumDuration
                FROM tmp_Vendorrates_stage3_ vRate
			    	 LEFT join tblRateRuleMargin rule_mgn1 on  rule_mgn1.RateRuleId = @v_rateRuleId_ and ( (rule_mgn1.MinRate is null AND  rule_mgn1.MaxRate is null)   OR (vRate.rate Between rule_mgn1.MinRate and rule_mgn1.MaxRate) )
                LEFT join tblRateRuleMargin rule_mgn2 on  rule_mgn2.RateRuleId = @v_rateRuleId_ and ( (rule_mgn2.MinRate is null AND  rule_mgn2.MaxRate is null)   OR (vRate.rateN Between rule_mgn2.MinRate and rule_mgn2.MaxRate) );
   



			ELSE

				INSERT IGNORE INTO tmp_Rates_ (OriginationCode ,OriginationDescription,code,description,rate,rateN,ConnectionFee,PreviousRate,VendorConnectionID,AccountID,RateCurrency,ConnectionFeeCurrency,MinimumDuration)
                SELECT 
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
					AccountID,
					RateCurrency,
					ConnectionFeeCurrency,
					MinimumDuration
					
                FROM
                    (
                        select
                        max(OriginationCode) as OriginationCode,
						max(OriginationDescription) as OriginationDescription,
						max(RowCode) AS RowCode,
                        max(description) AS description,
                        AVG(Rate) as Rate,
                        AVG(RateN) as RateN,
                        AVG(ConnectionFee) as ConnectionFee,
						max(VendorConnectionID) as VendorConnectionID,
						max(AccountID) as AccountID,
						max(RateCurrency) as RateCurrency,
						max(ConnectionFeeCurrency) as ConnectionFeeCurrency,
						max(MinimumDuration) as MinimumDuration
						
                        from tmp_VRatesstage2_
                        group by
                        CASE WHEN @p_GroupBy = 'Desc' THEN
                          OriginationDescription
                        ELSE  OriginationCode
      					END,
						CASE WHEN @p_GroupBy = 'Desc' THEN
                          description
                        ELSE  RowCode
      					END

                    )  vRate
			       LEFT join tblRateRuleMargin rule_mgn1 on  rule_mgn1.RateRuleId = @v_rateRuleId_ and ( (rule_mgn1.MinRate is null AND  rule_mgn1.MaxRate is null)   OR (vRate.rate Between rule_mgn1.MinRate and rule_mgn1.MaxRate) )
                LEFT join tblRateRuleMargin rule_mgn2 on  rule_mgn2.RateRuleId = @v_rateRuleId_ and ( (rule_mgn2.MinRate is null AND  rule_mgn2.MaxRate is null)   OR (vRate.rateN Between rule_mgn2.MinRate and rule_mgn2.MaxRate) );





			END IF;


			SET @v_pointer_ = @v_pointer_ + 1;


		END WHILE;

		
		IF @p_GroupBy = 'Desc' 
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
		RateN = fn_Round(Rate,@v_RoundChargedAmount),
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
		14.    	
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
										@v_TimezonesID,
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
										@v_TimezonesID,
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
						RateTableId = @p_RateTableId AND TimezonesID = @v_TimezonesID;
				
					
					CALL prc_ArchiveOldRateTableRateAA(@p_RateTableId,@v_TimezonesID,CONCAT(@p_ModifiedBy,'|RateGenerator')); 
				
				ELSE 

					UPDATE
						tblRateTableRate
					SET
						EndDate = NOW()
					WHERE
						RateTableId = @p_RateTableId AND TimezonesID = @v_TimezonesID;

					
					CALL prc_ArchiveOldRateTableRate(@p_RateTableId,@v_TimezonesID,CONCAT(@p_ModifiedBy,'|RateGenerator')); 
				
					
				END IF;
				
				
			END IF;	
			
			
			IF (@v_RateApprovalProcess_ = 1 ) THEN 

				UPDATE
					tmp_Rates_ tr
				SET
					PreviousRate = (SELECT rtr.Rate FROM tblRateTableRateAA rtr JOIN tblRate r ON r.RateID=rtr.RateID WHERE rtr.RateTableID=@p_RateTableId AND rtr.TimezonesID=@v_TimezonesID AND r.Code=tr.Code AND rtr.EffectiveDate<tr.EffectiveDate ORDER BY rtr.EffectiveDate DESC,rtr.RateTableRateID DESC LIMIT 1);

				UPDATE
					tmp_Rates_ tr
				SET
					PreviousRate = (SELECT rtr.Rate FROM tblRateTableRateArchive rtr JOIN tblRate r ON r.RateID=rtr.RateID WHERE rtr.RateTableID=@p_RateTableId AND rtr.TimezonesID=@v_TimezonesID AND r.Code=tr.Code AND rtr.EffectiveDate<tr.EffectiveDate ORDER BY rtr.EffectiveDate DESC,rtr.RateTableRateID DESC LIMIT 1)
				WHERE
					PreviousRate is null;

			ELSE 

					UPDATE
						tmp_Rates_ tr
					SET
						PreviousRate = (SELECT rtr.Rate FROM tblRateTableRate rtr JOIN tblRate r ON r.RateID=rtr.RateID WHERE rtr.RateTableID=@p_RateTableId AND rtr.TimezonesID=@v_TimezonesID AND r.Code=tr.Code AND rtr.EffectiveDate<tr.EffectiveDate ORDER BY rtr.EffectiveDate DESC,rtr.RateTableRateID DESC LIMIT 1);

					UPDATE
						tmp_Rates_ tr
					SET
						PreviousRate = (SELECT rtr.Rate FROM tblRateTableRateArchive rtr JOIN tblRate r ON r.RateID=rtr.RateID WHERE rtr.RateTableID=@p_RateTableId AND rtr.TimezonesID=@v_TimezonesID AND r.Code=tr.Code AND rtr.EffectiveDate<tr.EffectiveDate ORDER BY rtr.EffectiveDate DESC,rtr.RateTableRateID DESC LIMIT 1)
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
						(@p_GroupBy != 'Desc'  AND rate.code = tblRate.Code )

						OR
						(@p_GroupBy = 'Desc' AND rate.description = tblRate.description )
					)
					AND
					rtr.TimezonesID = @v_TimezonesID AND
					rtr.RateTableId = @p_RateTableId AND
					tblRate.CodeDeckId = @v_codedeckid_ AND
					rate.rate != rtr.Rate;

				CALL prc_ArchiveOldRateTableRateAA(@p_RateTableId,@v_TimezonesID,CONCAT(@p_ModifiedBy,'|RateGenerator')); 

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
						(@p_GroupBy != 'Desc'  AND rate.code = tblRate.Code )

						OR
						(@p_GroupBy = 'Desc' AND rate.description = tblRate.description )
					)
					AND
					rtr.TimezonesID = @v_TimezonesID AND
					rtr.RateTableId = @p_RateTableId AND
					tblRate.CodeDeckId = @v_codedeckid_ AND
					rate.rate != rtr.Rate;
	
				CALL prc_ArchiveOldRateTableRate(@p_RateTableId,@v_TimezonesID,CONCAT(@p_ModifiedBy,'|RateGenerator')); 

			
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
							@v_TimezonesID AS TimezonesID,
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
									AND tbl1.TimezonesID = @v_TimezonesID
							LEFT JOIN tblRateTableRateAA tbl2
								ON tblRate.RateId = tbl2.RateId
									and tbl2.EffectiveDate = rate.EffectiveDate
									AND tbl2.RateTableId = @p_RateTableId
									AND tbl2.TimezonesID = @v_TimezonesID
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
						AND rtr.TimezonesID = @v_TimezonesID 
						AND rtr.EffectiveDate = rate.EffectiveDate 
						AND tblRate.CodeDeckId = @v_codedeckid_;

					

					CALL prc_ArchiveOldRateTableRateAA(@p_RateTableId,@v_TimezonesID,CONCAT(@p_ModifiedBy,'|RateGenerator')); 

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
							@v_TimezonesID AS TimezonesID,
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
									AND tbl1.TimezonesID = @v_TimezonesID
							LEFT JOIN tblRateTableRate tbl2
								ON tblRate.RateId = tbl2.RateId
									and tbl2.EffectiveDate = rate.EffectiveDate
									AND tbl2.RateTableId = @p_RateTableId
									AND tbl2.TimezonesID = @v_TimezonesID
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
				AND rtr.TimezonesID = @v_TimezonesID 
				AND rtr.EffectiveDate = rate.EffectiveDate 
				AND tblRate.CodeDeckId = @v_codedeckid_;
	

			CALL prc_ArchiveOldRateTableRate(@p_RateTableId,@v_TimezonesID,CONCAT(@p_ModifiedBy,'|RateGenerator')); 

			
		END IF;



			
			
		-- insert EndDate = EffectiveDate of future same rate 
		IF (@v_RateApprovalProcess_ = 1 ) THEN 

			
				INSERT INTO tmp_ALL_RateTableRate_ 
				SELECT * FROM tblRateTableRateAA WHERE RateTableID=@p_RateTableId AND TimezonesID=@v_TimezonesID;


				UPDATE
					tmp_ALL_RateTableRate_ temp
				SET
					EndDate = ( SELECT EffectiveDate 
								FROM tblRateTableRateAA rtr 
								WHERE rtr.RateTableID=@p_RateTableId 
								AND rtr.TimezonesID=@v_TimezonesID 
								AND rtr.RateID=temp.RateID 
								AND rtr.EffectiveDate > temp.EffectiveDate 
								ORDER BY rtr.EffectiveDate ASC, rtr.TimezonesID , rtr.RateID  ASC LIMIT 1
							)
				WHERE
					temp.RateTableId = @p_RateTableId AND temp.TimezonesID = @v_TimezonesID;

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
					rtr.RateTableId=@p_RateTableId AND
					rtr.TimezonesID=@v_TimezonesID;
				
				
				CALL prc_ArchiveOldRateTableRateAA(@p_RateTableId,@v_TimezonesID,CONCAT(@p_ModifiedBy,'|RateGenerator')); 


		ELSE	

				INSERT INTO tmp_ALL_RateTableRate_ 
				SELECT * FROM tblRateTableRate WHERE RateTableID=@p_RateTableId AND TimezonesID=@v_TimezonesID;


				UPDATE
					tmp_ALL_RateTableRate_ temp
				SET
					EndDate = (SELECT EffectiveDate FROM tblRateTableRate rtr WHERE rtr.RateTableID=@p_RateTableId AND rtr.TimezonesID=@v_TimezonesID AND rtr.RateID=temp.RateID AND rtr.EffectiveDate>temp.EffectiveDate ORDER BY rtr.EffectiveDate ASC,rtr.RateTableRateID ASC LIMIT 1)
				WHERE
					temp.RateTableId = @p_RateTableId AND temp.TimezonesID = @v_TimezonesID;

				UPDATE
					tblRateTableRate rtr
				INNER JOIN
					tmp_ALL_RateTableRate_ temp ON rtr.RateTableRateID=temp.RateTableRateID AND rtr.TimezonesID=temp.TimezonesID
				SET
					rtr.EndDate=temp.EndDate,
					rtr.ApprovedStatus = @v_RATE_STATUS_APPROVED
				WHERE
					rtr.RateTableId=@p_RateTableId AND
					rtr.TimezonesID=@v_TimezonesID;
				

				
				CALL prc_ArchiveOldRateTableRate(@p_RateTableId,@v_TimezonesID,CONCAT(@p_ModifiedBy,'|RateGenerator')); 


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