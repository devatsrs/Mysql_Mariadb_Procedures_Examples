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

-- Dumping structure for procedure speakintelligentRM.prc_GetDIDLCR
DROP PROCEDURE IF EXISTS `prc_GetDIDLCR`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `prc_GetDIDLCR`(
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

        SET	@v_RateTypeID = 2;	-- //1 - Termination,  2 - DID,   3 - Package
        set @v_AppliedToCustomer = 1; 
        set @v_AppliedToVendor = 2; 
        set @v_AppliedToReseller = 3; 



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
				
				Total1 DECIMAL(18,8),
				Total DECIMAL(18,8)
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
				AccountID int,
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
				AccountID int,
				Primary Key (ID )

			);



			DROP TEMPORARY TABLE IF EXISTS tmp_origination_minutes;
			CREATE TEMPORARY TABLE tmp_origination_minutes (
				OriginationCode varchar(50),
				minutes int
			);
			DROP TEMPORARY TABLE IF EXISTS tmp_timezone_minutes_2;
			CREATE TEMPORARY TABLE tmp_timezone_minutes_2 (
				TimezonesID int,
				AccountID int,
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
				AccountID int,
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


 
 			set @p_CurrencySymbol = (SELECT Symbol from tblCurrency where CurrencyID = @p_CurrencyID);
			 
			SET @v_CallerRate = 1;

			SET @p_DIDCategoryID  		= @p_DIDCategoryID;
			SET @p_Prefix = TRIM(LEADING '0' FROM @p_Prefix);

			

			IF @p_NoOfServicesContracted = 0 THEN
			
				insert into tmp_NoOfServicesContracted (VendorID,NoOfServicesContracted)
				select VendorID,count(CLI) as NoOfServicesContracted
				from  tblCLIRateTable
				where 
					CompanyID  = @p_companyid
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

				inner join speakintelligentRM.tblCountry c  on   d.area_prefix  like concat(c.Prefix,'%')

				where CompanyID = @p_companyid AND StartDate >= @p_StartDate AND StartDate <= @p_EndDate and d.is_inbound = 1

				AND (@p_CountryID = '' OR  c.CountryID = @p_CountryID )

				AND (@p_AccessType = '' OR d.NoType = @p_AccessType)

				AND (@p_City = '' OR d.City  = @p_City)

				AND ( @p_Tariff = '' OR d.Tariff  = @p_Tariff )

				AND ( @p_Prefix = '' OR ( d.area_prefix   = concat(c.Prefix,  @p_Prefix )  ) );


				-- Sumera not yet confirmed Account ID in CDR
				insert into tmp_timezone_minutes (TimezonesID, CostPerMinute,OutpaymentPerMinute,CollectionCostAmount)

				select TimezonesID  , sum(CostPerMinute), sum(OutpaymentPerMinute), sum(CollectionCostAmount) 

				from speakintelligentCDR.tblUsageDetails  d

				inner join speakintelligentCDR.tblUsageHeader h on d.UsageHeaderID = h.UsageHeaderID

				inner join speakintelligentRM.tblCountry c  on   d.area_prefix  like concat(c.Prefix,'%')

				where CompanyID = @p_companyid AND StartDate >= @p_StartDate AND StartDate <= @p_EndDate and d.is_inbound = 1 and TimezonesID is not null

				AND (@p_CountryID = '' OR  c.CountryID = @p_CountryID )

				AND (@p_AccessType = '' OR d.NoType = @p_AccessType)

				AND (@p_City = '' OR d.City  = @p_City)

				AND ( @p_Tariff = '' OR d.Tariff  = @p_Tariff )

				AND ( @p_Prefix = '' OR ( d.area_prefix   = concat(c.Prefix,  @p_Prefix )  ) )

				group by TimezonesID;


				insert into tmp_origination_minutes ( OriginationCode, minutes )

				select CLIPrefix  , (sum(billed_duration) / 60) as minutes

				from speakintelligentCDR.tblUsageDetails  d

				inner join speakintelligentCDR.tblUsageHeader h on d.UsageHeaderID = h.UsageHeaderID

				inner join speakintelligentRM.tblCountry c  on   d.area_prefix  like concat(c.Prefix,'%')

				where CompanyID = @p_companyid AND StartDate >= @p_StartDate AND StartDate <= @p_EndDate and d.is_inbound = 1 and CLIPrefix is not null

				AND (@p_CountryID = '' OR  c.CountryID = @p_CountryID )

				AND (@p_AccessType = '' OR d.NoType = @p_AccessType)

				AND (@p_City = '' OR d.City  = @p_City)

				AND ( @p_Tariff = '' OR d.Tariff  = @p_Tariff )

				AND ( @p_Prefix = '' OR ( d.area_prefix   = concat(c.Prefix,  @p_Prefix )  ) )

				group by CLIPrefix;


			ELSE


/*
					Minutes = 50
					%		= 20
					Timezone = Peak (10)

					AccountID  TimezoneID 	CostPerMinute OutpaymentPerMinute
						1		Peak			NULL				0.5
						1		Off-Peak		0.5					NULL
						1		Default			NULL				0.5


					AccountID  TimezoneID 	minutes_CostPerMinute minutes_OutpaymentPerMinute
						1		Peak			0							0.5 * 10
						1		Off-Peak		0.5 * 50					NULL
						1		Default			NULL						0.5 * 40

					*/

					insert into tmp_timezone_minutes ( AccountID, TimezonesID, CostPerMinute , OutpaymentPerMinute,CollectionCostAmount )
		
					Select DISTINCT vc.AccountId, drtr.TimezonesID, drtr.CostPerMinute, drtr.OutpaymentPerMinute, drtr.CollectionCostAmount
		
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
							;



					SET @p_PeakTimeZonePercentage	 		 = @p_TimezonePercentage;
					SET @p_MobileOrigination				 = @p_Origination ;
					SET @p_MobileOriginationPercentage	 	 = @p_OriginationPercentage ;


					insert into tmp_timezones (TimezonesID) select TimezonesID from tblTimezones;

					SET @v_rowCount_ = ( SELECT COUNT(*) FROM tmp_timezones );

					-- // account loop

					INSERT INTO tmp_accounts ( AccountID )  SELECT DISTINCT AccountID FROM tmp_timezone_minutes;

					SET @v_v_pointer_ = 1;

					SET @v_v_rowCount_ = ( SELECT COUNT(*) FROM tmp_accounts );

					WHILE @v_v_pointer_ <= @v_v_rowCount_
					DO

								SET @v_AccountID = ( SELECT AccountID FROM tmp_accounts WHERE ID = @v_v_pointer_ );
 
 								
								UPDATE  tmp_timezone_minutes SET minute_CostPerMinute =  ( (@p_Minutes/ 100) * @p_PeakTimeZonePercentage )
								WHERE  TimezonesID = @p_Timezone AND AccountID = @v_AccountID AND CostPerMinute IS NOT NULL;


								UPDATE  tmp_timezone_minutes SET minute_OutpaymentPerMinute =  ( (@p_Minutes/ 100) * @p_PeakTimeZonePercentage )
								WHERE  TimezonesID = @p_Timezone AND AccountID = @v_AccountID AND OutpaymentPerMinute IS NOT NULL;

								UPDATE  tmp_timezone_minutes SET minute_CollectionCostAmount =  ( (@p_Minutes/ 100) * @p_PeakTimeZonePercentage )
								WHERE  TimezonesID = @p_Timezone AND AccountID = @v_AccountID AND CollectionCostAmount IS NOT NULL;

					
								SET @v_RemainingTimezonesForCostPerMinute = ( SELECT count(*) FROM tmp_timezone_minutes where TimezonesID != @p_Timezone AND AccountID = @v_AccountID AND CostPerMinute IS NOT NULL );
								SET @v_RemainingTimezonesForOutpaymentPerMinute = ( SELECT count(*) FROM tmp_timezone_minutes where TimezonesID != @p_Timezone AND AccountID = @v_AccountID AND OutpaymentPerMinute IS NOT NULL );
								SET @v_RemainingTimezonesForCollectionCostAmount = ( SELECT count(*) FROM tmp_timezone_minutes where TimezonesID != @p_Timezone AND AccountID = @v_AccountID AND CollectionCostAmount IS NOT NULL );

								SET @v_RemainingCostPerMinute = (@p_Minutes - IFNULL((select minute_CostPerMinute FROM tmp_timezone_minutes WHERE  TimezonesID = @p_Timezone AND AccountID = @v_AccountID),0)  ) / @v_RemainingTimezonesForCostPerMinute ;
								SET @v_RemainingOutpaymentPerMinute = (@p_Minutes - IFNULL((select minute_OutpaymentPerMinute FROM tmp_timezone_minutes WHERE  TimezonesID = @p_Timezone AND AccountID = @v_AccountID),0) ) / @v_RemainingTimezonesForOutpaymentPerMinute ;
								SET @v_RemainingCollectionCostAmount = (@p_Minutes - IFNULL((select minute_CollectionCostAmount FROM tmp_timezone_minutes WHERE  TimezonesID = @p_Timezone AND AccountID = @v_AccountID),0) ) / @v_RemainingTimezonesForCollectionCostAmount ;

								SET @v_pointer_ = 1;

								WHILE @v_pointer_ <= @v_rowCount_
								DO

										SET @v_TimezonesID = ( SELECT TimezonesID FROM tmp_timezones WHERE ID = @v_pointer_ AND TimezonesID != @p_Timezone );

										if @v_TimezonesID > 0 THEN

												UPDATE  tmp_timezone_minutes SET minute_CostPerMinute =  @v_RemainingCostPerMinute
												WHERE  TimezonesID = @v_TimezonesID AND AccountID = @v_AccountID AND CostPerMinute IS NOT NULL;


												UPDATE  tmp_timezone_minutes SET minute_OutpaymentPerMinute =  @v_RemainingOutpaymentPerMinute
												WHERE  TimezonesID = @v_TimezonesID AND AccountID = @v_AccountID AND OutpaymentPerMinute IS NOT NULL;

												UPDATE  tmp_timezone_minutes SET minute_CollectionCostAmount =  @v_RemainingCollectionCostAmount
												WHERE  TimezonesID = @v_TimezonesID AND AccountID = @v_AccountID AND CollectionCostAmount IS NOT NULL;

										END IF ;

									SET @v_pointer_ = @v_pointer_ + 1;

								END WHILE;

						SET @v_v_pointer_ = @v_v_pointer_ + 1;

					END WHILE;

					-- // account loop ends


					SET @v_MinutesFromMobileOrigination  =  ( (@p_Minutes/ 100) * @p_MobileOriginationPercentage ) 	;

					insert into tmp_origination_minutes ( OriginationCode, minutes )
					select @p_MobileOrigination  , @v_MinutesFromMobileOrigination ;



			END IF;


		SET @v_days =    TIMESTAMPDIFF(DAY, (SELECT @p_StartDate), (SELECT @p_EndDate)) + 1 ;
		SET @v_period1 =      IF(MONTH((SELECT @p_StartDate)) = MONTH((SELECT @p_EndDate)), 0, (TIMESTAMPDIFF(DAY, (SELECT @p_StartDate), LAST_DAY((SELECT @p_StartDate)) + INTERVAL 0 DAY)) / DAY(LAST_DAY((SELECT @p_StartDate))));
		SET @v_period2 =      TIMESTAMPDIFF(MONTH, LAST_DAY((SELECT @p_StartDate)) + INTERVAL 1 DAY, LAST_DAY((SELECT @p_EndDate))) ;
		SET @v_period3 =      IF(MONTH((SELECT @p_StartDate)) = MONTH((SELECT @p_EndDate)), (SELECT @v_days), DAY((SELECT @p_EndDate))) / DAY(LAST_DAY((SELECT @p_EndDate)));
		SET @p_months =     (SELECT @v_period1) + (SELECT @v_period2) + (SELECT @v_period3);

		SET @p_months = ROUND(@p_months,1);
		
		
		insert into tmp_timezone_minutes_2 (AccountID, TimezonesID, minute_CostPerMinute,minute_OutpaymentPerMinute,minute_CollectionCostAmount) select AccountID,TimezonesID, minute_CostPerMinute,minute_OutpaymentPerMinute,minute_CollectionCostAmount from tmp_timezone_minutes;
		insert into tmp_timezone_minutes_3 (AccountID, TimezonesID, minute_CostPerMinute,minute_OutpaymentPerMinute,minute_CollectionCostAmount) select AccountID,TimezonesID, minute_CostPerMinute,minute_OutpaymentPerMinute,minute_CollectionCostAmount from tmp_timezone_minutes;



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
																
																Total1,
																Total
																)

	select
								drtr.TimezonesID,
								t.Title as TimezoneTitle,
								drtr.AccessType,
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
												END * @p_months 
											)
								
								+ 
											-- @TrunkCostPerService := 
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
														* (vtc.Cost  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = vtc.CurrencyID 
														and  CompanyID = @p_companyid ))
													)
													
													END
												ELSE 
													0
												END
											) / (select NoOfServicesContracted from  tmp_NoOfServicesContracted sc where sc.VendorID is null or sc.VendorID  = a.AccountID )
										),0)
										
								)
								as MonthlyCost,

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

								@Chargeback := CASE WHEN ( ChargebackCurrency is not null)
								THEN

                                        CASE WHEN  @p_CurrencyID = ChargebackCurrency THEN
                                            drtr.Chargeback
                                        ELSE
                                        (

                                            (@v_DestinationCurrencyConversionRate )
                                            * (drtr.Chargeback  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = ChargebackCurrency and  CompanyID = @p_companyid ))
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


								@CollectionCostPercentage := CASE WHEN ( CollectionCostAmountCurrency is not null)
								THEN

                                        CASE WHEN  @p_CurrencyID = CollectionCostAmountCurrency THEN
                                            drtr.CollectionCostPercentage
                                        ELSE
                                        (

                                            (@v_DestinationCurrencyConversionRate )
                                            * (drtr.CollectionCostPercentage  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = CollectionCostAmountCurrency and  CompanyID = @p_companyid ))
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
								END as RegistrationCostPerNumber,

								


 
								@Total1 := (

									(	IFNULL(@MonthlyCost,0) 				)				+ 
									(IFNULL(@CostPerMinute,0) * IFNULL((select minute_CostPerMinute from tmp_timezone_minutes tm where tm.TimezonesID = t.TimezonesID and (tm.AccountID is null OR tm.AccountID   = a.AccountID) ),0))	+
									(IFNULL(@CostPerCall,0) * @p_Calls)		+
									(IFNULL(@SurchargePerCall,0) * IFNULL(tom.minutes,0)) +
									(IFNULL(@OutpaymentPerMinute,0) *  IFNULL((select minute_OutpaymentPerMinute from tmp_timezone_minutes_2 tm2 where tm2.TimezonesID = t.TimezonesID and (tm2.AccountID is null OR tm2.AccountID  = a.AccountID) ),0))	+
									(IFNULL(@OutpaymentPerCall,0) * 	@p_Calls) +

									(IFNULL(@CollectionCostAmount,0) * IFNULL((select minute_CollectionCostAmount from tmp_timezone_minutes_3 tm3 where tm3.TimezonesID = t.TimezonesID and (tm3.AccountID is null OR tm3.AccountID  = a.AccountID) ),0) )


								)
								 as Total1,
								@Total := (
								@Total1 + @Total1 * (select sum( IF(FlatStatus = 0 ,(Amount/100), Amount ) * IFNULL(@CollectionCostPercentage,0))  from tblTaxRate where CompanyID = @p_companyid  AND `Status` = 1 AND  TaxType in  (1,2)   )
									) as Total





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
				left join tmp_origination_minutes tom  on r2.Code = tom.OriginationCode

				where

				rt.CompanyId =  @p_companyid

				and vc.DIDCategoryID = @p_DIDCategoryID

				and drtr.ApprovedStatus = 1

				and rt.Type = @v_RateTypeID

			  	and rt.AppliedTo = @v_AppliedToVendor

				AND EffectiveDate <= DATE(@p_SelectedEffectiveDate)

				AND (EndDate is NULL OR EndDate > now() )
				;


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
																
																Total1,
																Total
							)
								select
								drtr.TimezonesID,
								t.Title as TimezoneTitle,
								drtr.AccessType,
								r.CountryID,
								drtr.City,
								drtr.Tariff,

								r.Code,
								r2.Code as OriginationCode,
								vc.VendorConnectionID,
								vc.Name as VendorConnectionName,
								@MonthlyCost := 
								(
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

												WHEN  ( @p_CurrencyID = rt.CurrencyID ) THEN
													drtr.MonthlyCost
												ELSE
													(

														(@v_DestinationCurrencyConversionRate )	* (drtr.MonthlyCost  / (@v_CompanyCurrencyConversionRate ))
													)
												END * @p_months 
											)
								
								+ 
											-- @TrunkCostPerService := 
										IFNULL(
										(
											(
												CASE WHEN ( vtc.CurrencyID is not null)
												THEN
													CASE WHEN  @p_CurrencyID = vtc.CurrencyID THEN
														vtc.Cost
													ELSE
													(

														(@v_DestinationCurrencyConversionRate) * (vtc.Cost  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = vtc.CurrencyID and  CompanyID = @p_companyid ))
													)
													
													END
												ELSE 
													0
												END
											) / (select NoOfServicesContracted from  tmp_NoOfServicesContracted sc where sc.VendorID is null or sc.VendorID  = a.AccountID )
										),0)
										
								)
								as MonthlyCost,
								

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

								@Chargeback := CASE WHEN ( ChargebackCurrency is not null)
								THEN

                                        CASE WHEN  @p_CurrencyID = ChargebackCurrency THEN
                                            drtr.Chargeback
                                        ELSE
                                        (

                                            (@v_DestinationCurrencyConversionRate )
                                            * (drtr.Chargeback  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = ChargebackCurrency and  CompanyID = @p_companyid ))
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


								@CollectionCostPercentage := CASE WHEN ( CollectionCostAmountCurrency is not null)
								THEN

                                        CASE WHEN  @p_CurrencyID = CollectionCostAmountCurrency THEN
                                            drtr.CollectionCostPercentage
                                        ELSE
                                        (

                                            (@v_DestinationCurrencyConversionRate )
                                            * (drtr.CollectionCostPercentage  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = CollectionCostAmountCurrency and  CompanyID = @p_companyid ))
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
								END as RegistrationCostPerNumber,

								@Total1 := (
									(	IFNULL(@MonthlyCost,0) 				)				+
									(IFNULL(@CostPerMinute,0) * IFNULL(tom.minutes,0))	+
									(IFNULL(@CostPerCall,0) * @p_Calls)		+
									(IFNULL(@SurchargePerCall,0) * IFNULL(tom.minutes,0)) +
									(IFNULL(@OutpaymentPerMinute,0) * 	IFNULL(tom.minutes,0))	+
									(IFNULL(@OutpaymentPerCall,0) * 	@p_Calls) +

									(IFNULL(@CollectionCostAmount,0) * IFNULL(tom.minutes,0))


								) as Total1,

							@Total := (
								@Total1 + @Total1 * (select sum( IF(FlatStatus = 0 ,(Amount/100), Amount ) * IFNULL(@CollectionCostPercentage,0))  from tblTaxRate where CompanyID = @p_companyid AND `Status` = 1 AND  TaxType in  (1,2)   )
									) as Total





				from tblRateTableDIDRate  drtr
				inner join tblRateTable  rt on rt.RateTableId = drtr.RateTableId
				 inner join tblVendorConnection vc on vc.RateTableID = rt.RateTableId and vc.DIDCategoryID = rt.DIDCategoryID and vc.CompanyID = rt.CompanyId and vc.Active=1
				inner join tblAccount a on vc.AccountId = a.AccountID and rt.CompanyId = a.CompanyId
				left join tblVendorTrunkCost vtc on vtc.AccountID = a.AccountID
				inner join tblRate r on drtr.RateID = r.RateID and r.CompanyID = vc.CompanyID
				inner join tblRate r2 on drtr.OriginationRateID = r2.RateID and r.CompanyID = vc.CompanyID
		 		inner join tblCountry c on c.CountryID = r.CountryID

				AND ( @p_CountryID = '' OR  c.CountryID = @p_CountryID )
				AND ( @p_City = '' OR drtr.City = @p_City )
				AND ( @p_Tariff = '' OR drtr.Tariff  = @p_Tariff )
				AND ( @p_Prefix = '' OR (r.Code  = concat(c.Prefix ,@p_Prefix) ) )
				AND ( @p_AccessType = '' OR drtr.AccessType = @p_AccessType )



				inner join tblTimezones t on t.TimezonesID =  drtr.TimezonesID
				inner join tmp_origination_minutes tom  on r2.Code = tom.OriginationCode
				where

				rt.CompanyId = @p_companyid

				and vc.DIDCategoryID = @p_DIDCategoryID

				and drtr.ApprovedStatus = 1

				and rt.Type = @v_RateTypeID

			  	and rt.AppliedTo = @v_AppliedToVendor


				AND EffectiveDate <= DATE(@p_SelectedEffectiveDate)

				AND (EndDate is NULL OR EndDate > now() )

				;




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
                      CASE WHEN (@prev_Code = Code AND  @prev_AccessType    = AccessType AND  @prev_CountryID = CountryID
                              AND  @prev_City    = City AND  @prev_Tariff = Tariff /*AND  @prev_VendorConnectionID = VendorConnectionID */ AND @prev_Total <=  Total
                              )
                      THEN
                          @vPosition + 1
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

          SET @stm_columns = CONCAT(@stm_columns, "GROUP_CONCAT(if(ANY_VALUE(vPosition) = ",@v_pointer_,", CONCAT(ANY_VALUE(Total), '<br>', ANY_VALUE(VendorConnectionName), '<br>', DATE_FORMAT (ANY_VALUE(EffectiveDate), '%d/%m/%Y'),'' ), NULL)) AS `POSITION ",@v_pointer_,"`,");

				SET @v_pointer_ = @v_pointer_ + 1;

			END WHILE;

			SET @stm_columns = TRIM(TRAILING ',' FROM @stm_columns);

			IF (@p_isExport = 0)
			THEN

        SET @stm_query = CONCAT("SELECT AccessType ,Country ,Code,City ,Tariff, ", @stm_columns," FROM tmp_final_table_output GROUP BY Code, AccessType ,Country ,City ,Tariff    ORDER BY Code, AccessType ,Country ,City ,Tariff  LIMIT ",@p_RowspPage," OFFSET ",@v_OffSet_," ;");

		  select count(Code) as totalcount from tmp_final_table_output;


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

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;