use speakintelligentRM;
DROP PROCEDURE IF EXISTS `prc_GetPackageLCR`;
DELIMITER //
CREATE PROCEDURE `prc_GetPackageLCR`(
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
        SET @p_Calls            =   p_Calls;		-- Not in Use
        SET @p_Minutes            =   p_Minutes;
        SET @p_Timezone            =   p_Timezone;
        SET @p_TimezonePercentage            =   p_TimezonePercentage;
        SET @p_StartDate            =   p_StartDate;
        SET @p_EndDate            =   p_EndDate;
        SET @p_PageNumber            =   p_PageNumber;
        SET @p_RowspPage            =   p_RowspPage;
        SET @p_SortOrder            =   p_SortOrder;
        SET @p_isExport            =   p_isExport;


        SET	@v_RateTypeID = 3;	-- //1 - Termination,  2 - DID,   3 - Package

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

 
            
			IF /*@p_Calls = 0 AND*/ @p_Minutes = 0 THEN

				-- AccountID is not confirmed yet by Sumera in CDR

				insert into tmp_timezone_minutes (TimezonesID,PackageID, PackageCostPerMinute,RecordingCostPerMinute)

				select PackageTimezonesID  , AccountServicePackageID, sum(PackageCostPerMinute)  ,sum(RecordingCostPerMinute)  

				from speakintelligentCDR.tblUsageDetails  d

				inner join speakintelligentCDR.tblUsageHeader h on d.UsageHeaderID = h.UsageHeaderID

				where StartDate >= @p_StartDate AND StartDate <= @p_EndDate 

                AND d.is_inbound = 1 

				AND ( @p_PackageId = 0 OR d.AccountServicePackageID = @p_PackageId  )

				group by PackageTimezonesID  , AccountServicePackageID;


			ELSE

					/*
					Minutes = 50
					%		= 20
					Timezone = Peak (10)

					AccountID  PackageID TimezoneID 	PackageCostPerMinute RecordingCostPerMinute
						1					Peak			NULL				0.5
						1					Off-Peak		0.5					NULL
						1					Default			NULL				0.5


					AccountID  PackageID TimezoneID 	minutes_PackageCostPerMinute minutes_RecordingCostPerMinute
						1					Peak			0							0.5 * 10
						1					Off-Peak		0.5 * 50					NULL
						1					Default			NULL						0.5 * 40

					*/

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


					-- INSERT INTO tmp_timezone_minutes_2 SELECT * FROM tmp_timezone_minutes;
					-- INSERT INTO tmp_timezone_minutes_3 SELECT * FROM tmp_timezone_minutes;

					insert into tmp_timezones (TimezonesID) select TimezonesID from tblTimezones;

					SET @v_rowCount_ = ( SELECT COUNT(*) FROM tmp_timezones );

					SET @p_TimeZonePercentage	 		 = @p_TimezonePercentage;
				

					SET @v_default_TimezonesID = ( SELECT TimezonesID from tblTimezones where Title = 'Default' );

					-- // account loop

					INSERT INTO tmp_accounts ( VendorConnectionID , PackageID )  SELECT DISTINCT VendorConnectionID , PackageID FROM tmp_timezone_minutes order by VendorConnectionID , PackageID;

					IF @p_TimeZonePercentage > 0 THEN

						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET minute_PackageCostPerMinute = ( (@p_Minutes/ 100) * @p_TimeZonePercentage )
												
						WHERE  tzm.TimezonesID = @p_Timezone AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.PackageID = a.PackageID AND tzm.PackageCostPerMinute IS NOT NULL;

						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET minute_RecordingCostPerMinute =  ( (@p_Minutes/ 100) * @p_TimeZonePercentage )
												
						WHERE  tzm.TimezonesID = @p_Timezone AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.PackageID = a.PackageID AND tzm.RecordingCostPerMinute IS NOT NULL;

					

						-- truncate and update latest to have latest updated miutes 
						truncate table tmp_timezone_minutes_2;
						truncate table tmp_timezone_minutes_3;


						INSERT INTO tmp_timezone_minutes_2 SELECT * FROM tmp_timezone_minutes where TimezonesID != @v_default_TimezonesID;
						INSERT INTO tmp_timezone_minutes_3 SELECT * FROM tmp_timezone_minutes where TimezonesID != @v_default_TimezonesID;



						-- SET Remaining Timezone minutes  
						/*LOGIC: 
							minute_PackageCostPerMinute = @p_Minutes - (SELECTED TIMEZONE MINUTES) / NOT SELECTED TIMEZONES RECORD COUNT
						*/

						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET minute_PackageCostPerMinute = ( @p_Minutes - IFNULL((select tzmd2.minute_PackageCostPerMinute from tmp_timezone_minutes_3 tzmd2 WHERE tzmd2.TimezonesID = @p_Timezone AND tzmd2.VendorConnectionID = a.VendorConnectionID AND tzmd2.PackageID = a.PackageID AND  tzmd2.PackageCostPerMinute IS NOT NULL LIMIT 1),0) )   
														/ (  select IF(count(*) = 0 , 1,count(*) )  from tmp_timezone_minutes_2 tzmd WHERE tzmd.TimezonesID != @p_Timezone AND tzmd.VendorConnectionID = a.VendorConnectionID AND tzmd.PackageID = a.PackageID  AND tzmd.PackageCostPerMinute IS NOT NULL) 
						WHERE  (tzm.TimezonesID != @v_default_TimezonesID AND tzm.TimezonesID != @p_Timezone) AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.PackageID = a.PackageID   AND tzm.PackageCostPerMinute IS NOT NULL;

						
						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET minute_RecordingCostPerMinute = ( @p_Minutes - IFNULL((select tzmd2.minute_RecordingCostPerMinute from tmp_timezone_minutes_3 tzmd2 WHERE tzmd2.TimezonesID = @p_Timezone AND tzmd2.VendorConnectionID = a.VendorConnectionID AND tzmd2.PackageID = a.PackageID AND  tzmd2.RecordingCostPerMinute IS NOT NULL LIMIT 1),0) )   
														/ (  select IF(count(*) = 0 , 1,count(*) )  from tmp_timezone_minutes_2 tzmd WHERE tzmd.TimezonesID != @p_Timezone AND tzmd.VendorConnectionID = a.VendorConnectionID AND tzmd.PackageID = a.PackageID AND tzmd.RecordingCostPerMinute IS NOT NULL ) 
						WHERE  (tzm.TimezonesID != @v_default_TimezonesID AND tzm.TimezonesID != @p_Timezone) AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.PackageID = a.PackageID  AND tzm.RecordingCostPerMinute IS NOT NULL;
						

						
					ELSE 

						truncate table tmp_timezone_minutes_2;
						INSERT INTO tmp_timezone_minutes_2 SELECT * FROM tmp_timezone_minutes;


						-- when p_TimeZonePercentage is blank equally distribute minutes
						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET minute_PackageCostPerMinute =  @p_Minutes /  (select IF(count(DISTINCT tzmd.TimezonesID) = 0 , 1,count(DISTINCT tzmd.TimezonesID) ) from tmp_timezone_minutes_2 tzmd WHERE tzmd.VendorConnectionID = tzm.VendorConnectionID AND tzmd.PackageID = tzm.PackageID AND tzmd.PackageCostPerMinute IS NOT NULL )
													
						WHERE  (tzm.TimezonesID != @v_default_TimezonesID ) AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.PackageID = a.PackageID AND tzm.PackageCostPerMinute IS NOT NULL;

						UPDATE  tmp_timezone_minutes tzm
						INNER JOIN tmp_accounts a on tzm.VendorConnectionID = a.VendorConnectionID
						SET minute_RecordingCostPerMinute = @p_Minutes /  (select IF(count(DISTINCT tzmd.TimezonesID) = 0 , 1,count(DISTINCT tzmd.TimezonesID) ) from tmp_timezone_minutes_2 tzmd WHERE tzmd.VendorConnectionID = tzm.VendorConnectionID AND tzmd.PackageID = tzm.PackageID AND tzmd.RecordingCostPerMinute IS NOT NULL)
												
						WHERE  (tzm.TimezonesID != @v_default_TimezonesID ) AND tzm.VendorConnectionID = a.VendorConnectionID AND tzm.PackageID = a.PackageID AND tzm.RecordingCostPerMinute IS NOT NULL;



					END IF;

					UPDATE  tmp_timezone_minutes SET minute_PackageCostPerMinute   = @p_Minutes WHERE TimezonesID != @v_default_TimezonesID AND PackageCostPerMinute IS NOT NULL;
					UPDATE  tmp_timezone_minutes SET minute_RecordingCostPerMinute = @p_Minutes WHERE TimezonesID != @v_default_TimezonesID AND RecordingCostPerMinute IS NOT NULL;



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



		/*
		Make following fields common against Timezones 
		Common MonthlyCost ,  
		
		STEP1: select single record which has MonthlyCost per product Single record of max TimezonesID
		STEP2: delete product MonthlyCost where TimezonesID!= MaxTimezonesID
		*/
			/*
			Make following fields common against Timezones 
			Common MonthlyCost , OneoffCost  
			*/
			 
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
        inner join tmp_timezone_minutes tm on tm.TimezonesID = drtr.TimezonesID AND tm.PackageID = drtr.PackageID AND ( tm.VendorConnectionID IS NULL OR drtr.VendorConnectionID = tm.VendorConnectionID ); -- Sumera Not confirmed yet Accountid for CDR

					 
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
                    
					CASE WHEN (@prev_PackageName = PackageName /*AND  @prev_VendorConnectionID = VendorConnectionID */ AND @prev_Total <  Total) THEN @vPosition + 1
					     WHEN (@prev_PackageName = PackageName /*AND  @prev_VendorConnectionID = VendorConnectionID */ AND @prev_Total =  Total) THEN @vPosition 
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

            SET @stm_columns = CONCAT(@stm_columns, "GROUP_CONCAT(if(vPosition = ",@v_pointer_,", CONCAT(Total, '<br>', VendorConnectionName, '<br>', DATE_FORMAT(EffectiveDate, '%d/%m/%Y'),'' ), NULL) SEPARATOR '<br>'  ) AS `POSITION ",@v_pointer_,"`,");

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