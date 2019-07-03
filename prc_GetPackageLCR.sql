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

-- Dumping structure for procedure speakintelligentRM.prc_GetPackageLCR
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
				AccountID int,
				PackageID int,
				PackageCostPerMinute DECIMAL(18,8), 
				RecordingCostPerMinute DECIMAL(18,8),
				minute_PackageCostPerMinute DECIMAL(18,2), 
				minute_RecordingCostPerMinute DECIMAL(18,2)
			);

			DROP TEMPORARY TABLE IF EXISTS tmp_accounts;
			CREATE TEMPORARY TABLE tmp_accounts (
				ID int auto_increment,
				AccountID int,
				PackageID int,
				Primary Key (ID )

			);

 
            
			IF /*@p_Calls = 0 AND*/ @p_Minutes = 0 THEN

				-- AccountID is not confirmed yet by Sumera in CDR

				insert into tmp_timezone_minutes (TimezonesID,PackageID, PackageCostPerMinute,RecordingCostPerMinute)

				select PackageTimezonesID  , AccountServicePackageID, sum(PackageCostPerMinute)  ,sum(RecordingCostPerMinute)  

				from speakintelligentCDR.tblUsageDetails  d

				inner join speakintelligentCDR.tblUsageHeader h on d.UsageHeaderID = h.UsageHeaderID

				where CompanyID = @p_companyid AND StartDate >= @p_StartDate AND StartDate <= @p_EndDate 

                AND d.is_inbound = 1 

				AND ( @p_PackageId = 0 OR d.AccountServicePackageID = @p_PackageId  )

				group by PackageTimezonesID  , AccountServicePackageID;


			ELSE

					/*
					Minutes = 50
					%		= 20
					Timezone = Peak (10)

					AccountID  TimezoneID 	PackageCostPerMinute RecordingCostPerMinute
						1		Peak			NULL				0.5
						1		Off-Peak		0.5					NULL
						1		Default			NULL				0.5


					AccountID  TimezoneID 	minutes_PackageCostPerMinute minutes_RecordingCostPerMinute
						1		Peak			0							0.5 * 10
						1		Off-Peak		0.5 * 50					NULL
						1		Default			NULL						0.5 * 40

					*/

					insert into tmp_timezone_minutes (AccountID, TimezonesID, PackageID, PackageCostPerMinute , RecordingCostPerMinute )
		
					Select 			distinct vc.AccountId,drtr.TimezonesID,pk.PackageID, drtr.PackageCostPerMinute,drtr.RecordingCostPerMinute
		
					FROM tblRateTablePKGRate  drtr
					INNER JOIN tblRateTable  rt ON rt.RateTableId = drtr.RateTableId 
					INNER JOIN tblVendorConnection vc ON vc.RateTableID = rt.RateTableId  AND vc.CompanyID = rt.CompanyId  AND vc.Active=1 AND vc.RateTypeID = @v_RateTypeID
					INNER JOIN tblAccount a ON vc.AccountId = a.AccountID AND rt.CompanyId = a.CompanyId
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
					
					AND (EndDate IS NULL OR EndDate > NOW() ) ;   


					insert into tmp_timezones (TimezonesID) select TimezonesID from tblTimezones;

					SET @v_rowCount_ = ( SELECT COUNT(*) FROM tmp_timezones );

					SET @p_PeakTimeZonePercentage	 		 = @p_TimezonePercentage;

					-- // account loop

					INSERT INTO tmp_accounts ( AccountID , PackageID )  SELECT DISTINCT AccountID , PackageID FROM tmp_timezone_minutes;

					SET @v_v_pointer_ = 1;

					SET @v_v_rowCount_ = ( SELECT COUNT(*) FROM tmp_accounts );

					WHILE @v_v_pointer_ <= @v_v_rowCount_
					DO

								SET @v_AccountID = ( SELECT AccountID FROM tmp_accounts WHERE ID = @v_v_pointer_ );
								SET @v_PackageID = ( SELECT PackageID FROM tmp_accounts WHERE ID = @v_v_pointer_ );
 
 								
								UPDATE  tmp_timezone_minutes SET minute_PackageCostPerMinute =  ( (@p_Minutes/ 100) * @p_PeakTimeZonePercentage )
								WHERE  TimezonesID = @p_Timezone AND AccountID = @v_AccountID AND PackageID = @v_PackageID  AND PackageCostPerMinute IS NOT NULL;


								UPDATE  tmp_timezone_minutes SET minute_RecordingCostPerMinute =  ( (@p_Minutes/ 100) * @p_PeakTimeZonePercentage )
								WHERE  TimezonesID = @p_Timezone AND AccountID = @v_AccountID AND PackageID = @v_PackageID  AND RecordingCostPerMinute IS NOT NULL;

 
					
								SET @v_RemainingTimezonesForPackageCostPerMinute = ( SELECT count(*) FROM tmp_timezone_minutes where TimezonesID != @p_Timezone AND AccountID = @v_AccountID AND PackageID = @v_PackageID AND PackageCostPerMinute IS NOT NULL );
								SET @v_RemainingTimezonesForRecordingCostPerMinute = ( SELECT count(*) FROM tmp_timezone_minutes where TimezonesID != @p_Timezone AND AccountID = @v_AccountID AND PackageID = @v_PackageID AND RecordingCostPerMinute IS NOT NULL );

								SET @v_RemainingPackageCostPerMinute = (@p_Minutes - IFNULL((select minute_PackageCostPerMinute FROM tmp_timezone_minutes WHERE  TimezonesID = @p_Timezone AND AccountID = @v_AccountID AND PackageID = @v_PackageID),0)  ) / @v_RemainingTimezonesForPackageCostPerMinute ;
								SET @v_RemainingRecordingCostPerMinute = (@p_Minutes - IFNULL((select minute_RecordingCostPerMinute FROM tmp_timezone_minutes WHERE  TimezonesID = @p_Timezone AND AccountID = @v_AccountID AND PackageID = @v_PackageID),0) ) / @v_RemainingTimezonesForRecordingCostPerMinute ;

								SET @v_pointer_ = 1;

								WHILE @v_pointer_ <= @v_rowCount_
								DO

										SET @v_TimezonesID = ( SELECT TimezonesID FROM tmp_timezones WHERE ID = @v_pointer_ AND TimezonesID != @p_Timezone );

										if @v_TimezonesID > 0 THEN

												UPDATE  tmp_timezone_minutes SET minute_PackageCostPerMinute =  @v_RemainingPackageCostPerMinute
												WHERE  TimezonesID = @v_TimezonesID AND AccountID = @v_AccountID AND PackageID = @v_PackageID AND PackageCostPerMinute IS NOT NULL;


												UPDATE  tmp_timezone_minutes SET minute_RecordingCostPerMinute =  @v_RemainingRecordingCostPerMinute
												WHERE  TimezonesID = @v_TimezonesID AND AccountID = @v_AccountID AND PackageID = @v_PackageID AND RecordingCostPerMinute IS NOT NULL;
 
										END IF ;

									SET @v_pointer_ = @v_pointer_ + 1;

								END WHILE;

						SET @v_v_pointer_ = @v_v_pointer_ + 1;

					END WHILE;

					-- // account loop ends

			END IF;


		SET @v_days =    TIMESTAMPDIFF(DAY, (SELECT @p_StartDate), (SELECT @p_EndDate)) + 1 ;
		SET @v_period1 =      IF(MONTH((SELECT @p_StartDate)) = MONTH((SELECT @p_EndDate)), 0, (TIMESTAMPDIFF(DAY, (SELECT @p_StartDate), LAST_DAY((SELECT @p_StartDate)) + INTERVAL 0 DAY)) / DAY(LAST_DAY((SELECT @p_StartDate))));
		SET @v_period2 =      TIMESTAMPDIFF(MONTH, LAST_DAY((SELECT @p_StartDate)) + INTERVAL 1 DAY, LAST_DAY((SELECT @p_EndDate))) ;
		SET @v_period3 =      IF(MONTH((SELECT @p_StartDate)) = MONTH((SELECT @p_EndDate)), (SELECT @v_days), DAY((SELECT @p_EndDate))) / DAY(LAST_DAY((SELECT @p_EndDate)));
		SET @p_months =     (SELECT @v_period1) + (SELECT @v_period2) + (SELECT @v_period3);

		SET @p_months = fn_Round(@p_months,1);
		
		

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
								t.Title AS TimezoneTitle,
								drtr.EffectiveDate,
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
								END * @p_months AS MonthlyCost,

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
								END  AS RecordingCostPerMinute,
									
								@Total := (
									(	IFNULL(@MonthlyCost,0) 				)				+
									(IFNULL(@PackageCostPerMinute,0) * IFNULL(tm.minute_PackageCostPerMinute,0)	)+
									(IFNULL(@RecordingCostPerMinute,0) * IFNULL(tm.minute_RecordingCostPerMinute,0) )
								)   
								 AS Total
												
        FROM tblRateTablePKGRate  drtr
        INNER JOIN tblRateTable  rt ON rt.RateTableId = drtr.RateTableId 
        INNER JOIN tblVendorConnection vc ON vc.RateTableID = rt.RateTableId  AND vc.CompanyID = rt.CompanyId  AND vc.Active=1 AND vc.RateTypeID = @v_RateTypeID
        INNER JOIN tblAccount a ON vc.AccountId = a.AccountID AND rt.CompanyId = a.CompanyId
        INNER JOIN tblRate r ON drtr.RateID = r.RateID AND r.CompanyID = vc.CompanyID	
        INNER JOIN tblPackage pk ON pk.CompanyID = r.CompanyID AND pk.Name = r.Code 
        INNER JOIN tblTimezones t ON t.TimezonesID =  drtr.TimezonesID
        left join tmp_timezone_minutes tm on tm.TimezonesID = t.TimezonesID AND tm.PackageID = pk.PackageID AND ( tm.AccountID IS NULL OR tm.AccountID = a.AccountID) -- Sumera Not confirmed yet Accountid for CDR
        
        WHERE
        
        rt.CompanyId =  @p_companyid				

        AND ( @p_PackageId = 0 OR pk.PackageId = @p_PackageId )

        AND rt.Type = @v_RateTypeID 
        
        AND rt.AppliedTo = @v_AppliedToVendor 
                    
        AND EffectiveDate <= DATE(@p_SelectedEffectiveDate)
        
        AND (EndDate IS NULL OR EndDate > NOW() ) ;   
					 
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
                    CASE WHEN (@prev_PackageName = PackageName /*AND  @prev_VendorConnectionID = VendorConnectionID */ AND @prev_Total <=  Total
                            )
                    THEN
                        @vPosition + 1
                    ELSE
                    1
                    END) as  vPosition,
                    @prev_PackageName  := PackageName  ,
                    @prev_VendorConnectionID  := VendorConnectionID,
                    @prev_Total := Total

                    from tmp_table_output_1
                    ,(SELECT  @vPosition := 0 , @prev_PackageName  := ''  , @prev_VendorConnectionID  := '', @prev_Total := 0 ) t

                  ORDER BY PackageName,Total,VendorConnectionID
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

            SET @stm_columns = CONCAT(@stm_columns, "GROUP_CONCAT(if(ANY_VALUE(vPosition) = ",@v_pointer_,", CONCAT(ANY_VALUE(Total), '<br>', ANY_VALUE(VendorConnectionName), '<br>', DATE_FORMAT (ANY_VALUE(EffectiveDate), '%d/%m/%Y'),'' ), NULL) SEPARATOR '<br>'  ) AS `POSITION ",@v_pointer_,"`,");

		    SET @v_pointer_ = @v_pointer_ + 1;

		END WHILE;

		SET @stm_columns = TRIM(TRAILING ',' FROM @stm_columns);

		IF (@p_isExport = 0) THEN

            SET @stm_query = CONCAT("SELECT PackageName, ", @stm_columns," FROM tmp_final_table_output GROUP BY PackageName ORDER BY PackageName LIMIT ",@p_RowspPage," OFFSET ",@v_OffSet_," ;");

		    select count(PackageName) as totalcount from tmp_final_table_output;


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

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
