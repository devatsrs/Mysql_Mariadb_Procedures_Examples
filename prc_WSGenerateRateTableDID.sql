use speakintelligentRM;
-- CALL prc_WSGenerateRateTableDID(394,133,-1,'SI Test RG - Access - 12-07-DevTest-1-10','2019-10-01',0,'now','Sumera Khan')
DROP PROCEDURE IF EXISTS `prc_WSGenerateRateTableDID`;
DELIMITER //
CREATE PROCEDURE `prc_WSGenerateRateTableDID` (
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
			show warnings;
			ROLLBACK;
			INSERT INTO tmp_JobLog_ (Message) VALUES ('RateTable generation failed');
		END;

		DROP TEMPORARY TABLE IF EXISTS tmp_JobLog_;
		CREATE TEMPORARY TABLE tmp_JobLog_ (
			Message longtext
		);

		SET @session.collation_connection='utf8_unicode_ci';
		SET @session.character_set_client='utf8';
		SET SESSION group_concat_max_len = 1000000;

		SET global auto_increment_increment = 1;
		SET global auto_increment_offset = 1;

		SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;


		SET @p_jobId 				=		p_jobId;
		SET @p_RateGeneratorId 		=		p_RateGeneratorId;
		SET @p_RateTableId 			=		p_RateTableId;
		SET @p_rateTableName 		=		p_rateTableName;
		SET @p_EffectiveDate 		=		p_EffectiveDate;
		SET @p_delete_exiting_rate 	=		p_delete_exiting_rate;
		SET @p_EffectiveRate 		=		p_EffectiveRate;
		SET @p_ModifiedBy 			=		p_ModifiedBy;


	DROP TEMPORARY TABLE IF EXISTS tmp_Raterules_;
	CREATE TEMPORARY TABLE tmp_Raterules_  (
		rateruleid INT,
		Component VARCHAR(50) COLLATE utf8_unicode_ci,
		Origination VARCHAR(50) COLLATE utf8_unicode_ci,
		TimezonesID int,
		CountryID int,
		AccessType varchar(100),
		Prefix varchar(100),
		City varchar(100),
		Tariff varchar(100),
		`Order` INT,
		RowNo INT
	);

	DROP TEMPORARY TABLE IF EXISTS tmp_RateGeneratorCalculatedRate_;
	CREATE TEMPORARY TABLE tmp_RateGeneratorCalculatedRate_  (
		CalculatedRateID INT,
		Component VARCHAR(50),
		Origination VARCHAR(50) ,
		TimezonesID int,
		RateLessThen	DECIMAL(18, 8),
		ChangeRateTo DECIMAL(18, 8),
		`CountryID` INT(11) NULL DEFAULT NULL,
		`AccessType` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
		`Prefix` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
		`City` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
		`Tariff` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
		RowNo INT
	);

	DROP TEMPORARY TABLE IF EXISTS tmp_tblRateTableDIDRate_step1;
	CREATE TEMPORARY TABLE tmp_tblRateTableDIDRate_step1 (
			RateTableID int,
			TimezonesID  int,
			TimezoneTitle  varchar(100),
			CodeDeckId int,
			CountryID int,
			AccessType varchar(100),
			CountryPrefix varchar(100),
			City varchar(100),
			Tariff varchar(100),
			Code varchar(100),
			OriginationCode  varchar(100),
			VendorConnectionID int,
			VendorID int,
			-- VendorConnectionName varchar(200),
			EndDate datetime,
			OneOffCost DECIMAL(18, 8),
			MonthlyCost DECIMAL(18, 8),
			TrunkCostPerService DECIMAL(18, 8),
			CostPerCall DECIMAL(18, 8),
			CostPerMinute DECIMAL(18, 8),
			SurchargePerCall DECIMAL(18, 8),
			SurchargePerMinute DECIMAL(18, 8),
			OutpaymentPerCall DECIMAL(18, 8),
			OutpaymentPerMinute DECIMAL(18, 8),
			Surcharges DECIMAL(18, 8),
			Chargeback DECIMAL(18, 8),
			CollectionCostAmount DECIMAL(18, 8),
			CollectionCostPercentage DECIMAL(18, 8),
			RegistrationCostPerNumber DECIMAL(18, 8)
		);

	DROP TEMPORARY TABLE IF EXISTS tmp_tblRateTableDIDRate_step1_dup;
	CREATE TEMPORARY TABLE tmp_tblRateTableDIDRate_step1_dup (
			RateTableID int,
			TimezonesID  int,
			TimezoneTitle  varchar(100),
			CodeDeckId int,
			CountryID int,
			AccessType varchar(100),
			CountryPrefix varchar(100),
			City varchar(100),
			Tariff varchar(100),
			Code varchar(100),
			OriginationCode  varchar(100),
			VendorConnectionID int,
			VendorID int,
			-- VendorConnectionName varchar(200),
			EndDate datetime,
			OneOffCost DECIMAL(18, 8),
			MonthlyCost DECIMAL(18, 8),
			TrunkCostPerService DECIMAL(18, 8),
			CostPerCall DECIMAL(18, 8),
			CostPerMinute DECIMAL(18, 8),
			SurchargePerCall DECIMAL(18, 8),
			SurchargePerMinute DECIMAL(18, 8),
			OutpaymentPerCall DECIMAL(18, 8),
			OutpaymentPerMinute DECIMAL(18, 8),
			Surcharges DECIMAL(18, 8),
			Chargeback DECIMAL(18, 8),
			CollectionCostAmount DECIMAL(18, 8),
			CollectionCostPercentage DECIMAL(18, 8),
			RegistrationCostPerNumber DECIMAL(18, 8)
		);

	DROP TEMPORARY TABLE IF EXISTS tmp_table_without_origination;
	CREATE TEMPORARY TABLE tmp_table_without_origination (
		RateTableID int,
		TimezonesID  int,
		TimezoneTitle  varchar(100),
		CodeDeckId int,
		CountryID int,
		AccessType varchar(100),
		CountryPrefix varchar(100),
		City varchar(100),
		Tariff varchar(100),
		Code varchar(100),
		OriginationCode  varchar(100),
		VendorConnectionID int,
		VendorID int,
		-- VendorConnectionName varchar(200),
		EndDate datetime,
		OneOffCost DECIMAL(18, 8),
		MonthlyCost DECIMAL(18, 8),
		CostPerCall DECIMAL(18, 8),
		CostPerMinute DECIMAL(18, 8),
		SurchargePerCall DECIMAL(18, 8),
		SurchargePerMinute DECIMAL(18, 8),
		OutpaymentPerCall DECIMAL(18, 8),
		OutpaymentPerMinute DECIMAL(18, 8),
		Surcharges DECIMAL(18, 8),
		Chargeback DECIMAL(18, 8),
		CollectionCostAmount DECIMAL(18, 8),
		CollectionCostPercentage DECIMAL(18, 8),
		RegistrationCostPerNumber DECIMAL(18, 8),


		OneOffCostCurrency int,
		MonthlyCostCurrency int,
		CostPerCallCurrency int,
		CostPerMinuteCurrency int,
		SurchargePerCallCurrency int,
		SurchargePerMinuteCurrency int,
		OutpaymentPerCallCurrency int,
		OutpaymentPerMinuteCurrency int,
		SurchargesCurrency int,
		ChargebackCurrency int,
		CollectionCostAmountCurrency int,
		RegistrationCostPerNumberCurrency int,

		OutPayment DECIMAL(18,8),
		Surcharge DECIMAL(18,8),

		Total DECIMAL(18, 8)
	);

	DROP TEMPORARY TABLE IF EXISTS tmp_table_with_origination;
	CREATE TEMPORARY TABLE tmp_table_with_origination (
		RateTableID int,
		TimezonesID  int,
		TimezoneTitle  varchar(100),
		CodeDeckId int,
		CountryID int,
		AccessType varchar(100),
		CountryPrefix varchar(100),
		City varchar(100),
		Tariff varchar(100),
		Code varchar(100),
		OriginationCode  varchar(100),
		VendorConnectionID int,
		VendorID int,
		-- VendorConnectionName varchar(200),
		EndDate datetime,

		OneOffCost DECIMAL(18, 8),
		MonthlyCost DECIMAL(18, 8),
		CostPerCall DECIMAL(18, 8),
		CostPerMinute DECIMAL(18, 8),
		SurchargePerCall DECIMAL(18, 8),
		SurchargePerMinute DECIMAL(18, 8),
		OutpaymentPerCall DECIMAL(18, 8),
		OutpaymentPerMinute DECIMAL(18, 8),
		Surcharges DECIMAL(18, 8),
		Chargeback DECIMAL(18, 8),
		CollectionCostAmount DECIMAL(18, 8),
		CollectionCostPercentage DECIMAL(18, 8),
		RegistrationCostPerNumber DECIMAL(18, 8),


		OneOffCostCurrency int,
		MonthlyCostCurrency int,
		CostPerCallCurrency int,
		CostPerMinuteCurrency int,
		SurchargePerCallCurrency int,
		SurchargePerMinuteCurrency int,
		OutpaymentPerCallCurrency int,
		OutpaymentPerMinuteCurrency int,
		SurchargesCurrency int,
		ChargebackCurrency int,
		CollectionCostAmountCurrency int,
		RegistrationCostPerNumberCurrency int,

		OutPayment DECIMAL(18,8),
		Surcharge DECIMAL(18,8),

		Total DECIMAL(18, 8)
	);



	DROP TEMPORARY TABLE IF EXISTS tmp_tblRateTableDIDRate;
	CREATE TEMPORARY TABLE tmp_tblRateTableDIDRate (
		RateTableID int,
		TimezonesID  int,
		TimezoneTitle  varchar(100),
		CodeDeckId int,
		CountryID int,
		AccessType varchar(100),
		CountryPrefix varchar(100),
		City varchar(100),
		Tariff varchar(100),
		Code varchar(100),
		OriginationCode  varchar(100),
		VendorConnectionID int,
		VendorID int,
		-- VendorConnectionName varchar(200),
		EndDate datetime,
		OneOffCost DECIMAL(18, 8),
		MonthlyCost DECIMAL(18, 8),
		CostPerCall DECIMAL(18, 8),
		CostPerMinute DECIMAL(18, 8),
		SurchargePerCall DECIMAL(18, 8),
		SurchargePerMinute DECIMAL(18, 8),
		OutpaymentPerCall DECIMAL(18, 8),
		OutpaymentPerMinute DECIMAL(18, 8),
		Surcharges DECIMAL(18, 8),
		Chargeback DECIMAL(18, 8),
		CollectionCostAmount DECIMAL(18, 8),
		CollectionCostPercentage DECIMAL(18, 8),
		RegistrationCostPerNumber DECIMAL(18, 8),

		OneOffCostCurrency int,
		MonthlyCostCurrency int,
		CostPerCallCurrency int,
		CostPerMinuteCurrency int,
		SurchargePerCallCurrency int,
		SurchargePerMinuteCurrency int,
		OutpaymentPerCallCurrency int,
		OutpaymentPerMinuteCurrency int,
		SurchargesCurrency int,
		ChargebackCurrency int,
		CollectionCostAmountCurrency int,
		RegistrationCostPerNumberCurrency int,


		Total DECIMAL(18, 8)
	);

	DROP TEMPORARY TABLE IF EXISTS tmp_SelectedVendortblRateTableDIDRate;
	CREATE TEMPORARY TABLE tmp_SelectedVendortblRateTableDIDRate (
		RateTableID int,
		TimezonesID  int,
		TimezoneTitle  varchar(100),
		CodeDeckId int,
		CountryID int,
		AccessType varchar(100),
		CountryPrefix varchar(100),
		City varchar(100),
		Tariff varchar(100),
		Code varchar(100),
		OriginationCode  varchar(100),
		VendorConnectionID int,
		VendorID int,
		-- VendorConnectionName varchar(200),
		EndDate datetime,
		OneOffCost DECIMAL(18, 8),
		MonthlyCost DECIMAL(18, 8),
		CostPerCall DECIMAL(18, 8),
		CostPerMinute DECIMAL(18, 8),
		SurchargePerCall DECIMAL(18, 8),
		SurchargePerMinute DECIMAL(18, 8),
		OutpaymentPerCall DECIMAL(18, 8),
		OutpaymentPerMinute DECIMAL(18, 8),
		Surcharges DECIMAL(18, 8),
		Chargeback DECIMAL(18, 8),
		CollectionCostAmount DECIMAL(18, 8),
		CollectionCostPercentage DECIMAL(18, 8),
		RegistrationCostPerNumber DECIMAL(18, 8),

		OneOffCostCurrency int,
		MonthlyCostCurrency int,
		CostPerCallCurrency int,
		CostPerMinuteCurrency int,
		SurchargePerCallCurrency int,
		SurchargePerMinuteCurrency int,
		OutpaymentPerCallCurrency int,
		OutpaymentPerMinuteCurrency int,
		SurchargesCurrency int,
		ChargebackCurrency int,
		CollectionCostAmountCurrency int,
		RegistrationCostPerNumberCurrency int,


		MarginRuleApplied_OneOffCost TINYINT(1) ,
		MarginRuleApplied_MonthlyCost TINYINT(1) ,
		MarginRuleApplied_CostPerCall TINYINT(1) ,
		MarginRuleApplied_CostPerMinute TINYINT(1) ,
		MarginRuleApplied_SurchargePerCall TINYINT(1) ,
		MarginRuleApplied_SurchargePerMinute TINYINT(1) ,
		MarginRuleApplied_OutpaymentPerCall TINYINT(1) ,
		MarginRuleApplied_OutpaymentPerMinute TINYINT(1) ,
		MarginRuleApplied_Surcharges TINYINT(1) ,
		MarginRuleApplied_Chargeback TINYINT(1) ,
		MarginRuleApplied_CollectionCostAmount TINYINT(1) ,
		MarginRuleApplied_CollectionCostPercentage TINYINT(1) ,
		MarginRuleApplied_RegistrationCostPerNumber TINYINT(1) 

	);

	DROP TEMPORARY TABLE IF EXISTS tmp_SelectedVendortblRateTableDIDRate_dup;
	CREATE TEMPORARY TABLE tmp_SelectedVendortblRateTableDIDRate_dup (
			RateTableID int,
			TimezonesID  int,
			TimezoneTitle  varchar(100),
			CodeDeckId int,
			CountryID int,
			AccessType varchar(100),
			CountryPrefix varchar(100),
			City varchar(100),
			Tariff varchar(100),
			Code varchar(100),
			OriginationCode  varchar(100),
			VendorConnectionID int,
			VendorID int,
			-- VendorConnectionName varchar(200),
			EndDate datetime,
			OneOffCost DECIMAL(18, 8),
			MonthlyCost DECIMAL(18, 8),
			CostPerCall DECIMAL(18, 8),
			CostPerMinute DECIMAL(18, 8),
			SurchargePerCall DECIMAL(18, 8),
			SurchargePerMinute DECIMAL(18, 8),
			OutpaymentPerCall DECIMAL(18, 8),
			OutpaymentPerMinute DECIMAL(18, 8),
			Surcharges DECIMAL(18, 8),
			Chargeback DECIMAL(18, 8),
			CollectionCostAmount DECIMAL(18, 8),
			CollectionCostPercentage DECIMAL(18, 8),
			RegistrationCostPerNumber DECIMAL(18, 8),

			OneOffCostCurrency int,
			MonthlyCostCurrency int,
			CostPerCallCurrency int,
			CostPerMinuteCurrency int,
			SurchargePerCallCurrency int,
			SurchargePerMinuteCurrency int,
			OutpaymentPerCallCurrency int,
			OutpaymentPerMinuteCurrency int,
			SurchargesCurrency int,
			ChargebackCurrency int,
			CollectionCostAmountCurrency int,
			RegistrationCostPerNumberCurrency int,


			MarginRuleApplied_OneOffCost TINYINT(1) ,
			MarginRuleApplied_MonthlyCost TINYINT(1) ,
			MarginRuleApplied_CostPerCall TINYINT(1) ,
			MarginRuleApplied_CostPerMinute TINYINT(1) ,
			MarginRuleApplied_SurchargePerCall TINYINT(1) ,
			MarginRuleApplied_SurchargePerMinute TINYINT(1) ,
			MarginRuleApplied_OutpaymentPerCall TINYINT(1) ,
			MarginRuleApplied_OutpaymentPerMinute TINYINT(1) ,
			MarginRuleApplied_Surcharges TINYINT(1) ,
			MarginRuleApplied_Chargeback TINYINT(1) ,
			MarginRuleApplied_CollectionCostAmount TINYINT(1) ,
			MarginRuleApplied_CollectionCostPercentage TINYINT(1) ,
			MarginRuleApplied_RegistrationCostPerNumber TINYINT(1) 


		);

		DROP TEMPORARY TABLE IF EXISTS tmp_table_output_1;
		CREATE TEMPORARY TABLE tmp_table_output_1 (

			RateTableID int,
			TimezonesID  int,
			TimezoneTitle  varchar(100),
			CodeDeckId int,
			CountryID int,
			AccessType varchar(100),
			CountryPrefix varchar(100),
			City varchar(100),
			Tariff varchar(100),
			Code varchar(100),
			OriginationCode  varchar(100),
			VendorConnectionID int,
			VendorID int,
			-- VendorConnectionName varchar(200),
			EndDate datetime,
			OneOffCost DECIMAL(18, 8),
			MonthlyCost DECIMAL(18, 8),
			CostPerCall DECIMAL(18, 8),
			CostPerMinute DECIMAL(18, 8),
			SurchargePerCall DECIMAL(18, 8),
			SurchargePerMinute DECIMAL(18, 8),
			OutpaymentPerCall DECIMAL(18, 8),
			OutpaymentPerMinute DECIMAL(18, 8),
			Surcharges DECIMAL(18, 8),
			Chargeback DECIMAL(18, 8),
			CollectionCostAmount DECIMAL(18, 8),
			CollectionCostPercentage DECIMAL(18, 8),
			RegistrationCostPerNumber DECIMAL(18, 8),

			OneOffCostCurrency int,
			MonthlyCostCurrency int,
			CostPerCallCurrency int,
			CostPerMinuteCurrency int,
			SurchargePerCallCurrency int,
			SurchargePerMinuteCurrency int,
			OutpaymentPerCallCurrency int,
			OutpaymentPerMinuteCurrency int,
			SurchargesCurrency int,
			ChargebackCurrency int,
			CollectionCostAmountCurrency int,
			RegistrationCostPerNumberCurrency int,


			Total DECIMAL(18, 8)
		);


		DROP TEMPORARY TABLE IF EXISTS tmp_table_output_2;
		CREATE TEMPORARY TABLE tmp_table_output_2 (

			RateTableID int,
			TimezonesID  int,
			TimezoneTitle  varchar(100),
			CodeDeckId int,
			CountryID int,
			AccessType varchar(100),
			CountryPrefix varchar(100),
			City varchar(100),
			Tariff varchar(100),
			Code varchar(100),
			OriginationCode  varchar(100),
			VendorConnectionID int,
			VendorID int,
			-- VendorConnectionName varchar(200),
			EndDate datetime,
			OneOffCost DECIMAL(18, 8),
			MonthlyCost DECIMAL(18, 8),
			CostPerCall DECIMAL(18, 8),
			CostPerMinute DECIMAL(18, 8),
			SurchargePerCall DECIMAL(18, 8),
			SurchargePerMinute DECIMAL(18, 8),
			OutpaymentPerCall DECIMAL(18, 8),
			OutpaymentPerMinute DECIMAL(18, 8),
			Surcharges DECIMAL(18, 8),
			Chargeback DECIMAL(18, 8),
			CollectionCostAmount DECIMAL(18, 8),
			CollectionCostPercentage DECIMAL(18, 8),
			RegistrationCostPerNumber DECIMAL(18, 8),

			OneOffCostCurrency int,
			MonthlyCostCurrency int,
			CostPerCallCurrency int,
			CostPerMinuteCurrency int,
			SurchargePerCallCurrency int,
			SurchargePerMinuteCurrency int,
			OutpaymentPerCallCurrency int,
			OutpaymentPerMinuteCurrency int,
			SurchargesCurrency int,
			ChargebackCurrency int,
			CollectionCostAmountCurrency int,
			RegistrationCostPerNumberCurrency int,


			Total DECIMAL(18, 8),
			vPosition int


		);

		DROP TEMPORARY TABLE IF EXISTS tmp_timezones;
		CREATE TEMPORARY TABLE tmp_timezones (
			ID int auto_increment,
			TimezonesID int,
			primary key (ID)
		);

 

		DROP TEMPORARY TABLE IF EXISTS tmp_timezone_minutes;
		CREATE TEMPORARY TABLE tmp_timezone_minutes (
			TimezonesID int,
			VendorConnectionID int,
			AccessType varchar(200),
			CountryID int,
			City varchar(50),
			Tariff varchar(50),
			Code varchar(100),
			OriginationCode varchar(100),		-- FIX-Telecom Italia			MOB-Vodafone
			OriginationCode2 varchar(100),		-- FIX							MOB
			OriginationCode2_Rows varchar(100),	--  2 							4

			CostPerMinute DECIMAL(18,8), 
			OutpaymentPerMinute DECIMAL(18,8),
			SurchargePerMinute DECIMAL(18,8),

			OutpaymentPerCall DECIMAL(18,8), 
			Surcharges DECIMAL(18,8),
			SurchargePerCall DECIMAL(18,8),
			CollectionCostAmount DECIMAL(18,8),
			CostPerCall DECIMAL(18,8),

			minute_CostPerMinute DECIMAL(18,2), 
			minute_OutpaymentPerMinute DECIMAL(18,2),
			minute_SurchargePerMinute DECIMAL(18,2),

			calls_OutpaymentPerCall DECIMAL(18,2), 
			calls_Surcharges DECIMAL(18,2), 
			calls_SurchargePerCall DECIMAL(18,2), 
			calls_CollectionCostAmount DECIMAL(18,2), 
			calls_CostPerCall DECIMAL(18,2), 

			INDEX Index1 (TimezonesID),
			INDEX Index2 (VendorConnectionID),
			INDEX Index3 (AccessType),
			INDEX Index4 (CountryID),
			INDEX Index5 (City),
			INDEX Index6 (Tariff),
			INDEX Index7 (Code),
			INDEX Index8 (OriginationCode)


		);

		DROP TEMPORARY TABLE IF EXISTS tmp_timezone_minutes_2;
		CREATE TEMPORARY TABLE tmp_timezone_minutes_2 LIKE tmp_timezone_minutes;

		DROP TEMPORARY TABLE IF EXISTS tmp_timezone_minutes_3;
		CREATE TEMPORARY TABLE tmp_timezone_minutes_3 LIKE tmp_timezone_minutes;


		DROP TEMPORARY TABLE IF EXISTS tmp_accounts;
		CREATE TEMPORARY TABLE tmp_accounts (
			ID int auto_increment,
			TimezonesID  int,
			VendorConnectionID int,
			AccessType varchar(200),
			CountryID int,
			City varchar(50),
			Tariff varchar(50),
			Code varchar(100),
			OriginationCode varchar(100),
			OriginationCode2 varchar(100),

			_Minutes int,
			_Calls int,

			INDEX Index1 (TimezonesID),
			INDEX Index2 (VendorConnectionID),
			INDEX Index3 (AccessType),
			INDEX Index4 (CountryID),
			INDEX Index5 (City),
			INDEX Index6 (Tariff),
			INDEX Index7 (Code),
			INDEX Index8 (OriginationCode),

			Primary Key (ID )

		);

		DROP TEMPORARY TABLE IF EXISTS tmp_accounts2;
		CREATE TEMPORARY TABLE tmp_accounts2 LIKE tmp_accounts;

		DROP TEMPORARY TABLE IF EXISTS tmp_accounts2_dup;
		CREATE TEMPORARY TABLE tmp_accounts2_dup LIKE tmp_accounts;

		DROP TEMPORARY TABLE IF EXISTS tmp_NoOfServicesContracted;
		CREATE TEMPORARY TABLE tmp_NoOfServicesContracted (
			VendorID int,
			NoOfServicesContracted int
		);


		DROP TEMPORARY TABLE IF EXISTS tmp_RateGeneratorVendors_;
		CREATE TEMPORARY TABLE tmp_RateGeneratorVendors_  (
			RateGeneratorVendorsID INT AUTO_INCREMENT,
			Vendors varchar(50),
			CountryID int,
			AccessType varchar(100),
			Prefix varchar(100),
			City varchar(100),
			Tariff varchar(100),
			PRIMARY KEY (RateGeneratorVendorsID)
		);

		DROP TEMPORARY TABLE IF EXISTS tmp_SelectVendorsWithDID_;
		CREATE TEMPORARY TABLE tmp_SelectVendorsWithDID_  (
			SelectVendorsWithDIDID INT AUTO_INCREMENT,
			VendorID int,
			CountryID int,
			AccessType varchar(100),
			Code varchar(100),
			City varchar(100),
			Tariff varchar(100),
			IsSelected	int,
			PRIMARY KEY (SelectVendorsWithDIDID)

		);


		DROP TEMPORARY TABLE IF EXISTS tmp_SelectVendorsWithDID_dup;
		CREATE TEMPORARY TABLE tmp_SelectVendorsWithDID_dup  (
			SelectVendorsWithDIDID INT AUTO_INCREMENT,
			VendorID int,
			CountryID int,
			AccessType varchar(100),
			Code varchar(100),
			City varchar(100),
			Tariff varchar(100),
			IsSelected	int,
			PRIMARY KEY (SelectVendorsWithDIDID)
		);

		DROP TEMPORARY TABLE IF EXISTS tmp_SelectedVendorPerRow;
		CREATE TEMPORARY TABLE tmp_SelectedVendorPerRow (
			CountryID int,
			AccessType varchar(100),
			CountryPrefix varchar(100),
			City varchar(100),
			Tariff varchar(100),
			Code varchar(100),
			VendorConnectionID int,
			vPosition int
		);


		DROP TEMPORARY TABLE IF EXISTS tmp_RatesForMarginRule;
		CREATE TEMPORARY TABLE tmp_RatesForMarginRule (
			TimezonesID  int,
			OriginationCode  varchar(100),
			Code varchar(100),
			CountryID int,
			AccessType varchar(100),
			City varchar(100),
			Tariff varchar(100),

			OneOffCost DECIMAL(18, 8),
			MonthlyCost DECIMAL(18, 8),
			CostPerCall DECIMAL(18, 8),
			CostPerMinute DECIMAL(18, 8),
			SurchargePerCall DECIMAL(18, 8),
			SurchargePerMinute DECIMAL(18, 8),
			OutpaymentPerCall DECIMAL(18, 8),
			OutpaymentPerMinute DECIMAL(18, 8),
			Surcharges DECIMAL(18, 8),
			Chargeback DECIMAL(18, 8),
			CollectionCostAmount DECIMAL(18, 8),
			CollectionCostPercentage DECIMAL(18, 8),
			RegistrationCostPerNumber DECIMAL(18, 8)

		);	



		IF @p_rateTableName IS NOT NULL
		THEN


			SET @v_RTRowCount_ = (SELECT COUNT(*)
													 FROM tblRateTable
													 WHERE RateTableName = @p_rateTableName
																 AND CompanyId = (SELECT
																										CompanyId
																									FROM tblRateGenerator
																									WHERE RateGeneratorID = @p_RateGeneratorId));

			IF @v_RTRowCount_ > 0
			THEN
				INSERT INTO tmp_JobLog_ (Message) VALUES ('RateTable Name is already exist, Please try using another RateTable Name');
				SELECT * FROM tmp_JobLog_;
				LEAVE GenerateRateTable;
			END IF;
		END IF;



		SELECT
			rateposition,
			companyid ,
			tblRateGenerator.RateGeneratorName,
			RateGeneratorId,
			CurrencyID,

			DIDCategoryID,
			Calls,
			Minutes,
			DateFrom,
			DateTo,
			TimezonesID,
			TimezonesPercentage,
			Origination,
			OriginationPercentage,

			IFNULL(CountryID,''),
			IFNULL(AccessType,''),
			IFNULL(City,''),
			IFNULL(Tariff,''),
			IFNULL(Prefix,''),
			IFNULL(AppliedTo,''),
			IFNULL(Reseller,''),
			NoOfServicesContracted,


			IF( percentageRate = '' OR percentageRate is null	,0, percentageRate )

			INTO @v_RatePosition_, @v_CompanyId_,   @v_RateGeneratorName_,@p_RateGeneratorId, @v_CurrencyID_,

			@p_DIDCategoryID,
			@v_Calls,
			@v_Minutes,
			@p_StartDate ,@p_EndDate ,@p_Timezone, @p_TimezonePercentage, @p_Origination, @p_OriginationPercentage,


			@p_CountryID,
			@p_AccessType,
			@p_City,
			@p_Tariff,
			@p_Prefix,
			@p_AppliedTo,
			@p_Reseller,
			@p_NoOfServicesContracted,

			@v_percentageRate_
		FROM tblRateGenerator
		WHERE RateGeneratorId = @p_RateGeneratorId;


		/* ------------------------------ TEST  ------------------------------ */
		-- SET @p_Prefix 							= '0905'; -- TEST
		-- SET @p_Tariff 							= '2 per call'; -- TEST
	
		/* ------------------------------ TEST  ------------------------------ */

			/*-- call prc_GetDIDLCR_NEW(1, '67', 'Premium Rate Number', '','0.15 per minute' ,'070' ,'9' , 1, '5' ,'2019-11-28','100','300','13','80','FIX','60','2019-10-28','2019-11-28','0' ,1,50,'desc',0)
			SET @p_CountryID 						= 67;
			SET @p_AccessType 						= 'Premium Rate Number';
			SET @p_City 							= NULL;
			SET @p_Tariff 							= '0.15 per minute';
			SET @p_Prefix 							= '070';
			-- SET @p_CurrencyID 					= ;
			SET @p_DIDCategoryID 					= 1 ;
			-- SET @p_Position 						= ;
			SET @p_SelectedEffectiveDate 			= '2019-11-28';
			SET @v_Calls 							= '100';
			SET @v_Minutes 							= '300';
			SET @p_Timezone 						= '13';
			SET @p_TimezonePercentage 				= '80';
			SET @p_Origination 						= 'FIX';
			SET @p_OriginationPercentage 			= '60';
			SET @p_StartDate 						= '2019-10-28';
			SET @p_EndDate 							= '2019-11-28';
			SET @p_NoOfServicesContracted 			= 0;
			*/
			
			
			 
		/* ------------------------------ TESTING ------------------------------ */



		SET @v_RoundChargedAmount = 6;

		SELECT CurrencyId INTO @v_CompanyCurrencyID_ FROM  tblCompany WHERE CompanyID = @v_CompanyId_;

        Select Value INTO @v_DestinationCurrencyConversionRate from tblCurrencyConversion where tblCurrencyConversion.CurrencyId =  @v_CurrencyID_  and  CompanyID = @v_CompanyId_;

        Select Value INTO @v_CompanyCurrencyConversionRate from tblCurrencyConversion where tblCurrencyConversion.CurrencyId =  @v_CompanyCurrencyID_  and  CompanyID = @v_CompanyId_;


		SELECT IFNULL(Value,0) INTO @v_RateApprovalProcess_ FROM tblCompanySetting WHERE CompanyID = @v_CompanyId_ AND `Key`='RateApprovalProcess';

		SET @v_RateApprovalStatus_ = 0;

		IF @v_RateApprovalProcess_ = 1 THEN

			SET @v_RateApprovalStatus_ = 0;

		ELSE

			SET @v_RateApprovalStatus_ = 1;

		END IF;


		INSERT INTO tmp_Raterules_(
			rateruleid ,
			Component,
			Origination ,
			TimezonesID ,
			CountryID ,
			AccessType,
			Prefix ,
			City,
			Tariff,
			`Order` ,
			RowNo
		)
			SELECT
				rateruleid,
				IFNULL(Component,''),
				IFNULL(OriginationDescription,''),
				IFNULL(TimezonesID,0),
				IFNULL(CountryID,0),
				IFNULL(AccessType,''),
				IFNULL(Prefix ,''),
				IFNULL(City,''),
				IFNULL(Tariff,''),
				`Order`,
				@row_num := @row_num+1 AS RowID
			FROM tblRateRule,(SELECT @row_num := 0) x
			WHERE rategeneratorid = @p_RateGeneratorId
			ORDER BY `Order` ASC;


		INSERT INTO tmp_RateGeneratorVendors_ (
			Vendors,
			CountryID,
			AccessType,
			Prefix,
			City,
			Tariff
		)
		select
			rgv.Vendors,
			rgv.CountryID,
			rgv.AccessType,
			TRIM(LEADING '0' FROM rgv.Prefix),
			rgv.City,
			rgv.Tariff

		FROM tblRateGeneratorVendors rgv
		-- INNER JOIN tblAccount a ON (fn_IsEmpty(rgv.Vendors) OR FIND_IN_SET(a.AccountID,rgv.Vendors) != 0 ) AND a.IsVendor = 1 AND a.Status = 1
		WHERE rgv.RateGeneratorId = @p_RateGeneratorId
		ORDER BY rgv.RateGeneratorVendorsID ASC;


		INSERT INTO tmp_RateGeneratorCalculatedRate_
			(
			CalculatedRateID ,
			Component ,
			Origination ,
			TimezonesID ,
			RateLessThen,
			ChangeRateTo ,
			CountryID ,
			AccessType,
			Prefix ,
			City,
			Tariff,
			RowNo )
			SELECT

			CalculatedRateID ,
			Component ,
			IFNULL(Origination,''),
			IFNULL(TimezonesID ,0),
			RateLessThen,
			ChangeRateTo,
			IFNULL(CountryID,0),
			IFNULL(AccessType,''),
			IFNULL(Prefix ,''),
			IFNULL(City,''),
			IFNULL(Tariff,''),
			@row_num := @row_num+1 AS RowID
			FROM tblRateGeneratorCalculatedRate,(SELECT @row_num := 0) x
			WHERE RateGeneratorId = @p_RateGeneratorId
			ORDER BY CalculatedRateID ASC;


			SET @v_ApprovedStatus = 1;

			SET	@v_RateTypeID = 2;	-- //1 - Termination,  2 - DID,   3 - Package

			set @v_AppliedToCustomer = 1;
			set @v_AppliedToVendor = 2;
			set @v_AppliedToReseller = 3;





			SET @p_Calls	 							 = @v_Calls;
			SET @p_Minutes	 							 = @v_Minutes;
			SET @p_Timezone	 				 			 = @p_Timezone;
			-- SET @p_TimezonePercentage	 		 = @p_TimezonePercentage;
			-- SET @p_MobileOriginationPercentage	 = @p_OriginationPercentage ;

			SET @p_Prefix = TRIM(LEADING '0' FROM @p_Prefix);


			IF @p_NoOfServicesContracted > 0 THEN


				insert into tmp_NoOfServicesContracted ( VendorID, NoOfServicesContracted )
				select null, @p_NoOfServicesContracted;

			ELSE

				insert into tmp_NoOfServicesContracted (VendorID,NoOfServicesContracted)
				select cli.VendorID,count(cli.CLI) as NoOfServicesContracted
				from  tblCLIRateTable cli
				inner join tblCountry c on c.CountryID = cli.CountryID

				where
					cli.VendorID > 0
					AND cli.Status = 1
					AND cli.NumberStartDate <= now()
					AND cli.NumberEndDate >= current_date()


				group by cli.VendorID;



			END IF ;

			IF @p_Calls = 0 AND @p_Minutes = 0 THEN



				select count(UsageDetailID)  into @p_Calls

				from speakintelligentCDR.tblUsageDetails  d

				inner join speakintelligentCDR.tblUsageHeader h on d.UsageHeaderID = h.UsageHeaderID

				inner join speakintelligentRM.tblCountry c  on   d.CLIPrefix  like concat(c.Prefix,'%')

				where StartDate >= @p_StartDate AND StartDate <= @p_EndDate and d.is_inbound = 1

				AND ( fn_IsEmpty(@p_CountryID) OR  c.CountryID = @p_CountryID )

				AND ( fn_IsEmpty(@p_AccessType)  OR d.NoType = @p_AccessType)

				AND ( fn_IsEmpty(@p_City)  OR d.City  = @p_City)

				AND ( fn_IsEmpty(@p_Tariff) OR d.Tariff  = @p_Tariff )

				AND ( fn_IsEmpty(@p_Prefix)  OR ( d.CLIPrefix   = concat(c.Prefix,  @p_Prefix )  ) );



				insert into tmp_timezone_minutes (TimezonesID, AccessType,CountryID,Code,City,Tariff, minute_CostPerMinute,minute_OutpaymentPerMinute,minute_SurchargePerMinute)

				select TimezonesID  , d.NoType, c.CountryID, d.CLIPrefix as Code, d.City, d.Tariff, (sum(billed_duration) / 60), (sum(billed_duration) / 60), (sum(billed_duration) / 60)

				from speakintelligentCDR.tblUsageDetails  d

				inner join speakintelligentCDR.tblUsageHeader h on d.UsageHeaderID = h.UsageHeaderID

				inner join speakintelligentRM.tblCountry c  on   d.CLIPrefix  like concat(c.Prefix,'%')

				where StartDate >= @p_StartDate AND StartDate <= @p_EndDate and d.is_inbound = 1 and TimezonesID is not null

				AND ( fn_IsEmpty(@p_CountryID) OR  c.CountryID = @p_CountryID )

				AND ( fn_IsEmpty(@p_AccessType)  OR d.NoType = @p_AccessType)

				AND ( fn_IsEmpty(@p_City)  OR d.City  = @p_City)

				AND ( fn_IsEmpty(@p_Tariff) OR d.Tariff  = @p_Tariff )

				AND ( fn_IsEmpty(@p_Prefix)  OR ( d.CLIPrefix   = concat(c.Prefix,  @p_Prefix )  ) )

				group by TimezonesID  , d.NoType, c.CountryID, d.CLIPrefix, d.City, d.Tariff;


				/*insert into tmp_origination_minutes ( OriginationCode, minutes )

				select CLIPrefix  , (sum(billed_duration) / 60) as minutes

				from speakintelligentCDR.tblUsageDetails  d

				inner join speakintelligentCDR.tblUsageHeader h on d.UsageHeaderID = h.UsageHeaderID

				inner join speakintelligentRM.tblCountry c  on   d.CLIPrefix  like concat(c.Prefix,'%')

				where StartDate >= @p_StartDate AND StartDate <= @p_EndDate and d.is_inbound = 1 and CLIPrefix is not null

				AND ( fn_IsEmpty(@p_CountryID) OR  c.CountryID = @p_CountryID )

				AND ( fn_IsEmpty(@p_AccessType)  OR d.NoType = @p_AccessType)

				AND ( fn_IsEmpty(@p_City)  OR d.City  = @p_City)

				AND ( fn_IsEmpty(@p_Tariff) OR d.Tariff  = @p_Tariff )

				AND ( fn_IsEmpty(@p_Prefix)  OR ( d.CLIPrefix   = concat(c.Prefix,  @p_Prefix )  ) )

				group by CLIPrefix;*/



			ELSE




				-- SET @p_MobileOrigination				 = @p_Origination ;
				-- SET @v_PeakTimeZoneMinutes				 =  ( (@p_Minutes/ 100) * @p_TimezonePercentage ) 	;
				-- SET @v_MinutesFromMobileOrigination  =  ( (@p_Minutes/ 100) * @p_MobileOriginationPercentage ) 	;




/*
					Minutes = 50
					%		= 20
					Timezone = Peak (10)

					VendorID  TimezoneID 	CostPerMinute OutpaymentPerMinute
						1		Peak			NULL				0.5
						1		Off-Peak		0.5					NULL
						1		Default			NULL				0.5


					VendorID  TimezoneID 	minutes_CostPerMinute minutes_OutpaymentPerMinute
						1		Peak			0							0.5 * 10
						1		Off-Peak		0.5 * 50					NULL
						1		Default			NULL						0.5 * 40

					*/

					
					insert into tmp_timezone_minutes ( VendorConnectionID, TimezonesID, AccessType,CountryID,Code,OriginationCode, City,Tariff, CostPerMinute, OutpaymentPerMinute, SurchargePerMinute, OutpaymentPerCall, Surcharges, SurchargePerCall, CollectionCostAmount, CostPerCall )
					
					select VendorConnectionID, TimezonesID, AccessType, CountryID, Code, OriginationCode,City, Tariff , CostPerMinute, OutpaymentPerMinute, SurchargePerMinute, OutpaymentPerCall, Surcharges, SurchargePerCall, CollectionCostAmount, CostPerCall
					
					FROM (

						Select DISTINCT vc.VendorConnectionID, drtr.TimezonesID, drtr.AccessType, c.CountryID,r.Code,IFNULL(r2.Code,'') as OriginationCode, drtr.City, drtr.Tariff , sum(drtr.CostPerMinute) as CostPerMinute, sum(drtr.OutpaymentPerMinute) as OutpaymentPerMinute, sum(drtr.SurchargePerMinute) as SurchargePerMinute, sum(OutpaymentPerCall) as OutpaymentPerCall, sum(Surcharges) as Surcharges, sum(SurchargePerCall) as SurchargePerCall, sum(CollectionCostAmount) as CollectionCostAmount, sum(CostPerCall) as CostPerCall
					
						FROM tblRateTableDIDRate  drtr
						inner join tblRateTable  rt on rt.RateTableId = drtr.RateTableId
						inner join tblVendorConnection vc on vc.RateTableID = rt.RateTableId and ((vc.DIDCategoryID IS NOT NULL AND rt.DIDCategoryID IS NOT NULL) AND vc.DIDCategoryID = rt.DIDCategoryID) and vc.CompanyID = rt.CompanyId  and vc.Active=1
						inner join tblAccount a on vc.AccountId = a.AccountID and rt.CompanyId = a.CompanyId and a.IsVendor = 1 and a.Status = 1
						left join tblVendorTrunkCost vtc on a.AccountID = vtc.AccountID
						inner join tblRate r on drtr.RateID = r.RateID and r.CompanyID = vc.CompanyID
						left join tblRate r2 on drtr.OriginationRateID = r2.RateID and r.CompanyID = r2.CompanyID
						inner join tblCountry c on c.CountryID = r.CountryID

						AND ( fn_IsEmpty(@p_CountryID)   OR  c.CountryID = @p_CountryID )
						AND ( fn_IsEmpty(@p_City)   OR drtr.City = @p_City )
						AND ( fn_IsEmpty(@p_Tariff)   OR drtr.Tariff  = @p_Tariff )
						AND ( fn_IsEmpty(@p_Prefix)   OR (r.Code  = concat(c.Prefix ,@p_Prefix) ) )
						AND ( fn_IsEmpty(@p_AccessType)   OR drtr.AccessType = @p_AccessType )

						inner join tblTimezones t on t.TimezonesID =  drtr.TimezonesID
						where

							rt.CompanyId =  @v_CompanyId_

							and vc.DIDCategoryID = @p_DIDCategoryID

							and drtr.ApprovedStatus = @v_ApprovedStatus

							and rt.Type = @v_RateTypeID

							and rt.AppliedTo = @v_AppliedToVendor

							and (
								(@p_EffectiveRate = 'now' AND EffectiveDate <= NOW())
								OR
								(@p_EffectiveRate = 'future' AND EffectiveDate > NOW()  )
								OR
								(	 @p_EffectiveRate = 'effective' AND EffectiveDate <= @p_EffectiveDate
										AND ( drtr.EndDate IS NULL OR (drtr.EndDate > DATE(@p_EffectiveDate)) )
								)
							)
							group by VendorConnectionID, TimezonesID, AccessType, CountryID, drtr.RateID,drtr.OriginationRateID, City, Tariff

					)	tmp ;





					-- SET @p_TimezonePercentage	 		 = @p_TimezonePercentage;
					-- SET @p_MobileOrigination				 = @p_Origination ;
					-- SET @p_MobileOriginationPercentage	 	 = @p_OriginationPercentage ;


					-- insert into tmp_timezones (TimezonesID) select TimezonesID from tblTimezones;

					-- SET @v_rowCount_ = ( SELECT COUNT(*) FROM tmp_timezones );

					--  account loop

					/*
							Split calls and mins based on Origination and then further split by time of day. 
							If origination BLANK then ignore that from origination split 
							IF Time of day Default then ignore that from Time of day split.
							Ignore origination from Split if NOT like FIX,MOB (Sumera)

							If Default Time of day then full mins/cals
							if blank origination then full mins/calls
					*/


					UPDATE tmp_timezone_minutes
					SET OriginationCode2 = ( CASE WHEN OriginationCode LIKE '%MOB%' THEN 
													'MOB'
												WHEN OriginationCode LIKE '%FIX%' THEN
													'FIX'
												ELSE	
													OriginationCode
											END );

					DELETE FROM tmp_timezone_minutes WHERE OriginationCode != ''  AND OriginationCode NOT LIKE '%MOB%' AND OriginationCode NOT LIKE '%FIX%';

					INSERT INTO tmp_accounts ( TimezonesID,VendorConnectionID,AccessType,CountryID,Code,OriginationCode,OriginationCode2,City,Tariff )  
							   SELECT DISTINCT TimezonesID,VendorConnectionID,AccessType,CountryID,Code,OriginationCode,OriginationCode2,City,Tariff 
							   FROM tmp_timezone_minutes;

					SET @v_default_TimezonesID = ( SELECT TimezonesID from tblTimezones where Title = 'Default' );

/*
+-------------+---------------+------------------+-----------+------+--------+---------------+-------+-----------------+--------------------+--------------------------+-------------+-------------+---------------+------------------+--------------------+-------------------+---------------------+------------+------------+----------------------+--------------------------+---------------------------+
| TimezonesID | TimezoneTitle | AccessType       | CountryID | City | Tariff | EffectiveDate | Code  | OriginationCode | VendorConnectionID | VendorConnectionName     | MonthlyCost | CostPerCall | CostPerMinute | SurchargePerCall | SurchargePerMinute | OutpaymentPerCall | OutpaymentPerMinute | Surcharges | Chargeback | CollectionCostAmount | CollectionCostPercentage | RegistrationCostPerNumber |
+-------------+---------------+------------------+-----------+------+--------+---------------+-------+-----------------+--------------------+--------------------------+-------------+-------------+---------------+------------------+--------------------+-------------------+---------------------+------------+------------+----------------------+--------------------------+---------------------------+
| 1           | Default       | Freephone Number | 475       |      |        | 2019-11-02    | 31800 |                 | 6                  | Ziggo - Freephone Number | 0.00000000  | 0.00800000  |               |                  | 0.01250000         |                   |                     |            |            |                      |                          |                           |
+-------------+---------------+------------------+-----------+------+--------+---------------+-------+-----------------+--------------------+--------------------------+-------------+-------------+---------------+------------------+--------------------+-------------------+---------------------+------------+------------+----------------------+--------------------------+---------------------------+
| 10          | Off Peak      | Freephone Number | 475       |      |        | 2019-11-02    | 31800 |                 | 6                  | Ziggo - Freephone Number |             |             | 0.00800000    |                  |                    |                   |                     |            |            |                      |                          |                           |
+-------------+---------------+------------------+-----------+------+--------+---------------+-------+-----------------+--------------------+--------------------------+-------------+-------------+---------------+------------------+--------------------+-------------------+---------------------+------------+------------+----------------------+--------------------------+---------------------------+
| 13          | Peak          | Freephone Number | 475       |      |        | 2019-11-02    | 31800 |                 | 6                  | Ziggo - Freephone Number |             |             | 0.01075000    |                  |                    |                   |                     |            |            |                      |                          |                           |
+-------------+---------------+------------------+-----------+------+--------+---------------+-------+-----------------+--------------------+--------------------------+-------------+-------------+---------------+------------------+--------------------+-------------------+---------------------+------------+------------+----------------------+--------------------------+---------------------------+
| 1           | Default       | Freephone Number | 475       |      |        | 2019-11-06    | 31800 | FIX             | 14                 | DIDWW - Freephone        | 13.54157263 |             | 0.04513858    |                  |                    |                   |                     |            |            |                      |                          |                           |
+-------------+---------------+------------------+-----------+------+--------+---------------+-------+-----------------+--------------------+--------------------------+-------------+-------------+---------------+------------------+--------------------+-------------------+---------------------+------------+------------+----------------------+--------------------------+---------------------------+

*/
					 -- select * from  tmp_timezone_minutes ; -- TEST

					-- first Origination Logic split minutes
					-- Same Logic for Origination (like  timezone percentage , timezone minute split.)
					IF @p_OriginationPercentage > 0 THEN
					
						/*
						Issue: Onno:Ziggo has difference when applying FIX 60% instead of MOB 40%. That should give the same result.
						
						Ziggo has Origination MOB with SurchargePerMin but not FIX so value is different.
						
						MOB 40% of 300 = 120 (MOB Entry Exists)
						SurchargePerMin
						
						FIX Entry NOT Exists = 300
						SurchargePerMin						
						*/

						
						SET @v_selectedOriginationMinutes = ( (@p_Minutes/ 100) * @p_OriginationPercentage );
						SET @v_selectedOriginationCalls = ( (@p_Calls/ 100) * @p_OriginationPercentage );

						SET @v_remainingOriginationMinutes = @p_Minutes - ( (@p_Minutes/ 100) * @p_OriginationPercentage );
						SET @v_remainingOriginationCalls = @p_Calls - ( (@p_Calls/ 100) * @p_OriginationPercentage );
						
						-- store percentage calls and minutes to apply in timezone and origination stage.
						UPDATE tmp_accounts 
						SET 
						_Minutes = @v_selectedOriginationMinutes,
						_Calls = @v_selectedOriginationCalls
						WHERE OriginationCode LIKE CONCAT('%',@p_Origination,'%');
						
						-- FOR OPERATOR ISSUE (MOB-VODAFONE). (ADDED LATER FOR OPERATOR ISSUE)
						UPDATE tmp_accounts 
						SET
						_Minutes = @v_remainingOriginationMinutes,
						 _Calls =  @v_remainingOriginationCalls
						WHERE OriginationCode2 not LIKE CONCAT('%',@p_Origination,'%');

						-- select * from  tmp_accounts ; -- TEST

						--	If origination BLANK then ignore that from origination split 
						-- Minutes
						-- add percentage minute on selected timezones
						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET minute_CostPerMinute = _Minutes
						WHERE  tzm.OriginationCode LIKE CONCAT('%',@p_Origination,'%') AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.TimezonesID = a.TimezonesID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff AND tzm.CostPerMinute IS NOT NULL;

						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET minute_OutpaymentPerMinute =  _Minutes
						WHERE  tzm.OriginationCode LIKE CONCAT('%',@p_Origination,'%') AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.TimezonesID = a.TimezonesID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff AND tzm.OutpaymentPerMinute IS NOT NULL;

						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET minute_SurchargePerMinute = _Minutes
						WHERE  tzm.OriginationCode LIKE CONCAT('%',@p_Origination,'%') AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.TimezonesID = a.TimezonesID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff AND tzm.SurchargePerMinute IS NOT NULL;
			
  						-- Calls
						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET calls_OutpaymentPerCall = _Calls
						WHERE  tzm.OriginationCode LIKE CONCAT('%',@p_Origination,'%') AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.TimezonesID = a.TimezonesID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff 
						AND tzm.OutpaymentPerCall IS NOT NULL;

						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET calls_Surcharges =  _Calls
						WHERE  tzm.OriginationCode LIKE CONCAT('%',@p_Origination,'%') AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.TimezonesID = a.TimezonesID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff 
						AND tzm.Surcharges IS NOT NULL;

						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET calls_SurchargePerCall = _Calls
						WHERE  tzm.OriginationCode LIKE CONCAT('%',@p_Origination,'%') AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.TimezonesID = a.TimezonesID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff 
						AND tzm.SurchargePerCall IS NOT NULL;

						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET calls_CollectionCostAmount =  _Calls
						WHERE  tzm.OriginationCode LIKE CONCAT('%',@p_Origination,'%') AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.TimezonesID = a.TimezonesID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff 
						AND tzm.CollectionCostAmount IS NOT NULL;

						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET calls_CostPerCall = _Calls
						WHERE  tzm.OriginationCode LIKE CONCAT('%',@p_Origination,'%') AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.TimezonesID = a.TimezonesID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff 
						AND tzm.CostPerCall IS NOT NULL;
						
						-- ----------------------------------------------------

 
						 -- select * from  tmp_timezone_minutes ; -- TEST
					
					
						truncate table tmp_timezone_minutes_2;
						truncate table tmp_timezone_minutes_3;

						INSERT INTO tmp_timezone_minutes_2 SELECT * FROM tmp_timezone_minutes where OriginationCode != ''; -- AND TimezonesID != @v_default_TimezonesID;
						INSERT INTO tmp_timezone_minutes_3 SELECT * FROM tmp_timezone_minutes where OriginationCode != ''; -- AND TimezonesID != @v_default_TimezonesID;

						-- Minutes -  Selected Origination Minutes / Total Count of Records not Selected
						-- add remaining minute on remaining 
						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET minute_CostPerMinute = ( IFNULL((select  (@p_Minutes - tzmd2.minute_CostPerMinute) 
																			from tmp_timezone_minutes_3 tzmd2 WHERE tzmd2.OriginationCode LIKE CONCAT('%',@p_Origination,'%') AND tzmd2.VendorConnectionID = a.VendorConnectionID /*AND tzmd2.TimezonesID = a.TimezonesID*/ AND tzmd2.AccessType = a.AccessType AND tzmd2.CountryID = a.CountryID /*AND tzmd2.OriginationCode = a.OriginationCode*/ AND tzmd2.Code = a.Code AND tzmd2.City = a.City 
																			AND tzmd2.Tariff = a.Tariff AND tzmd2.CostPerMinute IS NOT NULL LIMIT 1 ),_Minutes) )   
														/ (select IF(count(*) = 0,1,count(*))  from tmp_timezone_minutes_2 tzmd WHERE /*tzmd.OriginationCode NOT LIKE CONCAT('%',@p_Origination,'%') AND*/ tzmd.VendorConnectionID = a.VendorConnectionID AND tzmd.TimezonesID = a.TimezonesID AND tzmd.AccessType = a.AccessType AND tzmd.CountryID = a.CountryID AND tzmd.OriginationCode = a.OriginationCode AND tzmd.Code = a.Code AND tzmd.City = a.City 
														AND tzmd.Tariff = a.Tariff AND tzmd.CostPerMinute IS NOT NULL) 
						WHERE  (tzm.OriginationCode NOT LIKE CONCAT('%',@p_Origination,'%')) AND tzm.TimezonesID = a.TimezonesID AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City 
													AND tzm.Tariff = a.Tariff AND tzm.CostPerMinute IS NOT NULL;

						
						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET minute_OutpaymentPerMinute = ( IFNULL((select (@p_Minutes - tzmd2.minute_OutpaymentPerMinute) 
																			from tmp_timezone_minutes_3 tzmd2 WHERE tzmd2.OriginationCode LIKE CONCAT('%',@p_Origination,'%') AND tzmd2.VendorConnectionID = a.VendorConnectionID /*AND tzmd2.TimezonesID = a.TimezonesID*/ AND tzmd2.AccessType = a.AccessType AND tzmd2.CountryID = a.CountryID /*AND tzmd2.OriginationCode = a.OriginationCode*/ AND tzmd2.Code = a.Code AND tzmd2.City = a.City 
																			AND tzmd2.Tariff = a.Tariff AND tzmd2.OutpaymentPerMinute IS NOT NULL LIMIT 1 ),_Minutes) )   
														/ (  select IF(count(*) = 0,1,count(*))  from tmp_timezone_minutes_2 tzmd WHERE /*tzmd.OriginationCode NOT LIKE CONCAT('%',@p_Origination,'%') AND*/ tzmd.VendorConnectionID = a.VendorConnectionID AND tzmd.TimezonesID = a.TimezonesID AND tzmd.AccessType = a.AccessType AND tzmd.CountryID = a.CountryID AND tzmd.OriginationCode = a.OriginationCode AND tzmd.Code = a.Code AND tzmd.City = a.City 
														AND tzmd.Tariff = a.Tariff AND tzmd.OutpaymentPerMinute IS NOT NULL ) 
						WHERE  (tzm.OriginationCode NOT LIKE CONCAT('%',@p_Origination,'%')) AND tzm.TimezonesID = a.TimezonesID AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City 
													AND tzm.Tariff = a.Tariff AND tzm.OutpaymentPerMinute IS NOT NULL;
						
						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET minute_SurchargePerMinute = ( IFNULL((select (@p_Minutes - tzmd2.minute_SurchargePerMinute) 
																			from tmp_timezone_minutes_3 tzmd2 WHERE (tzmd2.OriginationCode LIKE CONCAT('%',@p_Origination,'%')) AND tzmd2.VendorConnectionID = a.VendorConnectionID /*AND tzmd2.TimezonesID = a.TimezonesID*/ AND tzmd2.AccessType = a.AccessType AND tzmd2.CountryID = a.CountryID /*AND tzmd2.OriginationCode = a.OriginationCode*/ AND tzmd2.Code = a.Code AND tzmd2.City = a.City 
																			AND tzmd2.Tariff = a.Tariff AND tzmd2.SurchargePerMinute IS NOT NULL LIMIT 1 ),_Minutes) )   
														/ (  select IF(count(*) = 0,1,count(*))  from tmp_timezone_minutes_2 tzmd WHERE /*tzmd.OriginationCode NOT LIKE CONCAT('%',@p_Origination,'%') AND*/ tzmd.VendorConnectionID = a.VendorConnectionID AND tzmd.TimezonesID = a.TimezonesID AND tzmd.AccessType = a.AccessType AND tzmd.CountryID = a.CountryID AND tzmd.OriginationCode = a.OriginationCode AND tzmd.Code = a.Code AND tzmd.City = a.City 
														AND tzmd.Tariff = a.Tariff AND tzmd.SurchargePerMinute IS NOT NULL) 
						WHERE  (tzm.OriginationCode NOT LIKE CONCAT('%',@p_Origination,'%')) AND tzm.TimezonesID = a.TimezonesID AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City 
													AND tzm.Tariff = a.Tariff AND tzm.SurchargePerMinute IS NOT NULL;
						

						-- add remaining calls on remaining Origination
						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET calls_OutpaymentPerCall = ( IFNULL((select (@p_Calls - tzmd2.calls_OutpaymentPerCall) 
																			from tmp_timezone_minutes_3 tzmd2 WHERE tzmd2.OriginationCode LIKE CONCAT('%',@p_Origination,'%') AND tzmd2.VendorConnectionID = a.VendorConnectionID /*AND tzmd2.TimezonesID = a.TimezonesID*/ AND tzmd2.AccessType = a.AccessType AND tzmd2.CountryID = a.CountryID /*AND tzmd2.OriginationCode = a.OriginationCode*/ AND tzmd2.Code = a.Code AND tzmd2.City = a.City 
																			AND tzmd2.Tariff = a.Tariff AND tzmd2.OutpaymentPerCall IS NOT NULL LIMIT 1 ),_Calls) )   
														/ (  select IF(count(*) = 0,1,count(*))  from tmp_timezone_minutes_2 tzmd WHERE /*tzmd.OriginationCode NOT LIKE CONCAT('%',@p_Origination,'%') AND*/ tzmd.VendorConnectionID = a.VendorConnectionID AND tzmd.TimezonesID = a.TimezonesID AND tzmd.AccessType = a.AccessType AND tzmd.CountryID = a.CountryID AND tzmd.OriginationCode = a.OriginationCode AND tzmd.Code = a.Code AND tzmd.City = a.City 
														AND tzmd.Tariff = a.Tariff AND tzmd.OutpaymentPerCall IS NOT NULL) 
						WHERE  (tzm.OriginationCode NOT LIKE CONCAT('%',@p_Origination,'%')) AND tzm.TimezonesID = a.TimezonesID AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City 
													AND tzm.Tariff = a.Tariff AND tzm.OutpaymentPerCall IS NOT NULL;



						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET calls_Surcharges = ( IFNULL((select (@p_Calls - tzmd2.calls_Surcharges) 
																			from tmp_timezone_minutes_3 tzmd2 WHERE tzmd2.OriginationCode LIKE CONCAT('%',@p_Origination,'%') AND tzmd2.VendorConnectionID = a.VendorConnectionID /*AND tzmd2.TimezonesID = a.TimezonesID*/ AND tzmd2.AccessType = a.AccessType AND tzmd2.CountryID = a.CountryID /*AND tzmd2.OriginationCode = a.OriginationCode*/ AND tzmd2.Code = a.Code AND tzmd2.City = a.City 
																			AND tzmd2.Tariff = a.Tariff AND tzmd2.Surcharges IS NOT NULL LIMIT 1 ),_Calls) )   
														/ (  select IF(count(*) = 0,1,count(*))  from tmp_timezone_minutes_2 tzmd WHERE /*tzmd.OriginationCode NOT LIKE CONCAT('%',@p_Origination,'%') AND*/ tzmd.VendorConnectionID = a.VendorConnectionID AND tzmd.TimezonesID = a.TimezonesID AND tzmd.AccessType = a.AccessType AND tzmd.CountryID = a.CountryID AND tzmd.OriginationCode = a.OriginationCode AND tzmd.Code = a.Code AND tzmd.City = a.City 
														AND tzmd.Tariff = a.Tariff AND tzmd.Surcharges IS NOT NULL) 
						WHERE  (tzm.OriginationCode NOT LIKE CONCAT('%',@p_Origination,'%')) AND tzm.TimezonesID = a.TimezonesID AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City 
													AND tzm.Tariff = a.Tariff AND tzm.Surcharges IS NOT NULL;

						
						
						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET calls_SurchargePerCall = ( IFNULL((select (@p_Calls - tzmd2.calls_SurchargePerCall) 
																			from tmp_timezone_minutes_3 tzmd2 WHERE (tzmd2.OriginationCode LIKE CONCAT('%',@p_Origination,'%')) AND tzmd2.VendorConnectionID = a.VendorConnectionID /*AND tzmd2.TimezonesID = a.TimezonesID*/ AND tzmd2.AccessType = a.AccessType AND tzmd2.CountryID = a.CountryID /*AND tzmd2.OriginationCode = a.OriginationCode*/ AND tzmd2.Code = a.Code AND tzmd2.City = a.City 
																			AND tzmd2.Tariff = a.Tariff AND tzmd2.SurchargePerCall IS NOT NULL LIMIT 1 ),_Calls) )   
														/ (  select IF(count(*) = 0,1,count(*))  from tmp_timezone_minutes_2 tzmd WHERE /*tzmd.OriginationCode NOT LIKE CONCAT('%',@p_Origination,'%') AND*/ tzmd.VendorConnectionID = a.VendorConnectionID AND tzmd.TimezonesID = a.TimezonesID AND tzmd.AccessType = a.AccessType AND tzmd.CountryID = a.CountryID AND tzmd.OriginationCode = a.OriginationCode AND tzmd.Code = a.Code AND tzmd.City = a.City 
														AND tzmd.Tariff = a.Tariff AND tzmd.SurchargePerCall IS NOT NULL) 
						WHERE  (tzm.OriginationCode NOT LIKE CONCAT('%',@p_Origination,'%')) AND tzm.TimezonesID = a.TimezonesID AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City 
													AND tzm.Tariff = a.Tariff AND tzm.SurchargePerCall IS NOT NULL;
						 						
						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET calls_CollectionCostAmount = ( IFNULL((select (@p_Calls - tzmd2.calls_CollectionCostAmount) 
																			from tmp_timezone_minutes_3 tzmd2 WHERE tzmd2.OriginationCode LIKE CONCAT('%',@p_Origination,'%') AND tzmd2.VendorConnectionID = a.VendorConnectionID /*AND tzmd2.TimezonesID = a.TimezonesID*/ AND tzmd2.AccessType = a.AccessType AND tzmd2.CountryID = a.CountryID /*AND tzmd2.OriginationCode = a.OriginationCode*/ AND tzmd2.Code = a.Code AND tzmd2.City = a.City 
																			AND tzmd2.Tariff = a.Tariff AND tzmd2.CollectionCostAmount IS NOT NULL LIMIT 1 ),_Calls) )   
														/ (  select IF(count(*) = 0,1,count(*))  from tmp_timezone_minutes_2 tzmd WHERE /*tzmd.OriginationCode NOT LIKE CONCAT('%',@p_Origination,'%') AND*/ tzmd.VendorConnectionID = a.VendorConnectionID AND tzmd.TimezonesID = a.TimezonesID AND tzmd.AccessType = a.AccessType AND tzmd.CountryID = a.CountryID AND tzmd.OriginationCode = a.OriginationCode AND tzmd.Code = a.Code AND tzmd.City = a.City 
														AND tzmd.Tariff = a.Tariff AND tzmd.CollectionCostAmount IS NOT NULL) 
						WHERE  (tzm.OriginationCode NOT LIKE CONCAT('%',@p_Origination,'%')) AND tzm.TimezonesID = a.TimezonesID AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City 
													AND tzm.Tariff = a.Tariff AND tzm.CollectionCostAmount IS NOT NULL;
						
						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET calls_CostPerCall = ( IFNULL((select (@p_Calls - tzmd2.calls_CostPerCall) 
																			from tmp_timezone_minutes_3 tzmd2 WHERE (tzmd2.OriginationCode LIKE CONCAT('%',@p_Origination,'%')) AND tzmd2.VendorConnectionID = a.VendorConnectionID /*AND tzmd2.TimezonesID = a.TimezonesID*/ AND tzmd2.AccessType = a.AccessType AND tzmd2.CountryID = a.CountryID /*AND tzmd2.OriginationCode = a.OriginationCode*/ AND tzmd2.Code = a.Code AND tzmd2.City = a.City 
																			AND tzmd2.Tariff = a.Tariff AND tzmd2.CostPerCall IS NOT NULL LIMIT 1 ),_Calls) )   
														/ (  select IF(count(*) = 0,1,count(*))  from tmp_timezone_minutes_2 tzmd WHERE /*tzmd.OriginationCode NOT LIKE CONCAT('%',@p_Origination,'%') AND*/ tzmd.VendorConnectionID = a.VendorConnectionID AND tzmd.TimezonesID = a.TimezonesID AND tzmd.AccessType = a.AccessType AND tzmd.CountryID = a.CountryID AND tzmd.OriginationCode = a.OriginationCode AND tzmd.Code = a.Code AND tzmd.City = a.City 
														AND tzmd.Tariff = a.Tariff AND tzmd.CostPerCall IS NOT NULL) 
						WHERE  (tzm.OriginationCode NOT LIKE CONCAT('%',@p_Origination,'%')) AND tzm.TimezonesID = a.TimezonesID AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City 
													AND tzm.Tariff = a.Tariff AND tzm.CostPerCall IS NOT NULL;


				/*calls_OutpaymentPerCall DECIMAL(18,2), 
				calls_Surcharges DECIMAL(18,2), 
				calls_SurchargePerCall DECIMAL(18,2), 
				calls_CollectionCostAmount DECIMAL(18,2), 
				calls_CostPerCall DECIMAL(18,2), 
				*/
						


						/* Origination Change
 						-- split minutes and calls when same timezones with same but multiple Origination with operators

							+---------------------+---------+--------------------+-----------+------+-----------------+-------------+------------+-------------+-------------+---------------+------------------+--------------------+-------------------+---------------------+------------+------------+----------------------+--------------------------+---------------------------+---------------+--+--+--+
							| AccessType          | Country | Origination        | Prefix    | City | Tariff          | Time of Day | OneOffCost | MonthlyCost | CostPerCall | CostPerMinute | SurchargePerCall | SurchargePerMinute | OutpaymentPerCall | OutpaymentPerMinute | Surcharges | Chargeback | CollectionCostAmount | CollectionCostPercentage | RegistrationCostPerNumber | EffectiveDate |  |  |  |
							+---------------------+---------+--------------------+-----------+------+-----------------+-------------+------------+-------------+-------------+---------------+------------------+--------------------+-------------------+---------------------+------------+------------+----------------------+--------------------------+---------------------------+---------------+--+--+--+
							| Premium Rate Number | ITALY   | FIX-Telecom Italia | 398998408 |      | 1.22 per minute | Default     |            |             |             |               |                  |                    |                   | € 0.84              |            | 10         |                      |                          |                           | 2019-11-22    |  |  |  |
							+---------------------+---------+--------------------+-----------+------+-----------------+-------------+------------+-------------+-------------+---------------+------------------+--------------------+-------------------+---------------------+------------+------------+----------------------+--------------------------+---------------------------+---------------+--+--+--+
							| Premium Rate Number | ITALY   | FIX                | 398998408 |      | 1.22 per minute | Default     |            |             |             |               |                  |                    |                   | € 0.76              |            | 10         |                      |                          |                           | 2019-11-22    |  |  |  |
							+---------------------+---------+--------------------+-----------+------+-----------------+-------------+------------+-------------+-------------+---------------+------------------+--------------------+-------------------+---------------------+------------+------------+----------------------+--------------------------+---------------------------+---------------+--+--+--+
							| Premium Rate Number | ITALY   | MOB-TIM            | 398998408 |      | 1.22 per minute | Default     |            |             |             |               |                  |                    | € 0.21            | € 0.62              |            | 10         |                      |                          |                           | 2019-11-22    |  |  |  |
							+---------------------+---------+--------------------+-----------+------+-----------------+-------------+------------+-------------+-------------+---------------+------------------+--------------------+-------------------+---------------------+------------+------------+----------------------+--------------------------+---------------------------+---------------+--+--+--+
							| Premium Rate Number | ITALY   | MOB-Vodafone       | 398998408 |      | 1.22 per minute | Default     |            |             |             |               |                  |                    | € 0.16            | € 0.42              |            | 10         |                      |                          |                           | 2019-11-22    |  |  |  |
							+---------------------+---------+--------------------+-----------+------+-----------------+-------------+------------+-------------+-------------+---------------+------------------+--------------------+-------------------+---------------------+------------+------------+----------------------+--------------------------+---------------------------+---------------+--+--+--+
							| Premium Rate Number | ITALY   | MOB-Wind           | 398998408 |      | 1.22 per minute | Default     |            |             |             |               |                  |                    |                   | € 0.56              |            | 10         |                      |                          |                           | 2019-11-22    |  |  |  |
							+---------------------+---------+--------------------+-----------+------+-----------------+-------------+------------+-------------+-------------+---------------+------------------+--------------------+-------------------+---------------------+------------+------------+----------------------+--------------------------+---------------------------+---------------+--+--+--+
							| Premium Rate Number | ITALY   | MOB-H3G            | 398998408 |      | 1.22 per minute | Default     |            |             |             |               |                  |                    | € 0.21            | € 0.42              |            | 10         |                      |                          |                           | 2019-11-22    |  |  |  |
							+---------------------+---------+--------------------+-----------+------+-----------------+-------------+------------+-------------+-------------+---------------+------------------+--------------------+-------------------+---------------------+------------+------------+----------------------+--------------------------+---------------------------+---------------+--+--+--+

						*/


						update tmp_timezone_minutes tzm
						inner join (
								SELECT TimezonesID,VendorConnectionID,AccessType,CountryID,Code,OriginationCode,City,Tariff,
												CASE WHEN OriginationCode LIKE '%MOB%' THEN 
														'MOB'
													WHEN OriginationCode LIKE '%FIX%' THEN
														'FIX'
													ELSE	
														OriginationCode
												END as OriginationCode2,
									 count(*) as _TotalRows 

									FROM  tmp_accounts
									WHERE  OriginationCode != '' 
									GROUP By TimezonesID,VendorConnectionID,AccessType,CountryID,Code,OriginationCode2,City,Tariff
									HAVING count(*)  > 1
						) a	
						on  tzm.VendorConnectionID = a.VendorConnectionID AND tzm.TimezonesID = a.TimezonesID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode2 = a.OriginationCode2 AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff
						SET OriginationCode2_Rows = _TotalRows;

						-- LOGIC (Onno/Sumera) : when origination2 and timezones are same dont split minutes / calls by filled components ie. (count(*) where  CostPerMinute IS NOT NULL ) 
						-- Instead use all OriginationCode2_Rows count without checking components value is given or not.
						-- Minutes
 						UPDATE  tmp_timezone_minutes
						SET minute_CostPerMinute = minute_CostPerMinute/OriginationCode2_Rows
						WHERE CostPerMinute IS NOT NULL and OriginationCode2_Rows > 1;

						UPDATE  tmp_timezone_minutes 
						SET minute_OutpaymentPerMinute =  minute_OutpaymentPerMinute/OriginationCode2_Rows
						WHERE OutpaymentPerMinute IS NOT NULL and OriginationCode2_Rows > 1;

						UPDATE  tmp_timezone_minutes
						SET minute_SurchargePerMinute = minute_SurchargePerMinute/OriginationCode2_Rows
						WHERE SurchargePerMinute IS NOT NULL and OriginationCode2_Rows > 1;
			
						-- Calls
						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET calls_OutpaymentPerCall = _Calls/OriginationCode2_Rows
						WHERE  tzm.OriginationCode2 not LIKE CONCAT('%',@p_Origination,'%') AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.TimezonesID = a.TimezonesID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode2 = a.OriginationCode2 AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff 
						AND tzm.OutpaymentPerCall IS NOT NULL and OriginationCode2_Rows > 1;

						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET calls_Surcharges = _Calls/OriginationCode2_Rows
						WHERE  tzm.OriginationCode2 not LIKE CONCAT('%',@p_Origination,'%') AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.TimezonesID = a.TimezonesID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode2 = a.OriginationCode2 AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff 
						AND tzm.Surcharges IS NOT NULL and OriginationCode2_Rows > 1;


						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET calls_SurchargePerCall = _Calls/OriginationCode2_Rows
						WHERE  tzm.OriginationCode2 not LIKE CONCAT('%',@p_Origination,'%') AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.TimezonesID = a.TimezonesID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode2 = a.OriginationCode2 AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff 
						AND tzm.SurchargePerCall IS NOT NULL and OriginationCode2_Rows > 1;


						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET calls_CollectionCostAmount = _Calls/OriginationCode2_Rows
						WHERE  tzm.OriginationCode2 not LIKE CONCAT('%',@p_Origination,'%') AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.TimezonesID = a.TimezonesID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode2 = a.OriginationCode2 AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff 
						AND tzm.CollectionCostAmount IS NOT NULL and OriginationCode2_Rows > 1;


						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET calls_CostPerCall = _Calls/OriginationCode2_Rows
						WHERE  tzm.OriginationCode2 not LIKE CONCAT('%',@p_Origination,'%') AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.TimezonesID = a.TimezonesID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode2 = a.OriginationCode2 AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff 
						AND tzm.CostPerCall IS NOT NULL and OriginationCode2_Rows > 1;
						-- Operator change over


					ELSE 


						truncate table tmp_timezone_minutes_2;

 						INSERT INTO tmp_timezone_minutes_2 SELECT * FROM tmp_timezone_minutes where OriginationCode != '';
 

						-- minutes	
						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET minute_CostPerMinute =  @p_Minutes /  (select IF(count(DISTINCT tzmd.OriginationCode)=0,1,count(DISTINCT tzmd.OriginationCode)) from tmp_timezone_minutes_2 tzmd WHERE tzmd.VendorConnectionID = tzm.VendorConnectionID AND tzmd.TimezonesID = tzm.TimezonesID AND tzmd.AccessType = tzm.AccessType AND tzmd.CountryID = tzm.CountryID AND tzmd.OriginationCode = tzm.OriginationCode AND tzmd.Code = tzm.Code AND tzmd.City = tzm.City AND tzmd.Tariff = tzm.Tariff AND tzmd.CostPerMinute IS NOT NULL )
												 
						WHERE   tzm.VendorConnectionID = a.VendorConnectionID AND tzm.TimezonesID = a.TimezonesID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff AND tzm.CostPerMinute IS NOT NULL;

						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET minute_OutpaymentPerMinute = @p_Minutes /  (select IF(count(DISTINCT tzmd.OriginationCode)=0,1,count(DISTINCT tzmd.OriginationCode)) from tmp_timezone_minutes_2 tzmd WHERE tzmd.VendorConnectionID = tzm.VendorConnectionID AND tzmd.TimezonesID = tzm.TimezonesID AND tzmd.AccessType = tzm.AccessType AND tzmd.CountryID = tzm.CountryID AND tzmd.OriginationCode = tzm.OriginationCode AND tzmd.Code = tzm.Code AND tzmd.City = tzm.City AND tzmd.Tariff = tzm.Tariff AND tzmd.OutpaymentPerMinute IS NOT NULL)
												
						WHERE   tzm.VendorConnectionID = a.VendorConnectionID AND tzm.TimezonesID = a.TimezonesID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff AND tzm.OutpaymentPerMinute IS NOT NULL;

						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET minute_SurchargePerMinute = @p_Minutes /  (select IF(count(DISTINCT tzmd.OriginationCode)=0,1,count(DISTINCT tzmd.OriginationCode)) from tmp_timezone_minutes_2 tzmd WHERE tzmd.VendorConnectionID = a.VendorConnectionID AND tzmd.TimezonesID = tzm.TimezonesID AND tzmd.AccessType = a.AccessType AND tzmd.CountryID = a.CountryID AND tzmd.OriginationCode = tzm.OriginationCode AND tzmd.Code = a.Code AND tzmd.City = a.City AND tzmd.Tariff = a.Tariff AND tzmd.SurchargePerMinute IS NOT NULL)
												
						WHERE   tzm.VendorConnectionID = a.VendorConnectionID AND tzm.TimezonesID = a.TimezonesID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff AND tzm.SurchargePerMinute IS NOT NULL;

				/*calls_OutpaymentPerCall DECIMAL(18,2), 
				calls_Surcharges DECIMAL(18,2), 
				calls_SurchargePerCall DECIMAL(18,2), 
				calls_CollectionCostAmount DECIMAL(18,2), 
				calls_CostPerCall DECIMAL(18,2), 
				*/

						-- calls
						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET calls_OutpaymentPerCall =  @p_Calls /  (select IF(count(DISTINCT tzmd.OriginationCode)=0,1,count(DISTINCT tzmd.OriginationCode)) from tmp_timezone_minutes_2 tzmd WHERE tzmd.VendorConnectionID = tzm.VendorConnectionID AND tzmd.TimezonesID = tzm.TimezonesID AND tzmd.AccessType = tzm.AccessType AND tzmd.CountryID = tzm.CountryID AND tzmd.OriginationCode = tzm.OriginationCode AND tzmd.Code = tzm.Code AND tzmd.City = tzm.City AND tzmd.Tariff = tzm.Tariff 
						AND tzmd.OutpaymentPerCall IS NOT NULL )
												 
						WHERE   tzm.VendorConnectionID = a.VendorConnectionID AND tzm.TimezonesID = a.TimezonesID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff 
						AND tzm.OutpaymentPerCall IS NOT NULL;

						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET calls_Surcharges = @p_Calls /  (select IF(count(DISTINCT tzmd.OriginationCode)=0,1,count(DISTINCT tzmd.OriginationCode)) from tmp_timezone_minutes_2 tzmd WHERE tzmd.VendorConnectionID = tzm.VendorConnectionID AND tzmd.TimezonesID = tzm.TimezonesID AND tzmd.AccessType = tzm.AccessType AND tzmd.CountryID = tzm.CountryID AND tzmd.OriginationCode = tzm.OriginationCode AND tzmd.Code = tzm.Code AND tzmd.City = tzm.City AND tzmd.Tariff = tzm.Tariff 
						AND tzmd.Surcharges IS NOT NULL)
												
						WHERE   tzm.VendorConnectionID = a.VendorConnectionID AND tzm.TimezonesID = a.TimezonesID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff 
						AND tzm.Surcharges IS NOT NULL;

						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET calls_SurchargePerCall = @p_Calls /  (select IF(count(DISTINCT tzmd.OriginationCode)=0,1,count(DISTINCT tzmd.OriginationCode)) from tmp_timezone_minutes_2 tzmd WHERE tzmd.VendorConnectionID = a.VendorConnectionID AND tzmd.TimezonesID = tzm.TimezonesID AND tzmd.AccessType = a.AccessType AND tzmd.CountryID = a.CountryID AND tzmd.OriginationCode = tzm.OriginationCode AND tzmd.Code = a.Code AND tzmd.City = a.City AND tzmd.Tariff = a.Tariff 
						AND tzmd.SurchargePerCall IS NOT NULL)
												
						WHERE   tzm.VendorConnectionID = a.VendorConnectionID AND tzm.TimezonesID = a.TimezonesID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff 
						AND tzm.SurchargePerCall IS NOT NULL;

						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET calls_CollectionCostAmount = @p_Calls /  (select IF(count(DISTINCT tzmd.OriginationCode)=0,1,count(DISTINCT tzmd.OriginationCode)) from tmp_timezone_minutes_2 tzmd WHERE tzmd.VendorConnectionID = tzm.VendorConnectionID AND tzmd.TimezonesID = tzm.TimezonesID AND tzmd.AccessType = tzm.AccessType AND tzmd.CountryID = tzm.CountryID AND tzmd.OriginationCode = tzm.OriginationCode AND tzmd.Code = tzm.Code AND tzmd.City = tzm.City AND tzmd.Tariff = tzm.Tariff 
						AND tzmd.CollectionCostAmount IS NOT NULL)
												
						WHERE   tzm.VendorConnectionID = a.VendorConnectionID AND tzm.TimezonesID = a.TimezonesID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff 
						AND tzm.CollectionCostAmount IS NOT NULL;

						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET calls_CostPerCall = @p_Calls /  (select IF(count(DISTINCT tzmd.OriginationCode)=0,1,count(DISTINCT tzmd.OriginationCode)) from tmp_timezone_minutes_2 tzmd WHERE tzmd.VendorConnectionID = a.VendorConnectionID AND tzmd.TimezonesID = tzm.TimezonesID AND tzmd.AccessType = a.AccessType AND tzmd.CountryID = a.CountryID AND tzmd.OriginationCode = tzm.OriginationCode AND tzmd.Code = a.Code AND tzmd.City = a.City AND tzmd.Tariff = a.Tariff 
						AND tzmd.CostPerCall IS NOT NULL)
												
						WHERE   tzm.VendorConnectionID = a.VendorConnectionID AND tzm.TimezonesID = a.TimezonesID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff 
						AND tzm.CostPerCall IS NOT NULL;

					END IF;



					--	if blank origination then full mins/calls
					-- minutes
					UPDATE  tmp_timezone_minutes SET minute_CostPerMinute = @p_Minutes WHERE OriginationCode = '' AND CostPerMinute IS NOT NULL;
					UPDATE  tmp_timezone_minutes SET minute_OutpaymentPerMinute = @p_Minutes WHERE OriginationCode = '' AND OutpaymentPerMinute IS NOT NULL;
					UPDATE  tmp_timezone_minutes SET minute_SurchargePerMinute = @p_Minutes WHERE OriginationCode = '' AND SurchargePerMinute IS NOT NULL;
					-- calls
				/*calls_OutpaymentPerCall DECIMAL(18,2), 
				calls_Surcharges DECIMAL(18,2), 
				calls_SurchargePerCall DECIMAL(18,2), 
				calls_CollectionCostAmount DECIMAL(18,2), 
				calls_CostPerCall DECIMAL(18,2), 
				*/

					UPDATE  tmp_timezone_minutes SET calls_OutpaymentPerCall = @p_Calls WHERE OriginationCode = '' AND OutpaymentPerCall IS NOT NULL;
					UPDATE  tmp_timezone_minutes SET calls_Surcharges = @p_Calls WHERE OriginationCode = '' AND Surcharges IS NOT NULL;
					UPDATE  tmp_timezone_minutes SET calls_SurchargePerCall = @p_Calls WHERE OriginationCode = '' AND SurchargePerCall IS NOT NULL;
					UPDATE  tmp_timezone_minutes SET calls_CollectionCostAmount = @p_Calls WHERE OriginationCode = '' AND CollectionCostAmount IS NOT NULL;
					UPDATE  tmp_timezone_minutes SET calls_CostPerCall = @p_Calls WHERE OriginationCode = '' AND CostPerCall IS NOT NULL;

					 -- select * from  tmp_timezone_minutes ; -- TEST



/*
+-------------+---------------+------------------+-----------+------+--------+---------------+-------+-----------------+--------------------+--------------------------+-------------+-------------+---------------+------------------+--------------------+-------------------+---------------------+------------+------------+----------------------+--------------------------+---------------------------+
| TimezonesID | TimezoneTitle | AccessType       | CountryID | City | Tariff | EffectiveDate | Code  | OriginationCode | VendorConnectionID | VendorConnectionName     | MonthlyCost | CostPerCall | CostPerMinute | SurchargePerCall | SurchargePerMinute | OutpaymentPerCall | OutpaymentPerMinute | Surcharges | Chargeback | CollectionCostAmount | CollectionCostPercentage | RegistrationCostPerNumber |
+-------------+---------------+------------------+-----------+------+--------+---------------+-------+-----------------+--------------------+--------------------------+-------------+-------------+---------------+------------------+--------------------+-------------------+---------------------+------------+------------+----------------------+--------------------------+---------------------------+
| 1           | Default       | Freephone Number | 475       |      |        | 2019-11-02    | 31800 | FIX             | 6                  | Ziggo - Freephone Number | 0.00000000  | 0.00800000  |               |                  | 0.01250000         |                   |                     |            |            |                      |                          |                           |
+-------------+---------------+------------------+-----------+------+--------+---------------+-------+-----------------+--------------------+--------------------------+-------------+-------------+---------------+------------------+--------------------+-------------------+---------------------+------------+------------+----------------------+--------------------------+---------------------------+
| 10          | Off Peak      | Freephone Number | 475       |      |        | 2019-11-02    | 31800 | MOB             | 6                  | Ziggo - Freephone Number |             |             | 0.00800000    |                  |                    |                   |                     |            |            |                      |                          |                           |
+-------------+---------------+------------------+-----------+------+--------+---------------+-------+-----------------+--------------------+--------------------------+-------------+-------------+---------------+------------------+--------------------+-------------------+---------------------+------------+------------+----------------------+--------------------------+---------------------------+
| 13          | Peak          | Freephone Number | 475       |      |        | 2019-11-02    | 31800 | MOB             | 6                  | Ziggo - Freephone Number |             |             | 0.01075000    |                  |                    |                   |                     |            |            |                      |                          |                           |
+-------------+---------------+------------------+-----------+------+--------+---------------+-------+-----------------+--------------------+--------------------------+-------------+-------------+---------------+------------------+--------------------+-------------------+---------------------+------------+------------+----------------------+--------------------------+---------------------------+
| 1           | Default       | Freephone Number | 475       |      |        | 2019-11-06    | 31800 | FIX             | 14                 | DIDWW - Freephone        | 13.54157263 |             | 0.04513858    |                  |                    |                   |                     |            |            |                      |                          |                           |
+-------------+---------------+------------------+-----------+------+--------+---------------+-------+-----------------+--------------------+--------------------------+-------------+-------------+---------------+------------------+--------------------+-------------------+---------------------+------------+------------+----------------------+--------------------------+---------------------------+

*/

					

					-- If Default Time of day then full mins/cals
					-- **** no need to run query as default will by applied to all timezones and following queries will discard Default Timezone. ****


					-- Timezone Logic after Origination Logic
					-- Logic for timezone percentage , timezone minute split.
					IF @p_TimezonePercentage > 0 THEN
					


						-- Minutes
						-- add percentage minute on selected timezones
						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						-- SET minute_CostPerMinute = ( (@p_Minutes/ 100) * @p_TimezonePercentage )
						SET minute_CostPerMinute = ( (minute_CostPerMinute/ 100) * @p_TimezonePercentage )
												
						WHERE  tzm.TimezonesID = @p_Timezone AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff AND tzm.CostPerMinute IS NOT NULL;

						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						-- SET minute_OutpaymentPerMinute =  ( (@p_Minutes/ 100) * @p_TimezonePercentage )
						SET minute_OutpaymentPerMinute =  ( (minute_OutpaymentPerMinute/ 100) * @p_TimezonePercentage )
												
						WHERE  tzm.TimezonesID = @p_Timezone AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff AND tzm.OutpaymentPerMinute IS NOT NULL;

						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						-- SET minute_SurchargePerMinute = ( (@p_Minutes/ 100) * @p_TimezonePercentage )
						SET minute_SurchargePerMinute = ( (minute_SurchargePerMinute/ 100) * @p_TimezonePercentage )
												
						WHERE  tzm.TimezonesID = @p_Timezone AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff AND tzm.SurchargePerMinute IS NOT NULL;

				/*calls_OutpaymentPerCall DECIMAL(18,2), 
				calls_Surcharges DECIMAL(18,2), 
				calls_SurchargePerCall DECIMAL(18,2), 
				calls_CollectionCostAmount DECIMAL(18,2), 
				calls_CostPerCall DECIMAL(18,2), 
				*/

						-- Calls
						-- add percentage calls on selected timezones
						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						-- SET minute_CostPerMinute = ( (@p_Minutes/ 100) * @p_TimezonePercentage )
						SET calls_OutpaymentPerCall = ( (calls_OutpaymentPerCall/ 100) * @p_TimezonePercentage )
						WHERE  tzm.TimezonesID = @p_Timezone AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff 
						AND tzm.OutpaymentPerCall IS NOT NULL;

						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						-- SET minute_OutpaymentPerMinute =  ( (@p_Minutes/ 100) * @p_TimezonePercentage )
						SET calls_Surcharges =  ( (calls_Surcharges/ 100) * @p_TimezonePercentage )
						WHERE  tzm.TimezonesID = @p_Timezone AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff 
						AND tzm.Surcharges IS NOT NULL;

						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						-- SET minute_SurchargePerMinute = ( (@p_Minutes/ 100) * @p_TimezonePercentage )
						SET calls_SurchargePerCall = ( (calls_SurchargePerCall/ 100) * @p_TimezonePercentage )
						WHERE  tzm.TimezonesID = @p_Timezone AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff 
						AND tzm.SurchargePerCall IS NOT NULL;

						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						-- SET minute_OutpaymentPerMinute =  ( (@p_Minutes/ 100) * @p_TimezonePercentage )
						SET calls_CollectionCostAmount =  ( (calls_CollectionCostAmount/ 100) * @p_TimezonePercentage )
						WHERE  tzm.TimezonesID = @p_Timezone AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff 
						AND tzm.CollectionCostAmount IS NOT NULL;

						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						-- SET minute_SurchargePerMinute = ( (@p_Minutes/ 100) * @p_TimezonePercentage )
						SET calls_CostPerCall = ( (calls_CostPerCall/ 100) * @p_TimezonePercentage )
						WHERE  tzm.TimezonesID = @p_Timezone AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff 
						AND tzm.CostPerCall IS NOT NULL;
						
					
						 -- select * from  tmp_timezone_minutes ; -- TEST

						truncate table tmp_timezone_minutes_2;
						truncate table tmp_timezone_minutes_3;


						INSERT INTO tmp_timezone_minutes_2 SELECT * FROM tmp_timezone_minutes where TimezonesID != @v_default_TimezonesID;
						INSERT INTO tmp_timezone_minutes_3 SELECT * FROM tmp_timezone_minutes where TimezonesID != @v_default_TimezonesID;


						-- minutes
						-- add remaining minute on remaining timezones
						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET minute_CostPerMinute = ( minute_CostPerMinute /*@p_Minutes*/ - IFNULL((select tzmd2.minute_CostPerMinute 
																			from tmp_timezone_minutes_3 tzmd2 WHERE tzmd2.TimezonesID = @p_Timezone AND tzmd2.VendorConnectionID = a.VendorConnectionID AND tzmd2.AccessType = a.AccessType AND tzmd2.CountryID = a.CountryID AND tzmd2.OriginationCode = a.OriginationCode AND tzmd2.Code = a.Code AND tzmd2.City = a.City 
																			AND tzmd2.Tariff = a.Tariff AND tzmd2.CostPerMinute IS NOT NULL LIMIT 1 ),0) )   
														/ (  select IF(count(*) = 0,1,count(*))  from tmp_timezone_minutes_2 tzmd WHERE tzmd.TimezonesID != @p_Timezone AND tzmd.VendorConnectionID = a.VendorConnectionID AND tzmd.AccessType = a.AccessType AND tzmd.CountryID = a.CountryID AND tzmd.OriginationCode = a.OriginationCode AND tzmd.Code = a.Code AND tzmd.City = a.City 
														AND tzmd.Tariff = a.Tariff AND tzmd.CostPerMinute IS NOT NULL) 
						WHERE  (tzm.TimezonesID != @v_default_TimezonesID AND tzm.TimezonesID != @p_Timezone) AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND  tzm.Code = a.Code AND tzm.City = a.City 
													AND tzm.Tariff = a.Tariff AND tzm.CostPerMinute IS NOT NULL;

						
						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET minute_OutpaymentPerMinute = ( minute_OutpaymentPerMinute /*@p_Minutes*/ - IFNULL((select tzmd2.minute_OutpaymentPerMinute 
																			from tmp_timezone_minutes_3 tzmd2 WHERE tzmd2.TimezonesID = @p_Timezone AND tzmd2.VendorConnectionID = a.VendorConnectionID AND tzmd2.AccessType = a.AccessType AND tzmd2.CountryID = a.CountryID AND tzmd2.OriginationCode = a.OriginationCode AND tzmd2.Code = a.Code AND tzmd2.City = a.City 
																			AND tzmd2.Tariff = a.Tariff AND tzmd2.OutpaymentPerMinute IS NOT NULL LIMIT 1 ),0) )   
														/ (  select IF(count(*) = 0,1,count(*))  from tmp_timezone_minutes_2 tzmd WHERE tzmd.TimezonesID != @p_Timezone AND tzmd.VendorConnectionID = a.VendorConnectionID AND tzmd.AccessType = a.AccessType AND tzmd.CountryID = a.CountryID AND tzmd.OriginationCode = a.OriginationCode AND tzmd.Code = a.Code AND tzmd.City = a.City 
														AND tzmd.Tariff = a.Tariff AND tzmd.OutpaymentPerMinute IS NOT NULL) 
						WHERE  (tzm.TimezonesID != @v_default_TimezonesID AND tzm.TimezonesID != @p_Timezone) AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City 
													AND tzm.Tariff = a.Tariff AND tzm.OutpaymentPerMinute IS NOT NULL;
						
						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET minute_SurchargePerMinute = ( minute_SurchargePerMinute /*@p_Minutes*/ - IFNULL((select tzmd2.minute_SurchargePerMinute 
																			from tmp_timezone_minutes_3 tzmd2 WHERE (tzmd2.TimezonesID = @p_Timezone) AND tzmd2.VendorConnectionID = a.VendorConnectionID AND tzmd2.AccessType = a.AccessType AND tzmd2.CountryID = a.CountryID AND tzmd2.OriginationCode = a.OriginationCode AND tzmd2.Code = a.Code AND tzmd2.City = a.City 
																			AND tzmd2.Tariff = a.Tariff AND tzmd2.SurchargePerMinute IS NOT NULL LIMIT 1 ),0) )   
														/ (  select IF(count(*) = 0,1,count(*))  from tmp_timezone_minutes_2 tzmd WHERE tzmd.TimezonesID != @p_Timezone AND tzmd.VendorConnectionID = a.VendorConnectionID AND tzmd.AccessType = a.AccessType AND tzmd.CountryID = a.CountryID AND tzmd.OriginationCode = a.OriginationCode AND tzmd.Code = a.Code AND tzmd.City = a.City 
														AND tzmd.Tariff = a.Tariff AND tzmd.SurchargePerMinute IS NOT NULL) 
						WHERE  (tzm.TimezonesID != @v_default_TimezonesID AND tzm.TimezonesID != @p_Timezone) AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City 
													AND tzm.Tariff = a.Tariff AND tzm.SurchargePerMinute IS NOT NULL;
						

						/*calls_OutpaymentPerCall DECIMAL(18,2), 
						calls_Surcharges DECIMAL(18,2), 
						calls_SurchargePerCall DECIMAL(18,2), 
						calls_CollectionCostAmount DECIMAL(18,2), 
						calls_CostPerCall DECIMAL(18,2), 
						*/
						-- calls
						-- add remaining calls on remaining timezones
						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET calls_OutpaymentPerCall = ( calls_OutpaymentPerCall /*@p_Minutes*/ - IFNULL((select tzmd2.calls_OutpaymentPerCall 
																			from tmp_timezone_minutes_3 tzmd2 WHERE tzmd2.TimezonesID = @p_Timezone AND tzmd2.VendorConnectionID = a.VendorConnectionID AND tzmd2.AccessType = a.AccessType AND tzmd2.CountryID = a.CountryID AND tzmd2.OriginationCode = a.OriginationCode AND tzmd2.Code = a.Code AND tzmd2.City = a.City 
																			AND tzmd2.Tariff = a.Tariff AND tzmd2.OutpaymentPerCall IS NOT NULL LIMIT 1 ),0) )   
														/ (  select IF(count(*) = 0,1,count(*))  from tmp_timezone_minutes_2 tzmd WHERE tzmd.TimezonesID != @p_Timezone AND tzmd.VendorConnectionID = a.VendorConnectionID AND tzmd.AccessType = a.AccessType AND tzmd.CountryID = a.CountryID AND tzmd.OriginationCode = a.OriginationCode AND tzmd.Code = a.Code AND tzmd.City = a.City 
														AND tzmd.Tariff = a.Tariff AND tzmd.OutpaymentPerCall IS NOT NULL) 
						WHERE  (tzm.TimezonesID != @v_default_TimezonesID AND tzm.TimezonesID != @p_Timezone) AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND  tzm.Code = a.Code AND tzm.City = a.City 
													AND tzm.Tariff = a.Tariff AND tzm.OutpaymentPerCall IS NOT NULL;

						
						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET calls_Surcharges = ( calls_Surcharges /*@p_Minutes*/ - IFNULL((select tzmd2.calls_Surcharges 
																			from tmp_timezone_minutes_3 tzmd2 WHERE tzmd2.TimezonesID = @p_Timezone AND tzmd2.VendorConnectionID = a.VendorConnectionID AND tzmd2.AccessType = a.AccessType AND tzmd2.CountryID = a.CountryID AND tzmd2.OriginationCode = a.OriginationCode AND tzmd2.Code = a.Code AND tzmd2.City = a.City 
																			AND tzmd2.Tariff = a.Tariff AND tzmd2.Surcharges IS NOT NULL LIMIT 1 ),0) )   
														/ (  select IF(count(*) = 0,1,count(*))  from tmp_timezone_minutes_2 tzmd WHERE tzmd.TimezonesID != @p_Timezone AND tzmd.VendorConnectionID = a.VendorConnectionID AND tzmd.AccessType = a.AccessType AND tzmd.CountryID = a.CountryID AND tzmd.OriginationCode = a.OriginationCode AND tzmd.Code = a.Code AND tzmd.City = a.City 
														AND tzmd.Tariff = a.Tariff AND tzmd.Surcharges IS NOT NULL) 
						WHERE  (tzm.TimezonesID != @v_default_TimezonesID AND tzm.TimezonesID != @p_Timezone) AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City 
													AND tzm.Tariff = a.Tariff AND tzm.Surcharges IS NOT NULL;
						
						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET calls_SurchargePerCall = ( calls_SurchargePerCall /*@p_Minutes*/ - IFNULL((select tzmd2.calls_SurchargePerCall 
																			from tmp_timezone_minutes_3 tzmd2 WHERE (tzmd2.TimezonesID = @p_Timezone) AND tzmd2.VendorConnectionID = a.VendorConnectionID AND tzmd2.AccessType = a.AccessType AND tzmd2.CountryID = a.CountryID AND tzmd2.OriginationCode = a.OriginationCode AND tzmd2.Code = a.Code AND tzmd2.City = a.City 
																			AND tzmd2.Tariff = a.Tariff AND tzmd2.SurchargePerCall IS NOT NULL LIMIT 1 ),0) )   
														/ (  select IF(count(*) = 0,1,count(*))  from tmp_timezone_minutes_2 tzmd WHERE tzmd.TimezonesID != @p_Timezone AND tzmd.VendorConnectionID = a.VendorConnectionID AND tzmd.AccessType = a.AccessType AND tzmd.CountryID = a.CountryID AND tzmd.OriginationCode = a.OriginationCode AND tzmd.Code = a.Code AND tzmd.City = a.City 
														AND tzmd.Tariff = a.Tariff AND tzmd.SurchargePerCall IS NOT NULL) 
						WHERE  (tzm.TimezonesID != @v_default_TimezonesID AND tzm.TimezonesID != @p_Timezone) AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City 
													AND tzm.Tariff = a.Tariff AND tzm.SurchargePerCall IS NOT NULL;

						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET calls_CollectionCostAmount = ( calls_CollectionCostAmount /*@p_Minutes*/ - IFNULL((select tzmd2.calls_CollectionCostAmount 
																			from tmp_timezone_minutes_3 tzmd2 WHERE tzmd2.TimezonesID = @p_Timezone AND tzmd2.VendorConnectionID = a.VendorConnectionID AND tzmd2.AccessType = a.AccessType AND tzmd2.CountryID = a.CountryID AND tzmd2.OriginationCode = a.OriginationCode AND tzmd2.Code = a.Code AND tzmd2.City = a.City 
																			AND tzmd2.Tariff = a.Tariff AND tzmd2.CollectionCostAmount IS NOT NULL LIMIT 1 ),0) )   
														/ (  select IF(count(*) = 0,1,count(*))  from tmp_timezone_minutes_2 tzmd WHERE tzmd.TimezonesID != @p_Timezone AND tzmd.VendorConnectionID = a.VendorConnectionID AND tzmd.AccessType = a.AccessType AND tzmd.CountryID = a.CountryID AND tzmd.OriginationCode = a.OriginationCode AND tzmd.Code = a.Code AND tzmd.City = a.City 
														AND tzmd.Tariff = a.Tariff AND tzmd.CollectionCostAmount IS NOT NULL) 
						WHERE  (tzm.TimezonesID != @v_default_TimezonesID AND tzm.TimezonesID != @p_Timezone) AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City 
													AND tzm.Tariff = a.Tariff AND tzm.CollectionCostAmount IS NOT NULL;
						
						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET calls_CostPerCall = ( calls_CostPerCall /*@p_Minutes*/ - IFNULL((select tzmd2.calls_CostPerCall 
																			from tmp_timezone_minutes_3 tzmd2 WHERE (tzmd2.TimezonesID = @p_Timezone) AND tzmd2.VendorConnectionID = a.VendorConnectionID AND tzmd2.AccessType = a.AccessType AND tzmd2.CountryID = a.CountryID AND tzmd2.OriginationCode = a.OriginationCode AND tzmd2.Code = a.Code AND tzmd2.City = a.City 
																			AND tzmd2.Tariff = a.Tariff AND tzmd2.CostPerCall IS NOT NULL LIMIT 1 ),0) )   
														/ (  select IF(count(*) = 0,1,count(*))  from tmp_timezone_minutes_2 tzmd WHERE tzmd.TimezonesID != @p_Timezone AND tzmd.VendorConnectionID = a.VendorConnectionID AND tzmd.AccessType = a.AccessType AND tzmd.CountryID = a.CountryID AND tzmd.OriginationCode = a.OriginationCode AND tzmd.Code = a.Code AND tzmd.City = a.City 
														AND tzmd.Tariff = a.Tariff AND tzmd.CostPerCall IS NOT NULL) 
						WHERE  (tzm.TimezonesID != @v_default_TimezonesID AND tzm.TimezonesID != @p_Timezone) AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City 
													AND tzm.Tariff = a.Tariff AND tzm.CostPerCall IS NOT NULL;



							

					ELSE 


						truncate table tmp_timezone_minutes_2;

						INSERT INTO tmp_timezone_minutes_2 SELECT * FROM tmp_timezone_minutes where TimezonesID != @v_default_TimezonesID;

						-- Minutes						
						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET minute_CostPerMinute =  minute_CostPerMinute /*@p_Minutes*/ /  (select IF(count(DISTINCT tzmd.TimezonesID)=0,1,count(DISTINCT tzmd.TimezonesID)) from tmp_timezone_minutes_2 tzmd WHERE  tzmd.VendorConnectionID = tzm.VendorConnectionID AND tzmd.AccessType = tzm.AccessType AND tzmd.CountryID = tzm.CountryID AND tzmd.OriginationCode = tzm.OriginationCode AND tzmd.Code = tzm.Code AND tzmd.City = tzm.City AND tzmd.Tariff = tzm.Tariff AND tzmd.CostPerMinute IS NOT NULL )
											 
						WHERE (tzm.TimezonesID != @v_default_TimezonesID ) AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff AND tzm.CostPerMinute IS NOT NULL;

						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET minute_OutpaymentPerMinute = minute_OutpaymentPerMinute /*@p_Minutes*/ /  (select IF(count(DISTINCT tzmd.TimezonesID)=0,1,count(DISTINCT tzmd.TimezonesID)) from tmp_timezone_minutes_2 tzmd WHERE  tzmd.VendorConnectionID = tzm.VendorConnectionID AND tzmd.AccessType = tzm.AccessType AND tzmd.CountryID = tzm.CountryID AND tzmd.OriginationCode = tzm.OriginationCode AND tzmd.Code = tzm.Code AND tzmd.City = tzm.City AND tzmd.Tariff = tzm.Tariff AND tzmd.OutpaymentPerMinute IS NOT NULL)
												
						WHERE  (tzm.TimezonesID != @v_default_TimezonesID ) AND  tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff AND tzm.OutpaymentPerMinute IS NOT NULL;

						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET minute_SurchargePerMinute = minute_SurchargePerMinute /*@p_Minutes*/ /  (select IF(count(DISTINCT tzmd.TimezonesID)=0,1,count(DISTINCT tzmd.TimezonesID)) from tmp_timezone_minutes_2 tzmd WHERE  tzmd.VendorConnectionID = a.VendorConnectionID AND tzmd.AccessType = a.AccessType AND tzmd.CountryID = a.CountryID AND tzmd.OriginationCode = tzm.OriginationCode AND tzmd.Code = a.Code AND tzmd.City = a.City AND tzmd.Tariff = a.Tariff AND tzmd.SurchargePerMinute IS NOT NULL)
												
						WHERE  (tzm.TimezonesID != @v_default_TimezonesID ) AND  tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff AND tzm.SurchargePerMinute IS NOT NULL;

						/*calls_OutpaymentPerCall DECIMAL(18,2), 
						calls_Surcharges DECIMAL(18,2), 
						calls_SurchargePerCall DECIMAL(18,2), 
						calls_CollectionCostAmount DECIMAL(18,2), 
						calls_CostPerCall DECIMAL(18,2), 
						*/

						-- Calls						
						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET calls_OutpaymentPerCall =  calls_OutpaymentPerCall /*@p_Minutes*/ /  (select IF(count(DISTINCT tzmd.TimezonesID)=0,1,count(DISTINCT tzmd.TimezonesID)) from tmp_timezone_minutes_2 tzmd WHERE  tzmd.VendorConnectionID = tzm.VendorConnectionID AND tzmd.AccessType = tzm.AccessType AND tzmd.CountryID = tzm.CountryID AND tzmd.OriginationCode = tzm.OriginationCode AND tzmd.Code = tzm.Code AND tzmd.City = tzm.City AND tzmd.Tariff = tzm.Tariff 
						AND tzmd.OutpaymentPerCall IS NOT NULL )
						WHERE  (tzm.TimezonesID != @v_default_TimezonesID ) AND  tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff 
						AND tzm.OutpaymentPerCall IS NOT NULL;

						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET calls_Surcharges = calls_Surcharges /*@p_Minutes*/ /  (select IF(count(DISTINCT tzmd.TimezonesID)=0,1,count(DISTINCT tzmd.TimezonesID)) from tmp_timezone_minutes_2 tzmd WHERE  tzmd.VendorConnectionID = tzm.VendorConnectionID AND tzmd.AccessType = tzm.AccessType AND tzmd.CountryID = tzm.CountryID AND tzmd.OriginationCode = tzm.OriginationCode AND tzmd.Code = tzm.Code AND tzmd.City = tzm.City AND tzmd.Tariff = tzm.Tariff 
						AND tzmd.Surcharges IS NOT NULL)
						WHERE  (tzm.TimezonesID != @v_default_TimezonesID ) AND  tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff 
						AND tzm.Surcharges IS NOT NULL;

						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET calls_SurchargePerCall = calls_SurchargePerCall /*@p_Minutes*/ /  (select IF(count(DISTINCT tzmd.TimezonesID)=0,1,count(DISTINCT tzmd.TimezonesID)) from tmp_timezone_minutes_2 tzmd WHERE  tzmd.VendorConnectionID = a.VendorConnectionID AND tzmd.AccessType = a.AccessType AND tzmd.CountryID = a.CountryID AND tzmd.OriginationCode = tzm.OriginationCode AND tzmd.Code = a.Code AND tzmd.City = a.City AND tzmd.Tariff = a.Tariff 
						AND tzmd.SurchargePerCall IS NOT NULL)
						WHERE   tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff 
						AND tzm.SurchargePerCall IS NOT NULL;

						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET calls_CollectionCostAmount = calls_CollectionCostAmount /*@p_Minutes*/ /  (select IF(count(DISTINCT tzmd.TimezonesID)=0,1,count(DISTINCT tzmd.TimezonesID)) from tmp_timezone_minutes_2 tzmd WHERE  tzmd.VendorConnectionID = tzm.VendorConnectionID AND tzmd.AccessType = tzm.AccessType AND tzmd.CountryID = tzm.CountryID AND tzmd.OriginationCode = tzm.OriginationCode AND tzmd.Code = tzm.Code AND tzmd.City = tzm.City AND tzmd.Tariff = tzm.Tariff 
						AND tzmd.CollectionCostAmount IS NOT NULL)
						WHERE (tzm.TimezonesID != @v_default_TimezonesID ) AND   tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff 
						AND tzm.CollectionCostAmount IS NOT NULL;

						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET calls_CostPerCall = calls_CostPerCall /*@p_Minutes*/ /  (select IF(count(DISTINCT tzmd.TimezonesID)=0,1,count(DISTINCT tzmd.TimezonesID)) from tmp_timezone_minutes_2 tzmd WHERE  tzmd.VendorConnectionID = a.VendorConnectionID AND tzmd.AccessType = a.AccessType AND tzmd.CountryID = a.CountryID AND tzmd.OriginationCode = tzm.OriginationCode AND tzmd.Code = a.Code AND tzmd.City = a.City AND tzmd.Tariff = a.Tariff 
						AND tzmd.CostPerCall IS NOT NULL)
						WHERE (tzm.TimezonesID != @v_default_TimezonesID ) AND   tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff 
						AND tzm.CostPerCall IS NOT NULL;

					END IF;


					truncate table tmp_timezone_minutes_2;
					INSERT INTO tmp_timezone_minutes_2 SELECT * FROM tmp_timezone_minutes;

				
  

					
					/* SET @v_MinutesFromMobileOrigination  =  ( (@p_Minutes/ 100) * @p_OriginationPercentage ) 	;
					insert into tmp_origination_minutes ( OriginationCode, minutes )
					select @p_Origination  , @v_MinutesFromMobileOrigination ;
					*/
 


		END IF;

		SET @v_days =    TIMESTAMPDIFF(DAY, (SELECT @p_StartDate), (SELECT @p_EndDate)) + 1 ;
		SET @v_period1 =      IF(MONTH((SELECT @p_StartDate)) = MONTH((SELECT @p_EndDate)), 0, (TIMESTAMPDIFF(DAY, (SELECT @p_StartDate), LAST_DAY((SELECT @p_StartDate)) + INTERVAL 0 DAY)) / DAY(LAST_DAY((SELECT @p_StartDate))));
		SET @v_period2 =      TIMESTAMPDIFF(MONTH, LAST_DAY((SELECT @p_StartDate)) + INTERVAL 1 DAY, LAST_DAY((SELECT @p_EndDate))) ;
		SET @v_period3 =      IF(MONTH((SELECT @p_StartDate)) = MONTH((SELECT @p_EndDate)), (SELECT @v_days), DAY((SELECT @p_EndDate))) / DAY(LAST_DAY((SELECT @p_EndDate)));
		SET @p_months =     (SELECT @v_period1) + (SELECT @v_period2) + (SELECT @v_period3);

		SET @p_months = Round(@p_months,1); -- fn_Round(@p_months,1);

		




		INSERT INTO  tmp_tblRateTableDIDRate_step1
		(
			RateTableID,
			TimezonesID,
			TimezoneTitle,
			CodeDeckId,
			CountryID,
			AccessType,
			CountryPrefix,
			City,
			Tariff,
			Code,
			OriginationCode,
			VendorConnectionID,
			VendorID,
 			EndDate,
			OneOffCost,
			MonthlyCost,
			TrunkCostPerService,
			CostPerCall,
			CostPerMinute,
			SurchargePerCall,
			SurchargePerMinute,
			OutpaymentPerCall,
			OutpaymentPerMinute,
			Surcharges,
			Chargeback,
			CollectionCostAmount,
			CollectionCostPercentage,
			RegistrationCostPerNumber
		)

			select
				rt.RateTableID,
				drtr.TimezonesID,
				t.Title as TimezoneTitle,
				rt.CodeDeckId,
				c.CountryID,
				drtr.AccessType,
				c.Prefix as CountryPrefix,
				drtr.City,
				drtr.Tariff,
				r.Code,
				IFNULL(r2.Code,'') as OriginationCode,
				vc.VendorConnectionID,
				a.AccountID as VendorID,
 				drtr.EndDate,
				@OneOffCost := CASE WHEN ( OneOffCostCurrency is not null)
				THEN

					CASE WHEN  @v_CurrencyID_ = OneOffCostCurrency THEN
						drtr.OneOffCost
					ELSE
					(

						(@v_DestinationCurrencyConversionRate  )
						* (drtr.OneOffCost  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = OneOffCostCurrency and  CompanyID = @v_CompanyId_ ))
					)
					END

				ELSE
					(

						(@v_DestinationCurrencyConversionRate ) * (drtr.OneOffCost  / (@v_CompanyCurrencyConversionRate ))
					)
				END as OneOffCost,

				@MonthlyCost :=
				(
					CASE WHEN ( MonthlyCostCurrency is not null)
					THEN

							CASE WHEN  @v_CurrencyID_ = MonthlyCostCurrency THEN
								drtr.MonthlyCost
							ELSE
							(

								(@v_DestinationCurrencyConversionRate  )
								* (drtr.MonthlyCost  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = MonthlyCostCurrency and  CompanyID = @v_CompanyId_ ))
							)
							END


					ELSE
						(

							(@v_DestinationCurrencyConversionRate )
							* (drtr.MonthlyCost  / (@v_CompanyCurrencyConversionRate ))
						)
					END
				) as MonthlyCost,

				/*@TrunkCostPerService := vtc.Cost / NoOfServicesContracted
					
				*/

				@TrunkCostPerService :=
				(
						IFNULL(
						(
							(
								CASE WHEN ( vtc.CurrencyID is not null)
								THEN
									CASE WHEN  @v_CurrencyID_ = vtc.CurrencyID THEN
										vtc.Cost
									ELSE
									(

										(@v_DestinationCurrencyConversionRate)
										* (vtc.Cost  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = vtc.CurrencyID and  CompanyID = @v_CompanyId_ ))
									)

									END
								ELSE
									0
								END
							) / (select NoOfServicesContracted from  tmp_NoOfServicesContracted sc where sc.VendorID is null or sc.VendorID  = a.AccountID )
						),0)

				)
				as TrunkCostPerService,

				@CostPerCall := CASE WHEN ( CostPerCallCurrency is not null)
				THEN

						CASE WHEN  @v_CurrencyID_ = CostPerCallCurrency THEN
							drtr.CostPerCall
						ELSE
						(

							(@v_DestinationCurrencyConversionRate )
							* (drtr.CostPerCall  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = CostPerCallCurrency and  CompanyID = @v_CompanyId_ ))
						)
						END


				ELSE
					(

						(@v_DestinationCurrencyConversionRate )
						* (drtr.CostPerCall  / (@v_CompanyCurrencyConversionRate ))
					)
				END as CostPerCall,

				@CostPerMinute := CASE WHEN ( CostPerMinuteCurrency is not null)
				THEN

						CASE WHEN  @v_CurrencyID_ = CostPerMinuteCurrency THEN
							drtr.CostPerMinute
						ELSE
						(

							(@v_DestinationCurrencyConversionRate )
							* (drtr.CostPerMinute  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = CostPerMinuteCurrency and  CompanyID = @v_CompanyId_ ))
						)
						END


				ELSE
					(

						(@v_DestinationCurrencyConversionRate )
						* (drtr.CostPerMinute  / (@v_CompanyCurrencyConversionRate ))
					)
				END as CostPerMinute,


				@SurchargePerCall := CASE WHEN ( SurchargePerCallCurrency is not null)
				THEN

					CASE WHEN  @v_CurrencyID_ = SurchargePerCallCurrency THEN
						drtr.SurchargePerCall
					ELSE
					(

						(@v_DestinationCurrencyConversionRate )
						* (drtr.SurchargePerCall  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = SurchargePerCallCurrency and  CompanyID = @v_CompanyId_ ))
					)
					END

				ELSE
					(

						(@v_DestinationCurrencyConversionRate )
						* (drtr.SurchargePerCall  / (@v_CompanyCurrencyConversionRate ))
					)
				END as SurchargePerCall,


				@SurchargePerMinute := CASE WHEN ( SurchargePerMinuteCurrency is not null)
				THEN

					CASE WHEN  @v_CurrencyID_ = SurchargePerMinuteCurrency THEN
						drtr.SurchargePerMinute
					ELSE
					(

						(@v_DestinationCurrencyConversionRate )
						* (drtr.SurchargePerMinute  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = SurchargePerMinuteCurrency and  CompanyID = @v_CompanyId_ ))
					)
					END

				ELSE
					(

						(@v_DestinationCurrencyConversionRate )
						* (drtr.SurchargePerMinute  / (@v_CompanyCurrencyConversionRate ))
					)
				END as SurchargePerMinute,

				@OutpaymentPerCall := CASE WHEN ( OutpaymentPerCallCurrency is not null)
				THEN

					CASE WHEN  @v_CurrencyID_ = OutpaymentPerCallCurrency THEN
						drtr.OutpaymentPerCall
					ELSE
					(

						(@v_DestinationCurrencyConversionRate )
						* (drtr.OutpaymentPerCall  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = OutpaymentPerCallCurrency and  CompanyID = @v_CompanyId_ ))
					)
					END

				ELSE
					(

						(@v_DestinationCurrencyConversionRate )
						* (drtr.OutpaymentPerCall  / (@v_CompanyCurrencyConversionRate ))
					)
				END as OutpaymentPerCall,

				@OutpaymentPerMinute := CASE WHEN ( OutpaymentPerMinuteCurrency is not null)
				THEN

					CASE WHEN  @v_CurrencyID_ = OutpaymentPerMinuteCurrency THEN
						drtr.OutpaymentPerMinute
					ELSE
					(

						(@v_DestinationCurrencyConversionRate )
						* (drtr.OutpaymentPerMinute  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = OutpaymentPerMinuteCurrency and  CompanyID = @v_CompanyId_ ))
					)
					END

				ELSE
					(

						(@v_DestinationCurrencyConversionRate )
						* (drtr.OutpaymentPerMinute  / (@v_CompanyCurrencyConversionRate ))
					)
				END as OutpaymentPerMinute,

				@Surcharges := CASE WHEN ( SurchargesCurrency is not null)
				THEN

					CASE WHEN  @v_CurrencyID_ = SurchargesCurrency THEN
						drtr.Surcharges
					ELSE
					(

						(@v_DestinationCurrencyConversionRate )
						* (drtr.Surcharges  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = SurchargesCurrency and  CompanyID = @v_CompanyId_ ))
					)
					END

				ELSE
					(

						(@v_DestinationCurrencyConversionRate )
						* (drtr.Surcharges  / (@v_CompanyCurrencyConversionRate ))
					)
				END as Surcharges,

				@Chargeback := drtr.Chargeback as Chargeback,


				@CollectionCostAmount := CASE WHEN ( CollectionCostAmountCurrency is not null)
				THEN

					CASE WHEN  @v_CurrencyID_ = CollectionCostAmountCurrency THEN
						drtr.CollectionCostAmount
					ELSE
					(

						(@v_DestinationCurrencyConversionRate )
						* (drtr.CollectionCostAmount  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = CollectionCostAmountCurrency and  CompanyID = @v_CompanyId_ ))
					)
					END

				ELSE
					(

						(@v_DestinationCurrencyConversionRate )
						* (drtr.CollectionCostAmount  / (@v_CompanyCurrencyConversionRate ))
					)
				END as CollectionCostAmount,


				@CollectionCostPercentage := drtr.CollectionCostPercentage  as CollectionCostPercentage,

				@RegistrationCostPerNumber := CASE WHEN ( RegistrationCostPerNumberCurrency is not null)
				THEN

					CASE WHEN  @v_CurrencyID_ = RegistrationCostPerNumberCurrency THEN
						drtr.RegistrationCostPerNumber
					ELSE
					(

						(@v_DestinationCurrencyConversionRate )
						* (drtr.RegistrationCostPerNumber  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = RegistrationCostPerNumberCurrency and  CompanyID = @v_CompanyId_ ))
					)
					END

				ELSE
					(

						(@v_DestinationCurrencyConversionRate )
						* (drtr.RegistrationCostPerNumber  / (@v_CompanyCurrencyConversionRate ))
					)
				END as RegistrationCostPerNumber


				from tblRateTableDIDRate  drtr
				inner join tblRateTable  rt on rt.RateTableId = drtr.RateTableId
				 inner join tblVendorConnection vc on vc.RateTableID = rt.RateTableId and vc.DIDCategoryID = rt.DIDCategoryID and vc.CompanyID = rt.CompanyId  and vc.Active=1
				inner join tblAccount a on vc.AccountId = a.AccountID and rt.CompanyId = a.CompanyId and a.IsVendor = 1 and a.Status = 1
				left join tblVendorTrunkCost vtc on a.AccountID = vtc.AccountID
				inner join tblRate r on drtr.RateID = r.RateID and r.CompanyID = vc.CompanyID
				left join tblRate r2 on drtr.OriginationRateID = r2.RateID and r.CompanyID = r2.CompanyID
		 		inner join tblCountry c on c.CountryID = r.CountryID


				AND ( fn_IsEmpty(@p_CountryID)  OR  c.CountryID = @p_CountryID )
				AND ( fn_IsEmpty(@p_City)  OR drtr.City = @p_City )
				AND ( fn_IsEmpty(@p_Tariff)  OR drtr.Tariff  = @p_Tariff )
				AND ( fn_IsEmpty(@p_Prefix)  OR (r.Code  = concat(c.Prefix ,@p_Prefix) ) )
				AND ( fn_IsEmpty(@p_AccessType)  OR drtr.AccessType = @p_AccessType )
				inner join tblTimezones t on t.TimezonesID =  drtr.TimezonesID

				where

				rt.CompanyId =  @v_CompanyId_

				and vc.DIDCategoryID = @p_DIDCategoryID

				and drtr.ApprovedStatus = @v_ApprovedStatus

				and rt.Type = @v_RateTypeID

			  	and rt.AppliedTo = @v_AppliedToVendor

				and (
					 (@p_EffectiveRate = 'now' AND EffectiveDate <= NOW())
					 OR
					 (@p_EffectiveRate = 'future' AND EffectiveDate > NOW()  )
					 OR
					 (	 @p_EffectiveRate = 'effective' AND EffectiveDate <= @p_EffectiveDate
							 AND ( drtr.EndDate IS NULL OR (drtr.EndDate > DATE(@p_EffectiveDate)) )
					 )
				);


 		/*
		NOTE: as per LCR remove records not exitst in tmp_timezone_minutes
		 DELETE drtr FROM tmp_tblRateTableDIDRate_step1 drtr
		LEFT JOIN  tmp_timezone_minutes tm on drtr.TimezonesID = tm.TimezonesID   and drtr.VendorConnectionID = tm.VendorConnectionID and drtr.OriginationCode = tm.OriginationCode 
		AND drtr.AccessType = tm.AccessType AND drtr.CountryID = tm.CountryID  AND drtr.Code = tm.Code AND drtr.City = tm.City AND  drtr.Tariff  = tm.Tariff
		where tm.VendorConnectionID IS NULL;
		*/








		/*
		Make following fields common against Timezones
		Common MonthlyCost , OneoffCost  and RegistrationCostPerNumber

		STEP1: select single record which has MonthlyCost per product Single record of max TimezonesID
		STEP2: delete product MonthlyCost where TimezonesID!= MaxTimezonesID
		*/
/*
			Make following fields common against Timezones
			Common MonthlyCost , OneoffCost  and RegistrationCostPerNumber
			*/

			insert into tmp_tblRateTableDIDRate_step1_dup select * from tmp_tblRateTableDIDRate_step1;

			update tmp_tblRateTableDIDRate_step1 svr
			INNER JOIN (
					select  VendorConnectionID,  max(TimezonesID) as TimezonesID, AccessType, CountryID, Code, City, Tariff
					from tmp_tblRateTableDIDRate_step1_dup
					where  MonthlyCost > 0 group by  VendorConnectionID,  AccessType, CountryID, Code, City, Tariff
				)
				svr2 on
					  svr.VendorConnectionID = svr2.VendorConnectionID AND
					  svr.TimezonesID != svr2.TimezonesID AND
					  svr.AccessType = svr2.AccessType AND
					  svr.CountryID = svr2.CountryID AND
					  svr.Code = svr2.Code AND
					  svr.City = svr2.City AND
					  svr.Tariff = svr2.Tariff

			SET svr.MonthlyCost = 0
			where svr.MonthlyCost > 0 and svr2.TimezonesID is not null and svr.TimezonesID is not null;


			update tmp_tblRateTableDIDRate_step1 svr
			INNER JOIN (
					select  VendorConnectionID,  max(TimezonesID) as TimezonesID, AccessType, CountryID, Code, City, Tariff
					from tmp_tblRateTableDIDRate_step1_dup
					where  OneoffCost > 0 group by  VendorConnectionID,  AccessType, CountryID, Code, City, Tariff
				)
				svr2 on
					  svr.VendorConnectionID = svr2.VendorConnectionID AND
					  svr.TimezonesID != svr2.TimezonesID AND
					  svr.AccessType = svr2.AccessType AND
					  svr.CountryID = svr2.CountryID AND
					  svr.Code = svr2.Code AND
					  svr.City = svr2.City AND
					  svr.Tariff = svr2.Tariff
			SET svr.OneoffCost = 0
			where svr.OneoffCost > 0 and svr2.TimezonesID is not null and svr.TimezonesID is not null;


			update tmp_tblRateTableDIDRate_step1 svr
			INNER JOIN (
					select  VendorConnectionID,  max(TimezonesID) as TimezonesID, AccessType, CountryID, Code, City, Tariff
					from tmp_tblRateTableDIDRate_step1_dup
					where  RegistrationCostPerNumber > 0 group by  VendorConnectionID,  AccessType, CountryID, Code, City, Tariff
				)
				svr2 on
					  svr.VendorConnectionID = svr2.VendorConnectionID AND
					  svr.TimezonesID != svr2.TimezonesID AND
					  svr.AccessType = svr2.AccessType AND
					  svr.CountryID = svr2.CountryID AND
					  svr.Code = svr2.Code AND
					  svr.City = svr2.City AND
					  svr.Tariff = svr2.Tariff

			SET svr.RegistrationCostPerNumber = 0
			where svr.RegistrationCostPerNumber > 0 and svr2.TimezonesID is not null and svr.TimezonesID is not null;

		-- ######################################## -- ######################################## -- ################################# -- ################################	
		-- do same for same timezone and different Origination

			update tmp_tblRateTableDIDRate_step1 svr
			INNER JOIN (
					select  VendorConnectionID, max(OriginationCode) as OriginationCode,  max(TimezonesID) as TimezonesID, AccessType, CountryID, Code, City, Tariff
					from tmp_tblRateTableDIDRate_step1_dup
					where  MonthlyCost > 0 group by  VendorConnectionID,  AccessType, CountryID, Code, City, Tariff
				)
				svr2 on
					  svr.VendorConnectionID = svr2.VendorConnectionID AND
					  svr.OriginationCode != svr2.OriginationCode AND 
					  svr.TimezonesID = svr2.TimezonesID AND 
					  svr.AccessType = svr2.AccessType AND
					  svr.CountryID = svr2.CountryID AND
					  svr.Code = svr2.Code AND
					  svr.City = svr2.City AND
					  svr.Tariff = svr2.Tariff

			SET svr.MonthlyCost = 0
			where svr.MonthlyCost > 0 and svr2.TimezonesID is not null and svr.TimezonesID is not null;


			update tmp_tblRateTableDIDRate_step1 svr
			INNER JOIN (
					select  VendorConnectionID, max(OriginationCode) as OriginationCode,  max(TimezonesID) as TimezonesID, AccessType, CountryID, Code, City, Tariff
					from tmp_tblRateTableDIDRate_step1_dup
					where  OneoffCost > 0 group by  VendorConnectionID,  AccessType, CountryID, Code, City, Tariff
				)
				svr2 on
					  svr.VendorConnectionID = svr2.VendorConnectionID AND
					  svr.OriginationCode != svr2.OriginationCode AND 
					  svr.TimezonesID = svr2.TimezonesID AND 
					  svr.AccessType = svr2.AccessType AND
					  svr.CountryID = svr2.CountryID AND
					  svr.Code = svr2.Code AND
					  svr.City = svr2.City AND
					  svr.Tariff = svr2.Tariff
			SET svr.OneoffCost = 0
			where svr.OneoffCost > 0 and svr2.TimezonesID is not null and svr.TimezonesID is not null;


			update tmp_tblRateTableDIDRate_step1 svr
			INNER JOIN (
					select  VendorConnectionID, max(OriginationCode) as OriginationCode,  max(TimezonesID) as TimezonesID, AccessType, CountryID, Code, City, Tariff
					from tmp_tblRateTableDIDRate_step1_dup
					where  RegistrationCostPerNumber > 0 group by  VendorConnectionID,  AccessType, CountryID, Code, City, Tariff
				)
				svr2 on
					  svr.VendorConnectionID = svr2.VendorConnectionID AND
					  svr.OriginationCode != svr2.OriginationCode AND 
					  svr.TimezonesID = svr2.TimezonesID AND 
					  svr.AccessType = svr2.AccessType AND
					  svr.CountryID = svr2.CountryID AND
					  svr.Code = svr2.Code AND
					  svr.City = svr2.City AND
					  svr.Tariff = svr2.Tariff

			SET svr.RegistrationCostPerNumber = 0
			where svr.RegistrationCostPerNumber > 0 and svr2.TimezonesID is not null and svr.TimezonesID is not null;
 

			insert into tmp_table_without_origination
			(
				RateTableID,
				TimezonesID,
				TimezoneTitle,
				CodeDeckId,
				CountryID,
				AccessType,
				CountryPrefix,
				City,
				Tariff,
				Code,
				OriginationCode,
				VendorConnectionID,
				VendorID,
				-- VendorConnectionName,
				EndDate,
				OneOffCost,
				MonthlyCost,
				CostPerCall,
				CostPerMinute,
				SurchargePerCall,
				SurchargePerMinute,
				OutpaymentPerCall,
				OutpaymentPerMinute,
				Surcharges,
				Chargeback,
				CollectionCostAmount,
				CollectionCostPercentage,
				RegistrationCostPerNumber,

				OneOffCostCurrency,
				MonthlyCostCurrency,
				CostPerCallCurrency,
				CostPerMinuteCurrency,
				SurchargePerCallCurrency,
				SurchargePerMinuteCurrency,
				OutpaymentPerCallCurrency,
				OutpaymentPerMinuteCurrency,
				SurchargesCurrency,
				ChargebackCurrency,
				CollectionCostAmountCurrency,
				RegistrationCostPerNumberCurrency,
				OutPayment,
				Surcharge,
				Total
			)
			select
				drtr.RateTableID,
				drtr.TimezonesID,
				drtr.TimezoneTitle,
				drtr.CodeDeckId,
				drtr.CountryID,
				drtr.AccessType,
				drtr.CountryPrefix,
				drtr.City,
				drtr.Tariff,
				drtr.Code,
				drtr.OriginationCode,
				drtr.VendorConnectionID,
				drtr.VendorID,
				drtr.EndDate,
				( ( IFNULL(drtr.OneOffCost,0)  )  ) as OneOffCost,
				( ( IFNULL(drtr.MonthlyCost,0) * @p_months ) + drtr.TrunkCostPerService ) as MonthlyCost,
				drtr.CostPerCall,
				drtr.CostPerMinute,
				drtr.SurchargePerCall,
				drtr.SurchargePerMinute,
				drtr.OutpaymentPerCall,
				drtr.OutpaymentPerMinute,
				drtr.Surcharges,
				drtr.Chargeback,
				drtr.CollectionCostAmount,
				drtr.CollectionCostPercentage,
				drtr.RegistrationCostPerNumber,



				@v_CurrencyID_ as OneOffCostCurrency,
				@v_CurrencyID_ as MonthlyCostCurrency,
				@v_CurrencyID_ as CostPerCallCurrency,
				@v_CurrencyID_ as CostPerMinuteCurrency,
				@v_CurrencyID_ as SurchargePerCallCurrency,
				@v_CurrencyID_ as SurchargePerMinuteCurrency,
				@v_CurrencyID_ as OutpaymentPerCallCurrency,
				@v_CurrencyID_ as OutpaymentPerMinuteCurrency,
				@v_CurrencyID_ as SurchargesCurrency,
				@v_CurrencyID_ as ChargebackCurrency,
				@v_CurrencyID_ as CollectionCostAmountCurrency,
				@v_CurrencyID_ as RegistrationCostPerNumberCurrency,



				/*
				Outpayment
						OutpaymentPerCall
						OutpaymentPerMinute

				MonthlyCost * months + TrunkCostPerService
				CollectionCostAmount
				CostPerCall
				CostPerMinute

				Surcharge
					IF SurchargePerCall and SurchargePerMinute = 0
							Surcharges
						ELSE
							SurchargePerCall +
							SurchargePerMinute

					END IF

				 OutPayment * 1.21  * CollectionCostPercentage/100
				 OutPayment * Chargeback/100

				*/

				@OutPayment  := (

					( IFNULL(drtr.OutpaymentPerCall,0) * 	IFNULL(tm.calls_OutpaymentPerCall,0) )  +
					( IFNULL(drtr.OutpaymentPerMinute,0) *  IFNULL(tm.minute_OutpaymentPerMinute,0))	
					
				),

				@Surcharge := (
					CASE WHEN IFNULL(drtr.SurchargePerCall,0) = 0 AND IFNULL(drtr.SurchargePerMinute,0) = 0 THEN
						(IFNULL(drtr.Surcharges,0) * IFNULL(tm.calls_Surcharges,0))
					ELSE 	
						(
							(IFNULL(drtr.SurchargePerCall,0) * IFNULL(tm.calls_SurchargePerCall,0) ) +
							(IFNULL(drtr.SurchargePerMinute,0) * IFNULL(tm.minute_SurchargePerMinute,0))	
						)
					END 
				),
				@Total := (

					(	(IFNULL(drtr.MonthlyCost,0)* @p_months)	 +  drtr.TrunkCostPerService	)				+ 

					( IFNULL(drtr.CollectionCostAmount,0) * IFNULL(tm.calls_CollectionCostAmount,0) ) +
					(IFNULL(drtr.CostPerCall,0) * IFNULL(tm.calls_CostPerCall,0))		+
					(IFNULL(drtr.CostPerMinute,0) * IFNULL(tm.minute_CostPerMinute,0))	+
					
					@Surcharge  - @OutPayment +

					(
						( ( (@OutPayment * 1.21) ) * IFNULL(drtr.CollectionCostPercentage,0)/100 ) +
						( ( (@OutPayment  * IFNULL(drtr.Chargeback,0)/100 ) ) )
					)

				)
					as Total
				from tmp_tblRateTableDIDRate_step1  drtr
				INNER JOIN  tmp_timezone_minutes tm on drtr.TimezonesID = tm.TimezonesID   and drtr.VendorConnectionID = tm.VendorConnectionID and drtr.OriginationCode = tm.OriginationCode  
				AND drtr.AccessType = tm.AccessType AND drtr.CountryID = tm.CountryID  AND drtr.Code = tm.Code AND drtr.City = tm.City AND  drtr.Tariff  = tm.Tariff;

 						-- just for testing -- TEST
						/*select  
								drtr.RateTableID,
								drtr.TimezonesID,
								drtr.TimezoneTitle,
								drtr.CodeDeckId,
								drtr.CountryID,
								drtr.AccessType,
								drtr.CountryPrefix,
								drtr.City,
								drtr.Tariff,
								drtr.Code,
								drtr.OriginationCode,
								drtr.VendorConnectionID,
								drtr.VendorID,
								drtr.EndDate,
								drtr.OneOffCost,
								drtr.MonthlyCost,
								drtr.CostPerCall,
								drtr.CostPerMinute,
								drtr.SurchargePerCall,
								drtr.SurchargePerMinute,
								drtr.OutpaymentPerCall,
								drtr.OutpaymentPerMinute,
								drtr.Surcharges,
								drtr.Chargeback,
								drtr.CollectionCostAmount,
								drtr.CollectionCostPercentage,
								drtr.RegistrationCostPerNumber,

								


								@OutPayment  := (

									( IFNULL(drtr.OutpaymentPerCall,0) * 	IFNULL(tm.calls_OutpaymentPerCall,0) )  +
									( IFNULL(drtr.OutpaymentPerMinute,0) *  IFNULL(tm.minute_OutpaymentPerMinute,0))	
									
								),

								@Surcharge := (
									CASE WHEN IFNULL(drtr.SurchargePerCall,0) = 0 AND IFNULL(drtr.SurchargePerMinute,0) = 0 THEN
										(IFNULL(drtr.Surcharges,0) * IFNULL(tm.calls_Surcharges,0))
									ELSE 	
										(
											(IFNULL(drtr.SurchargePerCall,0) * IFNULL(tm.calls_SurchargePerCall,0) ) +
											(IFNULL(drtr.SurchargePerMinute,0) * IFNULL(tm.minute_SurchargePerMinute,0))	
										)
									END 
								),
								@Total := (

									(	(IFNULL(drtr.MonthlyCost,0)* @p_months)	 +  drtr.TrunkCostPerService	)				+ 

									( IFNULL(drtr.CollectionCostAmount,0) * IFNULL(tm.calls_CollectionCostAmount,0) ) +
									(IFNULL(drtr.CostPerCall,0) * IFNULL(tm.calls_CostPerCall,0))		+
									(IFNULL(drtr.CostPerMinute,0) * IFNULL(tm.minute_CostPerMinute,0))	+
									
									@Surcharge  - @OutPayment +

									(
										( ( (@OutPayment * 1.21) ) * IFNULL(drtr.CollectionCostPercentage,0)/100 ) +
										( ( (@OutPayment  * IFNULL(drtr.Chargeback,0)/100 ) ) )
									)

								)
								 as Total,

								tm.calls_CostPerCall,
								@disOutPayment  := concat(

									concat( IFNULL(drtr.OutpaymentPerCall,0) ,' * ', 	IFNULL(tm.calls_OutpaymentPerCall,0) ) , ' + ',
									concat( IFNULL(drtr.OutpaymentPerMinute,0) ,' * ' ,  IFNULL(tm.minute_OutpaymentPerMinute,0))	
									
								) as disOutPayment,

								@disSurcharge := concat(
									CASE WHEN IFNULL(drtr.SurchargePerCall,0) = 0 AND IFNULL(drtr.SurchargePerMinute,0) = 0 THEN
										concat(IFNULL(drtr.Surcharges,0) , ' * ' ,  IFNULL(tm.calls_Surcharges,0))
									ELSE 	
									concat(
											concat(IFNULL(drtr.SurchargePerCall,0) , ' * ' , IFNULL(tm.calls_SurchargePerCall,0) ) , ' + ',
											concat(IFNULL(drtr.SurchargePerMinute,0) , ' * ' , IFNULL(tm.minute_SurchargePerMinute,0))	
										)
									END 
								) as disSurcharge,
								@disTotal := concat(

									concat(	concat(IFNULL(drtr.MonthlyCost,0) , ' * ' , @p_months)	 , ' + ',  drtr.TrunkCostPerService	)			, ' + ',

									concat( IFNULL(drtr.CollectionCostAmount,0) , ' * ' , IFNULL(tm.calls_CollectionCostAmount,0) ) , ' + ',
									concat(IFNULL(drtr.CostPerCall,0) , ' * ' , IFNULL(tm.calls_CostPerCall,0))		, ' + ',
									concat(IFNULL(drtr.CostPerMinute,0) , ' * ' , IFNULL(tm.minute_CostPerMinute,0)), ' + ',
									
									concat(@Surcharge  , ' - ', @OutPayment, ' + '),

									concat(
										concat(concat( concat(@OutPayment , ' * ' , 1.21) ) , ' * ' , IFNULL(drtr.CollectionCostPercentage,0) , ' / ', 100 )  , ' + ',
										concat(concat( concat(@OutPayment  , ' * ' , IFNULL(drtr.Chargeback,0), ' / ', 100 ) ) )
									)

								) as disTotal


								

						from tmp_tblRateTableDIDRate_step1  drtr
						INNER JOIN  tmp_timezone_minutes tm on drtr.TimezonesID = tm.TimezonesID   and drtr.VendorConnectionID = tm.VendorConnectionID and drtr.OriginationCode = tm.OriginationCode  
						AND drtr.AccessType = tm.AccessType AND drtr.CountryID = tm.CountryID  AND drtr.Code = tm.Code AND drtr.City = tm.City AND  drtr.Tariff  = tm.Tariff;
						*/
						
 
				insert into tmp_tblRateTableDIDRate (
										RateTableID,
										TimezonesID,
										TimezoneTitle,
										CodeDeckId,
										CountryID,
										AccessType,
										CountryPrefix,
										City,
										Tariff,
										Code,
										OriginationCode,
										VendorConnectionID,
										VendorID,
										-- VendorConnectionName,
										EndDate,
										OneOffCost,
										MonthlyCost,
										CostPerCall,
										CostPerMinute,
										SurchargePerCall,
										SurchargePerMinute,
										OutpaymentPerCall,
										OutpaymentPerMinute,
										Surcharges,
										Chargeback,
										CollectionCostAmount,
										CollectionCostPercentage,
										RegistrationCostPerNumber,
										OneOffCostCurrency,
										MonthlyCostCurrency,
										CostPerCallCurrency,
										CostPerMinuteCurrency,
										SurchargePerCallCurrency,
										SurchargePerMinuteCurrency,
										OutpaymentPerCallCurrency,
										OutpaymentPerMinuteCurrency,
										SurchargesCurrency,
										ChargebackCurrency,
										CollectionCostAmountCurrency,
										RegistrationCostPerNumberCurrency,
										Total
										)

										select
										RateTableID,
										TimezonesID,
										TimezoneTitle,
										CodeDeckId,
										CountryID,
										AccessType,
										CountryPrefix,
										City,
										Tariff,
										Code,
										OriginationCode,
										VendorConnectionID,
										VendorID,
										-- VendorConnectionName,
										EndDate,
										OneOffCost,
										MonthlyCost,
										CostPerCall,
										CostPerMinute,
										SurchargePerCall,
										SurchargePerMinute,
										OutpaymentPerCall,
										OutpaymentPerMinute,
										Surcharges,
										Chargeback,
										CollectionCostAmount,
										CollectionCostPercentage,
										RegistrationCostPerNumber,
										OneOffCostCurrency,
										MonthlyCostCurrency,
										CostPerCallCurrency,
										CostPerMinuteCurrency,
										SurchargePerCallCurrency,
										SurchargePerMinuteCurrency,
										OutpaymentPerCallCurrency,
										OutpaymentPerMinuteCurrency,
										SurchargesCurrency,
										ChargebackCurrency,
										CollectionCostAmountCurrency,
										RegistrationCostPerNumberCurrency,
										Total
										from tmp_table_without_origination 
										where Total is not null;





      insert into tmp_table_output_1
      (												RateTableID,
												TimezonesID,
												TimezoneTitle,
												CodeDeckId,
												CountryID,
												AccessType,
												CountryPrefix,
												City,
												Tariff,
												Code,
												OriginationCode,
												VendorConnectionID,
												VendorID,
												-- VendorConnectionName,
												EndDate,
												OneOffCost,
												MonthlyCost,
												CostPerCall,
												CostPerMinute,
												SurchargePerCall,
												SurchargePerMinute,
												OutpaymentPerCall,
												OutpaymentPerMinute,
												Surcharges,
												Chargeback,
												CollectionCostAmount,
												CollectionCostPercentage,
												RegistrationCostPerNumber,
												OneOffCostCurrency,
												MonthlyCostCurrency,
												CostPerCallCurrency,
												CostPerMinuteCurrency,
												SurchargePerCallCurrency,
												SurchargePerMinuteCurrency,
												OutpaymentPerCallCurrency,
												OutpaymentPerMinuteCurrency,
												SurchargesCurrency,
												ChargebackCurrency,
												CollectionCostAmountCurrency,
												RegistrationCostPerNumberCurrency,
												Total
							)
								select
	  											max(RateTableID),
												(TimezonesID),
												max(TimezoneTitle),
												max(CodeDeckId),
												(CountryID),
												(AccessType),
												max(CountryPrefix),
												(City),
												(Tariff),
												(Code),
												(OriginationCode),
												(VendorConnectionID),
												max(VendorID),
												-- max(VendorConnectionName),
												max(EndDate),
												max(OneOffCost),
												max(MonthlyCost),
												max(CostPerCall),
												max(CostPerMinute),
												max(SurchargePerCall),
												max(SurchargePerMinute),
												max(OutpaymentPerCall),
												max(OutpaymentPerMinute),
												max(Surcharges),
												max(Chargeback),
												max(CollectionCostAmount),
												max(CollectionCostPercentage),
												max(RegistrationCostPerNumber),
												max(OneOffCostCurrency),
												max(MonthlyCostCurrency),
												max(CostPerCallCurrency),
												max(CostPerMinuteCurrency),
												max(SurchargePerCallCurrency),
												max(SurchargePerMinuteCurrency),
												max(OutpaymentPerCallCurrency),
												max(OutpaymentPerMinuteCurrency),
												max(SurchargesCurrency),
												max(ChargebackCurrency),
												max(CollectionCostAmountCurrency),
												max(RegistrationCostPerNumberCurrency),
												sum(Total)

      from tmp_tblRateTableDIDRate
      group by AccessType ,CountryID ,City ,Tariff,OriginationCode,Code ,VendorConnectionID,TimezonesID;	-- Added OriginationCode Unlike LCR , will add OriginationCode now onwards quries.





		-- select * from tmp_table_output_1; -- TEST

		-- LEAVE GenerateRateTable; -- TEST


/*			There will be only 2 scenarios as per Sumera confirms,

			-------------------------------------
			Package		Vendor		Select
			-------------------------------------
			Package1	Vendor1		1
			Package2	Vendor1		1
			Package3	Vendor1		1
			Package4	Vendor1		1
			Package5	Vendor1		1

			Package1	Vendor2		1
			Package2	Vendor2		0
			Package3	Vendor2		0
			Package4	Vendor2		0
			Package5	Vendor2		0

			Package1	Vendor3		1
			Package2	Vendor3		0
			Package3	Vendor3		1
			Package4	Vendor3		1
			Package5	Vendor3		0

			-------------------------------------
			Scenario 1
				No records
			Note: In this case all package rates will come from all vendors.


			Scenario 2
			-------------------------------------
			Package		Vendor
			-------------------------------------
			Package1	Vendor1
			All			Vendor2 Vendor3 Vendor4

			Note: In this case Fax2Email package rates will come from Bics and other packages will come from Telecom2, PCCW, Ziggo.

		*/




		SET @v_rowCount_  = ( select count(*) from tmp_RateGeneratorVendors_ );

		IF @v_rowCount_ > 0 THEN

			-- NOTE: OriginationCode is not added in tblRateGeneratorVendors (tmp_RateGeneratorVendors_)
			INSERT INTO tmp_accounts2 ( VendorID , AccessType, CountryID, City,  Tariff, OriginationCode, Code )
			SELECT DISTINCT VendorID , AccessType, CountryID, City,  Tariff, OriginationCode, Code
			FROM tmp_table_output_1 GROUP BY VendorID , AccessType, CountryID, City,  Tariff, OriginationCode,  Code;

			INSERT INTO tmp_accounts2_dup
			SELECT * FROM tmp_accounts2;

				-- add packages not exists in rate table . for a scenario
				/*Case 1
				RG Pos :2
				Custom : 			Daotec			( daotec has no custom rates )
				All		 : 			Zigo Daote
				*/
				INSERT INTO tmp_accounts2 ( VendorID , AccessType, CountryID, City,  Tariff, OriginationCode, Code )
					select
						v.VendorID , v.AccessType, v.CountryID, v.City,  v.Tariff, a.OriginationCode,  v.Code
					from (
								 select
									 a.AccountID as VendorID , rgv.AccessType, rgv.CountryID, rgv.City,  rgv.Tariff, concat(c.Prefix,rgv.Prefix) as Code
								 FROM tmp_RateGeneratorVendors_ rgv
									 inner join tblCountry c on c.CountryID = rgv.CountryID
									 INNER JOIN tblAccount a ON (fn_IsEmpty(rgv.Vendors) OR FIND_IN_SET(a.AccountID,rgv.Vendors) != 0 ) AND a.IsVendor = 1 AND a.Status = 1
								 where rgv.Vendors is not null
						 ) v
						LEFT JOIN tmp_accounts2_dup a  on v.VendorID = a.VendorID
																							AND v.AccessType = a.AccessType
																							AND v.CountryID = a.CountryID
																							AND v.City = a.City
																							AND v.Tariff = a.Tariff
																							AND v.Code = a.Code
																							-- AND v.OriginationCode = a.OriginationCode -- NOTE: OriginationCode is not added in tblRateGeneratorVendors (tmp_RateGeneratorVendors_)
					where a.ID is   null;




				SET @v_pointer_ = 1;

				-- need to add tiemzone in rate rule.
				WHILE @v_pointer_ <= @v_rowCount_
				DO

						SET @v_RateGeneratorVendorsID = (SELECT RateGeneratorVendorsID FROM tmp_RateGeneratorVendors_  WHERE RateGeneratorVendorsID = @v_pointer_);

						-- NOTE: OriginationCode is not added in tblRateGeneratorVendors (tmp_RateGeneratorVendors_)

						truncate table tmp_SelectVendorsWithDID_dup;
						insert into tmp_SelectVendorsWithDID_dup
						select * from tmp_SelectVendorsWithDID_;

 						truncate table tmp_SelectVendorsWithDID_;
						INSERT INTO tmp_SelectVendorsWithDID_ ( VendorID ,CountryID, AccessType, Code, City,  Tariff,   IsSelected )
						select	a.VendorID ,  a.CountryID,a.AccessType, a.Code, a.City,  a.Tariff,  1 as IsSelected
						FROM tmp_accounts2 a
						inner join tblRate r on a.Code = r.Code
						inner join tblCodeDeck cd on cd.CodeDeckId = r.CodeDeckId AND cd.Type  = @v_RateTypeID
						inner join tblCountry c on c.CountryID = r.CountryID
						inner JOIN tmp_RateGeneratorVendors_  v on v.RateGeneratorVendorsID = @v_RateGeneratorVendorsID
														AND ( fn_IsEmpty(v.Vendors)  OR FIND_IN_SET(a.VendorID,v.Vendors) != 0 /*a.VendorID = v.VendorID*/ )
														AND ( fn_IsEmpty(v.AccessType) OR a.AccessType = v.AccessType )
														AND ( fn_IsEmpty(v.CountryID) OR a.CountryID = v.CountryID )
														AND ( fn_IsEmpty(v.City) OR a.City = v.City )
														AND ( fn_IsEmpty(v.Tariff) OR a.Tariff = v.Tariff )
														AND ( fn_IsEmpty(v.Prefix)   OR (a.Code  = concat(c.Prefix ,v.Prefix) ) )
														-- AND ( fn_IsEmpty(v.Code) OR a.Tariff = v.Code )
						left  JOIN tmp_SelectVendorsWithDID_dup  vd on
															(fn_IsEmpty(vd.AccessType) OR  a.AccessType = vd.AccessType)
														AND   (fn_IsEmpty(vd.CountryID) OR   a.CountryID = vd.CountryID)
														AND   (fn_IsEmpty(vd.City) OR  a.City = vd.City)
														AND   (fn_IsEmpty(vd.Tariff) OR  a.Tariff = vd.Tariff)
														AND   (fn_IsEmpty(vd.Code) OR  a.Code = vd.Code)
						WHERE vd.SelectVendorsWithDIDID IS NULL;
						-- ORDER BY VendorID ,CountryID, AccessType, Code, City,  Tariff,a.VendorID;



						-- truncate table tmp_table_output_2;
						insert into tmp_table_output_2 (	AccessType,CountryID,Code,City,Tariff,Total,VendorConnectionID,vPosition)
							select AccessType,CountryID,Code,City,Tariff,Total,VendorConnectionID,vPosition
							from (
									select AccessType,CountryID,Code,City,Tariff,Total,VendorConnectionID,
									@vPosition := (
										CASE WHEN (@prev_Code = Code AND  @prev_AccessType    = AccessType AND  @prev_CountryID = CountryID AND  @prev_City    = City AND  @prev_Tariff = Tariff AND @prev_Total <  Total AND  (@v_percentageRate_ = 0 OR  (@prev_Total > 0 and  fn_Round( (((Total - @prev_Total) /  @prev_Total) * 100), 2 ) > @v_percentageRate_) ) )  THEN  @vPosition + 1
										WHEN (@prev_Code = Code AND  @prev_AccessType    = AccessType AND  @prev_CountryID = CountryID AND  @prev_City    = City AND  @prev_Tariff = Tariff AND @prev_Total <  Total AND  (@v_percentageRate_ = 0 OR  (@prev_Total > 0 and  fn_Round( (((Total - @prev_Total) /  @prev_Total) * 100), 2 ) <= @v_percentageRate_) ) )  THEN  -1		-- remove -1 records

										WHEN (@prev_Code = Code AND  @prev_AccessType    = AccessType AND  @prev_CountryID = CountryID AND  @prev_City    = City AND  @prev_Tariff = Tariff AND @prev_Total =  Total AND (@v_percentageRate_ = 0 OR  (@prev_Total > 0 and  fn_Round( (((Total - @prev_Total) /  @prev_Total) * 100), 2 ) > @v_percentageRate_) ) )  THEN  @vPosition
										WHEN (@prev_Code = Code AND  @prev_AccessType    = AccessType AND  @prev_CountryID = CountryID AND  @prev_City    = City AND  @prev_Tariff = Tariff AND @prev_Total =  Total AND (@v_percentageRate_ = 0 OR  (@prev_Total > 0 and  fn_Round( (((Total - @prev_Total) /  @prev_Total) * 100), 2 ) <= @v_percentageRate_) ) )  THEN  -1
										ELSE
											1
										END ) as  vPosition,
									@prev_AccessType := AccessType ,
									@prev_CountryID  := CountryID  ,
									@prev_City  := City  ,
									@prev_Tariff := Tariff ,
									@prev_Code  := Code  ,
									@prev_Total := Total

								from (
										select AccessType,CountryID,Code,City,Tariff,Total,VendorConnectionID
										from (
 												select AccessType ,CountryID ,City ,Tariff,Code ,VendorConnectionID,VendorID ,sum(Total) as Total
												from tmp_table_output_1
												group by AccessType ,CountryID ,City ,Tariff,Code ,VendorConnectionID,VendorID
										) drtr1
										INNER JOIN tmp_SelectVendorsWithDID_  vd on
														drtr1.VendorID = vd.VendorID
														AND drtr1.AccessType = vd.AccessType
														AND   drtr1.CountryID = vd.CountryID
														AND   drtr1.City = vd.City
														AND   drtr1.Tariff = vd.Tariff
														AND   drtr1.Code = vd.Code

									) tmp

									,(SELECT  @vPosition := 0 , @prev_TimezonesID := '' , @prev_AccessType := '' ,@prev_CountryID  := '' ,@prev_City  := '' ,@prev_Tariff := '' ,@prev_OriginationCode  := '',  @prev_Code  := ''  , @prev_VendorConnectionID  := '', @prev_Total := 0 ) t
							         ORDER BY AccessType,CountryID,Code,City,Tariff,Total,VendorConnectionID

							) tmp
							where vPosition  <= @v_RatePosition_ AND vPosition != -1;


						SET @v_pointer_ = @v_pointer_ + 1;

				END WHILE;


		ELSE


						-- truncate table tmp_table_output_2;
						insert into tmp_table_output_2 (AccessType,CountryID,Code,City,Tariff,Total,VendorConnectionID,vPosition)
							select AccessType,CountryID,Code,City,Tariff,Total,VendorConnectionID,vPosition
							from (
										 select
											 AccessType,CountryID,Code,City,Tariff,Total,VendorConnectionID,
											 @vPosition := (
												 CASE WHEN (@prev_Code = Code AND  @prev_AccessType    = AccessType AND  @prev_CountryID = CountryID AND  @prev_City    = City AND  @prev_Tariff = Tariff AND @prev_Total <  Total AND  (@v_percentageRate_ = 0 OR  (@prev_Total > 0 and  fn_Round( (((Total - @prev_Total) /  @prev_Total) * 100), 2 ) > @v_percentageRate_) ) )  THEN  @vPosition + 1
												 WHEN (@prev_Code = Code AND  @prev_AccessType    = AccessType AND  @prev_CountryID = CountryID AND  @prev_City    = City AND  @prev_Tariff = Tariff AND @prev_Total <  Total AND  (@v_percentageRate_ = 0 OR  (@prev_Total > 0 and  fn_Round( (((Total - @prev_Total) /  @prev_Total) * 100), 2 ) <= @v_percentageRate_) ) )  THEN  -1		-- remove -1 records

												 WHEN (@prev_Code = Code AND  @prev_AccessType    = AccessType AND  @prev_CountryID = CountryID AND  @prev_City    = City AND  @prev_Tariff = Tariff AND @prev_Total =  Total AND (@v_percentageRate_ = 0 OR  (@prev_Total > 0 and  fn_Round( (((Total - @prev_Total) /  @prev_Total) * 100), 2 ) > @v_percentageRate_) ) )  THEN  @vPosition
												 WHEN (@prev_Code = Code AND  @prev_AccessType    = AccessType AND  @prev_CountryID = CountryID AND  @prev_City    = City AND  @prev_Tariff = Tariff AND @prev_Total =  Total AND (@v_percentageRate_ = 0 OR  (@prev_Total > 0 and  fn_Round( (((Total - @prev_Total) /  @prev_Total) * 100), 2 ) <= @v_percentageRate_) ) )  THEN  -1
												 ELSE
													 1
												 END) as  vPosition,
											 @prev_AccessType := AccessType ,
											 @prev_CountryID  := CountryID  ,
											 @prev_City  := City  ,
											 @prev_Tariff := Tariff ,
											 @prev_Code  := Code  ,
											 @prev_Total := Total

										 from (
 												select AccessType ,CountryID ,City ,Tariff,Code ,VendorConnectionID ,sum(Total) as Total
												from tmp_table_output_1
												group by AccessType ,CountryID ,City ,Tariff,Code ,VendorConnectionID
										 ) tmp2
											 ,(SELECT  @vPosition := 0 , @prev_TimezonesID := '' , @prev_AccessType := '' ,@prev_CountryID  := '' ,@prev_City  := '' ,@prev_Tariff := '' ,@prev_OriginationCode  := '', @prev_Code  := ''  , @prev_VendorConnectionID  := '', @prev_Total := 0 ) t
								         ORDER BY AccessType,CountryID,Code,City,Tariff,Total,VendorConnectionID


									 ) tmp
							where vPosition  <= @v_RatePosition_ AND vPosition != -1;

						-- SET @v_max_position = (select max(vPosition)  from tmp_table_output_2   limit 1 );
						-- SET @v_SelectedVendorConnectionID = ( select VendorConnectionID from tmp_table_output_2 where vPosition = @v_max_position order by AccessType ,CountryID ,City ,Tariff,Code ,TimezonesID,Total limit 1 );







		END IF;

		insert into tmp_SelectedVendorPerRow ( AccessType,CountryID,Code,City,Tariff,VendorConnectionID,vPosition )
		select AccessType,CountryID,Code,City,Tariff,VendorConnectionID,vPosition
		from (
				select AccessType,CountryID,Code,City,Tariff,Total,VendorConnectionID,
					@vPosition := (
					CASE WHEN ( @prev_Code = Code AND  @prev_AccessType    = AccessType AND  @prev_CountryID = CountryID AND  @prev_City    = City AND  @prev_Tariff = Tariff AND @prev_Total >=  Total )
					THEN
							@vPosition + 1
						ELSE
							1
						END 
					) as  vPosition,
					@prev_AccessType := AccessType ,
					@prev_CountryID  := CountryID  ,
					@prev_City  := City  ,
					@prev_Tariff := Tariff ,
					@prev_Code  := Code  ,
					@prev_Total := Total

				from  tmp_table_output_2
					,(SELECT  @vPosition := 0 , @prev_TimezonesID := '' , @prev_AccessType := '' ,@prev_CountryID  := '' ,@prev_City  := '' ,@prev_Tariff := '' ,@prev_Code  := ''  , @prev_VendorConnectionID  := '', @prev_Total := 0 ) t
				-- order by AccessType ,CountryID ,City ,Tariff,OriginationCode,Code ,TimezonesID,Total desc
				ORDER BY AccessType,CountryID,Code,City,Tariff,Total,VendorConnectionID desc
			) tmp
		where vPosition = 1 ;
						


		-- LEAVE GenerateRateTable;
		insert into tmp_SelectedVendortblRateTableDIDRate
		(
			RateTableID, TimezonesID, TimezoneTitle, CodeDeckId, CountryID, AccessType, CountryPrefix, City, Tariff, Code, OriginationCode,
			VendorConnectionID,  VendorID, EndDate, OneOffCost, MonthlyCost, CostPerCall, CostPerMinute, SurchargePerCall,
			SurchargePerMinute, OutpaymentPerCall, OutpaymentPerMinute, Surcharges, Chargeback, CollectionCostAmount, CollectionCostPercentage,
			RegistrationCostPerNumber, OneOffCostCurrency, MonthlyCostCurrency, CostPerCallCurrency, CostPerMinuteCurrency, SurchargePerCallCurrency,
			SurchargePerMinuteCurrency, OutpaymentPerCallCurrency, OutpaymentPerMinuteCurrency, SurchargesCurrency, ChargebackCurrency, CollectionCostAmountCurrency,
			RegistrationCostPerNumberCurrency
		)
		select
			RateTableID,
			TimezonesID,
			TimezoneTitle,
			CodeDeckId,
			a.CountryID,
			a.AccessType,
			a.CountryPrefix,
			a.City,
			a.Tariff,
			a.Code,
			a.OriginationCode,
			a.VendorConnectionID,
			a.VendorID,
			EndDate,

			IFNULL(OneOffCost,0),
			IFNULL(MonthlyCost,0),
			IFNULL(CostPerCall,0),
			IFNULL(CostPerMinute,0),
			IFNULL(SurchargePerCall,0),
			IFNULL(SurchargePerMinute,0),
			IFNULL(OutpaymentPerCall,0),
			IFNULL(OutpaymentPerMinute,0),
			IFNULL(Surcharges,0),
			IFNULL(Chargeback,0),
			IFNULL(CollectionCostAmount,0),
			IFNULL(CollectionCostPercentage,0),
			IFNULL(RegistrationCostPerNumber,0),

			OneOffCostCurrency,
			MonthlyCostCurrency,
			CostPerCallCurrency,
			CostPerMinuteCurrency,
			SurchargePerCallCurrency,
			SurchargePerMinuteCurrency,
			OutpaymentPerCallCurrency,
			OutpaymentPerMinuteCurrency,
			SurchargesCurrency,
			ChargebackCurrency,
			CollectionCostAmountCurrency,
			RegistrationCostPerNumberCurrency

		from tmp_table_output_1 a
		INNER JOIN tmp_SelectedVendorPerRow v
		where a.AccessType 				=   v.AccessType AND
			a.CountryID 				=   v.CountryID AND
			a.Code 						=   v.Code AND
			a.City 						=   v.City AND
			a.Tariff 					=   v.Tariff AND
			a.VendorConnectionID 		=   v.VendorConnectionID;
			



			-- SELECT * from tmp_SelectedVendortblRateTableDIDRate;  -- TEST

			-- LEAVE GenerateRateTable;


			DROP TEMPORARY TABLE IF EXISTS tmp_MergeComponents;
			CREATE TEMPORARY TABLE tmp_MergeComponents (
				ID int auto_increment,
				Component TEXT  ,
				Origination TEXT  ,
				ToOrigination TEXT  ,
				TimezonesID INT(11)   ,
				ToTimezonesID INT(11)   ,
				Action CHAR(4)    ,
				MergeTo TEXT  ,
				FromCountryID INT(11)   ,
				ToCountryID INT(11)   ,
				FromAccessType VARCHAR(50)    ,
				ToAccessType VARCHAR(50)    ,
				FromPrefix VARCHAR(50)    ,
				ToPrefix VARCHAR(50)    ,
				FromCity VARCHAR(50)    ,
				FromTariff VARCHAR(50)    ,
				ToCity VARCHAR(50)    ,
				ToTariff VARCHAR(50)    ,
				primary key (ID)
			);

			insert into tmp_MergeComponents (
									Component,
									Origination,
									ToOrigination,
									TimezonesID,
									ToTimezonesID,
									Action,
									MergeTo,
									FromCountryID,
									ToCountryID,
									FromAccessType,
									ToAccessType,
									FromPrefix,
									ToPrefix,
									FromCity,
									FromTariff,
									ToCity,
									ToTariff

			)
			select
									Component,
									IFNULL(Origination,''),
									IFNULL(ToOrigination,''),
									IFNULL(TimezonesID,0),
									IFNULL(ToTimezonesID,0),
									Action,
									MergeTo,
									IFNULL(FromCountryID,0),
									IFNULL(ToCountryID,0),
									IFNULL(FromAccessType,''),
									IFNULL(ToAccessType,''),
									IFNULL(FromPrefix,''),
									IFNULL(ToPrefix,''),
									IFNULL(FromCity,''),
									IFNULL(FromTariff,''),
									IFNULL(ToCity,''),
									IFNULL(ToTariff,'')

			from tblRateGeneratorCostComponent
			where RateGeneratorId = @p_RateGeneratorId
			order by CostComponentID asc;



		DROP TEMPORARY TABLE IF EXISTS tmp_dup_SelectedVendortblRateTableDIDRate;
		CREATE TEMPORARY TABLE tmp_dup_SelectedVendortblRateTableDIDRate LIKE tmp_SelectedVendortblRateTableDIDRate;
		INSERT INTO tmp_dup_SelectedVendortblRateTableDIDRate SELECT * FROM tmp_SelectedVendortblRateTableDIDRate;


		-- ####################################
		-- margin component  starts
		-- ####################################

		-- SET @ALL_TIMEZONES_EXCEPT_DEFAULT = ( select group_concat(distinct TimezonesID) from  tblTimezones WHERE TimezonesID != @v_default_TimezonesID );

	 	SET @v_pointer_ = 1;
		SET @v_rowCount_ = ( SELECT COUNT(*) FROM tmp_Raterules_ );

		WHILE @v_pointer_ <= @v_rowCount_
		DO

			-- SET @v_rateRuleId_ = ( SELECT rateruleid FROM tmp_Raterules_ rr WHERE rr.RowNo = @v_pointer_ );

/*

			RATE RULE = EMPTY/DEFAULT

				COST COMPOENT VALUE OF DEFAULT = (
							IF !DEFAULT COST COMPOENT VALUE > 0 (COST COMPOENT OF OTHER THAN DEFAULT TIME OF DAYS ( PEAK / OFF PEAK / WEEK END ))
								DONT APPLY MARGIN
							ELSE 
								DONT APPLY MARGIN
				)

			Whenever there is Default/All Timezone selected in Rule.
			And when we need to apply rates for Default first of all check if there are values
			for all other timezone (for selected cost component and conditions) then the rule should not apply on default.
			If there are no values in any of timezones then only value should be filled in Default timezone, and skip other timezones for that perticular rule.

       Check if Default has a value

		a. If so: Apply rule

		b. If not: Check other time zone

		i. If no values in all other time zones: Apply rule

		ii. If values are present in other time zone: Do not apply rule to Default, only to other time zones
	

	Please note this has to be applied per origin.


			Data: 
			Timezone	AnyCostComponent
			1				0
			2				0
			3				0

			Rules
			Timezone		Margin
				1			200p
			
			Output:
			Timezone	AnyCostComponent
			1				0
			---------------------------------------
			Data: 
			Timezone	AnyCostComponent
			1				0
			2				0
			3				0

			Rules
			Timezone		Margin
				All			200p
			
			Output:
			Timezone	AnyCostComponent
			1				0
			---------------------------------------
			Data: 
			Timezone	AnyCostComponent
			1				0
			2				10
			3				10

			Rules
			Timezone		Margin
				1			200p
			
			Output:
			blank
			---------------------------------------
			Data: 
			Timezone	AnyCostComponent
			1				0
			2				10
			3				10

			Rules
			Timezone		Margin
				All			200p
			
			Output:
			Timezone	AnyCostComponent
			2				10
			3				10




*/
 
											
				SELECT rateruleid, TimezonesID,Component INTO @v_rateRuleId_, @v_M_TimezoneID, @v_M_Component FROM tmp_Raterules_ rr WHERE rr.RowNo = @v_pointer_ ;

				TRUNCATE TABLE tmp_RatesForMarginRule;
				INSERT INTO tmp_RatesForMarginRule (
							TimezonesID,
							OriginationCode,
							CountryID,
							AccessType,
							Code,
							City,
							Tariff,
							OneOffCost,
							MonthlyCost,
							CostPerCall,
							CostPerMinute,
							SurchargePerCall,
							SurchargePerMinute,
							OutpaymentPerCall,
							OutpaymentPerMinute,
							Surcharges,
							Chargeback,
							CollectionCostAmount,
							CollectionCostPercentage,
							RegistrationCostPerNumber
				)
				select 
							rt.TimezonesID,
							rt.OriginationCode,
							rt.CountryID,
							rt.AccessType,
							rt.Code,
							rt.City,
							rt.Tariff, 
							rt.OneOffCost,
							rt.MonthlyCost,
							rt.CostPerCall,
							rt.CostPerMinute,
							rt.SurchargePerCall,
							rt.SurchargePerMinute,
							rt.OutpaymentPerCall,
							rt.OutpaymentPerMinute,
							rt.Surcharges,
							rt.Chargeback,
							rt.CollectionCostAmount,
							rt.CollectionCostPercentage,
							rt.RegistrationCostPerNumber

				from tmp_dup_SelectedVendortblRateTableDIDRate rt
				inner join tmp_Raterules_ rr on rr.RowNo  = @v_pointer_
				and ( fn_IsEmpty(rr.TimezonesID) OR rr.TimezonesID  = rt.TimezonesID )
				and (  fn_IsEmpty(rr.Origination) OR rr.Origination = rt.OriginationCode )
				AND (  fn_IsEmpty(rr.CountryID) OR rt.CountryID = 	rr.CountryID )
				AND (  fn_IsEmpty(rr.AccessType) OR rt.AccessType = 	rr.AccessType )
				AND (  fn_IsEmpty(rr.Prefix)  OR rt.Code = 	concat(rt.CountryPrefix ,TRIM(LEADING '0' FROM rr.Prefix)) )
				AND (  fn_IsEmpty(rr.City) OR rt.City = 	rr.City )
				AND (  fn_IsEmpty(rr.Tariff) OR rt.Tariff = 	rr.Tariff );




				if( fn_IsEmpty(@v_M_TimezoneID) OR @v_M_TimezoneID = @v_default_TimezonesID ) THEN




						DROP TEMPORARY TABLE IF EXISTS TMP_TABLE2;
						CREATE TEMPORARY TABLE TMP_TABLE2 LIKE tmp_dup_SelectedVendortblRateTableDIDRate;
						INSERT INTO TMP_TABLE2 SELECT rt.* FROM tmp_dup_SelectedVendortblRateTableDIDRate rt

									inner join tmp_Raterules_ rr on rr.RowNo  = @v_pointer_
									-- AND rt.TimezonesID != @v_default_TimezonesID
									-- and ( fn_IsEmpty(rr.TimezonesID) OR rr.TimezonesID  = rt.TimezonesID )
									-- and (  fn_IsEmpty(rr.Origination) OR rr.Origination = rt.OriginationCode )
									AND (  fn_IsEmpty(rr.CountryID) OR rt.CountryID = 	rr.CountryID )
									AND (  fn_IsEmpty(rr.AccessType) OR rt.AccessType = 	rr.AccessType )
									AND (  fn_IsEmpty(rr.Prefix)  OR rt.Code = 	concat(rt.CountryPrefix ,TRIM(LEADING '0' FROM rr.Prefix)) )
									AND (  fn_IsEmpty(rr.City) OR rt.City = 	rr.City )
									AND (  fn_IsEmpty(rr.Tariff) OR rt.Tariff = 	rr.Tariff );



					-- when one recors of default is not empty
						

						-- 2. Remove all zero rates  ( with all origination ). (TimezonesID ,CountryID,AccessType,Code,City,Tariff)
						DELETE t1 FROM tmp_RatesForMarginRule t1
						inner join (

								--  1. Take all default rates (TimezonesID,OriginationCode,CountryID,AccessType,Code,City,Tariff)

									select distinct TimezonesID,OriginationCode,CountryID,AccessType,Code,City,Tariff
									from TMP_TABLE2 
									
									where
									 TimezonesID = @v_default_TimezonesID
									AND (
										(@v_M_Component = 'OneOffCost' AND ( !fn_IsEmpty(OneOffCost) )) OR		-- just to fix issues blank value due to single value per row (TimezonesID,CountryID,AccessType,Code,City,Tariff) if margin is present in rule it should be applied
										(@v_M_Component = 'MonthlyCost' AND ( !fn_IsEmpty(MonthlyCost) )) OR
										(@v_M_Component = 'CostPerCall' AND ( !fn_IsEmpty(CostPerCall) )) OR
										(@v_M_Component = 'CostPerMinute' AND ( !fn_IsEmpty(CostPerMinute) )) OR
										(@v_M_Component = 'SurchargePerCall' AND ( !fn_IsEmpty(SurchargePerCall) )) OR
										(@v_M_Component = 'SurchargePerMinute' AND ( !fn_IsEmpty(SurchargePerMinute) )) OR
										(@v_M_Component = 'OutpaymentPerCall' AND ( !fn_IsEmpty(OutpaymentPerCall) )) OR
										(@v_M_Component = 'OutpaymentPerMinute' AND ( !fn_IsEmpty(OutpaymentPerMinute) )) OR
										(@v_M_Component = 'Surcharges' AND ( !fn_IsEmpty(Surcharges) )) OR
										(@v_M_Component = 'Chargeback' AND ( !fn_IsEmpty(Chargeback) )) OR
										(@v_M_Component = 'CollectionCostAmount' AND ( !fn_IsEmpty(CollectionCostAmount) )) OR
										(@v_M_Component = 'CollectionCostPercentage' AND ( !fn_IsEmpty(CollectionCostPercentage) )) OR
										(@v_M_Component = 'RegistrationCostPerNumber' AND ( !fn_IsEmpty(RegistrationCostPerNumber) ))  
									)
							) t2 on
								t2.TimezonesID = @v_default_TimezonesID
							AND (   t2.OriginationCode != 	t1.OriginationCode )
							AND (   t2.CountryID = 	t1.CountryID )
							AND (   t2.AccessType = 	t1.AccessType )
							AND (   t2.Code = 	t1.Code )
							AND (   t2.City = 	t1.City )
							AND (   t2.Tariff = 	t1.Tariff )
							AND	(
									(@v_M_Component = 'OneOffCost' AND ( fn_IsEmpty(t1.OneOffCost) )) OR
									(@v_M_Component = 'MonthlyCost' AND ( fn_IsEmpty(t1.MonthlyCost) )) OR
									(@v_M_Component = 'CostPerCall' AND ( fn_IsEmpty(t1.CostPerCall) )) OR
									(@v_M_Component = 'CostPerMinute' AND ( fn_IsEmpty(t1.CostPerMinute) )) OR
									(@v_M_Component = 'SurchargePerCall' AND ( fn_IsEmpty(t1.SurchargePerCall) )) OR
									(@v_M_Component = 'SurchargePerMinute' AND ( fn_IsEmpty(t1.SurchargePerMinute) )) OR
									(@v_M_Component = 'OutpaymentPerCall' AND ( fn_IsEmpty(t1.OutpaymentPerCall) )) OR
									(@v_M_Component = 'OutpaymentPerMinute' AND ( fn_IsEmpty(t1.OutpaymentPerMinute) )) OR
									(@v_M_Component = 'Surcharges' AND ( fn_IsEmpty(t1.Surcharges) )) OR
									(@v_M_Component = 'Chargeback' AND ( fn_IsEmpty(t1.Chargeback) )) OR
									(@v_M_Component = 'CollectionCostAmount' AND ( fn_IsEmpty(t1.CollectionCostAmount) )) OR
									(@v_M_Component = 'CollectionCostPercentage' AND ( fn_IsEmpty(t1.CollectionCostPercentage) )) OR
									(@v_M_Component = 'RegistrationCostPerNumber' AND ( fn_IsEmpty(t1.RegistrationCostPerNumber) ))  
							);


						-- when all default records are empty and other timezones are also empty
						-- 1. if there are other timezones present against same (CountryID,AccessType,Code,City,Tariff) and they are empty
						-- YES , delete them


						DELETE t1 FROM tmp_RatesForMarginRule t1
						inner join (   
									-- when all default records are empty 
									select distinct TimezonesID,OriginationCode,CountryID,AccessType,Code,City,Tariff
									from TMP_TABLE2 
									where
									 TimezonesID = @v_default_TimezonesID
									AND (
										(@v_M_Component = 'OneOffCost' AND ( fn_IsEmpty(OneOffCost) )) OR
										(@v_M_Component = 'MonthlyCost' AND ( fn_IsEmpty(MonthlyCost) )) OR
										(@v_M_Component = 'CostPerCall' AND ( fn_IsEmpty(CostPerCall) )) OR
										(@v_M_Component = 'CostPerMinute' AND ( fn_IsEmpty(CostPerMinute) )) OR
										(@v_M_Component = 'SurchargePerCall' AND ( fn_IsEmpty(SurchargePerCall) )) OR
										(@v_M_Component = 'SurchargePerMinute' AND ( fn_IsEmpty(SurchargePerMinute) )) OR
										(@v_M_Component = 'OutpaymentPerCall' AND ( fn_IsEmpty(OutpaymentPerCall) )) OR
										(@v_M_Component = 'OutpaymentPerMinute' AND ( fn_IsEmpty(OutpaymentPerMinute) )) OR
										(@v_M_Component = 'Surcharges' AND ( fn_IsEmpty(Surcharges) )) OR
										(@v_M_Component = 'Chargeback' AND ( fn_IsEmpty(Chargeback) )) OR
										(@v_M_Component = 'CollectionCostAmount' AND ( fn_IsEmpty(CollectionCostAmount) )) OR
										(@v_M_Component = 'CollectionCostPercentage' AND ( fn_IsEmpty(CollectionCostPercentage) )) OR
										(@v_M_Component = 'RegistrationCostPerNumber' AND ( fn_IsEmpty(RegistrationCostPerNumber) ))  
									)

							)
						
						t2 on
								t1.TimezonesID IN ( select distinct TimezonesID from  tblTimezones WHERE TimezonesID != @v_default_TimezonesID )
							-- AND (   t2.OriginationCode != 	t1.OriginationCode )
							AND (   t2.CountryID = 	t1.CountryID )
							AND (   t2.AccessType = 	t1.AccessType )
							AND (   t2.Code = 	t1.Code )
							AND (   t2.City = 	t1.City )
							AND (   t2.Tariff = 	t1.Tariff )
							AND	(
									(@v_M_Component = 'OneOffCost' AND ( fn_IsEmpty(t1.OneOffCost) )) OR
									(@v_M_Component = 'MonthlyCost' AND ( fn_IsEmpty(t1.MonthlyCost) )) OR
									(@v_M_Component = 'CostPerCall' AND ( fn_IsEmpty(t1.CostPerCall) )) OR
									(@v_M_Component = 'CostPerMinute' AND ( fn_IsEmpty(t1.CostPerMinute) )) OR
									(@v_M_Component = 'SurchargePerCall' AND ( fn_IsEmpty(t1.SurchargePerCall) )) OR
									(@v_M_Component = 'SurchargePerMinute' AND ( fn_IsEmpty(t1.SurchargePerMinute) )) OR
									(@v_M_Component = 'OutpaymentPerCall' AND ( fn_IsEmpty(t1.OutpaymentPerCall) )) OR
									(@v_M_Component = 'OutpaymentPerMinute' AND ( fn_IsEmpty(t1.OutpaymentPerMinute) )) OR
									(@v_M_Component = 'Surcharges' AND ( fn_IsEmpty(t1.Surcharges) )) OR
									(@v_M_Component = 'Chargeback' AND ( fn_IsEmpty(t1.Chargeback) )) OR
									(@v_M_Component = 'CollectionCostAmount' AND ( fn_IsEmpty(t1.CollectionCostAmount) )) OR
									(@v_M_Component = 'CollectionCostPercentage' AND ( fn_IsEmpty(t1.CollectionCostPercentage) )) OR
									(@v_M_Component = 'RegistrationCostPerNumber' AND ( fn_IsEmpty(t1.RegistrationCostPerNumber) ))  
							);
				
				

						-- WHEN ONLY DEFAULTS ARE EMPTY AND OTHERS ARE NON EMPTY THEN REMOVE DEFAULT ONE
						DELETE t1 FROM tmp_RatesForMarginRule t1
						inner join (   
									select distinct TimezonesID,OriginationCode,CountryID,AccessType,Code,City,Tariff
									from TMP_TABLE2 
									where
									 TimezonesID != @v_default_TimezonesID
									AND (
										(@v_M_Component = 'OneOffCost' AND ( !fn_IsEmpty(OneOffCost) )) OR
										(@v_M_Component = 'MonthlyCost' AND ( !fn_IsEmpty(MonthlyCost) )) OR
										(@v_M_Component = 'CostPerCall' AND ( !fn_IsEmpty(CostPerCall) )) OR
										(@v_M_Component = 'CostPerMinute' AND ( !fn_IsEmpty(CostPerMinute) )) OR
										(@v_M_Component = 'SurchargePerCall' AND ( !fn_IsEmpty(SurchargePerCall) )) OR
										(@v_M_Component = 'SurchargePerMinute' AND ( !fn_IsEmpty(SurchargePerMinute) )) OR
										(@v_M_Component = 'OutpaymentPerCall' AND ( !fn_IsEmpty(OutpaymentPerCall) )) OR
										(@v_M_Component = 'OutpaymentPerMinute' AND ( !fn_IsEmpty(OutpaymentPerMinute) )) OR
										(@v_M_Component = 'Surcharges' AND ( !fn_IsEmpty(Surcharges) )) OR
										(@v_M_Component = 'Chargeback' AND ( !fn_IsEmpty(Chargeback) )) OR
										(@v_M_Component = 'CollectionCostAmount' AND ( !fn_IsEmpty(CollectionCostAmount) )) OR
										(@v_M_Component = 'CollectionCostPercentage' AND ( !fn_IsEmpty(CollectionCostPercentage) )) OR
										(@v_M_Component = 'RegistrationCostPerNumber' AND ( !fn_IsEmpty(RegistrationCostPerNumber) ))  
									)

							) t2 on
								t1.TimezonesID = @v_default_TimezonesID
							-- AND (   t2.OriginationCode != 	t1.OriginationCode )

							AND (   t2.CountryID = 	t1.CountryID )
							AND (   t2.AccessType = 	t1.AccessType )
							AND (   t2.Code = 	t1.Code )
							AND (   t2.City = 	t1.City )
							AND (   t2.Tariff = 	t1.Tariff )
							AND	(
									(@v_M_Component = 'OneOffCost' AND ( fn_IsEmpty(t1.OneOffCost) )) OR
									(@v_M_Component = 'MonthlyCost' AND ( fn_IsEmpty(t1.MonthlyCost) )) OR
									(@v_M_Component = 'CostPerCall' AND ( fn_IsEmpty(t1.CostPerCall) )) OR
									(@v_M_Component = 'CostPerMinute' AND ( fn_IsEmpty(t1.CostPerMinute) )) OR
									(@v_M_Component = 'SurchargePerCall' AND ( fn_IsEmpty(t1.SurchargePerCall) )) OR
									(@v_M_Component = 'SurchargePerMinute' AND ( fn_IsEmpty(t1.SurchargePerMinute) )) OR
									(@v_M_Component = 'OutpaymentPerCall' AND ( fn_IsEmpty(t1.OutpaymentPerCall) )) OR
									(@v_M_Component = 'OutpaymentPerMinute' AND ( fn_IsEmpty(t1.OutpaymentPerMinute) )) OR
									(@v_M_Component = 'Surcharges' AND ( fn_IsEmpty(t1.Surcharges) )) OR
									(@v_M_Component = 'Chargeback' AND ( fn_IsEmpty(t1.Chargeback) )) OR
									(@v_M_Component = 'CollectionCostAmount' AND ( fn_IsEmpty(t1.CollectionCostAmount) )) OR
									(@v_M_Component = 'CollectionCostPercentage' AND ( fn_IsEmpty(t1.CollectionCostPercentage) )) OR
									(@v_M_Component = 'RegistrationCostPerNumber' AND ( fn_IsEmpty(t1.RegistrationCostPerNumber) ))  
							);



				END IF ;
						
							update tmp_SelectedVendortblRateTableDIDRate rt
							inner join tmp_Raterules_ rr on rr.RowNo  = @v_pointer_
							inner join  tmp_RatesForMarginRule  xtemp on 
								 (  xtemp.TimezonesID  = rt.TimezonesID )
							and (   xtemp.OriginationCode = rt.OriginationCode )
							AND (   xtemp.CountryID = 	rt.CountryID )
							AND (   xtemp.AccessType = 	rt.AccessType )
							AND (   xtemp.Code = 	rt.Code)
							AND (   xtemp.City = 	rt.City )
							AND (   xtemp.Tariff = 	rt.Tariff )

 
							/*update tmp_SelectedVendortblRateTableDIDRate rt
							inner join tmp_Raterules_ rr on rr.RowNo  = @v_pointer_
							and ( fn_IsEmpty(rr.TimezonesID) OR rr.TimezonesID  = rt.TimezonesID )
							and (  fn_IsEmpty(rr.Origination) OR rr.Origination = rt.OriginationCode )
							AND (  fn_IsEmpty(rr.CountryID) OR rt.CountryID = 	rr.CountryID )
							AND (  fn_IsEmpty(rr.AccessType) OR rt.AccessType = 	rr.AccessType )
	 						AND (  fn_IsEmpty(rr.Prefix)  OR rt.Code = 	concat(rt.CountryPrefix ,TRIM(LEADING '0' FROM rr.Prefix)) )
							AND (  fn_IsEmpty(rr.City) OR rt.City = 	rr.City )
							AND (  fn_IsEmpty(rr.Tariff) OR rt.Tariff = 	rr.Tariff )
							*/

							LEFT join tblRateRuleMargin rule_mgn1 on  rule_mgn1.RateRuleId = @v_rateRuleId_
							AND
							(
								(rr.Component = 'OneOffCost' AND ( (rule_mgn1.MinRate is null AND  rule_mgn1.MaxRate is null ) OR (  rt.OneOffCost Between rule_mgn1.MinRate and rule_mgn1.MaxRate ) )  ) OR
								(rr.Component = 'MonthlyCost' AND ( (rule_mgn1.MinRate is null AND  rule_mgn1.MaxRate is null ) OR (  rt.MonthlyCost Between rule_mgn1.MinRate and rule_mgn1.MaxRate ) )  ) OR
								(rr.Component = 'CostPerCall' AND ( (rule_mgn1.MinRate is null AND  rule_mgn1.MaxRate is null ) OR (  rt.CostPerCall Between rule_mgn1.MinRate and rule_mgn1.MaxRate ) )  ) OR
								(rr.Component = 'CostPerMinute' AND ( (rule_mgn1.MinRate is null AND  rule_mgn1.MaxRate is null ) OR (  rt.CostPerMinute Between rule_mgn1.MinRate and rule_mgn1.MaxRate ) )  ) OR
								(rr.Component = 'SurchargePerCall' AND ( (rule_mgn1.MinRate is null AND  rule_mgn1.MaxRate is null ) OR (  rt.SurchargePerCall Between rule_mgn1.MinRate and rule_mgn1.MaxRate ) )  ) OR
								(rr.Component = 'SurchargePerMinute' AND ( (rule_mgn1.MinRate is null AND  rule_mgn1.MaxRate is null ) OR (  rt.SurchargePerMinute Between rule_mgn1.MinRate and rule_mgn1.MaxRate ) )  ) OR
								(rr.Component = 'OutpaymentPerCall' AND ( (rule_mgn1.MinRate is null AND  rule_mgn1.MaxRate is null ) OR (  rt.OutpaymentPerCall Between rule_mgn1.MinRate and rule_mgn1.MaxRate ) )  ) OR
								(rr.Component = 'OutpaymentPerMinute' AND ( (rule_mgn1.MinRate is null AND  rule_mgn1.MaxRate is null ) OR (  rt.OutpaymentPerMinute Between rule_mgn1.MinRate and rule_mgn1.MaxRate ) )  ) OR
								(rr.Component = 'Surcharges' AND ( (rule_mgn1.MinRate is null AND  rule_mgn1.MaxRate is null ) OR (  rt.Surcharges Between rule_mgn1.MinRate and rule_mgn1.MaxRate ) )  ) OR
								(rr.Component = 'Chargeback' AND ( (rule_mgn1.MinRate is null AND  rule_mgn1.MaxRate is null ) OR (  rt.Chargeback Between rule_mgn1.MinRate and rule_mgn1.MaxRate ) )  ) OR
								(rr.Component = 'CollectionCostAmount' AND ( (rule_mgn1.MinRate is null AND  rule_mgn1.MaxRate is null ) OR (  rt.CollectionCostAmount Between rule_mgn1.MinRate and rule_mgn1.MaxRate ) )  ) OR
								(rr.Component = 'CollectionCostPercentage' AND ( (rule_mgn1.MinRate is null AND  rule_mgn1.MaxRate is null ) OR (  rt.CollectionCostPercentage Between rule_mgn1.MinRate and rule_mgn1.MaxRate ) )  ) OR
								(rr.Component = 'RegistrationCostPerNumber' AND ( (rule_mgn1.MinRate is null AND  rule_mgn1.MaxRate is null ) OR (  rt.RegistrationCostPerNumber Between rule_mgn1.MinRate and rule_mgn1.MaxRate ) )  )


							)
							SET
                             rt.OneOffCost = CASE WHEN rr.Component = 'OneOffCost' AND rt.MarginRuleApplied_OneOffCost is null  AND rule_mgn1.RateRuleId is not null THEN
												CASE WHEN trim(IFNULL(rule_mgn1.AddMargin,"")) != '' THEN
													rt.OneOffCost + (CASE WHEN rule_mgn1.addmargin LIKE '%p' THEN ((CAST(REPLACE(rule_mgn1.addmargin, 'p', '') AS DECIMAL(18, 2)) / 100) * rt.OneOffCost) ELSE rule_mgn1.addmargin END)
												WHEN trim(IFNULL(rule_mgn1.FixedValue,"")) != '' THEN
													rule_mgn1.FixedValue
												ELSE
													rt.OneOffCost
												END
										ELSE
											rt.OneOffCost
										END,
										

							rt.MonthlyCost = CASE WHEN rr.Component = 'MonthlyCost' AND rt.MarginRuleApplied_MonthlyCost  IS NULL  AND rule_mgn1.RateRuleId is not null THEN
										CASE WHEN trim(IFNULL(rule_mgn1.AddMargin,"")) != '' THEN
											rt.MonthlyCost + (CASE WHEN rule_mgn1.addmargin LIKE '%p' THEN ((CAST(REPLACE(rule_mgn1.addmargin, 'p', '') AS DECIMAL(18, 2)) / 100) * rt.MonthlyCost) ELSE rule_mgn1.addmargin END)
										WHEN trim(IFNULL(rule_mgn1.FixedValue,"")) != '' THEN
											rule_mgn1.FixedValue
										ELSE
											rt.MonthlyCost
										END
								ELSE
								rt.MonthlyCost
								END,

							rt.CostPerCall = CASE WHEN rr.Component = 'CostPerCall' AND rt.MarginRuleApplied_CostPerCall  IS NULL  AND  rule_mgn1.RateRuleId is not null THEN
										CASE WHEN trim(IFNULL(rule_mgn1.AddMargin,"")) != '' THEN
											rt.CostPerCall + (CASE WHEN rule_mgn1.addmargin LIKE '%p' THEN ((CAST(REPLACE(rule_mgn1.addmargin, 'p', '') AS DECIMAL(18, 2)) / 100) * rt.CostPerCall) ELSE rule_mgn1.addmargin END)
										WHEN trim(IFNULL(rule_mgn1.FixedValue,"")) != '' THEN
											rule_mgn1.FixedValue
										ELSE
											rt.CostPerCall
										END
								ELSE
								rt.CostPerCall
								END,

							rt.CostPerMinute = CASE WHEN rr.Component = 'CostPerMinute' AND rt.MarginRuleApplied_CostPerMinute  IS NULL  AND rule_mgn1.RateRuleId is not null THEN
										CASE WHEN trim(IFNULL(rule_mgn1.AddMargin,"")) != '' THEN
											rt.CostPerMinute + (CASE WHEN rule_mgn1.addmargin LIKE '%p' THEN ((CAST(REPLACE(rule_mgn1.addmargin, 'p', '') AS DECIMAL(18, 2)) / 100) * rt.CostPerMinute) ELSE rule_mgn1.addmargin END)
										WHEN trim(IFNULL(rule_mgn1.FixedValue,"")) != '' THEN
											rule_mgn1.FixedValue
										ELSE
											rt.CostPerMinute
										END
								ELSE
								rt.CostPerMinute
								END,

							rt.SurchargePerCall = CASE WHEN rr.Component = 'SurchargePerCall' AND rt.MarginRuleApplied_SurchargePerCall  IS NULL  AND rule_mgn1.RateRuleId is not null THEN
										CASE WHEN trim(IFNULL(rule_mgn1.AddMargin,"")) != '' THEN
											rt.SurchargePerCall + (CASE WHEN rule_mgn1.addmargin LIKE '%p' THEN ((CAST(REPLACE(rule_mgn1.addmargin, 'p', '') AS DECIMAL(18, 2)) / 100) * rt.SurchargePerCall) ELSE rule_mgn1.addmargin END)
										WHEN trim(IFNULL(rule_mgn1.FixedValue,"")) != '' THEN
											rule_mgn1.FixedValue
										ELSE
											rt.SurchargePerCall
										END
								ELSE
								rt.SurchargePerCall
								END,

							rt.SurchargePerMinute = CASE WHEN rr.Component = 'SurchargePerMinute' AND rt.MarginRuleApplied_SurchargePerMinute  IS NULL  AND rule_mgn1.RateRuleId is not null THEN
										CASE WHEN trim(IFNULL(rule_mgn1.AddMargin,"")) != '' THEN
											rt.SurchargePerMinute + (CASE WHEN rule_mgn1.addmargin LIKE '%p' THEN ((CAST(REPLACE(rule_mgn1.addmargin, 'p', '') AS DECIMAL(18, 2)) / 100) * rt.SurchargePerMinute) ELSE rule_mgn1.addmargin END)
										WHEN trim(IFNULL(rule_mgn1.FixedValue,"")) != '' THEN
											rule_mgn1.FixedValue
										ELSE
											rt.SurchargePerMinute
										END
								ELSE
								rt.SurchargePerMinute
								END,

							rt.OutpaymentPerCall = CASE WHEN rr.Component = 'OutpaymentPerCall' AND rt.MarginRuleApplied_OutpaymentPerCall  IS NULL  AND rule_mgn1.RateRuleId is not null THEN
										CASE WHEN trim(IFNULL(rule_mgn1.AddMargin,"")) != '' THEN
											rt.OutpaymentPerCall + (CASE WHEN rule_mgn1.addmargin LIKE '%p' THEN ((CAST(REPLACE(rule_mgn1.addmargin, 'p', '') AS DECIMAL(18, 2)) / 100) * rt.OutpaymentPerCall) ELSE rule_mgn1.addmargin END)
										WHEN trim(IFNULL(rule_mgn1.FixedValue,"")) != '' THEN
											rule_mgn1.FixedValue
										ELSE
											rt.OutpaymentPerCall
										END
								ELSE
								rt.OutpaymentPerCall
								END,

							rt.OutpaymentPerMinute = CASE WHEN rr.Component = 'OutpaymentPerMinute' AND rt.MarginRuleApplied_OutpaymentPerMinute  IS NULL  AND rule_mgn1.RateRuleId is not null THEN
										CASE WHEN trim(IFNULL(rule_mgn1.AddMargin,"")) != '' THEN
											rt.OutpaymentPerMinute + (CASE WHEN rule_mgn1.addmargin LIKE '%p' THEN ((CAST(REPLACE(rule_mgn1.addmargin, 'p', '') AS DECIMAL(18, 2)) / 100) * rt.OutpaymentPerMinute) ELSE rule_mgn1.addmargin END)
										WHEN trim(IFNULL(rule_mgn1.FixedValue,"")) != '' THEN
											rule_mgn1.FixedValue
										ELSE
											rt.OutpaymentPerMinute
										END
								ELSE
								rt.OutpaymentPerMinute
								END,

							rt.Surcharges = CASE WHEN rr.Component = 'Surcharges' AND rt.MarginRuleApplied_Surcharges  IS NULL  AND rule_mgn1.RateRuleId is not null THEN
										CASE WHEN trim(IFNULL(rule_mgn1.AddMargin,"")) != '' THEN
											rt.Surcharges + (CASE WHEN rule_mgn1.addmargin LIKE '%p' THEN ((CAST(REPLACE(rule_mgn1.addmargin, 'p', '') AS DECIMAL(18, 2)) / 100) * rt.Surcharges) ELSE rule_mgn1.addmargin END)
										WHEN trim(IFNULL(rule_mgn1.FixedValue,"")) != '' THEN
											rule_mgn1.FixedValue
										ELSE
											rt.Surcharges
										END
								ELSE
								rt.Surcharges
								END,

							rt.Chargeback = CASE WHEN rr.Component = 'Chargeback' AND rt.MarginRuleApplied_Chargeback  IS NULL  AND rule_mgn1.RateRuleId is not null THEN
										CASE WHEN trim(IFNULL(rule_mgn1.AddMargin,"")) != '' THEN
											rt.Chargeback + (CASE WHEN rule_mgn1.addmargin LIKE '%p' THEN ((CAST(REPLACE(rule_mgn1.addmargin, 'p', '') AS DECIMAL(18, 2)) / 100) * rt.Chargeback) ELSE rule_mgn1.addmargin END)
										WHEN trim(IFNULL(rule_mgn1.FixedValue,"")) != '' THEN
											rule_mgn1.FixedValue
										ELSE
											rt.Chargeback
										END
								ELSE
								rt.Chargeback
								END,

							rt.CollectionCostAmount = CASE WHEN rr.Component = 'CollectionCostAmount' AND rt.MarginRuleApplied_CollectionCostAmount  IS NULL  AND rule_mgn1.RateRuleId is not null THEN
										CASE WHEN trim(IFNULL(rule_mgn1.AddMargin,"")) != '' THEN
											rt.CollectionCostAmount + (CASE WHEN rule_mgn1.addmargin LIKE '%p' THEN ((CAST(REPLACE(rule_mgn1.addmargin, 'p', '') AS DECIMAL(18, 2)) / 100) * rt.CollectionCostAmount) ELSE rule_mgn1.addmargin END)
										WHEN trim(IFNULL(rule_mgn1.FixedValue,"")) != '' THEN
											rule_mgn1.FixedValue
										ELSE
											rt.CollectionCostAmount
										END
								ELSE
								rt.CollectionCostAmount
								END,

							rt.CollectionCostPercentage = CASE WHEN rr.Component = 'CollectionCostPercentage' AND rt.MarginRuleApplied_CollectionCostPercentage  IS NULL  AND rule_mgn1.RateRuleId is not null THEN
										CASE WHEN trim(IFNULL(rule_mgn1.AddMargin,"")) != '' THEN
											rt.CollectionCostPercentage + (CASE WHEN rule_mgn1.addmargin LIKE '%p' THEN ((CAST(REPLACE(rule_mgn1.addmargin, 'p', '') AS DECIMAL(18, 2)) / 100) * rt.CollectionCostPercentage) ELSE rule_mgn1.addmargin END)
										WHEN trim(IFNULL(rule_mgn1.FixedValue,"")) != '' THEN
											rule_mgn1.FixedValue
										ELSE
											rt.CollectionCostPercentage
										END
								ELSE
								rt.CollectionCostPercentage
								END,

							rt.RegistrationCostPerNumber = CASE WHEN rr.Component = 'RegistrationCostPerNumber' AND rt.MarginRuleApplied_RegistrationCostPerNumber  IS NULL  AND rule_mgn1.RateRuleId is not null THEN
										CASE WHEN trim(IFNULL(rule_mgn1.AddMargin,"")) != '' THEN
											rt.RegistrationCostPerNumber + (CASE WHEN rule_mgn1.addmargin LIKE '%p' THEN ((CAST(REPLACE(rule_mgn1.addmargin, 'p', '') AS DECIMAL(18, 2)) / 100) * rt.RegistrationCostPerNumber) ELSE rule_mgn1.addmargin END)
										WHEN trim(IFNULL(rule_mgn1.FixedValue,"")) != '' THEN
											rule_mgn1.FixedValue
										ELSE
											rt.RegistrationCostPerNumber
										END
								ELSE
								rt.RegistrationCostPerNumber
								END,
								
								rt.MarginRuleApplied_OneOffCost =  CASE WHEN rr.Component = 'OneOffCost' AND rt.MarginRuleApplied_OneOffCost  IS NULL  AND rule_mgn1.RateRuleId is not null THEN
															CASE WHEN trim(IFNULL(rule_mgn1.AddMargin,"")) != '' THEN
																1
															WHEN trim(IFNULL(rule_mgn1.FixedValue,"")) != '' THEN
																1
															ELSE
																NULL
															END
										ELSE
											rt.MarginRuleApplied_OneOffCost
										END
											,
								
													
								rt.MarginRuleApplied_MonthlyCost = CASE WHEN rr.Component = 'MonthlyCost' AND rt.MarginRuleApplied_MonthlyCost  IS NULL  AND rule_mgn1.RateRuleId is not null THEN
										CASE WHEN trim(IFNULL(rule_mgn1.AddMargin,"")) != '' THEN
											1
										WHEN trim(IFNULL(rule_mgn1.FixedValue,"")) != '' THEN
											1
										ELSE
											NULL
										END
								ELSE
								rt.MarginRuleApplied_MonthlyCost
								END,

							rt.MarginRuleApplied_CostPerCall = CASE WHEN rr.Component = 'CostPerCall' AND rt.MarginRuleApplied_CostPerCall  IS NULL  AND  rule_mgn1.RateRuleId is not null THEN
										CASE WHEN trim(IFNULL(rule_mgn1.AddMargin,"")) != '' THEN
											1
										WHEN trim(IFNULL(rule_mgn1.FixedValue,"")) != '' THEN
											1
										ELSE
											NULL
										END
								ELSE
								rt.MarginRuleApplied_CostPerCall
								END,

							rt.MarginRuleApplied_CostPerMinute = CASE WHEN rr.Component = 'CostPerMinute' AND rt.MarginRuleApplied_CostPerMinute  IS NULL  AND rule_mgn1.RateRuleId is not null THEN
										CASE WHEN trim(IFNULL(rule_mgn1.AddMargin,"")) != '' THEN
											1
										WHEN trim(IFNULL(rule_mgn1.FixedValue,"")) != '' THEN
											1
										ELSE
											NULL
										END
								ELSE
								rt.MarginRuleApplied_CostPerMinute
								END,

							rt.MarginRuleApplied_SurchargePerCall = CASE WHEN rr.Component = 'SurchargePerCall' AND rt.MarginRuleApplied_SurchargePerCall  IS NULL  AND rule_mgn1.RateRuleId is not null THEN
										CASE WHEN trim(IFNULL(rule_mgn1.AddMargin,"")) != '' THEN
											1
										WHEN trim(IFNULL(rule_mgn1.FixedValue,"")) != '' THEN
											1
										ELSE
											NULL
										END
								ELSE
								rt.MarginRuleApplied_SurchargePerCall
								END,

							rt.MarginRuleApplied_SurchargePerMinute = CASE WHEN rr.Component = 'SurchargePerMinute' AND rt.MarginRuleApplied_SurchargePerMinute  IS NULL  AND rule_mgn1.RateRuleId is not null THEN
										CASE WHEN trim(IFNULL(rule_mgn1.AddMargin,"")) != '' THEN
											1
										WHEN trim(IFNULL(rule_mgn1.FixedValue,"")) != '' THEN
											1
										ELSE
											NULL
										END
								ELSE
								rt.MarginRuleApplied_SurchargePerMinute
								END,

							rt.MarginRuleApplied_OutpaymentPerCall = CASE WHEN rr.Component = 'OutpaymentPerCall' AND rt.MarginRuleApplied_OutpaymentPerCall  IS NULL  AND rule_mgn1.RateRuleId is not null THEN
										CASE WHEN trim(IFNULL(rule_mgn1.AddMargin,"")) != '' THEN
											1
										WHEN trim(IFNULL(rule_mgn1.FixedValue,"")) != '' THEN
											1
										ELSE
											NULL
										END
								ELSE
								rt.MarginRuleApplied_OutpaymentPerCall
								END,

							rt.MarginRuleApplied_OutpaymentPerMinute = CASE WHEN rr.Component = 'OutpaymentPerMinute' AND rt.MarginRuleApplied_OutpaymentPerMinute  IS NULL  AND rule_mgn1.RateRuleId is not null THEN
										CASE WHEN trim(IFNULL(rule_mgn1.AddMargin,"")) != '' THEN
											1
										WHEN trim(IFNULL(rule_mgn1.FixedValue,"")) != '' THEN
											1
										ELSE
											NULL
										END
								ELSE
								rt.MarginRuleApplied_OutpaymentPerMinute
								END,

							rt.MarginRuleApplied_Surcharges = CASE WHEN rr.Component = 'Surcharges' AND rt.MarginRuleApplied_Surcharges  IS NULL  AND rule_mgn1.RateRuleId is not null THEN
										CASE WHEN trim(IFNULL(rule_mgn1.AddMargin,"")) != '' THEN
											1
										WHEN trim(IFNULL(rule_mgn1.FixedValue,"")) != '' THEN
											1
										ELSE
											NULL
										END
								ELSE
								rt.MarginRuleApplied_Surcharges
								END,

							rt.MarginRuleApplied_Chargeback = CASE WHEN rr.Component = 'Chargeback' AND rt.MarginRuleApplied_Chargeback  IS NULL  AND rule_mgn1.RateRuleId is not null THEN
										CASE WHEN trim(IFNULL(rule_mgn1.AddMargin,"")) != '' THEN
											1
										WHEN trim(IFNULL(rule_mgn1.FixedValue,"")) != '' THEN
											1
										ELSE
											NULL
										END
								ELSE
								rt.MarginRuleApplied_Chargeback
								END,

							rt.MarginRuleApplied_CollectionCostAmount = CASE WHEN rr.Component = 'CollectionCostAmount' AND rt.MarginRuleApplied_CollectionCostAmount  IS NULL  AND rule_mgn1.RateRuleId is not null THEN
										CASE WHEN trim(IFNULL(rule_mgn1.AddMargin,"")) != '' THEN
											1
										WHEN trim(IFNULL(rule_mgn1.FixedValue,"")) != '' THEN
											1
										ELSE
											NULL
										END
								ELSE
								rt.MarginRuleApplied_CollectionCostAmount
								END,

							rt.MarginRuleApplied_CollectionCostPercentage = CASE WHEN rr.Component = 'CollectionCostPercentage' AND rt.MarginRuleApplied_CollectionCostPercentage  IS NULL  AND rule_mgn1.RateRuleId is not null THEN
										CASE WHEN trim(IFNULL(rule_mgn1.AddMargin,"")) != '' THEN
											1
										WHEN trim(IFNULL(rule_mgn1.FixedValue,"")) != '' THEN
											1
										ELSE
											NULL
										END
								ELSE
								rt.MarginRuleApplied_CollectionCostPercentage
								END,

							rt.MarginRuleApplied_RegistrationCostPerNumber = CASE WHEN rr.Component = 'RegistrationCostPerNumber' AND rt.MarginRuleApplied_RegistrationCostPerNumber  IS NULL  AND rule_mgn1.RateRuleId is not null THEN
										CASE WHEN trim(IFNULL(rule_mgn1.AddMargin,"")) != '' THEN
											1
										WHEN trim(IFNULL(rule_mgn1.FixedValue,"")) != '' THEN
											1
										ELSE
											NULL
										END
								ELSE
								rt.MarginRuleApplied_RegistrationCostPerNumber
								END
				;





			SET @v_pointer_ = @v_pointer_ + 1;

		END WHILE;


		-- ####################################
		-- margin component  over
		-- ####################################



		-- ####################################
		-- calculate rate starts
		-- ####################################



	 	SET @v_pointer_ = 1;
		SET @v_rowCount_ = ( SELECT COUNT(*) FROM tmp_RateGeneratorCalculatedRate_ );

		WHILE @v_pointer_ <= @v_rowCount_
		DO





						update tmp_SelectedVendortblRateTableDIDRate rt
						inner join tmp_RateGeneratorCalculatedRate_ rr on
						rr.RowNo  = @v_pointer_
						AND (fn_IsEmpty(rr.TimezonesID)  OR rr.TimezonesID  = rt.TimezonesID )
						AND (  fn_IsEmpty(rr.Origination)  OR rr.Origination = rt.OriginationCode )
						AND (  fn_IsEmpty(rr.CountryID) OR rt.CountryID = 	rr.CountryID )
						AND (  fn_IsEmpty(rr.AccessType)  OR rt.AccessType = 	rr.AccessType )
 						AND (  fn_IsEmpty(rr.Prefix)  OR rt.Code = 	concat(rt.CountryPrefix ,TRIM(LEADING '0' FROM rr.Prefix)) )
						AND (  fn_IsEmpty(rr.City)  OR rt.City = 	rr.City )
						AND (  fn_IsEmpty(rr.Tariff)  OR rt.Tariff = 	rr.Tariff )



						SET
						OneOffCost = CASE WHEN FIND_IN_SET('OneOffCost',rr.Component) != 0 AND IFNULL(OneOffCost,0) < RateLessThen AND rr.CalculatedRateID is not null THEN
						ChangeRateTo
						ELSE
						OneOffCost
						END,
						MonthlyCost = CASE WHEN FIND_IN_SET('MonthlyCost',rr.Component) != 0 AND MonthlyCost < RateLessThen AND rr.CalculatedRateID is not null THEN
						ChangeRateTo
						ELSE
						MonthlyCost
						END,
						CostPerCall = CASE WHEN FIND_IN_SET('CostPerCall',rr.Component) != 0 AND CostPerCall < RateLessThen AND rr.CalculatedRateID is not null THEN
						ChangeRateTo
						ELSE
						CostPerCall
						END,
						CostPerMinute = CASE WHEN FIND_IN_SET('CostPerMinute',rr.Component) != 0 AND CostPerMinute < RateLessThen AND rr.CalculatedRateID is not null THEN
						ChangeRateTo
						ELSE
						CostPerMinute
						END,
						SurchargePerCall = CASE WHEN FIND_IN_SET('SurchargePerCall',rr.Component) != 0 AND SurchargePerCall < RateLessThen AND rr.CalculatedRateID is not null THEN
						ChangeRateTo
						ELSE
						SurchargePerCall
						END,
						SurchargePerMinute = CASE WHEN FIND_IN_SET('SurchargePerMinute',rr.Component) != 0 AND SurchargePerMinute < RateLessThen AND rr.CalculatedRateID is not null THEN
						ChangeRateTo
						ELSE
						SurchargePerMinute
						END,
						OutpaymentPerCall = CASE WHEN FIND_IN_SET('OutpaymentPerCall',rr.Component) != 0 AND OutpaymentPerCall < RateLessThen AND rr.CalculatedRateID is not null THEN
						ChangeRateTo
						ELSE
						OutpaymentPerCall
						END,
						OutpaymentPerMinute = CASE WHEN FIND_IN_SET('OutpaymentPerMinute',rr.Component) != 0 AND OutpaymentPerMinute < RateLessThen AND rr.CalculatedRateID is not null THEN
						ChangeRateTo
						ELSE
						OutpaymentPerMinute
						END,
						Surcharges = CASE WHEN FIND_IN_SET('Surcharges',rr.Component) != 0 AND Surcharges < RateLessThen AND rr.CalculatedRateID is not null THEN
						ChangeRateTo
						ELSE
						Surcharges
						END,
						Chargeback = CASE WHEN FIND_IN_SET('Chargeback',rr.Component) != 0 AND Chargeback < RateLessThen AND rr.CalculatedRateID is not null THEN
						ChangeRateTo
						ELSE
						Chargeback
						END,
						CollectionCostAmount = CASE WHEN FIND_IN_SET('CollectionCostAmount',rr.Component) != 0 AND CollectionCostAmount < RateLessThen AND rr.CalculatedRateID is not null THEN
						ChangeRateTo
						ELSE
						CollectionCostAmount
						END,
						CollectionCostPercentage = CASE WHEN FIND_IN_SET('CollectionCostPercentage',rr.Component) != 0 AND CollectionCostPercentage < RateLessThen AND rr.CalculatedRateID is not null THEN
						ChangeRateTo
						ELSE
						CollectionCostPercentage
						END,
						RegistrationCostPerNumber = CASE WHEN FIND_IN_SET('RegistrationCostPerNumber',rr.Component) != 0 AND RegistrationCostPerNumber < RateLessThen AND rr.CalculatedRateID is not null THEN
						ChangeRateTo
						ELSE
						RegistrationCostPerNumber
						END;


			SET @v_pointer_ = @v_pointer_ + 1;

		END WHILE;


		-- ####################################
		-- calculate rate over
		-- ####################################


		-- ####################################
		-- merge component  start
		-- ####################################

		CALL prc_WSGenerateRateTableDIDMerge();
		/*
		insert into tmp_SelectedVendortblRateTableDIDRate_dup
		select * from tmp_SelectedVendortblRateTableDIDRate;

	 	SET @v_pointer_ = 1;
		SET @v_rowCount_ = ( SELECT COUNT(*) FROM tmp_MergeComponents );

		WHILE @v_pointer_ <= @v_rowCount_
		DO


				SELECT
						Component,
						Origination,
						ToOrigination,
						TimezonesID,
						ToTimezonesID,
						Action,
						MergeTo,
						FromCountryID,
						ToCountryID,
						FromAccessType,
						ToAccessType,
						TRIM(LEADING '0' FROM FromPrefix),
						TRIM(LEADING '0' FROM ToPrefix),
						FromCity,
						FromTariff,
						ToCity,
						ToTariff

				INTO

						@v_Component,
						@p_Origination,
						@v_ToOrigination,
						@p_Timezone,
						@v_ToTimezonesID,
						@v_Action,
						@v_MergeTo,
						@v_FromCountryID,
						@v_ToCountryID,
						@v_FromAccessType,
						@v_ToAccessType,
						@v_FromPrefix,
						@v_ToPrefix,
						@v_FromCity,
						@v_FromTariff,
						@v_ToCity,
						@v_ToTariff

				FROM tmp_MergeComponents WHERE ID = @v_pointer_;

				IF @v_Action = 'sum' THEN

					SET @ResultField = concat('(' ,  REPLACE(@v_Component,',',' + ') , ') ');

				ELSE

					SET @ResultField = concat('GREATEST(' ,  @v_Component, ') ');

				END IF;

				SET @stm1 = CONCAT('
						update tmp_SelectedVendortblRateTableDIDRate srt
						inner join (

								select

									TimezonesID,
									Code,
									OriginationCode,
									', @ResultField , ' as componentValue

									from tmp_SelectedVendortblRateTableDIDRate_dup

								where


								    (  fn_IsEmpty(@p_Timezone) OR  TimezonesID = @p_Timezone)
								AND (  fn_IsEmpty(@p_Origination)  OR  OriginationCode = @p_Origination)
								AND (  fn_IsEmpty(@v_FromCountryID)  OR CountryID = 	@v_FromCountryID )
								AND (  fn_IsEmpty(@v_FromAccessType)   OR AccessType = 	@v_FromAccessType )
								AND (  fn_IsEmpty(@v_FromPrefix)  OR Code = 	concat(CountryPrefix ,@v_FromPrefix) )
								AND (  fn_IsEmpty(@v_FromCity)  OR City = 	@v_FromCity )
								AND (  fn_IsEmpty(@v_FromTariff)  OR Tariff = 	@v_FromTariff )




						) tmp on
								tmp.Code = srt.Code
								AND (  fn_IsEmpty(@v_ToTimezonesID) OR  srt.TimezonesID = @v_ToTimezonesID)
								AND (  fn_IsEmpty(@v_ToOrigination)  OR  srt.OriginationCode = @v_ToOrigination)
								AND (  fn_IsEmpty(@v_ToCountryID)  OR srt.CountryID = 	@v_ToCountryID )
								AND (  fn_IsEmpty(@v_ToAccessType)   OR srt.AccessType = 	@v_ToAccessType )
								AND (  fn_IsEmpty(@v_ToPrefix)  OR srt.Code = 	concat(srt.CountryPrefix ,@v_ToPrefix) )
								AND (  fn_IsEmpty(@v_ToCity)  OR srt.City = 	@v_ToCity )
								AND (  fn_IsEmpty(@v_ToTariff)  OR srt.Tariff = 	@v_ToTariff )
						set

						' , 'new_', @v_MergeTo , ' = tmp.componentValue;
				');
				PREPARE stm1 FROM @stm1;
				EXECUTE stm1;


				IF ROW_COUNT()  = 0 THEN



						insert into tmp_SelectedVendortblRateTableDIDRate
						(
								TimezonesID,
								TimezoneTitle,
								Code,
								OriginationCode,
								VendorConnectionID,
								VendorID,
								CodeDeckId,
								CountryID,
								AccessType,
								CountryPrefix,

								City,
								Tariff,
								EndDate,
								-- VendorConnectionName,
								OneOffCost,
								MonthlyCost,
								CostPerCall,
								CostPerMinute,
								SurchargePerCall,
								SurchargePerMinute,
								OutpaymentPerCall,
								OutpaymentPerMinute,
								Surcharges,
								Chargeback,
								CollectionCostAmount,
								CollectionCostPercentage,
								RegistrationCostPerNumber,
								OneOffCostCurrency,
								MonthlyCostCurrency,
								CostPerCallCurrency,
								CostPerMinuteCurrency,
								SurchargePerCallCurrency,
								SurchargePerMinuteCurrency,
								OutpaymentPerCallCurrency,
								OutpaymentPerMinuteCurrency,
								SurchargesCurrency,
								ChargebackCurrency,
								CollectionCostAmountCurrency,
								RegistrationCostPerNumberCurrency
						)
						select
								IF(fn_IsEmpty(@v_ToTimezonesID),TimezonesID,@v_ToTimezonesID) as TimezonesID,
								TimezoneTitle,
								IF(fn_IsEmpty(@v_ToPrefix), Code, concat(CountryPrefix ,@v_ToPrefix)) as Code,
								IF(fn_IsEmpty(@v_ToOrigination),OriginationCode,@v_ToOrigination) as OriginationCode,
								VendorConnectionID,
								VendorID,
								CodeDeckId,
								IF( fn_IsEmpty(@v_ToCountryID),CountryID,@v_ToCountryID) as CountryID,
								IF(fn_IsEmpty(@v_ToAccessType),AccessType,@v_ToAccessType) as AccessType,
								CountryPrefix,
								IF(fn_IsEmpty(@v_ToCity),City,@v_ToCity) as City,
								IF(fn_IsEmpty(@v_ToTariff),Tariff,@v_ToTariff) as Tariff,
								-- VendorConnectionName,
								EndDate,
								OneOffCost,
								MonthlyCost,
								CostPerCall,
								CostPerMinute,
								SurchargePerCall,
								SurchargePerMinute,
								OutpaymentPerCall,
								OutpaymentPerMinute,
								Surcharges,
								Chargeback,
								CollectionCostAmount,
								CollectionCostPercentage,
								RegistrationCostPerNumber,
								OneOffCostCurrency,
								MonthlyCostCurrency,
								CostPerCallCurrency,
								CostPerMinuteCurrency,
								SurchargePerCallCurrency,
								SurchargePerMinuteCurrency,
								OutpaymentPerCallCurrency,
								OutpaymentPerMinuteCurrency,
								SurchargesCurrency,
								ChargebackCurrency,
								CollectionCostAmountCurrency,
								RegistrationCostPerNumberCurrency

						from tmp_table_output_1

						where
							    (  fn_IsEmpty(@p_Timezone)   OR  TimezonesID = @p_Timezone)
							AND (  fn_IsEmpty(@p_Origination)  OR  OriginationCode = @p_Origination)
							AND (  fn_IsEmpty(@v_FromCountryID)  OR CountryID = 	@v_FromCountryID )
							AND (  fn_IsEmpty(@v_FromAccessType) OR AccessType = 	@v_FromAccessType )
							AND (  fn_IsEmpty(@v_FromPrefix)  OR Code = 	concat(CountryPrefix ,@v_FromPrefix) )
							AND (  fn_IsEmpty(@v_FromCity)  OR City = 	@v_FromCity )
							AND (  fn_IsEmpty(@v_FromTariff) OR Tariff = 	@v_FromTariff );



				END IF;

				DEALLOCATE PREPARE stm1;



			SET @v_pointer_ = @v_pointer_ + 1;

		END WHILE;





		update tmp_SelectedVendortblRateTableDIDRate
		SET
			OneOffCost  = CASE WHEN new_OneOffCost is null THEN OneOffCost ELSE new_OneOffCost END ,
			MonthlyCost  = CASE WHEN new_MonthlyCost is null THEN MonthlyCost ELSE new_MonthlyCost END ,
			CostPerCall  = CASE WHEN new_CostPerCall is null THEN CostPerCall ELSE new_CostPerCall END ,
			CostPerMinute  = CASE WHEN new_CostPerMinute is null THEN CostPerMinute ELSE new_CostPerMinute END ,
			SurchargePerCall  = CASE WHEN new_SurchargePerCall is null THEN SurchargePerCall ELSE new_SurchargePerCall END ,
			SurchargePerMinute  = CASE WHEN new_SurchargePerMinute is null THEN SurchargePerMinute ELSE new_SurchargePerMinute END ,
			OutpaymentPerCall  = CASE WHEN new_OutpaymentPerCall is null THEN OutpaymentPerCall ELSE new_OutpaymentPerCall END ,
			OutpaymentPerMinute  = CASE WHEN new_OutpaymentPerMinute is null THEN OutpaymentPerMinute ELSE new_OutpaymentPerMinute END ,
			Surcharges  = CASE WHEN new_Surcharges is null THEN Surcharges ELSE new_Surcharges END ,
			Chargeback  = CASE WHEN new_Chargeback is null THEN Chargeback ELSE new_Chargeback END ,
			CollectionCostAmount  = CASE WHEN new_CollectionCostAmount is null THEN CollectionCostAmount ELSE new_CollectionCostAmount END ,
			CollectionCostPercentage  = CASE WHEN new_CollectionCostPercentage is null THEN CollectionCostPercentage ELSE new_CollectionCostPercentage END ,
			RegistrationCostPerNumber  = CASE WHEN new_RegistrationCostPerNumber is null THEN RegistrationCostPerNumber ELSE new_RegistrationCostPerNumber END ;
		*/

		-- ####################################
		-- merge component  over
		-- ####################################


		-- leave GenerateRateTable;

/*
select  AccessType,			CountryID,			OriginationCode,			Code,			City,			Tariff,			TimezoneTitle,			OneOffCost,			MonthlyCost,			CostPerCall,			CostPerMinute,			SurchargePerCall,			SurchargePerMinute,			OutpaymentPerCall,			OutpaymentPerMinute,			Surcharges,			Chargeback,			CollectionCostAmount,			CollectionCostPercentage,			RegistrationCostPerNumber
from tmp_SelectedVendortblRateTableDIDRate 		where Code = '398998408' and Tariff  = '1.22 per minute'		order by Code, TimezonesID ,OriginationCode, CountryID, AccessType, City, Tariff;
	
select  AccessType,			CountryID,			OriginationCode,			Code,			City,			Tariff,			TimezoneTitle,			OneOffCost,			MonthlyCost,			CostPerCall,			CostPerMinute,			SurchargePerCall,			SurchargePerMinute,			OutpaymentPerCall,			OutpaymentPerMinute,			Surcharges,			Chargeback,			CollectionCostAmount,			CollectionCostPercentage,			RegistrationCostPerNumber
from tmp_SelectedVendortblRateTableDIDRate 		
where Code = '3270' and Tariff  = '0.3 per minute'
order by Code, TimezonesID ,OriginationCode, CountryID, AccessType, City, Tariff;
	
select  AccessType,			CountryID,			OriginationCode,			Code,			City,			Tariff,			TimezoneTitle,			OneOffCost,			MonthlyCost,			CostPerCall,			CostPerMinute,			SurchargePerCall,			SurchargePerMinute,			OutpaymentPerCall,			OutpaymentPerMinute,			Surcharges,			Chargeback,			CollectionCostAmount,			CollectionCostPercentage,			RegistrationCostPerNumber
from tmp_SelectedVendortblRateTableDIDRate 		
where Code = '32905' and Tariff  = '2 per call'
order by Code, TimezonesID ,OriginationCode, CountryID, AccessType, City, Tariff;
*/	


		/*
			Update same MonthlyCost, OneoffCost , RegistrationCostPerNumber	 to all record across timezones.	-- Removed after confirming with Sumera 21-01-2020
		*/
		/*TRUNCATE TABLE tmp_tblRateTableDIDRate_step1_dup;
		INSERT INTO tmp_tblRateTableDIDRate_step1_dup ( VendorConnectionID,  TimezonesID, AccessType, CountryID, Code, City, Tariff, OneOffCost,MonthlyCost,RegistrationCostPerNumber )
		SELECT  VendorConnectionID,  TimezonesID, AccessType, CountryID, Code, City, Tariff, OneOffCost, MonthlyCost, RegistrationCostPerNumber
		FROM tmp_SelectedVendortblRateTableDIDRate;


		UPDATE tmp_SelectedVendortblRateTableDIDRate svr
		INNER JOIN (
				select  VendorConnectionID,  max(TimezonesID) as TimezonesID, AccessType, CountryID, Code, City, Tariff , max(MonthlyCost) as MonthlyCost
				from tmp_tblRateTableDIDRate_step1_dup
				where  MonthlyCost > 0 group by  VendorConnectionID,  AccessType, CountryID, Code, City, Tariff
			)
			svr2 on
					svr.VendorConnectionID = svr2.VendorConnectionID AND
					svr.TimezonesID != svr2.TimezonesID AND
					svr.AccessType = svr2.AccessType AND
					svr.CountryID = svr2.CountryID AND
					svr.Code = svr2.Code AND
					svr.City = svr2.City AND
					svr.Tariff = svr2.Tariff
		SET svr.MonthlyCost = svr2.MonthlyCost;

		UPDATE tmp_SelectedVendortblRateTableDIDRate svr
		INNER JOIN (
				select  VendorConnectionID,  max(TimezonesID) as TimezonesID, AccessType, CountryID, Code, City, Tariff , max(OneOffCost) as OneOffCost
				from tmp_tblRateTableDIDRate_step1_dup
				where  OneOffCost > 0 group by  VendorConnectionID,  AccessType, CountryID, Code, City, Tariff
			)
			svr2 on
					svr.VendorConnectionID = svr2.VendorConnectionID AND
					svr.TimezonesID != svr2.TimezonesID AND
					svr.AccessType = svr2.AccessType AND
					svr.CountryID = svr2.CountryID AND
					svr.Code = svr2.Code AND
					svr.City = svr2.City AND
					svr.Tariff = svr2.Tariff
		SET svr.OneOffCost = svr2.OneOffCost;

		UPDATE tmp_SelectedVendortblRateTableDIDRate svr
		INNER JOIN (
				select  VendorConnectionID,  max(TimezonesID) as TimezonesID, AccessType, CountryID, Code, City, Tariff , max(RegistrationCostPerNumber) as RegistrationCostPerNumber
				from tmp_tblRateTableDIDRate_step1_dup
				where  RegistrationCostPerNumber > 0 group by  VendorConnectionID,  AccessType, CountryID, Code, City, Tariff
			)
			svr2 on
					svr.VendorConnectionID = svr2.VendorConnectionID AND
					svr.TimezonesID != svr2.TimezonesID AND
					svr.AccessType = svr2.AccessType AND
					svr.CountryID = svr2.CountryID AND
					svr.Code = svr2.Code AND
					svr.City = svr2.City AND
					svr.Tariff = svr2.Tariff
		SET svr.RegistrationCostPerNumber = svr2.RegistrationCostPerNumber;
		*/


		SET @v_SelectedRateTableID = ( select RateTableID from tmp_SelectedVendortblRateTableDIDRate limit 1 );

		SET @v_AffectedRecords_ = 0;

		
		-- select * from tmp_SelectedVendortblRateTableDIDRate; -- TEST

		-- LEAVE GenerateRateTable; -- TEST


		START TRANSACTION;

		SET @v_RATE_STATUS_AWAITING  = 0;
		SET @v_RATE_STATUS_APPROVED  = 1;
		SET @v_RATE_STATUS_REJECTED  = 2;
		SET @v_RATE_STATUS_DELETE    = 3;

		IF @p_RateTableId = -1
		THEN

			-- SET @v_codedeckid_ = ( select CodeDeckId from tmp_SelectedVendortblRateTableDIDRate limit 1 );

			INSERT INTO tblRateTable (Type, CompanyId, RateTableName, RateGeneratorID,DIDCategoryID, TrunkID, CodeDeckId,CurrencyID,Status, RoundChargedAmount,MinimumCallCharge,AppliedTo,Reseller,created_at,updated_at, CreatedBy,ModifiedBy)
			select  @v_RateTypeID as Type, @v_CompanyId_, @p_rateTableName , @p_RateGeneratorId,DIDCategoryID, 0 as TrunkID,  CodeDeckId , @v_CurrencyID_ as  CurrencyID, Status, @v_RoundChargedAmount,MinimumCallCharge, @p_AppliedTo as AppliedTo, @p_Reseller as Reseller, now() ,now() ,@p_ModifiedBy,@p_ModifiedBy
			from tblRateTable where RateTableID = @v_SelectedRateTableID  limit 1;

			SET @p_RateTableId = LAST_INSERT_ID();

		ELSE

		/*
			UPDATE rt 
			from  tblRateTable rt
			INNER JOIN tblRateTable rt1 where rt.RateTableID = @p_RateTableId and   rt1.RateTableID = @v_SelectedRateTableID  limit 1;
				rt.Type = @v_RateTypeID ,
				rt.RateGeneratorID = @p_RateGeneratorId ,
				rt.DIDCategoryID = rt1.DIDCategoryID, 
				 CodeDeckId,CurrencyID,Status, RoundChargedAmount,MinimumCallCharge,AppliedTo,Reseller,created_at,updated_at, CreatedBy,ModifiedBy
			*/

			-- select  @v_RateTypeID as Type, @v_CompanyId_, @p_rateTableName , @p_RateGeneratorId,DIDCategoryID, 0 as TrunkID,  CodeDeckId , @v_CurrencyID_ as  CurrencyID, Status, RoundChargedAmount,MinimumCallCharge, @p_AppliedTo as AppliedTo, @p_Reseller as Reseller, now() ,now() ,@p_ModifiedBy,@p_ModifiedBy
			


			-- SET @p_RateTableId = @p_RateTableId;

				IF @p_delete_exiting_rate = 1
				THEN


						IF ( @v_RateApprovalProcess_ = 1 ) THEN

							UPDATE
								tblRateTableDIDRateAA
							SET
								EndDate = NOW()
							WHERE
								RateTableId = @p_RateTableId;

							call prc_ArchiveOldRateTableDIDRateAA(@p_RateTableId, NULL,@p_ModifiedBy);

						ELSE

							UPDATE
								tblRateTableDIDRate
							SET
								EndDate = NOW()
							WHERE
								RateTableId = @p_RateTableId;


							call prc_ArchiveOldRateTableDIDRate(@p_RateTableId, NULL,@p_ModifiedBy);
						END IF;

				END IF;



			IF (@v_RateApprovalProcess_ = 1 ) THEN


				update tblRateTableDIDRateAA rtd
				INNER JOIN tblRateTable rt  on rt.RateTableID = rtd.RateTableID
				INNER JOIN tblRate r ON rtd.RateID  = r.RateID 
				LEFT JOIN tblRate rr ON rtd.OriginationRateID  = rr.RateID
				inner join tmp_SelectedVendortblRateTableDIDRate drtr on 
								drtr.Code = r.Code 
							and	drtr.CountryID = r.CountryID
							and drtr.OriginationCode = rr.Code
							and rtd.TimezonesID = drtr.TimezonesID 
							and rtd.AccessType = drtr.AccessType 
							and rtd.City = drtr.City 
							and rtd.Tariff = drtr.Tariff 
							and  r.CodeDeckId = rr.CodeDeckId  
							AND  r.CodeDeckId = drtr.CodeDeckId

				SET rtd.EndDate = NOW()

				where
				rtd.RateTableID = @p_RateTableId and rtd.EffectiveDate = @p_EffectiveDate;


				call prc_ArchiveOldRateTableDIDRateAA(@p_RateTableId, NULL,@p_ModifiedBy);


			ELSE



					update tblRateTableDIDRate rtd
					INNER JOIN tblRateTable rt  on rt.RateTableID = rtd.RateTableID
					INNER JOIN tblRate r ON rtd.RateID  = r.RateID
					LEFT JOIN tblRate rr ON rtd.OriginationRateID  = rr.RateID
					inner join tmp_SelectedVendortblRateTableDIDRate drtr on
								drtr.Code = r.Code 
							and	drtr.CountryID = r.CountryID
							and drtr.OriginationCode = rr.Code
							and rtd.TimezonesID = drtr.TimezonesID 
							and rtd.AccessType = drtr.AccessType 
							and rtd.City = drtr.City 
							and rtd.Tariff = drtr.Tariff 
							and  r.CodeDeckId = rr.CodeDeckId 
							AND  r.CodeDeckId = drtr.CodeDeckId

					SET rtd.EndDate = NOW()

					where
					rtd.RateTableID = @p_RateTableId and rtd.EffectiveDate = @p_EffectiveDate;

					call prc_ArchiveOldRateTableDIDRate(@p_RateTableId, NULL,@p_ModifiedBy);


			END IF;

			SET @v_AffectedRecords_ = @v_AffectedRecords_ + FOUND_ROWS();


		END IF; -- IF @p_RateTableId = -1 OVER


		IF (@v_RateApprovalProcess_ = 1 ) THEN


					INSERT INTO tblRateTableDIDRateAA (
									VendorID,
									RateTableId,
									TimezonesID,
									OriginationRateID,
									RateId,
									City,
									Tariff,
									AccessType,
									OneOffCost,
									MonthlyCost,
									CostPerCall,
									CostPerMinute,
									SurchargePerCall,
									SurchargePerMinute,
									OutpaymentPerCall,
									OutpaymentPerMinute,
									Surcharges,
									Chargeback,
									CollectionCostAmount,
									CollectionCostPercentage,
									RegistrationCostPerNumber,
									OneOffCostCurrency,
									MonthlyCostCurrency,
									CostPerCallCurrency,
									CostPerMinuteCurrency,
									SurchargePerCallCurrency,
									SurchargePerMinuteCurrency,
									OutpaymentPerCallCurrency,
									OutpaymentPerMinuteCurrency,
									SurchargesCurrency,
									ChargebackCurrency,
									CollectionCostAmountCurrency,
									RegistrationCostPerNumberCurrency,
									EffectiveDate,
									EndDate,
									ApprovedStatus,

									created_at ,
									updated_at ,
									CreatedBy ,
									ModifiedBy


					)
					SELECT DISTINCT
								drtr.VendorID,
								@p_RateTableId as RateTableId,
								drtr.TimezonesID,
								IFNULL(rr.RateID,0) as OriginationRateID,
								r.RateId,
								drtr.City,
								drtr.Tariff,
								drtr.AccessType,

								drtr.OneOffCost,
								drtr.MonthlyCost,
								drtr.CostPerCall,
								drtr.CostPerMinute,
								drtr.SurchargePerCall,
								drtr.SurchargePerMinute,
								drtr.OutpaymentPerCall,
								drtr.OutpaymentPerMinute,
								drtr.Surcharges,
								drtr.Chargeback,
								drtr.CollectionCostAmount,
								drtr.CollectionCostPercentage,
								drtr.RegistrationCostPerNumber,

								drtr.OneOffCostCurrency,
								drtr.MonthlyCostCurrency,
								drtr.CostPerCallCurrency,
								drtr.CostPerMinuteCurrency,
								drtr.SurchargePerCallCurrency,
								drtr.SurchargePerMinuteCurrency,
								drtr.OutpaymentPerCallCurrency,
								drtr.OutpaymentPerMinuteCurrency,
								drtr.SurchargesCurrency,
								drtr.ChargebackCurrency,
								drtr.CollectionCostAmountCurrency,
								drtr.RegistrationCostPerNumberCurrency,


								@p_EffectiveDate as EffectiveDate,
								date(drtr.EndDate) as EndDate,
								@v_RateApprovalStatus_ as ApprovedStatus,


									now() as  created_at ,
									now() as updated_at ,
									@p_ModifiedBy as CreatedBy ,
									@p_ModifiedBy as ModifiedBy



								from tmp_SelectedVendortblRateTableDIDRate drtr
								inner join tblRateTable  rt on rt.RateTableId = drtr.RateTableId
								INNER JOIN tblRate r ON drtr.Code = r.Code and	drtr.CountryID = r.CountryID and r.CodeDeckId = drtr.CodeDeckId
								LEFT JOIN tblRate rr ON drtr.OriginationCode = rr.Code and r.CodeDeckId = rr.CodeDeckId
								LEFT join tblRateTableDIDRateAA rtd  on rtd.RateID  = r.RateID 
																    and rtd.OriginationRateID  = rr.RateID
																    and rtd.TimezonesID = drtr.TimezonesID 
																	and rtd.AccessType = drtr.AccessType 
																    and rtd.City = drtr.City 
																	and rtd.Tariff = drtr.Tariff
								and rtd.RateTableID = @p_RateTableId
								and rtd.EffectiveDate = @p_EffectiveDate
								WHERE rtd.RateTableDIDRateID is null;

		ELSE


				INSERT INTO tblRateTableDIDRate (
									VendorID,
									RateTableId,
									TimezonesID,
									OriginationRateID,
									RateId,
									City,
									Tariff,
									AccessType,
									OneOffCost,
									MonthlyCost,
									CostPerCall,
									CostPerMinute,
									SurchargePerCall,
									SurchargePerMinute,
									OutpaymentPerCall,
									OutpaymentPerMinute,
									Surcharges,
									Chargeback,
									CollectionCostAmount,
									CollectionCostPercentage,
									RegistrationCostPerNumber,
									OneOffCostCurrency,
									MonthlyCostCurrency,
									CostPerCallCurrency,
									CostPerMinuteCurrency,
									SurchargePerCallCurrency,
									SurchargePerMinuteCurrency,
									OutpaymentPerCallCurrency,
									OutpaymentPerMinuteCurrency,
									SurchargesCurrency,
									ChargebackCurrency,
									CollectionCostAmountCurrency,
									RegistrationCostPerNumberCurrency,
									EffectiveDate,
									EndDate,
									ApprovedStatus,

									created_at ,
									updated_at ,
									CreatedBy ,
									ModifiedBy


					)
					SELECT DISTINCT
								drtr.VendorID,
								@p_RateTableId as RateTableId,
								drtr.TimezonesID,
								IFNULL(rr.RateID,0) as OriginationRateID,
								r.RateId,
								drtr.City,
								drtr.Tariff,
								drtr.AccessType,


														
								drtr.OneOffCost,
								drtr.MonthlyCost,
								drtr.CostPerCall,
								drtr.CostPerMinute,
								drtr.SurchargePerCall,
								drtr.SurchargePerMinute,
								drtr.OutpaymentPerCall,
								drtr.OutpaymentPerMinute,
								drtr.Surcharges,
								drtr.Chargeback,
								drtr.CollectionCostAmount,
								drtr.CollectionCostPercentage,
								drtr.RegistrationCostPerNumber,


								drtr.OneOffCostCurrency,
								drtr.MonthlyCostCurrency,
								drtr.CostPerCallCurrency,
								drtr.CostPerMinuteCurrency,
								drtr.SurchargePerCallCurrency,
								drtr.SurchargePerMinuteCurrency,
								drtr.OutpaymentPerCallCurrency,
								drtr.OutpaymentPerMinuteCurrency,
								drtr.SurchargesCurrency,
								drtr.ChargebackCurrency,
								drtr.CollectionCostAmountCurrency,
								drtr.RegistrationCostPerNumberCurrency,


								@p_EffectiveDate as EffectiveDate,
								date(drtr.EndDate) as EndDate,
								@v_RateApprovalStatus_ as ApprovedStatus,


									now() as  created_at ,
									now() as updated_at ,
									@p_ModifiedBy as CreatedBy ,
									@p_ModifiedBy as ModifiedBy


								from tmp_SelectedVendortblRateTableDIDRate drtr
								inner join tblRateTable  rt on rt.RateTableId = drtr.RateTableId
								INNER JOIN tblRate r ON drtr.Code = r.Code and	drtr.CountryID = r.CountryID and r.CodeDeckId = drtr.CodeDeckId
								LEFT JOIN tblRate rr ON drtr.OriginationCode = rr.Code and r.CodeDeckId = rr.CodeDeckId
								LEFT join tblRateTableDIDRate rtd  on rtd.RateID  = r.RateID 
																    and rtd.OriginationRateID  = rr.RateID
																    and rtd.TimezonesID = drtr.TimezonesID 
																	and rtd.AccessType = drtr.AccessType 
																    and rtd.City = drtr.City 
																	and rtd.Tariff = drtr.Tariff
								and rtd.RateTableID = @p_RateTableId
								and rtd.EffectiveDate = @p_EffectiveDate
								WHERE rtd.RateTableDIDRateID is null;

 
		END IF;


		SET @v_AffectedRecords_ = @v_AffectedRecords_ + FOUND_ROWS();

		DROP TEMPORARY TABLE IF EXISTS tmp_EffectiveDates_;
		CREATE TEMPORARY TABLE tmp_EffectiveDates_ (
			RowID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
			EffectiveDate  Date
		);
		INSERT INTO tmp_EffectiveDates_ (EffectiveDate)
		SELECT distinct
			EffectiveDate
		FROM
		(
			select distinct EffectiveDate
			from 	tblRateTableDIDRate
			WHERE
				RateTableId = @p_RateTableId
			Group By EffectiveDate
			order by EffectiveDate desc
		) tmp
		,(SELECT @row_num := 0) x;


		SET @v_pointer_ = 1;
		SET @v_rowCount_ = ( SELECT COUNT(*) FROM tmp_EffectiveDates_ );

		IF @v_rowCount_ > 0 THEN

			WHILE @v_pointer_ <= @v_rowCount_
			DO
				SET @EffectiveDate = ( SELECT EffectiveDate FROM tmp_EffectiveDates_ WHERE RowID = @v_pointer_ );


				IF (@v_RateApprovalProcess_ = 1 ) THEN


						UPDATE  tblRateTableDIDRateAA vr1
						inner join
						(
							select
								RateTableId,
								OriginationRateID,
								RateID,
								EffectiveDate,
								TimezonesID,
								AccessType,
								City,
								Tariff
							FROM tblRateTableDIDRateAA
							WHERE RateTableId = @p_RateTableId
								AND EffectiveDate =   @EffectiveDate
							order by EffectiveDate desc
						) tmpvr
						on
							vr1.RateTableId = tmpvr.RateTableId
							AND vr1.OriginationRateID = tmpvr.OriginationRateID
							AND vr1.RateID = tmpvr.RateID
							AND vr1.TimezonesID = tmpvr.TimezonesID
							and vr1.AccessType = tmpvr.AccessType 
							AND vr1.City = tmpvr.City
							AND vr1.Tariff = tmpvr.Tariff
							AND vr1.EffectiveDate < tmpvr.EffectiveDate
						SET
							vr1.EndDate = @EffectiveDate
						where
							vr1.RateTableId = @p_RateTableId

							AND vr1.EndDate is null;

				ELSE

						UPDATE  tblRateTableDIDRate vr1
						inner join
						(
							select
								RateTableId,
								OriginationRateID,
								RateID,
								EffectiveDate,
								TimezonesID,
								AccessType,
								City,
								Tariff
							FROM tblRateTableDIDRate
							WHERE RateTableId = @p_RateTableId
								AND EffectiveDate =   @EffectiveDate
							order by EffectiveDate desc
						) tmpvr
						on
							vr1.RateTableId = tmpvr.RateTableId
							AND vr1.OriginationRateID = tmpvr.OriginationRateID
							AND vr1.RateID = tmpvr.RateID
							AND vr1.TimezonesID = tmpvr.TimezonesID
							and vr1.AccessType = tmpvr.AccessType 
							AND vr1.City = tmpvr.City
							AND vr1.Tariff = tmpvr.Tariff
							AND vr1.EffectiveDate < tmpvr.EffectiveDate
						SET
							vr1.EndDate = @EffectiveDate
						where
							vr1.RateTableId = @p_RateTableId

							AND vr1.EndDate is null;
				END IF;

				SET @v_pointer_ = @v_pointer_ + 1;

			END WHILE;

			

		END IF;

		commit;


		SELECT RoundChargedAmount INTO @v_RoundChargedAmount from tblRateTable where RateTableID = @p_RateTableId  limit 1;
		-- USE COMPANY ROUDING ONLY ....


			IF (@v_RateApprovalProcess_ = 1 ) THEN



				update tblRateTableDIDRateAA
				SET

				OneOffCost = IF(OneOffCost = 0 , NULL, fn_Round(OneOffCost,@v_RoundChargedAmount)),
				MonthlyCost = IF(MonthlyCost = 0 , NULL, fn_Round(MonthlyCost,@v_RoundChargedAmount)),
				CostPerCall = IF(CostPerCall = 0 , NULL, fn_Round(CostPerCall,@v_RoundChargedAmount)),
				CostPerMinute = IF(CostPerMinute = 0 , NULL, fn_Round(CostPerMinute,@v_RoundChargedAmount)),
				SurchargePerCall = IF(SurchargePerCall = 0 , NULL, fn_Round(SurchargePerCall,@v_RoundChargedAmount)),
				SurchargePerMinute = IF(SurchargePerMinute = 0 , NULL, fn_Round(SurchargePerMinute,@v_RoundChargedAmount)),
				OutpaymentPerCall = IF(OutpaymentPerCall = 0 , NULL, fn_Round(OutpaymentPerCall,@v_RoundChargedAmount)),
				OutpaymentPerMinute = IF(OutpaymentPerMinute = 0 , NULL, fn_Round(OutpaymentPerMinute,@v_RoundChargedAmount)),
				Surcharges = IF(Surcharges = 0 , NULL, fn_Round(Surcharges,@v_RoundChargedAmount)),
				Chargeback = IF(Chargeback = 0 , NULL, fn_Round(Chargeback,@v_RoundChargedAmount)),
				CollectionCostAmount = IF(CollectionCostAmount = 0 , NULL, fn_Round(CollectionCostAmount,@v_RoundChargedAmount)),
				CollectionCostPercentage = IF(CollectionCostPercentage = 0 , NULL, fn_Round(CollectionCostPercentage,@v_RoundChargedAmount)),
				RegistrationCostPerNumber = IF(RegistrationCostPerNumber = 0 , NULL, fn_Round(RegistrationCostPerNumber,@v_RoundChargedAmount)),
				updated_at = now(),
				ModifiedBy = @p_ModifiedBy

				where
				RateTableID = @p_RateTableId;



			ELSE


				update tblRateTableDIDRate
				SET

				OneOffCost = IF(OneOffCost = 0 , NULL, fn_Round(OneOffCost,@v_RoundChargedAmount)),
				MonthlyCost = IF(MonthlyCost = 0 , NULL, fn_Round(MonthlyCost,@v_RoundChargedAmount)),
				CostPerCall = IF(CostPerCall = 0 , NULL, fn_Round(CostPerCall,@v_RoundChargedAmount)),
				CostPerMinute = IF(CostPerMinute = 0 , NULL, fn_Round(CostPerMinute,@v_RoundChargedAmount)),
				SurchargePerCall = IF(SurchargePerCall = 0 , NULL, fn_Round(SurchargePerCall,@v_RoundChargedAmount)),
				SurchargePerMinute = IF(SurchargePerMinute = 0 , NULL, fn_Round(SurchargePerMinute,@v_RoundChargedAmount)),
				OutpaymentPerCall = IF(OutpaymentPerCall = 0 , NULL, fn_Round(OutpaymentPerCall,@v_RoundChargedAmount)),
				OutpaymentPerMinute = IF(OutpaymentPerMinute = 0 , NULL, fn_Round(OutpaymentPerMinute,@v_RoundChargedAmount)),
				Surcharges = IF(Surcharges = 0 , NULL, fn_Round(Surcharges,@v_RoundChargedAmount)),
				Chargeback = IF(Chargeback = 0 , NULL, fn_Round(Chargeback,@v_RoundChargedAmount)),
				CollectionCostAmount = IF(CollectionCostAmount = 0 , NULL, fn_Round(CollectionCostAmount,@v_RoundChargedAmount)),
				CollectionCostPercentage = IF(CollectionCostPercentage = 0 , NULL, fn_Round(CollectionCostPercentage,@v_RoundChargedAmount)),
				RegistrationCostPerNumber = IF(RegistrationCostPerNumber = 0 , NULL, fn_Round(RegistrationCostPerNumber,@v_RoundChargedAmount)),
				updated_at = now(),
				ModifiedBy = @p_ModifiedBy

				where
				RateTableID = @p_RateTableId;

			END IF;



		IF (@v_RateApprovalProcess_ = 1 ) THEN


			call prc_ArchiveOldRateTableDIDRateAA(@p_RateTableId, NULL,@p_ModifiedBy);

		ELSE

			call prc_ArchiveOldRateTableDIDRate(@p_RateTableId, NULL,@p_ModifiedBy);

		END IF;

		IF(@p_RateTableId > 0 ) THEN
		
			INSERT INTO tmp_JobLog_ (Message) VALUES (@p_RateTableId);
		
		ELSE 

			INSERT INTO tmp_JobLog_ (Message) VALUES ('No data found');
		
		END IF;
		
		SELECT * FROM tmp_JobLog_;


		SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;



	END//
DELIMITER ;
