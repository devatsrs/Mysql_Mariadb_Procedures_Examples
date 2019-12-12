use speakintelligentRM;
-- CALL prc_WSGenerateRateTable_NEW2(350,132,-1,'SI Test RG - Termination - 12-07-DD-Test3-324660-13-09','2019-09-13',0,'now','Onno Westra') ;

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
		
		SET @p_rateTableName				= 	p_rateTableName;
		SET @p_EffectiveDate				= 	p_EffectiveDate;
		SET @p_delete_exiting_rate		= 	p_delete_exiting_rate;
		SET @p_EffectiveRate				= 	p_EffectiveRate;
		
		SET @p_ModifiedBy				= 	p_ModifiedBy;
		
		
		


		SET @v_RATE_STATUS_AWAITING  = 0;
		SET @v_RATE_STATUS_APPROVED  = 1;
		SET @v_RATE_STATUS_REJECTED  = 2;
		SET @v_RATE_STATUS_DELETE    = 3;
	
		SET @v_RoundChargedAmount = 6;

    
		SET	@v_RateTypeID = 1;
        set @v_AppliedToCustomer = 1; 
        set @v_AppliedToVendor = 2; 
        set @v_AppliedToReseller = 3; 
		SET @v_default_TimezonesID = (SELECT TimezonesID from tblTimezones where Title = 'Default');


		SET @p_EffectiveDate = CAST(@p_EffectiveDate AS DATE);
		

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
 			OriginationType VARCHAR(200) COLLATE utf8_unicode_ci,
			OriginationCountryID INT,
			DestinationType VARCHAR(200) COLLATE utf8_unicode_ci,
			DestinationCountryID INT,
			code VARCHAR(50) COLLATE utf8_unicode_ci,
 			RowNo INT,
			`Order` INT
		);

		DROP TEMPORARY TABLE IF EXISTS tmp_Raterules_dup;
		CREATE TEMPORARY TABLE tmp_Raterules_dup  (
			rateruleid INT,
			Originationcode VARCHAR(50) COLLATE utf8_unicode_ci,
 			OriginationType VARCHAR(200) COLLATE utf8_unicode_ci,
			OriginationCountryID INT,
			DestinationType VARCHAR(200) COLLATE utf8_unicode_ci,
			DestinationCountryID INT,
			code VARCHAR(50) COLLATE utf8_unicode_ci,
 			RowNo INT,
			`Order` INT
		);



		DROP TEMPORARY TABLE IF EXISTS tmp_rule_ori_code_;
		CREATE TEMPORARY TABLE tmp_rule_ori_code_  (
			CodeID INT auto_increment,
			RateID INT,
			Code VARCHAR(50),
			Type VARCHAR(50),
			CountryID INT,
			INDEX INDEX1(RateID),
			INDEX INDEX2(Code),
			INDEX INDEX3(Type,CountryID),
			PRIMARY KEY (CodeID)
		);
		DROP TEMPORARY TABLE IF EXISTS tmp_code_;
		CREATE TEMPORARY TABLE tmp_code_  (
			CodeID INT auto_increment,
			RateID INT,
			Code VARCHAR(50),
			Type VARCHAR(50),
			CountryID INT,
			INDEX INDEX1(RateID),
			INDEX INDEX2(Code),
			INDEX INDEX3(Type,CountryID),
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
			INDEX INDEX2(Code),
			INDEX INDEX3(Type,CountryID),
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
			INDEX INDEX2(Code),
			INDEX INDEX3(Type,CountryID),
			PRIMARY KEY (CodeID)
		);

		
		DROP TEMPORARY TABLE IF EXISTS tmp_search_code_;
		CREATE TEMPORARY TABLE tmp_search_code_ (
			RowCodeID int ,
			CodeID  INT,
			RowCode VARCHAR(50),
			Code VARCHAR(50),
			INDEX INDEX3(CodeID)

		);


		DROP TEMPORARY TABLE IF EXISTS tmp_code_origination;
		CREATE TEMPORARY TABLE tmp_code_origination  (
			RateID INT,
			
			
			INDEX tmp_code_code (`RateID`)
		);

		 


		DROP TEMPORARY TABLE IF EXISTS tmp_tblAccounts;
		CREATE TEMPORARY TABLE tmp_tblAccounts (
			AccountID INT(11) ,
			RateTableID INT(11) ,
			VendorConnectionID INT(11) ,
			VendorConnectionName VARCHAR(200),
			index INDEX1(RateTableID)
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
			EffectiveDate DATE,
			Preference INT(11),
			MinimumDuration INT(11),
			INDEX Index1 (RateID,OriginationRateID)

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
			INDEX Index1 ( CodeID )
		);

		DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_stage;
		CREATE TEMPORARY TABLE IF NOT EXISTS tmp_VendorRate_stage(
			TimezonesID int,
			VendorConnectionID int,
			AccountID int,
			RowCodeID INT,
			OriginationCodeID int,
			CodeID int,
			Rate DECIMAL(18, 8) ,
			RateN DECIMAL(18, 8) ,
			ConnectionFee DECIMAL(18, 8) ,
			Preference int,
			MinimumDuration int,
			INDEX Index1 ( RowCodeID,TimezonesID,VendorConnectionID, OriginationCodeID, CodeID )
		);



		DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_stage_1;
		CREATE TEMPORARY TABLE tmp_VendorRate_stage_1 (
			TimezonesID int,
			VendorConnectionID int,
			RowCodeID int,
			OriginationCodeID int,
			CodeID int,
			AccountID int,
			Rate DECIMAL(18, 8) ,
			RateN DECIMAL(18, 8) ,
			ConnectionFee DECIMAL(18, 8) ,
			Preference int,
			MinimumDuration int,
		INDEX Index1 (TimezonesID),
			INDEX Index2 (VendorConnectionID,OriginationCodeID,RowCodeID)
		);

		DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_stage_1_DEFAULT;
		 CREATE TEMPORARY TABLE tmp_VendorRate_stage_1_DEFAULT (
 
			TimezonesID int,
			VendorConnectionID int,
			RowCodeID int,
			OriginationCodeID int,
			CodeID int,
			AccountID int,
			Rate DECIMAL(18, 8) ,
			RateN DECIMAL(18, 8) ,
			ConnectionFee DECIMAL(18, 8) ,
			Preference int,
			MinimumDuration int,
			 INDEX INDEX1 (TimezonesID),
			 INDEX INDEX2 (VendorConnectionID),
			 INDEX INDEX3 (OriginationCodeID,RowCodeID)

		);

		DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_stage_1_dup;
		 CREATE TEMPORARY TABLE tmp_VendorRate_stage_1_dup (
 
			TimezonesID int,
			VendorConnectionID int,
			RowCodeID int,
			OriginationCodeID int,
			CodeID int,
			AccountID int,
			Rate DECIMAL(18, 8) ,
			RateN DECIMAL(18, 8) ,
			ConnectionFee DECIMAL(18, 8) ,
			Preference int,
			MinimumDuration int,

			 INDEX INDEX1 (TimezonesID),
			 INDEX INDEX2 (VendorConnectionID),
			INDEX INDEX3 (OriginationCodeID,RowCodeID)

		);

		DROP TEMPORARY TABLE IF EXISTS tmp_timezones;
		CREATE TEMPORARY TABLE tmp_timezones (
			ID int auto_increment,
			TimezonesID int,
			primary key (ID)
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
			MinimumDuration INT,
			INDEX INDEX1 (TimezonesID,OriginationCodeID,CodeID)

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
			MinimumDuration INT,
			INDEX INDEX1 (TimezonesID),
			INDEX INDEX2 (CodeID,OriginationCodeID),
			INDEX INDEX3 (Rate),
			INDEX INDEX4 (RateN)

		);

 		DROP TEMPORARY TABLE IF EXISTS tmp_VRatesstage2_;
		CREATE TEMPORARY TABLE tmp_VRatesstage2_  (
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
			FinalRankNumber INT,
			INDEX INDEX1 (TimezonesID,OriginationCodeID,RowCodeID,FinalRankNumber)

		);
		DROP TEMPORARY TABLE IF EXISTS tmp_dupVRatesstage2_;
		CREATE TEMPORARY TABLE tmp_dupVRatesstage2_  (

			TimezonesID int,
			OriginationCodeID int,
			RowCodeID int,
			FinalRankNumber int,
			INDEX INDEX1 (TimezonesID,OriginationCodeID,RowCodeID,FinalRankNumber)

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
			ConnectionFee DECIMAL(18,6),
			MinimumDuration INT,
			INDEX INDEX1 (Rate,RateN)

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
				ConnectionFee DECIMAL(18,6),
				Preference int,
				MinimumDuration INT,

				INDEX Index1 (TimezonesID),
				INDEX Index2 (CodeID,OriginationCodeID,RowCodeID,AccountID)

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
				Preference int,
				MinimumDuration INT,
				FinalRankNumber INT ,

			INDEX IX_CODE (TimezonesID,OriginationCodeID,CodeID,FinalRankNumber)

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
				INDEX `IX_IAAB_RateTableId_RateID_ORateID_TimezonesID_EffectiveDate` (`RateTableId`, `RateID`, `OriginationRateID`, `TimezonesID`, `EffectiveDate`),
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
		
		

        Select Value INTO @v_DestinationCurrencyConversionRate from tblCurrencyConversion where tblCurrencyConversion.CurrencyId =  @v_CurrencyID_  and  CompanyID = @v_CompanyId_;

        Select Value INTO @v_CompanyCurrencyConversionRate from tblCurrencyConversion where tblCurrencyConversion.CurrencyId =  @v_CompanyCurrencyID_  and  CompanyID = @v_CompanyId_;


		INSERT INTO tmp_Raterules_(
										rateruleid,
										Originationcode,
										
										OriginationType,
										OriginationCountryID,
										DestinationType,
										DestinationCountryID,
										code,
										
										RowNo,
										`Order`
								)
			SELECT
				rateruleid,
				IF(Originationcode='',NULL,Originationcode),
				IF(OriginationType='',NULL,OriginationType),
				IF(TRIM(OriginationCountryID)='',NULL,OriginationCountryID),
				IF(DestinationType='',NULL,DestinationType),
				IF(TRIM(DestinationCountryID)='',NULL,DestinationCountryID),
				IF(code='',NULL	,code),
				@row_num := @row_num+1 AS RowID,
				`Order`
			FROM tblRateRule,(SELECT @row_num := 0) x
			WHERE rategeneratorid = @p_RateGeneratorId
			ORDER BY `Order` ASC;  

			insert into tmp_Raterules_dup  	select 	*	from tmp_Raterules_;

		insert into tmp_code_ ( RateID, Code, Type, CountryID )
		SELECT DISTINCT r.RateID, r.Code, r.Type, r.CountryID
		from tblRate r
		INNER JOIN tmp_Raterules_ rr
			ON   ( fn_IsEmpty(rr.code)  OR rr.code = '*' OR (r.Code LIKE (REPLACE(rr.code,'*', '%%')) ))
					 AND
					 ( fn_IsEmpty(rr.DestinationType)  OR ( r.`Type` = rr.DestinationType ))
					 AND
					 ( fn_IsEmpty(rr.DestinationCountryID) OR (r.`CountryID` = rr.DestinationCountryID ))
		where r.CodeDeckID =  @v_codedeckid_
		ORDER BY LENGTH(r.Code), r.Code ASC;


		insert into tmp_rule_ori_code_ ( RateID, Code, Type, CountryID )
			SELECT DISTINCT r.RateID, r.Code, r.Type, r.CountryID
			from tblRate r
				INNER JOIN tmp_Raterules_ rr
					ON   ( fn_IsEmpty(rr.Originationcode)  OR rr.Originationcode = '*' OR (r.Code LIKE (REPLACE(rr.Originationcode,'*', '%%')) ))
							 AND
							 ( fn_IsEmpty(rr.OriginationType)  OR ( r.`Type` = rr.OriginationType ))
							 AND
							 ( fn_IsEmpty(rr.OriginationCountryID) OR (r.`CountryID` = rr.OriginationCountryID ))
			where r.CodeDeckID =  @v_codedeckid_
			ORDER BY LENGTH(r.Code), r.Code ASC;




	

		insert into tmp_code_dup select * from 	tmp_code_;
		insert into tmp_code_dup2 select * from 	tmp_code_;

			insert into tmp_search_code_ ( RowCodeID,CodeID,RowCode,Code )
			SELECT DISTINCT r.CodeID as RowCodeID ,r2.CodeID as CodeID,r.Code as RowCode ,r2.Code as Code
			from tblRateSearchCode rsc
			INNER JOIN tmp_code_ r on    r.RateID = rsc.RowCodeRateID 
			INNER JOIN tmp_code_dup r2 on    r2.RateID = rsc.CodeRateID 
		 	/*INNER JOIN tmp_Raterules_ rr
				ON   ( fn_IsEmpty(rr.code)  OR rr.code = '*' OR (r.Code LIKE (REPLACE(rr.code,'*', '%%')) ))
						AND
				( fn_IsEmpty(rr.DestinationType)  OR ( r.`Type` = rr.DestinationType ))
						AND
				( fn_IsEmpty(rr.DestinationCountryID) OR (r.`CountryID` = rr.DestinationCountryID) )*/
			where rsc.CodeDeckID =  @v_codedeckid_
			
			;






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
			EffectiveDate,
			Preference,
			MinimumDuration 
			)
			select
				distinct
				rtr.TimezonesID,VendorConnectionID,a.AccountID,OriginationRateID,rtr.RateID,
				CASE WHEN  rtr.RateCurrency IS NOT NULL 
				THEN
					CASE WHEN  rtr.RateCurrency = @v_CurrencyID_
					THEN
						rtr.Rate
					ELSE
					(
						
						(@v_DestinationCurrencyConversionRate ) * (rtr.rate  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = rtr.RateCurrency and  CompanyID = @v_CompanyId_ ))
					)
					END
				ELSE 
					(
						(@v_DestinationCurrencyConversionRate )  * (rtr.rate  / (@v_CompanyCurrencyConversionRate ))
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
						
						(@v_DestinationCurrencyConversionRate )  * (rtr.RateN  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = rtr.RateCurrency and  CompanyID = @v_CompanyId_ ))
					)
					END
				ELSE 
					(
						(@v_DestinationCurrencyConversionRate ) * (rtr.RateN  / (@v_CompanyCurrencyConversionRate ))
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
						
						(@v_DestinationCurrencyConversionRate )  * (rtr.ConnectionFee  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = rtr.ConnectionFeeCurrency and  CompanyID = @v_CompanyId_ ))
					)
					END
				ELSE 
					(
						(@v_DestinationCurrencyConversionRate ) * (rtr.ConnectionFee  / (@v_CompanyCurrencyConversionRate ))
					)
				END    
				as ConnectionFee,
				DATE(EffectiveDate) as EffectiveDate, 
				
				
				IFNULL(Preference, 5) AS Preference,
				
				
				MinimumDuration

				from tblRateTableRate rtr
				INNER JOIN tmp_code_ r on    r.RateID =  rtr.RateID
				

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
				
				AND rtr.Blocked = 0 
				 
				;



				INSERT INTO tmp_VendorRate_detail 				
				(		TimezonesID,
						VendorConnectionID,
						AccountID,
						OriginationCodeID,
						CodeID,
						Rate,
						RateN,
						ConnectionFee,
						Preference,
						MinimumDuration
				 )
				Select distinct 
						TimezonesID,
						VendorConnectionID,
						AccountID,
						OriginationCodeID,
						CodeID,
						Rate,
						RateN,
						ConnectionFee,
						Preference,
						MinimumDuration
				FROM (
						SELECT 
							-- DISTINCT 
							v.TimezonesID,
							v.VendorConnectionID,
							v.AccountID,
							ifnull(r2.CodeID,0) as OriginationCodeID,
							r.CodeID as  CodeID,
							v.Rate,
							v.RateN,
							v.ConnectionFee,
							v.Preference,
							v.MinimumDuration,
							@row_num := IF(@prev_VendorConnectionID = v.VendorConnectionID AND @prev_TimezonesID = v.TimezonesID AND @prev_OriginationRateID = v.OriginationRateID AND 
											@prev_RateID = v.RateID AND @prev_EffectiveDate >= v.EffectiveDate, @row_num + 1, 1) AS RowID,
							@prev_VendorConnectionID := VendorConnectionID,
							
							@prev_TimezonesID := v.TimezonesID,
							@prev_OriginationRateID := v.OriginationRateID,
							@prev_RateID := v.RateID,
							@prev_EffectiveDate := v.EffectiveDate
						FROM tmp_tblRateTableRate v
						INNER JOIN tmp_code_ r ON  r.RateId = v.RateID
						LEFT JOIN tmp_rule_ori_code_ r2 ON r2.RateId = v.OriginationRateID
							,(SELECT @row_num := 1,  @prev_VendorConnectionID := 0 ,@prev_TimezonesID := 0, @prev_OriginationRateID := 0,@prev_RateID := 0, @prev_EffectiveDate := '') x
						ORDER BY v.VendorConnectionID, v.TimezonesID, r2.Code, r.Code, v.EffectiveDate DESC
					) tbl
				WHERE RowID = 1;
			



		insert into tmp_VendorRate_stage
			(
				TimezonesID,
				VendorConnectionID,
				RowCodeID,
				OriginationCodeID,
				CodeID,
				AccountID,
				Rate,
				RateN,
				ConnectionFee,
				Preference,
				MinimumDuration
			)
		SELECT
			distinct
			v.TimezonesID,
			v.VendorConnectionID,
			SplitCode.RowCodeID,
			v.OriginationCodeID,
			v.CodeID,
			v.AccountID ,
			v.Rate ,
			v.RateN ,
			v.ConnectionFee ,
			v.Preference,
			v.MinimumDuration
		FROM tmp_VendorRate_detail v
		LEFT join  tmp_search_code_ SplitCode on v.CodeID = SplitCode.CodeID;

		insert into tmp_VendorRate_stage_1
								(TimezonesID,VendorConnectionID,RowCodeID,OriginationCodeID,CodeID,AccountID,Rate,RateN,ConnectionFee,Preference,MinimumDuration)
			SELECT
				distinct TimezonesID,VendorConnectionID,RowCodeID,OriginationCodeID,CodeID,AccountID,Rate,RateN,ConnectionFee,Preference,MinimumDuration
			from (
						 SELECT
							 TimezonesID,VendorConnectionID,RowCodeID,OriginationCodeID,CodeID,AccountID,Rate,RateN,ConnectionFee,Preference,MinimumDuration,

							 @SingleRowCode := ( CASE WHEN( @prev_OriginationCodeID = OriginationCodeID  AND @prev_RowCodeID = RowCodeID  AND  @prev_TimezonesID = TimezonesID  AND @prev_VendorConnectionID = VendorConnectionID     )
								 THEN @SingleRowCode + 1
																	 ELSE 1  END ) AS SingleRowCode,
							 @prev_OriginationCodeID := OriginationCodeID	 ,
							 @prev_RowCodeID := RowCodeID	 ,
							 @prev_VendorConnectionID := VendorConnectionID ,
							 @prev_TimezonesID := TimezonesID
							FROM tmp_VendorRate_stage
							 , (SELECT  @prev_TimezonesID := null, @prev_OriginationCodeID := null, @prev_RowCodeID := null,  @SingleRowCode := null , @prev_VendorConnectionID := null ) x
 							order by  TimezonesID,VendorConnectionID desc ,RowCodeID desc ,OriginationCodeID desc ,CodeID desc
		
				 ) tmp1 where SingleRowCode = 1;


			


		SET @v_hasDefault_ = ( SELECT COUNT(TimezonesID) FROM ( SELECT DISTINCT TimezonesID FROM tmp_VendorRate_stage_1 WHERE TimezonesID = @v_default_TimezonesID group by TimezonesID ) tmp );
		SET @v_rowCount_ = ( SELECT COUNT(TimezonesID) FROM ( SELECT DISTINCT TimezonesID FROM tmp_VendorRate_stage_1 WHERE TimezonesID != @v_default_TimezonesID group by TimezonesID ) tmp );
		SET @v_pointer_ = 1;
		
		IF @v_rowCount_ > 0 AND @v_hasDefault_ = 1 THEN 

				INSERT INTO tmp_VendorRate_stage_1_DEFAULT (
												TimezonesID,
												VendorConnectionID,
												RowCodeID,
												OriginationCodeID,
												CodeID,
												AccountID ,
												Rate ,
												RateN ,
												ConnectionFee ,
												Preference,
												MinimumDuration

											)
											SELECT
												DISTINCT
												TimezonesID,
												VendorConnectionID,
												RowCodeID,
												OriginationCodeID,
												CodeID,
												AccountID ,
												Rate ,
												RateN ,
												ConnectionFee ,
												Preference,
												MinimumDuration

				FROM tmp_VendorRate_stage_1 
				WHERE TimezonesID = @v_default_TimezonesID;


				DELETE  FROM tmp_VendorRate_stage_1 WHERE TimezonesID = @v_default_TimezonesID;


				
				INSERT INTO tmp_VendorRate_stage_1_dup (
						TimezonesID,
						VendorConnectionID,
						RowCodeID,
						OriginationCodeID,
						CodeID,
						AccountID ,
						Rate ,
						RateN ,
						ConnectionFee ,
						Preference,
						MinimumDuration


				)
				SELECT
						DISTINCT
						TimezonesID,
						VendorConnectionID,
						RowCodeID,
						OriginationCodeID,
						CodeID,
						AccountID ,
						Rate ,
						RateN ,
						ConnectionFee ,
						Preference,
						MinimumDuration

				FROM tmp_VendorRate_stage_1;

				insert into tmp_timezones (TimezonesID) select distinct TimezonesID from tmp_VendorRate_stage_1 WHERE TimezonesID != @v_default_TimezonesID;
				


				
				delete vd 
				from tmp_VendorRate_stage_1_dup vd
				INNER JOIN  tmp_VendorRate_stage_1_DEFAULT v
				ON v.VendorConnectionID = vd.VendorConnectionID AND
				
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
						CodeID,
						AccountID ,
						Rate ,
						RateN ,
						ConnectionFee ,
						Preference,
						MinimumDuration


					)
					SELECT 

						DISTINCT 
						@v_v_TimezonesID as TimezonesID , 
						vd.VendorConnectionID,
						vd.RowCodeID,
						vd.OriginationCodeID,
						vd.CodeID,
						vd.AccountID ,
						vd.Rate ,
						vd.RateN ,
						vd.ConnectionFee ,
						vd.Preference,
						vd.MinimumDuration


					FROM tmp_VendorRate_stage_1_DEFAULT vd
					LEFT JOIN tmp_VendorRate_stage_1_dup v on 
										
										v.TimezonesID  = @v_v_TimezonesID AND
 										vd.OriginationCodeID = v.OriginationCodeID AND
										vd.RowCodeID = v.RowCodeID;

					SET @v_pointer_ = @v_pointer_ + 1;

				END WHILE;
				
		END IF;



		
		



		truncate table tmp_timezones;
		insert into tmp_timezones (TimezonesID) select distinct TimezonesID from tmp_VendorRate_stage_1;

		SET @v_t_pointer_ = 1;
		SET @v_t_rowCount_ = ( SELECT COUNT(TimezonesID) FROM tmp_timezones );

		
		WHILE @v_t_pointer_ <= @v_t_rowCount_
		DO

				SET @v_TimezonesID_ = ( SELECT TimezonesID FROM tmp_timezones WHERE ID = @v_t_pointer_ );

				SET @v_r_pointer_ = 1;
				SET @v_r_rowCount_ = ( SELECT COUNT(rateruleid) FROM tmp_Raterules_ );

				
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
											DISTINCT
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

						insert into tmp_final_VendorRate_(
							TimezonesID,
							VendorConnectionID,
							AccountID,
							RowCodeID,
							OriginationCodeID,
							CodeID,
							Rate,
							RateN,
							ConnectionFee,
							Preference,
							MinimumDuration,
							FinalRankNumber

						)
							SELECT
											DISTINCT
                      TimezonesID,
                      VendorConnectionID,
                      AccountID,
                      RowCodeID,
                      IFNULL(OriginationCodeID,0) AS OriginationCodeID,
                      CodeID,
                      Rate,
                      RateN,
                      ConnectionFee,
						Preference,
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
												Preference,
												MinimumDuration,
										@rank := CASE WHEN ( @prev_TimezonesID = vr.TimezonesID  AND  @prev_OriginationCodeID = vr.OriginationCodeID  AND  @prev_RowCodeID = vr.RowCodeID  AND @prev_Rate <  vr.Rate  AND (@v_percentageRate = 0 OR  (@v_percentageRate > 0 AND fn_Round((((vr.Rate - @prev_Rate) / @prev_Rate) * 100),2) > @v_percentageRate) ) ) THEN @rank+1
															WHEN ( @prev_TimezonesID = vr.TimezonesID  AND @prev_OriginationCodeID = vr.OriginationCodeID  AND  @prev_RowCodeID = vr.RowCodeID  AND @prev_Rate <  vr.Rate  AND (@v_percentageRate = 0 OR  (@v_percentageRate > 0 AND fn_Round((((vr.Rate - @prev_Rate) / @prev_Rate) * 100),2) <= @v_percentageRate) ) ) THEN -1 
															
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
												from tmp_VendorRate_stage_1  tmpvr
												Inner join  tmp_code_ r on r.CodeID = tmpvr.CodeID
												LEFT join  tmp_rule_ori_code_ r2   on   r2.CodeID = tmpvr.OriginationCodeID
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
										vr.TimezonesID,vr.OriginationCodeID,vr.RowCodeID, vr.Rate,vr.VendorConnectionID

								) tbl1
							where FinalRankNumber <= @v_RatePosition_ AND FinalRankNumber != -1;

					ELSE


						insert into tmp_final_VendorRate_(
								TimezonesID,
								VendorConnectionID,
								AccountID,
								RowCodeID,
								OriginationCodeID,
								CodeID,
								Rate,
								RateN,
								ConnectionFee,
								Preference,
								MinimumDuration,
								FinalRankNumber
							)
							SELECT
								DISTINCT
                TimezonesID,
                VendorConnectionID,
                AccountID,
                RowCodeID,
                IFNULL(OriginationCodeID,0) AS OriginationCodeID,
                CodeID,
                Rate,
                RateN,
                ConnectionFee,
								Preference,
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
										Preference,
                    MinimumDuration,
											@preference_rank := CASE WHEN (@prev_TimezonesID = vr.TimezonesID  AND @prev_OriginationCodeID    = vr.OriginationCodeID AND @prev_Code  = vr.RowCodeID  AND @prev_Preference > vr.Preference  )   THEN @preference_rank + 1
																	WHEN (@prev_TimezonesID = vr.TimezonesID  AND @prev_OriginationCodeID    = vr.OriginationCodeID AND @prev_Code  = vr.RowCodeID  AND @prev_Preference = vr.Preference AND @prev_Rate <= vr.Rate   AND  (@v_percentageRate = 0 OR  (@v_percentageRate > 0 AND fn_Round((((vr.Rate - @prev_Rate) / @prev_Rate) * 100),2) > @v_percentageRate) ) ) THEN @preference_rank + 1
																	WHEN (@prev_TimezonesID = vr.TimezonesID  AND @prev_OriginationCodeID    = vr.OriginationCodeID AND @prev_Code  = vr.RowCodeID  AND @prev_Preference = vr.Preference AND @prev_Rate <= vr.Rate   AND  (@v_percentageRate = 0 OR  (@v_percentageRate > 0 AND fn_Round((((vr.Rate - @prev_Rate) / @prev_Rate) * 100),2) <= @v_percentageRate) ) ) THEN -1 
																	ELSE 1 END

										AS FinalRankNumber,
										@prev_TimezonesID  := vr.TimezonesID,
										@prev_RowCodeID := vr.RowCodeID,
										@prev_OriginationCodeID := vr.OriginationCodeID,
 										@prev_Preference := vr.Preference,
										@prev_Rate := vr.Rate
									from (
                         select distinct tmpvr.*
                         from tmp_VendorRate_stage_1  tmpvr
                           Inner join  tmp_code_ r on tmpvr.TimezonesID = @v_TimezonesID_  AND r.CodeID = tmpvr.CodeID
													 LEFT join  tmp_rule_ori_code_ r2   on   r2.CodeID = tmpvr.OriginationCodeID
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
										vr.TimezonesID  , vr.OriginationCodeID, vr.RowCodeID, vr.Preference DESC ,vr.Rate ASC ,vr.VendorConnectionID ASC
								) tbl1
							where FinalRankNumber <= @v_RatePosition_ AND FinalRankNumber != -1;


					END IF;



          truncate  table  tmp_VRatesstage2_;
          INSERT INTO tmp_VRatesstage2_(
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
					)
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
            left join tmp_Rates2_ rate on rate.TimezonesID = vr.TimezonesID AND rate.OriginationCodeID = vr.OriginationCodeID AND rate.CodeID = vr.RowCodeID
            WHERE  rate.CodeID is null
            order by vr.FinalRankNumber desc ;



					IF @v_Average_ = 0
					THEN


            truncate tmp_dupVRatesstage2_;


            insert into tmp_dupVRatesstage2_(
									TimezonesID ,
									OriginationCodeID ,
									RowCodeID ,
									FinalRankNumber

						)
              SELECT DISTINCT
                  TimezonesID,
                  OriginationCodeID ,
                  RowCodeID,
                  MAX(FinalRankNumber) AS MaxFinalRankNumber
              FROM tmp_VRatesstage2_ GROUP BY TimezonesID,OriginationCodeID, RowCodeID;

            truncate tmp_Vendorrates_stage3_;
            INSERT INTO tmp_Vendorrates_stage3_(
										TimezonesID ,
										VendorConnectionID ,
										AccountID ,
										RowCodeID ,
										OriginationCodeID ,
										CodeID ,
										Rate ,
										RateN ,
										ConnectionFee ,
										MinimumDuration
						)
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
                vr.MinimumDuration
              from tmp_VRatesstage2_ vr
                INNER JOIN tmp_dupVRatesstage2_ vr2
                  ON ( vr.TimezonesID = vr2.TimezonesID AND vr.OriginationCodeID = vr2.OriginationCodeID  AND vr.RowCodeID = vr2.RowCodeID AND  vr.FinalRankNumber = vr2.FinalRankNumber );

 

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



    

    DROP TEMPORARY TABLE IF EXISTS tmp_Rate_final_1 ;
    CREATE TEMPORARY TABLE tmp_Rate_final_1 (
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
      
      AccountID int,
      RateCurrency INT,
      ConnectionFeeCurrency INT,
      MinimumDuration int,
      INDEX INDEX1 (Rate),
      INDEX INDEX2 (TimezonesID),
      INDEX INDEX3 (EffectiveDate),
      INDEX INDEX4 (RateID,EffectiveDate)
    );

    INSERT INTO tmp_Rate_final_1(
      OriginationRateID,
      RateID,
      RateTableId,
      TimezonesID,
      Rate,
      RateN,
      PreviousRate,
      ConnectionFee,
      EffectiveDate,
      Interval1,
      IntervalN,
      AccountID,
      RateCurrency,
      ConnectionFeeCurrency,
      MinimumDuration
	)
      SELECT
        distinct
        oc.RateID as OriginationRateID,
        c.RateID,
        @p_RateTableId,
        r.TimezonesID,
				fn_Round(r.Rate,@v_RoundChargedAmount),
				fn_Round(r.RateN,@v_RoundChargedAmount),
        r.Rate as PreviousRate,
        fn_Round(IFNULL(r.ConnectionFee,0),@v_RoundChargedAmount) AS ConnectionFee,
        @p_EffectiveDate,
        tblRate.Interval1,
        tblRate.IntervalN,
        
        r.AccountID,
        @v_CurrencyID_ as RateCurrency,
        @v_CurrencyID_ as ConnectionFeeCurrency,
        r.MinimumDuration
      FROM tmp_Rates_ r
        INNER JOIN tmp_code_  c on r.CodeID = c.CodeID
        INNER JOIN tblRate  on tblRate.RateID = c.RateID
				LEFT JOIN tmp_rule_ori_code_ oc on r.OriginationCodeID = oc.CodeID;


    
		-- // https://dba.stackexchange.com/questions/97286/will-large-inserts-crash-a-3-node-mysql-database-cluster
		





					IF @p_RateTableId = -1
					THEN

						
						SET @v_TerminationType = 1;

						INSERT INTO tblRateTable (Type,CompanyId, RateTableName, RateGeneratorID, TrunkID, CodeDeckId,CurrencyID,RoundChargedAmount,AppliedTo,Reseller)
						VALUES (@v_TerminationType, @v_CompanyId_, @p_rateTableName, @p_RateGeneratorId, @v_trunk_, @v_codedeckid_,@v_CurrencyID_,@v_RoundChargedAmount,@v_AppliedTo,@v_Reseller);


						SET @p_RateTableId = LAST_INSERT_ID();
						





						/*loop starts */

						select count(*) into @v_row_count from tmp_Rate_final_1 ;

						IF @v_row_count  > 0 THEN

										
							SET @v_v_pointer_ = 1;
							SET @v_limit = 100000;   
							SET @v_v_rowCount_ = ceil(@v_row_count/@v_limit);

							WHILE @v_v_pointer_ <= @v_v_rowCount_
							DO

								SET @v_OffSet_ = (@v_v_pointer_ * @v_limit) - @v_limit;


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
								
								AccountID int,
								RateCurrency INT,
								ConnectionFeeCurrency INT,
								MinimumDuration int,
								INDEX INDEX1 (Rate),
								INDEX INDEX2 (TimezonesID),
								INDEX INDEX3 (EffectiveDate),
								INDEX INDEX4 (RateID,EffectiveDate)
								);
								
								SET @stm_query = CONCAT("insert into tmp_Rate_final
														select * from tmp_Rate_final_1 
														LIMIT " , @v_limit , "  OFFSET " ,   @v_OffSet_ );

								PREPARE stm_query FROM @stm_query;
								EXECUTE stm_query;
								DEALLOCATE PREPARE stm_query;

								START TRANSACTION;


								IF (@v_RateApprovalProcess_ = 1) 
								THEN
		

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
											IFNULL(OriginationRateID,0),
											RateID,
											@p_RateTableId,
											TimezonesID,
											Rate,
											RateN,
											EffectiveDate,
											Rate as PreviousRate,
											Interval1,
											IntervalN,
											ConnectionFee,
											@v_RATE_STATUS_AWAITING as ApprovedStatus,
											AccountID,
											RateCurrency,
											ConnectionFeeCurrency,
											MinimumDuration

										FROM tmp_Rate_final;


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

											IFNULL(OriginationRateID,0),
											RateID,
											@p_RateTableId,
											TimezonesID,
											Rate,
											RateN,
											EffectiveDate,
											Rate as PreviousRate,
											Interval1,
											IntervalN,
											ConnectionFee,
											@v_RATE_STATUS_APPROVED as ApprovedStatus,
											AccountID,
											RateCurrency,
											ConnectionFeeCurrency,
											MinimumDuration


										FROM tmp_Rate_final;


								END IF;

								COMMIT;

								SET @v_v_pointer_ = @v_v_pointer_ + 1;


							END WHILE;
								/*loop ends*/

						END IF; -- 		IF @v_row_count  > 0 THEN


			ELSE	/* IF @p_RateTableId = -1 */

						
						IF @p_delete_exiting_rate = 1
						THEN

							IF (@v_RateApprovalProcess_ = 1 ) THEN

								UPDATE
									tblRateTableRateAA
								SET
									EndDate = NOW()
								WHERE
									RateTableId = @p_RateTableId ; 


								CALL prc_ArchiveOldRateTableRateAA(@p_RateTableId,NULL,CONCAT(@p_ModifiedBy,'|RateGenerator'));

							ELSE

								UPDATE
									tblRateTableRate
								SET
									EndDate = NOW()
								WHERE
									RateTableId = @p_RateTableId ; 


								CALL prc_ArchiveOldRateTableRate(@p_RateTableId,NULL,CONCAT(@p_ModifiedBy,'|RateGenerator'));


							END IF;


						END IF;


						IF (@v_RateApprovalProcess_ = 1 ) THEN

							UPDATE
								tmp_Rate_final_1 tr
							SET
								PreviousRate = (SELECT rtr.Rate 
													FROM tblRateTableRateAA rtr 
													WHERE rtr.RateTableID=@p_RateTableId 
													AND rtr.TimezonesID=tr.TimezonesID AND rtr.RateID=tr.RateID
													AND rtr.EffectiveDate<tr.EffectiveDate 
													ORDER BY rtr.EffectiveDate DESC,rtr.RateTableRateID DESC LIMIT 1);

							UPDATE
								tmp_Rate_final_1 tr
							SET
								PreviousRate = (SELECT rtr.Rate 
														FROM tblRateTableRateArchive rtr 
														WHERE rtr.RateTableID=@p_RateTableId 
														AND rtr.TimezonesID=tr.TimezonesID  AND rtr.RateID=tr.RateID
														AND rtr.EffectiveDate<tr.EffectiveDate 
														ORDER BY rtr.EffectiveDate DESC,rtr.RateTableRateID DESC LIMIT 1)
							WHERE
								PreviousRate is null;

						ELSE

							UPDATE
								tmp_Rate_final_1 tr
							SET
								PreviousRate = (SELECT rtr.Rate FROM tblRateTableRate rtr  WHERE rtr.RateTableID=@p_RateTableId AND rtr.TimezonesID=tr.TimezonesID AND rtr.RateID=tr.RateID  AND rtr.EffectiveDate < tr.EffectiveDate ORDER BY rtr.EffectiveDate DESC,rtr.RateTableRateID DESC LIMIT 1);

							UPDATE
								tmp_Rate_final_1 tr
							SET
								PreviousRate = (SELECT rtr.Rate FROM tblRateTableRateArchive rtr  WHERE   rtr.RateTableID=@p_RateTableId AND rtr.TimezonesID=tr.TimezonesID AND rtr.RateID=tr.RateID  AND rtr.EffectiveDate < tr.EffectiveDate ORDER BY rtr.EffectiveDate DESC,rtr.RateTableRateID DESC LIMIT 1)
							WHERE
								PreviousRate is null;


						END IF;


						IF @v_IncreaseEffectiveDate_ != @v_DecreaseEffectiveDate_ THEN

							UPDATE tmp_Rate_final_1
							SET
								EffectiveDate =		CASE WHEN PreviousRate < Rate
									THEN
										@v_IncreaseEffectiveDate_
																	WHEN PreviousRate > Rate THEN
																		@v_DecreaseEffectiveDate_
																	ELSE @p_EffectiveDate
																	END;

						END IF;

						
						IF (@v_RateApprovalProcess_ = 1 ) THEN

							UPDATE
									tblRateTableRateAA rtr

									INNER JOIN
									tmp_Rate_final_1 rate ON

																				rtr.TimezonesID = rate.TimezonesID
																				AND rate.RateID = rtr.RateID
																				AND  rtr.EffectiveDate = @p_EffectiveDate
							SET
								rtr.EndDate = NOW()
							WHERE
								rtr.RateTableId = @p_RateTableId
								AND
								rtr.RateTableId = @p_RateTableId AND
								rate.rate != rtr.Rate;

							CALL prc_ArchiveOldRateTableRateAA(@p_RateTableId,NULL,CONCAT(@p_ModifiedBy,'|RateGenerator'));

						ELSE


							UPDATE
									tblRateTableRate rtr

									INNER JOIN
									tmp_Rate_final_1 rate ON

																				rtr.TimezonesID = rate.TimezonesID
																				AND rate.RateID = rtr.RateID
																				AND  rtr.EffectiveDate = @p_EffectiveDate
							SET
								rtr.EndDate = NOW()
							WHERE
								rtr.RateTableId = @p_RateTableId
								AND
								rtr.RateTableId = @p_RateTableId AND
								rate.rate != rtr.Rate;




							CALL prc_ArchiveOldRateTableRate(@p_RateTableId,NULL,CONCAT(@p_ModifiedBy,'|RateGenerator'));


						END IF;

						IF (@v_RateApprovalProcess_ = 1 ) THEN

							UPDATE
									tblRateTableRateAA rtr
									LEFT JOIN
									tmp_Rate_final_1 rate ON rate.OriginationRateID = rtr.OriginationRateID and rate.RateID=rtr.RateID
							SET
								rtr.EndDate = NOW()
							WHERE
								rate.RateID is null
								AND rtr.RateTableId = @p_RateTableId
								AND rtr.TimezonesID = rate.TimezonesID
								AND rtr.EffectiveDate = rate.EffectiveDate;


							CALL prc_ArchiveOldRateTableRateAA(@p_RateTableId,NULL,CONCAT(@p_ModifiedBy,'|RateGenerator'));


						ELSE


							UPDATE
									tblRateTableRate rtr
									LEFT JOIN
									tmp_Rate_final_1 rate ON rate.OriginationRateID = rtr.OriginationRateID and rate.RateID=rtr.RateID

							SET
								rtr.EndDate = NOW()
							WHERE
								rate.RateID is null
								AND rtr.RateTableId = @p_RateTableId
								AND rtr.TimezonesID = rate.TimezonesID
								AND rtr.EffectiveDate = rate.EffectiveDate 				;


							CALL prc_ArchiveOldRateTableRate(@p_RateTableId,NULL,CONCAT(@p_ModifiedBy,'|RateGenerator'));


						END IF ;


						/*loop starts */

						select count(*) into @v_row_count from tmp_Rate_final_1 ;

						IF @v_row_count  > 0 THEN

										
							SET @v_v_pointer_ = 1;
							SET @v_limit = 100000;   
							SET @v_v_rowCount_ = ceil(@v_row_count/@v_limit);

							WHILE @v_v_pointer_ <= @v_v_rowCount_
							DO

								SET @v_OffSet_ = (@v_v_pointer_ * @v_limit) - @v_limit;


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
								
								AccountID int,
								RateCurrency INT,
								ConnectionFeeCurrency INT,
								MinimumDuration int,
								INDEX INDEX1 (Rate),
								INDEX INDEX2 (TimezonesID),
								INDEX INDEX3 (EffectiveDate),
								INDEX INDEX4 (RateID,EffectiveDate)
								);
								
								SET @stm_query = CONCAT("insert into tmp_Rate_final
														select * from tmp_Rate_final_1 
														LIMIT " , @v_limit , "  OFFSET " ,   @v_OffSet_ );

								PREPARE stm_query FROM @stm_query;
								EXECUTE stm_query;
								DEALLOCATE PREPARE stm_query;



								START TRANSACTION;

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

											IFNULL(rate.OriginationRateID,0),
											rate.RateID,
											@p_RateTableId,
											rate.TimezonesID,
											rate.Rate,
											rate.RateN,
											rate.EffectiveDate,
											rate.PreviousRate,
											rate.Interval1,
											rate.IntervalN,
											rate.ConnectionFee,
											@v_RATE_STATUS_AWAITING as ApprovedStatus,
											rate.AccountID,
											rate.RateCurrency,
											rate.ConnectionFeeCurrency,
											rate.MinimumDuration



										FROM tmp_Rate_final rate
											LEFT JOIN tblRateTableRateAA tbl1
												ON  tbl1.TimezonesID = rate.TimezonesID
														AND rate.RateID = tbl1.RateID
														AND tbl1.RateTableId = @p_RateTableId

											LEFT JOIN tblRateTableRateAA tbl2
												ON
													tbl2.TimezonesID = rate.TimezonesID
													AND rate.RateID = tbl2.RateID
													and tbl2.EffectiveDate = rate.EffectiveDate
													AND tbl2.RateTableId = @p_RateTableId

										WHERE  (    tbl1.RateTableRateID IS NULL
																OR
																(
																	tbl2.RateTableRateID IS NULL
																	AND  tbl1.EffectiveDate != rate.EffectiveDate

																)
										);

									

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

											IFNULL(rate.OriginationRateID,0),
											rate.RateID,
											@p_RateTableId,
											rate.TimezonesID,
											rate.Rate,
											rate.RateN,
											rate.EffectiveDate,
											rate.PreviousRate,
											rate.Interval1,
											rate.IntervalN,
											rate.ConnectionFee,
											@v_RATE_STATUS_APPROVED as ApprovedStatus,
											rate.AccountID,
											rate.RateCurrency,
											rate.ConnectionFeeCurrency,
											rate.MinimumDuration

										FROM tmp_Rate_final rate
											LEFT JOIN tblRateTableRate tbl1
												ON tbl1.TimezonesID = rate.TimezonesID
													AND tbl1.RateTableId = @p_RateTableId
													AND rate.RateID = tbl1.RateID
											LEFT JOIN tblRateTableRate tbl2
												ON tbl2.TimezonesID = rate.TimezonesID
													and tbl2.EffectiveDate = rate.EffectiveDate
													AND tbl2.RateTableId = @p_RateTableId
													AND rate.RateID = tbl2.RateID
										WHERE  (    tbl1.RateTableRateID IS NULL
																OR
																(
																	tbl2.RateTableRateID IS NULL
																	AND  tbl1.EffectiveDate != rate.EffectiveDate

																)
										);


								END IF;
								
						
								COMMIT;



								SET @v_v_pointer_ = @v_v_pointer_ + 1;


							END WHILE;

						END IF; -- 		IF @v_row_count  > 0 THEN


						IF (@v_RateApprovalProcess_ = 1 ) THEN





							INSERT INTO tmp_ALL_RateTableRate_(
													`RateTableRateAAID`,
													`RateTableRateID`,
													`OriginationRateID`,
													`RateID`,
													`RateTableId`,
													`TimezonesID`,
													`Rate`,
													`RateN`,
													`EffectiveDate`,
													`EndDate`,
													`created_at`,
													`updated_at`,
													`CreatedBy`,
													`ModifiedBy`,
													`PreviousRate`,
													`Interval1`,
													`IntervalN`,
													`MinimumDuration`,
													`ConnectionFee`,
													`RoutingCategoryID`,
													`Preference`,
													`Blocked`,
													`ApprovedStatus`,
													`ApprovedBy`,
													`ApprovedDate`,
													`RateCurrency`,
													`ConnectionFeeCurrency`,
													`VendorID`
							)
								SELECT
									`RateTableRateAAID`,
									`RateTableRateID`,
									`OriginationRateID`,
									`RateID`,
									`RateTableId`,
									`TimezonesID`,
									`Rate`,
									`RateN`,
									`EffectiveDate`,
									`EndDate`,
									`created_at`,
									`updated_at`,
									`CreatedBy`,
									`ModifiedBy`,
									`PreviousRate`,
									`Interval1`,
									`IntervalN`,
									`MinimumDuration`,
									`ConnectionFee`,
									`RoutingCategoryID`,
									`Preference`,
									`Blocked`,
									`ApprovedStatus`,
									`ApprovedBy`,
									`ApprovedDate`,
									`RateCurrency`,
									`ConnectionFeeCurrency`,
									`VendorID`
								FROM tblRateTableRateAA WHERE RateTableID=@p_RateTableId ; 


							UPDATE
								tmp_ALL_RateTableRate_ temp
							SET
								EndDate = ( SELECT EffectiveDate
														FROM tblRateTableRateAA rtr
														
														WHERE rtr.RateTableID=@p_RateTableId
																	AND rtr.RateID=temp.RateID
																	AND rtr.OriginationRateID = temp.OriginationRateID
																	AND rtr.TimezonesID=temp.TimezonesID
																	AND rtr.EffectiveDate > temp.EffectiveDate
														ORDER BY rtr.EffectiveDate ASC, rtr.TimezonesID , rtr.RateID  ASC LIMIT 1
								)
							WHERE
								temp.RateTableId = @p_RateTableId; 

							UPDATE
									tblRateTableRateAA rtr
									INNER JOIN
									tmp_ALL_RateTableRate_ temp ON
												rtr.RateTableID=temp.RateTableID
												AND rtr.RateID = temp.RateID
												AND rtr.OriginationRateID = temp.OriginationRateID
												AND rtr.TimezonesID=temp.TimezonesID
												AND rtr.EffectiveDate = temp.EffectiveDate
							SET
								rtr.EndDate=temp.EndDate,
								rtr.ApprovedStatus = @v_RATE_STATUS_AWAITING
							WHERE
								rtr.RateTableId=@p_RateTableId ; 

							CALL prc_ArchiveOldRateTableRateAA(@p_RateTableId,NULL,CONCAT(@p_ModifiedBy,'|RateGenerator'));


						ELSE



							INSERT INTO tmp_ALL_RateTableRate_ (
								
								`RateTableRateID`,
								`OriginationRateID`,
								`RateID`,
								`RateTableId`,
								`TimezonesID`,
								`Rate`,
								`RateN`,
								`EffectiveDate`,
								`EndDate`,
								`created_at`,
								`updated_at`,
								`CreatedBy`,
								`ModifiedBy`,
								`PreviousRate`,
								`Interval1`,
								`IntervalN`,
								`MinimumDuration`,
								`ConnectionFee`,
								`RoutingCategoryID`,
								`Preference`,
								`Blocked`,
								`ApprovedStatus`,
								`ApprovedBy`,
								`ApprovedDate`,
								`RateCurrency`,
								`ConnectionFeeCurrency`,
								`VendorID`


							)
							SELECT
									
									`RateTableRateID`,
									`OriginationRateID`,
									`RateID`,
									`RateTableId`,
									`TimezonesID`,
									`Rate`,
									`RateN`,
									`EffectiveDate`,
									`EndDate`,
									`created_at`,
									`updated_at`,
									`CreatedBy`,
									`ModifiedBy`,
									`PreviousRate`,
									`Interval1`,
									`IntervalN`,
									`MinimumDuration`,
									`ConnectionFee`,
									`RoutingCategoryID`,
									`Preference`,
									`Blocked`,
									`ApprovedStatus`,
									`ApprovedBy`,
									`ApprovedDate`,
									`RateCurrency`,
									`ConnectionFeeCurrency`,
									`VendorID`

								FROM tblRateTableRate WHERE RateTableID=@p_RateTableId; 


							UPDATE
								tmp_ALL_RateTableRate_ temp
							SET
								EndDate = (
										SELECT EffectiveDate 
												FROM tblRateTableRate rtr 
												WHERE rtr.RateTableID=@p_RateTableId 
												AND rtr.RateID=temp.RateID 
												AND rtr.OriginationRateID=temp.OriginationRateID 
												AND rtr.TimezonesID=temp.TimezonesID 
												AND rtr.EffectiveDate>temp.EffectiveDate 
												ORDER BY rtr.EffectiveDate ASC,rtr.RateTableRateID ASC LIMIT 1
												)
							WHERE
								temp.RateTableId = @p_RateTableId ; 

						
							UPDATE
									tblRateTableRate rtr
									INNER JOIN
									tmp_ALL_RateTableRate_ temp ON 
											rtr.RateTableRateID=temp.RateTableRateID 
											AND rtr.TimezonesID=temp.TimezonesID
							SET
								rtr.EndDate=temp.EndDate,
								rtr.ApprovedStatus = @v_RATE_STATUS_APPROVED
							WHERE
								rtr.RateTableId=@p_RateTableId ; 
							



							CALL prc_ArchiveOldRateTableRate(@p_RateTableId,NULL,CONCAT(@p_ModifiedBy,'|RateGenerator'));


						END IF;







					END IF;

		
				-- COMMIT;




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


		SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;


	END//
DELIMITER ;
