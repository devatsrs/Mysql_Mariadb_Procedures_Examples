use speakintelligentRM;
DROP PROCEDURE IF EXISTS `prc_GetDIDLCR`;
DELIMITER //
CREATE PROCEDURE `prc_GetDIDLCR`(
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

		-- load perameters
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



		SET @v_OffSet_ = (@p_PageNumber * @p_RowspPage) - @p_RowspPage;
		
		-- load currency settings

		SELECT CurrencyId INTO @v_CompanyCurrencyID_ FROM  tblCompany WHERE CompanyID = @p_companyid;

        Select Value INTO @v_DestinationCurrencyConversionRate from tblCurrencyConversion where tblCurrencyConversion.CurrencyId =  @p_CurrencyID  and  CompanyID = @p_companyid;
        Select Value INTO @v_CompanyCurrencyConversionRate from tblCurrencyConversion where tblCurrencyConversion.CurrencyId =  @v_CompanyCurrencyID_  and  CompanyID = @p_companyid;

		-- load temp tables 
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
				City varchar(100) COLLATE 'utf8_unicode_ci',
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
				City varchar(100) COLLATE 'utf8_unicode_ci',
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
				City varchar(100) COLLATE 'utf8_unicode_ci',
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
						City varchar(100) COLLATE 'utf8_unicode_ci',
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
						RegistrationCostPerNumber DECIMAL(18,8),
						
						INDEX Index1 (TimezonesID,VendorConnectionID,AccessType,CountryID,OriginationCode,Code,City,Tariff),
						INDEX Index2 (MonthlyCost)
 
			);

 
			DROP TEMPORARY TABLE IF EXISTS tmp_tblRateTableDIDRate_step1_dup;
			CREATE TEMPORARY TABLE tmp_tblRateTableDIDRate_step1_dup LIKE tmp_tblRateTableDIDRate_step1;


			DROP TEMPORARY TABLE IF EXISTS tmp_table_without_origination;
			CREATE TEMPORARY TABLE tmp_table_without_origination (

						TimezonesID  int,
						TimezoneTitle  varchar(100),
						AccessType varchar(200),
						CountryID int,
						City varchar(100) COLLATE 'utf8_unicode_ci',
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

			-- component name table
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
            City varchar(100) COLLATE 'utf8_unicode_ci',
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
            City varchar(100) COLLATE 'utf8_unicode_ci',
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
            City varchar(100) COLLATE 'utf8_unicode_ci',
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
				City varchar(100) COLLATE 'utf8_unicode_ci',
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

				INDEX Index1 (TimezonesID,VendorConnectionID,AccessType,CountryID,OriginationCode,Code,City,Tariff),
				INDEX Index2 (CostPerMinute),
				INDEX Index3 (OutpaymentPerMinute),
				INDEX Index4 (SurchargePerMinute),

				INDEX Index5 (OutpaymentPerCall),
				INDEX Index6 (Surcharges),
				INDEX Index7 (SurchargePerCall),
				INDEX Index8 (CollectionCostAmount),
				INDEX Index9 (CostPerCall)


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
				City varchar(100) COLLATE 'utf8_unicode_ci',
				Tariff varchar(50),
				Code varchar(100),
				OriginationCode varchar(100),
				OriginationCode2 varchar(100),

				_Minutes int,
				_Calls int,

				INDEX Index1 (TimezonesID,VendorConnectionID,AccessType,CountryID,OriginationCode,Code,City,Tariff),

				Primary Key (ID )

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

			
			-- load tmp_NoOfServicesContracted  for total calculation
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
			
			-- no calls and minutes given -- (not tested	)
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



			ELSE

 
						

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

					-- load data based on setttings 											 		
 							insert into tmp_timezone_minutes ( VendorConnectionID, TimezonesID, AccessType,CountryID,Code,OriginationCode, City,Tariff, CostPerMinute, OutpaymentPerMinute, SurchargePerMinute, OutpaymentPerCall, Surcharges, SurchargePerCall, CollectionCostAmount, CostPerCall )
							select VendorConnectionID, TimezonesID, AccessType, CountryID, Code, OriginationCode,City, Tariff , CostPerMinute, OutpaymentPerMinute, SurchargePerMinute, OutpaymentPerCall, Surcharges, SurchargePerCall, CollectionCostAmount, CostPerCall
								from(
								
								Select DISTINCT vc.VendorConnectionID, drtr.TimezonesID, drtr.AccessType, c.CountryID,r.Code,IFNULL(r2.Code,'') as OriginationCode, drtr.City, drtr.Tariff , sum(drtr.CostPerMinute) as CostPerMinute, sum(drtr.OutpaymentPerMinute) as OutpaymentPerMinute, sum(drtr.SurchargePerMinute) as SurchargePerMinute, sum(OutpaymentPerCall) as OutpaymentPerCall, sum(Surcharges) as Surcharges, sum(SurchargePerCall) as SurchargePerCall, sum(CollectionCostAmount) as CollectionCostAmount, sum(CostPerCall) as CostPerCall
				
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
									
									-- AND ( @p_OriginationPercentage = '' OR   drtr.OriginationRateID is null ) -- to skip origination records seperate 

									and vc.DIDCategoryID = @p_DIDCategoryID

									and drtr.ApprovedStatus = 1

									and rt.Type = @v_RateTypeID

									and rt.AppliedTo = @v_AppliedToVendor

									AND EffectiveDate <= DATE(@p_SelectedEffectiveDate)

									AND (EndDate is NULL OR EndDate > now() )

									group by VendorConnectionID, TimezonesID, AccessType, CountryID, drtr.RateID,drtr.OriginationRateID, City, Tariff

								)	tmp ;

					
					-- SET @p_TimezonePercentage	 		 = @p_TimezonePercentage;
					-- SET @p_Origination				 = @p_Origination ;
					-- SET @p_OriginationPercentage	 	 = @p_OriginationPercentage ;

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
						INNER JOIN tmp_accounts a on tzm.TimezonesID = a.TimezonesID AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode LIKE CONCAT('%',@p_Origination,'%') AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff  
						SET minute_CostPerMinute = _Minutes
						WHERE tzm.CostPerMinute IS NOT NULL;

						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.TimezonesID = a.TimezonesID AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode LIKE CONCAT('%',@p_Origination,'%') AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff  
						SET minute_OutpaymentPerMinute =  _Minutes
						WHERE tzm.OutpaymentPerMinute IS NOT NULL;

						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.TimezonesID = a.TimezonesID AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode LIKE CONCAT('%',@p_Origination,'%') AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff  
						SET minute_SurchargePerMinute = _Minutes
						WHERE tzm.SurchargePerMinute IS NOT NULL;

						-- Calls
						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.TimezonesID = a.TimezonesID AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode LIKE CONCAT('%',@p_Origination,'%') AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff
						SET calls_OutpaymentPerCall = _Calls
						WHERE tzm.OutpaymentPerCall IS NOT NULL;

						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.TimezonesID = a.TimezonesID AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode LIKE CONCAT('%',@p_Origination,'%') AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff
						SET calls_Surcharges =  _Calls
						WHERE tzm.Surcharges IS NOT NULL;

						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.TimezonesID = a.TimezonesID AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode LIKE CONCAT('%',@p_Origination,'%') AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff
						SET calls_SurchargePerCall = _Calls
						WHERE tzm.SurchargePerCall IS NOT NULL;

						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.TimezonesID = a.TimezonesID AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode LIKE CONCAT('%',@p_Origination,'%') AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff
						SET calls_CollectionCostAmount =  _Calls
						WHERE tzm.CollectionCostAmount IS NOT NULL;

						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.TimezonesID = a.TimezonesID AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode LIKE CONCAT('%',@p_Origination,'%') AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff
						SET calls_CostPerCall = _Calls
						WHERE tzm.CostPerCall IS NOT NULL;
						
						-- ----------------------------------------------------

 
						 -- select * from  tmp_timezone_minutes ; -- TEST
					
					
						truncate table tmp_timezone_minutes_2;	-- INDEXES SAME AS tmp_timezone_minutes
						-- truncate table tmp_timezone_minutes_3; -- INDEXES SAME AS tmp_timezone_minutes BUT NOT TimezonesID
						DROP TEMPORARY TABLE IF EXISTS tmp_timezone_minutes_3;
						CREATE TEMPORARY TABLE tmp_timezone_minutes_3 (
							TimezonesID int,
							VendorConnectionID int,
							AccessType varchar(200),
							CountryID int,
							City varchar(100) COLLATE 'utf8_unicode_ci',
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

							INDEX Index1 (VendorConnectionID,AccessType,CountryID,OriginationCode,Code,City,Tariff),
							INDEX Index2 (CostPerMinute),
							INDEX Index3 (OutpaymentPerMinute),
							INDEX Index4 (SurchargePerMinute),

							INDEX Index5 (OutpaymentPerCall),
							INDEX Index6 (Surcharges),
							INDEX Index7 (SurchargePerCall),
							INDEX Index8 (CollectionCostAmount),
							INDEX Index9 (CostPerCall)


						);
						
						INSERT INTO tmp_timezone_minutes_2 SELECT * FROM tmp_timezone_minutes where OriginationCode != ''; -- AND TimezonesID != @v_default_TimezonesID;
						INSERT INTO tmp_timezone_minutes_3 SELECT * FROM tmp_timezone_minutes where OriginationCode != ''; -- AND TimezonesID != @v_default_TimezonesID;

						-- Minutes -  Selected Origination Minutes / Total Count of Records not Selected
						-- add remaining minute on remaining 
						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.TimezonesID = a.TimezonesID AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode NOT LIKE CONCAT('%',@p_Origination,'%') AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff
						SET minute_CostPerMinute = ( IFNULL((select  (@p_Minutes - tzmd2.minute_CostPerMinute) 
																			from tmp_timezone_minutes_3 tzmd2 WHERE tzmd2.VendorConnectionID = a.VendorConnectionID /*AND tzmd2.TimezonesID = a.TimezonesID*/ AND tzmd2.AccessType = a.AccessType AND tzmd2.CountryID = a.CountryID AND tzmd2.OriginationCode LIKE CONCAT('%',@p_Origination,'%') /*AND tzmd2.OriginationCode = a.OriginationCode*/ AND tzmd2.Code = a.Code AND tzmd2.City = a.City 
																			AND tzmd2.Tariff = a.Tariff AND tzmd2.CostPerMinute IS NOT NULL LIMIT 1 ),_Minutes) )   
														/ (select IF(count(*) = 0,1,count(*))  from tmp_timezone_minutes_2 tzmd WHERE /*tzmd.OriginationCode NOT LIKE CONCAT('%',@p_Origination,'%') AND*/ tzmd.TimezonesID = a.TimezonesID AND tzmd.VendorConnectionID = a.VendorConnectionID AND tzmd.AccessType = a.AccessType AND tzmd.CountryID = a.CountryID AND tzmd.OriginationCode = a.OriginationCode AND tzmd.Code = a.Code AND tzmd.City = a.City 
														AND tzmd.Tariff = a.Tariff AND tzmd.CostPerMinute IS NOT NULL) 
						WHERE tzm.CostPerMinute IS NOT NULL;

						
						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.TimezonesID = a.TimezonesID AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode NOT LIKE CONCAT('%',@p_Origination,'%') AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff
						SET minute_OutpaymentPerMinute = ( IFNULL((select (@p_Minutes - tzmd2.minute_OutpaymentPerMinute) 
																			from tmp_timezone_minutes_3 tzmd2 WHERE tzmd2.VendorConnectionID = a.VendorConnectionID /*AND tzmd2.TimezonesID = a.TimezonesID*/ AND tzmd2.AccessType = a.AccessType AND tzmd2.CountryID = a.CountryID AND tzmd2.OriginationCode LIKE CONCAT('%',@p_Origination,'%') /*AND tzmd2.OriginationCode = a.OriginationCode*/ AND tzmd2.Code = a.Code AND tzmd2.City = a.City 
																			AND tzmd2.Tariff = a.Tariff AND tzmd2.OutpaymentPerMinute IS NOT NULL LIMIT 1 ),_Minutes) )   
														/ (  select IF(count(*) = 0,1,count(*))  from tmp_timezone_minutes_2 tzmd WHERE /*tzmd.OriginationCode NOT LIKE CONCAT('%',@p_Origination,'%') AND*/ tzmd.TimezonesID = a.TimezonesID AND tzmd.VendorConnectionID = a.VendorConnectionID AND tzmd.AccessType = a.AccessType AND tzmd.CountryID = a.CountryID AND tzmd.OriginationCode = a.OriginationCode AND tzmd.Code = a.Code AND tzmd.City = a.City 
														AND tzmd.Tariff = a.Tariff AND tzmd.OutpaymentPerMinute IS NOT NULL ) 
						WHERE tzm.OutpaymentPerMinute IS NOT NULL;
						
						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.TimezonesID = a.TimezonesID AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode NOT LIKE CONCAT('%',@p_Origination,'%') AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff
						SET minute_SurchargePerMinute = ( IFNULL((select (@p_Minutes - tzmd2.minute_SurchargePerMinute) 
																			from tmp_timezone_minutes_3 tzmd2 WHERE (tzmd2.VendorConnectionID = a.VendorConnectionID /*AND tzmd2.TimezonesID = a.TimezonesID*/ AND tzmd2.AccessType = a.AccessType AND tzmd2.CountryID = a.CountryID AND tzmd2.OriginationCode LIKE CONCAT('%',@p_Origination,'%')) /*AND tzmd2.OriginationCode = a.OriginationCode*/ AND tzmd2.Code = a.Code AND tzmd2.City = a.City 
																			AND tzmd2.Tariff = a.Tariff AND tzmd2.SurchargePerMinute IS NOT NULL LIMIT 1 ),_Minutes) )   
														/ (  select IF(count(*) = 0,1,count(*))  from tmp_timezone_minutes_2 tzmd WHERE /*tzmd.OriginationCode NOT LIKE CONCAT('%',@p_Origination,'%') AND*/ tzmd.TimezonesID = a.TimezonesID AND tzmd.VendorConnectionID = a.VendorConnectionID AND tzmd.AccessType = a.AccessType AND tzmd.CountryID = a.CountryID AND tzmd.OriginationCode = a.OriginationCode AND tzmd.Code = a.Code AND tzmd.City = a.City 
														AND tzmd.Tariff = a.Tariff AND tzmd.SurchargePerMinute IS NOT NULL) 
						WHERE tzm.SurchargePerMinute IS NOT NULL;
						

						-- add remaining calls on remaining Origination
						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.TimezonesID = a.TimezonesID AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode NOT LIKE CONCAT('%',@p_Origination,'%') AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff
						SET calls_OutpaymentPerCall = ( IFNULL((select (@p_Calls - tzmd2.calls_OutpaymentPerCall) 
																			from tmp_timezone_minutes_3 tzmd2 WHERE tzmd2.VendorConnectionID = a.VendorConnectionID /*AND tzmd2.TimezonesID = a.TimezonesID*/ AND tzmd2.AccessType = a.AccessType AND tzmd2.CountryID = a.CountryID AND tzmd2.OriginationCode LIKE CONCAT('%',@p_Origination,'%') /*AND tzmd2.OriginationCode = a.OriginationCode*/ AND tzmd2.Code = a.Code AND tzmd2.City = a.City 
																			AND tzmd2.Tariff = a.Tariff AND tzmd2.OutpaymentPerCall IS NOT NULL LIMIT 1 ),_Calls) )   
														/ (  select IF(count(*) = 0,1,count(*))  from tmp_timezone_minutes_2 tzmd WHERE /*tzmd.OriginationCode NOT LIKE CONCAT('%',@p_Origination,'%') AND*/ tzmd.TimezonesID = a.TimezonesID AND tzmd.VendorConnectionID = a.VendorConnectionID AND tzmd.AccessType = a.AccessType AND tzmd.CountryID = a.CountryID AND tzmd.OriginationCode = a.OriginationCode AND tzmd.Code = a.Code AND tzmd.City = a.City 
														AND tzmd.Tariff = a.Tariff AND tzmd.OutpaymentPerCall IS NOT NULL) 
						WHERE tzm.OutpaymentPerCall IS NOT NULL;



						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.TimezonesID = a.TimezonesID AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode NOT LIKE CONCAT('%',@p_Origination,'%') AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff
						SET calls_Surcharges = ( IFNULL((select (@p_Calls - tzmd2.calls_Surcharges) 
																			from tmp_timezone_minutes_3 tzmd2 WHERE tzmd2.VendorConnectionID = a.VendorConnectionID /*AND tzmd2.TimezonesID = a.TimezonesID*/ AND tzmd2.AccessType = a.AccessType AND tzmd2.CountryID = a.CountryID AND tzmd2.OriginationCode LIKE CONCAT('%',@p_Origination,'%') /*AND tzmd2.OriginationCode = a.OriginationCode*/ AND tzmd2.Code = a.Code AND tzmd2.City = a.City 
																			AND tzmd2.Tariff = a.Tariff AND tzmd2.Surcharges IS NOT NULL LIMIT 1 ),_Calls) )   
														/ (  select IF(count(*) = 0,1,count(*))  from tmp_timezone_minutes_2 tzmd WHERE /*tzmd.OriginationCode NOT LIKE CONCAT('%',@p_Origination,'%') AND*/ tzmd.TimezonesID = a.TimezonesID AND tzmd.VendorConnectionID = a.VendorConnectionID AND tzmd.AccessType = a.AccessType AND tzmd.CountryID = a.CountryID AND tzmd.OriginationCode = a.OriginationCode AND tzmd.Code = a.Code AND tzmd.City = a.City 
														AND tzmd.Tariff = a.Tariff AND tzmd.Surcharges IS NOT NULL) 
						WHERE tzm.Surcharges IS NOT NULL;

						
						
						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.TimezonesID = a.TimezonesID AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode NOT LIKE CONCAT('%',@p_Origination,'%') AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff
						SET calls_SurchargePerCall = ( IFNULL( (select (@p_Calls - tzmd2.calls_SurchargePerCall) 
																			from tmp_timezone_minutes_3 tzmd2 WHERE tzmd2.VendorConnectionID = a.VendorConnectionID /*AND tzmd2.TimezonesID = a.TimezonesID*/ AND tzmd2.AccessType = a.AccessType AND tzmd2.CountryID = a.CountryID AND tzmd2.OriginationCode LIKE CONCAT('%',@p_Origination,'%') /*AND tzmd2.OriginationCode = a.OriginationCode*/ AND tzmd2.Code = a.Code AND tzmd2.City = a.City 
																			AND tzmd2.Tariff = a.Tariff AND tzmd2.SurchargePerCall IS NOT NULL LIMIT 1 ),_Calls) )   
														/ (  select IF(count(*) = 0,1,count(*))  from tmp_timezone_minutes_2 tzmd WHERE /*tzmd.OriginationCode NOT LIKE CONCAT('%',@p_Origination,'%') AND*/ tzmd.TimezonesID = a.TimezonesID AND tzmd.VendorConnectionID = a.VendorConnectionID AND tzmd.AccessType = a.AccessType AND tzmd.CountryID = a.CountryID AND tzmd.OriginationCode = a.OriginationCode AND tzmd.Code = a.Code AND tzmd.City = a.City 
														AND tzmd.Tariff = a.Tariff AND tzmd.SurchargePerCall IS NOT NULL) 
						WHERE tzm.SurchargePerCall IS NOT NULL;
												
						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.TimezonesID = a.TimezonesID AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode NOT LIKE CONCAT('%',@p_Origination,'%') AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff
						SET calls_CollectionCostAmount = ( IFNULL((select (@p_Calls - tzmd2.calls_CollectionCostAmount) 
																			from tmp_timezone_minutes_3 tzmd2 WHERE tzmd2.VendorConnectionID = a.VendorConnectionID /*AND tzmd2.TimezonesID = a.TimezonesID*/ AND tzmd2.AccessType = a.AccessType AND tzmd2.CountryID = a.CountryID AND tzmd2.OriginationCode LIKE CONCAT('%',@p_Origination,'%') /*AND tzmd2.OriginationCode = a.OriginationCode*/ AND tzmd2.Code = a.Code AND tzmd2.City = a.City 
																			AND tzmd2.Tariff = a.Tariff AND tzmd2.CollectionCostAmount IS NOT NULL LIMIT 1 ),_Calls) )   
														/ (  select IF(count(*) = 0,1,count(*))  from tmp_timezone_minutes_2 tzmd WHERE /*tzmd.OriginationCode NOT LIKE CONCAT('%',@p_Origination,'%') AND*/ tzmd.TimezonesID = a.TimezonesID AND tzmd.VendorConnectionID = a.VendorConnectionID AND tzmd.AccessType = a.AccessType AND tzmd.CountryID = a.CountryID AND tzmd.OriginationCode = a.OriginationCode AND tzmd.Code = a.Code AND tzmd.City = a.City 
														AND tzmd.Tariff = a.Tariff AND tzmd.CollectionCostAmount IS NOT NULL) 
						WHERE tzm.CollectionCostAmount IS NOT NULL;
						
						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.TimezonesID = a.TimezonesID AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode NOT LIKE CONCAT('%',@p_Origination,'%') AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff
						SET calls_CostPerCall = ( IFNULL((select (@p_Calls - tzmd2.calls_CostPerCall) 
																			from tmp_timezone_minutes_3 tzmd2 WHERE tzmd2.VendorConnectionID = a.VendorConnectionID /*AND tzmd2.TimezonesID = a.TimezonesID*/ AND tzmd2.AccessType = a.AccessType AND tzmd2.CountryID = a.CountryID AND tzmd2.OriginationCode LIKE CONCAT('%',@p_Origination,'%') /*AND tzmd2.OriginationCode = a.OriginationCode*/ AND tzmd2.Code = a.Code AND tzmd2.City = a.City 
																			AND tzmd2.Tariff = a.Tariff AND tzmd2.CostPerCall IS NOT NULL LIMIT 1 ),_Calls) )   
														/ (  select IF(count(*) = 0,1,count(*))  from tmp_timezone_minutes_2 tzmd WHERE /*tzmd.OriginationCode NOT LIKE CONCAT('%',@p_Origination,'%') AND*/ tzmd.TimezonesID = a.TimezonesID AND tzmd.VendorConnectionID = a.VendorConnectionID AND tzmd.AccessType = a.AccessType AND tzmd.CountryID = a.CountryID AND tzmd.OriginationCode = a.OriginationCode AND tzmd.Code = a.Code AND tzmd.City = a.City 
														AND tzmd.Tariff = a.Tariff AND tzmd.CostPerCall IS NOT NULL) 
						WHERE tzm.CostPerCall IS NOT NULL;

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
						on  tzm.TimezonesID = a.TimezonesID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode2 = a.OriginationCode2 AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff
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
						INNER JOIN tmp_accounts a on tzm.TimezonesID = a.TimezonesID AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode2 not LIKE CONCAT('%',@p_Origination,'%') AND tzm.OriginationCode2 = a.OriginationCode2 AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff
						SET calls_OutpaymentPerCall = _Calls/OriginationCode2_Rows
						WHERE tzm.OutpaymentPerCall IS NOT NULL and OriginationCode2_Rows > 1;

						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.TimezonesID = a.TimezonesID AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode2 not LIKE CONCAT('%',@p_Origination,'%') AND tzm.OriginationCode2 = a.OriginationCode2 AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff
						SET calls_Surcharges = _Calls/OriginationCode2_Rows
						WHERE tzm.Surcharges IS NOT NULL and OriginationCode2_Rows > 1;


						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.TimezonesID = a.TimezonesID AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode2 not LIKE CONCAT('%',@p_Origination,'%') AND tzm.OriginationCode2 = a.OriginationCode2 AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff
						SET calls_SurchargePerCall = _Calls/OriginationCode2_Rows
						WHERE tzm.SurchargePerCall IS NOT NULL and OriginationCode2_Rows > 1;


						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.TimezonesID = a.TimezonesID AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode2 not LIKE CONCAT('%',@p_Origination,'%') AND tzm.OriginationCode2 = a.OriginationCode2 AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff
						SET calls_CollectionCostAmount = _Calls/OriginationCode2_Rows
						WHERE tzm.CollectionCostAmount IS NOT NULL and OriginationCode2_Rows > 1;


						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.TimezonesID = a.TimezonesID AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode2 not LIKE CONCAT('%',@p_Origination,'%') AND tzm.OriginationCode2 = a.OriginationCode2 AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff
						SET calls_CostPerCall = _Calls/OriginationCode2_Rows
						WHERE tzm.CostPerCall IS NOT NULL and OriginationCode2_Rows > 1;
						-- Operator change over


					ELSE 


						truncate table tmp_timezone_minutes_2;
 						INSERT INTO tmp_timezone_minutes_2 SELECT * FROM tmp_timezone_minutes where OriginationCode != '';
 
						-- minutes	
						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.TimezonesID = a.TimezonesID AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff
						SET minute_CostPerMinute =  @p_Minutes /  (select IF(count(DISTINCT tzmd.OriginationCode)=0,1,count(DISTINCT tzmd.OriginationCode)) from tmp_timezone_minutes_2 tzmd WHERE tzmd.TimezonesID = tzm.TimezonesID AND tzmd.VendorConnectionID = tzm.VendorConnectionID AND tzmd.AccessType = tzm.AccessType AND tzmd.CountryID = tzm.CountryID AND tzmd.OriginationCode = tzm.OriginationCode AND tzmd.Code = tzm.Code AND tzmd.City = tzm.City AND tzmd.Tariff = tzm.Tariff AND tzmd.CostPerMinute IS NOT NULL )
						WHERE tzm.CostPerMinute IS NOT NULL;

						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.TimezonesID = a.TimezonesID AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff
						SET minute_OutpaymentPerMinute = @p_Minutes /  (select IF(count(DISTINCT tzmd.OriginationCode)=0,1,count(DISTINCT tzmd.OriginationCode)) from tmp_timezone_minutes_2 tzmd WHERE tzmd.TimezonesID = tzm.TimezonesID AND tzmd.VendorConnectionID = tzm.VendorConnectionID AND tzmd.AccessType = tzm.AccessType AND tzmd.CountryID = tzm.CountryID AND tzmd.OriginationCode = tzm.OriginationCode AND tzmd.Code = tzm.Code AND tzmd.City = tzm.City AND tzmd.Tariff = tzm.Tariff AND tzmd.OutpaymentPerMinute IS NOT NULL)
						WHERE tzm.OutpaymentPerMinute IS NOT NULL;

						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.TimezonesID = a.TimezonesID AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff
						SET minute_SurchargePerMinute = @p_Minutes /  (select IF(count(DISTINCT tzmd.OriginationCode)=0,1,count(DISTINCT tzmd.OriginationCode)) from tmp_timezone_minutes_2 tzmd WHERE tzmd.TimezonesID = tzm.TimezonesID AND tzmd.VendorConnectionID = a.VendorConnectionID AND tzmd.AccessType = a.AccessType AND tzmd.CountryID = a.CountryID AND tzmd.OriginationCode = tzm.OriginationCode AND tzmd.Code = a.Code AND tzmd.City = a.City AND tzmd.Tariff = a.Tariff AND tzmd.SurchargePerMinute IS NOT NULL)
						WHERE tzm.SurchargePerMinute IS NOT NULL;

						
						-- calls
						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.TimezonesID = a.TimezonesID AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff
						SET calls_OutpaymentPerCall =  @p_Calls /  (select IF(count(DISTINCT tzmd.OriginationCode)=0,1,count(DISTINCT tzmd.OriginationCode)) from tmp_timezone_minutes_2 tzmd 
                        WHERE tzmd.TimezonesID = tzm.TimezonesID AND tzmd.VendorConnectionID = tzm.VendorConnectionID AND tzmd.AccessType = tzm.AccessType AND tzmd.CountryID = tzm.CountryID AND tzmd.OriginationCode = tzm.OriginationCode AND tzmd.Code = tzm.Code AND tzmd.City = tzm.City AND tzmd.Tariff = tzm.Tariff 
						AND tzmd.OutpaymentPerCall IS NOT NULL )
						WHERE tzm.OutpaymentPerCall IS NOT NULL;

						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.TimezonesID = a.TimezonesID AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff
						SET calls_Surcharges = @p_Calls /  (select IF(count(DISTINCT tzmd.OriginationCode)=0,1,count(DISTINCT tzmd.OriginationCode)) from tmp_timezone_minutes_2 tzmd 
                        WHERE tzmd.TimezonesID = tzm.TimezonesID AND tzmd.VendorConnectionID = tzm.VendorConnectionID AND tzmd.AccessType = tzm.AccessType AND tzmd.CountryID = tzm.CountryID AND tzmd.OriginationCode = tzm.OriginationCode AND tzmd.Code = tzm.Code AND tzmd.City = tzm.City AND tzmd.Tariff = tzm.Tariff 
						AND tzmd.Surcharges IS NOT NULL)
						WHERE tzm.Surcharges IS NOT NULL;

						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.TimezonesID = a.TimezonesID AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff
						SET calls_SurchargePerCall = @p_Calls /  (select IF(count(DISTINCT tzmd.OriginationCode)=0,1,count(DISTINCT tzmd.OriginationCode)) from tmp_timezone_minutes_2 tzmd 
                        WHERE tzmd.TimezonesID = tzm.TimezonesID AND tzmd.VendorConnectionID = a.VendorConnectionID AND tzmd.AccessType = a.AccessType AND tzmd.CountryID = a.CountryID AND tzmd.OriginationCode = tzm.OriginationCode AND tzmd.Code = a.Code AND tzmd.City = a.City AND tzmd.Tariff = a.Tariff 
						AND tzmd.SurchargePerCall IS NOT NULL)
						WHERE tzm.SurchargePerCall IS NOT NULL;

						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.TimezonesID = a.TimezonesID AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff
						SET calls_CollectionCostAmount = @p_Calls /  (select IF(count(DISTINCT tzmd.OriginationCode)=0,1,count(DISTINCT tzmd.OriginationCode)) from tmp_timezone_minutes_2 tzmd 
                        WHERE tzmd.TimezonesID = tzm.TimezonesID AND tzmd.VendorConnectionID = tzm.VendorConnectionID AND tzmd.AccessType = tzm.AccessType AND tzmd.CountryID = tzm.CountryID AND tzmd.OriginationCode = tzm.OriginationCode AND tzmd.Code = tzm.Code AND tzmd.City = tzm.City AND tzmd.Tariff = tzm.Tariff 
						AND tzmd.CollectionCostAmount IS NOT NULL)
						WHERE tzm.CollectionCostAmount IS NOT NULL;

						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.TimezonesID = a.TimezonesID AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff
						SET calls_CostPerCall = @p_Calls /  (select IF(count(DISTINCT tzmd.OriginationCode)=0,1,count(DISTINCT tzmd.OriginationCode)) from tmp_timezone_minutes_2 tzmd 
                        WHERE tzmd.TimezonesID = tzm.TimezonesID AND tzmd.VendorConnectionID = a.VendorConnectionID AND tzmd.AccessType = a.AccessType AND tzmd.CountryID = a.CountryID AND tzmd.OriginationCode = tzm.OriginationCode AND tzmd.Code = a.Code AND tzmd.City = a.City AND tzmd.Tariff = a.Tariff 
						AND tzmd.CostPerCall IS NOT NULL)
						WHERE tzm.CostPerCall IS NOT NULL;

					END IF;



					--	if blank origination then full mins/calls
					-- minutes
					UPDATE  tmp_timezone_minutes SET minute_CostPerMinute = @p_Minutes WHERE OriginationCode = '' AND CostPerMinute IS NOT NULL;
					UPDATE  tmp_timezone_minutes SET minute_OutpaymentPerMinute = @p_Minutes WHERE OriginationCode = '' AND OutpaymentPerMinute IS NOT NULL;
					UPDATE  tmp_timezone_minutes SET minute_SurchargePerMinute = @p_Minutes WHERE OriginationCode = '' AND SurchargePerMinute IS NOT NULL;
					-- calls

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
						INNER JOIN tmp_accounts a FORCE INDEX(Index1) on tzm.TimezonesID = @p_Timezone AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff
						-- SET minute_CostPerMinute = ( (@p_Minutes/ 100) * @p_TimezonePercentage )
						SET minute_CostPerMinute = ( (minute_CostPerMinute/ 100) * @p_TimezonePercentage )
						WHERE tzm.CostPerMinute IS NOT NULL;

						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.TimezonesID = @p_Timezone AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff
						-- SET minute_OutpaymentPerMinute =  ( (@p_Minutes/ 100) * @p_TimezonePercentage )
						SET minute_OutpaymentPerMinute =  ( (minute_OutpaymentPerMinute/ 100) * @p_TimezonePercentage )
						WHERE tzm.OutpaymentPerMinute IS NOT NULL;

						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a FORCE INDEX(Index1) on tzm.TimezonesID = @p_Timezone AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff
						-- SET minute_SurchargePerMinute = ( (@p_Minutes/ 100) * @p_TimezonePercentage )
						SET minute_SurchargePerMinute = ( (minute_SurchargePerMinute/ 100) * @p_TimezonePercentage )
						WHERE tzm.SurchargePerMinute IS NOT NULL;

						-- Calls
						-- add percentage calls on selected timezones
						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a FORCE INDEX(Index1) on tzm.TimezonesID = @p_Timezone AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff
						-- SET minute_CostPerMinute = ( (@p_Minutes/ 100) * @p_TimezonePercentage )
						SET calls_OutpaymentPerCall = ( (calls_OutpaymentPerCall/ 100) * @p_TimezonePercentage )
						WHERE tzm.OutpaymentPerCall IS NOT NULL;

						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a FORCE INDEX(Index1) on tzm.TimezonesID = @p_Timezone AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff
						-- SET minute_OutpaymentPerMinute =  ( (@p_Minutes/ 100) * @p_TimezonePercentage )
						SET calls_Surcharges =  ( (calls_Surcharges/ 100) * @p_TimezonePercentage )
						WHERE tzm.Surcharges IS NOT NULL;

						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a FORCE INDEX(Index1) on tzm.TimezonesID = @p_Timezone AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff
						-- SET minute_SurchargePerMinute = ( (@p_Minutes/ 100) * @p_TimezonePercentage )
						SET calls_SurchargePerCall = ( (calls_SurchargePerCall/ 100) * @p_TimezonePercentage )
						WHERE tzm.SurchargePerCall IS NOT NULL;

						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a FORCE INDEX(Index1) on tzm.TimezonesID = @p_Timezone AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff
						-- SET minute_OutpaymentPerMinute =  ( (@p_Minutes/ 100) * @p_TimezonePercentage )
						SET calls_CollectionCostAmount =  ( (calls_CollectionCostAmount/ 100) * @p_TimezonePercentage )
						WHERE tzm.CollectionCostAmount IS NOT NULL;

						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a FORCE INDEX(Index1) on tzm.TimezonesID = @p_Timezone AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff
						-- SET minute_SurchargePerMinute = ( (@p_Minutes/ 100) * @p_TimezonePercentage )
						SET calls_CostPerCall = ( (calls_CostPerCall/ 100) * @p_TimezonePercentage )
						WHERE tzm.CostPerCall IS NOT NULL;
						
					
						 -- select * from  tmp_timezone_minutes ; -- TEST

						truncate table tmp_timezone_minutes_2;
						DROP TEMPORARY TABLE IF EXISTS tmp_timezone_minutes_3;
						CREATE TEMPORARY TABLE tmp_timezone_minutes_3 LIKE tmp_timezone_minutes;


						INSERT INTO tmp_timezone_minutes_2 SELECT * FROM tmp_timezone_minutes where TimezonesID != @v_default_TimezonesID;
						INSERT INTO tmp_timezone_minutes_3 SELECT * FROM tmp_timezone_minutes where TimezonesID != @v_default_TimezonesID;


						-- minutes
						-- add remaining minute on remaining timezones
						UPDATE  tmp_timezone_minutes tzm FORCE INDEX(Index1,Index2)
						INNER JOIN tmp_accounts a FORCE INDEX(Index1) on  tzm.TimezonesID != @v_default_TimezonesID AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.TimezonesID != @p_Timezone AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff
						SET minute_CostPerMinute = ( minute_CostPerMinute /*@p_Minutes*/ - IFNULL((select tzmd2.minute_CostPerMinute 
																			from tmp_timezone_minutes_3 tzmd2 FORCE INDEX(Index1,Index2) WHERE tzmd2.TimezonesID = @p_Timezone AND tzmd2.VendorConnectionID = a.VendorConnectionID AND tzmd2.AccessType = a.AccessType AND tzmd2.CountryID = a.CountryID AND tzmd2.OriginationCode = a.OriginationCode AND tzmd2.Code = a.Code AND tzmd2.City = a.City 
																			AND tzmd2.Tariff = a.Tariff AND tzmd2.CostPerMinute IS NOT NULL LIMIT 1 ),0) )   
														/ (  select IF(count(*) = 0,1,count(*))  from tmp_timezone_minutes_2 tzmd FORCE INDEX(Index1,Index2) WHERE tzmd.TimezonesID != @p_Timezone AND tzmd.VendorConnectionID = a.VendorConnectionID AND tzmd.AccessType = a.AccessType AND tzmd.CountryID = a.CountryID AND tzmd.OriginationCode = a.OriginationCode AND tzmd.Code = a.Code AND tzmd.City = a.City 
														AND tzmd.Tariff = a.Tariff AND tzmd.CostPerMinute IS NOT NULL) 
						WHERE tzm.CostPerMinute IS NOT NULL;

						
						UPDATE  tmp_timezone_minutes tzm FORCE INDEX(Index1,Index2)
						INNER JOIN tmp_accounts a FORCE INDEX(Index1) on  tzm.TimezonesID != @v_default_TimezonesID AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.TimezonesID != @p_Timezone AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff
						SET minute_OutpaymentPerMinute = ( minute_OutpaymentPerMinute /*@p_Minutes*/ - IFNULL((select tzmd2.minute_OutpaymentPerMinute 
																			from tmp_timezone_minutes_3 tzmd2 FORCE INDEX(Index1,Index2) WHERE tzmd2.TimezonesID = @p_Timezone AND tzmd2.VendorConnectionID = a.VendorConnectionID AND tzmd2.AccessType = a.AccessType AND tzmd2.CountryID = a.CountryID AND tzmd2.OriginationCode = a.OriginationCode AND tzmd2.Code = a.Code AND tzmd2.City = a.City 
																			AND tzmd2.Tariff = a.Tariff AND tzmd2.OutpaymentPerMinute IS NOT NULL LIMIT 1 ),0) )   
														/ (  select IF(count(*) = 0,1,count(*))  from tmp_timezone_minutes_2 tzmd FORCE INDEX(Index1,Index2) WHERE tzmd.TimezonesID != @p_Timezone AND tzmd.VendorConnectionID = a.VendorConnectionID AND tzmd.AccessType = a.AccessType AND tzmd.CountryID = a.CountryID AND tzmd.OriginationCode = a.OriginationCode AND tzmd.Code = a.Code AND tzmd.City = a.City 
														AND tzmd.Tariff = a.Tariff AND tzmd.OutpaymentPerMinute IS NOT NULL) 
						WHERE tzm.OutpaymentPerMinute IS NOT NULL;
						
						UPDATE  tmp_timezone_minutes tzm FORCE INDEX(Index1,Index2)
						INNER JOIN tmp_accounts a FORCE INDEX(Index1) on tzm.TimezonesID != @v_default_TimezonesID AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.TimezonesID != @p_Timezone AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff
						SET minute_SurchargePerMinute = ( minute_SurchargePerMinute /*@p_Minutes*/ - IFNULL((select tzmd2.minute_SurchargePerMinute 
																			from tmp_timezone_minutes_3 tzmd2 FORCE INDEX(Index1,Index2) WHERE (tzmd2.TimezonesID = @p_Timezone) AND tzmd2.VendorConnectionID = a.VendorConnectionID AND tzmd2.AccessType = a.AccessType AND tzmd2.CountryID = a.CountryID AND tzmd2.OriginationCode = a.OriginationCode AND tzmd2.Code = a.Code AND tzmd2.City = a.City 
																			AND tzmd2.Tariff = a.Tariff AND tzmd2.SurchargePerMinute IS NOT NULL LIMIT 1 ),0) )   
														/ (  select IF(count(*) = 0,1,count(*))  from tmp_timezone_minutes_2 tzmd FORCE INDEX(Index1,Index2) WHERE tzmd.TimezonesID != @p_Timezone AND tzmd.VendorConnectionID = a.VendorConnectionID AND tzmd.AccessType = a.AccessType AND tzmd.CountryID = a.CountryID AND tzmd.OriginationCode = a.OriginationCode AND tzmd.Code = a.Code AND tzmd.City = a.City 
														AND tzmd.Tariff = a.Tariff AND tzmd.SurchargePerMinute IS NOT NULL) 
						WHERE tzm.SurchargePerMinute IS NOT NULL;
						

						-- calls
						-- add remaining calls on remaining timezones
						UPDATE  tmp_timezone_minutes tzm FORCE INDEX(Index1,Index2)
						INNER JOIN tmp_accounts a FORCE INDEX(Index1) on tzm.TimezonesID != @v_default_TimezonesID AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.TimezonesID != @p_Timezone AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff
						SET calls_OutpaymentPerCall = ( calls_OutpaymentPerCall /*@p_Minutes*/ - IFNULL((select tzmd2.calls_OutpaymentPerCall 
																			from tmp_timezone_minutes_3 tzmd2 FORCE INDEX(Index1,Index2) WHERE tzmd2.TimezonesID = @p_Timezone AND tzmd2.VendorConnectionID = a.VendorConnectionID AND tzmd2.AccessType = a.AccessType AND tzmd2.CountryID = a.CountryID AND tzmd2.OriginationCode = a.OriginationCode AND tzmd2.Code = a.Code AND tzmd2.City = a.City 
																			AND tzmd2.Tariff = a.Tariff AND tzmd2.OutpaymentPerCall IS NOT NULL LIMIT 1 ),0) )   
														/ (  select IF(count(*) = 0,1,count(*))  from tmp_timezone_minutes_2 tzmd FORCE INDEX(Index1,Index2) WHERE tzmd.TimezonesID != @p_Timezone AND tzmd.VendorConnectionID = a.VendorConnectionID AND tzmd.AccessType = a.AccessType AND tzmd.CountryID = a.CountryID AND tzmd.OriginationCode = a.OriginationCode AND tzmd.Code = a.Code AND tzmd.City = a.City 
														AND tzmd.Tariff = a.Tariff AND tzmd.OutpaymentPerCall IS NOT NULL) 
						WHERE tzm.OutpaymentPerCall IS NOT NULL;

						
						UPDATE  tmp_timezone_minutes tzm FORCE INDEX(Index1,Index2)
						INNER JOIN tmp_accounts a FORCE INDEX(Index1) on tzm.TimezonesID != @v_default_TimezonesID AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.TimezonesID != @p_Timezone AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff
						SET calls_Surcharges = ( calls_Surcharges /*@p_Minutes*/ - IFNULL((select tzmd2.calls_Surcharges 
																			from tmp_timezone_minutes_3 tzmd2 FORCE INDEX(Index1,Index2) WHERE tzmd2.TimezonesID = @p_Timezone AND tzmd2.VendorConnectionID = a.VendorConnectionID AND tzmd2.AccessType = a.AccessType AND tzmd2.CountryID = a.CountryID AND tzmd2.OriginationCode = a.OriginationCode AND tzmd2.Code = a.Code AND tzmd2.City = a.City 
																			AND tzmd2.Tariff = a.Tariff AND tzmd2.Surcharges IS NOT NULL LIMIT 1 ),0) )   
														/ (  select IF(count(*) = 0,1,count(*))  from tmp_timezone_minutes_2 tzmd FORCE INDEX(Index1,Index2) WHERE tzmd.TimezonesID != @p_Timezone AND tzmd.VendorConnectionID = a.VendorConnectionID AND tzmd.AccessType = a.AccessType AND tzmd.CountryID = a.CountryID AND tzmd.OriginationCode = a.OriginationCode AND tzmd.Code = a.Code AND tzmd.City = a.City 
														AND tzmd.Tariff = a.Tariff AND tzmd.Surcharges IS NOT NULL) 
						WHERE tzm.Surcharges IS NOT NULL;
						
						UPDATE  tmp_timezone_minutes tzm FORCE INDEX(Index1,Index2)
						INNER JOIN tmp_accounts a FORCE INDEX(Index1) on tzm.TimezonesID != @v_default_TimezonesID AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.TimezonesID != @p_Timezone AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff
						SET calls_SurchargePerCall = ( calls_SurchargePerCall /*@p_Minutes*/ - IFNULL((select tzmd2.calls_SurchargePerCall 
																			from tmp_timezone_minutes_3 tzmd2 FORCE INDEX(Index1,Index2) WHERE (tzmd2.TimezonesID = @p_Timezone) AND tzmd2.VendorConnectionID = a.VendorConnectionID AND tzmd2.AccessType = a.AccessType AND tzmd2.CountryID = a.CountryID AND tzmd2.OriginationCode = a.OriginationCode AND tzmd2.Code = a.Code AND tzmd2.City = a.City 
																			AND tzmd2.Tariff = a.Tariff AND tzmd2.SurchargePerCall IS NOT NULL LIMIT 1 ),0) )   
														/ (  select IF(count(*) = 0,1,count(*))  from tmp_timezone_minutes_2 tzmd FORCE INDEX(Index1,Index2) WHERE tzmd.TimezonesID != @p_Timezone AND tzmd.VendorConnectionID = a.VendorConnectionID AND tzmd.AccessType = a.AccessType AND tzmd.CountryID = a.CountryID AND tzmd.OriginationCode = a.OriginationCode AND tzmd.Code = a.Code AND tzmd.City = a.City 
														AND tzmd.Tariff = a.Tariff AND tzmd.SurchargePerCall IS NOT NULL) 
						WHERE tzm.SurchargePerCall IS NOT NULL;

						UPDATE  tmp_timezone_minutes tzm FORCE INDEX(Index1,Index2)
						INNER JOIN tmp_accounts a FORCE INDEX(Index1) on tzm.TimezonesID != @v_default_TimezonesID AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.TimezonesID != @p_Timezone AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff
						SET calls_CollectionCostAmount = ( calls_CollectionCostAmount /*@p_Minutes*/ - IFNULL((select tzmd2.calls_CollectionCostAmount 
																			from tmp_timezone_minutes_3 tzmd2 FORCE INDEX(Index1,Index2) WHERE tzmd2.TimezonesID = @p_Timezone AND tzmd2.VendorConnectionID = a.VendorConnectionID AND tzmd2.AccessType = a.AccessType AND tzmd2.CountryID = a.CountryID AND tzmd2.OriginationCode = a.OriginationCode AND tzmd2.Code = a.Code AND tzmd2.City = a.City 
																			AND tzmd2.Tariff = a.Tariff AND tzmd2.CollectionCostAmount IS NOT NULL LIMIT 1 ),0) )   
														/ (  select IF(count(*) = 0,1,count(*))  from tmp_timezone_minutes_2 tzmd FORCE INDEX(Index1,Index2) WHERE tzmd.TimezonesID != @p_Timezone AND tzmd.VendorConnectionID = a.VendorConnectionID AND tzmd.AccessType = a.AccessType AND tzmd.CountryID = a.CountryID AND tzmd.OriginationCode = a.OriginationCode AND tzmd.Code = a.Code AND tzmd.City = a.City 
														AND tzmd.Tariff = a.Tariff AND tzmd.CollectionCostAmount IS NOT NULL) 
						WHERE tzm.CollectionCostAmount IS NOT NULL;
						
						UPDATE  tmp_timezone_minutes tzm FORCE INDEX(Index1,Index2)
						INNER JOIN tmp_accounts a FORCE INDEX(Index1) on tzm.TimezonesID != @v_default_TimezonesID AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.TimezonesID != @p_Timezone AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff
						SET calls_CostPerCall = ( calls_CostPerCall /*@p_Minutes*/ - IFNULL((select tzmd2.calls_CostPerCall 
																			from tmp_timezone_minutes_3 tzmd2 FORCE INDEX(Index1,Index2) WHERE (tzmd2.TimezonesID = @p_Timezone) AND tzmd2.VendorConnectionID = a.VendorConnectionID AND tzmd2.AccessType = a.AccessType AND tzmd2.CountryID = a.CountryID AND tzmd2.OriginationCode = a.OriginationCode AND tzmd2.Code = a.Code AND tzmd2.City = a.City 
																			AND tzmd2.Tariff = a.Tariff AND tzmd2.CostPerCall IS NOT NULL LIMIT 1 ),0) )   
														/ (  select IF(count(*) = 0,1,count(*))  from tmp_timezone_minutes_2 tzmd FORCE INDEX(Index1,Index2) WHERE tzmd.TimezonesID != @p_Timezone AND tzmd.VendorConnectionID = a.VendorConnectionID AND tzmd.AccessType = a.AccessType AND tzmd.CountryID = a.CountryID AND tzmd.OriginationCode = a.OriginationCode AND tzmd.Code = a.Code AND tzmd.City = a.City 
														AND tzmd.Tariff = a.Tariff AND tzmd.CostPerCall IS NOT NULL) 
						WHERE tzm.CostPerCall IS NOT NULL;



							

					ELSE 


						truncate table tmp_timezone_minutes_2;

						INSERT INTO tmp_timezone_minutes_2 SELECT * FROM tmp_timezone_minutes where TimezonesID != @v_default_TimezonesID;

						-- Minutes						
						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a FORCE INDEX(Index1) on tzm.TimezonesID != @v_default_TimezonesID AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff
						SET minute_CostPerMinute =  minute_CostPerMinute /*@p_Minutes*/ /  (select IF(count(DISTINCT tzmd.TimezonesID)=0,1,count(DISTINCT tzmd.TimezonesID)) from tmp_timezone_minutes_2 tzmd WHERE  tzmd.VendorConnectionID = tzm.VendorConnectionID AND tzmd.AccessType = tzm.AccessType AND tzmd.CountryID = tzm.CountryID AND tzmd.OriginationCode = tzm.OriginationCode AND tzmd.Code = tzm.Code AND tzmd.City = tzm.City AND tzmd.Tariff = tzm.Tariff AND tzmd.CostPerMinute IS NOT NULL )
						WHERE tzm.CostPerMinute IS NOT NULL;

						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a FORCE INDEX(Index1) on tzm.TimezonesID != @v_default_TimezonesID AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff
						SET minute_OutpaymentPerMinute = minute_OutpaymentPerMinute /*@p_Minutes*/ /  (select IF(count(DISTINCT tzmd.TimezonesID)=0,1,count(DISTINCT tzmd.TimezonesID)) from tmp_timezone_minutes_2 tzmd WHERE  tzmd.VendorConnectionID = tzm.VendorConnectionID AND tzmd.AccessType = tzm.AccessType AND tzmd.CountryID = tzm.CountryID AND tzmd.OriginationCode = tzm.OriginationCode AND tzmd.Code = tzm.Code AND tzmd.City = tzm.City AND tzmd.Tariff = tzm.Tariff AND tzmd.OutpaymentPerMinute IS NOT NULL)
						WHERE tzm.OutpaymentPerMinute IS NOT NULL;

						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a FORCE INDEX(Index1) on tzm.TimezonesID != @v_default_TimezonesID AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff
						SET minute_SurchargePerMinute = minute_SurchargePerMinute /*@p_Minutes*/ /  (select IF(count(DISTINCT tzmd.TimezonesID)=0,1,count(DISTINCT tzmd.TimezonesID)) from tmp_timezone_minutes_2 tzmd WHERE  tzmd.VendorConnectionID = a.VendorConnectionID AND tzmd.AccessType = a.AccessType AND tzmd.CountryID = a.CountryID AND tzmd.OriginationCode = tzm.OriginationCode AND tzmd.Code = a.Code AND tzmd.City = a.City AND tzmd.Tariff = a.Tariff AND tzmd.SurchargePerMinute IS NOT NULL)
						WHERE tzm.SurchargePerMinute IS NOT NULL;

						-- Calls						
						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a FORCE INDEX(Index1) on tzm.TimezonesID != @v_default_TimezonesID AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff
						SET calls_OutpaymentPerCall =  calls_OutpaymentPerCall /*@p_Minutes*/ /  (select IF(count(DISTINCT tzmd.TimezonesID)=0,1,count(DISTINCT tzmd.TimezonesID)) from tmp_timezone_minutes_2 tzmd WHERE  tzmd.VendorConnectionID = tzm.VendorConnectionID AND tzmd.AccessType = tzm.AccessType AND tzmd.CountryID = tzm.CountryID AND tzmd.OriginationCode = tzm.OriginationCode AND tzmd.Code = tzm.Code AND tzmd.City = tzm.City AND tzmd.Tariff = tzm.Tariff 
						AND tzmd.OutpaymentPerCall IS NOT NULL )
						WHERE tzm.OutpaymentPerCall IS NOT NULL;

						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a FORCE INDEX(Index1) on tzm.TimezonesID != @v_default_TimezonesID AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff
						SET calls_Surcharges = calls_Surcharges /*@p_Minutes*/ /  (select IF(count(DISTINCT tzmd.TimezonesID)=0,1,count(DISTINCT tzmd.TimezonesID)) from tmp_timezone_minutes_2 tzmd WHERE  tzmd.VendorConnectionID = tzm.VendorConnectionID AND tzmd.AccessType = tzm.AccessType AND tzmd.CountryID = tzm.CountryID AND tzmd.OriginationCode = tzm.OriginationCode AND tzmd.Code = tzm.Code AND tzmd.City = tzm.City AND tzmd.Tariff = tzm.Tariff 
						AND tzmd.Surcharges IS NOT NULL)
						WHERE tzm.Surcharges IS NOT NULL;

						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a FORCE INDEX(Index1) on tzm.TimezonesID != @v_default_TimezonesID AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff
						SET calls_SurchargePerCall = calls_SurchargePerCall /*@p_Minutes*/ /  (select IF(count(DISTINCT tzmd.TimezonesID)=0,1,count(DISTINCT tzmd.TimezonesID)) from tmp_timezone_minutes_2 tzmd WHERE  tzmd.VendorConnectionID = a.VendorConnectionID AND tzmd.AccessType = a.AccessType AND tzmd.CountryID = a.CountryID AND tzmd.OriginationCode = tzm.OriginationCode AND tzmd.Code = a.Code AND tzmd.City = a.City AND tzmd.Tariff = a.Tariff 
						AND tzmd.SurchargePerCall IS NOT NULL)
						WHERE tzm.SurchargePerCall IS NOT NULL;

						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a FORCE INDEX(Index1) on tzm.VendorConnectionID = a.VendorConnectionID
						SET calls_CollectionCostAmount = calls_CollectionCostAmount /*@p_Minutes*/ /  (select IF(count(DISTINCT tzmd.TimezonesID)=0,1,count(DISTINCT tzmd.TimezonesID)) from tmp_timezone_minutes_2 tzmd WHERE  tzmd.VendorConnectionID = tzm.VendorConnectionID AND tzmd.AccessType = tzm.AccessType AND tzmd.CountryID = tzm.CountryID AND tzmd.OriginationCode = tzm.OriginationCode AND tzmd.Code = tzm.Code AND tzmd.City = tzm.City AND tzmd.Tariff = tzm.Tariff 
						AND tzmd.CollectionCostAmount IS NOT NULL)
						WHERE (tzm.TimezonesID != @v_default_TimezonesID ) AND   tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff 
						AND tzm.CollectionCostAmount IS NOT NULL;

						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a FORCE INDEX(Index1) on tzm.TimezonesID != @v_default_TimezonesID AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.AccessType = a.AccessType AND tzm.CountryID = a.CountryID AND tzm.OriginationCode = a.OriginationCode AND tzm.Code = a.Code AND tzm.City = a.City AND tzm.Tariff = a.Tariff
						SET calls_CostPerCall = calls_CostPerCall /*@p_Minutes*/ /  (select IF(count(DISTINCT tzmd.TimezonesID)=0,1,count(DISTINCT tzmd.TimezonesID)) from tmp_timezone_minutes_2 tzmd WHERE  tzmd.VendorConnectionID = a.VendorConnectionID AND tzmd.AccessType = a.AccessType AND tzmd.CountryID = a.CountryID AND tzmd.OriginationCode = tzm.OriginationCode AND tzmd.Code = a.Code AND tzmd.City = a.City AND tzmd.Tariff = a.Tariff 
						AND tzmd.CostPerCall IS NOT NULL)
						WHERE tzm.CostPerCall IS NOT NULL;

					END IF;


 
			END IF;


			-- select * from  tmp_timezone_minutes ; -- TEST
			
			-- leave ThisSP;
			-- calculate months
			SET @v_days =    TIMESTAMPDIFF(DAY, (SELECT @p_StartDate), (SELECT @p_EndDate)) + 1 ;
			SET @v_period1 =      IF(MONTH((SELECT @p_StartDate)) = MONTH((SELECT @p_EndDate)), 0, (TIMESTAMPDIFF(DAY, (SELECT @p_StartDate), LAST_DAY((SELECT @p_StartDate)) + INTERVAL 0 DAY)) / DAY(LAST_DAY((SELECT @p_StartDate))));
			SET @v_period2 =      TIMESTAMPDIFF(MONTH, LAST_DAY((SELECT @p_StartDate)) + INTERVAL 1 DAY, LAST_DAY((SELECT @p_EndDate))) ;
			SET @v_period3 =      IF(MONTH((SELECT @p_StartDate)) = MONTH((SELECT @p_EndDate)), (SELECT @v_days), DAY((SELECT @p_EndDate))) / DAY(LAST_DAY((SELECT @p_EndDate)));
			SET @p_months =     (SELECT @v_period1) + (SELECT @v_period2) + (SELECT @v_period3);

			SET @p_months = Round(@p_months,1); -- fn_Round(@p_months,1);



			
			-- step 1 currency conversion 
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
								IFNULL(r2.Code,'') as OriginationCode,
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


		-- NOTE: as per LCR remove records not exitst in tmp_timezone_minutes
 		DELETE drtr FROM tmp_tblRateTableDIDRate_step1 drtr
		LEFT JOIN  tmp_timezone_minutes tm on drtr.TimezonesID = tm.TimezonesID   and drtr.VendorConnectionID = tm.VendorConnectionID 
		AND drtr.AccessType = tm.AccessType AND drtr.CountryID = tm.CountryID and drtr.OriginationCode = tm.OriginationCode AND drtr.Code = tm.Code AND drtr.City = tm.City AND  drtr.Tariff  = tm.Tariff
		where tm.VendorConnectionID IS NULL;
	 
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
		insert into tmp_tblRateTableDIDRate_step1_dup (VendorConnectionID,  TimezonesID, AccessType, CountryID,  Code, City, Tariff )
		select  VendorConnectionID,  max(TimezonesID) as TimezonesID, AccessType, CountryID, Code,City, Tariff 
		from tmp_tblRateTableDIDRate_step1 FORCE INDEX (Index1,Index2)
		where  MonthlyCost > 0
		group by  VendorConnectionID,  AccessType, CountryID, CountryPrefix, Code,City, Tariff ;

	
		update tmp_tblRateTableDIDRate_step1 svr FORCE INDEX (Index1,Index2)
		INNER JOIN tmp_tblRateTableDIDRate_step1_dup svr2  FORCE INDEX (Index1,Index2) on 
					svr.TimezonesID != svr2.TimezonesID AND 
					svr.VendorConnectionID = svr2.VendorConnectionID AND 
					svr.AccessType = svr2.AccessType AND 
					svr.CountryID = svr2.CountryID AND 
					-- svr.OriginationCode = svr2.OriginationCode AND 
					svr.Code = svr2.Code AND 
					svr.City = svr2.City AND 
					svr.Tariff = svr2.Tariff 
		SET svr.MonthlyCost = 0
		where svr.MonthlyCost > 0 and svr2.TimezonesID is not null and svr.TimezonesID is not null;


		-- do same for same timezone and different Origination.
		truncate table tmp_tblRateTableDIDRate_step1_dup;
		insert into tmp_tblRateTableDIDRate_step1_dup (VendorConnectionID, OriginationCode, TimezonesID, AccessType, CountryID,  Code, City, Tariff )
		select  VendorConnectionID, max(OriginationCode) as OriginationCode, max(TimezonesID) as TimezonesID, AccessType, CountryID,  Code,City, Tariff 
		from tmp_tblRateTableDIDRate_step1  FORCE INDEX (Index1,Index2)
		where  MonthlyCost > 0
		group by  VendorConnectionID,  AccessType, CountryID, CountryPrefix, Code,City, Tariff ;


		update tmp_tblRateTableDIDRate_step1 svr FORCE INDEX (Index1,Index2)
		INNER JOIN tmp_tblRateTableDIDRate_step1_dup svr2 FORCE INDEX (Index1,Index2) on 
					svr.TimezonesID = svr2.TimezonesID AND 
					svr.VendorConnectionID = svr2.VendorConnectionID AND 
					svr.AccessType = svr2.AccessType AND 
					svr.CountryID = svr2.CountryID AND 
					svr.OriginationCode != svr2.OriginationCode AND 
					svr.Code = svr2.Code AND 
					svr.City = svr2.City AND 
					svr.Tariff = svr2.Tariff 
		SET svr.MonthlyCost = 0
		where svr.MonthlyCost > 0 and svr2.TimezonesID is not null and svr.TimezonesID is not null;


			-- step 2 find Total
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
						INNER JOIN  tmp_timezone_minutes tm on 
							drtr.TimezonesID = tm.TimezonesID   
						and drtr.VendorConnectionID = tm.VendorConnectionID 
						AND drtr.AccessType = tm.AccessType 
						AND drtr.CountryID = tm.CountryID 
						and drtr.OriginationCode = tm.OriginationCode 
						AND drtr.Code = tm.Code 
						AND drtr.City = tm.City 
						AND drtr.Tariff  = tm.Tariff;


						-- just for testing -- TEST
						/*select  
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
				
			-- select * from tmp_table_without_origination; -- TEST

				-- step 3 remove  records where  Total is null
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
				from
				tmp_table_without_origination

				where Total is not null;

					 

		-- single record per row -  group by AccessType,CountryID,City,Tariff,OriginationCode,Code,VendorConnectionID,TimezonesID

      insert into tmp_table_output_1
      (AccessType ,CountryID ,City ,Tariff,Code ,VendorConnectionID ,VendorConnectionName,EffectiveDate,Total)
      select AccessType ,CountryID ,City ,Tariff,Code ,VendorConnectionID ,VendorConnectionName,max(EffectiveDate),sum(Total) as Total
      from tmp_table1_
      group by VendorConnectionID,VendorConnectionName,AccessType,CountryID ,Code,City,Tariff;


	-- LEAVE ThisSP;

		-- order vendors in posision.

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

		-- display records 
  		SET @stm_columns = "";

      IF @p_isExport = 0 AND @p_Position > 10 THEN
        SET @p_Position = 10;
      END IF;



			SET @v_pointer_ = 1;
			WHILE @v_pointer_ <= @p_Position
			DO

          SET @stm_columns = CONCAT(@stm_columns, "GROUP_CONCAT(if(vPosition = ",@v_pointer_,", CONCAT(Total, '<br>', VendorConnectionName, '<br>', DATE_FORMAT(EffectiveDate, '%d/%m/%Y'),'' ), NULL) ) AS `POSITION ",@v_pointer_,"`,");

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