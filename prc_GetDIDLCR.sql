use speakintelligentRM;
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
				AccessType varchar(200),
				CountryID int,
				City varchar(50),
				Tariff varchar(50),
				Prefix varchar(100),


				CostPerMinute DECIMAL(18,8), 
				OutpaymentPerMinute DECIMAL(18,8),
				SurchargePerMinute DECIMAL(18,8),

				minute_CostPerMinute DECIMAL(18,2), 
				minute_OutpaymentPerMinute DECIMAL(18,2),
				minute_SurchargePerMinute DECIMAL(18,2),

				INDEX Index1 (TimezonesID),
				INDEX Index2 (AccountID),
				INDEX Index3 (AccessType),
				INDEX Index4 (CountryID),
				INDEX Index5 (City),
				INDEX Index6 (Tariff),
				INDEX Index7 (Prefix)


			);

			DROP TEMPORARY TABLE IF EXISTS tmp_timezone_minutes_2;
			CREATE TEMPORARY TABLE tmp_timezone_minutes_2 (
				TimezonesID int,
				AccountID int,
				AccessType varchar(200),
				CountryID int,
				City varchar(50),
				Tariff varchar(50),
				Prefix varchar(100),


				CostPerMinute DECIMAL(18,8), 
				OutpaymentPerMinute DECIMAL(18,8),
				SurchargePerMinute DECIMAL(18,8),

				minute_CostPerMinute DECIMAL(18,2), 
				minute_OutpaymentPerMinute DECIMAL(18,2),
				minute_SurchargePerMinute DECIMAL(18,2),

				
				INDEX Index1 (TimezonesID),
				INDEX Index2 (AccountID),
				INDEX Index3 (AccessType),
				INDEX Index4 (CountryID),
				INDEX Index5 (City),
				INDEX Index6 (Tariff),
				INDEX Index7 (Prefix)

			);

			DROP TEMPORARY TABLE IF EXISTS tmp_timezone_minutes_3;
			CREATE TEMPORARY TABLE tmp_timezone_minutes_3 (
				TimezonesID int,
				AccountID int,
				AccessType varchar(200),
				CountryID int,
				City varchar(50),
				Tariff varchar(50),
				Prefix varchar(100),


				CostPerMinute DECIMAL(18,8), 
				OutpaymentPerMinute DECIMAL(18,8),
				SurchargePerMinute DECIMAL(18,8),

				minute_CostPerMinute DECIMAL(18,2), 
				minute_OutpaymentPerMinute DECIMAL(18,2),
				minute_SurchargePerMinute DECIMAL(18,2),

				INDEX Index1 (TimezonesID),
				INDEX Index2 (AccountID),
				INDEX Index3 (AccessType),
				INDEX Index4 (CountryID),
				INDEX Index5 (City),
				INDEX Index6 (Tariff),
				INDEX Index7 (Prefix)

			);



			DROP TEMPORARY TABLE IF EXISTS tmp_accounts;
			CREATE TEMPORARY TABLE tmp_accounts (
				ID int auto_increment,
				AccountID int,
				AccessType varchar(200),
				CountryID int,
				City varchar(50),
				Tariff varchar(50),
				Prefix varchar(100),

				INDEX Index2 (AccountID),
				INDEX Index3 (AccessType),
				INDEX Index4 (CountryID),
				INDEX Index5 (City),
				INDEX Index6 (Tariff),
				INDEX Index7 (Prefix),

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

					AND ( fn_IsEmpty(@p_CountryID)  OR  cli.CountryID = @p_CountryID )
					AND ( fn_IsEmpty(@p_City)  OR cli.City = @p_City )
					AND ( fn_IsEmpty(@p_Tariff)  OR cli.Tariff  = @p_Tariff )
					AND ( fn_IsEmpty(@p_Prefix)  OR ( cli.Prefix   = concat(c.Prefix,  @p_Prefix )  ) )
					AND ( fn_IsEmpty(@p_AccessType)  OR cli.NoType = @p_AccessType )

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


				-- Sumera not yet confirmed Account ID in CDR
				insert into tmp_timezone_minutes (TimezonesID, AccessType,CountryID,Prefix,City,Tariff, minute_CostPerMinute,minute_OutpaymentPerMinute,minute_SurchargePerMinute)

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


/*
					Minutes = 50
					%		= 20
					Timezone = Peak (10)

					AccountID  p_CountryID p_AccessType p_City p_Tariff p_Prefix TimezoneID 	CostPerMinute OutpaymentPerMinute
						1															Peak			NULL				0.5
						1															Off-Peak		0.5					NULL
						1															Default			NULL				0.5


					AccountID  p_CountryID p_AccessType p_City p_Tariff p_Prefix TimezoneID 	CostPerMinute OutpaymentPerMinute
						1															Peak			0							0.5 * 10
						1															Off-Peak		0.5 * 50					NULL
						1															Default			NULL						0.5 * 40

					*/

					insert into tmp_timezone_minutes ( AccountID, TimezonesID, AccessType,CountryID,Prefix,City,Tariff, CostPerMinute, OutpaymentPerMinute, SurchargePerMinute )
		
					
					select AccountId, TimezonesID, AccessType, CountryID, Prefix, City, Tariff , CostPerMinute, OutpaymentPerMinute, SurchargePerMinute
						from(
						
						Select DISTINCT vc.AccountId, drtr.TimezonesID, drtr.AccessType, c.CountryID,c.Prefix, drtr.City, drtr.Tariff , sum(drtr.CostPerMinute) as CostPerMinute, sum(drtr.OutpaymentPerMinute) as OutpaymentPerMinute, sum(drtr.SurchargePerMinute) as SurchargePerMinute
		
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

							group by AccountId, TimezonesID, AccessType, CountryID, Prefix, City, Tariff

						)	tmp ;

						
						INSERT INTO tmp_timezone_minutes_2 SELECT * FROM tmp_timezone_minutes;
						INSERT INTO tmp_timezone_minutes_3 SELECT * FROM tmp_timezone_minutes;

						 



					SET @p_PeakTimeZonePercentage	 		 = @p_TimezonePercentage;
					SET @p_MobileOrigination				 = @p_Origination ;
					SET @p_MobileOriginationPercentage	 	 = @p_OriginationPercentage ;


					insert into tmp_timezones (TimezonesID) select TimezonesID from tblTimezones;

					SET @v_rowCount_ = ( SELECT COUNT(*) FROM tmp_timezones );

					-- // account loop

					INSERT INTO tmp_accounts ( AccountID ,AccessType,CountryID,Prefix,City,Tariff )  SELECT DISTINCT AccountID, AccessType,CountryID,Prefix,City,Tariff FROM tmp_timezone_minutes;

					-- SET PEAK/Selected Timezones minutes 
												/* lOGIC IF @p_PeakTimeZonePercentage > 0 THEN

													SET @v_PeakTimeZoneMinutes				 =  ( (@p_Minutes/ 100) * @p_PeakTimeZonePercentage ) 	;

												ELSE 
													SET @v_no_of_timezones 				= 		(select count(DISTINCT TimezonesID) from tmp_timezone_minutes WHERE AccountID = @v_AccountID AND AccessType = @v_AccessType AND CountryID = @v_CountryID AND Prefix = @v_Prefix AND City = @v_City AND Tariff = @v_Tariff );
													SET @v_PeakTimeZoneMinutes				 =   @p_Minutes /  @v_no_of_timezones	;

												END IF;	*/

					UPDATE  tmp_timezone_minutes tzm
					INNER JOIN tmp_accounts a on tzm.AccountID = a.AccountID
					SET minute_CostPerMinute = 
											CASE WHEN @p_PeakTimeZonePercentage > 0 THEN
												( (@p_Minutes/ 100) * @p_PeakTimeZonePercentage )
											ELSE
													@p_Minutes /  (select count(DISTINCT tzmd.TimezonesID) from tmp_timezone_minutes_2 tzmd WHERE tzmd.AccountID = tzm.AccountID AND tzmd.AccessType = tzm.AccessType AND tzmd.CountryID = tzm.CountryID AND tzmd.Prefix = tzm.Prefix AND tzmd.City = tzm.City AND tzmd.Tariff = tzm.Tariff )
											END
 					WHERE  tzm.TimezonesID = @p_Timezone AND tzm.AccountID = a.AccountID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.Prefix = a.Prefix AND tzm.City = a.City AND tzm.Tariff = a.Tariff AND tzm.CostPerMinute IS NOT NULL;

					UPDATE  tmp_timezone_minutes tzm
					INNER JOIN tmp_accounts a on tzm.AccountID = a.AccountID
					SET minute_OutpaymentPerMinute = 
											CASE WHEN @p_PeakTimeZonePercentage > 0 THEN
												( (@p_Minutes/ 100) * @p_PeakTimeZonePercentage )
											ELSE
													@p_Minutes /  (select count(DISTINCT tzmd.TimezonesID) from tmp_timezone_minutes_2 tzmd WHERE tzmd.AccountID = tzm.AccountID AND tzmd.AccessType = tzm.AccessType AND tzmd.CountryID = tzm.CountryID AND tzmd.Prefix = tzm.Prefix AND tzmd.City = tzm.City AND tzmd.Tariff = tzm.Tariff )
											END
 					WHERE  tzm.TimezonesID = @p_Timezone AND tzm.AccountID = a.AccountID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.Prefix = a.Prefix AND tzm.City = a.City AND tzm.Tariff = a.Tariff AND tzm.OutpaymentPerMinute IS NOT NULL;

					UPDATE  tmp_timezone_minutes tzm
					INNER JOIN tmp_accounts a on tzm.AccountID = a.AccountID
					SET minute_SurchargePerMinute = 
											CASE WHEN @p_PeakTimeZonePercentage > 0 THEN
												( (@p_Minutes/ 100) * @p_PeakTimeZonePercentage )
											ELSE
													@p_Minutes /  (select count(DISTINCT tzmd.TimezonesID) from tmp_timezone_minutes_2 tzmd WHERE tzmd.AccountID = a.AccountID AND tzmd.AccessType = a.AccessType AND tzmd.CountryID = a.CountryID AND tzmd.Prefix = a.Prefix AND tzmd.City = a.City AND tzmd.Tariff = a.Tariff )
											END
 					WHERE  tzm.TimezonesID = @p_Timezone AND tzm.AccountID = a.AccountID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.Prefix = a.Prefix AND tzm.City = a.City AND tzm.Tariff = a.Tariff AND tzm.SurchargePerMinute IS NOT NULL;





					-- SET Remaining Timezone minutes  
									--				LOGIC		SET @v_RemainingTimezonesForCostPerMinute = ( SELECT count(*) FROM tmp_timezone_minutes where TimezonesID != @p_Timezone AND AccountID = @v_AccountID AND AccessType = @v_AccessType AND CountryID = @v_CountryID AND Prefix = @v_Prefix AND City = @v_City AND Tariff = @v_Tariff AND CostPerMinute IS NOT NULL );
									--						SET @v_RemainingCostPerMinute = (@p_Minutes - IFNULL(@v_PeakTimeZoneMinutes,0)  ) / @v_RemainingTimezonesForCostPerMinute ;

					
					UPDATE  tmp_timezone_minutes tzm
					INNER JOIN tmp_accounts a on tzm.AccountID = a.AccountID
					SET minute_CostPerMinute = ( @p_Minutes - IFNULL((select tzmd2.minute_CostPerMinute 
																		from tmp_timezone_minutes_3 tzmd2 WHERE tzmd2.TimezonesID = @p_Timezone AND tzmd2.AccountID = a.AccountID AND tzmd2.AccessType = a.AccessType AND tzmd2.CountryID = a.CountryID AND tzmd2.Prefix = a.Prefix AND tzmd2.City = a.City 
																		AND tzmd2.Tariff = a.Tariff AND tzmd2.CostPerMinute IS NOT NULL),0) )   
													/ (  select count(*)  from tmp_timezone_minutes_2 tzmd WHERE tzmd.TimezonesID != @p_Timezone AND tzmd.AccountID = a.AccountID AND tzmd.AccessType = a.AccessType AND tzmd.CountryID = a.CountryID AND tzmd.Prefix = a.Prefix AND tzmd.City = a.City 
													AND tzmd.Tariff = a.Tariff AND tzmd.CostPerMinute IS NOT NULL) 
 					WHERE  (tzm.TimezonesID != @p_Timezone) AND tzm.AccountID = a.AccountID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.Prefix = a.Prefix AND tzm.City = a.City 
					 							AND tzm.Tariff = a.Tariff AND tzm.CostPerMinute IS NOT NULL;

					
					UPDATE  tmp_timezone_minutes tzm
					INNER JOIN tmp_accounts a on tzm.AccountID = a.AccountID
					SET minute_OutpaymentPerMinute = ( @p_Minutes - IFNULL((select tzmd2.minute_OutpaymentPerMinute 
																		from tmp_timezone_minutes_3 tzmd2 WHERE tzmd2.TimezonesID = @p_Timezone AND tzmd2.AccountID = a.AccountID AND tzmd2.AccessType = a.AccessType AND tzmd2.CountryID = a.CountryID AND tzmd2.Prefix = a.Prefix AND tzmd2.City = a.City 
																		AND tzmd2.Tariff = a.Tariff AND tzmd2.OutpaymentPerMinute IS NOT NULL),0) )   
													/ (  select count(*)  from tmp_timezone_minutes_2 tzmd WHERE tzmd.TimezonesID != @p_Timezone AND tzmd.AccountID = a.AccountID AND tzmd.AccessType = a.AccessType AND tzmd.CountryID = a.CountryID AND tzmd.Prefix = a.Prefix AND tzmd.City = a.City 
													AND tzmd.Tariff = a.Tariff AND tzmd.OutpaymentPerMinute IS NOT NULL) 
 					WHERE  (tzm.TimezonesID != @p_Timezone) AND tzm.AccountID = a.AccountID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.Prefix = a.Prefix AND tzm.City = a.City 
					 							AND tzm.Tariff = a.Tariff AND tzm.OutpaymentPerMinute IS NOT NULL;
					
					UPDATE  tmp_timezone_minutes tzm
					INNER JOIN tmp_accounts a on tzm.AccountID = a.AccountID
					SET minute_SurchargePerMinute = ( @p_Minutes - IFNULL((select tzmd2.minute_SurchargePerMinute 
																		from tmp_timezone_minutes_3 tzmd2 WHERE (tzmd2.TimezonesID = @p_Timezone) AND tzmd2.AccountID = a.AccountID AND tzmd2.AccessType = a.AccessType AND tzmd2.CountryID = a.CountryID AND tzmd2.Prefix = a.Prefix AND tzmd2.City = a.City 
																		AND tzmd2.Tariff = a.Tariff AND tzmd2.SurchargePerMinute IS NOT NULL),0) )   
													/ (  select count(*)  from tmp_timezone_minutes_2 tzmd WHERE tzmd.TimezonesID != @p_Timezone AND tzmd.AccountID = a.AccountID AND tzmd.AccessType = a.AccessType AND tzmd.CountryID = a.CountryID AND tzmd.Prefix = a.Prefix AND tzmd.City = a.City 
													AND tzmd.Tariff = a.Tariff AND tzmd.SurchargePerMinute IS NOT NULL) 
 					WHERE  (tzm.TimezonesID != @p_Timezone) AND tzm.AccountID = a.AccountID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.Prefix = a.Prefix AND tzm.City = a.City 
					 							AND tzm.Tariff = a.Tariff AND tzm.SurchargePerMinute IS NOT NULL;
					
					



					-- SET Timezones 
					
					/*		OLD CODE WITH LOOP
					
					SET @v_v_pointer_ = 1;

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
							SET @v_no_of_timezones 				= 		(select count(DISTINCT TimezonesID) from tmp_timezone_minutes WHERE AccountID = @v_AccountID AND AccessType = @v_AccessType AND CountryID = @v_CountryID AND Prefix = @v_Prefix AND City = @v_City AND Tariff = @v_Tariff );
							SET @v_PeakTimeZoneMinutes				 =   @p_Minutes /  @v_no_of_timezones	;

						END IF;	

						UPDATE  tmp_timezone_minutes SET minute_CostPerMinute =  @v_PeakTimeZoneMinutes
						WHERE  TimezonesID = @p_Timezone AND AccountID = @v_AccountID AND AccessType = @v_AccessType AND CountryID = @v_CountryID AND Prefix = @v_Prefix AND City = @v_City AND Tariff = @v_Tariff AND CostPerMinute IS NOT NULL;


						UPDATE  tmp_timezone_minutes SET minute_OutpaymentPerMinute =  @v_PeakTimeZoneMinutes
						WHERE  TimezonesID = @p_Timezone AND AccountID = @v_AccountID AND AccessType = @v_AccessType AND CountryID = @v_CountryID AND Prefix = @v_Prefix AND City = @v_City AND Tariff = @v_Tariff AND OutpaymentPerMinute IS NOT NULL;

						UPDATE  tmp_timezone_minutes SET minute_SurchargePerMinute =  @v_PeakTimeZoneMinutes
						WHERE  TimezonesID = @p_Timezone AND AccountID = @v_AccountID AND AccessType = @v_AccessType AND CountryID = @v_CountryID AND Prefix = @v_Prefix AND City = @v_City AND Tariff = @v_Tariff AND SurchargePerMinute IS NOT NULL;
						
			
						SET @v_RemainingTimezonesForCostPerMinute = ( SELECT count(*) FROM tmp_timezone_minutes where TimezonesID != @p_Timezone AND AccountID = @v_AccountID AND AccessType = @v_AccessType AND CountryID = @v_CountryID AND Prefix = @v_Prefix AND City = @v_City AND Tariff = @v_Tariff AND CostPerMinute IS NOT NULL );
						SET @v_RemainingTimezonesForOutpaymentPerMinute = ( SELECT count(*) FROM tmp_timezone_minutes where TimezonesID != @p_Timezone AND AccountID = @v_AccountID AND AccessType = @v_AccessType AND CountryID = @v_CountryID AND Prefix = @v_Prefix AND City = @v_City AND Tariff = @v_Tariff AND OutpaymentPerMinute IS NOT NULL );
						SET @v_RemainingTimezonesForSurchargePerMinute = ( SELECT count(*) FROM tmp_timezone_minutes where TimezonesID != @p_Timezone AND AccountID = @v_AccountID AND AccessType = @v_AccessType AND CountryID = @v_CountryID AND Prefix = @v_Prefix AND City = @v_City AND Tariff = @v_Tariff AND SurchargePerMinute IS NOT NULL );

						SET @v_RemainingCostPerMinute = (@p_Minutes - IFNULL(@v_PeakTimeZoneMinutes,0)  ) / @v_RemainingTimezonesForCostPerMinute ;
						SET @v_RemainingOutpaymentPerMinute = (@p_Minutes - IFNULL(@v_PeakTimeZoneMinutes,0) ) / @v_RemainingTimezonesForOutpaymentPerMinute ;
						SET @v_RemainingSurchargePerMinute = (@p_Minutes - IFNULL(@v_PeakTimeZoneMinutes,0) ) / @v_RemainingTimezonesForSurchargePerMinute ;

						SET @v_pointer_ = 1;

						WHILE @v_pointer_ <= @v_rowCount_
						DO

							SET @v_TimezonesID = ( SELECT TimezonesID FROM tmp_timezones WHERE ID = @v_pointer_ AND TimezonesID != @p_Timezone );

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

			SET @p_months = fn_Round(@p_months,1);



			
			delete from tmp_timezone_minutes where minute_OutpaymentPerMinute is null and minute_SurchargePerMinute is null and minute_CostPerMinute is null;

			
			

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
								Total
								)
					select TimezonesID,
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
							Total
																
					from (
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
								END as RegistrationCostPerNumber,

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

								Outpayment + OutPayment * 21 % Tax * CollectionCostPercentage/100
								OutPayment * Chargeback/100

								*/

								@OutPayment  := (

									( IFNULL(@OutpaymentPerCall,0) * 	@p_Calls )  +
									( IFNULL(@OutpaymentPerMinute,0) *  IFNULL(tm.minute_OutpaymentPerMinute,0))	
									
								),

								@Surcharge := (
									CASE WHEN IFNULL(@SurchargePerCall,0) = 0 AND IFNULL(@SurchargePerMinute,0) = 0 THEN
										(IFNULL(@Surcharges,0) * @p_Calls)
									ELSE 	
										(
											(IFNULL(@SurchargePerCall,0) * @p_Calls ) +
											(IFNULL(@SurchargePerMinute,0) * IFNULL(tm.minute_SurchargePerMinute,0))	
										)
									END 
								),
								@Total := (

									(	(IFNULL(@MonthlyCost,0)* @p_months)	 +  @TrunkCostPerService	)				+ 

									( IFNULL(@CollectionCostAmount,0) ) +
									(IFNULL(@CostPerCall,0) * @p_Calls)		+
									(IFNULL(@CostPerMinute,0) * IFNULL(tm.minute_CostPerMinute,0))	+
									
									@Surcharge +

									( ( @OutPayment + (@OutPayment * 21/100) ) * IFNULL(@CollectionCostPercentage,0)/100 ) +
									( ( @OutPayment + (@OutPayment  * IFNULL(@Chargeback,0)/100 ) ) )

								)
								 as Total
								

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
						-- left join tmp_origination_minutes tom  on r2.Code = tom.OriginationCode
						LEFT JOIN  tmp_timezone_minutes tm on t.TimezonesID = tm.TimezonesID   and ( tm.AccountID is null OR a.AccountID = tm.AccountID ) AND drtr.AccessType = tm.AccessType 
						  AND c.CountryID = tm.CountryID  AND c.Prefix = tm.Prefix AND drtr.City = tm.City AND  drtr.Tariff  = tm.Tariff
						where

						rt.CompanyId =  @p_companyid

						and vc.DIDCategoryID = @p_DIDCategoryID

						and drtr.ApprovedStatus = 1

						and rt.Type = @v_RateTypeID

						and rt.AppliedTo = @v_AppliedToVendor

						AND EffectiveDate <= DATE(@p_SelectedEffectiveDate)

						AND (EndDate is NULL OR EndDate > now() )
					) tmp ;


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
																Total
							)
							select 
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
									Total
							from
							(
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
									END  
								)
								as MonthlyCost,
								
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

														(@v_DestinationCurrencyConversionRate) * (vtc.Cost  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = vtc.CurrencyID and  CompanyID = @p_companyid ))
													)
													
													END
												ELSE 
													0
												END
											) / (select NoOfServicesContracted from  tmp_NoOfServicesContracted sc where sc.VendorID is null or sc.VendorID  = a.AccountID )
										),0) as TrunkCostPerService,

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
								END as RegistrationCostPerNumber,
 

								@OutPayment  := (

									( IFNULL(@OutpaymentPerCall,0) * 	@p_Calls )  +
									( IFNULL(@OutpaymentPerMinute,0) *  IFNULL(tom.minutes,0))	
									
								),

 								@Surcharge := (
									CASE WHEN IFNULL(@SurchargePerCall,0) = 0 AND IFNULL(@SurchargePerMinute,0) = 0 THEN
										IFNULL(@Surcharges,0) * @p_Calls
									ELSE 	
										(
											(IFNULL(@SurchargePerCall,0) * @p_Calls ) +
											(IFNULL(@SurchargePerMinute,0) * IFNULL(tom.minutes,0))		
										)
									END 
								),
								@Total := (

									(	(IFNULL(@MonthlyCost,0)* @p_months)	 +  @TrunkCostPerService	)				+ 

									( IFNULL(@CollectionCostAmount,0) ) +
									(IFNULL(@CostPerCall,0) * @p_Calls)		+
									(IFNULL(@CostPerMinute,0) * IFNULL(tom.minutes,0))		+
									
									@Surcharge +

									( ( @OutPayment + (@OutPayment * 21/100) ) * IFNULL(@CollectionCostPercentage,0)/100 ) +
									( ( @OutPayment + (@OutPayment  * IFNULL(@Chargeback,0)/100 ) ) )

								)
								 as Total


								 
						from tblRateTableDIDRate  drtr
						inner join tblRateTable  rt on rt.RateTableId = drtr.RateTableId
						inner join tblVendorConnection vc on vc.RateTableID = rt.RateTableId and vc.DIDCategoryID = rt.DIDCategoryID and vc.CompanyID = rt.CompanyId and vc.Active=1
						inner join tblAccount a on vc.AccountId = a.AccountID and rt.CompanyId = a.CompanyId and a.IsVendor = 1 and a.Status = 1
						left join tblVendorTrunkCost vtc on  a.AccountID = vtc.AccountID
						inner join tblRate r on drtr.RateID = r.RateID and r.CompanyID = vc.CompanyID
						inner join tblRate r2 on drtr.OriginationRateID = r2.RateID and r.CompanyID = r2.CompanyID
						inner join tblCountry c on c.CountryID = r.CountryID

						AND ( fn_IsEmpty(@p_CountryID)  OR  c.CountryID = @p_CountryID )
						AND ( fn_IsEmpty(@p_City)  OR drtr.City = @p_City )
						AND ( fn_IsEmpty(@p_Tariff)  OR drtr.Tariff  = @p_Tariff )
						AND ( fn_IsEmpty(@p_Prefix)  OR (r.Code  = concat(c.Prefix ,@p_Prefix) ) )
						AND ( fn_IsEmpty(@p_AccessType)  OR drtr.AccessType = @p_AccessType )



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
					) tmp;




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
                      	CASE WHEN (@prev_Code = Code AND  @prev_AccessType    = AccessType AND  @prev_CountryID = CountryID AND  @prev_City    = City AND  @prev_Tariff = Tariff /*AND  @prev_VendorConnectionID = VendorConnectionID */ AND @prev_Total <  Total )  THEN   @vPosition + 1
                      	    WHEN (@prev_Code = Code AND  @prev_AccessType    = AccessType AND  @prev_CountryID = CountryID AND  @prev_City    = City AND  @prev_Tariff = Tariff /*AND  @prev_VendorConnectionID = VendorConnectionID */ AND @prev_Total =  Total )  THEN   @vPosition 
                      
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

          SET @stm_columns = CONCAT(@stm_columns, "GROUP_CONCAT(if(ANY_VALUE(vPosition) = ",@v_pointer_,", CONCAT(ANY_VALUE(Total), '<br>', ANY_VALUE(VendorConnectionName), '<br>', DATE_FORMAT (ANY_VALUE(EffectiveDate), '%d/%m/%Y'),'' ), NULL) ) AS `POSITION ",@v_pointer_,"`,");

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