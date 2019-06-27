use speakintelligentRM;
-- --------------------------------------------------------
-- Host:                         78.129.140.6
-- Server version:               5.7.25 - MySQL Community Server (GPL)
-- Server OS:                    Linux
-- HeidiSQL Version:             9.5.0.5196
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Dumping structure for procedure speakintelligentRM.prc_WSGenerateRateTableDID
DROP PROCEDURE IF EXISTS `prc_WSGenerateRateTableDID`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `prc_WSGenerateRateTableDID`(
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


				new_OneOffCost DECIMAL(18, 8),
				new_MonthlyCost DECIMAL(18, 8),
				new_CostPerCall DECIMAL(18, 8),
				new_CostPerMinute DECIMAL(18, 8),
				new_SurchargePerCall DECIMAL(18, 8),
				new_SurchargePerMinute DECIMAL(18, 8),
				new_OutpaymentPerCall DECIMAL(18, 8),
				new_OutpaymentPerMinute DECIMAL(18, 8),
				new_Surcharges DECIMAL(18, 8),
				new_Chargeback DECIMAL(18, 8),
				new_CollectionCostAmount DECIMAL(18, 8),
				new_CollectionCostPercentage DECIMAL(18, 8),
				new_RegistrationCostPerNumber DECIMAL(18, 8)

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

			DROP TEMPORARY TABLE IF EXISTS tmp_final_table_output;
			CREATE TEMPORARY TABLE tmp_final_table_output (

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


			/*DROP TEMPORARY TABLE IF EXISTS tmp_vendor_position;
			CREATE TEMPORARY TABLE tmp_vendor_position (
				
				

AccessType ,CountryID ,City ,Tariff,Code ,TimezonesID,VendorConnectionID,vPosition
			);*/

			DROP TEMPORARY TABLE IF EXISTS tmp_timezones;
			CREATE TEMPORARY TABLE tmp_timezones (
				ID int auto_increment,
				TimezonesID int,
				primary key (ID)
			);


			DROP TEMPORARY TABLE IF EXISTS tmp_origination_minutes;
			CREATE TEMPORARY TABLE tmp_origination_minutes (
				OriginationCode varchar(50),
				minutes int
			);


			DROP TEMPORARY TABLE IF EXISTS tmp_timezone_minutes;
			CREATE TEMPORARY TABLE tmp_timezone_minutes (
				TimezonesID int,
				VendorID int,
				AccessType varchar(200),
				CountryID int,
				City varchar(50),
				Tariff varchar(50),
				Prefix varchar(100),

				CostPerMinute DECIMAL(18,8), 
				OutpaymentPerMinute DECIMAL(18,8),
				CollectionCostAmount DECIMAL(18,8),
				minute_CostPerMinute DECIMAL(18,2), 
				minute_OutpaymentPerMinute DECIMAL(18,2),
				minute_CollectionCostAmount DECIMAL(18,2)
			);

			DROP TEMPORARY TABLE IF EXISTS tmp_accounts;
			CREATE TEMPORARY TABLE tmp_accounts (
				ID int auto_increment,
				VendorID int,
				AccessType varchar(200),
				CountryID int,
				City varchar(50),
				Tariff varchar(50),
				Prefix varchar(100),

				Primary Key (ID )

			);


			DROP TEMPORARY TABLE IF EXISTS tmp_timezone_minutes_2;
			CREATE TEMPORARY TABLE tmp_timezone_minutes_2 (
				TimezonesID int,
				VendorID int,
				AccessType varchar(200),
				CountryID int,
				City varchar(50),
				Tariff varchar(50),
				Prefix varchar(100),

				CostPerMinute DECIMAL(18,8), 
				OutpaymentPerMinute DECIMAL(18,8),
				CollectionCostAmount DECIMAL(18,8),
				minute_CostPerMinute DECIMAL(18,2), 
				minute_OutpaymentPerMinute DECIMAL(18,2),
				minute_CollectionCostAmount DECIMAL(18,2)
			);
			DROP TEMPORARY TABLE IF EXISTS tmp_timezone_minutes_3;
			CREATE TEMPORARY TABLE tmp_timezone_minutes_3 (
				TimezonesID int,
				VendorID int,
				AccessType varchar(200),
				CountryID int,
				City varchar(50),
				Tariff varchar(50),
				Prefix varchar(100),

				CostPerMinute DECIMAL(18,8), 
				OutpaymentPerMinute DECIMAL(18,8),
				CollectionCostAmount DECIMAL(18,8),
				minute_CostPerMinute DECIMAL(18,2), 
				minute_OutpaymentPerMinute DECIMAL(18,2),
				minute_CollectionCostAmount DECIMAL(18,2)
			);



			DROP TEMPORARY TABLE IF EXISTS tmp_NoOfServicesContracted;
			CREATE TEMPORARY TABLE tmp_NoOfServicesContracted (
				VendorID int,
				NoOfServicesContracted int
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

			@v_DIDCategoryID_,
			@v_Calls,
			@v_Minutes,
			@v_StartDate_ ,@v_EndDate_ ,@v_TimezonesID, @v_TimezonesPercentage, @v_Origination, @v_OriginationPercentage,


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
				IFNULL(TimeOfDay,''),
				IFNULL(CountryID,''),
				IFNULL(AccessType,''),
				IFNULL(Prefix ,''),
				IFNULL(City,''),
				IFNULL(Tariff,''),
				`Order`,
				@row_num := @row_num+1 AS RowID
			FROM tblRateRule,(SELECT @row_num := 0) x
			WHERE rategeneratorid = @p_RateGeneratorId
			ORDER BY `Order` ASC;



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
			IFNULL(TimezonesID ,''),
			RateLessThen,
			ChangeRateTo,
			IFNULL(CountryID,''),
			IFNULL(AccessType,''),
			IFNULL(Prefix ,''),
			IFNULL(City,''),
			IFNULL(Tariff,''),
			@row_num := @row_num+1 AS RowID
			FROM tblRateGeneratorCalculatedRate,(SELECT @row_num := 0) x
			WHERE RateGeneratorId = @p_RateGeneratorId
			ORDER BY CalculatedRateID ASC;


				set @v_ApprovedStatus = 1;

				set @v_DIDType = 2;

			  	set @v_AppliedToCustomer = 1;
				set @v_AppliedToVendor = 2;
				set @v_AppliedToReseller = 3;





			SET @p_Calls	 							 = @v_Calls;
			SET @p_Minutes	 							 = @v_Minutes;
			SET @v_PeakTimeZoneID	 				 = @v_TimezonesID;
			SET @p_PeakTimeZonePercentage	 		 = @v_TimezonesPercentage;
			SET @p_MobileOriginationPercentage	 = @v_OriginationPercentage ;

			SET @p_Prefix = TRIM(LEADING '0' FROM @p_Prefix);

			
			IF @p_NoOfServicesContracted = 0 THEN
			
				insert into tmp_NoOfServicesContracted (VendorID,NoOfServicesContracted)
				select VendorID,count(CLI) as NoOfServicesContracted
				from  tblCLIRateTable
				where 
					CompanyID  = @v_CompanyId_
					AND VendorID > 0
					AND Status = 1 
					AND NumberEndDate >= current_date()
					
				group by VendorID;
				
			ELSE 

				insert into tmp_NoOfServicesContracted (VendorID,NoOfServicesContracted)
				select null,@p_NoOfServicesContracted;
			
			END IF ;

			IF @p_Calls = 0 AND @p_Minutes = 0 THEN



				select count(UsageDetailID)  into @p_Calls

				from speakintelligentCDR.tblUsageDetails  d

				inner join speakintelligentCDR.tblUsageHeader h on d.UsageHeaderID = h.UsageHeaderID

				inner join speakintelligentRM.tblCountry c  on   d.CLIPrefix  like concat(c.Prefix,'%')

				where CompanyID = @v_CompanyId_ AND StartDate >= @v_StartDate_ AND StartDate <= @v_EndDate_ and d.is_inbound = 1

				AND (@p_CountryID = '' OR  c.CountryID = @p_CountryID )

				AND (@p_AccessType = '' OR d.NoType = @p_AccessType)

				AND (@p_City = '' OR d.City  = @p_City)

				AND (@p_Tariff = '' OR d.Tariff  = @p_Tariff)

				AND ( @p_Prefix = '' OR ( d.CLIPrefix   = concat(c.Prefix,  @p_Prefix )  ) );



				insert into tmp_timezone_minutes (TimezonesID, AccessType,CountryID,Prefix,City,Tariff, CostPerMinute,OutpaymentPerMinute,CollectionCostAmount)

				select TimezonesID  , d.NoType, c.CountryID, d.CLIPrefix, d.City, d.Tariff, sum(CostPerMinute), sum(OutpaymentPerMinute), sum(CollectionCostAmount) 

				from speakintelligentCDR.tblUsageDetails  d

				inner join speakintelligentCDR.tblUsageHeader h on d.UsageHeaderID = h.UsageHeaderID

				inner join speakintelligentRM.tblCountry c  on   d.CLIPrefix  like concat(c.Prefix,'%')

				where CompanyID = @v_CompanyId_ AND StartDate >= @v_StartDate_ AND StartDate <= @v_EndDate_ and d.is_inbound = 1 and TimezonesID is not null

				AND (@p_CountryID = '' OR  c.CountryID = @p_CountryID )

				AND (@p_AccessType = '' OR d.NoType = @p_AccessType)

				AND (@p_City = '' OR d.City  = @p_City)

				AND (@p_Tariff = '' OR d.Tariff  = @p_Tariff)

				AND ( @p_Prefix = '' OR ( d.CLIPrefix   = concat(c.Prefix,  @p_Prefix )  ) )

				group by TimezonesID  , d.NoType, c.CountryID, d.CLIPrefix, d.City, d.Tariff;


				insert into tmp_origination_minutes ( OriginationCode, minutes )

				select CLIPrefix  , (sum(billed_duration) / 60) as minutes

				from speakintelligentCDR.tblUsageDetails  d

				inner join speakintelligentCDR.tblUsageHeader h on d.UsageHeaderID = h.UsageHeaderID

				inner join speakintelligentRM.tblCountry c  on   d.CLIPrefix  like concat(c.Prefix,'%')

				where CompanyID = @v_CompanyId_ AND StartDate >= @v_StartDate_ AND StartDate <= @v_EndDate_ and d.is_inbound = 1 and CLIPrefix is not null

				AND (@p_CountryID = '' OR  c.CountryID = @p_CountryID )

				AND (@p_AccessType = '' OR d.NoType = @p_AccessType)

				AND (@p_City = '' OR d.City  = @p_City)

				AND (@p_Tariff = '' OR d.Tariff  = @p_Tariff)

				AND ( @p_Prefix = '' OR ( d.CLIPrefix   = concat(c.Prefix,  @p_Prefix )  ) )

				group by CLIPrefix;



			ELSE




				SET @p_MobileOrigination				 = @v_Origination ;
				-- SET @v_PeakTimeZoneMinutes				 =  ( (@p_Minutes/ 100) * @p_PeakTimeZonePercentage ) 	;
				SET @v_MinutesFromMobileOrigination  =  ( (@p_Minutes/ 100) * @p_MobileOriginationPercentage ) 	;




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

					insert into tmp_timezone_minutes ( VendorID, TimezonesID, AccessType,CountryID,Prefix,City,Tariff, CostPerMinute , OutpaymentPerMinute,CollectionCostAmount )
		
					select AccountId, TimezonesID, AccessType, CountryID, Prefix, City, Tariff , CostPerMinute, OutpaymentPerMinute, CollectionCostAmount
						from(
						
						Select DISTINCT vc.AccountId, drtr.TimezonesID, drtr.AccessType, c.CountryID,c.Prefix, drtr.City, drtr.Tariff , sum(drtr.CostPerMinute) as CostPerMinute, sum(drtr.OutpaymentPerMinute) as OutpaymentPerMinute, sum(drtr.CollectionCostAmount) as CollectionCostAmount
		
						from tblRateTableDIDRate  drtr
						inner join tblRateTable  rt on rt.RateTableId = drtr.RateTableId
						inner join tblVendorConnection vc on vc.RateTableID = rt.RateTableId and ((vc.DIDCategoryID IS NOT NULL AND rt.DIDCategoryID IS NOT NULL) AND vc.DIDCategoryID = rt.DIDCategoryID) and vc.CompanyID = rt.CompanyId  and vc.Active=1
						inner join tblAccount a on vc.AccountId = a.AccountID and rt.CompanyId = a.CompanyId
						left join tblVendorTrunkCost vtc on vtc.AccountID = a.AccountID
						inner join tblRate r on drtr.RateID = r.RateID and r.CompanyID = vc.CompanyID
						left join tblRate r2 on drtr.OriginationRateID = r2.RateID and r.CompanyID = vc.CompanyID
						inner join tblCountry c on c.CountryID = r.CountryID

						AND ( @p_CountryID = '' OR  c.CountryID = @p_CountryID )
						AND ( @p_City = '' OR drtr.City = @p_City )
						AND ( @p_Tariff = '' OR drtr.Tariff  = @p_Tariff )
						AND ( @p_Prefix = '' OR (r.Code  = concat(c.Prefix ,@p_Prefix) ) )
						AND ( @p_AccessType = '' OR drtr.AccessType = @p_AccessType )

						inner join tblTimezones t on t.TimezonesID =  drtr.TimezonesID
						where

							rt.CompanyId =  @p_companyid

							and vc.DIDCategoryID = @p_DIDCategoryID

							and drtr.ApprovedStatus = 1

							and rt.Type = @v_RateTypeID

							and rt.AppliedTo = @v_AppliedToVendor

							AND EffectiveDate <= DATE(@p_SelectedEffectiveDate)

							AND (EndDate is NULL OR EndDate > now() )

							group by AccountId, TimezonesID, AccessType, CountryID, Prefix, City, Tariff

						)	tmp ;
						




					-- SET @p_PeakTimeZonePercentage	 		 = @p_TimezonePercentage;
					-- SET @p_MobileOrigination				 = @p_Origination ;
					-- SET @p_MobileOriginationPercentage	 	 = @p_OriginationPercentage ;


					insert into tmp_timezones (TimezonesID) select TimezonesID from tblTimezones;

					SET @v_rowCount_ = ( SELECT COUNT(*) FROM tmp_timezones );

					-- // account loop

					INSERT INTO tmp_accounts ( VendorID ,AccessType,CountryID,Prefix,City,Tariff )  SELECT DISTINCT VendorID, AccessType,CountryID,Prefix,City,Tariff FROM tmp_timezone_minutes;

					SET @v_v_pointer_ = 1;

					SET @v_v_rowCount_ = ( SELECT COUNT(*) FROM tmp_accounts );

					WHILE @v_v_pointer_ <= @v_v_rowCount_
					DO

								SET @v_VendorID = ( SELECT VendorID FROM tmp_accounts WHERE ID = @v_v_pointer_ );
								SET @v_AccessType = ( SELECT AccessType FROM tmp_accounts WHERE ID = @v_v_pointer_ );
								SET @v_CountryID = ( SELECT CountryID FROM tmp_accounts WHERE ID = @v_v_pointer_ );
								SET @v_Prefix = ( SELECT Prefix FROM tmp_accounts WHERE ID = @v_v_pointer_ );
								SET @v_City = ( SELECT City FROM tmp_accounts WHERE ID = @v_v_pointer_ );
								SET @v_Tariff = ( SELECT Tariff FROM tmp_accounts WHERE ID = @v_v_pointer_ );
 
 								
								UPDATE  tmp_timezone_minutes SET minute_CostPerMinute =  ( (@p_Minutes/ 100) * @p_PeakTimeZonePercentage )
								WHERE  TimezonesID = @p_Timezone AND VendorID = @v_VendorID AND AccessType = @v_AccessType AND CountryID = @v_CountryID AND Prefix = @v_Prefix AND City = @v_City AND Tariff = @v_Tariff AND CostPerMinute IS NOT NULL;


								UPDATE  tmp_timezone_minutes SET minute_OutpaymentPerMinute =  ( (@p_Minutes/ 100) * @p_PeakTimeZonePercentage )
								WHERE  TimezonesID = @p_Timezone AND VendorID = @v_VendorID AND AccessType = @v_AccessType AND CountryID = @v_CountryID AND Prefix = @v_Prefix AND City = @v_City AND Tariff = @v_Tariff AND OutpaymentPerMinute IS NOT NULL;

								UPDATE  tmp_timezone_minutes SET minute_CollectionCostAmount =  ( (@p_Minutes/ 100) * @p_PeakTimeZonePercentage )
								WHERE  TimezonesID = @p_Timezone AND VendorID = @v_VendorID AND AccessType = @v_AccessType AND CountryID = @v_CountryID AND Prefix = @v_Prefix AND City = @v_City AND Tariff = @v_Tariff AND CollectionCostAmount IS NOT NULL;

					
								SET @v_RemainingTimezonesForCostPerMinute = ( SELECT count(*) FROM tmp_timezone_minutes where TimezonesID != @p_Timezone AND VendorID = @v_VendorID AND AccessType = @v_AccessType AND CountryID = @v_CountryID AND Prefix = @v_Prefix AND City = @v_City AND Tariff = @v_Tariff AND CostPerMinute IS NOT NULL );
								SET @v_RemainingTimezonesForOutpaymentPerMinute = ( SELECT count(*) FROM tmp_timezone_minutes where TimezonesID != @p_Timezone AND VendorID = @v_VendorID AND AccessType = @v_AccessType AND CountryID = @v_CountryID AND Prefix = @v_Prefix AND City = @v_City AND Tariff = @v_Tariff AND OutpaymentPerMinute IS NOT NULL );
								SET @v_RemainingTimezonesForCollectionCostAmount = ( SELECT count(*) FROM tmp_timezone_minutes where TimezonesID != @p_Timezone AND VendorID = @v_VendorID AND AccessType = @v_AccessType AND CountryID = @v_CountryID AND Prefix = @v_Prefix AND City = @v_City AND Tariff = @v_Tariff AND CollectionCostAmount IS NOT NULL );

								SET @v_RemainingCostPerMinute = (@p_Minutes - IFNULL((select minute_CostPerMinute FROM tmp_timezone_minutes WHERE  TimezonesID = @p_Timezone AND VendorID = @v_VendorID AND AccessType = @v_AccessType AND CountryID = @v_CountryID AND Prefix = @v_Prefix AND City = @v_City AND Tariff = @v_Tariff ),0)  ) / @v_RemainingTimezonesForCostPerMinute ;
								SET @v_RemainingOutpaymentPerMinute = (@p_Minutes - IFNULL((select minute_OutpaymentPerMinute FROM tmp_timezone_minutes WHERE  TimezonesID = @p_Timezone AND VendorID = @v_VendorID AND AccessType = @v_AccessType AND CountryID = @v_CountryID AND Prefix = @v_Prefix AND City = @v_City AND Tariff = @v_Tariff ),0) ) / @v_RemainingTimezonesForOutpaymentPerMinute ;
								SET @v_RemainingCollectionCostAmount = (@p_Minutes - IFNULL((select minute_CollectionCostAmount FROM tmp_timezone_minutes WHERE  TimezonesID = @p_Timezone AND VendorID = @v_VendorID AND AccessType = @v_AccessType AND CountryID = @v_CountryID AND Prefix = @v_Prefix AND City = @v_City AND Tariff = @v_Tariff ),0) ) / @v_RemainingTimezonesForCollectionCostAmount ;

								SET @v_pointer_ = 1;

								WHILE @v_pointer_ <= @v_rowCount_
								DO

										SET @v_TimezonesID = ( SELECT TimezonesID FROM tmp_timezones WHERE ID = @v_pointer_ AND TimezonesID != @p_Timezone );

										if @v_TimezonesID > 0 THEN

												UPDATE  tmp_timezone_minutes SET minute_CostPerMinute =  @v_RemainingCostPerMinute
												WHERE  TimezonesID = @v_TimezonesID AND VendorID = @v_VendorID AND AccessType = @v_AccessType AND CountryID = @v_CountryID AND Prefix = @v_Prefix AND City = @v_City AND Tariff = @v_Tariff  AND CostPerMinute IS NOT NULL;


												UPDATE  tmp_timezone_minutes SET minute_OutpaymentPerMinute =  @v_RemainingOutpaymentPerMinute
												WHERE  TimezonesID = @v_TimezonesID AND VendorID = @v_VendorID AND AccessType = @v_AccessType AND CountryID = @v_CountryID AND Prefix = @v_Prefix AND City = @v_City AND Tariff = @v_Tariff  AND OutpaymentPerMinute IS NOT NULL;

												UPDATE  tmp_timezone_minutes SET minute_CollectionCostAmount =  @v_RemainingCollectionCostAmount
												WHERE  TimezonesID = @v_TimezonesID AND VendorID = @v_VendorID AND AccessType = @v_AccessType AND CountryID = @v_CountryID AND Prefix = @v_Prefix AND City = @v_City AND Tariff = @v_Tariff  AND CollectionCostAmount IS NOT NULL;

										END IF ;

									SET @v_pointer_ = @v_pointer_ + 1;

								END WHILE;

						SET @v_v_pointer_ = @v_v_pointer_ + 1;

					END WHILE;

					-- // account loop ends


				insert into tmp_origination_minutes ( OriginationCode, minutes )
				select @p_MobileOrigination  , @v_MinutesFromMobileOrigination ;


		END IF;

		SET @v_days =    TIMESTAMPDIFF(DAY, (SELECT @v_StartDate_), (SELECT @v_EndDate_)) + 1 ;
		SET @v_period1 =      IF(MONTH((SELECT @v_StartDate_)) = MONTH((SELECT @v_EndDate_)), 0, (TIMESTAMPDIFF(DAY, (SELECT @v_StartDate_), LAST_DAY((SELECT @v_StartDate_)) + INTERVAL 1 DAY)) / DAY(LAST_DAY((SELECT @v_StartDate_))));
		SET @v_period2 =      TIMESTAMPDIFF(MONTH, LAST_DAY((SELECT @v_StartDate_)) + INTERVAL 1 DAY, LAST_DAY((SELECT @v_EndDate_))) ;
		SET @v_period3 =      IF(MONTH((SELECT @v_StartDate_)) = MONTH((SELECT @v_EndDate_)), (SELECT @v_days), DAY((SELECT @v_EndDate_))) / DAY(LAST_DAY((SELECT @v_EndDate_)));
		SET @v_months =     (SELECT @v_period1) + (SELECT @v_period2) + (SELECT @v_period3);

		SET @v_months = ROUND(@v_months,1);
	

		insert into tmp_timezone_minutes_2 (VendorID, TimezonesID, AccessType,CountryID,Prefix,City,Tariff, minute_CostPerMinute,minute_OutpaymentPerMinute,minute_CollectionCostAmount) select VendorID,TimezonesID, AccessType,CountryID,Prefix,City,Tariff, minute_CostPerMinute,minute_OutpaymentPerMinute,minute_CollectionCostAmount from tmp_timezone_minutes;
		insert into tmp_timezone_minutes_3 (VendorID, TimezonesID, AccessType,CountryID,Prefix,City,Tariff,minute_CostPerMinute,minute_OutpaymentPerMinute,minute_CollectionCostAmount) select VendorID,TimezonesID, AccessType,CountryID,Prefix,City,Tariff, minute_CostPerMinute,minute_OutpaymentPerMinute,minute_CollectionCostAmount from tmp_timezone_minutes;








										insert into tmp_table_without_origination (
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

	from (
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
								r2.Code as OriginationCode,
								vc.VendorConnectionID,
								a.AccountID as VendorID,
								-- vc.Name as VendorConnectionName,
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

								@Chargeback := CASE WHEN ( ChargebackCurrency is not null)
								THEN

									CASE WHEN  @v_CurrencyID_ = ChargebackCurrency THEN
										drtr.Chargeback
									ELSE
									(

										(@v_DestinationCurrencyConversionRate )
										* (drtr.Chargeback  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = ChargebackCurrency and  CompanyID = @v_CompanyId_ ))
									)
									END

								ELSE
									(

										(@v_DestinationCurrencyConversionRate )
										* (drtr.Chargeback  / (@v_CompanyCurrencyConversionRate ))
									)
								END as Chargeback,

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


								@CollectionCostPercentage := CASE WHEN ( CollectionCostAmountCurrency is not null)
								THEN

									CASE WHEN  @v_CurrencyID_ = CollectionCostAmountCurrency THEN
										drtr.CollectionCostPercentage
									ELSE
									(

										(@v_DestinationCurrencyConversionRate )
										* (drtr.CollectionCostPercentage  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = CollectionCostAmountCurrency and  CompanyID = @v_CompanyId_ ))
									)
									END

								ELSE
									(

										(@v_DestinationCurrencyConversionRate )
										* (drtr.CollectionCostPercentage  / (@v_CompanyCurrencyConversionRate ))
									)
								END as CollectionCostPercentage,

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
								END as RegistrationCostPerNumber,

								



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


								
								@Total1 := (

									(	(IFNULL(@MonthlyCost,0)* @v_months)	 +  @TrunkCostPerService	)				+ 
									(IFNULL(@CostPerMinute,0) * IFNULL((select minute_CostPerMinute from tmp_timezone_minutes tm where tm.TimezonesID = t.TimezonesID and (tm.VendorID is null OR tm.VendorID   = a.AccountID) AND tm.AccessType = drtr.AccessType AND tm.CountryID = c.CountryID AND tm.Prefix = c.Prefix AND tm.City = drtr.City AND tm.Tariff = drtr.Tariff  LIMIT 1 ),0 ))	+
									(IFNULL(@CostPerCall,0) * @p_Calls)		+
									(IFNULL(@SurchargePerCall,0) * IFNULL(tom.minutes,0)) +
									(IFNULL(@OutpaymentPerMinute,0) *  IFNULL((select minute_OutpaymentPerMinute from tmp_timezone_minutes_2 tm2 where tm2.TimezonesID = t.TimezonesID and (tm2.VendorID is null OR tm2.VendorID  = a.AccountID) AND tm2.AccessType = drtr.AccessType AND tm2.CountryID = c.CountryID AND tm2.Prefix = c.Prefix  AND tm2.City = drtr.City AND tm2.Tariff = drtr.Tariff LIMIT 1 ),0))	+
									(IFNULL(@OutpaymentPerCall,0) * 	@p_Calls) +

									(IFNULL(@CollectionCostAmount,0) * IFNULL((select minute_CollectionCostAmount from tmp_timezone_minutes_3 tm3 where tm3.TimezonesID = t.TimezonesID and (tm3.VendorID is null OR tm3.VendorID  = a.AccountID) AND tm3.AccessType = drtr.AccessType AND tm3.CountryID = c.CountryID AND tm3.Prefix = c.Prefix  AND tm3.City = drtr.City AND tm3.Tariff = drtr.Tariff LIMIT 1 ),0))

								)
 
								 as Total1,
								@Total := (
								@Total1 + @Total1 * (select sum( IF(FlatStatus = 0 ,(Amount/100), Amount ) * IFNULL(@CollectionCostPercentage,0))  from tblTaxRate where CompanyID = @v_CompanyId_ AND TaxType in  (1,2)   )
									) as Total



				from tblRateTableDIDRate  drtr
				inner join tblRateTable  rt on rt.RateTableId = drtr.RateTableId
				 inner join tblVendorConnection vc on vc.RateTableID = rt.RateTableId and vc.DIDCategoryID = rt.DIDCategoryID and vc.CompanyID = rt.CompanyId  and vc.Active=1
				inner join tblAccount a on vc.AccountId = a.AccountID and rt.CompanyId = a.CompanyId
				left join tblVendorTrunkCost vtc on vtc.AccountID = a.AccountID
				inner join tblRate r on drtr.RateID = r.RateID and r.CompanyID = vc.CompanyID
				left join tblRate r2 on drtr.OriginationRateID = r2.RateID and r.CompanyID = vc.CompanyID
		 		inner join tblCountry c on c.CountryID = r.CountryID


				AND ( @p_CountryID = '' OR  c.CountryID = @p_CountryID )
				AND ( @p_City = '' OR drtr.City  = @p_City )
				AND ( @p_Tariff = '' OR drtr.Tariff  = @p_Tariff )
				AND ( @p_Prefix = '' OR (r.Code  = concat(c.Prefix ,@p_Prefix) ) )
				AND ( @p_AccessType = '' OR drtr.AccessType = @p_AccessType )


				inner join tblTimezones t on t.TimezonesID =  drtr.TimezonesID
				left join tmp_origination_minutes tom  on r2.Code = tom.OriginationCode

				where

				rt.CompanyId =  @v_CompanyId_

				and vc.DIDCategoryID = @v_DIDCategoryID_

				and drtr.ApprovedStatus = @v_ApprovedStatus

				and rt.Type = @v_DIDType

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
		) tmp	

			;




										insert into tmp_table_with_origination (
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
		from (																
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
								r2.Code as OriginationCode,
								vc.VendorConnectionID,
								a.AccountID as VendorID,
								-- vc.Name as VendorConnectionName,
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

										(@v_DestinationCurrencyConversionRate )
										* (drtr.OneOffCost  / (@v_CompanyCurrencyConversionRate ))
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

								@Chargeback := CASE WHEN ( ChargebackCurrency is not null)
								THEN

									CASE WHEN  @v_CurrencyID_ = ChargebackCurrency THEN
										drtr.Chargeback
									ELSE
									(

										(@v_DestinationCurrencyConversionRate )
										* (drtr.Chargeback  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = ChargebackCurrency and  CompanyID = @v_CompanyId_ ))
									)
									END

 								ELSE
									(

										(@v_DestinationCurrencyConversionRate )
										* (drtr.Chargeback  / (@v_CompanyCurrencyConversionRate ))
									)
								END as Chargeback,

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


								@CollectionCostPercentage := CASE WHEN ( CollectionCostAmountCurrency is not null)
								THEN

									CASE WHEN  @v_CurrencyID_ = CollectionCostAmountCurrency THEN
										drtr.CollectionCostPercentage
									ELSE
									(

										(@v_DestinationCurrencyConversionRate )
										* (drtr.CollectionCostPercentage  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = CollectionCostAmountCurrency and  CompanyID = @v_CompanyId_ ))
									)
									END
 
								ELSE
									(

										(@v_DestinationCurrencyConversionRate )
										* (drtr.CollectionCostPercentage  / (@v_CompanyCurrencyConversionRate ))
									)
								END as CollectionCostPercentage,

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
								END as RegistrationCostPerNumber,


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




							 @Total1 := (
									(	(IFNULL(@MonthlyCost,0)* @v_months)	 +  @TrunkCostPerService	)				+ 
									(IFNULL(@CostPerMinute,0) * IFNULL(tom.minutes,0))	+
									(IFNULL(@CostPerCall,0) * @p_Calls)		+
									(IFNULL(@SurchargePerCall,0) * IFNULL(tom.minutes,0)) +
									(IFNULL(@OutpaymentPerMinute,0) * 	IFNULL(tom.minutes,0))	+
									(IFNULL(@OutpaymentPerCall,0) * 	@p_Calls) +

									(IFNULL(@CollectionCostAmount,0) * IFNULL(tom.minutes,0))


								) as Total1,

								@Total := (
								@Total1 + @Total1 * (select sum( IF(FlatStatus = 0 ,(Amount/100), Amount ) * IFNULL(@CollectionCostPercentage,0))  from tblTaxRate where CompanyID = @v_CompanyId_ AND TaxType in  (1,2)   )
									) as Total


				from tblRateTableDIDRate  drtr
				inner join tblRateTable  rt on rt.RateTableId = drtr.RateTableId
				 inner join tblVendorConnection vc on vc.RateTableID = rt.RateTableId and vc.DIDCategoryID = rt.DIDCategoryID and vc.CompanyID = rt.CompanyId  and vc.Active=1
				inner join tblAccount a on vc.AccountId = a.AccountID and rt.CompanyId = a.CompanyId
				left join tblVendorTrunkCost vtc on vtc.AccountID = a.AccountID
				inner join tblRate r on drtr.RateID = r.RateID and r.CompanyID = vc.CompanyID
				left join tblRate r2 on drtr.OriginationRateID = r2.RateID and r.CompanyID = vc.CompanyID
		 		inner join tblCountry c on c.CountryID = r.CountryID


				AND ( @p_CountryID = '' OR  c.CountryID = @p_CountryID )
				AND ( @p_City = '' OR drtr.City  = @p_City )
				AND ( @p_Tariff = '' OR drtr.Tariff  = @p_Tariff )
				AND ( @p_Prefix = '' OR (r.Code  = concat(c.Prefix ,@p_Prefix) ) )
				AND ( @p_AccessType = '' OR drtr.AccessType = @p_AccessType )


				inner join tblTimezones t on t.TimezonesID =  drtr.TimezonesID
				inner join tmp_origination_minutes tom  on r2.Code = tom.OriginationCode
				where

				rt.CompanyId =  @v_CompanyId_

				and vc.DIDCategoryID = @v_DIDCategoryID_

				and drtr.ApprovedStatus = @v_ApprovedStatus

				and rt.Type = @v_DIDType

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
		) tmp;



			delete t1 from tmp_table_without_origination t1 inner join tmp_table_with_origination t2 on t1.VendorConnectionID = t2.VendorConnectionID and t1.TimezonesID = t2.TimezonesID and t1.Code = t2.Code;

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
										(MonthlyCost) as MonthlyCost,
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
										from (
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
												from
												tmp_table_without_origination

												union all

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
												from
												tmp_table_with_origination

										) tmp
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
												max(OriginationCode),
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
      group by AccessType ,CountryID ,City ,Tariff,Code ,VendorConnectionID,TimezonesID;


		insert into tmp_table_output_2
      		(	RateTableID, TimezonesID, TimezoneTitle, CodeDeckId, CountryID, AccessType, CountryPrefix, City, Tariff, Code, OriginationCode, 
			VendorConnectionID, VendorID,
			  
			 EndDate, OneOffCost, MonthlyCost, CostPerCall, CostPerMinute, SurchargePerCall,
			SurchargePerMinute, OutpaymentPerCall, OutpaymentPerMinute, Surcharges, Chargeback, CollectionCostAmount, CollectionCostPercentage, 
			RegistrationCostPerNumber, OneOffCostCurrency, MonthlyCostCurrency, CostPerCallCurrency, CostPerMinuteCurrency, SurchargePerCallCurrency, 
			SurchargePerMinuteCurrency, OutpaymentPerCallCurrency, OutpaymentPerMinuteCurrency, SurchargesCurrency, ChargebackCurrency, CollectionCostAmountCurrency, 
			RegistrationCostPerNumberCurrency, Total, vPosition	)
			
			select 

			RateTableID, TimezonesID, TimezoneTitle, CodeDeckId, CountryID, AccessType, CountryPrefix, City, Tariff, Code, OriginationCode, 
			VendorConnectionID,VendorID,   EndDate, OneOffCost, MonthlyCost, CostPerCall, CostPerMinute, SurchargePerCall,
			SurchargePerMinute, OutpaymentPerCall, OutpaymentPerMinute, Surcharges, Chargeback, CollectionCostAmount, CollectionCostPercentage, 
			RegistrationCostPerNumber, OneOffCostCurrency, MonthlyCostCurrency, CostPerCallCurrency, CostPerMinuteCurrency, SurchargePerCallCurrency, 
			SurchargePerMinuteCurrency, OutpaymentPerCallCurrency, OutpaymentPerMinuteCurrency, SurchargesCurrency, ChargebackCurrency, CollectionCostAmountCurrency, 
			RegistrationCostPerNumberCurrency, Total, vPosition

			from ( 
								select 

						RateTableID, TimezonesID, TimezoneTitle, CodeDeckId, CountryID, AccessType, CountryPrefix, City, Tariff, Code, OriginationCode, 
						VendorConnectionID, VendorID,  EndDate, OneOffCost, MonthlyCost, CostPerCall, CostPerMinute, SurchargePerCall,
						SurchargePerMinute, OutpaymentPerCall, OutpaymentPerMinute, Surcharges, Chargeback, CollectionCostAmount, CollectionCostPercentage, 
						RegistrationCostPerNumber, OneOffCostCurrency, MonthlyCostCurrency, CostPerCallCurrency, CostPerMinuteCurrency, SurchargePerCallCurrency, 
						SurchargePerMinuteCurrency, OutpaymentPerCallCurrency, OutpaymentPerMinuteCurrency, SurchargesCurrency, ChargebackCurrency, CollectionCostAmountCurrency, 
						RegistrationCostPerNumberCurrency, Total,
	
				     @vPosition := (
						 		CASE WHEN (@prev_TimezonesID = TimezonesID AND @prev_Code = Code AND  @prev_AccessType    = AccessType AND  @prev_CountryID = CountryID AND  @prev_City    = City AND  @prev_Tariff = Tariff AND @prev_Total <=  Total
                              )
                      THEN
                          @vPosition + 1
                      ELSE
                        1
                      END) as  vPosition,
					  @prev_TimezonesID  := TimezonesID,
                      @prev_AccessType := AccessType ,
                      @prev_CountryID  := CountryID  ,
                      @prev_City  := City  ,
                      @prev_Tariff := Tariff ,
                      @prev_Code  := Code  ,
                      @prev_VendorConnectionID  := VendorConnectionID,
                      @prev_Total := Total

					from tmp_table_output_1
					,(SELECT  @vPosition := 0 , @prev_TimezonesID := '' , @prev_AccessType := '' ,@prev_CountryID  := '' ,@prev_City  := '' ,@prev_Tariff := '' ,@prev_Code  := ''  , @prev_VendorConnectionID  := '', @prev_Total := 0 ) t
					order by AccessType ,CountryID ,City ,Tariff,Code ,TimezonesID,Total
			
			) tmp
			where vPosition  <= @v_RatePosition_ ;

			insert into tmp_final_table_output
			(
			RateTableID, TimezonesID, TimezoneTitle, CodeDeckId, CountryID, AccessType, CountryPrefix, City, Tariff, Code, OriginationCode, 
			VendorConnectionID,  VendorID, EndDate, OneOffCost, MonthlyCost, CostPerCall, CostPerMinute, SurchargePerCall,
			SurchargePerMinute, OutpaymentPerCall, OutpaymentPerMinute, Surcharges, Chargeback, CollectionCostAmount, CollectionCostPercentage, 
			RegistrationCostPerNumber, OneOffCostCurrency, MonthlyCostCurrency, CostPerCallCurrency, CostPerMinuteCurrency, SurchargePerCallCurrency, 
			SurchargePerMinuteCurrency, OutpaymentPerCallCurrency, OutpaymentPerMinuteCurrency, SurchargesCurrency, ChargebackCurrency, CollectionCostAmountCurrency, 
			RegistrationCostPerNumberCurrency, Total, vPosition
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
												-- max(VendorConnectionName),
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
												Total,
			 									vPosition
			from (
				
				 
								select 

						RateTableID, TimezonesID, TimezoneTitle, CodeDeckId, CountryID, AccessType, CountryPrefix, City, Tariff, Code, OriginationCode, 
						VendorConnectionID, VendorID,  EndDate, OneOffCost, MonthlyCost, CostPerCall, CostPerMinute, SurchargePerCall,
						SurchargePerMinute, OutpaymentPerCall, OutpaymentPerMinute, Surcharges, Chargeback, CollectionCostAmount, CollectionCostPercentage, 
						RegistrationCostPerNumber, OneOffCostCurrency, MonthlyCostCurrency, CostPerCallCurrency, CostPerMinuteCurrency, SurchargePerCallCurrency, 
						SurchargePerMinuteCurrency, OutpaymentPerCallCurrency, OutpaymentPerMinuteCurrency, SurchargesCurrency, ChargebackCurrency, CollectionCostAmountCurrency, 
						RegistrationCostPerNumberCurrency, Total,
	
				     @vPosition := (
						 		CASE WHEN (@prev_TimezonesID = TimezonesID AND @prev_Code = Code AND  @prev_AccessType    = AccessType AND  @prev_CountryID = CountryID AND  @prev_City    = City AND  @prev_Tariff = Tariff AND @prev_Total >=  Total
                              )
                      THEN
                          @vPosition + 1
                      ELSE
                        1
                      END) as  vPosition,
					  @prev_TimezonesID  := TimezonesID,
                      @prev_AccessType := AccessType ,
                      @prev_CountryID  := CountryID  ,
                      @prev_City  := City  ,
                      @prev_Tariff := Tariff ,
                      @prev_Code  := Code  ,
                      @prev_VendorConnectionID  := VendorConnectionID,
                      @prev_Total := Total

					from tmp_table_output_2
					,(SELECT  @vPosition := 0 , @prev_TimezonesID := '' , @prev_AccessType := '' ,@prev_CountryID  := '' ,@prev_City  := '' ,@prev_Tariff := '' ,@prev_Code  := ''  , @prev_VendorConnectionID  := '', @prev_Total := 0 ) t
					order by AccessType ,CountryID ,City ,Tariff,Code ,TimezonesID,Total desc

				 
				) tmp
				where vPosition = 1 ;
		 --   group by AccessType ,CountryID ,City ,Tariff,Code ,TimezonesID;




			insert into tmp_SelectedVendortblRateTableDIDRate
			(
					RateTableID,
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

			)
			select
					RateTableID,
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
					-- VendorConnectionName,
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

			from tmp_final_table_output;





			DROP TEMPORARY TABLE IF EXISTS tmp_MergeComponents;
			CREATE TEMPORARY TABLE tmp_MergeComponents(
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
									IFNULL(TimezonesID,''),
									IFNULL(ToTimezonesID,''),
									Action,
									MergeTo,
									IFNULL(FromCountryID,''),
									IFNULL(ToCountryID,''),
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
						FromPrefix,
						ToPrefix,
						FromCity,
						FromTariff,
						ToCity,
						ToTariff

				INTO

						@v_Component,
						@v_Origination,
						@v_ToOrigination,
						@v_TimezonesID,
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

									from tmp_tblRateTableDIDRate

								where


								  (  @v_TimezonesID = "" OR  TimezonesID = @v_TimezonesID)
								AND (  @v_Origination = "" OR  OriginationCode = @v_Origination)
								AND (  @v_FromCountryID =  ""  OR CountryID = 	@v_FromCountryID )
								AND (  @v_FromAccessType =  ""  OR AccessType = 	@v_FromAccessType )
								AND (  @v_FromPrefix =  "" OR Code = 	concat(CountryPrefix ,@v_FromPrefix) )
								AND (  @v_FromCity =  "" OR City = 	@v_FromCity )
								AND (  @v_FromTariff =  "" OR Tariff = 	@v_FromTariff )




						) tmp on
								tmp.Code = srt.Code
								AND (  @v_ToTimezonesID = "" OR  srt.TimezonesID = @v_ToTimezonesID)
								AND (  @v_ToOrigination = "" OR  srt.OriginationCode = @v_ToOrigination)
								AND (  @v_ToCountryID =  ""  OR srt.CountryID = 	@v_ToCountryID )
								AND (  @v_ToAccessType =  ""  OR srt.AccessType = 	@v_ToAccessType )
								AND (  @v_ToPrefix =  "" OR srt.Code = 	concat(srt.CountryPrefix ,@v_ToPrefix) )
								AND (  @v_ToCity =  "" OR srt.City = 	@v_ToCity )
								AND (  @v_ToTariff =  "" OR srt.Tariff = 	@v_ToTariff )
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
								IF(@v_ToTimezonesID = '',TimezonesID,@v_ToTimezonesID) as TimezonesID,
								TimezoneTitle,
								IF(@v_ToPrefix = '', Code, concat(CountryPrefix ,@v_ToPrefix)) as Code,
								IF(@v_ToOrigination = '',OriginationCode,@v_ToOrigination) as OriginationCode,
								VendorConnectionID,
								VendorID,
								CodeDeckId,
								IF(@v_ToCountryID = '',CountryID,@v_ToCountryID) as CountryID,
								IF(@v_ToAccessType = '',AccessType,@v_ToAccessType) as AccessType,
								CountryPrefix,
								IF(@v_ToCity = '',City,@v_ToCity) as City,
								IF(@v_ToTariff = '',Tariff,@v_ToTariff) as Tariff,
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

						from tmp_tblRateTableDIDRate

						where
							(  @v_TimezonesID = "" OR  TimezonesID = @v_TimezonesID)
							AND (  @v_Origination = "" OR  OriginationCode = @v_Origination)
							AND (  @v_FromCountryID =  ''  OR CountryID = 	@v_FromCountryID )
							AND (  @v_FromAccessType =  ''  OR AccessType = 	@v_FromAccessType )
							AND (  @v_FromPrefix =  '' OR Code = 	concat(CountryPrefix ,@v_FromPrefix) )
							AND (  @v_FromCity =  '' OR City = 	@v_FromCity )
							AND (  @v_FromTariff =  '' OR Tariff = 	@v_FromTariff );



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




	 	SET @v_pointer_ = 1;
		SET @v_rowCount_ = ( SELECT COUNT(*) FROM tmp_Raterules_ );

		WHILE @v_pointer_ <= @v_rowCount_
		DO

			SET @v_rateRuleId_ = (SELECT rateruleid FROM tmp_Raterules_ rr WHERE rr.RowNo = @v_pointer_);


						update tmp_SelectedVendortblRateTableDIDRate rt
						inner join tmp_Raterules_ rr on rr.RowNo  = @v_pointer_
						and  rr.TimezonesID  = rt.TimezonesID
						and (rr.Origination = '' OR rr.Origination = rt.OriginationCode )
						AND (  rr.CountryID = ''  OR rt.CountryID = 	rr.CountryID )
						AND (  rr.AccessType = '' OR rt.AccessType = 	rr.AccessType )
						AND (  rr.Prefix = ''  OR rt.Code = 	concat(rt.CountryPrefix ,rr.Prefix) )
						AND (  rr.City = '' OR rt.City = 	rr.City )
						AND (  rr.Tariff = '' OR rt.Tariff = 	rr.Tariff )

						LEFT join tblRateRuleMargin rule_mgn1 on  rule_mgn1.RateRuleId = @v_rateRuleId_
						AND
						(
							(rr.Component = 'OneOffCost' AND ( (rule_mgn1.MinRate is null AND  rule_mgn1.MaxRate is null ) OR (  OneOffCost Between rule_mgn1.MinRate and rule_mgn1.MaxRate ) )  ) OR
							(rr.Component = 'MonthlyCost' AND ( (rule_mgn1.MinRate is null AND  rule_mgn1.MaxRate is null ) OR (  MonthlyCost Between rule_mgn1.MinRate and rule_mgn1.MaxRate ) )  ) OR
							(rr.Component = 'CostPerCall' AND ( (rule_mgn1.MinRate is null AND  rule_mgn1.MaxRate is null ) OR (  CostPerCall Between rule_mgn1.MinRate and rule_mgn1.MaxRate ) )  ) OR
							(rr.Component = 'CostPerMinute' AND ( (rule_mgn1.MinRate is null AND  rule_mgn1.MaxRate is null ) OR (  CostPerMinute Between rule_mgn1.MinRate and rule_mgn1.MaxRate ) )  ) OR
							(rr.Component = 'SurchargePerCall' AND ( (rule_mgn1.MinRate is null AND  rule_mgn1.MaxRate is null ) OR (  SurchargePerCall Between rule_mgn1.MinRate and rule_mgn1.MaxRate ) )  ) OR
							(rr.Component = 'SurchargePerMinute' AND ( (rule_mgn1.MinRate is null AND  rule_mgn1.MaxRate is null ) OR (  SurchargePerMinute Between rule_mgn1.MinRate and rule_mgn1.MaxRate ) )  ) OR
							(rr.Component = 'OutpaymentPerCall' AND ( (rule_mgn1.MinRate is null AND  rule_mgn1.MaxRate is null ) OR (  OutpaymentPerCall Between rule_mgn1.MinRate and rule_mgn1.MaxRate ) )  ) OR
							(rr.Component = 'OutpaymentPerMinute' AND ( (rule_mgn1.MinRate is null AND  rule_mgn1.MaxRate is null ) OR (  OutpaymentPerMinute Between rule_mgn1.MinRate and rule_mgn1.MaxRate ) )  ) OR
							(rr.Component = 'Surcharges' AND ( (rule_mgn1.MinRate is null AND  rule_mgn1.MaxRate is null ) OR (  Surcharges Between rule_mgn1.MinRate and rule_mgn1.MaxRate ) )  ) OR
							(rr.Component = 'Chargeback' AND ( (rule_mgn1.MinRate is null AND  rule_mgn1.MaxRate is null ) OR (  Chargeback Between rule_mgn1.MinRate and rule_mgn1.MaxRate ) )  ) OR
							(rr.Component = 'CollectionCostAmount' AND ( (rule_mgn1.MinRate is null AND  rule_mgn1.MaxRate is null ) OR (  CollectionCostAmount Between rule_mgn1.MinRate and rule_mgn1.MaxRate ) )  ) OR
							(rr.Component = 'CollectionCostPercentage' AND ( (rule_mgn1.MinRate is null AND  rule_mgn1.MaxRate is null ) OR (  CollectionCostPercentage Between rule_mgn1.MinRate and rule_mgn1.MaxRate ) )  ) OR
							(rr.Component = 'RegistrationCostPerNumber' AND ( (rule_mgn1.MinRate is null AND  rule_mgn1.MaxRate is null ) OR (  RegistrationCostPerNumber Between rule_mgn1.MinRate and rule_mgn1.MaxRate ) )  ) 


						)

						SET
						OneOffCost = CASE WHEN rr.Component = 'OneOffCost' AND rule_mgn1.RateRuleId is not null THEN
											CASE WHEN trim(IFNULL(rule_mgn1.AddMargin,"")) != '' THEN
												OneOffCost + (CASE WHEN rule_mgn1.addmargin LIKE '%p' THEN ((CAST(REPLACE(rule_mgn1.addmargin, 'p', '') AS DECIMAL(18, 2)) / 100) * OneOffCost) ELSE rule_mgn1.addmargin END)
											WHEN trim(IFNULL(rule_mgn1.FixedValue,"")) != '' THEN
												rule_mgn1.FixedValue
											ELSE
												OneOffCost
											END
									ELSE
									OneOffCost
									END,

						MonthlyCost = CASE WHEN rr.Component = 'MonthlyCost' AND rule_mgn1.RateRuleId is not null THEN
									CASE WHEN trim(IFNULL(rule_mgn1.AddMargin,"")) != '' THEN
										MonthlyCost + (CASE WHEN rule_mgn1.addmargin LIKE '%p' THEN ((CAST(REPLACE(rule_mgn1.addmargin, 'p', '') AS DECIMAL(18, 2)) / 100) * MonthlyCost) ELSE rule_mgn1.addmargin END)
									WHEN trim(IFNULL(rule_mgn1.FixedValue,"")) != '' THEN
										rule_mgn1.FixedValue
									ELSE
										MonthlyCost
									END
							ELSE
							MonthlyCost
							END,

						CostPerCall = CASE WHEN rr.Component = 'CostPerCall' AND rule_mgn1.RateRuleId is not null THEN
									CASE WHEN trim(IFNULL(rule_mgn1.AddMargin,"")) != '' THEN
										CostPerCall + (CASE WHEN rule_mgn1.addmargin LIKE '%p' THEN ((CAST(REPLACE(rule_mgn1.addmargin, 'p', '') AS DECIMAL(18, 2)) / 100) * CostPerCall) ELSE rule_mgn1.addmargin END)
									WHEN trim(IFNULL(rule_mgn1.FixedValue,"")) != '' THEN
										rule_mgn1.FixedValue
									ELSE
										CostPerCall
									END
							ELSE
							CostPerCall
							END,

						CostPerMinute = CASE WHEN rr.Component = 'CostPerMinute' AND rule_mgn1.RateRuleId is not null THEN
									CASE WHEN trim(IFNULL(rule_mgn1.AddMargin,"")) != '' THEN
										CostPerMinute + (CASE WHEN rule_mgn1.addmargin LIKE '%p' THEN ((CAST(REPLACE(rule_mgn1.addmargin, 'p', '') AS DECIMAL(18, 2)) / 100) * CostPerMinute) ELSE rule_mgn1.addmargin END)
									WHEN trim(IFNULL(rule_mgn1.FixedValue,"")) != '' THEN
										rule_mgn1.FixedValue
									ELSE
										CostPerMinute
									END
							ELSE
							CostPerMinute
							END,

						SurchargePerCall = CASE WHEN rr.Component = 'SurchargePerCall' AND rule_mgn1.RateRuleId is not null THEN
									CASE WHEN trim(IFNULL(rule_mgn1.AddMargin,"")) != '' THEN
										SurchargePerCall + (CASE WHEN rule_mgn1.addmargin LIKE '%p' THEN ((CAST(REPLACE(rule_mgn1.addmargin, 'p', '') AS DECIMAL(18, 2)) / 100) * SurchargePerCall) ELSE rule_mgn1.addmargin END)
									WHEN trim(IFNULL(rule_mgn1.FixedValue,"")) != '' THEN
										rule_mgn1.FixedValue
									ELSE
										SurchargePerCall
									END
							ELSE
							SurchargePerCall
							END,

						SurchargePerMinute = CASE WHEN rr.Component = 'SurchargePerMinute' AND rule_mgn1.RateRuleId is not null THEN
									CASE WHEN trim(IFNULL(rule_mgn1.AddMargin,"")) != '' THEN
										SurchargePerMinute + (CASE WHEN rule_mgn1.addmargin LIKE '%p' THEN ((CAST(REPLACE(rule_mgn1.addmargin, 'p', '') AS DECIMAL(18, 2)) / 100) * SurchargePerMinute) ELSE rule_mgn1.addmargin END)
									WHEN trim(IFNULL(rule_mgn1.FixedValue,"")) != '' THEN
										rule_mgn1.FixedValue
									ELSE
										SurchargePerMinute
									END
							ELSE
							SurchargePerMinute
							END,

						OutpaymentPerCall = CASE WHEN rr.Component = 'OutpaymentPerCall' AND rule_mgn1.RateRuleId is not null THEN
									CASE WHEN trim(IFNULL(rule_mgn1.AddMargin,"")) != '' THEN
										OutpaymentPerCall + (CASE WHEN rule_mgn1.addmargin LIKE '%p' THEN ((CAST(REPLACE(rule_mgn1.addmargin, 'p', '') AS DECIMAL(18, 2)) / 100) * OutpaymentPerCall) ELSE rule_mgn1.addmargin END)
									WHEN trim(IFNULL(rule_mgn1.FixedValue,"")) != '' THEN
										rule_mgn1.FixedValue
									ELSE
										OutpaymentPerCall
									END
							ELSE
							OutpaymentPerCall
							END,

						OutpaymentPerMinute = CASE WHEN rr.Component = 'OutpaymentPerMinute' AND rule_mgn1.RateRuleId is not null THEN
									CASE WHEN trim(IFNULL(rule_mgn1.AddMargin,"")) != '' THEN
										OutpaymentPerMinute + (CASE WHEN rule_mgn1.addmargin LIKE '%p' THEN ((CAST(REPLACE(rule_mgn1.addmargin, 'p', '') AS DECIMAL(18, 2)) / 100) * OutpaymentPerMinute) ELSE rule_mgn1.addmargin END)
									WHEN trim(IFNULL(rule_mgn1.FixedValue,"")) != '' THEN
										rule_mgn1.FixedValue
									ELSE
										OutpaymentPerMinute
									END
							ELSE
							OutpaymentPerMinute
							END,
						Surcharges = CASE WHEN rr.Component = 'Surcharges' AND rule_mgn1.RateRuleId is not null THEN
									CASE WHEN trim(IFNULL(rule_mgn1.AddMargin,"")) != '' THEN
										Surcharges + (CASE WHEN rule_mgn1.addmargin LIKE '%p' THEN ((CAST(REPLACE(rule_mgn1.addmargin, 'p', '') AS DECIMAL(18, 2)) / 100) * Surcharges) ELSE rule_mgn1.addmargin END)
									WHEN trim(IFNULL(rule_mgn1.FixedValue,"")) != '' THEN
										rule_mgn1.FixedValue
									ELSE
										Surcharges
									END
							ELSE
							Surcharges
							END,

						Chargeback = CASE WHEN rr.Component = 'Chargeback' AND rule_mgn1.RateRuleId is not null THEN
									CASE WHEN trim(IFNULL(rule_mgn1.AddMargin,"")) != '' THEN
										Chargeback + (CASE WHEN rule_mgn1.addmargin LIKE '%p' THEN ((CAST(REPLACE(rule_mgn1.addmargin, 'p', '') AS DECIMAL(18, 2)) / 100) * Chargeback) ELSE rule_mgn1.addmargin END)
									WHEN trim(IFNULL(rule_mgn1.FixedValue,"")) != '' THEN
										rule_mgn1.FixedValue
									ELSE
										Chargeback
									END
							ELSE
							Chargeback
							END,

						CollectionCostAmount = CASE WHEN rr.Component = 'CollectionCostAmount' AND rule_mgn1.RateRuleId is not null THEN
									CASE WHEN trim(IFNULL(rule_mgn1.AddMargin,"")) != '' THEN
										CollectionCostAmount + (CASE WHEN rule_mgn1.addmargin LIKE '%p' THEN ((CAST(REPLACE(rule_mgn1.addmargin, 'p', '') AS DECIMAL(18, 2)) / 100) * CollectionCostAmount) ELSE rule_mgn1.addmargin END)
									WHEN trim(IFNULL(rule_mgn1.FixedValue,"")) != '' THEN
										rule_mgn1.FixedValue
									ELSE
										CollectionCostAmount
									END
							ELSE
							CollectionCostAmount
							END,

						CollectionCostPercentage = CASE WHEN rr.Component = 'CollectionCostPercentage' AND rule_mgn1.RateRuleId is not null THEN
									CASE WHEN trim(IFNULL(rule_mgn1.AddMargin,"")) != '' THEN
										CollectionCostPercentage + (CASE WHEN rule_mgn1.addmargin LIKE '%p' THEN ((CAST(REPLACE(rule_mgn1.addmargin, 'p', '') AS DECIMAL(18, 2)) / 100) * CollectionCostPercentage) ELSE rule_mgn1.addmargin END)
									WHEN trim(IFNULL(rule_mgn1.FixedValue,"")) != '' THEN
										rule_mgn1.FixedValue
									ELSE
										CollectionCostPercentage
									END
							ELSE
							CollectionCostPercentage
							END,

						RegistrationCostPerNumber = CASE WHEN rr.Component = 'RegistrationCostPerNumber' AND rule_mgn1.RateRuleId is not null THEN
									CASE WHEN trim(IFNULL(rule_mgn1.AddMargin,"")) != '' THEN
										RegistrationCostPerNumber + (CASE WHEN rule_mgn1.addmargin LIKE '%p' THEN ((CAST(REPLACE(rule_mgn1.addmargin, 'p', '') AS DECIMAL(18, 2)) / 100) * RegistrationCostPerNumber) ELSE rule_mgn1.addmargin END)
									WHEN trim(IFNULL(rule_mgn1.FixedValue,"")) != '' THEN
										rule_mgn1.FixedValue
									ELSE
										RegistrationCostPerNumber
									END
							ELSE
							RegistrationCostPerNumber
							END
			;




			SET @v_pointer_ = @v_pointer_ + 1;

		END WHILE;






	 	SET @v_pointer_ = 1;
		SET @v_rowCount_ = ( SELECT COUNT(*) FROM tmp_RateGeneratorCalculatedRate_ );

		WHILE @v_pointer_ <= @v_rowCount_
		DO





						update tmp_SelectedVendortblRateTableDIDRate rt
						inner join tmp_RateGeneratorCalculatedRate_ rr on
						rr.RowNo  = @v_pointer_  AND rr.TimezonesID  = rt.TimezonesID  and   (rr.Origination = '' OR rr.Origination = rt.OriginationCode )

						AND (  rr.CountryID = ''  OR rt.CountryID = 	rr.CountryID )
						AND (  rr.AccessType = ''  OR rt.AccessType = 	rr.AccessType )
						AND (  rr.Prefix = ''  OR rt.Code = 	concat(rt.CountryPrefix ,rr.Prefix) )
						AND (  rr.City = ''  OR rt.City = 	rr.City )
						AND (  rr.Tariff = ''  OR rt.Tariff = 	rr.Tariff )



						SET
						OneOffCost = CASE WHEN FIND_IN_SET(rr.Component,'OneOffCost') != 0 AND OneOffCost < RateLessThen AND rr.CalculatedRateID is not null THEN
						ChangeRateTo
						ELSE
						OneOffCost
						END,
						MonthlyCost = CASE WHEN FIND_IN_SET(rr.Component,'MonthlyCost') != 0 AND MonthlyCost < RateLessThen AND rr.CalculatedRateID is not null THEN
						ChangeRateTo
						ELSE
						MonthlyCost
						END,
						CostPerCall = CASE WHEN FIND_IN_SET(rr.Component,'CostPerCall') != 0 AND CostPerCall < RateLessThen AND rr.CalculatedRateID is not null THEN
						ChangeRateTo
						ELSE
						CostPerCall
						END,
						CostPerMinute = CASE WHEN FIND_IN_SET(rr.Component,'CostPerMinute') != 0 AND CostPerMinute < RateLessThen AND rr.CalculatedRateID is not null THEN
						ChangeRateTo
						ELSE
						CostPerMinute
						END,
						SurchargePerCall = CASE WHEN FIND_IN_SET(rr.Component,'SurchargePerCall') != 0 AND SurchargePerCall < RateLessThen AND rr.CalculatedRateID is not null THEN
						ChangeRateTo
						ELSE
						SurchargePerCall
						END,
						SurchargePerMinute = CASE WHEN FIND_IN_SET(rr.Component,'SurchargePerMinute') != 0 AND SurchargePerMinute < RateLessThen AND rr.CalculatedRateID is not null THEN
						ChangeRateTo
						ELSE
						SurchargePerMinute
						END,
						OutpaymentPerCall = CASE WHEN FIND_IN_SET(rr.Component,'OutpaymentPerCall') != 0 AND OutpaymentPerCall < RateLessThen AND rr.CalculatedRateID is not null THEN
						ChangeRateTo
						ELSE
						OutpaymentPerCall
						END,
						OutpaymentPerMinute = CASE WHEN FIND_IN_SET(rr.Component,'OutpaymentPerMinute') != 0 AND OutpaymentPerMinute < RateLessThen AND rr.CalculatedRateID is not null THEN
						ChangeRateTo
						ELSE
						OutpaymentPerMinute
						END,
						Surcharges = CASE WHEN FIND_IN_SET(rr.Component,'Surcharges') != 0 AND Surcharges < RateLessThen AND rr.CalculatedRateID is not null THEN
						ChangeRateTo
						ELSE
						Surcharges
						END,
						Chargeback = CASE WHEN FIND_IN_SET(rr.Component,'Chargeback') != 0 AND Chargeback < RateLessThen AND rr.CalculatedRateID is not null THEN
						ChangeRateTo
						ELSE
						Chargeback
						END,
						CollectionCostAmount = CASE WHEN FIND_IN_SET(rr.Component,'CollectionCostAmount') != 0 AND CollectionCostAmount < RateLessThen AND rr.CalculatedRateID is not null THEN
						ChangeRateTo
						ELSE
						CollectionCostAmount
						END,
						CollectionCostPercentage = CASE WHEN FIND_IN_SET(rr.Component,'CollectionCostPercentage') != 0 AND CollectionCostPercentage < RateLessThen AND rr.CalculatedRateID is not null THEN
						ChangeRateTo
						ELSE
						CollectionCostPercentage
						END,
						RegistrationCostPerNumber = CASE WHEN FIND_IN_SET(rr.Component,'RegistrationCostPerNumber') != 0 AND RegistrationCostPerNumber < RateLessThen AND rr.CalculatedRateID is not null THEN
						ChangeRateTo
						ELSE
						RegistrationCostPerNumber
						END;


			SET @v_pointer_ = @v_pointer_ + 1;

		END WHILE;




		-- leave GenerateRateTable;



		SET @v_SelectedRateTableID = ( select RateTableID from tmp_SelectedVendortblRateTableDIDRate limit 1 );

		SET @v_AffectedRecords_ = 0;

		START TRANSACTION;

		SET @v_RATE_STATUS_AWAITING  = 0;
		SET @v_RATE_STATUS_APPROVED  = 1;
		SET @v_RATE_STATUS_REJECTED  = 2;
		SET @v_RATE_STATUS_DELETE    = 3;

		IF @p_RateTableId = -1
		THEN

			-- SET @v_codedeckid_ = ( select CodeDeckId from tmp_SelectedVendortblRateTableDIDRate limit 1 );

			INSERT INTO tblRateTable (Type, CompanyId, RateTableName, RateGeneratorID,DIDCategoryID, TrunkID, CodeDeckId,CurrencyID,Status, RoundChargedAmount,MinimumCallCharge,AppliedTo,Reseller,created_at,updated_at, CreatedBy,ModifiedBy)
			select  @v_DIDType as Type, @v_CompanyId_, @p_rateTableName , @p_RateGeneratorId,DIDCategoryID, 0 as TrunkID,  CodeDeckId , @v_CurrencyID_ as  CurrencyID, Status, RoundChargedAmount,MinimumCallCharge, @p_AppliedTo as AppliedTo, @p_Reseller as Reseller, now() ,now() ,@p_ModifiedBy,@p_ModifiedBy
			from tblRateTable where RateTableID = @v_SelectedRateTableID  limit 1;

			SET @p_RateTableId = LAST_INSERT_ID();

		ELSE

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
				INNER JOIN tblRate r
					ON rtd.RateID  = r.RateID
				LEFT JOIN tblRate rr
					ON rtd.OriginationRateID  = rr.RateID
				inner join tmp_SelectedVendortblRateTableDIDRate drtr on
				drtr.Code = r.Code and drtr.OriginationCode = rr.Code
				and rtd.TimezonesID = drtr.TimezonesID and rtd.City = drtr.City and rtd.Tariff = drtr.Tariff and  r.CodeDeckId = rr.CodeDeckId  AND  r.CodeDeckId = drtr.CodeDeckId

				SET rtd.EndDate = NOW()

				where
				rtd.RateTableID = @p_RateTableId and rtd.EffectiveDate = @p_EffectiveDate;


				call prc_ArchiveOldRateTableDIDRateAA(@p_RateTableId, NULL,@p_ModifiedBy);


			ELSE



					update tblRateTableDIDRate rtd
					INNER JOIN tblRateTable rt  on rt.RateTableID = rtd.RateTableID
					INNER JOIN tblRate r
						ON rtd.RateID  = r.RateID
					LEFT JOIN tblRate rr
						ON rtd.OriginationRateID  = rr.RateID
					inner join tmp_SelectedVendortblRateTableDIDRate drtr on
					drtr.Code = r.Code and drtr.OriginationCode = rr.Code
					and rtd.TimezonesID = drtr.TimezonesID and rtd.City = drtr.City and rtd.Tariff = drtr.Tariff and  r.CodeDeckId = rr.CodeDeckId  AND  r.CodeDeckId = drtr.CodeDeckId

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
								INNER JOIN tblRate r ON drtr.Code = r.Code and r.CodeDeckId = drtr.CodeDeckId
								LEFT JOIN tblRate rr ON drtr.OriginationCode = rr.Code and r.CodeDeckId = rr.CodeDeckId
								LEFT join tblRateTableDIDRateAA rtd  on rtd.RateID  = r.RateID and rtd.OriginationRateID  = rr.RateID
								and  rtd.TimezonesID = drtr.TimezonesID and rtd.City = drtr.City and rtd.Tariff = drtr.Tariff
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
								INNER JOIN tblRate r ON drtr.Code = r.Code and r.CodeDeckId = drtr.CodeDeckId
								LEFT JOIN tblRate rr ON drtr.OriginationCode = rr.Code and r.CodeDeckId = rr.CodeDeckId
								LEFT join tblRateTableDIDRate rtd  on rtd.RateID  = r.RateID and rtd.OriginationRateID  = rr.RateID
								and  rtd.TimezonesID = drtr.TimezonesID and rtd.City = drtr.City and rtd.Tariff = drtr.Tariff
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



			IF (@v_RateApprovalProcess_ = 1 ) THEN



				update tblRateTableDIDRateAA
				SET

				OneOffCost = IF(OneOffCost = 0 , NULL, ROUND(OneOffCost,IFNULL(@v_RoundChargedAmount,@v_CompanyRoundChargesAmount))),
				MonthlyCost = IF(MonthlyCost = 0 , NULL, ROUND(MonthlyCost,IFNULL(@v_RoundChargedAmount,@v_CompanyRoundChargesAmount))),
				CostPerCall = IF(CostPerCall = 0 , NULL, ROUND(CostPerCall,IFNULL(@v_RoundChargedAmount,@v_CompanyRoundChargesAmount))),
				CostPerMinute = IF(CostPerMinute = 0 , NULL, ROUND(CostPerMinute,IFNULL(@v_RoundChargedAmount,@v_CompanyRoundChargesAmount))),
				SurchargePerCall = IF(SurchargePerCall = 0 , NULL, ROUND(SurchargePerCall,IFNULL(@v_RoundChargedAmount,@v_CompanyRoundChargesAmount))),
				SurchargePerMinute = IF(SurchargePerMinute = 0 , NULL, ROUND(SurchargePerMinute,IFNULL(@v_RoundChargedAmount,@v_CompanyRoundChargesAmount))),
				OutpaymentPerCall = IF(OutpaymentPerCall = 0 , NULL, ROUND(OutpaymentPerCall,IFNULL(@v_RoundChargedAmount,@v_CompanyRoundChargesAmount))),
				OutpaymentPerMinute = IF(OutpaymentPerMinute = 0 , NULL, ROUND(OutpaymentPerMinute,IFNULL(@v_RoundChargedAmount,@v_CompanyRoundChargesAmount))),
				Surcharges = IF(Surcharges = 0 , NULL, ROUND(Surcharges,IFNULL(@v_RoundChargedAmount,@v_CompanyRoundChargesAmount))),
				Chargeback = IF(Chargeback = 0 , NULL, ROUND(Chargeback,IFNULL(@v_RoundChargedAmount,@v_CompanyRoundChargesAmount))),
				CollectionCostAmount = IF(CollectionCostAmount = 0 , NULL, ROUND(CollectionCostAmount,IFNULL(@v_RoundChargedAmount,@v_CompanyRoundChargesAmount))),
				CollectionCostPercentage = IF(CollectionCostPercentage = 0 , NULL, ROUND(CollectionCostPercentage,IFNULL(@v_RoundChargedAmount,@v_CompanyRoundChargesAmount))),
				RegistrationCostPerNumber = IF(RegistrationCostPerNumber = 0 , NULL, ROUND(RegistrationCostPerNumber,IFNULL(@v_RoundChargedAmount,@v_CompanyRoundChargesAmount))),
				updated_at = now(),
				ModifiedBy = @p_ModifiedBy

				where
				RateTableID = @p_RateTableId;



			ELSE


				update tblRateTableDIDRate
				SET

				OneOffCost = IF(OneOffCost = 0 , NULL, ROUND(OneOffCost,IFNULL(@v_RoundChargedAmount,@v_CompanyRoundChargesAmount))),
				MonthlyCost = IF(MonthlyCost = 0 , NULL, ROUND(MonthlyCost,IFNULL(@v_RoundChargedAmount,@v_CompanyRoundChargesAmount))),
				CostPerCall = IF(CostPerCall = 0 , NULL, ROUND(CostPerCall,IFNULL(@v_RoundChargedAmount,@v_CompanyRoundChargesAmount))),
				CostPerMinute = IF(CostPerMinute = 0 , NULL, ROUND(CostPerMinute,IFNULL(@v_RoundChargedAmount,@v_CompanyRoundChargesAmount))),
				SurchargePerCall = IF(SurchargePerCall = 0 , NULL, ROUND(SurchargePerCall,IFNULL(@v_RoundChargedAmount,@v_CompanyRoundChargesAmount))),
				SurchargePerMinute = IF(SurchargePerMinute = 0 , NULL, ROUND(SurchargePerMinute,IFNULL(@v_RoundChargedAmount,@v_CompanyRoundChargesAmount))),
				OutpaymentPerCall = IF(OutpaymentPerCall = 0 , NULL, ROUND(OutpaymentPerCall,IFNULL(@v_RoundChargedAmount,@v_CompanyRoundChargesAmount))),
				OutpaymentPerMinute = IF(OutpaymentPerMinute = 0 , NULL, ROUND(OutpaymentPerMinute,IFNULL(@v_RoundChargedAmount,@v_CompanyRoundChargesAmount))),
				Surcharges = IF(Surcharges = 0 , NULL, ROUND(Surcharges,IFNULL(@v_RoundChargedAmount,@v_CompanyRoundChargesAmount))),
				Chargeback = IF(Chargeback = 0 , NULL, ROUND(Chargeback,IFNULL(@v_RoundChargedAmount,@v_CompanyRoundChargesAmount))),
				CollectionCostAmount = IF(CollectionCostAmount = 0 , NULL, ROUND(CollectionCostAmount,IFNULL(@v_RoundChargedAmount,@v_CompanyRoundChargesAmount))),
				CollectionCostPercentage = IF(CollectionCostPercentage = 0 , NULL, ROUND(CollectionCostPercentage,IFNULL(@v_RoundChargedAmount,@v_CompanyRoundChargesAmount))),
				RegistrationCostPerNumber = IF(RegistrationCostPerNumber = 0 , NULL, ROUND(RegistrationCostPerNumber,IFNULL(@v_RoundChargedAmount,@v_CompanyRoundChargesAmount))),
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

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
