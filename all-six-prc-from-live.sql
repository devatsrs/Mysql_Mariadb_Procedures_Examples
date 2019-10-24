-- --------------------------------------------------------
-- Host:                         localhost
-- Server version:               10.4.8-MariaDB-log - MariaDB Server
-- Server OS:                    Linux
-- HeidiSQL Version:             9.5.0.5196
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Dumping structure for procedure speakintelligentRM.prc_GetDIDLCR
DROP PROCEDURE IF EXISTS `prc_GetDIDLCR`;
DELIMITER //
CREATE  PROCEDURE `prc_GetDIDLCR`(
	IN `p_companyid` INT,
	IN `p_CountryID` varchar(100),
	IN `p_AccessType` varchar(100),
	IN `p_City` varchar(100),
	IN `p_Tariff` VARCHAR(50),
	IN `p_Prefix` varchar(100),
	IN `p_CurrencyID` INT,
	IN `p_DIDCategoryID` INT,
	IN `p_Position` INT,
	IN `p_SelectedEffectiveDate` DATE,
	IN `p_Calls` INT,
	IN `p_Minutes` INT,
	IN `p_Timezone` INT,
	IN `p_TimezonePercentage` INT,
	IN `p_Origination` VARCHAR(100),
	IN `p_OriginationPercentage` INT,
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_NoOfServicesContracted` INT,
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_SortOrder` VARCHAR(50),
	IN `p_isExport` INT










































)
ThisSP:BEGIN



		SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;


        SET @p_companyid                    =p_companyid;
        SET @p_CountryID                    =p_CountryID;
        SET @p_AccessType                   =p_AccessType;
        SET @p_City                         =p_City;
        SET @p_Tariff                       =p_Tariff;
        SET @p_Prefix                       =p_Prefix;
        SET @p_CurrencyID                   =p_CurrencyID;
        SET @p_DIDCategoryID                =p_DIDCategoryID;
        SET @p_Position                     =p_Position;
        SET @p_SelectedEffectiveDate        =p_SelectedEffectiveDate;
        SET @p_Calls                        =p_Calls;
        SET @p_Minutes                      =p_Minutes;
        SET @p_Timezone                     =p_Timezone;
        SET @p_TimezonePercentage           =p_TimezonePercentage;
        SET @p_Origination                  =p_Origination;
        SET @p_OriginationPercentage        =p_OriginationPercentage;
        SET @p_StartDate                    =p_StartDate;
        SET @p_EndDate                      =p_EndDate;
        SET @p_NoOfServicesContracted       =p_NoOfServicesContracted;
        SET @p_PageNumber                   =p_PageNumber;
        SET @p_RowspPage                    =p_RowspPage;
        SET @p_SortOrder                    =p_SortOrder;
        SET @p_isExport                     =p_isExport;

        SET	@v_RateTypeID = 2;	
        set @v_AppliedToCustomer = 1; 
        set @v_AppliedToVendor = 2; 
        set @v_AppliedToReseller = 3; 
			
			/*
			
			comment test 
			
			*/
			


		SET @v_OffSet_ = (@p_PageNumber * @p_RowspPage) - @p_RowspPage;

		SELECT CurrencyId INTO @v_CompanyCurrencyID_ FROM  tblCompany WHERE CompanyID = @p_companyid;

        Select Value INTO @v_DestinationCurrencyConversionRate from tblCurrencyConversion where tblCurrencyConversion.CurrencyId =  @p_CurrencyID  and  CompanyID = @p_companyid;
        Select Value INTO @v_CompanyCurrencyConversionRate from tblCurrencyConversion where tblCurrencyConversion.CurrencyId =  @v_CompanyCurrencyID_  and  CompanyID = @p_companyid;

			DROP TEMPORARY TABLE IF EXISTS tmp_all_components;
				CREATE TEMPORARY TABLE tmp_all_components(
					ID int,
					component VARCHAR(200),
					component_title VARCHAR(200)
			);

			DROP TEMPORARY TABLE IF EXISTS tmp_table1_;
			CREATE TEMPORARY TABLE tmp_table1_ (
				TimezonesID  int,
				TimezoneTitle  varchar(100),
				AccessType varchar(200),
				CountryID int,
				City varchar(50),
				Tariff varchar(50),
				EffectiveDate DATE,
				Code varchar(100),
				OriginationCode  varchar(100),
				VendorConnectionID int,
				VendorConnectionName varchar(200),
				MonthlyCost DECIMAL(18,8),
				CostPerCall DECIMAL(18,8),
				CostPerMinute DECIMAL(18,8),
				SurchargePerCall DECIMAL(18,8),
				SurchargePerMinute DECIMAL(18,8),
				OutpaymentPerCall DECIMAL(18,8),
				OutpaymentPerMinute DECIMAL(18,8),
				Surcharges DECIMAL(18,8),
				Chargeback DECIMAL(18,8),
				CollectionCostAmount DECIMAL(18,8),
				CollectionCostPercentage DECIMAL(18,8),
				RegistrationCostPerNumber DECIMAL(18,8),
				Total DECIMAL(18,8)
			);

			DROP TEMPORARY TABLE IF EXISTS tmp_table1_dup;
			CREATE TEMPORARY TABLE tmp_table1_dup (
				TimezonesID  int,
				TimezoneTitle  varchar(100),
				AccessType varchar(200),
				CountryID int,
				City varchar(50),
				Tariff varchar(50),
				EffectiveDate DATE,
				Code varchar(100),
				OriginationCode  varchar(100),
				VendorConnectionID int,
				VendorConnectionName varchar(200),
				MonthlyCost DECIMAL(18,8),
				CostPerCall DECIMAL(18,8),
				CostPerMinute DECIMAL(18,8),
				SurchargePerCall DECIMAL(18,8),
				SurchargePerMinute DECIMAL(18,8),
				OutpaymentPerCall DECIMAL(18,8),
				OutpaymentPerMinute DECIMAL(18,8),
				Surcharges DECIMAL(18,8),
				Chargeback DECIMAL(18,8),
				CollectionCostAmount DECIMAL(18,8),
				CollectionCostPercentage DECIMAL(18,8),
				RegistrationCostPerNumber DECIMAL(18,8),
				Total DECIMAL(18,8)
			);


			DROP TEMPORARY TABLE IF EXISTS tmp_table_with_origination;
			CREATE TEMPORARY TABLE tmp_table_with_origination (

				TimezonesID  int,
				TimezoneTitle  varchar(100),
				AccessType varchar(200),
				CountryID int,
				City varchar(50),
				Tariff varchar(50),
				EffectiveDate DATE,
				Code varchar(100),
				OriginationCode  varchar(100),
				VendorConnectionID int,
				VendorConnectionName varchar(200),
				MonthlyCost DECIMAL(18,8),
				CostPerCall DECIMAL(18,8),
				CostPerMinute DECIMAL(18,8),
				SurchargePerCall DECIMAL(18,8),
				SurchargePerMinute DECIMAL(18,8),
				OutpaymentPerCall DECIMAL(18,8),
				OutpaymentPerMinute DECIMAL(18,8),
				Surcharges DECIMAL(18,8),
				Chargeback DECIMAL(18,8),
				CollectionCostAmount DECIMAL(18,8),
				CollectionCostPercentage DECIMAL(18,8),
				RegistrationCostPerNumber DECIMAL(18,8),
				
				OutPayment DECIMAL(18,8),
				Surcharge DECIMAL(18,8),

				Total1 DECIMAL(18,8),
				Total DECIMAL(18,8)
			);


			DROP TEMPORARY TABLE IF EXISTS tmp_tblRateTableDIDRate_step1;
			CREATE TEMPORARY TABLE tmp_tblRateTableDIDRate_step1 (

						TimezonesID  int,
						TimezoneTitle  varchar(100),
						AccessType varchar(200),
						CountryPrefix varchar(200),
						CountryID int,
						City varchar(50),
						Tariff varchar(50),
						EffectiveDate DATE,
						Code varchar(100),
						OriginationCode  varchar(100),
						VendorConnectionID int,
						VendorConnectionName varchar(200),
						MonthlyCost DECIMAL(18,8),
						TrunkCostPerService DECIMAL(18,8),
						CostPerCall DECIMAL(18,8),
						CostPerMinute DECIMAL(18,8),
						SurchargePerCall DECIMAL(18,8),
						SurchargePerMinute DECIMAL(18,8),
						OutpaymentPerCall DECIMAL(18,8),
						OutpaymentPerMinute DECIMAL(18,8),
						Surcharges DECIMAL(18,8),
						Chargeback DECIMAL(18,8),
						CollectionCostAmount DECIMAL(18,8),
						CollectionCostPercentage DECIMAL(18,8),
						RegistrationCostPerNumber DECIMAL(18,8)
			);

			DROP TEMPORARY TABLE IF EXISTS tmp_tblRateTableDIDRate_step1_dup;
			CREATE TEMPORARY TABLE tmp_tblRateTableDIDRate_step1_dup (

						TimezonesID  int,
						TimezoneTitle  varchar(100),
						AccessType varchar(200),
						CountryPrefix varchar(200),
						CountryID int,
						City varchar(50),
						Tariff varchar(50),
						EffectiveDate DATE,
						Code varchar(100),
						OriginationCode  varchar(100),
						VendorConnectionID int,
						VendorConnectionName varchar(200),
						MonthlyCost DECIMAL(18,8),
						TrunkCostPerService DECIMAL(18,8),
						CostPerCall DECIMAL(18,8),
						CostPerMinute DECIMAL(18,8),
						SurchargePerCall DECIMAL(18,8),
						SurchargePerMinute DECIMAL(18,8),
						OutpaymentPerCall DECIMAL(18,8),
						OutpaymentPerMinute DECIMAL(18,8),
						Surcharges DECIMAL(18,8),
						Chargeback DECIMAL(18,8),
						CollectionCostAmount DECIMAL(18,8),
						CollectionCostPercentage DECIMAL(18,8),
						RegistrationCostPerNumber DECIMAL(18,8)
			);

			DROP TEMPORARY TABLE IF EXISTS tmp_table_without_origination;
			CREATE TEMPORARY TABLE tmp_table_without_origination (

						TimezonesID  int,
						TimezoneTitle  varchar(100),
						AccessType varchar(200),
						CountryID int,
						City varchar(50),
						Tariff varchar(50),
						EffectiveDate DATE,
						Code varchar(100),
						OriginationCode  varchar(100),
						VendorConnectionID int,
						VendorConnectionName varchar(200),
						MonthlyCost DECIMAL(18,8),
						CostPerCall DECIMAL(18,8),
						CostPerMinute DECIMAL(18,8),
						SurchargePerCall DECIMAL(18,8),
						SurchargePerMinute DECIMAL(18,8),
						OutpaymentPerCall DECIMAL(18,8),
						OutpaymentPerMinute DECIMAL(18,8),
						Surcharges DECIMAL(18,8),
						Chargeback DECIMAL(18,8),
						CollectionCostAmount DECIMAL(18,8),
						CollectionCostPercentage DECIMAL(18,8),
						RegistrationCostPerNumber DECIMAL(18,8),

						OutPayment DECIMAL(18,8),
						Surcharge DECIMAL(18,8),
						
						Total1 DECIMAL(18,8),
						Total DECIMAL(18,8)
			);

				DROP TEMPORARY TABLE IF EXISTS tmp_vendors;
				CREATE TEMPORARY TABLE tmp_vendors (
					ID  int AUTO_INCREMENT,
					VendorConnectionName varchar(100),
					vPosition int,
					PRIMARY KEY (ID)
				);


			insert into tmp_all_components (ID, component , component_title )
				VALUES
				(1, 'MonthlyCost', 			'Monthly cost'),
				(2, 'CostPerCall'  , 		'Cost per call'),
				(3, 'CostPerMinute',			'Cost per minute'),
				(4, 'SurchargePerCall', 	'Surcharge per call'),
				(5, 'SurchargePerMinute',	'Surcharge per minute'),
				(6, 'OutpaymentPerCall', 	'Out payment per call'),
				(7, 'OutpaymentPerMinute', 'Out payment per minute'),
				(8, 'Surcharges',				'Surcharges'),
				(9, 'Chargeback',			   'Charge back'),
				(10, 'CollectionCostAmount','Collection cost - amount'),
				(11, 'CollectionCostPercentage', 'Collection cost - percentage'),
				(12, 'RegistrationCostPerNumber', 'Registration cost - per number');


			DROP TEMPORARY TABLE IF EXISTS tmp_table_output_1;
			CREATE TEMPORARY TABLE tmp_table_output_1 (

            AccessType varchar(200),
            CountryID int,
            City varchar(50),
            Tariff varchar(50),
            Code varchar(100),
            VendorConnectionID int,
            VendorConnectionName varchar(200),
            EffectiveDate DATE,
            Total DECIMAL(18,8)

			);


			DROP TEMPORARY TABLE IF EXISTS tmp_table_output_2;
			CREATE TEMPORARY TABLE tmp_table_output_2 (

            AccessType varchar(200),
            CountryID int,
            City varchar(50),
            Tariff varchar(50),
            Code varchar(100),
            VendorConnectionID int,
            VendorConnectionName varchar(200),
            EffectiveDate DATE,
            Total DECIMAL(18,8),
            vPosition int


			);


			DROP TEMPORARY TABLE IF EXISTS tmp_final_table_output;
			CREATE TEMPORARY TABLE tmp_final_table_output (

            AccessType varchar(200),
            Country varchar(100),
            City varchar(50),
            Tariff varchar(50),
            Code varchar(100),
            VendorConnectionID int,
            VendorConnectionName varchar(200),
            EffectiveDate DATE,
            Total varchar(200),
            vPosition int

			);


				DROP TEMPORARY TABLE IF EXISTS tmp_final_result;
			CREATE TEMPORARY TABLE tmp_final_result (
				Component  varchar(100)
			);


			DROP TEMPORARY TABLE IF EXISTS tmp_vendor_position;
			CREATE TEMPORARY TABLE tmp_vendor_position (
				VendorConnectionID int,
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


				CostPerMinute DECIMAL(18,8), 
				OutpaymentPerMinute DECIMAL(18,8),
				SurchargePerMinute DECIMAL(18,8),

				minute_CostPerMinute DECIMAL(18,2), 
				minute_OutpaymentPerMinute DECIMAL(18,2),
				minute_SurchargePerMinute DECIMAL(18,2),

				INDEX Index1 (TimezonesID),
				INDEX Index2 (VendorConnectionID),
				INDEX Index3 (AccessType),
				INDEX Index4 (CountryID),
				INDEX Index5 (City),
				INDEX Index6 (Tariff),
				INDEX Index7 (Code)


			);

			DROP TEMPORARY TABLE IF EXISTS tmp_timezone_minutes_2;
			CREATE TEMPORARY TABLE tmp_timezone_minutes_2 (
				TimezonesID int,
				VendorConnectionID int,
				AccessType varchar(200),
				CountryID int,
				City varchar(50),
				Tariff varchar(50),
				Code varchar(100),


				CostPerMinute DECIMAL(18,8), 
				OutpaymentPerMinute DECIMAL(18,8),
				SurchargePerMinute DECIMAL(18,8),

				minute_CostPerMinute DECIMAL(18,2), 
				minute_OutpaymentPerMinute DECIMAL(18,2),
				minute_SurchargePerMinute DECIMAL(18,2),

				
				INDEX Index1 (TimezonesID),
				INDEX Index2 (VendorConnectionID),
				INDEX Index3 (AccessType),
				INDEX Index4 (CountryID),
				INDEX Index5 (City),
				INDEX Index6 (Tariff),
				INDEX Index7 (Code)

			);

			DROP TEMPORARY TABLE IF EXISTS tmp_timezone_minutes_3;
			CREATE TEMPORARY TABLE tmp_timezone_minutes_3 (
				TimezonesID int,
				VendorConnectionID int,
				AccessType varchar(200),
				CountryID int,
				City varchar(50),
				Tariff varchar(50),
				Code varchar(100),


				CostPerMinute DECIMAL(18,8), 
				OutpaymentPerMinute DECIMAL(18,8),
				SurchargePerMinute DECIMAL(18,8),

				minute_CostPerMinute DECIMAL(18,2), 
				minute_OutpaymentPerMinute DECIMAL(18,2),
				minute_SurchargePerMinute DECIMAL(18,2),

				INDEX Index1 (TimezonesID),
				INDEX Index2 (VendorConnectionID),
				INDEX Index3 (AccessType),
				INDEX Index4 (CountryID),
				INDEX Index5 (City),
				INDEX Index6 (Tariff),
				INDEX Index7 (Code)

			);



			DROP TEMPORARY TABLE IF EXISTS tmp_accounts;
			CREATE TEMPORARY TABLE tmp_accounts (
				ID int auto_increment,
				VendorConnectionID int,
				AccessType varchar(200),
				CountryID int,
				City varchar(50),
				Tariff varchar(50),
				Code varchar(100),

				INDEX Index2 (VendorConnectionID),
				INDEX Index3 (AccessType),
				INDEX Index4 (CountryID),
				INDEX Index5 (City),
				INDEX Index6 (Tariff),
				INDEX Index7 (Code),

				Primary Key (ID )

			);



			DROP TEMPORARY TABLE IF EXISTS tmp_origination_minutes;
			CREATE TEMPORARY TABLE tmp_origination_minutes (
				OriginationCode varchar(50),
				minutes int
			);
			


			DROP TEMPORARY TABLE IF EXISTS tmp_NoOfServicesContracted;
			CREATE TEMPORARY TABLE tmp_NoOfServicesContracted (
				VendorID int,
				NoOfServicesContracted int
			);


 
 			set @p_CurrencySymbol = (SELECT Symbol from tblCurrency where CurrencyID = @p_CurrencyID);
			 
			SET @v_CallerRate = 1;

			SET @p_DIDCategoryID  		= @p_DIDCategoryID;
			SET @p_Prefix = TRIM(LEADING '0' FROM @p_Prefix);

			

			IF @p_NoOfServicesContracted >  0 THEN
			
				insert into tmp_NoOfServicesContracted (VendorID,NoOfServicesContracted)
				select null,@p_NoOfServicesContracted;
				
				
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

				select TimezonesID  , d.NoType, c.CountryID, d.CLIPrefix, d.City, d.Tariff, (sum(billed_duration) / 60), (sum(billed_duration) / 60), (sum(billed_duration) / 60) 

				from speakintelligentCDR.tblUsageDetails  d

				inner join speakintelligentCDR.tblUsageHeader h on d.UsageHeaderID = h.UsageHeaderID

				inner join speakintelligentRM.tblCountry c  on   d.CLIPrefix  like concat(c.Prefix,'%')

				where StartDate >= @p_StartDate AND StartDate <= @p_EndDate and d.is_inbound = 1 and TimezonesID is not null

				AND ( fn_IsEmpty(@p_CountryID) OR  c.CountryID = @p_CountryID )

				AND ( fn_IsEmpty(@p_AccessType)  OR d.NoType = @p_AccessType)

				AND ( fn_IsEmpty(@p_City)  OR d.City  = @p_City)

				AND ( fn_IsEmpty(@p_Tariff) OR d.Tariff  = @p_Tariff )

				AND ( fn_IsEmpty(@p_Prefix)  OR ( d.CLIPrefix   = concat(c.Prefix,  @p_Prefix )  ) )

				group by TimezonesID , d.NoType, c.CountryID, d.CLIPrefix, d.City, d.Tariff;


				insert into tmp_origination_minutes ( OriginationCode, minutes )

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

				group by CLIPrefix;


			ELSE




					insert into tmp_timezone_minutes ( VendorConnectionID, TimezonesID, AccessType,CountryID,Code,City,Tariff, CostPerMinute, OutpaymentPerMinute, SurchargePerMinute )
		
					
					select VendorConnectionID, TimezonesID, AccessType, CountryID, Code, City, Tariff , CostPerMinute, OutpaymentPerMinute, SurchargePerMinute
						from(
						
						Select DISTINCT vc.VendorConnectionID, drtr.TimezonesID, drtr.AccessType, c.CountryID,r.Code, drtr.City, drtr.Tariff , sum(drtr.CostPerMinute) as CostPerMinute, sum(drtr.OutpaymentPerMinute) as OutpaymentPerMinute, sum(drtr.SurchargePerMinute) as SurchargePerMinute
		
						from tblRateTableDIDRate  drtr
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

							rt.CompanyId =  @p_companyid

							and vc.DIDCategoryID = @p_DIDCategoryID

							and drtr.ApprovedStatus = 1

							and rt.Type = @v_RateTypeID

							and rt.AppliedTo = @v_AppliedToVendor

							AND EffectiveDate <= DATE(@p_SelectedEffectiveDate)

							AND (EndDate is NULL OR EndDate > now() )

							group by VendorConnectionID, TimezonesID, AccessType, CountryID, r.Code, City, Tariff

						)	tmp ;

						
					
					

						 



					SET @p_PeakTimeZonePercentage	 		 = @p_TimezonePercentage;
					SET @p_MobileOrigination				 = @p_Origination ;
					SET @p_MobileOriginationPercentage	 	 = @p_OriginationPercentage ;


					

					

					

					INSERT INTO tmp_accounts ( VendorConnectionID ,AccessType,CountryID,Code,City,Tariff )  SELECT DISTINCT VendorConnectionID, AccessType,CountryID,Code,City,Tariff FROM tmp_timezone_minutes;

					
												

					IF @p_PeakTimeZonePercentage > 0 THEN
					
						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET minute_CostPerMinute = ( (@p_Minutes/ 100) * @p_PeakTimeZonePercentage )
												
						WHERE  tzm.TimezonesID = @p_Timezone AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff AND tzm.CostPerMinute IS NOT NULL;

						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET minute_OutpaymentPerMinute =  ( (@p_Minutes/ 100) * @p_PeakTimeZonePercentage )
												
						WHERE  tzm.TimezonesID = @p_Timezone AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff AND tzm.OutpaymentPerMinute IS NOT NULL;

						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET minute_SurchargePerMinute = ( (@p_Minutes/ 100) * @p_PeakTimeZonePercentage )
												
						WHERE  tzm.TimezonesID = @p_Timezone AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff AND tzm.SurchargePerMinute IS NOT NULL;

 
						
					
					

						INSERT INTO tmp_timezone_minutes_2 SELECT * FROM tmp_timezone_minutes;
						INSERT INTO tmp_timezone_minutes_3 SELECT * FROM tmp_timezone_minutes;


						
										
										

						
						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET minute_CostPerMinute = ( @p_Minutes - IFNULL((select tzmd2.minute_CostPerMinute 
																			from tmp_timezone_minutes_3 tzmd2 WHERE tzmd2.TimezonesID = @p_Timezone AND tzmd2.VendorConnectionID = a.VendorConnectionID AND tzmd2.AccessType = a.AccessType AND tzmd2.CountryID = a.CountryID AND tzmd2.Code = a.Code AND tzmd2.City = a.City 
																			AND tzmd2.Tariff = a.Tariff AND tzmd2.CostPerMinute IS NOT NULL),0) )   
														/ (  select count(*)  from tmp_timezone_minutes_2 tzmd WHERE tzmd.TimezonesID != @p_Timezone AND tzmd.VendorConnectionID = a.VendorConnectionID AND tzmd.AccessType = a.AccessType AND tzmd.CountryID = a.CountryID AND tzmd.Code = a.Code AND tzmd.City = a.City 
														AND tzmd.Tariff = a.Tariff AND tzmd.CostPerMinute IS NOT NULL) 
						WHERE  (tzm.TimezonesID != @p_Timezone) AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.Code = a.Code AND tzm.City = a.City 
													AND tzm.Tariff = a.Tariff AND tzm.CostPerMinute IS NOT NULL;

						
						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET minute_OutpaymentPerMinute = ( @p_Minutes - IFNULL((select tzmd2.minute_OutpaymentPerMinute 
																			from tmp_timezone_minutes_3 tzmd2 WHERE tzmd2.TimezonesID = @p_Timezone AND tzmd2.VendorConnectionID = a.VendorConnectionID AND tzmd2.AccessType = a.AccessType AND tzmd2.CountryID = a.CountryID AND tzmd2.Code = a.Code AND tzmd2.City = a.City 
																			AND tzmd2.Tariff = a.Tariff AND tzmd2.OutpaymentPerMinute IS NOT NULL),0) )   
														/ (  select count(*)  from tmp_timezone_minutes_2 tzmd WHERE tzmd.TimezonesID != @p_Timezone AND tzmd.VendorConnectionID = a.VendorConnectionID AND tzmd.AccessType = a.AccessType AND tzmd.CountryID = a.CountryID AND tzmd.Code = a.Code AND tzmd.City = a.City 
														AND tzmd.Tariff = a.Tariff AND tzmd.OutpaymentPerMinute IS NOT NULL) 
						WHERE  (tzm.TimezonesID != @p_Timezone) AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.Code = a.Code AND tzm.City = a.City 
													AND tzm.Tariff = a.Tariff AND tzm.OutpaymentPerMinute IS NOT NULL;
						
						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET minute_SurchargePerMinute = ( @p_Minutes - IFNULL((select tzmd2.minute_SurchargePerMinute 
																			from tmp_timezone_minutes_3 tzmd2 WHERE (tzmd2.TimezonesID = @p_Timezone) AND tzmd2.VendorConnectionID = a.VendorConnectionID AND tzmd2.AccessType = a.AccessType AND tzmd2.CountryID = a.CountryID AND tzmd2.Code = a.Code AND tzmd2.City = a.City 
																			AND tzmd2.Tariff = a.Tariff AND tzmd2.SurchargePerMinute IS NOT NULL),0) )   
														/ (  select count(*)  from tmp_timezone_minutes_2 tzmd WHERE tzmd.TimezonesID != @p_Timezone AND tzmd.VendorConnectionID = a.VendorConnectionID AND tzmd.AccessType = a.AccessType AND tzmd.CountryID = a.CountryID AND tzmd.Code = a.Code AND tzmd.City = a.City 
														AND tzmd.Tariff = a.Tariff AND tzmd.SurchargePerMinute IS NOT NULL) 
						WHERE  (tzm.TimezonesID != @p_Timezone) AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.Code = a.Code AND tzm.City = a.City 
													AND tzm.Tariff = a.Tariff AND tzm.SurchargePerMinute IS NOT NULL;
						


							
							UPDATE  tmp_timezone_minutes tzm
							INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
							SET minute_CostPerMinute = @p_Minutes
							WHERE  (tzm.TimezonesID = @p_Timezone) AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.Code = a.Code AND tzm.City = a.City 
														AND tzm.Tariff = a.Tariff AND tzm.CostPerMinute IS NOT NULL
														AND	(  select count(*)  from tmp_timezone_minutes_2 tzmd 
														WHERE tzmd.TimezonesID != @p_Timezone 
														AND tzmd.VendorConnectionID = a.VendorConnectionID AND tzmd.AccessType = a.AccessType AND tzmd.CountryID = a.CountryID AND tzmd.Code = a.Code AND tzmd.City = a.City AND tzmd.Tariff = a.Tariff AND tzmd.CostPerMinute IS NOT NULL) = 0;

							UPDATE  tmp_timezone_minutes tzm
							INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
							SET minute_OutpaymentPerMinute = @p_Minutes
							WHERE  (tzm.TimezonesID = @p_Timezone) AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.Code = a.Code AND tzm.City = a.City 
														AND tzm.Tariff = a.Tariff AND tzm.OutpaymentPerMinute IS NOT NULL
														AND	(  select count(*)  from tmp_timezone_minutes_2 tzmd
														WHERE tzmd.TimezonesID != @p_Timezone 
														AND tzmd.VendorConnectionID = a.VendorConnectionID AND tzmd.AccessType = a.AccessType AND tzmd.CountryID = a.CountryID AND tzmd.Code = a.Code AND tzmd.City = a.City  AND tzmd.Tariff = a.Tariff AND tzmd.OutpaymentPerMinute IS NOT NULL ) = 0;


							UPDATE  tmp_timezone_minutes tzm
							INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
							SET minute_SurchargePerMinute = @p_Minutes
							WHERE  (tzm.TimezonesID = @p_Timezone) AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.Code = a.Code AND tzm.City = a.City 
														AND tzm.Tariff = a.Tariff AND tzm.SurchargePerMinute IS NOT NULL
														AND	(  select count(*)  from tmp_timezone_minutes_2 tzmd 
														WHERE tzmd.TimezonesID != @p_Timezone
														AND tzmd.VendorConnectionID = a.VendorConnectionID AND tzmd.AccessType = a.AccessType AND tzmd.CountryID = a.CountryID AND tzmd.Code = a.Code AND tzmd.City = a.City AND tzmd.Tariff = a.Tariff AND tzmd.SurchargePerMinute IS NOT NULL) = 0;


							

					ELSE 

						INSERT INTO tmp_timezone_minutes_2 SELECT * FROM tmp_timezone_minutes;

						
						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET minute_CostPerMinute =  @p_Minutes /  (select count(DISTINCT tzmd.TimezonesID) from tmp_timezone_minutes_2 tzmd WHERE tzmd.VendorConnectionID = tzm.VendorConnectionID AND tzmd.AccessType = tzm.AccessType AND tzmd.CountryID = tzm.CountryID AND tzmd.Code = tzm.Code AND tzmd.City = tzm.City AND tzmd.Tariff = tzm.Tariff AND tzmd.CostPerMinute IS NOT NULL )
												 
						WHERE   tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff AND tzm.CostPerMinute IS NOT NULL;

						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET minute_OutpaymentPerMinute = @p_Minutes /  (select count(DISTINCT tzmd.TimezonesID) from tmp_timezone_minutes_2 tzmd WHERE tzmd.VendorConnectionID = tzm.VendorConnectionID AND tzmd.AccessType = tzm.AccessType AND tzmd.CountryID = tzm.CountryID AND tzmd.Code = tzm.Code AND tzmd.City = tzm.City AND tzmd.Tariff = tzm.Tariff AND tzmd.OutpaymentPerMinute IS NOT NULL)
												
						WHERE   tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff AND tzm.OutpaymentPerMinute IS NOT NULL;

						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET minute_SurchargePerMinute = @p_Minutes /  (select count(DISTINCT tzmd.TimezonesID) from tmp_timezone_minutes_2 tzmd WHERE tzmd.VendorConnectionID = a.VendorConnectionID AND tzmd.AccessType = a.AccessType AND tzmd.CountryID = a.CountryID AND tzmd.Code = a.Code AND tzmd.City = a.City AND tzmd.Tariff = a.Tariff AND tzmd.SurchargePerMinute IS NOT NULL)
												
						WHERE   tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff AND tzm.SurchargePerMinute IS NOT NULL;


					END IF;

					


					
					
					

					


					SET @v_MinutesFromMobileOrigination  =  ( (@p_Minutes/ 100) * @p_MobileOriginationPercentage ) 	;

					insert into tmp_origination_minutes ( OriginationCode, minutes )
					select @p_MobileOrigination  , @v_MinutesFromMobileOrigination ;
 

			END IF;


			SET @v_days =    TIMESTAMPDIFF(DAY, (SELECT @p_StartDate), (SELECT @p_EndDate)) + 1 ;
			SET @v_period1 =      IF(MONTH((SELECT @p_StartDate)) = MONTH((SELECT @p_EndDate)), 0, (TIMESTAMPDIFF(DAY, (SELECT @p_StartDate), LAST_DAY((SELECT @p_StartDate)) + INTERVAL 0 DAY)) / DAY(LAST_DAY((SELECT @p_StartDate))));
			SET @v_period2 =      TIMESTAMPDIFF(MONTH, LAST_DAY((SELECT @p_StartDate)) + INTERVAL 1 DAY, LAST_DAY((SELECT @p_EndDate))) ;
			SET @v_period3 =      IF(MONTH((SELECT @p_StartDate)) = MONTH((SELECT @p_EndDate)), (SELECT @v_days), DAY((SELECT @p_EndDate))) / DAY(LAST_DAY((SELECT @p_EndDate)));
			SET @p_months =     (SELECT @v_period1) + (SELECT @v_period2) + (SELECT @v_period3);

			SET @p_months = fn_Round(@p_months,1);



			
			delete from tmp_timezone_minutes where minute_OutpaymentPerMinute is null and minute_SurchargePerMinute is null and minute_CostPerMinute is null;

			
			insert into tmp_tblRateTableDIDRate_step1
			(
								TimezonesID,
								TimezoneTitle,
								AccessType,
								CountryPrefix,
								CountryID ,
								City ,
								Tariff ,
								EffectiveDate,
								Code,
								OriginationCode,
								VendorConnectionID,
								VendorConnectionName,
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
								drtr.TimezonesID,
								t.Title as TimezoneTitle,
								drtr.AccessType,
								c.Prefix as CountryPrefix,
								r.CountryID,
								drtr.City,
								drtr.Tariff ,
								drtr.EffectiveDate,
								r.Code,
								r2.Code as OriginationCode,
								vc.VendorConnectionID,
								vc.Name as VendorConnectionName,


								@MonthlyCost := 
								(
									CASE WHEN ( MonthlyCostCurrency is not null)
									THEN

										CASE WHEN  @p_CurrencyID = MonthlyCostCurrency THEN
											drtr.MonthlyCost
										ELSE
										(

											(@v_DestinationCurrencyConversionRate  ) * (drtr.MonthlyCost  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = MonthlyCostCurrency and  CompanyID = @p_companyid ))
										)
										END

									ELSE
										(
											( @v_DestinationCurrencyConversionRate ) * ( drtr.MonthlyCost  / (@v_CompanyCurrencyConversionRate ) )
										)
									END  
								) as MonthlyCost,

								@TrunkCostPerService := 
								IFNULL(
								(
									(
										CASE WHEN ( vtc.CurrencyID is not null)
										THEN
											CASE WHEN  @p_CurrencyID = vtc.CurrencyID THEN
												vtc.Cost
											ELSE
											(

												(@v_DestinationCurrencyConversionRate)
												* (vtc.Cost  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = vtc.CurrencyID and  CompanyID = @p_companyid ))
											)
											
											END
										ELSE 
											0
										END
									) / (select NoOfServicesContracted from  tmp_NoOfServicesContracted sc where sc.VendorID is null or sc.VendorID  = a.AccountID )
								),0 ) as TrunkCostPerService,

								@CostPerCall := CASE WHEN ( CostPerCallCurrency is not null)
								THEN

                                            CASE WHEN  @p_CurrencyID = CostPerCallCurrency THEN
                                                drtr.CostPerCall
                                            ELSE
                                            (

                                                (@v_DestinationCurrencyConversionRate )
                                                * (drtr.CostPerCall  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = CostPerCallCurrency and  CompanyID = @p_companyid ))
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

                                            CASE WHEN  @p_CurrencyID = CostPerMinuteCurrency THEN
                                                drtr.CostPerMinute
                                            ELSE
                                            (

                                                (@v_DestinationCurrencyConversionRate )
                                                * (drtr.CostPerMinute  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = CostPerMinuteCurrency and  CompanyID = @p_companyid ))
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

                                        CASE WHEN  @p_CurrencyID = SurchargePerCallCurrency THEN
                                            drtr.SurchargePerCall
                                        ELSE
                                        (

                                            (@v_DestinationCurrencyConversionRate )
                                            * (drtr.SurchargePerCall  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = SurchargePerCallCurrency and  CompanyID = @p_companyid ))
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

                                        CASE WHEN  @p_CurrencyID = SurchargePerMinuteCurrency THEN
                                            drtr.SurchargePerMinute
                                        ELSE
                                        (

                                            (@v_DestinationCurrencyConversionRate )
                                            * (drtr.SurchargePerMinute  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = SurchargePerMinuteCurrency and  CompanyID = @p_companyid ))
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

                                        CASE WHEN  @p_CurrencyID = OutpaymentPerCallCurrency THEN
                                            drtr.OutpaymentPerCall
                                        ELSE
                                        (

                                            (@v_DestinationCurrencyConversionRate )
                                            * (drtr.OutpaymentPerCall  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = OutpaymentPerCallCurrency and  CompanyID = @p_companyid ))
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

                                        CASE WHEN  @p_CurrencyID = OutpaymentPerMinuteCurrency THEN
                                            drtr.OutpaymentPerMinute
                                        ELSE
                                        (

                                            (@v_DestinationCurrencyConversionRate )
                                            * (drtr.OutpaymentPerMinute  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = OutpaymentPerMinuteCurrency and  CompanyID = @p_companyid ))
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

                                        CASE WHEN  @p_CurrencyID = SurchargesCurrency THEN
                                            drtr.Surcharges
                                        ELSE
                                        (

                                            (@v_DestinationCurrencyConversionRate )
                                            * (drtr.Surcharges  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = SurchargesCurrency and  CompanyID = @p_companyid ))
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

                                        CASE WHEN  @p_CurrencyID = CollectionCostAmountCurrency THEN
                                            drtr.CollectionCostAmount
                                        ELSE
                                        (

                                            (@v_DestinationCurrencyConversionRate )
                                            * (drtr.CollectionCostAmount  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = CollectionCostAmountCurrency and  CompanyID = @p_companyid ))
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

                                        CASE WHEN  @p_CurrencyID = RegistrationCostPerNumberCurrency THEN
                                            drtr.RegistrationCostPerNumber
                                        ELSE
                                        (

                                            (@v_DestinationCurrencyConversionRate )
                                            * (drtr.RegistrationCostPerNumber  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = RegistrationCostPerNumberCurrency and  CompanyID = @p_companyid ))
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
						inner join tblVendorConnection vc on vc.RateTableID = rt.RateTableId and ((vc.DIDCategoryID IS NOT NULL AND rt.DIDCategoryID IS NOT NULL) AND vc.DIDCategoryID = rt.DIDCategoryID) and vc.CompanyID = rt.CompanyId  and vc.Active=1
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

						rt.CompanyId =  @p_companyid

						and vc.DIDCategoryID = @p_DIDCategoryID

						and drtr.ApprovedStatus = 1

						and rt.Type = @v_RateTypeID

						and rt.AppliedTo = @v_AppliedToVendor

						AND EffectiveDate <= DATE(@p_SelectedEffectiveDate)

						AND (EndDate is NULL OR EndDate > now() );



		insert into tmp_tblRateTableDIDRate_step1_dup (VendorConnectionID,  TimezonesID, AccessType, CountryID,  Code, City, Tariff )
		select  VendorConnectionID,  max(TimezonesID) as TimezonesID, AccessType, CountryID,  Code,City, Tariff 
		from tmp_tblRateTableDIDRate_step1 
		where  MonthlyCost > 0
		group by  VendorConnectionID,  AccessType, CountryID, CountryPrefix, Code,City, Tariff ;

	
		update tmp_tblRateTableDIDRate_step1 svr
		INNER JOIN tmp_tblRateTableDIDRate_step1_dup svr2 on 
					svr.VendorConnectionID = svr2.VendorConnectionID AND 
					svr.TimezonesID != svr2.TimezonesID AND 
					svr.AccessType = svr2.AccessType AND 
					svr.CountryID = svr2.CountryID AND 
					svr.Code = svr2.Code AND 
					svr.City = svr2.City AND 
					svr.Tariff = svr2.Tariff 
		SET svr.MonthlyCost = 0
		where svr.MonthlyCost > 0 and svr2.TimezonesID is not null and svr.TimezonesID is not null;


		
					insert into tmp_table_without_origination (

								TimezonesID,
								TimezoneTitle,
								AccessType,
								CountryID ,
								City ,
								Tariff ,
								EffectiveDate,
								Code,
								OriginationCode,
								VendorConnectionID,
								VendorConnectionName,
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
								OutPayment,
								Surcharge,
								Total
					)
					select  
							drtr.TimezonesID,
							drtr.TimezoneTitle,
							drtr.AccessType,
							drtr.CountryID ,
							drtr.City ,
							drtr.Tariff ,
							drtr.EffectiveDate,
							drtr.Code,
							drtr.OriginationCode,
							drtr.VendorConnectionID,
							drtr.VendorConnectionName,
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

									( IFNULL(drtr.OutpaymentPerCall,0) * 	@p_Calls )  +
									( IFNULL(drtr.OutpaymentPerMinute,0) *  IFNULL(tm.minute_OutpaymentPerMinute,0))	
									
								),

								@Surcharge := (
									CASE WHEN IFNULL(drtr.SurchargePerCall,0) = 0 AND IFNULL(drtr.SurchargePerMinute,0) = 0 THEN
										(IFNULL(drtr.Surcharges,0) * @p_Calls)
									ELSE 	
										(
											(IFNULL(drtr.SurchargePerCall,0) * @p_Calls ) +
											(IFNULL(drtr.SurchargePerMinute,0) * IFNULL(tm.minute_SurchargePerMinute,0))	
										)
									END 
								),
								@Total := (

									(	(IFNULL(drtr.MonthlyCost,0)* @p_months)	 +  drtr.TrunkCostPerService	)				+ 

									( IFNULL(drtr.CollectionCostAmount,0) * @p_Calls ) +
									(IFNULL(drtr.CostPerCall,0) * @p_Calls)		+
									(IFNULL(drtr.CostPerMinute,0) * IFNULL(tm.minute_CostPerMinute,0))	+
									
									@Surcharge  - @OutPayment +

									(
										( ( (@OutPayment * 1.21) ) * IFNULL(drtr.CollectionCostPercentage,0)/100 ) +
										( ( (@OutPayment  * IFNULL(drtr.Chargeback,0)/100 ) ) )
									)

								)
								 as Total
								

						from tmp_tblRateTableDIDRate_step1  drtr
						LEFT JOIN  tmp_timezone_minutes tm on drtr.TimezonesID = tm.TimezonesID   and ( tm.VendorConnectionID is null OR drtr.VendorConnectionID = tm.VendorConnectionID ) 
						AND drtr.AccessType = tm.AccessType AND drtr.CountryID = tm.CountryID  AND drtr.Code = tm.Code AND drtr.City = tm.City AND  drtr.Tariff  = tm.Tariff;


					insert into tmp_table_with_origination
					(

							TimezonesID,
							TimezoneTitle,
							AccessType,
							CountryID,
							City ,
							Tariff ,

							Code,
							OriginationCode,
							VendorConnectionID,
							VendorConnectionName,
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
							Outpayment,
							Surcharge,
							Total
					)
							 
					select
						drtr.TimezonesID,
						drtr.TimezoneTitle,
						drtr.AccessType,
						drtr.CountryID,
						drtr.City ,
						drtr.Tariff ,
						drtr.Code,
						drtr.OriginationCode,
						drtr.VendorConnectionID,
						drtr.VendorConnectionName,
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

						( IFNULL(drtr.OutpaymentPerCall,0) * 	@p_Calls )  +
						( IFNULL(drtr.OutpaymentPerMinute,0) *  IFNULL(tom.minutes,0))	
						
					),

					@Surcharge := (
						CASE WHEN IFNULL(drtr.SurchargePerCall,0) = 0 AND IFNULL(drtr.SurchargePerMinute,0) = 0 THEN
							IFNULL(drtr.Surcharges,0) * @p_Calls
						ELSE 	
							(
								(IFNULL(drtr.SurchargePerCall,0) * @p_Calls ) +
								(IFNULL(drtr.SurchargePerMinute,0) * IFNULL(tom.minutes,0))		
							)
						END 
					),
					@Total := (

						(	(IFNULL(drtr.MonthlyCost,0)* @p_months)	 +  drtr.TrunkCostPerService	)				+ 

						( IFNULL(drtr.CollectionCostAmount,0) * @p_Calls ) +
						(IFNULL(drtr.CostPerCall,0) * @p_Calls)		+
						(IFNULL(drtr.CostPerMinute,0) * IFNULL(tom.minutes,0))		+
						
						@Surcharge - @OutPayment +

						(
							( ( (@OutPayment * 1.21) ) * IFNULL(drtr.CollectionCostPercentage,0)/100 ) +
							( ( (@OutPayment  * IFNULL(drtr.Chargeback,0)/100 ) ) )
						)

					)
						as Total
							
				from tmp_tblRateTableDIDRate_step1  drtr
				inner join tmp_origination_minutes tom  on drtr.OriginationCode = tom.OriginationCode;




				delete t1 from tmp_table_without_origination t1 inner join tmp_table_with_origination t2 on t1.VendorConnectionID = t2.VendorConnectionID and t1.TimezonesID = t2.TimezonesID and t1.Code = t2.Code;



					insert into tmp_table1_ (

																TimezonesID,
																TimezoneTitle,
																AccessType,
																CountryID,
																City,
																Tariff,
																EffectiveDate,
																Code,
																OriginationCode,
																VendorConnectionID,
																VendorConnectionName,
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
																Total
																)

																select
																TimezonesID,
																TimezoneTitle,
																AccessType,
																CountryID,
																City,
																Tariff,
																EffectiveDate,
																Code,
																OriginationCode,
																VendorConnectionID,
																VendorConnectionName,
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
																Total
																from (
																		select
																		TimezonesID,
																		TimezoneTitle,
																		AccessType,
																		CountryID,
																		City,
																		Tariff,
																		EffectiveDate,
																		Code,
																		OriginationCode,
																		VendorConnectionID,
																		VendorConnectionName,
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
																		Total
																		from
																		tmp_table_without_origination

																		union all

																		select
																		TimezonesID,
																		TimezoneTitle,
																		AccessType,
																		CountryID,
																		City,
																		Tariff,
																		EffectiveDate,
																		Code,
																		OriginationCode,
																		VendorConnectionID,
																		VendorConnectionName,
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
																		Total
																		from
																		tmp_table_with_origination

																) tmp
																where Total is not null;

		
			


      insert into tmp_table_output_1
      (AccessType ,CountryID ,City ,Tariff,Code ,VendorConnectionID ,VendorConnectionName,EffectiveDate,Total)
      select AccessType ,CountryID ,City ,Tariff,Code ,VendorConnectionID ,VendorConnectionName,max(EffectiveDate),sum(Total) as Total
      from tmp_table1_
      group by AccessType ,CountryID ,City ,Tariff,Code ,VendorConnectionID ,VendorConnectionName;


      insert into tmp_table_output_2   ( AccessType ,CountryID ,City ,Tariff,Code ,VendorConnectionID ,VendorConnectionName,EffectiveDate,Total,vPosition )

      SELECT AccessType ,CountryID ,City ,Tariff,Code ,VendorConnectionID ,VendorConnectionName,EffectiveDate,Total,vPosition
      FROM (
        				select AccessType ,CountryID ,City ,Tariff,Code ,VendorConnectionID ,VendorConnectionName,EffectiveDate,Total,
                      @vPosition := (
                      	CASE WHEN (@prev_Code = Code AND  @prev_AccessType    = AccessType AND  @prev_CountryID = CountryID AND  @prev_City    = City AND  @prev_Tariff = Tariff  AND @prev_Total <  Total )  THEN   @vPosition + 1
                      	    WHEN (@prev_Code = Code AND  @prev_AccessType    = AccessType AND  @prev_CountryID = CountryID AND  @prev_City    = City AND  @prev_Tariff = Tariff  AND @prev_Total =  Total )  THEN   @vPosition 
                      
					  ELSE
                        1
                      END) as  vPosition,
                      @prev_AccessType := AccessType ,
                      @prev_CountryID  := CountryID  ,
                      @prev_City  := City  ,
                      @prev_Tariff := Tariff ,
                      @prev_Code  := Code  ,
                      @prev_VendorConnectionID  := VendorConnectionID,
                      @prev_Total := Total

        from tmp_table_output_1
            ,(SELECT  @vPosition := 0 , @prev_AccessType := '' ,@prev_CountryID  := '' ,@prev_City  := '' ,@prev_Tariff := '' ,@prev_Code  := ''  , @prev_VendorConnectionID  := '', @prev_Total := 0 ) t

        ORDER BY Code,AccessType,CountryID,City,Tariff,Total,VendorConnectionID
      ) tmp;


      insert into tmp_final_table_output
      (AccessType ,Country ,City ,Tariff,Code ,VendorConnectionID ,VendorConnectionName,EffectiveDate, Total,vPosition)
      select AccessType ,Country ,City ,Tariff,Code ,VendorConnectionID ,VendorConnectionName,EffectiveDate, concat( @p_CurrencySymbol, Total ),vPosition
      from tmp_table_output_2 t
      LEFT JOIN tblCountry  c on t.CountryID = c.CountryID
      where vPosition  < @p_Position ;


  		SET @stm_columns = "";

      IF @p_isExport = 0 AND @p_Position > 10 THEN
        SET @p_Position = 10;
      END IF;



			SET @v_pointer_ = 1;
			WHILE @v_pointer_ <= @p_Position
			DO

          SET @stm_columns = CONCAT(@stm_columns, "CONCAT(if(MIN(vPosition) = ",@v_pointer_,", CONCAT(MIN(Total), '<br>', MIN(VendorConnectionName), '<br>', DATE_FORMAT(MIN(EffectiveDate), '%d/%m/%Y'),'' ), NULL) ) AS `POSITION ",@v_pointer_,"`,");

				SET @v_pointer_ = @v_pointer_ + 1;

			END WHILE;

			SET @stm_columns = TRIM(TRAILING ',' FROM @stm_columns);

			IF (@p_isExport = 0)
			THEN

        SET @stm_query = CONCAT("SELECT AccessType ,Country ,Code,City ,Tariff, ", @stm_columns," FROM tmp_final_table_output GROUP BY Code, AccessType ,Country ,City ,Tariff    ORDER BY Code, AccessType ,Country ,City ,Tariff  LIMIT ",@p_RowspPage," OFFSET ",@v_OffSet_," ;");

		   select count(Code) as totalcount from ( select Code from tmp_final_table_output GROUP BY Code, AccessType ,Country ,City ,Tariff ) tmp   ;

			PREPARE stm_query FROM @stm_query;
			EXECUTE stm_query;
			DEALLOCATE PREPARE stm_query;

      ELSE

        SET @stm_query = CONCAT("SELECT AccessType ,Country ,Code,City ,Tariff,  ", @stm_columns," FROM tmp_final_table_output GROUP BY Code, AccessType ,Country ,City ,Tariff      ORDER BY Code, AccessType ,Country ,City ,Tariff  ;");


			PREPARE stm_query FROM @stm_query;
			EXECUTE stm_query;
			DEALLOCATE PREPARE stm_query;


      END IF;

    		

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;

-- Dumping structure for procedure speakintelligentRM.prc_GetLCR
DROP PROCEDURE IF EXISTS `prc_GetLCR`;
DELIMITER //
CREATE  PROCEDURE `prc_GetLCR`(
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
        
        SET @p_SelectedEffectiveDate        = p_SelectedEffectiveDate;
        
        
        
        SET @p_isExport                     = p_isExport;



        SET	@v_RateTypeID = 1;	
        set @v_AppliedToCustomer = 1; 
        set @v_AppliedToVendor = 2; 
        set @v_AppliedToReseller = 3; 


		SET @v_default_TimezonesID = 1; 

		SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

		SET @@session.collation_connection='utf8_unicode_ci';
		SET @@session.character_set_results='utf8';



		SET @v_OffSet_ = (@p_PageNumber * @p_RowspPage) - @p_RowspPage;

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
			prev_TimezonesID int	,
			INDEX Index1 (RowCode,TimezonesID,VendorConnectionID),
			INDEX Index2 (OriginationCode,Code),
			INDEX Index3 (MaxMatchRank)

		);

 		DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_stage_1;
		CREATE TEMPORARY TABLE tmp_VendorRate_stage_1 (
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
			INDEX Index1 (RowCode,TimezonesID,VendorConnectionID),
			INDEX Index2 (OriginationCode,Code)

		);

 		DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_stage_1_DEFAULT;
		CREATE TEMPORARY TABLE tmp_VendorRate_stage_1_DEFAULT (
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
			INDEX Index1 (VendorConnectionID),
			INDEX Index2 (OriginationCode,RowCode)

		);


 		DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_stage_1_dup;
		CREATE TEMPORARY TABLE tmp_VendorRate_stage_1_dup (
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

			INDEX Index1 (VendorConnectionID),
			INDEX Index2 (TimezonesID,OriginationCode,RowCode)
			
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
		)
		;

		DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_;
		CREATE TEMPORARY TABLE tmp_VendorRate_ (
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
			RowCode VARCHAR(50),

			INDEX Index1 (OriginationCode,RowCode),
			INDEX Index2 (TimezonesID,Rate,VendorConnectionID)
		
		)
		;

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

		)
		;



		DROP TEMPORARY TABLE IF EXISTS tmp_search_code_;
		CREATE TEMPORARY TABLE tmp_search_code_ (
			Code  varchar(50),
			RowCode  varchar(50)
			
		);



		DROP TEMPORARY TABLE IF EXISTS tmp_search_code_dup;
		CREATE TEMPORARY TABLE tmp_search_code_dup (
			Code  varchar(50),
			RowCode  varchar(50)
			
		);



		


		


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
			TrunkID int,
			CountryID int,
			OriginationRateID int,
			RateID int,
			Preference int,
			INDEX IX_Code (Code),
			INDEX tmp_VendorCurrentRates_VendorConnectionID (`VendorConnectionID`,`TimezonesID`,`RateId`,`EffectiveDate`)
		)
		;

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

		SELECT CurrencyId INTO @v_CompanyCurrencyID_ FROM  tblCompany WHERE CompanyID = @p_companyid;


		 

		insert into tmp_search_code_ ( RowCode, Code )
			SELECT  DISTINCT rsc.RowCode, rsc.Code 
				FROM tblRateSearchCode rsc
				INNER JOIN tblRate r on r.Code = rsc.RowCode AND r.CodeDeckID = rsc.CodeDeckID AND r.CompanyID = rsc.CompanyID
				WHERE r.CompanyID = @p_companyid  AND r.CodeDeckId = @p_codedeckID    
					AND
					(
						(
							( CHAR_LENGTH(RTRIM(@p_code)) = 0 OR @p_code = '*'  OR r.Code LIKE REPLACE(@p_code,'*', '%') )
							AND ( @p_Description = ''  OR @p_Description = '*' OR  r.Description LIKE REPLACE(@p_Description,'*', '%') )
						)
						
					);
		
		

		insert into tmp_search_code_dup select * from tmp_search_code_;

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
						DATE_FORMAT(tblRateTableRate.EffectiveDate,"%Y-%m-%d") AS EffectiveDate, 
                        vt.TrunkID, 
                        tblRate.CountryID,
						r2.RateID as OriginationRateID,
						tblRate.RateID,
                        IFNULL(Preference, 5) AS Preference
					FROM
						tblRateTableRate
                    INNER JOIN tblRateTable ON tblRateTable.RateTableID = tblRateTableRate.RateTableID AND  tblRateTable.CompanyID = @p_companyid AND tblRateTable.Type = @v_RateTypeID AND tblRateTable.AppliedTo = @v_AppliedToVendor
					INNER JOIN tblVendorConnection vt ON vt.CompanyID = @p_companyid and vt.RateTableID = tblRateTableRate.RateTableID  and vt.RateTypeID = 1   and vt.Active = 1 and vt.TrunkID = @p_trunkID
					INNER JOIN tblAccount ON tblAccount.AccountID = vt.AccountId AND  tblAccount.CompanyID = @p_companyid AND vt.AccountId = tblAccount.AccountID
					INNER JOIN tblRate ON tblRate.CompanyID = @p_companyid AND tblRateTableRate.RateId = tblRate.RateID 
					INNER JOIN ( select distinct Code from tmp_search_code_ ) SplitCode ON tblRate.Code = SplitCode.Code
					
					LEFT JOIN tblRate r2 ON r2.CompanyID = @p_companyid AND tblRateTableRate.OriginationRateID = r2.RateID

					WHERE
						
						( EffectiveDate <= DATE(@p_SelectedEffectiveDate) )

						AND ( fn_IsEmpty(@p_Originationcode)  OR r2.Code LIKE REPLACE(@p_Originationcode,"*", "%") )
						AND ( fn_IsEmpty(@p_OriginationDescription)  OR r2.Description LIKE REPLACE(@p_OriginationDescription,"*", "%") )


						AND ( fn_IsEmpty(@p_Originationcode)  OR  ( r2.RateID IS NOT NULL  ) )
						AND ( fn_IsEmpty(@p_OriginationDescription)  OR  ( r2.RateID IS NOT NULL  ) )


						AND ( tblRateTableRate.EndDate IS NULL OR  tblRateTableRate.EndDate > Now() )   
						AND (fn_IsEmpty(@p_AccountIds) OR FIND_IN_SET(tblAccount.AccountID,@p_AccountIds) != 0 )
						AND tblAccount.IsVendor = 1
						AND tblAccount.Status = 1
						 
                        AND
						(
							( @p_vendor_block = 1 )
							OR
							( @p_vendor_block = 0 AND tblRateTableRate.Blocked = 0	)
						);
		

			INSERT INTO tmp_VendorCurrentRates_
			Select RateTableRateID,VendorConnectionID,TimezonesID,Blocked,VendorConnectionName,OriginationCode,Code,OriginationDescription,Description, Rate,ConnectionFee,EffectiveDate,TrunkID,CountryID,RateID,Preference
				FROM (
						SELECT * ,
							@row_num := IF(@prev_RateTableRateID = RateTableRateID AND @prev_VendorConnectionID = VendorConnectionID AND  @prev_TimezonesID = TimezonesID AND @prev_TrunkID = TrunkID AND @prev_OriginationRateID = OriginationRateID AND  @prev_RateId = RateID AND @prev_EffectiveDate >= EffectiveDate, @row_num + 1, 1) AS RowID,
							@prev_RateTableRateID := RateTableRateID,
							@prev_VendorConnectionID := VendorConnectionID,
							@prev_TimezonesID := TimezonesID,
							@prev_TrunkID := TrunkID,
							@prev_OriginationRateID := OriginationRateID,
							@prev_RateId := RateID,
							@prev_EffectiveDate := EffectiveDate
						FROM tmp_VendorCurrentRates1_
							,(SELECT @row_num := 1, @prev_RateTableRateID := '',  @prev_VendorConnectionID := '', @prev_TimezonesID := '', @prev_TrunkID := '', @prev_OriginationRateID := '', @prev_RateId := '', @prev_EffectiveDate := '') x
						ORDER BY VendorConnectionID,TimezonesID,TrunkID, OriginationRateID,RateId, EffectiveDate , RateTableRateID DESC
				) tbl
				WHERE RowID = 1;
  



		
			
 

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
				IFNULL(v.OriginationCode,''),
				v.Code,
				v.Rate,
				v.ConnectionFee,
				v.EffectiveDate,
				IFNULL(tr1.Description,'') as OriginationDescription,
				tr.Description,
				v.Preference

			FROM tmp_VendorCurrentRates_ v

			INNER join  tmp_search_code_ 		SplitCode   on v.Code = SplitCode.Code
			INNER join tblRate tr on tr.CodeDeckId = @p_codedeckID and SplitCode.Code = tr.Code
			
			left join tblRate tr1 on tr1.CodeDeckId = @p_codedeckID and v.OriginationCode != '' AND v.OriginationCode = tr1.Code;
			
			

 
		
		update tmp_VendorRate_stage_1 v 
		INNER JOIN tblTimezones t on v.TimezonesID = t.TimezonesID
		SET  v.VendorConnectionName = concat(v.VendorConnectionName ,' - ' , t.Title  );

 
		
		SET @v_rowCount_ = ( SELECT COUNT(TimezonesID) FROM ( SELECT DISTINCT TimezonesID FROM tmp_VendorRate_stage_1 WHERE TimezonesID != @v_default_TimezonesID group by TimezonesID ) tmp );
		SET @v_pointer_ = 1;
		
		IF @v_rowCount_ > 0 THEN 
				
				INSERT INTO tmp_VendorRate_stage_1_DEFAULT
				SELECT * FROM tmp_VendorRate_stage_1 WHERE TimezonesID = @v_default_TimezonesID;

				DELETE  FROM tmp_VendorRate_stage_1 WHERE TimezonesID = @v_default_TimezonesID;

				INSERT INTO tmp_VendorRate_stage_1_dup SELECT * FROM tmp_VendorRate_stage_1;

				
				select GROUP_CONCAT(TimezonesID)  INTO @v_rest_TimezonesIDs from tblTimezones WHERE TimezonesID != @v_default_TimezonesID;


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
														v.TimezonesID,
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
												v.VendorConnectionID != vd.VendorConnectionID AND
												FIND_IN_SET(v.TimezonesID, @v_rest_TimezonesIDs) != 0 AND
												vd.OriginationCode = v.OriginationCode AND
												vd.RowCode = v.RowCode;

				
		END IF;

		

		
		insert ignore into tmp_VendorRate_stage_
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
				@prev_TimezonesID := v.TimezonesID,
				@prev_OriginationCode := v.OriginationCode,
				@prev_RowCode := RowCode	 ,
				@prev_VendorConnectionID := v.VendorConnectionID

			FROM tmp_VendorRate_stage_1 v
			inner join tblRate tr on tr.CompanyID = @p_companyid AND tr.CodeDeckId = @p_codedeckID and tr.Code = v.RowCode		
				, (SELECT  @prev_OriginationCode := NUll , @prev_RowCode := '',  @rank := 0 , @prev_Code := '' , @prev_TimezonesID := '' , @prev_VendorConnectionID := Null) f
			order by  RowCode,TimezonesID,VendorConnectionID,OriginationCode,Code desc;

		 
			insert ignore into tmp_VendorRate_
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
			where MaxMatchRank = 1;


		IF( @p_Preference = 0 )
		THEN

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
							order by OriginationCode,RowCode,TimezonesID,Rate,VendorConnectionID ASC
							

						) tbl1
					where
						(@p_isExport = 1  OR @p_isExport = 2) OR (@p_isExport = 0 AND FinalRankNumber <= @p_Position);

 
		ELSE

			 

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
								order by OriginationCode,RowCode,TimezonesID asc ,Preference desc ,VendorConnectionID ASC
							

						) tbl1
					where
						(@p_isExport = 1  OR @p_isExport = 2 ) OR (@p_isExport = 0 AND FinalRankNumber <= @p_Position);
 
		END IF;


		SET @stm_columns = "";


		IF @p_isExport = 0 AND @p_Position > 10 THEN
			SET @p_Position = 10;
		END IF;

		
		update tmp_final_VendorRate_
			SET
			 OriginationDescription = ifnull(REPLACE(OriginationDescription,",","-"),''),
			 Description = ifnull(REPLACE(Description,",","-"),'');

				
		update tmp_final_VendorRate_ v 
		INNER JOIN tblTimezones t on v.TimezonesID = t.TimezonesID
		SET  v.TimezoneName = t.Title;


		delete from tmp_final_VendorRate_ where Rate is null;


		IF @p_isExport = 2
		THEN
 
				SELECT
					distinct
					MIN(RateTableRateID) as RateTableRateID,
					MIN(VendorConnectionID) as VendorConnectionID,
					TimezoneName as TimezoneName,
					MIN(Blocked) as Blocked,
					MIN(VendorConnectionName) as VendorConnectionName,
					OriginationCode as OriginationCode,
					MIN(Code) as Code,
					MIN(Rate) as Rate,
					MIN(ConnectionFee) as ConnectionFee,
					MIN(EffectiveDate ) as EffectiveDate,
					MIN(OriginationDescription) as OriginationDescription,
					MIN(Description) as Description,
					MIN(Preference) as Preference,
					RowCode as RowCode,
					MIN(FinalRankNumber) as FinalRankNumber
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
					SET @stm_columns = CONCAT(@stm_columns, "CONCAT(if(MIN(FinalRankNumber) = ",@v_pointer_,", CONCAT(MIN(OriginationCode), '<br>', MIN(OriginationDescription), '<br>',MIN(Code), '<br>', MIN(Description), '<br>', MIN(Rate), '<br>', MIN(VendorConnectionName), '<br>', DATE_FORMAT(MIN(EffectiveDate), '%d/%m/%Y'),'', '=', MIN(RateTableRateID), '-', MIN(VendorConnectionID), '-', MIN(Code), '-', MIN(Blocked) , '-', MIN(Preference), '-', MIN(TimezonesID)  ), NULL) , '<BR>') AS `POSITION ",@v_pointer_,"`,");
				ELSE
					SET @stm_columns = CONCAT(@stm_columns, "CONCAT(if(MIN(FinalRankNumber) = ",@v_pointer_,", CONCAT(MIN(Code), '<br>', MIN(Description), '<br>', MIN(Rate), '<br>', MIN(VendorConnectionName), '<br>', DATE_FORMAT(MIN(EffectiveDate), '%d/%m/%Y')), NULL) SEPARATOR '<br>' )  AS `POSITION ",@v_pointer_,"`,");
				END IF;

				SET @v_pointer_ = @v_pointer_ + 1;

			END WHILE;

			SET @stm_columns = TRIM(TRAILING ',' FROM @stm_columns);



			IF ( @p_isExport = 0 )
			THEN

 
					SET @stm_query = CONCAT("SELECT CONCAT(OriginationCode , ' : ' , MIN(OriginationDescription), ' <br> => '  , RowCode , ' : ' , MIN(Description)) as Destination, TimezoneName as Timezone, ", @stm_columns," FROM tmp_final_VendorRate_  GROUP BY  OriginationCode,RowCode,TimezoneName ORDER BY OriginationCode,RowCode,TimezoneName ASC LIMIT ",@p_RowspPage," OFFSET ",@v_OffSet_," ;");

					select count(RowCode) as totalcount  from ( SELECT RowCode  from tmp_final_VendorRate_ GROUP BY OriginationCode, RowCode,TimezoneName ) tmp;

 

			END IF;

			IF @p_isExport = 1
			THEN

 
					SET @stm_query = CONCAT("SELECT CONCAT(OriginationCode , ' : ' , MIN(OriginationDescription), '  => '  , RowCode , ' : ' , MIN(Description)) as Destination, TimezoneName as Timezone ", @stm_columns," FROM tmp_final_VendorRate_   GROUP BY  OriginationCode,RowCode ORDER BY RowCode ASC;");


 

			END IF;




			PREPARE stm_query FROM @stm_query;
			EXECUTE stm_query;
			DEALLOCATE PREPARE stm_query;

		END IF;


		SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

	END//
DELIMITER ;

-- Dumping structure for procedure speakintelligentRM.prc_GetPackageLCR
DROP PROCEDURE IF EXISTS `prc_GetPackageLCR`;
DELIMITER //
CREATE  PROCEDURE `prc_GetPackageLCR`(
	IN `p_companyid` INT,
	IN `p_PackageId` INT,
	IN `p_CurrencyID` INT,
	IN `p_Position` INT,
	IN `p_SelectedEffectiveDate` DATE,
	IN `p_Calls` INT,
	IN `p_Minutes` INT,
	IN `p_Timezone` INT,
	IN `p_TimezonePercentage` INT,
	IN `p_StartDate` DATETIME,
	IN `p_EndDate` DATETIME,
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_SortOrder` VARCHAR(50),
	IN `p_isExport` INT

)
ThisSP:BEGIN



		SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;


        SET @p_companyid            =   p_companyid;
        SET @p_PackageId            =   p_PackageId;
        SET @p_CurrencyID            =   p_CurrencyID;
        SET @p_Position            =   p_Position;
        SET @p_SelectedEffectiveDate            =   p_SelectedEffectiveDate;
        SET @p_Calls            =   p_Calls;
        SET @p_Minutes            =   p_Minutes;
        SET @p_Timezone            =   p_Timezone;
        SET @p_TimezonePercentage            =   p_TimezonePercentage;
        SET @p_StartDate            =   p_StartDate;
        SET @p_EndDate            =   p_EndDate;
        SET @p_PageNumber            =   p_PageNumber;
        SET @p_RowspPage            =   p_RowspPage;
        SET @p_SortOrder            =   p_SortOrder;
        SET @p_isExport            =   p_isExport;


        SET	@v_RateTypeID = 3;	

        set @v_ApprovedStatus = 1;

        set @v_AppliedToCustomer = 1; 
        set @v_AppliedToVendor = 2; 
        set @v_AppliedToReseller = 3; 


		SET @v_OffSet_ = (@p_PageNumber * @p_RowspPage) - @p_RowspPage;

		SELECT CurrencyId INTO @v_CompanyCurrencyID_ FROM  tblCompany WHERE CompanyID = @p_companyid;

        Select Value INTO @v_DestinationCurrencyConversionRate from tblCurrencyConversion where tblCurrencyConversion.CurrencyId =  @p_CurrencyID  and  CompanyID = @p_companyid;
        Select Value INTO @v_CompanyCurrencyConversionRate from tblCurrencyConversion where tblCurrencyConversion.CurrencyId =  @v_CompanyCurrencyID_  and  CompanyID = @p_companyid;

		set @p_CurrencySymbol = (SELECT Symbol from tblCurrency where CurrencyID = @p_CurrencyID);


			DROP TEMPORARY TABLE IF EXISTS tmp_all_components;
				CREATE TEMPORARY TABLE tmp_all_components(
					ID int,
					component VARCHAR(200),
					component_title VARCHAR(200)
			);

			DROP TEMPORARY TABLE IF EXISTS tmp_Timezones;
				CREATE TEMPORARY TABLE tmp_Timezones(
					ID int AUTO_INCREMENT,
					TimezonesID int,
					Title varchar(200),
					Primary Key (ID )

			);


			DROP TEMPORARY TABLE IF EXISTS tmp_table1_;
			CREATE TEMPORARY TABLE tmp_table1_ (
				TimezonesID  int,
				TimezoneTitle  varchar(100),
				EffectiveDate DATE,
				PackageName varchar(100),
				VendorConnectionID int,
				VendorConnectionName varchar(200),
				MonthlyCost DECIMAL(18,8),
				PackageCostPerMinute DECIMAL(18,8),
				RecordingCostPerMinute DECIMAL(18,8),
				Total DECIMAL(18,8)
			);


			DROP TEMPORARY TABLE IF EXISTS tblRateTablePKGRate_step1;
			CREATE TEMPORARY TABLE tblRateTablePKGRate_step1 (
				TimezonesID  int,
				TimezoneTitle  varchar(100),
				EffectiveDate DATE,
				PackageID int,
				PackageName varchar(100),
				VendorConnectionID int,
				VendorConnectionName varchar(200),
				MonthlyCost DECIMAL(18,8),
				PackageCostPerMinute DECIMAL(18,8),
				RecordingCostPerMinute DECIMAL(18,8)
			);

			DROP TEMPORARY TABLE IF EXISTS tblRateTablePKGRate_step1_dup;
			CREATE TEMPORARY TABLE tblRateTablePKGRate_step1_dup (
				TimezonesID  int,
				TimezoneTitle  varchar(100),
				EffectiveDate DATE,
				PackageID int,
				PackageName varchar(100),
				VendorConnectionID int,
				VendorConnectionName varchar(200),
				MonthlyCost DECIMAL(18,8),
				PackageCostPerMinute DECIMAL(18,8),
				RecordingCostPerMinute DECIMAL(18,8)
			);

			DROP TEMPORARY TABLE IF EXISTS tmp_table_pkg;
			CREATE TEMPORARY TABLE tmp_table_pkg (
				TimezonesID  int,
				TimezoneTitle  varchar(100),
				EffectiveDate DATE,
				PackageName varchar(100),
				VendorConnectionID int,
				VendorConnectionName varchar(200),
				MonthlyCost DECIMAL(18,8),
				PackageCostPerMinute DECIMAL(18,8),
				RecordingCostPerMinute DECIMAL(18,8),
				Total DECIMAL(18,8)
			);

            DROP TEMPORARY TABLE IF EXISTS tmp_vendors;
            CREATE TEMPORARY TABLE tmp_vendors (
                ID  int AUTO_INCREMENT,
                VendorConnectionName varchar(100),
                vPosition int,
                PRIMARY KEY (ID)
            );


			INSERT INTO tmp_all_components (ID, component , component_title )
				VALUES
				(1, 'MonthlyCost', 			'Monthly cost'),
				(2, 'PackageCostPerMinute',			'Package Cost Per Minute'),
				(3, 'RecordingCostPerMinute', 'Recording Cost Per Minute');

			DROP TEMPORARY TABLE IF EXISTS tmp_table_output_1;
			CREATE TEMPORARY TABLE tmp_table_output_1 (

                PackageName varchar(100),
                VendorConnectionID int,
                VendorConnectionName varchar(200),
                EffectiveDate DATE,
                Total DECIMAL(18,8)

			);


			DROP TEMPORARY TABLE IF EXISTS tmp_table_output_2;
			CREATE TEMPORARY TABLE tmp_table_output_2 (

                PackageName varchar(100),
                VendorConnectionID int,
                VendorConnectionName varchar(200),
                EffectiveDate DATE,
                Total DECIMAL(18,8),
                vPosition int

			);


			DROP TEMPORARY TABLE IF EXISTS tmp_final_table_output;
			CREATE TEMPORARY TABLE tmp_final_table_output (

                PackageName varchar(100),
                VendorConnectionID int,
                VendorConnectionName varchar(200),
                EffectiveDate DATE,
                Total varchar(200),
                vPosition int

			);


			DROP TEMPORARY TABLE IF EXISTS tmp_final_result;
			CREATE TEMPORARY TABLE tmp_final_result (
				Component  varchar(100)
			);


			DROP TEMPORARY TABLE IF EXISTS tmp_vendor_position;
			CREATE TEMPORARY TABLE tmp_vendor_position (
				VendorConnectionID int,
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
				PackageID int,
				PackageCostPerMinute DECIMAL(18,8), 
				RecordingCostPerMinute DECIMAL(18,8),
				minute_PackageCostPerMinute DECIMAL(18,2), 
				minute_RecordingCostPerMinute DECIMAL(18,2)
			);

			DROP TEMPORARY TABLE IF EXISTS tmp_timezone_minutes_2;
			CREATE TEMPORARY TABLE tmp_timezone_minutes_2 (
				TimezonesID int,
				VendorConnectionID int,
				PackageID int,
				PackageCostPerMinute DECIMAL(18,8), 
				RecordingCostPerMinute DECIMAL(18,8),
				minute_PackageCostPerMinute DECIMAL(18,2), 
				minute_RecordingCostPerMinute DECIMAL(18,2)
			);

			DROP TEMPORARY TABLE IF EXISTS tmp_timezone_minutes_3;
			CREATE TEMPORARY TABLE tmp_timezone_minutes_3 (
				TimezonesID int,
				VendorConnectionID int,
				PackageID int,
				PackageCostPerMinute DECIMAL(18,8), 
				RecordingCostPerMinute DECIMAL(18,8),
				minute_PackageCostPerMinute DECIMAL(18,2), 
				minute_RecordingCostPerMinute DECIMAL(18,2)
			);

			DROP TEMPORARY TABLE IF EXISTS tmp_accounts;
			CREATE TEMPORARY TABLE tmp_accounts (
				ID int auto_increment,
				VendorConnectionID int,
				PackageID int,
				Primary Key (ID )

			);

 
            
			IF  @p_Minutes = 0 THEN

				

				insert into tmp_timezone_minutes (TimezonesID,PackageID, PackageCostPerMinute,RecordingCostPerMinute)

				select PackageTimezonesID  , AccountServicePackageID, sum(PackageCostPerMinute)  ,sum(RecordingCostPerMinute)  

				from speakintelligentCDR.tblUsageDetails  d

				inner join speakintelligentCDR.tblUsageHeader h on d.UsageHeaderID = h.UsageHeaderID

				where StartDate >= @p_StartDate AND StartDate <= @p_EndDate 

                AND d.is_inbound = 1 

				AND ( @p_PackageId = 0 OR d.AccountServicePackageID = @p_PackageId  )

				group by PackageTimezonesID  , AccountServicePackageID;


			ELSE

					

					insert into tmp_timezone_minutes (VendorConnectionID, TimezonesID, PackageID, PackageCostPerMinute , RecordingCostPerMinute )
		
					select VendorConnectionID, TimezonesID, PackageID, PackageCostPerMinute , RecordingCostPerMinute 
					from
					(
						Select distinct vc.VendorConnectionID,drtr.TimezonesID,pk.PackageID, sum(drtr.PackageCostPerMinute) as PackageCostPerMinute ,sum(drtr.RecordingCostPerMinute) as RecordingCostPerMinute
						FROM tblRateTablePKGRate  drtr
						INNER JOIN tblRateTable  rt ON rt.RateTableId = drtr.RateTableId 
						INNER JOIN tblVendorConnection vc ON vc.RateTableID = rt.RateTableId  AND vc.CompanyID = rt.CompanyId  AND vc.Active=1 AND vc.RateTypeID = @v_RateTypeID
						INNER JOIN tblAccount a ON vc.AccountId = a.AccountID AND rt.CompanyId = a.CompanyId and a.IsVendor = 1 and a.Status = 1
						INNER JOIN tblRate r ON drtr.RateID = r.RateID AND r.CompanyID = vc.CompanyID	
						INNER JOIN tblPackage pk ON pk.CompanyID = r.CompanyID AND pk.Name = r.Code 
						INNER JOIN tblTimezones t ON t.TimezonesID =  drtr.TimezonesID
						
						WHERE
						
						rt.CompanyId =  @p_companyid				

						AND vc.AccountId > 0

						AND ( @p_PackageId = 0 OR pk.PackageId = @p_PackageId )

						AND rt.Type = @v_RateTypeID 
						
						AND rt.AppliedTo = @v_AppliedToVendor 
									
						AND EffectiveDate <= DATE(@p_SelectedEffectiveDate)
						
						AND (EndDate IS NULL OR EndDate > NOW() )    

						group by VendorConnectionID, TimezonesID, PackageID

					) tmp ;	


					INSERT INTO tmp_timezone_minutes_2 SELECT * FROM tmp_timezone_minutes;
					INSERT INTO tmp_timezone_minutes_3 SELECT * FROM tmp_timezone_minutes;

					insert into tmp_timezones (TimezonesID) select TimezonesID from tblTimezones;

					SET @v_rowCount_ = ( SELECT COUNT(*) FROM tmp_timezones );

					SET @p_PeakTimeZonePercentage	 		 = @p_TimezonePercentage;
				


					

					INSERT INTO tmp_accounts ( VendorConnectionID , PackageID )  SELECT DISTINCT VendorConnectionID , PackageID FROM tmp_timezone_minutes order by VendorConnectionID , PackageID;

					IF @p_PeakTimeZonePercentage > 0 THEN

						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET minute_PackageCostPerMinute = ( (@p_Minutes/ 100) * @p_PeakTimeZonePercentage )
												
						WHERE  tzm.TimezonesID = @p_Timezone AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.PackageID = a.PackageID AND tzm.PackageCostPerMinute IS NOT NULL;

						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET minute_RecordingCostPerMinute =  ( (@p_Minutes/ 100) * @p_PeakTimeZonePercentage )
												
						WHERE  tzm.TimezonesID = @p_Timezone AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.PackageID = a.PackageID AND tzm.RecordingCostPerMinute IS NOT NULL;

					

						
						truncate table tmp_timezone_minutes_2;
						truncate table tmp_timezone_minutes_3;

						INSERT INTO tmp_timezone_minutes_2 SELECT * FROM tmp_timezone_minutes;
						INSERT INTO tmp_timezone_minutes_3 SELECT * FROM tmp_timezone_minutes;


						
													

						
						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET minute_PackageCostPerMinute = ( @p_Minutes - IFNULL((select tzmd2.minute_PackageCostPerMinute from tmp_timezone_minutes_3 tzmd2 WHERE tzmd2.TimezonesID = @p_Timezone AND tzmd2.VendorConnectionID = a.VendorConnectionID AND tzmd2.PackageID = a.PackageID AND  tzmd2.PackageCostPerMinute IS NOT NULL),0) )   
														/ (  select IF(count(*) = 0 , 1,count(*) )  from tmp_timezone_minutes_2 tzmd WHERE tzmd.TimezonesID != @p_Timezone AND tzmd.VendorConnectionID = a.VendorConnectionID AND tzmd.PackageID = a.PackageID  AND tzmd.PackageCostPerMinute IS NOT NULL) 
						WHERE  (tzm.TimezonesID != @p_Timezone) AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.PackageID = a.PackageID   AND tzm.PackageCostPerMinute IS NOT NULL;

						
						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET minute_RecordingCostPerMinute = ( @p_Minutes - IFNULL((select tzmd2.minute_RecordingCostPerMinute from tmp_timezone_minutes_3 tzmd2 WHERE tzmd2.TimezonesID = @p_Timezone AND tzmd2.VendorConnectionID = a.VendorConnectionID AND tzmd2.PackageID = a.PackageID AND  tzmd2.RecordingCostPerMinute IS NOT NULL),0) )   
														/ (  select IF(count(*) = 0 , 1,count(*) )  from tmp_timezone_minutes_2 tzmd WHERE tzmd.TimezonesID != @p_Timezone AND tzmd.VendorConnectionID = a.VendorConnectionID AND tzmd.PackageID = a.PackageID AND tzmd.RecordingCostPerMinute IS NOT NULL ) 
						WHERE  (tzm.TimezonesID != @p_Timezone) AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.PackageID = a.PackageID  AND tzm.RecordingCostPerMinute IS NOT NULL;
						

						
							
						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET minute_PackageCostPerMinute =  @p_Minutes 
						WHERE  (tzm.TimezonesID = @p_Timezone ) AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.PackageID = a.PackageID   AND tzm.PackageCostPerMinute IS NOT NULL
								AND (  select count(*) from tmp_timezone_minutes_2 tzmd 
								WHERE tzmd.TimezonesID != @p_Timezone AND tzmd.VendorConnectionID = a.VendorConnectionID AND tzmd.PackageID = a.PackageID  AND tzmd.PackageCostPerMinute IS NOT NULL) = 0;

						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET minute_RecordingCostPerMinute =  @p_Minutes 
						WHERE  (tzm.TimezonesID = @p_Timezone ) AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.PackageID = a.PackageID   AND tzm.RecordingCostPerMinute IS NOT NULL
								AND (  select count(*) from tmp_timezone_minutes_2 tzmd 
								WHERE tzmd.TimezonesID != @p_Timezone AND tzmd.VendorConnectionID = a.VendorConnectionID AND tzmd.PackageID = a.PackageID  AND tzmd.RecordingCostPerMinute IS NOT NULL) = 0;

							

						
					ELSE 

						
						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET minute_PackageCostPerMinute =  @p_Minutes /  (select IF(count(DISTINCT tzmd.TimezonesID) = 0 , 1,count(DISTINCT tzmd.TimezonesID) ) from tmp_timezone_minutes_2 tzmd WHERE tzmd.VendorConnectionID = tzm.VendorConnectionID AND tzmd.PackageID = tzm.PackageID AND tzmd.PackageCostPerMinute IS NOT NULL )
													
						WHERE   tzm.VendorConnectionID = a.VendorConnectionID AND tzm.PackageID = a.PackageID AND tzm.PackageCostPerMinute IS NOT NULL;

						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET minute_RecordingCostPerMinute = @p_Minutes /  (select IF(count(DISTINCT tzmd.TimezonesID) = 0 , 1,count(DISTINCT tzmd.TimezonesID) ) from tmp_timezone_minutes_2 tzmd WHERE tzmd.VendorConnectionID = tzm.VendorConnectionID AND tzmd.PackageID = tzm.PackageID AND tzmd.RecordingCostPerMinute IS NOT NULL)
												
						WHERE   tzm.VendorConnectionID = a.VendorConnectionID AND tzm.PackageID = a.PackageID AND tzm.RecordingCostPerMinute IS NOT NULL;



					END IF;





					

			END IF;


		SET @v_days =    TIMESTAMPDIFF(DAY, (SELECT @p_StartDate), (SELECT @p_EndDate)) + 1 ;
		SET @v_period1 =      IF(MONTH((SELECT @p_StartDate)) = MONTH((SELECT @p_EndDate)), 0, (TIMESTAMPDIFF(DAY, (SELECT @p_StartDate), LAST_DAY((SELECT @p_StartDate)) + INTERVAL 0 DAY)) / DAY(LAST_DAY((SELECT @p_StartDate))));
		SET @v_period2 =      TIMESTAMPDIFF(MONTH, LAST_DAY((SELECT @p_StartDate)) + INTERVAL 1 DAY, LAST_DAY((SELECT @p_EndDate))) ;
		SET @v_period3 =      IF(MONTH((SELECT @p_StartDate)) = MONTH((SELECT @p_EndDate)), (SELECT @v_days), DAY((SELECT @p_EndDate))) / DAY(LAST_DAY((SELECT @p_EndDate)));
		SET @p_months =     (SELECT @v_period1) + (SELECT @v_period2) + (SELECT @v_period3);

		SET @p_months = fn_Round(@p_months,1);
		
        INSERT INTO tblRateTablePKGRate_step1 
							(
									TimezonesID,
									TimezoneTitle,
									EffectiveDate,
									PackageID,
                                    PackageName,
									VendorConnectionID,
									VendorConnectionName,
									MonthlyCost,
									PackageCostPerMinute,
									RecordingCostPerMinute
								)
		SELECT
			drtr.TimezonesID,
			t.Title AS TimezoneTitle,
			drtr.EffectiveDate,
			pk.PackageID,
			pk.Name,
			vc.VendorConnectionID,
			vc.Name as VendorConnectionName, 

			@MonthlyCost := CASE WHEN ( MonthlyCostCurrency IS NOT NULL)
			THEN
				CASE WHEN  @p_CurrencyID = MonthlyCostCurrency THEN
					drtr.MonthlyCost
				ELSE
				(
					
					(@v_DestinationCurrencyConversionRate  )
					* (drtr.MonthlyCost  / (SELECT VALUE FROM tblCurrencyConversion WHERE tblCurrencyConversion.CurrencyId = MonthlyCostCurrency AND  CompanyID = @p_companyid ))
				)
				END
			ELSE
				(
					
					(@v_DestinationCurrencyConversionRate )
					* (drtr.MonthlyCost  / (@v_CompanyCurrencyConversionRate ))
				)
			END AS MonthlyCost,

			@PackageCostPerMinute := CASE WHEN ( PackageCostPerMinuteCurrency IS NOT NULL)
			THEN
					CASE WHEN  @p_CurrencyID = PackageCostPerMinuteCurrency THEN
						drtr.PackageCostPerMinute
					ELSE
					(
						
						(@v_DestinationCurrencyConversionRate )
						* (drtr.PackageCostPerMinute  / (SELECT VALUE FROM tblCurrencyConversion WHERE tblCurrencyConversion.CurrencyId = PackageCostPerMinuteCurrency AND  CompanyID = @p_companyid ))
					)
					END
				
			ELSE
				(
					
					(@v_DestinationCurrencyConversionRate )
					* (drtr.PackageCostPerMinute  / (@v_CompanyCurrencyConversionRate ))
				)
			END  AS PackageCostPerMinute,

			@RecordingCostPerMinute := CASE WHEN ( RecordingCostPerMinuteCurrency IS NOT NULL)
			THEN
					CASE WHEN  @p_CurrencyID = RecordingCostPerMinuteCurrency THEN
						drtr.RecordingCostPerMinute
					ELSE
					(
						
						(@v_DestinationCurrencyConversionRate )
						* (drtr.RecordingCostPerMinute  / (SELECT VALUE FROM tblCurrencyConversion WHERE tblCurrencyConversion.CurrencyId = RecordingCostPerMinuteCurrency AND  CompanyID = @p_companyid ))
					)
					END
				
			ELSE
				(
					
					(@v_DestinationCurrencyConversionRate )
					* (drtr.RecordingCostPerMinute  / (@v_CompanyCurrencyConversionRate ))
				)
			END  AS RecordingCostPerMinute
												
        FROM tblRateTablePKGRate  drtr
        INNER JOIN tblRateTable  rt ON rt.RateTableId = drtr.RateTableId 
        INNER JOIN tblVendorConnection vc ON vc.RateTableID = rt.RateTableId  AND vc.CompanyID = rt.CompanyId  AND vc.Active=1 AND vc.RateTypeID = @v_RateTypeID
        INNER JOIN tblAccount a ON vc.AccountId = a.AccountID AND rt.CompanyId = a.CompanyId and a.IsVendor = 1 and a.Status = 1
        INNER JOIN tblRate r ON drtr.RateID = r.RateID AND r.CompanyID = vc.CompanyID	
        INNER JOIN tblPackage pk ON pk.CompanyID = r.CompanyID AND pk.Name = r.Code 
        INNER JOIN tblTimezones t ON t.TimezonesID =  drtr.TimezonesID
         
        WHERE
        
        rt.CompanyId =  @p_companyid				

        AND ( @p_PackageId = 0 OR pk.PackageId = @p_PackageId )

        AND rt.Type = @v_RateTypeID 
        
        AND rt.AppliedTo = @v_AppliedToVendor 
                    
        AND EffectiveDate <= DATE(@p_SelectedEffectiveDate)
        
        AND (EndDate IS NULL OR EndDate > NOW() ) ;   		



		
			
			 
		insert into tblRateTablePKGRate_step1_dup (VendorConnectionID,TimezonesID, PackageID) 
		select VendorConnectionID, max(TimezonesID) as TimezonesID, PackageID 
		from tblRateTablePKGRate_step1
		WHERE MonthlyCost > 0
		GROUP BY VendorConnectionID, PackageID;

		update tblRateTablePKGRate_step1 svr
		INNER JOIN tblRateTablePKGRate_step1_dup svr2 on 
					svr.VendorConnectionID = svr2.VendorConnectionID AND 
					svr.TimezonesID != svr2.TimezonesID AND 
					svr.PackageID = svr2.PackageID 
		SET svr.MonthlyCost = 0
		where svr.MonthlyCost > 0 and svr2.TimezonesID is not null and svr.TimezonesID is not null;



        INSERT INTO tmp_table_pkg 
								(
									TimezonesID,
									TimezoneTitle,
									EffectiveDate,
                                    PackageName,
									VendorConnectionID,
									VendorConnectionName,
									MonthlyCost,
									PackageCostPerMinute,
									RecordingCostPerMinute,
									Total
								)
								SELECT
									drtr.TimezonesID,
									drtr.TimezoneTitle,
									drtr.EffectiveDate,
                                    drtr.PackageName,
									drtr.VendorConnectionID,
									drtr.VendorConnectionName,
									drtr.MonthlyCost,
									drtr.PackageCostPerMinute,
									drtr.RecordingCostPerMinute,
									
								@Total := (
									(	IFNULL(drtr.MonthlyCost,0) 	* @p_months			)				+
									(IFNULL(drtr.PackageCostPerMinute,0) * IFNULL(tm.minute_PackageCostPerMinute,0)	)+
									(IFNULL(drtr.RecordingCostPerMinute,0) * IFNULL(tm.minute_RecordingCostPerMinute,0) )
								)   
								 AS Total
												
        FROM tblRateTablePKGRate_step1  drtr
        left join tmp_timezone_minutes tm on tm.TimezonesID = drtr.TimezonesID AND tm.PackageID = drtr.PackageID AND ( tm.VendorConnectionID IS NULL OR drtr.VendorConnectionID = tm.VendorConnectionID ); 

					 
        INSERT INTO tmp_table1_ 
        (
            TimezonesID,
            TimezoneTitle,
            EffectiveDate,
            PackageName,
            VendorConnectionID,
            VendorConnectionName,
            MonthlyCost,
            PackageCostPerMinute,
            RecordingCostPerMinute,
            Total
        )
        
        SELECT 
            TimezonesID,
            TimezoneTitle,
            EffectiveDate,
            PackageName,
            VendorConnectionID,
            VendorConnectionName,
            MonthlyCost,
            PackageCostPerMinute,
            RecordingCostPerMinute,
            Total
        from tmp_table_pkg

        WHERE Total IS NOT NULL;
													

        insert into tmp_table_output_1 (PackageName ,VendorConnectionID ,VendorConnectionName,EffectiveDate,Total)
        select PackageName ,VendorConnectionID ,VendorConnectionName,max(EffectiveDate),sum(Total) as Total
        from tmp_table1_
        group by PackageName ,VendorConnectionID ,VendorConnectionName;


        insert into tmp_table_output_2   ( PackageName ,VendorConnectionID ,VendorConnectionName,EffectiveDate,Total,vPosition )

        SELECT PackageName, VendorConnectionID, VendorConnectionName, EffectiveDate, Total, vPosition
        FROM (
                    select PackageName ,VendorConnectionID ,VendorConnectionName,EffectiveDate,Total,
                    @vPosition := (
                    
					CASE WHEN (@prev_PackageName = PackageName  AND @prev_Total <  Total) THEN @vPosition + 1
					     WHEN (@prev_PackageName = PackageName  AND @prev_Total =  Total) THEN @vPosition 
                    ELSE
                    1
                    END) as  vPosition,
                    @prev_PackageName  := PackageName  ,
                    @prev_VendorConnectionID  := VendorConnectionID,
                    @prev_Total := Total

                    from tmp_table_output_1
                    ,(SELECT  @vPosition := 0 , @prev_PackageName  := ''  , @prev_VendorConnectionID  := '', @prev_Total := 0 ) t

                  ORDER BY PackageName,Total
        ) tmp;


        insert into tmp_final_table_output ( PackageName ,VendorConnectionID ,VendorConnectionName,EffectiveDate, Total,vPosition)
        select PackageName ,VendorConnectionID ,VendorConnectionName,EffectiveDate, concat( @p_CurrencySymbol, Total ), vPosition
        from tmp_table_output_2 
        where vPosition  < @p_Position ;


  		SET @stm_columns = "";

        IF @p_isExport = 0 AND @p_Position > 10 THEN
    
            SET @p_Position = 10;
    
        END IF;

        SET @v_pointer_ = 1;
       
        WHILE @v_pointer_ <= @p_Position
        DO

            SET @stm_columns = CONCAT(@stm_columns, "CONCAT(if(MIN(vPosition) = ",@v_pointer_,", CONCAT(MIN(Total), '<br>', MIN(VendorConnectionName), '<br>', DATE_FORMAT(MIN(EffectiveDate), '%d/%m/%Y'),'' ), NULL) SEPARATOR '<br>'  ) AS `POSITION ",@v_pointer_,"`,");

		    SET @v_pointer_ = @v_pointer_ + 1;

		END WHILE;

		SET @stm_columns = TRIM(TRAILING ',' FROM @stm_columns);

		IF (@p_isExport = 0) THEN

            SET @stm_query = CONCAT("SELECT PackageName, ", @stm_columns," FROM tmp_final_table_output GROUP BY PackageName ORDER BY PackageName LIMIT ",@p_RowspPage," OFFSET ",@v_OffSet_," ;");

  		    select count(PackageName) as totalcount from ( select PackageName from tmp_final_table_output GROUP BY PackageName ) tmp   ;


            PREPARE stm_query FROM @stm_query;
            EXECUTE stm_query;
            DEALLOCATE PREPARE stm_query;

        ELSE

             SET @stm_query = CONCAT("SELECT PackageName, ", @stm_columns," FROM tmp_final_table_output GROUP BY PackageName ORDER BY PackageName ;");


			PREPARE stm_query FROM @stm_query;
			EXECUTE stm_query;
			DEALLOCATE PREPARE stm_query;


      END IF;

    		

	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

END//
DELIMITER ;

-- Dumping structure for procedure speakintelligentRM.prc_WSGenerateRateTable
DROP PROCEDURE IF EXISTS `prc_WSGenerateRateTable`;
DELIMITER //
CREATE  PROCEDURE `prc_WSGenerateRateTable`(
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
		SET @v_default_TimezonesID = 1;


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
				IF(OriginationCountryID='',NULL,OriginationCountryID),
				IF(DestinationType='',NULL,DestinationType),
				IF(DestinationCountryID='',NULL,DestinationCountryID),
				IF(code='',NULL,code),
				
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
							 distinct
							 TimezonesID,VendorConnectionID,RowCodeID,OriginationCodeID,CodeID,AccountID,Rate,RateN,ConnectionFee,Preference,MinimumDuration,

							 @SingleRowCode := ( CASE WHEN( @prev_OriginationCodeID = OriginationCodeID  AND @prev_CodeID = CodeID  AND  @prev_TimezonesID = TimezonesID  AND @prev_VendorConnectionID = VendorConnectionID     )
								 THEN @SingleRowCode + 1
																	 ELSE 1  END ) AS SingleRowCode,
							 @prev_OriginationCodeID := OriginationCodeID	 ,
							 @prev_CodeID := CodeID	 ,
							 @prev_VendorConnectionID := VendorConnectionID ,
							 @prev_TimezonesID := TimezonesID
							FROM tmp_VendorRate_stage
							 , (SELECT   @prev_OriginationCodeID := null, @prev_CodeID := null,  @SingleRowCode := null , @prev_VendorConnectionID := null ) x
 							order by  RowCodeID desc ,TimezonesID,VendorConnectionID desc ,OriginationCodeID desc ,CodeID desc

		
					 ) tmp1 where SingleRowCode = 1;


			



		SET @v_rowCount_ = ( SELECT COUNT(TimezonesID) FROM ( SELECT DISTINCT TimezonesID FROM tmp_VendorRate_stage_1 WHERE TimezonesID != @v_default_TimezonesID group by TimezonesID ) tmp );
		SET @v_pointer_ = 1;
		
		IF @v_rowCount_ > 0 THEN 

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

    INSERT INTO tmp_Rate_final
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




    

		  


		START TRANSACTION;


		IF @p_RateTableId = -1
		THEN

			
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


		ELSE

			
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
					tmp_Rate_final tr
				SET
					PreviousRate = (SELECT rtr.Rate 
										FROM tblRateTableRateAA rtr 
										WHERE rtr.RateTableID=@p_RateTableId 
										AND rtr.TimezonesID=tr.TimezonesID AND rtr.RateID=tr.RateID
										 AND rtr.EffectiveDate<tr.EffectiveDate 
										 ORDER BY rtr.EffectiveDate DESC,rtr.RateTableRateID DESC LIMIT 1);

				UPDATE
					tmp_Rate_final tr
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
					tmp_Rate_final tr
				SET
					PreviousRate = (SELECT rtr.Rate FROM tblRateTableRate rtr  WHERE rtr.RateTableID=@p_RateTableId AND rtr.TimezonesID=tr.TimezonesID AND rtr.RateID=tr.RateID  AND rtr.EffectiveDate < tr.EffectiveDate ORDER BY rtr.EffectiveDate DESC,rtr.RateTableRateID DESC LIMIT 1);

				UPDATE
					tmp_Rate_final tr
				SET
					PreviousRate = (SELECT rtr.Rate FROM tblRateTableRateArchive rtr  WHERE   rtr.RateTableID=@p_RateTableId AND rtr.TimezonesID=tr.TimezonesID AND rtr.RateID=tr.RateID  AND rtr.EffectiveDate < tr.EffectiveDate ORDER BY rtr.EffectiveDate DESC,rtr.RateTableRateID DESC LIMIT 1)
				WHERE
					PreviousRate is null;


			END IF;


			IF @v_IncreaseEffectiveDate_ != @v_DecreaseEffectiveDate_ THEN

				UPDATE tmp_Rate_final
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
						tmp_Rate_final rate ON

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
						tmp_Rate_final rate ON

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

				
				UPDATE
						tblRateTableRateAA rtr
						LEFT JOIN
						tmp_Rate_final rate ON rate.RateID=rtr.RateID
				SET
					rtr.EndDate = NOW()
				WHERE
					rate.RateID is null
					AND rtr.RateTableId = @p_RateTableId
					AND rtr.TimezonesID = rate.TimezonesID
					AND rtr.EffectiveDate = rate.EffectiveDate;


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


				
				UPDATE
						tblRateTableRate rtr
						LEFT JOIN
						tmp_Rate_final rate ON rate.RateID=rtr.RateID
				SET
					rtr.EndDate = NOW()
				WHERE
					rate.RateID is null
					AND rtr.RateTableId = @p_RateTableId
					AND rtr.TimezonesID = rate.TimezonesID
					AND rtr.EffectiveDate = rate.EffectiveDate 				;


				CALL prc_ArchiveOldRateTableRate(@p_RateTableId,NULL,CONCAT(@p_ModifiedBy,'|RateGenerator'));


			END IF;





			
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

-- Dumping structure for procedure speakintelligentRM.prc_WSGenerateRateTableDID
DROP PROCEDURE IF EXISTS `prc_WSGenerateRateTableDID`;
DELIMITER //
CREATE  PROCEDURE `prc_WSGenerateRateTableDID`(
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

			/*DROP TEMPORARY TABLE IF EXISTS tmp_final_table_output;
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


			);*/


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
				VendorConnectionID int,
				AccessType varchar(200),
				CountryID int,
				City varchar(50),
				Tariff varchar(50),
				Code varchar(100),

 				CostPerMinute DECIMAL(18,8),
				OutpaymentPerMinute DECIMAL(18,8),
				SurchargePerMinute DECIMAL(18,8),

 				minute_CostPerMinute DECIMAL(18,2),
				minute_OutpaymentPerMinute DECIMAL(18,2),
				minute_SurchargePerMinute DECIMAL(18,2),

				INDEX Index1 (TimezonesID),
				INDEX Index2 (VendorConnectionID),
				INDEX Index3 (AccessType),
				INDEX Index4 (CountryID),
				INDEX Index5 (City),
				INDEX Index6 (Tariff),
				INDEX Index7 (Code)

			);

			DROP TEMPORARY TABLE IF EXISTS tmp_accounts;
			CREATE TEMPORARY TABLE tmp_accounts (
				ID int auto_increment,
				VendorConnectionID int,
				AccessType varchar(200),
				CountryID int,
				City varchar(50),
				Tariff varchar(50),
				Code varchar(100),

				Primary Key (ID )

			);

			DROP TEMPORARY TABLE IF EXISTS tmp_accounts2;
			CREATE TEMPORARY TABLE tmp_accounts2 (
				ID int auto_increment,
				VendorID int,
				AccessType varchar(200),
				CountryID int,
				City varchar(50),
				Tariff varchar(50),
				Code varchar(100),
				Primary Key (ID )
			);

		DROP TEMPORARY TABLE IF EXISTS tmp_accounts2_dup;
		CREATE TEMPORARY TABLE tmp_accounts2_dup (
			ID int auto_increment,
			VendorID int,
			AccessType varchar(200),
			CountryID int,
			City varchar(50),
			Tariff varchar(50),
			Code varchar(100),
			Primary Key (ID )
		);

		DROP TEMPORARY TABLE IF EXISTS tmp_timezone_minutes_2;
			CREATE TEMPORARY TABLE tmp_timezone_minutes_2 (
				TimezonesID int,
				VendorConnectionID int,
				AccessType varchar(200),
				CountryID int,
				City varchar(50),
				Tariff varchar(50),
				Code varchar(100),

				CostPerMinute DECIMAL(18,8),
				OutpaymentPerMinute DECIMAL(18,8),
				SurchargePerMinute DECIMAL(18,8),

 				minute_CostPerMinute DECIMAL(18,2),
				minute_OutpaymentPerMinute DECIMAL(18,2),
				minute_SurchargePerMinute DECIMAL(18,2),

				INDEX Index1 (TimezonesID),
				INDEX Index2 (VendorConnectionID),
				INDEX Index3 (AccessType),
				INDEX Index4 (CountryID),
				INDEX Index5 (City),
				INDEX Index6 (Tariff),
				INDEX Index7 (Code)

			);
			DROP TEMPORARY TABLE IF EXISTS tmp_timezone_minutes_3;
			CREATE TEMPORARY TABLE tmp_timezone_minutes_3 (
				TimezonesID int,
				VendorConnectionID int,
				AccessType varchar(200),
				CountryID int,
				City varchar(50),
				Tariff varchar(50),
				Code varchar(100),

 				CostPerMinute DECIMAL(18,8),
				OutpaymentPerMinute DECIMAL(18,8),
				SurchargePerMinute DECIMAL(18,8),

 				minute_CostPerMinute DECIMAL(18,2),
				minute_OutpaymentPerMinute DECIMAL(18,2),
				minute_SurchargePerMinute DECIMAL(18,2),

				INDEX Index1 (TimezonesID),
				INDEX Index2 (VendorConnectionID),
				INDEX Index3 (AccessType),
				INDEX Index4 (CountryID),
				INDEX Index5 (City),
				INDEX Index6 (Tariff),
				INDEX Index7 (Code)

			);



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
			SET @v_PeakTimeZoneID	 				 = @v_TimezonesID;
			SET @p_PeakTimeZonePercentage	 		 = @v_TimezonesPercentage;
			SET @p_MobileOriginationPercentage	 = @v_OriginationPercentage ;

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

				where StartDate >= @v_StartDate_ AND StartDate <= @v_EndDate_ and d.is_inbound = 1

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

				where StartDate >= @v_StartDate_ AND StartDate <= @v_EndDate_ and d.is_inbound = 1 and TimezonesID is not null

				AND ( fn_IsEmpty(@p_CountryID) OR  c.CountryID = @p_CountryID )

				AND ( fn_IsEmpty(@p_AccessType)  OR d.NoType = @p_AccessType)

				AND ( fn_IsEmpty(@p_City)  OR d.City  = @p_City)

				AND ( fn_IsEmpty(@p_Tariff) OR d.Tariff  = @p_Tariff )

				AND ( fn_IsEmpty(@p_Prefix)  OR ( d.CLIPrefix   = concat(c.Prefix,  @p_Prefix )  ) )

				group by TimezonesID  , d.NoType, c.CountryID, d.CLIPrefix, d.City, d.Tariff;


				insert into tmp_origination_minutes ( OriginationCode, minutes )

				select CLIPrefix  , (sum(billed_duration) / 60) as minutes

				from speakintelligentCDR.tblUsageDetails  d

				inner join speakintelligentCDR.tblUsageHeader h on d.UsageHeaderID = h.UsageHeaderID

				inner join speakintelligentRM.tblCountry c  on   d.CLIPrefix  like concat(c.Prefix,'%')

				where StartDate >= @v_StartDate_ AND StartDate <= @v_EndDate_ and d.is_inbound = 1 and CLIPrefix is not null

				AND ( fn_IsEmpty(@p_CountryID) OR  c.CountryID = @p_CountryID )

				AND ( fn_IsEmpty(@p_AccessType)  OR d.NoType = @p_AccessType)

				AND ( fn_IsEmpty(@p_City)  OR d.City  = @p_City)

				AND ( fn_IsEmpty(@p_Tariff) OR d.Tariff  = @p_Tariff )

				AND ( fn_IsEmpty(@p_Prefix)  OR ( d.CLIPrefix   = concat(c.Prefix,  @p_Prefix )  ) )

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

					insert into tmp_timezone_minutes ( VendorConnectionID, TimezonesID, AccessType,CountryID,Code,City,Tariff ,CostPerMinute, OutpaymentPerMinute, SurchargePerMinute  )

					select VendorConnectionID, TimezonesID, AccessType, CountryID, Code, City, Tariff , CostPerMinute, OutpaymentPerMinute, SurchargePerMinute
						from(

						Select DISTINCT vc.VendorConnectionID, drtr.TimezonesID, drtr.AccessType, c.CountryID,r.Code, drtr.City, drtr.Tariff , sum(drtr.CostPerMinute) as CostPerMinute, sum(drtr.OutpaymentPerMinute) as OutpaymentPerMinute, sum(drtr.SurchargePerMinute) as SurchargePerMinute


						from tblRateTableDIDRate  drtr
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

							and vc.DIDCategoryID = @v_DIDCategoryID_

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
							group by VendorConnectionID, TimezonesID, AccessType, CountryID, r.Code, City, Tariff

						)	tmp ;





					-- SET @p_PeakTimeZonePercentage	 		 = @p_TimezonePercentage;
					-- SET @p_MobileOrigination				 = @p_Origination ;
					-- SET @p_MobileOriginationPercentage	 	 = @p_OriginationPercentage ;


					-- insert into tmp_timezones (TimezonesID) select TimezonesID from tblTimezones;

					-- SET @v_rowCount_ = ( SELECT COUNT(*) FROM tmp_timezones );

					--  account loop

					INSERT INTO tmp_accounts ( VendorConnectionID ,AccessType,CountryID,Code,City,Tariff )
					SELECT DISTINCT VendorConnectionID, AccessType,CountryID,Code,City,Tariff FROM tmp_timezone_minutes;



					-- SET PEAK/Selected Timezones minutes
												/* lOGIC IF @p_PeakTimeZonePercentage > 0 THEN

													SET @v_PeakTimeZoneMinutes				 =  ( (@p_Minutes/ 100) * @p_PeakTimeZonePercentage ) 	;

												ELSE
													SET @v_no_of_timezones 				= 		(select count(DISTINCT TimezonesID) from tmp_timezone_minutes WHERE AccountID = @v_AccountID AND AccessType = @v_AccessType AND CountryID = @v_CountryID AND Prefix = @v_Prefix AND City = @v_City AND Tariff = @v_Tariff );
													SET @v_PeakTimeZoneMinutes				 =   @p_Minutes /  @v_no_of_timezones	;

												END IF;	*/
					IF @p_PeakTimeZonePercentage > 0 THEN

						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET minute_CostPerMinute = ( (@p_Minutes/ 100) * @p_PeakTimeZonePercentage )

						WHERE  tzm.TimezonesID = @p_Timezone AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff AND tzm.CostPerMinute IS NOT NULL;

						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET minute_OutpaymentPerMinute =  ( (@p_Minutes/ 100) * @p_PeakTimeZonePercentage )

						WHERE  tzm.TimezonesID = @p_Timezone AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff AND tzm.OutpaymentPerMinute IS NOT NULL;

						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET minute_SurchargePerMinute = ( (@p_Minutes/ 100) * @p_PeakTimeZonePercentage )

						WHERE  tzm.TimezonesID = @p_Timezone AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff AND tzm.SurchargePerMinute IS NOT NULL;


						-- truncate and update latest to have latest updated miutes
						truncate table tmp_timezone_minutes_2;
						truncate table tmp_timezone_minutes_3;

						INSERT INTO tmp_timezone_minutes_2 SELECT * FROM tmp_timezone_minutes;
						INSERT INTO tmp_timezone_minutes_3 SELECT * FROM tmp_timezone_minutes;


						-- SET Remaining Timezone minutes
										--				LOGIC		SET @v_RemainingTimezonesForCostPerMinute = ( SELECT count(*) FROM tmp_timezone_minutes where TimezonesID != @p_Timezone AND AccountID = @v_AccountID AND AccessType = @v_AccessType AND CountryID = @v_CountryID AND Code = @v_Prefix AND City = @v_City AND Tariff = @v_Tariff AND CostPerMinute IS NOT NULL );
										--						SET @v_RemainingCostPerMinute = (@p_Minutes - IFNULL(@v_PeakTimeZoneMinutes,0)  ) / @v_RemainingTimezonesForCostPerMinute ;


						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET minute_CostPerMinute = ( @p_Minutes - IFNULL((select tzmd2.minute_CostPerMinute
																			from tmp_timezone_minutes_3 tzmd2 WHERE tzmd2.TimezonesID = @p_Timezone AND tzmd2.VendorConnectionID = a.VendorConnectionID AND tzmd2.AccessType = a.AccessType AND tzmd2.CountryID = a.CountryID AND tzmd2.Code = a.Code AND tzmd2.City = a.City
																			AND tzmd2.Tariff = a.Tariff AND tzmd2.CostPerMinute IS NOT NULL),0) )
														/ (  select count(*)  from tmp_timezone_minutes_2 tzmd WHERE tzmd.TimezonesID != @p_Timezone AND tzmd.VendorConnectionID = a.VendorConnectionID AND tzmd.AccessType = a.AccessType AND tzmd.CountryID = a.CountryID AND tzmd.Code = a.Code AND tzmd.City = a.City
														AND tzmd.Tariff = a.Tariff AND tzmd.CostPerMinute IS NOT NULL)
						WHERE  (tzm.TimezonesID != @p_Timezone) AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.Code = a.Code AND tzm.City = a.City
													AND tzm.Tariff = a.Tariff AND tzm.CostPerMinute IS NOT NULL;


						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET minute_OutpaymentPerMinute = ( @p_Minutes - IFNULL((select tzmd2.minute_OutpaymentPerMinute
																			from tmp_timezone_minutes_3 tzmd2 WHERE tzmd2.TimezonesID = @p_Timezone AND tzmd2.VendorConnectionID = a.VendorConnectionID AND tzmd2.AccessType = a.AccessType AND tzmd2.CountryID = a.CountryID AND tzmd2.Code = a.Code AND tzmd2.City = a.City
																			AND tzmd2.Tariff = a.Tariff AND tzmd2.OutpaymentPerMinute IS NOT NULL),0) )
														/ (  select count(*)  from tmp_timezone_minutes_2 tzmd WHERE tzmd.TimezonesID != @p_Timezone AND tzmd.VendorConnectionID = a.VendorConnectionID AND tzmd.AccessType = a.AccessType AND tzmd.CountryID = a.CountryID AND tzmd.Code = a.Code AND tzmd.City = a.City
														AND tzmd.Tariff = a.Tariff AND tzmd.OutpaymentPerMinute IS NOT NULL)
						WHERE  (tzm.TimezonesID != @p_Timezone) AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.Code = a.Code AND tzm.City = a.City
													AND tzm.Tariff = a.Tariff AND tzm.OutpaymentPerMinute IS NOT NULL;

						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET minute_SurchargePerMinute = ( @p_Minutes - IFNULL((select tzmd2.minute_SurchargePerMinute
																			from tmp_timezone_minutes_3 tzmd2 WHERE (tzmd2.TimezonesID = @p_Timezone) AND tzmd2.VendorConnectionID = a.VendorConnectionID AND tzmd2.AccessType = a.AccessType AND tzmd2.CountryID = a.CountryID AND tzmd2.Code = a.Code AND tzmd2.City = a.City
																			AND tzmd2.Tariff = a.Tariff AND tzmd2.SurchargePerMinute IS NOT NULL),0) )
														/ (  select count(*)  from tmp_timezone_minutes_2 tzmd WHERE tzmd.TimezonesID != @p_Timezone AND tzmd.VendorConnectionID = a.VendorConnectionID AND tzmd.AccessType = a.AccessType AND tzmd.CountryID = a.CountryID AND tzmd.Code = a.Code AND tzmd.City = a.City
														AND tzmd.Tariff = a.Tariff AND tzmd.SurchargePerMinute IS NOT NULL)
						WHERE  (tzm.TimezonesID != @p_Timezone) AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.Code = a.Code AND tzm.City = a.City
													AND tzm.Tariff = a.Tariff AND tzm.SurchargePerMinute IS NOT NULL;


						/* Now new logic is if Vendor provides only 1 Tiezones which is v.TimezonesID = @p_Timezone
							then it should apply all minutes to those values ignoring % value specified against @p_Timezone
							so total minutes accorss record / product should be 100%

							Minutes = 500
							%		= 20
							Timezone = Default (100)

							VendorConnectionID  p_CountryID p_AccessType p_City p_Tariff p_Prefix TimezoneID 	CostPerMinute OutpaymentPerMinute	SurchargePerMinutes
								1																	Peak			NULL				0.07289			0.0728
								1																	Off-Peak		0.5					0.0728
								2																	Default			NULL				0.49


							VendorConnectionID  p_CountryID p_AccessType p_City p_Tariff p_Prefix TimezoneID 	CostPerMinute OutpaymentPerMinute			SurchargePerMinutes
								1																	Peak			NULL				0.07289  * 250		0.0728 * 500
								1																	Off-Peak		0.5	 * 500	<--		0.07289  * 250
								2																	Default			NULL				0.49 * 500	<---


							*/
							UPDATE  tmp_timezone_minutes tzm
							INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
							SET minute_CostPerMinute = @p_Minutes
							WHERE  (tzm.TimezonesID = @p_Timezone) AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.Code = a.Code AND tzm.City = a.City
														AND tzm.Tariff = a.Tariff AND tzm.CostPerMinute IS NOT NULL
														AND	(  select count(*)  from tmp_timezone_minutes_2 tzmd
														WHERE tzmd.TimezonesID != @p_Timezone
														AND tzmd.VendorConnectionID = a.VendorConnectionID AND tzmd.AccessType = a.AccessType AND tzmd.CountryID = a.CountryID AND tzmd.Code = a.Code AND tzmd.City = a.City AND tzmd.Tariff = a.Tariff AND tzmd.CostPerMinute IS NOT NULL) = 0;

							UPDATE  tmp_timezone_minutes tzm
							INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
							SET minute_OutpaymentPerMinute = @p_Minutes
							WHERE  (tzm.TimezonesID = @p_Timezone) AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.Code = a.Code AND tzm.City = a.City
														AND tzm.Tariff = a.Tariff AND tzm.OutpaymentPerMinute IS NOT NULL
														AND	(  select count(*)  from tmp_timezone_minutes_2 tzmd
														WHERE tzmd.TimezonesID != @p_Timezone
														AND tzmd.VendorConnectionID = a.VendorConnectionID AND tzmd.AccessType = a.AccessType AND tzmd.CountryID = a.CountryID AND tzmd.Code = a.Code AND tzmd.City = a.City  AND tzmd.Tariff = a.Tariff AND tzmd.OutpaymentPerMinute IS NOT NULL ) = 0;


							UPDATE  tmp_timezone_minutes tzm
							INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
							SET minute_SurchargePerMinute = @p_Minutes
							WHERE  (tzm.TimezonesID = @p_Timezone) AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.Code = a.Code AND tzm.City = a.City
														AND tzm.Tariff = a.Tariff AND tzm.SurchargePerMinute IS NOT NULL
														AND	(  select count(*)  from tmp_timezone_minutes_2 tzmd
														WHERE tzmd.TimezonesID != @p_Timezone
														AND tzmd.VendorConnectionID = a.VendorConnectionID AND tzmd.AccessType = a.AccessType AND tzmd.CountryID = a.CountryID AND tzmd.Code = a.Code AND tzmd.City = a.City AND tzmd.Tariff = a.Tariff AND tzmd.SurchargePerMinute IS NOT NULL) = 0;


							/* ################################################ New logic over */

					ELSE

						INSERT INTO tmp_timezone_minutes_2 SELECT * FROM tmp_timezone_minutes;

						-- when p_PeakTimeZonePercentage is blank equally distribute minutes
						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET minute_CostPerMinute =  @p_Minutes /  (select count(DISTINCT tzmd.TimezonesID) from tmp_timezone_minutes_2 tzmd WHERE tzmd.VendorConnectionID = tzm.VendorConnectionID AND tzmd.AccessType = tzm.AccessType AND tzmd.CountryID = tzm.CountryID AND tzmd.Code = tzm.Code AND tzmd.City = tzm.City AND tzmd.Tariff = tzm.Tariff AND tzmd.CostPerMinute IS NOT NULL )

						WHERE  /*tzm.TimezonesID = @p_Timezone AND*/ tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff AND tzm.CostPerMinute IS NOT NULL;

						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET minute_OutpaymentPerMinute = @p_Minutes /  (select count(DISTINCT tzmd.TimezonesID) from tmp_timezone_minutes_2 tzmd WHERE tzmd.VendorConnectionID = tzm.VendorConnectionID AND tzmd.AccessType = tzm.AccessType AND tzmd.CountryID = tzm.CountryID AND tzmd.Code = tzm.Code AND tzmd.City = tzm.City AND tzmd.Tariff = tzm.Tariff AND tzmd.OutpaymentPerMinute IS NOT NULL)

						WHERE  /*tzm.TimezonesID = @p_Timezone AND*/ tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff AND tzm.OutpaymentPerMinute IS NOT NULL;

						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET minute_SurchargePerMinute = @p_Minutes /  (select count(DISTINCT tzmd.TimezonesID) from tmp_timezone_minutes_2 tzmd WHERE tzmd.VendorConnectionID = a.VendorConnectionID AND tzmd.AccessType = a.AccessType AND tzmd.CountryID = a.CountryID AND tzmd.Code = a.Code AND tzmd.City = a.City AND tzmd.Tariff = a.Tariff AND tzmd.SurchargePerMinute IS NOT NULL)

						WHERE  /*tzm.TimezonesID = @p_Timezone AND*/ tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff AND tzm.SurchargePerMinute IS NOT NULL;


					END IF;







					/*SET @v_v_pointer_ = 1;

					SET @v_v_rowCount_ = ( SELECT COUNT(*) FROM tmp_accounts );

					WHILE @v_v_pointer_ <= @v_v_rowCount_
					DO

								SET @v_AccountID = ( SELECT AccountID FROM tmp_accounts WHERE ID = @v_v_pointer_ );
								SET @v_AccessType = ( SELECT AccessType FROM tmp_accounts WHERE ID = @v_v_pointer_ );
								SET @v_CountryID = ( SELECT CountryID FROM tmp_accounts WHERE ID = @v_v_pointer_ );
								SET @v_Prefix = ( SELECT Prefix FROM tmp_accounts WHERE ID = @v_v_pointer_ );
								SET @v_City = ( SELECT City FROM tmp_accounts WHERE ID = @v_v_pointer_ );
								SET @v_Tariff = ( SELECT Tariff FROM tmp_accounts WHERE ID = @v_v_pointer_ );


								IF @p_PeakTimeZonePercentage > 0 THEN

									SET @v_PeakTimeZoneMinutes				 =  ( (@p_Minutes/ 100) * @p_PeakTimeZonePercentage ) 	;

								ELSE
									SET @v_no_of_timezones 				= 		(select count(DISTINCT TimezonesID) from tmp_timezone_minutes WHERE  AccountID = @v_AccountID AND AccessType = @v_AccessType AND CountryID = @v_CountryID AND Prefix = @v_Prefix AND City = @v_City AND Tariff = @v_Tariff );
									SET @v_PeakTimeZoneMinutes				 =   @p_Minutes /  @v_no_of_timezones	;

								END IF;


								UPDATE  tmp_timezone_minutes SET minute_CostPerMinute =  @v_PeakTimeZoneMinutes
								WHERE  TimezonesID = @v_PeakTimeZoneID AND AccountID = @v_AccountID AND AccessType = @v_AccessType AND CountryID = @v_CountryID AND Prefix = @v_Prefix AND City = @v_City AND Tariff = @v_Tariff AND CostPerMinute IS NOT NULL;


								UPDATE  tmp_timezone_minutes SET minute_OutpaymentPerMinute =  @v_PeakTimeZoneMinutes
								WHERE  TimezonesID = @v_PeakTimeZoneID AND AccountID = @v_AccountID AND AccessType = @v_AccessType AND CountryID = @v_CountryID AND Prefix = @v_Prefix AND City = @v_City AND Tariff = @v_Tariff AND OutpaymentPerMinute IS NOT NULL;

								UPDATE  tmp_timezone_minutes SET minute_SurchargePerMinute =  @v_PeakTimeZoneMinutes
								WHERE  TimezonesID = @v_PeakTimeZoneID AND AccountID = @v_AccountID AND AccessType = @v_AccessType AND CountryID = @v_CountryID AND Prefix = @v_Prefix AND City = @v_City AND Tariff = @v_Tariff AND SurchargePerMinute IS NOT NULL;


								SET @v_RemainingTimezonesForCostPerMinute = ( SELECT count(*) FROM tmp_timezone_minutes where TimezonesID != @v_PeakTimeZoneID AND AccountID = @v_AccountID AND AccessType = @v_AccessType AND CountryID = @v_CountryID AND Prefix = @v_Prefix AND City = @v_City AND Tariff = @v_Tariff AND CostPerMinute IS NOT NULL );
								SET @v_RemainingTimezonesForOutpaymentPerMinute = ( SELECT count(*) FROM tmp_timezone_minutes where TimezonesID != @v_PeakTimeZoneID AND AccountID = @v_AccountID AND AccessType = @v_AccessType AND CountryID = @v_CountryID AND Prefix = @v_Prefix AND City = @v_City AND Tariff = @v_Tariff AND OutpaymentPerMinute IS NOT NULL );
								SET @v_RemainingTimezonesForSurchargePerMinute = ( SELECT count(*) FROM tmp_timezone_minutes where TimezonesID != @v_PeakTimeZoneID AND AccountID = @v_AccountID AND AccessType = @v_AccessType AND CountryID = @v_CountryID AND Prefix = @v_Prefix AND City = @v_City AND Tariff = @v_Tariff AND SurchargePerMinute IS NOT NULL );

								SET @v_RemainingCostPerMinute = (@p_Minutes - IFNULL(@v_PeakTimeZoneMinutes,0)  ) / @v_RemainingTimezonesForCostPerMinute ;
								SET @v_RemainingOutpaymentPerMinute = (@p_Minutes - IFNULL(@v_PeakTimeZoneMinutes,0) ) / @v_RemainingTimezonesForOutpaymentPerMinute ;
								SET @v_RemainingSurchargePerMinute = (@p_Minutes - IFNULL(@v_PeakTimeZoneMinutes,0) ) / @v_RemainingTimezonesForSurchargePerMinute ;

								SET @v_pointer_ = 1;

								WHILE @v_pointer_ <= @v_rowCount_
								DO

										SET @v_TimezonesID = ( SELECT TimezonesID FROM tmp_timezones WHERE ID = @v_pointer_ AND TimezonesID != @v_PeakTimeZoneID );

										if @v_TimezonesID > 0 THEN

												UPDATE  tmp_timezone_minutes SET minute_CostPerMinute =  @v_RemainingCostPerMinute
												WHERE  TimezonesID = @v_TimezonesID AND AccountID = @v_AccountID AND AccessType = @v_AccessType AND CountryID = @v_CountryID AND Prefix = @v_Prefix AND City = @v_City AND Tariff = @v_Tariff  AND CostPerMinute IS NOT NULL;


												UPDATE  tmp_timezone_minutes SET minute_OutpaymentPerMinute =  @v_RemainingOutpaymentPerMinute
												WHERE  TimezonesID = @v_TimezonesID AND AccountID = @v_AccountID AND AccessType = @v_AccessType AND CountryID = @v_CountryID AND Prefix = @v_Prefix AND City = @v_City AND Tariff = @v_Tariff  AND OutpaymentPerMinute IS NOT NULL;

												UPDATE  tmp_timezone_minutes SET minute_SurchargePerMinute =  @v_RemainingSurchargePerMinute
												WHERE  TimezonesID = @v_TimezonesID AND AccountID = @v_AccountID AND AccessType = @v_AccessType AND CountryID = @v_CountryID AND Prefix = @v_Prefix AND City = @v_City AND Tariff = @v_Tariff  AND SurchargePerMinute IS NOT NULL;

										END IF ;

									SET @v_pointer_ = @v_pointer_ + 1;

								END WHILE;

						SET @v_v_pointer_ = @v_v_pointer_ + 1;

					END WHILE;
					*/
					--  account loop ends


				insert into tmp_origination_minutes ( OriginationCode, minutes )
				select @p_MobileOrigination  , @v_MinutesFromMobileOrigination ;


		END IF;

		SET @v_days =    TIMESTAMPDIFF(DAY, (SELECT @v_StartDate_), (SELECT @v_EndDate_)) + 1 ;
		SET @v_period1 =      IF(MONTH((SELECT @v_StartDate_)) = MONTH((SELECT @v_EndDate_)), 0, (TIMESTAMPDIFF(DAY, (SELECT @v_StartDate_), LAST_DAY((SELECT @v_StartDate_)) + INTERVAL 1 DAY)) / DAY(LAST_DAY((SELECT @v_StartDate_))));
		SET @v_period2 =      TIMESTAMPDIFF(MONTH, LAST_DAY((SELECT @v_StartDate_)) + INTERVAL 1 DAY, LAST_DAY((SELECT @v_EndDate_))) ;
		SET @v_period3 =      IF(MONTH((SELECT @v_StartDate_)) = MONTH((SELECT @v_EndDate_)), (SELECT @v_days), DAY((SELECT @v_EndDate_))) / DAY(LAST_DAY((SELECT @v_EndDate_)));
		SET @v_months =     (SELECT @v_period1) + (SELECT @v_period2) + (SELECT @v_period3);

		SET @v_months = fn_Round(@v_months,1);




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
				r2.Code as OriginationCode,
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

				and vc.DIDCategoryID = @v_DIDCategoryID_

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

					( IFNULL(drtr.OutpaymentPerCall,0) * 	@p_Calls )  +
					( IFNULL(drtr.OutpaymentPerMinute,0) *  IFNULL(tm.minute_OutpaymentPerMinute,0) )

				),

				@Surcharge := (
					CASE WHEN IFNULL(drtr.SurchargePerCall,0) = 0 AND IFNULL(drtr.SurchargePerMinute,0) = 0 THEN
						IFNULL(drtr.Surcharges,0) * @p_Calls
					ELSE
						(
							(IFNULL(drtr.SurchargePerCall,0) * @p_Calls ) +
							(IFNULL(drtr.SurchargePerMinute,0) * IFNULL(tm.minute_SurchargePerMinute,0))
						)
					END
				),
				@Total := (

					(	(IFNULL(drtr.MonthlyCost,0)* @v_months)	 +  drtr.TrunkCostPerService	)				+

					( IFNULL(drtr.CollectionCostAmount,0) * @p_Calls) +
					(IFNULL(drtr.CostPerCall,0) * @p_Calls)		+
					(IFNULL(drtr.CostPerMinute,0) * IFNULL(tm.minute_CostPerMinute,0))	+

					@Surcharge - @OutPayment +

					(
						( (  (@OutPayment * 1.21) ) * IFNULL(drtr.CollectionCostPercentage,0)/100 ) +
						( (  (@OutPayment  * IFNULL(drtr.Chargeback,0)/100 ) ) )
					)

				)
					as Total
				from tmp_tblRateTableDIDRate_step1  drtr
				-- inner join tmp_SelectVendorsWithDID_ sv on drtr.VendorID = sv.VendorID AND drtr.AccessType = sv.AccessType AND drtr.CountryID = sv.CountryID AND drtr.Code = sv.Code AND drtr.City = sv.City AND drtr.Tariff = sv.Tariff AND sv.IsSelected = 1
				LEFT JOIN  tmp_timezone_minutes tm on drtr.TimezonesID = tm.TimezonesID  and ( tm.VendorConnectionID is null OR drtr.VendorConnectionID = tm.VendorConnectionID )
				AND drtr.AccessType = tm.AccessType AND drtr.CountryID = tm.CountryID AND drtr.Code = tm.Code AND drtr.City = tm.City AND drtr.Tariff = tm.Tariff;




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




				@OutPayment  := (

					( IFNULL(drtr.OutpaymentPerCall,0) * 	@p_Calls )  +
					( IFNULL(drtr.OutpaymentPerMinute,0) *  IFNULL(tom.minutes,0))

				),

				@Surcharge := (
					CASE WHEN IFNULL(drtr.SurchargePerCall,0) = 0 AND IFNULL(drtr.SurchargePerMinute,0) = 0 THEN
						IFNULL(drtr.Surcharges,0) * @p_Calls
					ELSE
						(
							(IFNULL(drtr.SurchargePerCall,0) * @p_Calls ) +
							(IFNULL(drtr.SurchargePerMinute,0) * IFNULL(tom.minutes,0))
						)
					END
				),
				@Total := (

					(	(IFNULL(drtr.MonthlyCost,0)* @v_months)	 +  drtr.TrunkCostPerService	)				+

					( IFNULL(drtr.CollectionCostAmount,0) * @p_Calls ) +
					(IFNULL(drtr.CostPerCall,0) * @p_Calls)		+
					(IFNULL(drtr.CostPerMinute,0) * IFNULL(tom.minutes,0))		+

					@Surcharge - @OutPayment +

					(
						( (  (@OutPayment * 1.21) ) * IFNULL(drtr.CollectionCostPercentage,0)/100 ) +
						( (  (@OutPayment  * IFNULL(drtr.Chargeback,0)/100 ) ) )
					)

				)
				as Total
			from tmp_tblRateTableDIDRate_step1  drtr
			-- inner join tmp_SelectVendorsWithDID_ sv on drtr.VendorID = sv.VendorID AND drtr.AccessType = sv.AccessType AND drtr.CountryID = sv.CountryID AND drtr.Code = sv.Code AND drtr.City = sv.City AND drtr.Tariff = sv.Tariff AND sv.IsSelected = 1
			inner join tmp_origination_minutes tom  on drtr.OriginationCode = tom.OriginationCode;

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


        INSERT INTO tmp_accounts2 ( VendorID , AccessType, CountryID, City,  Tariff,  Code )
        SELECT DISTINCT VendorID , AccessType, CountryID, City,  Tariff,  Code
        FROM tmp_table_output_1 GROUP BY VendorID , AccessType, CountryID, City,  Tariff,  Code;

				INSERT INTO tmp_accounts2_dup
				SELECT * FROM tmp_accounts2;

				-- add packages not exists in rate table . for a scenario
				/*Case 1
				RG Pos :2
				Custom : 			Daotec			( daotec has no custom rates )
				All		 : 			Zigo Daote
				*/
				INSERT INTO tmp_accounts2 ( VendorID , AccessType, CountryID, City,  Tariff,  Code )
					select
						v.VendorID , v.AccessType, v.CountryID, v.City,  v.Tariff,  v.Code
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
					where a.ID is   null;


				SET @v_pointer_ = 1;

				-- need to add tiemzone in rate rule.
				WHILE @v_pointer_ <= @v_rowCount_
				DO

						SET @v_RateGeneratorVendorsID = (SELECT RateGeneratorVendorsID FROM tmp_RateGeneratorVendors_  WHERE RateGeneratorVendorsID = @v_pointer_);

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



									truncate table tmp_table_output_2;
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
															 CASE WHEN (@prev_TimezonesID = TimezonesID AND @prev_Code = Code AND  @prev_AccessType    = AccessType AND  @prev_CountryID = CountryID AND  @prev_City    = City AND  @prev_Tariff = Tariff AND @prev_Total <  Total AND  (@v_percentageRate_ = 0 OR  (@prev_Total > 0 and  fn_Round( (((Total - @prev_Total) /  @prev_Total) * 100), 2 ) > @v_percentageRate_) ) )  THEN  @vPosition + 1
															 WHEN (@prev_TimezonesID = TimezonesID AND @prev_Code = Code AND  @prev_AccessType    = AccessType AND  @prev_CountryID = CountryID AND  @prev_City    = City AND  @prev_Tariff = Tariff AND @prev_Total <  Total AND  (@v_percentageRate_ = 0 OR  (@prev_Total > 0 and  fn_Round( (((Total - @prev_Total) /  @prev_Total) * 100), 2 ) <= @v_percentageRate_) ) )  THEN  -1		-- remove -1 records

															 WHEN (@prev_TimezonesID = TimezonesID AND @prev_Code = Code AND  @prev_AccessType    = AccessType AND  @prev_CountryID = CountryID AND  @prev_City    = City AND  @prev_Tariff = Tariff AND @prev_Total =  Total AND (@v_percentageRate_ = 0 OR  (@prev_Total > 0 and  fn_Round( (((Total - @prev_Total) /  @prev_Total) * 100), 2 ) > @v_percentageRate_) ) )  THEN  @vPosition
															 WHEN (@prev_TimezonesID = TimezonesID AND @prev_Code = Code AND  @prev_AccessType    = AccessType AND  @prev_CountryID = CountryID AND  @prev_City    = City AND  @prev_Tariff = Tariff AND @prev_Total =  Total AND (@v_percentageRate_ = 0 OR  (@prev_Total > 0 and  fn_Round( (((Total - @prev_Total) /  @prev_Total) * 100), 2 ) <= @v_percentageRate_) ) )  THEN  -1
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

													 from (
															 select
																 RateTableID, TimezonesID, TimezoneTitle, CodeDeckId, drtr1.CountryID, drtr1.AccessType, CountryPrefix, drtr1.City, drtr1.Tariff, drtr1.Code, OriginationCode,
																 VendorConnectionID, drtr1.VendorID,  EndDate, OneOffCost, MonthlyCost, CostPerCall, CostPerMinute, SurchargePerCall,
																 SurchargePerMinute, OutpaymentPerCall, OutpaymentPerMinute, Surcharges, Chargeback, CollectionCostAmount, CollectionCostPercentage,
																 RegistrationCostPerNumber, OneOffCostCurrency, MonthlyCostCurrency, CostPerCallCurrency, CostPerMinuteCurrency, SurchargePerCallCurrency,
																 SurchargePerMinuteCurrency, OutpaymentPerCallCurrency, OutpaymentPerMinuteCurrency, SurchargesCurrency, ChargebackCurrency, CollectionCostAmountCurrency,
																 RegistrationCostPerNumberCurrency, Total

															 from		tmp_table_output_1 drtr1
															 INNER JOIN tmp_SelectVendorsWithDID_  vd on
																			 drtr1.VendorID = vd.VendorID
																			 AND drtr1.AccessType = vd.AccessType
																			 AND   drtr1.CountryID = vd.CountryID
																			 AND   drtr1.City = vd.City
																			 AND   drtr1.Tariff = vd.Tariff
																			 AND   drtr1.Code = vd.Code

														 ) tmp

														 ,(SELECT  @vPosition := 0 , @prev_TimezonesID := '' , @prev_AccessType := '' ,@prev_CountryID  := '' ,@prev_City  := '' ,@prev_Tariff := '' ,@prev_Code  := ''  , @prev_VendorConnectionID  := '', @prev_Total := 0 ) t
													 order by AccessType ,CountryID ,City ,Tariff,Code ,TimezonesID,Total

												 ) tmp
										where vPosition  <= @v_RatePosition_ AND vPosition != -1;

									-- SET @v_max_position = (select max(vPosition)  from tmp_table_output_2   limit 1 );
									-- SET @v_SelectedVendorConnectionID = ( select VendorConnectionID from tmp_table_output_2 where vPosition = @v_max_position order by AccessType ,CountryID ,City ,Tariff,Code ,TimezonesID,Total limit 1 );

									insert into tmp_SelectedVendortblRateTableDIDRate
									(
										RateTableID, TimezonesID, TimezoneTitle, CodeDeckId, CountryID, AccessType, CountryPrefix, City, Tariff, Code, OriginationCode,
										VendorConnectionID,  VendorID, EndDate, OneOffCost, MonthlyCost, CostPerCall, CostPerMinute, SurchargePerCall,
										SurchargePerMinute, OutpaymentPerCall, OutpaymentPerMinute, Surcharges, Chargeback, CollectionCostAmount, CollectionCostPercentage,
										RegistrationCostPerNumber, OneOffCostCurrency, MonthlyCostCurrency, CostPerCallCurrency, CostPerMinuteCurrency, SurchargePerCallCurrency,
										SurchargePerMinuteCurrency, OutpaymentPerCallCurrency, OutpaymentPerMinuteCurrency, SurchargesCurrency, ChargebackCurrency, CollectionCostAmountCurrency,
										RegistrationCostPerNumberCurrency	-- , Total, vPosition
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
										-- Total,			 									vPosition
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



						SET @v_pointer_ = @v_pointer_ + 1;

				END WHILE;


		ELSE


						truncate table tmp_table_output_2;
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
												 CASE WHEN (@prev_TimezonesID = TimezonesID AND @prev_Code = Code AND  @prev_AccessType    = AccessType AND  @prev_CountryID = CountryID AND  @prev_City    = City AND  @prev_Tariff = Tariff AND @prev_Total <  Total AND  (@v_percentageRate_ = 0 OR  (@prev_Total > 0 and  fn_Round( (((Total - @prev_Total) /  @prev_Total) * 100), 2 ) > @v_percentageRate_) ) )  THEN  @vPosition + 1
												 WHEN (@prev_TimezonesID = TimezonesID AND @prev_Code = Code AND  @prev_AccessType    = AccessType AND  @prev_CountryID = CountryID AND  @prev_City    = City AND  @prev_Tariff = Tariff AND @prev_Total <  Total AND  (@v_percentageRate_ = 0 OR  (@prev_Total > 0 and  fn_Round( (((Total - @prev_Total) /  @prev_Total) * 100), 2 ) <= @v_percentageRate_) ) )  THEN  -1		-- remove -1 records

												 WHEN (@prev_TimezonesID = TimezonesID AND @prev_Code = Code AND  @prev_AccessType    = AccessType AND  @prev_CountryID = CountryID AND  @prev_City    = City AND  @prev_Tariff = Tariff AND @prev_Total =  Total AND (@v_percentageRate_ = 0 OR  (@prev_Total > 0 and  fn_Round( (((Total - @prev_Total) /  @prev_Total) * 100), 2 ) > @v_percentageRate_) ) )  THEN  @vPosition
												 WHEN (@prev_TimezonesID = TimezonesID AND @prev_Code = Code AND  @prev_AccessType    = AccessType AND  @prev_CountryID = CountryID AND  @prev_City    = City AND  @prev_Tariff = Tariff AND @prev_Total =  Total AND (@v_percentageRate_ = 0 OR  (@prev_Total > 0 and  fn_Round( (((Total - @prev_Total) /  @prev_Total) * 100), 2 ) <= @v_percentageRate_) ) )  THEN  -1
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
							where vPosition  <= @v_RatePosition_ AND vPosition != -1;

						-- SET @v_max_position = (select max(vPosition)  from tmp_table_output_2   limit 1 );
						-- SET @v_SelectedVendorConnectionID = ( select VendorConnectionID from tmp_table_output_2 where vPosition = @v_max_position order by AccessType ,CountryID ,City ,Tariff,Code ,TimezonesID,Total limit 1 );

						insert into tmp_SelectedVendortblRateTableDIDRate
						(
							RateTableID, TimezonesID, TimezoneTitle, CodeDeckId, CountryID, AccessType, CountryPrefix, City, Tariff, Code, OriginationCode,
							VendorConnectionID,  VendorID, EndDate, OneOffCost, MonthlyCost, CostPerCall, CostPerMinute, SurchargePerCall,
							SurchargePerMinute, OutpaymentPerCall, OutpaymentPerMinute, Surcharges, Chargeback, CollectionCostAmount, CollectionCostPercentage,
							RegistrationCostPerNumber, OneOffCostCurrency, MonthlyCostCurrency, CostPerCallCurrency, CostPerMinuteCurrency, SurchargePerCallCurrency,
							SurchargePerMinuteCurrency, OutpaymentPerCallCurrency, OutpaymentPerMinuteCurrency, SurchargesCurrency, ChargebackCurrency, CollectionCostAmountCurrency,
							RegistrationCostPerNumberCurrency	-- , Total, vPosition
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
							-- Total,			 									vPosition
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
												 END ) as  vPosition,
											 @prev_TimezonesID  := TimezonesID,
											 @prev_AccessType := AccessType ,
											 @prev_CountryID  := CountryID  ,
											 @prev_City  := City  ,
											 @prev_Tariff := Tariff ,
											 @prev_Code  := Code  ,
											 @prev_VendorConnectionID  := VendorConnectionID,
											 @prev_Total := Total

										 from  tmp_table_output_2
											 ,(SELECT  @vPosition := 0 , @prev_TimezonesID := '' , @prev_AccessType := '' ,@prev_CountryID  := '' ,@prev_City  := '' ,@prev_Tariff := '' ,@prev_Code  := ''  , @prev_VendorConnectionID  := '', @prev_Total := 0 ) t
										 order by AccessType ,CountryID ,City ,Tariff,Code ,TimezonesID,Total desc


									 ) tmp
							where vPosition = 1 ;
						--   group by AccessType ,CountryID ,City ,Tariff,Code ,TimezonesID;

		END IF;



			-- LEAVE GenerateRateTable;


			/*insert into tmp_SelectedVendortblRateTableDIDRate
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

			from tmp_table_output_1
			where VendorConnectionID = @v_SelectedVendorConnectionID;
			*/






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



		-- ####################################
		-- margin component  starts
		-- ####################################


	 	SET @v_pointer_ = 1;
		SET @v_rowCount_ = ( SELECT COUNT(*) FROM tmp_Raterules_ );

		WHILE @v_pointer_ <= @v_rowCount_
		DO

			SET @v_rateRuleId_ = ( SELECT rateruleid FROM tmp_Raterules_ rr WHERE rr.RowNo = @v_pointer_ );


							update tmp_SelectedVendortblRateTableDIDRate rt
							inner join tmp_Raterules_ rr on rr.RowNo  = @v_pointer_
							and  ( fn_IsEmpty(rr.TimezonesID) OR rr.TimezonesID  = rt.TimezonesID )
							and (  fn_IsEmpty(rr.Origination) OR rr.Origination = rt.OriginationCode )
							AND (  fn_IsEmpty(rr.CountryID) OR rt.CountryID = 	rr.CountryID )
							AND (  fn_IsEmpty(rr.AccessType) OR rt.AccessType = 	rr.AccessType )
	 						AND (  fn_IsEmpty(rr.Prefix)  OR rt.Code = 	concat(rt.CountryPrefix ,TRIM(LEADING '0' FROM rr.Prefix)) )
							AND (  fn_IsEmpty(rr.City) OR rt.City = 	rr.City )
							AND (  fn_IsEmpty(rr.Tariff) OR rt.Tariff = 	rr.Tariff )

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

									from tmp_SelectedVendortblRateTableDIDRate_dup

								where


								    (  fn_IsEmpty(@v_TimezonesID) OR  TimezonesID = @v_TimezonesID)
								AND (  fn_IsEmpty(@v_Origination)  OR  OriginationCode = @v_Origination)
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
							    (  fn_IsEmpty(@v_TimezonesID)   OR  TimezonesID = @v_TimezonesID)
							AND (  fn_IsEmpty(@v_Origination)  OR  OriginationCode = @v_Origination)
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


		-- ####################################
		-- merge component  over
		-- ####################################


		-- leave GenerateRateTable;




		/*
			Update same MonthlyCost, OneoffCost , RegistrationCostPerNumber	 to all record across timezones.
		*/
		TRUNCATE TABLE tmp_tblRateTableDIDRate_step1_dup;
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



		SET @v_SelectedRateTableID = ( select RateTableID from tmp_SelectedVendortblRateTableDIDRate limit 1 );

		SET @v_AffectedRecords_ = 0;

		-- LEAVE GenerateRateTable;


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

-- Dumping structure for procedure speakintelligentRM.prc_WSGenerateRateTablePackage
DROP PROCEDURE IF EXISTS `prc_WSGenerateRateTablePackage`;
DELIMITER //
CREATE  PROCEDURE `prc_WSGenerateRateTablePackage`(
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


		SET @p_jobId						=  p_jobId;
		SET @p_RateGeneratorId				=  p_RateGeneratorId;
		SET @p_RateTableId					=  p_RateTableId;
		SET @p_rateTableName				=  p_rateTableName;
		SET @p_EffectiveDate				=  p_EffectiveDate;
		SET @p_delete_exiting_rate			=  p_delete_exiting_rate;
		SET @p_EffectiveRate				=  p_EffectiveRate;
		SET @p_ModifiedBy					=  p_ModifiedBy;



		DROP TEMPORARY TABLE IF EXISTS tmp_Raterules_;
		CREATE TEMPORARY TABLE tmp_Raterules_  (
			rateruleid INT,
			PackageID int,
			Component VARCHAR(50) COLLATE utf8_unicode_ci,
			TimezonesID int,
			`Order` INT,
			RowNo INT
		);

		DROP TEMPORARY TABLE IF EXISTS tmp_RateGeneratorCalculatedRate_;
		CREATE TEMPORARY TABLE tmp_RateGeneratorCalculatedRate_  (
			CalculatedRateID INT,
			PackageID Int,
			Component VARCHAR(50),
			TimezonesID int,
			RateLessThen	DECIMAL(18, 8),
			ChangeRateTo DECIMAL(18, 8),
			RowNo INT
		);

		DROP TEMPORARY TABLE IF EXISTS tmp_RateGeneratorVendors_;
		CREATE TEMPORARY TABLE tmp_RateGeneratorVendors_  (
			RateGeneratorVendorsID INT AUTO_INCREMENT,
			PackageID Int,
			Vendors varchar(50),
			PRIMARY KEY (RateGeneratorVendorsID)
		);


		DROP TEMPORARY TABLE IF EXISTS tmp_SelectVendorsWithPackage_;
		CREATE TEMPORARY TABLE tmp_SelectVendorsWithPackage_  (
			SelectVendorsWithPackageID INT AUTO_INCREMENT,
			VendorID int,
			PackageID Int,
			IsSelected	int,
			PRIMARY KEY (SelectVendorsWithPackageID)
		);
		DROP TEMPORARY TABLE IF EXISTS tmp_SelectVendorsWithPackage_dup;
		CREATE TEMPORARY TABLE tmp_SelectVendorsWithPackage_dup  (
			SelectVendorsWithPackageID INT AUTO_INCREMENT,
			VendorID int,
			PackageID Int,
			IsSelected	int,
			PRIMARY KEY (SelectVendorsWithPackageID)
		);

		DROP TEMPORARY TABLE IF EXISTS tblRateTablePKGRate_step1;
		CREATE TEMPORARY TABLE tblRateTablePKGRate_step1 (
			RateTableID int,
			TimezonesID  int,
			
			CodeDeckId int,
			PackageID int,
			Code varchar(100),
			VendorConnectionID int,
			VendorID int,
			
			EffectiveDate datetime,
			EndDate datetime,
			OneOffCost DECIMAL(18,8) NULL DEFAULT NULL,
			MonthlyCost DECIMAL(18,8) NULL DEFAULT NULL,
			PackageCostPerMinute DECIMAL(18,8) NULL DEFAULT NULL,
			RecordingCostPerMinute DECIMAL(18,8) NULL DEFAULT NULL
		);



		DROP TEMPORARY TABLE IF EXISTS tblRateTablePKGRate_step1_dup;
		CREATE TEMPORARY TABLE tblRateTablePKGRate_step1_dup (
			RateTableID int,
			TimezonesID  int,
			
			CodeDeckId int,
			PackageID int,
			Code varchar(100),
			VendorConnectionID int,
			VendorID int,
			
			EffectiveDate datetime,
			EndDate datetime,
			OneOffCost DECIMAL(18,8) NULL DEFAULT NULL,
			MonthlyCost DECIMAL(18,8) NULL DEFAULT NULL,
			PackageCostPerMinute DECIMAL(18,8) NULL DEFAULT NULL,
			RecordingCostPerMinute DECIMAL(18,8) NULL DEFAULT NULL

		);


		DROP TEMPORARY TABLE IF EXISTS tmp_table_pkg;
		CREATE TEMPORARY TABLE tmp_table_pkg (
			RateTableID int,
			TimezonesID  int,
			
			CodeDeckId int,
			PackageID int,
			Code varchar(100),
			VendorConnectionID int,
			VendorID int,
			
			EffectiveDate datetime,
			EndDate datetime,
			OneOffCost DECIMAL(18,8) NULL DEFAULT NULL,
			MonthlyCost DECIMAL(18,8) NULL DEFAULT NULL,
			PackageCostPerMinute DECIMAL(18,8) NULL DEFAULT NULL,
			RecordingCostPerMinute DECIMAL(18,8) NULL DEFAULT NULL,


			OneOffCostCurrency INT(11) NULL DEFAULT NULL,
			MonthlyCostCurrency INT(11) NULL DEFAULT NULL,
			PackageCostPerMinuteCurrency INT(11) NULL DEFAULT NULL,
			RecordingCostPerMinuteCurrency INT(11) NULL DEFAULT NULL,

			Total DECIMAL(18, 8)
		);


		DROP TEMPORARY TABLE IF EXISTS tmp_table_output_1;
		CREATE TEMPORARY TABLE tmp_table_output_1 (
			RateTableID int,
			TimezonesID  int,
			
			CodeDeckId int,
			PackageID int,
			Code varchar(100),
			VendorConnectionID int,
			VendorID int,
			
			EffectiveDate datetime,
			EndDate datetime,
			OneOffCost DECIMAL(18,8) NULL DEFAULT NULL,
			MonthlyCost DECIMAL(18,8) NULL DEFAULT NULL,
			PackageCostPerMinute DECIMAL(18,8) NULL DEFAULT NULL,
			RecordingCostPerMinute DECIMAL(18,8) NULL DEFAULT NULL,


			OneOffCostCurrency INT(11) NULL DEFAULT NULL,
			MonthlyCostCurrency INT(11) NULL DEFAULT NULL,
			PackageCostPerMinuteCurrency INT(11) NULL DEFAULT NULL,
			RecordingCostPerMinuteCurrency INT(11) NULL DEFAULT NULL,

			Total DECIMAL(18, 8)
		);


		DROP TEMPORARY TABLE IF EXISTS tmp_table_output_2;
		CREATE TEMPORARY TABLE tmp_table_output_2 (
			RateTableID int,
			TimezonesID  int,
			
			CodeDeckId int,
			PackageID int,
			Code varchar(100),
			VendorConnectionID int,
			VendorID int,
			
			EffectiveDate datetime,
			EndDate datetime,
			OneOffCost DECIMAL(18,8) NULL DEFAULT NULL,
			MonthlyCost DECIMAL(18,8) NULL DEFAULT NULL,
			PackageCostPerMinute DECIMAL(18,8) NULL DEFAULT NULL,
			RecordingCostPerMinute DECIMAL(18,8) NULL DEFAULT NULL,


			OneOffCostCurrency INT(11) NULL DEFAULT NULL,
			MonthlyCostCurrency INT(11) NULL DEFAULT NULL,
			PackageCostPerMinuteCurrency INT(11) NULL DEFAULT NULL,
			RecordingCostPerMinuteCurrency INT(11) NULL DEFAULT NULL,

			Total DECIMAL(18, 8),
			vPosition int
		);


		DROP TEMPORARY TABLE IF EXISTS tmp_table_output_3;
		CREATE TEMPORARY TABLE tmp_table_output_3 (
			RateTableID int,
			TimezonesID  int,
			
			CodeDeckId int,
			PackageID int,
			Code varchar(100),
			VendorConnectionID int,
			VendorID int,
			
			EffectiveDate datetime,
			EndDate datetime,
			OneOffCost DECIMAL(18,8) NULL DEFAULT NULL,
			MonthlyCost DECIMAL(18,8) NULL DEFAULT NULL,
			PackageCostPerMinute DECIMAL(18,8) NULL DEFAULT NULL,
			RecordingCostPerMinute DECIMAL(18,8) NULL DEFAULT NULL,


			OneOffCostCurrency INT(11) NULL DEFAULT NULL,
			MonthlyCostCurrency INT(11) NULL DEFAULT NULL,
			PackageCostPerMinuteCurrency INT(11) NULL DEFAULT NULL,
			RecordingCostPerMinuteCurrency INT(11) NULL DEFAULT NULL

		);


		

		DROP TEMPORARY TABLE IF EXISTS tmp_SelectedVendortblRateTableRatePackage;
		CREATE TEMPORARY TABLE tmp_SelectedVendortblRateTableRatePackage (
			RateTableID int,
			TimezonesID  int,
			
			CodeDeckId int,
			PackageID int,
			Code varchar(100),
			VendorConnectionID int,
			VendorID int,
			
			EffectiveDate datetime,
			EndDate datetime,
			OneOffCost DECIMAL(18,8) NULL DEFAULT NULL,
			MonthlyCost DECIMAL(18,8) NULL DEFAULT NULL,
			PackageCostPerMinute DECIMAL(18,8) NULL DEFAULT NULL,
			RecordingCostPerMinute DECIMAL(18,8) NULL DEFAULT NULL,


			OneOffCostCurrency INT(11) NULL DEFAULT NULL,
			MonthlyCostCurrency INT(11) NULL DEFAULT NULL,
			PackageCostPerMinuteCurrency INT(11) NULL DEFAULT NULL,
			RecordingCostPerMinuteCurrency INT(11) NULL DEFAULT NULL,

			new_OneOffCost DECIMAL(18, 8),
			new_MonthlyCost DECIMAL(18, 8),
			new_PackageCostPerMinute DECIMAL(18, 8),
			new_RecordingCostPerMinute DECIMAL(18, 8)


		);

		DROP TEMPORARY TABLE IF EXISTS tmp_SelectedVendortblRateTableRatePackage_dup;
		CREATE TEMPORARY TABLE tmp_SelectedVendortblRateTableRatePackage_dup (
			RateTableID int,
			TimezonesID  int,
			
			CodeDeckId int,
			PackageID int,
			Code varchar(100),
			VendorConnectionID int,
			VendorID int,
			
			EffectiveDate datetime,
			EndDate datetime,
			OneOffCost DECIMAL(18,8) NULL DEFAULT NULL,
			MonthlyCost DECIMAL(18,8) NULL DEFAULT NULL,
			PackageCostPerMinute DECIMAL(18,8) NULL DEFAULT NULL,
			RecordingCostPerMinute DECIMAL(18,8) NULL DEFAULT NULL,


			OneOffCostCurrency INT(11) NULL DEFAULT NULL,
			MonthlyCostCurrency INT(11) NULL DEFAULT NULL,
			PackageCostPerMinuteCurrency INT(11) NULL DEFAULT NULL,
			RecordingCostPerMinuteCurrency INT(11) NULL DEFAULT NULL,

			new_OneOffCost DECIMAL(18, 8),
			new_MonthlyCost DECIMAL(18, 8),
			new_PackageCostPerMinute DECIMAL(18, 8),
			new_RecordingCostPerMinute DECIMAL(18, 8)


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
			PackageID int,
			PackageCostPerMinute DECIMAL(18,8),
			RecordingCostPerMinute DECIMAL(18,8),
			minute_PackageCostPerMinute DECIMAL(18,2),
			minute_RecordingCostPerMinute DECIMAL(18,2)
		);

		DROP TEMPORARY TABLE IF EXISTS tmp_timezone_minutes_2;
		CREATE TEMPORARY TABLE tmp_timezone_minutes_2 (
			TimezonesID int,
			VendorConnectionID int,
			PackageID int,
			PackageCostPerMinute DECIMAL(18,8),
			RecordingCostPerMinute DECIMAL(18,8),
			minute_PackageCostPerMinute DECIMAL(18,2),
			minute_RecordingCostPerMinute DECIMAL(18,2)
		);

		DROP TEMPORARY TABLE IF EXISTS tmp_timezone_minutes_3;
		CREATE TEMPORARY TABLE tmp_timezone_minutes_3 (
			TimezonesID int,
			VendorConnectionID int,
			PackageID int,
			PackageCostPerMinute DECIMAL(18,8),
			RecordingCostPerMinute DECIMAL(18,8),
			minute_PackageCostPerMinute DECIMAL(18,2),
			minute_RecordingCostPerMinute DECIMAL(18,2)
		);

		DROP TEMPORARY TABLE IF EXISTS tmp_accounts;
		CREATE TEMPORARY TABLE tmp_accounts (
			ID int auto_increment,
			VendorConnectionID int,
			PackageID int,
			Primary Key (ID )

		);

		DROP TEMPORARY TABLE IF EXISTS tmp_accounts2;
		CREATE TEMPORARY TABLE tmp_accounts2(
			ID int auto_increment,
			VendorID int,
			PackageID int,
			Primary Key (ID )

		);

		DROP TEMPORARY TABLE IF EXISTS tmp_accounts2_dup;
		CREATE TEMPORARY TABLE tmp_accounts2_dup(
			ID int auto_increment,
			VendorID int,
			PackageID int,
			Primary Key (ID )

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
			PackageID,
			Calls,
			Minutes,
			DateFrom,
			DateTo,
			TimezonesID,
			TimezonesPercentage,
			IFNULL(AppliedTo,''),
			IFNULL(Reseller,''),


			IF( percentageRate = '' OR percentageRate is null	,0, percentageRate )

		INTO
			@v_RatePosition_,
			@v_CompanyId_,
			@v_RateGeneratorName_,
			@p_RateGeneratorId,
			@v_CurrencyID_,
			@v_PackageID_,
			@v_Calls,
			@v_Minutes,
			@v_StartDate_ ,
			@v_EndDate_ ,
			@v_TimezonesID,
			@v_TimezonesPercentage,
			@p_AppliedTo,
			@p_Reseller,
			@v_percentageRate_

		FROM tblRateGenerator
		WHERE RateGeneratorId = @p_RateGeneratorId;

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
			TimezonesID ,
			PackageID ,
			`Order` ,
			RowNo
		)
			SELECT
				rateruleid,
				IFNULL(Component,''),
				IFNULL(TimezonesID,0),
				IFNULL(PackageID,0),
				`Order`,
				@row_num := @row_num+1 AS RowID
			FROM tblRateRule,(SELECT @row_num := 0) x
			WHERE rategeneratorid = @p_RateGeneratorId
			ORDER BY `Order` ASC;

		INSERT INTO tmp_RateGeneratorVendors_ (
			PackageID,
			Vendors
		)
			select
				PackageID,
				Vendors
			FROM tblRateGeneratorVendors
			WHERE RateGeneratorId = @p_RateGeneratorId
			ORDER BY RateGeneratorVendorsID	;



		INSERT INTO tmp_RateGeneratorCalculatedRate_
		(
			CalculatedRateID ,
			TimezonesID ,
			Component,
			RateLessThen,
			ChangeRateTo ,
			PackageID ,
			RowNo
		)
			SELECT

				CalculatedRateID,
				IFNULL(TimezonesID,0),
				Component,
				RateLessThen,
				ChangeRateTo,
				IFNULL(PackageID,0),
				@row_num := @row_num+1 AS RowID
			FROM tblRateGeneratorCalculatedRate,
				(SELECT @row_num := 0) x
			WHERE RateGeneratorId = @p_RateGeneratorId
			ORDER BY CalculatedRateID ASC;


		set @v_ApprovedStatus = 1;

		set @v_PackageType = 3;

		set @v_AppliedToCustomer = 1;
		set @v_AppliedToVendor = 2;
		set @v_AppliedToReseller = 3;





		SET @p_Calls	 							 = @v_Calls;
		SET @p_Minutes	 							 = @v_Minutes;
		SET @v_PeakTimeZoneID	 				 = @v_TimezonesID;
		SET @p_PeakTimeZonePercentage	 		 = @v_TimezonesPercentage;


		IF  @p_Minutes = 0 THEN

			

			insert into tmp_timezone_minutes (TimezonesID,PackageID, PackageCostPerMinute,RecordingCostPerMinute)

				select PackageTimezonesID  , AccountServicePackageID, sum(PackageCostPerMinute)  ,sum(RecordingCostPerMinute)

				from speakintelligentCDR.tblUsageDetails  d

					inner join speakintelligentCDR.tblUsageHeader h on d.UsageHeaderID = h.UsageHeaderID

				where StartDate >= @v_StartDate_ AND StartDate <= @v_EndDate_

							AND d.is_inbound = 1

							AND ( @v_PackageID_ = 0 OR d.AccountServicePackageID = @v_PackageID_  )

				group by PackageTimezonesID  , AccountServicePackageID;


		ELSE


			

			insert into tmp_timezone_minutes (VendorConnectionID, TimezonesID, PackageID, PackageCostPerMinute , RecordingCostPerMinute )

				Select 	VendorConnectionID, TimezonesID, PackageID, PackageCostPerMinute, RecordingCostPerMinute
				FROM (

							 Select 	distinct vc.VendorConnectionID,drtr.TimezonesID,pk.PackageID, SUM(drtr.PackageCostPerMinute) as PackageCostPerMinute,SUM(drtr.RecordingCostPerMinute) as RecordingCostPerMinute

							 FROM tblRateTablePKGRate  drtr
								 INNER JOIN tblRateTable  rt ON rt.RateTableId = drtr.RateTableId
								 INNER JOIN tblVendorConnection vc ON vc.RateTableID = rt.RateTableId  AND vc.CompanyID = rt.CompanyId  AND vc.Active=1 AND vc.RateTypeID = @v_PackageType
								 INNER JOIN tblAccount a ON vc.AccountId = a.AccountID AND rt.CompanyId = a.CompanyId and a.IsVendor = 1 and a.Status = 1
								 INNER JOIN tblRate r ON drtr.RateID = r.RateID AND r.CompanyID = vc.CompanyID
								 INNER JOIN tblPackage pk ON pk.CompanyID = r.CompanyID AND pk.Name = r.Code
								 INNER JOIN tblTimezones t ON t.TimezonesID =  drtr.TimezonesID
							 WHERE

								 rt.CompanyId =  @v_CompanyId_

								 AND ( @v_PackageID_ = 0 OR pk.PackageId = @v_PackageID_ )

								 AND rt.Type = @v_PackageType

								 AND rt.AppliedTo = @v_AppliedToVendor

								 and (
									 (@p_EffectiveRate = 'now' AND EffectiveDate <= NOW())
									 OR
									 (@p_EffectiveRate = 'future' AND EffectiveDate > NOW()  )
									 OR
									 (	 @p_EffectiveRate = 'effective' AND EffectiveDate <= @p_EffectiveDate
											 AND ( drtr.EndDate IS NULL OR (drtr.EndDate > DATE(@p_EffectiveDate)) )
									 )
								 )
								 AND (EndDate IS NULL OR EndDate > NOW() )

							 GROUP BY vc.VendorConnectionID,drtr.TimezonesID,pk.PackageID

						 ) TMP;



			insert into tmp_timezones (TimezonesID) select TimezonesID from tblTimezones;

			SET @v_rowCount_ = ( SELECT COUNT(*) FROM tmp_timezones );





INSERT INTO tmp_accounts ( VendorConnectionID , PackageID )  SELECT DISTINCT VendorConnectionID , PackageID FROM tmp_timezone_minutes order by VendorConnectionID , PackageID;


IF @p_PeakTimeZonePercentage > 0 THEN

UPDATE  tmp_timezone_minutes tzm
	INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
SET minute_PackageCostPerMinute = ( (@p_Minutes/ 100) * @p_PeakTimeZonePercentage )

WHERE  tzm.TimezonesID = @p_Timezone AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.PackageID = a.PackageID AND tzm.PackageCostPerMinute IS NOT NULL;

UPDATE  tmp_timezone_minutes tzm
	INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
SET minute_RecordingCostPerMinute =  ( (@p_Minutes/ 100) * @p_PeakTimeZonePercentage )

WHERE  tzm.TimezonesID = @p_Timezone AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.PackageID = a.PackageID AND tzm.RecordingCostPerMinute IS NOT NULL;




truncate table tmp_timezone_minutes_2;
truncate table tmp_timezone_minutes_3;

INSERT INTO tmp_timezone_minutes_2 SELECT * FROM tmp_timezone_minutes;
INSERT INTO tmp_timezone_minutes_3 SELECT * FROM tmp_timezone_minutes;






UPDATE  tmp_timezone_minutes tzm
	INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
SET minute_PackageCostPerMinute = ( @p_Minutes - IFNULL((select tzmd2.minute_PackageCostPerMinute from tmp_timezone_minutes_3 tzmd2 WHERE tzmd2.TimezonesID = @p_Timezone AND tzmd2.VendorConnectionID = a.VendorConnectionID AND tzmd2.PackageID = a.PackageID AND  tzmd2.PackageCostPerMinute IS NOT NULL),0) )
																	/ (  select IF(count(*) = 0 , 1,count(*) )  from tmp_timezone_minutes_2 tzmd WHERE tzmd.TimezonesID != @p_Timezone AND tzmd.VendorConnectionID = a.VendorConnectionID AND tzmd.PackageID = a.PackageID  AND tzmd.PackageCostPerMinute IS NOT NULL)
WHERE  (tzm.TimezonesID != @p_Timezone) AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.PackageID = a.PackageID   AND tzm.PackageCostPerMinute IS NOT NULL;


UPDATE  tmp_timezone_minutes tzm
	INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
SET minute_RecordingCostPerMinute = ( @p_Minutes - IFNULL((select tzmd2.minute_RecordingCostPerMinute from tmp_timezone_minutes_3 tzmd2 WHERE tzmd2.TimezonesID = @p_Timezone AND tzmd2.VendorConnectionID = a.VendorConnectionID AND tzmd2.PackageID = a.PackageID AND  tzmd2.RecordingCostPerMinute IS NOT NULL),0) )
																		/ (  select IF(count(*) = 0 , 1,count(*) )  from tmp_timezone_minutes_2 tzmd WHERE tzmd.TimezonesID != @p_Timezone AND tzmd.VendorConnectionID = a.VendorConnectionID AND tzmd.PackageID = a.PackageID AND tzmd.RecordingCostPerMinute IS NOT NULL )
WHERE  (tzm.TimezonesID != @p_Timezone) AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.PackageID = a.PackageID  AND tzm.RecordingCostPerMinute IS NOT NULL;




UPDATE  tmp_timezone_minutes tzm
	INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
SET minute_PackageCostPerMinute =  @p_Minutes
WHERE  (tzm.TimezonesID = @p_Timezone ) AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.PackageID = a.PackageID   AND tzm.PackageCostPerMinute IS NOT NULL
			 AND (  select count(*) from tmp_timezone_minutes_2 tzmd
WHERE tzmd.TimezonesID != @p_Timezone AND tzmd.VendorConnectionID = a.VendorConnectionID AND tzmd.PackageID = a.PackageID  AND tzmd.PackageCostPerMinute IS NOT NULL) = 0;

UPDATE  tmp_timezone_minutes tzm
	INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
SET minute_RecordingCostPerMinute =  @p_Minutes
WHERE  (tzm.TimezonesID = @p_Timezone ) AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.PackageID = a.PackageID   AND tzm.RecordingCostPerMinute IS NOT NULL
			 AND (  select count(*) from tmp_timezone_minutes_2 tzmd
WHERE tzmd.TimezonesID != @p_Timezone AND tzmd.VendorConnectionID = a.VendorConnectionID AND tzmd.PackageID = a.PackageID  AND tzmd.RecordingCostPerMinute IS NOT NULL) = 0;






ELSE


UPDATE  tmp_timezone_minutes tzm
	INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
SET minute_PackageCostPerMinute =  @p_Minutes /  ( select IF(count(DISTINCT tzmd.TimezonesID) = 0 , 1,count(DISTINCT tzmd.TimezonesID) ) from tmp_timezone_minutes_2 tzmd WHERE tzmd.VendorConnectionID = tzm.VendorConnectionID AND tzmd.PackageID = tzm.PackageID AND tzmd.PackageCostPerMinute IS NOT NULL )

WHERE   tzm.VendorConnectionID = a.VendorConnectionID AND tzm.PackageID = a.PackageID AND tzm.PackageCostPerMinute IS NOT NULL;

UPDATE  tmp_timezone_minutes tzm
	INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
SET minute_RecordingCostPerMinute = @p_Minutes /  (select IF(count(DISTINCT tzmd.TimezonesID) = 0 , 1,count(DISTINCT tzmd.TimezonesID) )from tmp_timezone_minutes_2 tzmd WHERE tzmd.VendorConnectionID = tzm.VendorConnectionID AND tzmd.PackageID = tzm.PackageID AND tzmd.RecordingCostPerMinute IS NOT NULL)

WHERE   tzm.VendorConnectionID = a.VendorConnectionID AND tzm.PackageID = a.PackageID AND tzm.RecordingCostPerMinute IS NOT NULL;



END IF;






END IF;





SET @v_days =    TIMESTAMPDIFF(DAY, (SELECT @v_StartDate_), (SELECT @v_EndDate_)) + 1 ;
SET @v_period1 =      IF(MONTH((SELECT @v_StartDate_)) = MONTH((SELECT @v_EndDate_)), 0, (TIMESTAMPDIFF(DAY, (SELECT @v_StartDate_), LAST_DAY((SELECT @v_StartDate_)) + INTERVAL 1 DAY)) / DAY(LAST_DAY((SELECT @v_StartDate_))));
SET @v_period2 =      TIMESTAMPDIFF(MONTH, LAST_DAY((SELECT @v_StartDate_)) + INTERVAL 1 DAY, LAST_DAY((SELECT @v_EndDate_))) ;
SET @v_period3 =      IF(MONTH((SELECT @v_StartDate_)) = MONTH((SELECT @v_EndDate_)), (SELECT @v_days), DAY((SELECT @v_EndDate_))) / DAY(LAST_DAY((SELECT @v_EndDate_)));
SET @v_months =     (SELECT @v_period1) + (SELECT @v_period2) + (SELECT @v_period3);

SET @v_months = fn_Round(@v_months,1);


insert into tblRateTablePKGRate_step1 (
	RateTableID,
	TimezonesID,
	
	CodeDeckId,
	PackageID,
	Code,
	VendorConnectionID,
	VendorID,
	
	EffectiveDate,
	EndDate,

	OneOffCost,
	MonthlyCost,
	PackageCostPerMinute,
	RecordingCostPerMinute

)
	select
		rt.RateTableID,
		drtr.TimezonesID,
		
		rt.CodeDeckId,
		pk.PackageID,
		r.Code,
		vc.VendorConnectionID,
		a.AccountID as VendorID,
		
		drtr.EffectiveDate,
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
											 * (drtr.OneOffCost  / ( @v_CompanyCurrencyConversionRate ))
										 )
									 END as OneOffCost,

		@MonthlyCost :=
		(
			CASE WHEN ( MonthlyCostCurrency is not null )
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

		@PackageCostPerMinute := CASE WHEN ( PackageCostPerMinuteCurrency IS NOT NULL )
			THEN
				CASE WHEN  @v_CurrencyID_ = PackageCostPerMinuteCurrency THEN
					drtr.PackageCostPerMinute
				ELSE
					(

						(@v_DestinationCurrencyConversionRate )
						* (drtr.PackageCostPerMinute  / (SELECT VALUE FROM tblCurrencyConversion WHERE tblCurrencyConversion.CurrencyId = PackageCostPerMinuteCurrency AND  CompanyID = @v_CompanyId_ ))
					)
				END

														 ELSE
															 (

																 (@v_DestinationCurrencyConversionRate )
																 * (drtr.PackageCostPerMinute  / (@v_CompanyCurrencyConversionRate ))
															 )
														 END  AS PackageCostPerMinute,

		@RecordingCostPerMinute := CASE WHEN ( RecordingCostPerMinuteCurrency IS NOT NULL)
			THEN
				CASE WHEN  @v_CurrencyID_ = RecordingCostPerMinuteCurrency THEN
					drtr.RecordingCostPerMinute
				ELSE
					(

						(@v_DestinationCurrencyConversionRate )
						* (drtr.RecordingCostPerMinute  / (SELECT VALUE FROM tblCurrencyConversion WHERE tblCurrencyConversion.CurrencyId = RecordingCostPerMinuteCurrency AND  CompanyID = @v_CompanyId_ ))
					)
				END
															 ELSE
																 (

																	 (@v_DestinationCurrencyConversionRate )
																	 * (drtr.RecordingCostPerMinute  / (@v_CompanyCurrencyConversionRate ))
																 )
															 END  AS RecordingCostPerMinute

	FROM tblRateTablePKGRate  drtr
		INNER JOIN tblRateTable  rt ON rt.RateTableId = drtr.RateTableId
		INNER JOIN tblVendorConnection vc ON vc.RateTableID = rt.RateTableId  AND vc.CompanyID = rt.CompanyId  AND vc.Active=1 AND vc.RateTypeID = @v_PackageType
		INNER JOIN tblAccount a ON vc.AccountId = a.AccountID AND rt.CompanyId = a.CompanyId and a.IsVendor = 1 and a.Status = 1
		INNER JOIN tblRate r ON drtr.RateID = r.RateID AND r.CompanyID = vc.CompanyID
		INNER JOIN tblPackage pk ON pk.CompanyID = r.CompanyID AND pk.Name = r.Code
		INNER JOIN tblTimezones t ON t.TimezonesID =  drtr.TimezonesID

	WHERE

		rt.CompanyId =  @v_CompanyId_

		AND ( @v_PackageID_ = 0 OR pk.PackageId = @v_PackageID_ )

		AND rt.Type = @v_PackageType

		AND rt.AppliedTo = @v_AppliedToVendor

		and (
			(@p_EffectiveRate = 'now' AND EffectiveDate <= NOW())
			OR
			(@p_EffectiveRate = 'future' AND EffectiveDate > NOW()  )
			OR
			(	 @p_EffectiveRate = 'effective' AND EffectiveDate <= @p_EffectiveDate
					AND ( drtr.EndDate IS NULL OR (drtr.EndDate > DATE(@p_EffectiveDate)) )
			)
		)
		AND ( EndDate IS NULL OR EndDate > NOW() );













insert into tblRateTablePKGRate_step1_dup select * from tblRateTablePKGRate_step1;

update tblRateTablePKGRate_step1 svr
	INNER JOIN (
							 select VendorConnectionID, max(TimezonesID) as TimezonesID, PackageID
							 from tblRateTablePKGRate_step1_dup
							 WHERE OneoffCost > 0
							 GROUP BY VendorConnectionID, PackageID
						 ) svr2 on
											svr.VendorConnectionID = svr2.VendorConnectionID AND
											svr.TimezonesID != svr2.TimezonesID AND
											svr.PackageID = svr2.PackageID
SET svr.OneoffCost = 0
where svr.OneoffCost > 0 and svr2.TimezonesID is not null and svr.TimezonesID is not null;


update tblRateTablePKGRate_step1 svr
	INNER JOIN (
							 select VendorConnectionID, max(TimezonesID) as TimezonesID, PackageID
							 from tblRateTablePKGRate_step1_dup
							 WHERE MonthlyCost > 0
							 GROUP BY VendorConnectionID, PackageID
						 ) svr2 on
											svr.VendorConnectionID = svr2.VendorConnectionID AND
											svr.TimezonesID != svr2.TimezonesID AND
											svr.PackageID = svr2.PackageID
SET svr.MonthlyCost = 0
where svr.MonthlyCost > 0 and svr2.TimezonesID is not null and svr.TimezonesID is not null;





insert into tmp_table_pkg (
	RateTableID,
	TimezonesID,
	
	CodeDeckId,
	PackageID,
	Code,
	VendorConnectionID,
	VendorID,
	
	EffectiveDate,
	EndDate,

	OneOffCost,
	MonthlyCost,
	PackageCostPerMinute,
	RecordingCostPerMinute,

	OneOffCostCurrency,
	MonthlyCostCurrency,
	PackageCostPerMinuteCurrency,
	RecordingCostPerMinuteCurrency,

	Total
)


	select
		drtr.RateTableID,
		drtr.TimezonesID,
		drtr.CodeDeckId,
		drtr.PackageID,
		drtr.Code,
		drtr.VendorConnectionID,
		drtr.VendorID,
		drtr.EffectiveDate,
		drtr.EndDate,

		drtr.OneOffCost,
		drtr.MonthlyCost,
		drtr.PackageCostPerMinute,
		drtr.RecordingCostPerMinute,

		@v_CurrencyID_ as OneOffCostCurrency,
		@v_CurrencyID_ as MonthlyCostCurrency,
		@v_CurrencyID_ as PackageCostPerMinuteCurrency,
		@v_CurrencyID_ as RecordingCostPerMinuteCurrency,

		

		@Total := (
			(	IFNULL(drtr.MonthlyCost,0) * @v_months )				+
			(IFNULL(drtr.PackageCostPerMinute,0) * IFNULL(tm.minute_PackageCostPerMinute,0)	)+
			(IFNULL(drtr.RecordingCostPerMinute,0) * IFNULL(tm.minute_RecordingCostPerMinute,0) )
		)
									 AS Total

	FROM tblRateTablePKGRate_step1  drtr
		
		left join tmp_timezone_minutes tm on tm.TimezonesID = drtr.TimezonesID AND tm.PackageID = drtr.PackageID  AND ( tm.VendorConnectionID IS NULL OR drtr.VendorConnectionID = tm.VendorConnectionID); 



INSERT INTO  tmp_table_output_1
(

	RateTableID,
	TimezonesID,
	
	CodedeckID,
	EffectiveDate,
	EndDate,
	Code,
	PackageID,
	VendorConnectionID,
	VendorID,
	
	OneOffCost,
	MonthlyCost,
	PackageCostPerMinute,
	RecordingCostPerMinute,

	OneOffCostCurrency,
	MonthlyCostCurrency,
	PackageCostPerMinuteCurrency,
	RecordingCostPerMinuteCurrency,

	Total

)

	SELECT
		RateTableID,
		TimezonesID,
		
		CodedeckID,
		EffectiveDate,
		EndDate,
		Code,
		PackageID,
		VendorConnectionID,
		VendorID,
		
		OneOffCost,
		MonthlyCost,
		PackageCostPerMinute,
		RecordingCostPerMinute,

		OneOffCostCurrency,
		MonthlyCostCurrency,
		PackageCostPerMinuteCurrency,
		RecordingCostPerMinuteCurrency,

		Total

	from tmp_table_pkg

	WHERE Total IS NOT NULL;







SET @v_rowCount_  = ( select count(*) from tmp_RateGeneratorVendors_ );

IF @v_rowCount_ > 0 THEN

SET @v_pointer_ = 1;

INSERT INTO tmp_accounts2 ( VendorID , PackageID )
	SELECT DISTINCT VendorID , PackageID FROM tmp_table_output_1 GROUP BY VendorID , PackageID;


INSERT INTO tmp_accounts2_dup
	SELECT * FROM tmp_accounts2;



INSERT INTO tmp_accounts2 ( VendorID , PackageID )
	select
		v.VendorID,
		v.PackageID
	from (
				 select
					 PackageID,
					 a.AccountID as VendorID
				 FROM tmp_RateGeneratorVendors_ rgv
					 INNER JOIN tblAccount a ON (fn_IsEmpty(rgv.Vendors) OR FIND_IN_SET(a.AccountID,rgv.Vendors) != 0 ) AND a.IsVendor = 1 AND a.Status = 1
				 where rgv.PackageID is not null
			 ) v
		LEFT JOIN tmp_accounts2_dup a  on v.VendorID = a.VendorID AND v.PackageID = a.PackageID
	where a.ID is   null;




WHILE @v_pointer_ <= @v_rowCount_
DO

SET @v_RateGeneratorVendorsID = ( SELECT RateGeneratorVendorsID FROM tmp_RateGeneratorVendors_  WHERE RateGeneratorVendorsID = @v_pointer_);


truncate table tmp_SelectVendorsWithPackage_dup;
insert into tmp_SelectVendorsWithPackage_dup
	select * from tmp_SelectVendorsWithPackage_;

truncate table tmp_SelectVendorsWithPackage_;
INSERT INTO tmp_SelectVendorsWithPackage_ ( VendorID , PackageID , IsSelected )
	select	a.VendorID, a.PackageID  , 1 AS  IsSelected
	FROM tmp_accounts2 a
		INNER JOIN tmp_RateGeneratorVendors_  v on v.RateGeneratorVendorsID = @v_RateGeneratorVendorsID AND ( fn_IsEmpty(v.Vendors)  OR FIND_IN_SET(a.VendorID,v.Vendors) != 0   )  AND ( fn_IsEmpty(v.PackageID) OR a.PackageID = v.PackageID )
		LEFT JOIN tmp_SelectVendorsWithPackage_dup  vd on   a.PackageID = vd.PackageID
	WHERE vd.SelectVendorsWithPackageID IS NULL
	ORDER BY a.PackageID,a.VendorID;


truncate table tmp_table_output_2;
INSERT INTO tmp_table_output_2
(

	RateTableID,
	TimezonesID,
	
	CodedeckID,
	EffectiveDate,
	EndDate,
	Code,
	PackageID,
	VendorConnectionID,
	VendorID,
	
	OneOffCost,
	MonthlyCost,
	PackageCostPerMinute,
	RecordingCostPerMinute,

	OneOffCostCurrency,
	MonthlyCostCurrency,
	PackageCostPerMinuteCurrency,
	RecordingCostPerMinuteCurrency,

	Total,
	vPosition

)

	SELECT
		DISTINCT
		RateTableID,
		TimezonesID,
		
		CodedeckID,
		EffectiveDate,
		EndDate,
		Code,
		PackageID,
		VendorConnectionID,
		VendorID,
		
		OneOffCost,
		MonthlyCost,
		PackageCostPerMinute,
		RecordingCostPerMinute,

		OneOffCostCurrency,
		MonthlyCostCurrency,
		PackageCostPerMinuteCurrency,
		RecordingCostPerMinuteCurrency,
		Total,
		vPosition

	from
		(
			select
				drtr.RateTableID,
				drtr.TimezonesID,
				
				drtr.CodedeckID,
				drtr.EffectiveDate,
				drtr.EndDate,
				drtr.Code,
				drtr.PackageID,
				drtr.VendorConnectionID,
				drtr.VendorID,
				
				drtr.OneOffCost,
				drtr.MonthlyCost,
				drtr.PackageCostPerMinute,
				drtr.RecordingCostPerMinute,

				drtr.OneOffCostCurrency,
				drtr.MonthlyCostCurrency,
				drtr.PackageCostPerMinuteCurrency,
				drtr.RecordingCostPerMinuteCurrency,
				drtr.Total,
				@vPosition := ( CASE WHEN (@prev_TimezonesID = drtr.TimezonesID AND @prev_PackageID = drtr.PackageID  AND @prev_Total <  drtr.Total AND  ( @v_percentageRate_ = 0 OR  (@prev_Total > 0 and  fn_Round( (((drtr.Total - @prev_Total) /  @prev_Total) * 100), 2 ) > @v_percentageRate_) )) THEN @vPosition + 1
												WHEN (@prev_TimezonesID = drtr.TimezonesID AND @prev_PackageID = drtr.PackageID  AND @prev_Total <  drtr.Total AND  ( @v_percentageRate_ = 0 OR  (@prev_Total > 0 and  fn_Round( (((drtr.Total - @prev_Total) /  @prev_Total) * 100), 2 ) <= @v_percentageRate_) )) THEN -1
												WHEN (@prev_TimezonesID = drtr.TimezonesID AND @prev_PackageID = drtr.PackageID  AND @prev_Total =  drtr.Total AND  ( @v_percentageRate_ = 0 OR  (@prev_Total > 0 and  fn_Round( (((drtr.Total - @prev_Total) /  @prev_Total) * 100), 2 ) > @v_percentageRate_) )) THEN @vPosition
												WHEN (@prev_TimezonesID = drtr.TimezonesID AND @prev_PackageID = drtr.PackageID  AND @prev_Total =  drtr.Total AND  ( @v_percentageRate_ = 0 OR  (@prev_Total > 0 and  fn_Round( (((drtr.Total - @prev_Total) /  @prev_Total) * 100), 2 ) <= @v_percentageRate_) )) THEN -1

												ELSE
													1
												END) as  vPosition,

				@prev_TimezonesID  := drtr.TimezonesID,
				@prev_PackageID 	 := drtr.PackageID ,
				@prev_Total 			 := drtr.Total

			from tmp_table_output_1 drtr
				inner join tmp_SelectVendorsWithPackage_ sv on drtr.VendorID = sv.VendorID AND drtr.PackageID = sv.PackageID AND sv.IsSelected = 1
				,(SELECT  @vPosition := 0 , @prev_TimezonesID := '' , @prev_PackageID := '' , @prev_Total := 0 ) t
			order by drtr.PackageID ,drtr.TimezonesID,drtr.Total


		) tmp
	where vPosition  <= @v_RatePosition_ AND vPosition != -1;

INSERT INTO tmp_table_output_3
(

	RateTableID,
	TimezonesID,
	
	CodedeckID,
	EffectiveDate,
	EndDate,
	Code,
	PackageID,
	VendorConnectionID,
	VendorID,
	
	OneOffCost,
	MonthlyCost,
	PackageCostPerMinute,
	RecordingCostPerMinute,

	OneOffCostCurrency,
	MonthlyCostCurrency,
	PackageCostPerMinuteCurrency,
	RecordingCostPerMinuteCurrency
	
)

	SELECT
		DISTINCT
		RateTableID,
		TimezonesID,
		
		CodedeckID,
		EffectiveDate,
		EndDate,
		Code,
		PackageID,
		VendorConnectionID,
		VendorID,
		
		IFNULL(OneOffCost,0),
		IFNULL(MonthlyCost,0),
		IFNULL(PackageCostPerMinute,0),
		IFNULL(RecordingCostPerMinute,0),

		OneOffCostCurrency,
		MonthlyCostCurrency,
		PackageCostPerMinuteCurrency,
		RecordingCostPerMinuteCurrency
	

	from
		(
			select
				RateTableID,
				TimezonesID,
				
				CodedeckID,
				EffectiveDate,
				EndDate,
				Code,
				PackageID,
				VendorConnectionID,
				VendorID,
				

				OneOffCost,
				MonthlyCost,
				PackageCostPerMinute,
				RecordingCostPerMinute,

				OneOffCostCurrency,
				MonthlyCostCurrency,
				PackageCostPerMinuteCurrency,
				RecordingCostPerMinuteCurrency,
				Total,
				@vPosition := (
					CASE WHEN (@prev_TimezonesID = TimezonesID AND @prev_PackageID = PackageID  AND @prev_Total >=  Total )  THEN @vPosition + 1

					ELSE
						1
					END
				) as  vPosition,
				@prev_TimezonesID  := TimezonesID,
				@prev_PackageID := PackageID ,
				@prev_Total := Total

			from tmp_table_output_2
				,(SELECT  @vPosition := 0 , @prev_TimezonesID := '' , @prev_PackageID := '' , @prev_Total := 0 ) t
			order by PackageID ,TimezonesID,Total desc


		) tmp
	where vPosition  = 1 ;



SET @v_pointer_ = @v_pointer_ + 1;

END WHILE;



INSERT INTO tmp_SelectedVendortblRateTableRatePackage
(

	RateTableID,
	TimezonesID,
	
	CodedeckID,
	EffectiveDate,
	EndDate,
	Code,
	PackageID,
	VendorConnectionID,
	VendorID,
	
	OneOffCost,
	MonthlyCost,
	PackageCostPerMinute,
	RecordingCostPerMinute,

	OneOffCostCurrency,
	MonthlyCostCurrency,
	PackageCostPerMinuteCurrency,
	RecordingCostPerMinuteCurrency
	
)

	SELECT
		DISTINCT
		drtr.RateTableID,
		drtr.TimezonesID,

		drtr.CodedeckID,
		drtr.EffectiveDate,
		drtr.EndDate,
		drtr.Code,
		drtr.PackageID,
		drtr.VendorConnectionID,
		drtr.VendorID,

		drtr.OneOffCost,
		drtr.MonthlyCost,
		drtr.PackageCostPerMinute,
		drtr.RecordingCostPerMinute,
		drtr.OneOffCostCurrency,
		drtr.MonthlyCostCurrency,
		drtr.PackageCostPerMinuteCurrency,
		drtr.RecordingCostPerMinuteCurrency

	FROM tmp_table_output_3 drtr;




ELSE


INSERT INTO tmp_table_output_2
(

	RateTableID,
	TimezonesID,
	
	CodedeckID,
	EffectiveDate,
	EndDate,
	Code,
	PackageID,
	VendorConnectionID,
	VendorID,
	
	OneOffCost,
	MonthlyCost,
	PackageCostPerMinute,
	RecordingCostPerMinute,

	OneOffCostCurrency,
	MonthlyCostCurrency,
	PackageCostPerMinuteCurrency,
	RecordingCostPerMinuteCurrency,

	Total,
	vPosition

)

	SELECT

		DISTINCT

		RateTableID,
		TimezonesID,
		
		CodedeckID,
		EffectiveDate,
		EndDate,
		Code,
		PackageID,
		VendorConnectionID,
		VendorID,
		
		OneOffCost,
		MonthlyCost,
		PackageCostPerMinute,
		RecordingCostPerMinute,

		OneOffCostCurrency,
		MonthlyCostCurrency,
		PackageCostPerMinuteCurrency,
		RecordingCostPerMinuteCurrency,
		Total,
		vPosition

	from
		(
			select
				drtr.RateTableID,
				drtr.TimezonesID,
				
				drtr.CodedeckID,
				drtr.EffectiveDate,
				drtr.EndDate,
				drtr.Code,
				drtr.PackageID,
				drtr.VendorConnectionID,
				drtr.VendorID,
				
				drtr.OneOffCost,
				drtr.MonthlyCost,
				drtr.PackageCostPerMinute,
				drtr.RecordingCostPerMinute,

				drtr.OneOffCostCurrency,
				drtr.MonthlyCostCurrency,
				drtr.PackageCostPerMinuteCurrency,
				drtr.RecordingCostPerMinuteCurrency,
				drtr.Total,
				@vPosition := ( CASE WHEN (@prev_TimezonesID = drtr.TimezonesID AND @prev_PackageID = drtr.PackageID  AND @prev_Total <  drtr.Total AND  ( @v_percentageRate_ = 0 OR  (@prev_Total > 0 and  fn_Round( (((drtr.Total - @prev_Total) /  @prev_Total) * 100), 2 ) > @v_percentageRate_) )) THEN @vPosition + 1
												WHEN (@prev_TimezonesID = drtr.TimezonesID AND @prev_PackageID = drtr.PackageID  AND @prev_Total <  drtr.Total AND  ( @v_percentageRate_ = 0 OR  (@prev_Total > 0 and  fn_Round( (((drtr.Total - @prev_Total) /  @prev_Total) * 100), 2 ) <= @v_percentageRate_) )) THEN -1
												WHEN (@prev_TimezonesID = drtr.TimezonesID AND @prev_PackageID = drtr.PackageID  AND @prev_Total =  drtr.Total AND  ( @v_percentageRate_ = 0 OR  (@prev_Total > 0 and  fn_Round( (((drtr.Total - @prev_Total) /  @prev_Total) * 100), 2 ) > @v_percentageRate_) )) THEN @vPosition
												WHEN (@prev_TimezonesID = drtr.TimezonesID AND @prev_PackageID = drtr.PackageID  AND @prev_Total =  drtr.Total AND  ( @v_percentageRate_ = 0 OR  (@prev_Total > 0 and  fn_Round( (((drtr.Total - @prev_Total) /  @prev_Total) * 100), 2 ) <= @v_percentageRate_) )) THEN -1

												ELSE
													1
												END) as  vPosition,

				@prev_TimezonesID  := drtr.TimezonesID,
				@prev_PackageID 	 := drtr.PackageID ,
				@prev_Total 			 := drtr.Total

			from tmp_table_output_1 drtr
				
				,(SELECT  @vPosition := 0 , @prev_TimezonesID := '' , @prev_PackageID := '' , @prev_Total := 0 ) t
			order by drtr.PackageID ,drtr.TimezonesID,drtr.Total


		) tmp
	where vPosition  <= @v_RatePosition_ AND vPosition != -1;

INSERT INTO tmp_table_output_3
(

	RateTableID,
	TimezonesID,
	
	CodedeckID,
	EffectiveDate,
	EndDate,
	Code,
	PackageID,
	VendorConnectionID,
	VendorID,
	
	OneOffCost,
	MonthlyCost,
	PackageCostPerMinute,
	RecordingCostPerMinute,

	OneOffCostCurrency,
	MonthlyCostCurrency,
	PackageCostPerMinuteCurrency,
	RecordingCostPerMinuteCurrency
	
)

	SELECT

		DISTINCT

		RateTableID,
		TimezonesID,
		
		CodedeckID,
		EffectiveDate,
		EndDate,
		Code,
		PackageID,
		VendorConnectionID,
		VendorID,
		
		IFNULL(OneOffCost,0),
		IFNULL(MonthlyCost,0),
		IFNULL(PackageCostPerMinute,0),
		IFNULL(RecordingCostPerMinute,0),

		OneOffCostCurrency,
		MonthlyCostCurrency,
		PackageCostPerMinuteCurrency,
		RecordingCostPerMinuteCurrency
	

	from
		(
			select

				RateTableID,
				TimezonesID,
				
				CodedeckID,
				EffectiveDate,
				EndDate,
				Code,
				PackageID,
				VendorConnectionID,
				VendorID,
				

				OneOffCost,
				MonthlyCost,
				PackageCostPerMinute,
				RecordingCostPerMinute,

				OneOffCostCurrency,
				MonthlyCostCurrency,
				PackageCostPerMinuteCurrency,
				RecordingCostPerMinuteCurrency,
				Total,
				@vPosition := (
					CASE WHEN (@prev_TimezonesID = TimezonesID AND @prev_PackageID = PackageID  AND @prev_Total >=  Total )  THEN @vPosition + 1

					ELSE
						1
					END
				) as  vPosition,
				@prev_TimezonesID  := TimezonesID,
				@prev_PackageID := PackageID ,
				@prev_Total := Total

			from tmp_table_output_2
				,(SELECT  @vPosition := 0 , @prev_TimezonesID := '' , @prev_PackageID := '' , @prev_Total := 0 ) t
			order by PackageID ,TimezonesID,Total desc


		) tmp
	where vPosition  = 1 ;


INSERT INTO tmp_SelectedVendortblRateTableRatePackage
(

	RateTableID,
	TimezonesID,
	
	CodedeckID,
	EffectiveDate,
	EndDate,
	Code,
	PackageID,
	VendorConnectionID,
	VendorID,
	
	OneOffCost,
	MonthlyCost,
	PackageCostPerMinute,
	RecordingCostPerMinute,

	OneOffCostCurrency,
	MonthlyCostCurrency,
	PackageCostPerMinuteCurrency,
	RecordingCostPerMinuteCurrency
	
)
	SELECT
		distinct
		drtr.RateTableID,
		drtr.TimezonesID,

		drtr.CodedeckID,
		drtr.EffectiveDate,
		drtr.EndDate,
		drtr.Code,
		drtr.PackageID,
		drtr.VendorConnectionID,
		drtr.VendorID,

		drtr.OneOffCost,
		drtr.MonthlyCost,
		drtr.PackageCostPerMinute,
		drtr.RecordingCostPerMinute,
		drtr.OneOffCostCurrency,
		drtr.MonthlyCostCurrency,
		drtr.PackageCostPerMinuteCurrency,
		drtr.RecordingCostPerMinuteCurrency

	FROM tmp_table_output_3 drtr;



END IF;







DROP TEMPORARY TABLE IF EXISTS tmp_MergeComponents;
CREATE TEMPORARY TABLE tmp_MergeComponents(
	ID int auto_increment,
	PackageID int(11)   ,
	Component TEXT  ,
	TimezonesID INT(11)   ,
	Action CHAR(4)    ,
	MergeTo TEXT  ,
	ToTimezonesID INT(11)   ,
	primary key (ID)
);

insert into tmp_MergeComponents (
	PackageID ,
	Component   ,
	TimezonesID,
	Action ,
	MergeTo  ,
	ToTimezonesID

)
	select
		IFNULL(PackageID,0) ,
		Component   ,
		IFNULL(TimezonesID,0),
		Action ,
		MergeTo  ,
		IFNULL(ToTimezonesID,0)


	from tblRateGeneratorCostComponent
	where RateGeneratorId = @p_RateGeneratorId
	order by CostComponentID asc;







SET @v_pointer_ = 1;
SET @v_rowCount_ = ( SELECT COUNT(*) FROM tmp_Raterules_ );

WHILE @v_pointer_ <= @v_rowCount_
DO

SET @v_rateRuleId_ = (SELECT rateruleid FROM tmp_Raterules_ rr WHERE rr.RowNo = @v_pointer_);


update tmp_SelectedVendortblRateTableRatePackage rt
	inner join tmp_Raterules_ rr on rr.RowNo  = @v_pointer_
																	and  (  fn_IsEmpty(rr.TimezonesID) OR rr.TimezonesID  = rt.TimezonesID )
																	and ( fn_IsEmpty(rr.PackageID) OR rr.PackageID = rt.PackageID )

	LEFT join tblRateRuleMargin rule_mgn1 on  rule_mgn1.RateRuleId = @v_rateRuleId_
																						AND
																						(
																							(rr.Component = 'OneOffCost' AND ( (rule_mgn1.MinRate is null AND  rule_mgn1.MaxRate is null ) OR (  OneOffCost Between rule_mgn1.MinRate and rule_mgn1.MaxRate ) )  ) OR
																							(rr.Component = 'MonthlyCost' AND ( (rule_mgn1.MinRate is null AND  rule_mgn1.MaxRate is null ) OR (  MonthlyCost Between rule_mgn1.MinRate and rule_mgn1.MaxRate ) )  ) OR
																							(rr.Component = 'PackageCostPerMinute' AND ( (rule_mgn1.MinRate is null AND  rule_mgn1.MaxRate is null ) OR (  PackageCostPerMinute Between rule_mgn1.MinRate and rule_mgn1.MaxRate ) )  ) OR
																							(rr.Component = 'RecordingCostPerMinute' AND ( (rule_mgn1.MinRate is null AND  rule_mgn1.MaxRate is null ) OR (  RecordingCostPerMinute Between rule_mgn1.MinRate and rule_mgn1.MaxRate ) )  )
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

	PackageCostPerMinute = CASE WHEN rr.Component = 'PackageCostPerMinute' AND rule_mgn1.RateRuleId is not null THEN
		CASE WHEN trim(IFNULL(rule_mgn1.AddMargin,"")) != '' THEN
			PackageCostPerMinute + (CASE WHEN rule_mgn1.addmargin LIKE '%p' THEN ((CAST(REPLACE(rule_mgn1.addmargin, 'p', '') AS DECIMAL(18, 2)) / 100) * PackageCostPerMinute) ELSE rule_mgn1.addmargin END)
		WHEN trim(IFNULL(rule_mgn1.FixedValue,"")) != '' THEN
			rule_mgn1.FixedValue
		ELSE
			PackageCostPerMinute
		END
												 ELSE
													 PackageCostPerMinute
												 END,

	RecordingCostPerMinute = CASE WHEN rr.Component = 'RecordingCostPerMinute' AND rule_mgn1.RateRuleId is not null THEN
		CASE WHEN trim(IFNULL(rule_mgn1.AddMargin,"")) != '' THEN
			RecordingCostPerMinute + (CASE WHEN rule_mgn1.addmargin LIKE '%p' THEN ((CAST(REPLACE(rule_mgn1.addmargin, 'p', '') AS DECIMAL(18, 2)) / 100) * RecordingCostPerMinute) ELSE rule_mgn1.addmargin END)
		WHEN trim(IFNULL(rule_mgn1.FixedValue,"")) != '' THEN
			rule_mgn1.FixedValue
		ELSE
			RecordingCostPerMinute
		END
													 ELSE
														 RecordingCostPerMinute
													 END
;




SET @v_pointer_ = @v_pointer_ + 1;

END WHILE;












SET @v_pointer_ = 1;
SET @v_rowCount_ = ( SELECT COUNT(*) FROM tmp_RateGeneratorCalculatedRate_ );

WHILE @v_pointer_ <= @v_rowCount_
DO

update tmp_SelectedVendortblRateTableRatePackage rt
	inner join tmp_RateGeneratorCalculatedRate_ rr on
																									 rr.RowNo  = @v_pointer_
																									 AND (fn_IsEmpty(rr.TimezonesID)  OR rr.TimezonesID  = rt.TimezonesID )
																									 and ( fn_IsEmpty(rr.PackageID) OR rr.PackageID = rt.PackageID )



SET
	OneOffCost = CASE WHEN FIND_IN_SET('OneOffCost',rr.Component) != 0 AND OneOffCost < RateLessThen AND rr.CalculatedRateID is not null THEN
		ChangeRateTo
							 ELSE
								 OneOffCost
							 END,
	MonthlyCost = CASE WHEN FIND_IN_SET('MonthlyCost',rr.Component) != 0 AND MonthlyCost < RateLessThen AND rr.CalculatedRateID is not null THEN
		ChangeRateTo
								ELSE
									MonthlyCost
								END,
	PackageCostPerMinute = CASE WHEN FIND_IN_SET('PackageCostPerMinute',rr.Component) != 0 AND PackageCostPerMinute < RateLessThen AND rr.CalculatedRateID is not null THEN
		ChangeRateTo
												 ELSE
													 PackageCostPerMinute
												 END,
	RecordingCostPerMinute = CASE WHEN FIND_IN_SET('RecordingCostPerMinute',rr.Component) != 0 AND RecordingCostPerMinute < RateLessThen AND rr.CalculatedRateID is not null THEN
		ChangeRateTo
													 ELSE
														 RecordingCostPerMinute
													 END
;


SET @v_pointer_ = @v_pointer_ + 1;

END WHILE;










insert into tmp_SelectedVendortblRateTableRatePackage_dup
	select * from tmp_SelectedVendortblRateTableRatePackage;


SET @v_pointer_ = 1;
SET @v_rowCount_ = ( SELECT COUNT(*) FROM tmp_MergeComponents );

WHILE @v_pointer_ <= @v_rowCount_
DO

SELECT
	PackageID ,
	Component   ,
	TimezonesID,
	Action ,
	MergeTo  ,
	ToTimezonesID

INTO

	@v_PackageID,
	@v_Component,
	@v_TimezonesID,
	@v_Action,
	@v_MergeTo,
	@v_ToTimezonesID

FROM tmp_MergeComponents WHERE ID = @v_pointer_;

IF @v_Action = 'sum' THEN

SET @ResultField = concat('(' ,  REPLACE(@v_Component,',',' + ') , ') ');

ELSE

SET @ResultField = concat('GREATEST(' ,  @v_Component, ') ');

END IF;

SET @stm1 = CONCAT('
						update tmp_SelectedVendortblRateTableRatePackage srt
						inner join (

								select

									TimezonesID,
									Code,
 									', @ResultField , ' as componentValue

									from tmp_SelectedVendortblRateTableRatePackage_dup

								where
								--	VendorID = @v_SelectedVendor

								 (  fn_IsEmpty(@v_TimezonesID) OR  TimezonesID = @v_TimezonesID )
								AND (  fn_IsEmpty(@v_PackageID) OR  PackageID = @v_PackageID )

						) tmp on
								tmp.Code = srt.Code
								AND (  fn_IsEmpty(@v_PackageID) OR  PackageID = @v_PackageID)
								AND (  fn_IsEmpty(@v_ToTimezonesID) OR  srt.TimezonesID = @v_ToTimezonesID)
						set

						' , 'new_', @v_MergeTo , ' = tmp.componentValue;
				');
PREPARE stm1 FROM @stm1;
EXECUTE stm1;

IF ROW_COUNT()  = 0 THEN

insert into tmp_SelectedVendortblRateTableRatePackage
(

RateTableID,
TimezonesID,

CodeDeckId,
PackageID,
Code,
VendorConnectionID,
VendorID,
EffectiveDate,
EndDate,

OneOffCost,
MonthlyCost,
PackageCostPerMinute,
RecordingCostPerMinute,

OneOffCostCurrency,
MonthlyCostCurrency,
PackageCostPerMinuteCurrency,
RecordingCostPerMinuteCurrency


)
select
	RateTableID,
	IF( fn_IsEmpty(@v_ToTimezonesID),TimezonesID,@v_ToTimezonesID ) as TimezonesID,
	
	CodeDeckId,
	PackageID,
	Code,
	VendorConnectionID,
	VendorID,
	EffectiveDate,
	EndDate,

	OneOffCost,
	MonthlyCost,
	PackageCostPerMinute,
	RecordingCostPerMinute,

	OneOffCostCurrency,
	MonthlyCostCurrency,
	PackageCostPerMinuteCurrency,
	RecordingCostPerMinuteCurrency


from tmp_table_output_1

where
	
	(  fn_IsEmpty(@v_TimezonesID) OR  TimezonesID = @v_TimezonesID)
	AND (  fn_IsEmpty(@v_PackageID) OR  PackageID = @v_PackageID);

END IF;

DEALLOCATE PREPARE stm1;



SET @v_pointer_ = @v_pointer_ + 1;

END WHILE;


update tmp_SelectedVendortblRateTableRatePackage
SET
	OneOffCost  = CASE WHEN new_OneOffCost is null THEN OneOffCost ELSE new_OneOffCost END ,
	MonthlyCost  = CASE WHEN new_MonthlyCost is null THEN MonthlyCost ELSE new_MonthlyCost END ,
	PackageCostPerMinute  = CASE WHEN new_PackageCostPerMinute is null THEN PackageCostPerMinute ELSE new_PackageCostPerMinute END ,
	RecordingCostPerMinute  = CASE WHEN new_RecordingCostPerMinute is null THEN RecordingCostPerMinute ELSE new_RecordingCostPerMinute END;















TRUNCATE TABLE tblRateTablePKGRate_step1_dup;
insert into tblRateTablePKGRate_step1_dup (VendorConnectionID, PackageID, TimezonesID, OneoffCost, MonthlyCost)
	select VendorConnectionID, PackageID, TimezonesID, OneoffCost, MonthlyCost
	from tmp_SelectedVendortblRateTableRatePackage;

update tmp_SelectedVendortblRateTableRatePackage svr
	INNER JOIN (
							 select VendorConnectionID, max(TimezonesID) as TimezonesID, PackageID , max(OneoffCost) as OneoffCost
							 from tblRateTablePKGRate_step1_dup
							 WHERE OneoffCost > 0
							 GROUP BY VendorConnectionID, PackageID
						 ) svr2 on
											svr.VendorConnectionID = svr2.VendorConnectionID AND
											svr.TimezonesID != svr2.TimezonesID AND
											svr.PackageID = svr2.PackageID
SET svr.OneoffCost = svr2.OneoffCost;


update tmp_SelectedVendortblRateTableRatePackage svr
	INNER JOIN (
							 select VendorConnectionID, max(TimezonesID) as TimezonesID, PackageID , max(MonthlyCost) as MonthlyCost
							 from tblRateTablePKGRate_step1_dup
							 WHERE MonthlyCost > 0
							 GROUP BY VendorConnectionID, PackageID
						 ) svr2 on
											svr.VendorConnectionID = svr2.VendorConnectionID AND
											svr.TimezonesID != svr2.TimezonesID AND
											svr.PackageID = svr2.PackageID
SET svr.MonthlyCost = svr2.MonthlyCost;









SET @v_SelectedRateTableID = ( select RateTableID from tmp_SelectedVendortblRateTableRatePackage limit 1 );

SET @v_AffectedRecords_ = 0;




START TRANSACTION;

SET @v_RATE_STATUS_AWAITING  = 0;
SET @v_RATE_STATUS_APPROVED  = 1;
SET @v_RATE_STATUS_REJECTED  = 2;
SET @v_RATE_STATUS_DELETE    = 3;

IF @p_RateTableId = -1
THEN



INSERT INTO tblRateTable (Type, CompanyId, RateTableName, RateGeneratorID, TrunkID, CodeDeckId,CurrencyID,Status, RoundChargedAmount,MinimumCallCharge,AppliedTo,Reseller,created_at,updated_at, CreatedBy,ModifiedBy)
select  @v_PackageType as Type, @v_CompanyId_, @p_rateTableName , @p_RateGeneratorId, 0 as TrunkID,   CodeDeckId , @v_CurrencyID_ as CurrencyID, Status, @v_RoundChargedAmount,MinimumCallCharge, @p_AppliedTo as AppliedTo, @p_Reseller as Reseller , now() ,now() ,@p_ModifiedBy,@p_ModifiedBy
from tblRateTable where RateTableID = @v_SelectedRateTableID  limit 1;


SET @p_RateTableId = LAST_INSERT_ID();



ELSE

SET @p_RateTableId = @p_RateTableId;

IF @p_delete_exiting_rate = 1
THEN


IF (@v_RateApprovalProcess_ = 1 ) THEN

UPDATE
	tblRateTablePKGRateAA
SET
	EndDate = NOW()
WHERE
	RateTableId = @p_RateTableId;

call prc_ArchiveOldRateTablePKGRateAA(@p_RateTableId, NULL,@p_ModifiedBy);

ELSE


UPDATE
	tblRateTablePKGRate
SET
	EndDate = NOW()
WHERE
	RateTableId = @p_RateTableId;


call prc_ArchiveOldRateTablePKGRate(@p_RateTableId, NULL,@p_ModifiedBy);
END IF;

END IF;



IF (@v_RateApprovalProcess_ = 1 ) THEN

update tblRateTablePKGRateAA rtd
	INNER JOIN tblRateTable rt  on rt.RateTableID = rtd.RateTableID
	INNER JOIN tblRate r
		ON rtd.RateID  = r.RateID
	inner join tmp_SelectedVendortblRateTableRatePackage drtr on
																															drtr.Code = r.Code
																															and rtd.TimezonesID = drtr.TimezonesID
																															AND  r.CodeDeckId = drtr.CodeDeckId

SET rtd.EndDate = NOW()

where
	rtd.RateTableID = @p_RateTableId and rtd.EffectiveDate = @p_EffectiveDate;

call prc_ArchiveOldRateTablePKGRateAA(@p_RateTableId, NULL,@p_ModifiedBy);


ELSE



update tblRateTablePKGRate rtd
	INNER JOIN tblRateTable rt  on rt.RateTableID = rtd.RateTableID
	INNER JOIN tblRate r
		ON rtd.RateID  = r.RateID
	inner join tmp_SelectedVendortblRateTableRatePackage drtr on
																															drtr.Code = r.Code
																															and rtd.TimezonesID = drtr.TimezonesID
																															AND  r.CodeDeckId = drtr.CodeDeckId

SET rtd.EndDate = NOW()

where
	rtd.RateTableID = @p_RateTableId and rtd.EffectiveDate = @p_EffectiveDate;

call prc_ArchiveOldRateTablePKGRate(@p_RateTableId, NULL,@p_ModifiedBy);


END IF;

SET @v_AffectedRecords_ = @v_AffectedRecords_ + FOUND_ROWS();


END IF; 


IF (@v_RateApprovalProcess_ = 1 ) THEN





INSERT INTO tblRateTablePKGRateAA (
RateTableId,
TimezonesID,
RateId,
OneOffCost,
MonthlyCost,
PackageCostPerMinute,
RecordingCostPerMinute,

OneOffCostCurrency,
MonthlyCostCurrency,
PackageCostPerMinuteCurrency,
RecordingCostPerMinuteCurrency,

EffectiveDate,
EndDate,
ApprovedStatus,
ApprovedDate,
created_at ,
updated_at ,
CreatedBy ,
ModifiedBy,
VendorID



)
SELECT DISTINCT

	@p_RateTableId as RateTableId,
	drtr.TimezonesID,
	r.RateId,

	drtr.OneOffCost,
	drtr.MonthlyCost,
	drtr.PackageCostPerMinute,
	drtr.RecordingCostPerMinute,


	drtr.OneOffCostCurrency,
	drtr.MonthlyCostCurrency,
	drtr.PackageCostPerMinuteCurrency,
	drtr.RecordingCostPerMinuteCurrency,

	@p_EffectiveDate as EffectiveDate,
	drtr.EndDate,
	@v_RateApprovalStatus_ as ApprovedStatus,
	now() as ApprovedDate,
	now() as  created_at ,
	now() as updated_at ,
	@p_ModifiedBy as CreatedBy ,
	@p_ModifiedBy as ModifiedBy,
	drtr.VendorID



from tmp_SelectedVendortblRateTableRatePackage drtr
	inner join tblRateTable  rt on rt.RateTableId = drtr.RateTableId
	INNER JOIN tblRate r ON drtr.Code = r.Code and r.CodeDeckId = drtr.CodeDeckId
	LEFT join tblRateTablePKGRateAA rtd  on rtd.RateID  = r.RateID
																					and  rtd.TimezonesID = drtr.TimezonesID
																					and rtd.RateTableID = @p_RateTableId
																					and rtd.EffectiveDate = @p_EffectiveDate
WHERE rtd.RateTablePKGRateID is null;

ELSE


INSERT INTO tblRateTablePKGRate (
	RateTableId,
	TimezonesID,
	RateId,
	OneOffCost,
	MonthlyCost,
	PackageCostPerMinute,
	RecordingCostPerMinute,

	OneOffCostCurrency,
	MonthlyCostCurrency,
	PackageCostPerMinuteCurrency,
	RecordingCostPerMinuteCurrency,

	EffectiveDate,
	EndDate,
	ApprovedStatus,
	ApprovedDate,
	created_at ,
	updated_at ,
	CreatedBy ,
	ModifiedBy,
	VendorID



)
	SELECT DISTINCT

		@p_RateTableId as RateTableId,
		drtr.TimezonesID,
		r.RateId,

		drtr.OneOffCost,
		drtr.MonthlyCost,
		drtr.PackageCostPerMinute,
		drtr.RecordingCostPerMinute,

		drtr.OneOffCostCurrency,
		drtr.MonthlyCostCurrency,
		drtr.PackageCostPerMinuteCurrency,
		drtr.RecordingCostPerMinuteCurrency,

		@p_EffectiveDate as EffectiveDate,
		drtr.EndDate,
		@v_RateApprovalStatus_ as ApprovedStatus,
		now() as ApprovedDate,
		now() as  created_at ,
		now() as updated_at ,
		@p_ModifiedBy as CreatedBy ,
		@p_ModifiedBy as ModifiedBy,
		drtr.VendorID



	from tmp_SelectedVendortblRateTableRatePackage drtr
		inner join tblRateTable  rt on rt.RateTableId = drtr.RateTableId
		INNER JOIN tblRate r ON drtr.Code = r.Code and r.CodeDeckId = drtr.CodeDeckId
		LEFT join tblRateTablePKGRate rtd  on rtd.RateID  = r.RateID
																					and  rtd.TimezonesID = drtr.TimezonesID and rtd.City = drtr.City and rtd.Tariff = drtr.Tariff
																					and rtd.RateTableID = @p_RateTableId
																					and rtd.EffectiveDate = @p_EffectiveDate
	WHERE rtd.RateTablePKGRateID is null;

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
			from 	tblRateTablePKGRate
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


UPDATE  tblRateTablePKGRateAA vr1
	inner join
	(
		select
			RateTableId,
			RateID,
			EffectiveDate,
			TimezonesID
		FROM tblRateTablePKGRateAA
		WHERE RateTableId = @p_RateTableId
					AND EffectiveDate =   @EffectiveDate
		order by EffectiveDate desc
	) tmpvr
		on
			vr1.RateTableId = tmpvr.RateTableId
			AND vr1.RateID = tmpvr.RateID
			AND vr1.TimezonesID = tmpvr.TimezonesID
			AND vr1.EffectiveDate < tmpvr.EffectiveDate
SET
	vr1.EndDate = @EffectiveDate
where
	vr1.RateTableId = @p_RateTableId

	AND vr1.EndDate is null;

ELSE

UPDATE  tblRateTablePKGRate vr1
	inner join
	(
		select
			RateTableId,
			RateID,
			EffectiveDate,
			TimezonesID
		FROM tblRateTablePKGRate
		WHERE RateTableId = @p_RateTableId
					AND EffectiveDate =   @EffectiveDate
		order by EffectiveDate desc
	) tmpvr
		on
			vr1.RateTableId = tmpvr.RateTableId
			AND vr1.RateID = tmpvr.RateID
			AND vr1.TimezonesID = tmpvr.TimezonesID
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



update tblRateTablePKGRateAA
SET

	OneOffCost = IF(OneOffCost = 0 , NULL, fn_Round(OneOffCost,@v_RoundChargedAmount)),
	MonthlyCost = IF(MonthlyCost = 0 , NULL, fn_Round(MonthlyCost,@v_RoundChargedAmount)),
	PackageCostPerMinute = IF(PackageCostPerMinute = 0 , NULL, fn_Round(PackageCostPerMinute,@v_RoundChargedAmount)),
	RecordingCostPerMinute = IF(RecordingCostPerMinute = 0 , NULL, fn_Round(RecordingCostPerMinute,@v_RoundChargedAmount)),

	updated_at = now(),
	ModifiedBy = @p_ModifiedBy

where
	RateTableID = @p_RateTableId;



ELSE


update tblRateTablePKGRate
SET

	OneOffCost = IF(OneOffCost = 0 , NULL, fn_Round(OneOffCost,@v_RoundChargedAmount)),
	MonthlyCost = IF(MonthlyCost = 0 , NULL, fn_Round(MonthlyCost,@v_RoundChargedAmount)),
	PackageCostPerMinute = IF(PackageCostPerMinute = 0 , NULL, fn_Round(PackageCostPerMinute,@v_RoundChargedAmount)),
	RecordingCostPerMinute = IF(RecordingCostPerMinute = 0 , NULL, fn_Round(RecordingCostPerMinute,@v_RoundChargedAmount)),

	updated_at = now(),
	ModifiedBy = @p_ModifiedBy

where
	RateTableID = @p_RateTableId;

END IF;



IF (@v_RateApprovalProcess_ = 1 ) THEN


call prc_ArchiveOldRateTablePKGRateAA(@p_RateTableId, NULL,@p_ModifiedBy);

ELSE

call prc_ArchiveOldRateTablePKGRate(@p_RateTableId, NULL,@p_ModifiedBy);

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
