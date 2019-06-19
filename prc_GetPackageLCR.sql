-- --------------------------------------------------------
-- Host:                         188.92.57.86
-- Server version:               5.7.24-log - MySQL Community Server (GPL)
-- Server OS:                    Linux
-- HeidiSQL Version:             9.5.0.5196
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Dumping structure for procedure speakintelligentRM.prc_GetPackageLCR
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `prc_GetPackageLCR`(
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
	IN `p_isExport` INT 







































)
ThisSP:BEGIN


		SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
			SELECT CurrencyId INTO @v_CompanyCurrencyID_ FROM  tblCompany WHERE CompanyID = p_companyid;
			-- select @v_CompanyCurrencyID_;
			
			DROP TEMPORARY TABLE IF EXISTS tmp_all_components;
				CREATE TEMPORARY TABLE tmp_all_components(
					ID INT,
					component VARCHAR(200),
					component_title VARCHAR(200)
			);
			DROP TEMPORARY TABLE IF EXISTS tmp_Timezones;
				CREATE TEMPORARY TABLE tmp_Timezones(
					ID INT AUTO_INCREMENT,
					TimezonesID INT,
					Title VARCHAR(200),
					PRIMARY KEY (ID )
			);
			DROP TEMPORARY TABLE IF EXISTS tmp_table1_;
			CREATE TEMPORARY TABLE tmp_table1_ (
				TimezonesID  INT,
				TimezoneTitle  VARCHAR(100),
				Code VARCHAR(100),
				VendorID INT,
				VendorName VARCHAR(200),
				VendorConnectionName VARCHAR(200),
				MonthlyCost DECIMAL(18,8),
				PackageCostPerMinute DECIMAL(18,8),
				RecordingCostPerMinute DECIMAL(18,8),
				Total DECIMAL(18,8),
				CurrencySymbol VARCHAR(10),
				RateEffectiveDate Date
			);
			
			DROP TEMPORARY TABLE IF EXISTS tmp_table_pkg;
			CREATE TEMPORARY TABLE tmp_table_pkg (
				TimezonesID  INT,
				TimezoneTitle  VARCHAR(100),
				Code VARCHAR(100),
				VendorID INT,
				VendorName VARCHAR(200),
				VendorConnectionName VARCHAR(200),
				MonthlyCost DECIMAL(18,8),
				PackageCostPerMinute DECIMAL(18,8),
				RecordingCostPerMinute DECIMAL(18,8),
				Total DECIMAL(18,8),
				CurrencyId INT,RateEffectiveDate Date
			);
			 
			DROP TEMPORARY TABLE IF EXISTS tmp_vendors;
			CREATE TEMPORARY TABLE tmp_vendors (
				ID  INT AUTO_INCREMENT,
				VendorName VARCHAR(100),
				VendorConnectionName VARCHAR(200),
				vPosition INT,
				PRIMARY KEY (ID)
			);

 			
			INSERT INTO tmp_all_components (ID, component , component_title )
				VALUES
				(1, 'MonthlyCost', 			'Monthly cost'),
				(3, 'PackageCostPerMinute',			'Package Cost Per Minute'),
				(4, 'RecordingCostPerMinute', 'Recording Cost Per Minute');
			DROP TEMPORARY TABLE IF EXISTS tmp_component_output_;
			CREATE TEMPORARY TABLE tmp_component_output_ (
				TimezoneTitle  VARCHAR(100),
				Component	  VARCHAR(200),
				ComponentValue VARCHAR(200),
				VendorName VARCHAR(200),
				VendorConnectionName VARCHAR(200),
				VendorID INT,
				Total DECIMAL(18,8),
				vPosition INT
			);
			DROP TEMPORARY TABLE IF EXISTS tmp_component_output_dup;
			CREATE TEMPORARY TABLE tmp_component_output_dup (
				TimezoneTitle  VARCHAR(100),
				Component	  VARCHAR(200),
				ComponentValue VARCHAR(200),
				VendorName VARCHAR(200),
				VendorConnectionName VARCHAR(200),
				VendorID INT,
				Total DECIMAL(18,8),
				vPosition INT
			);
		
			DROP TEMPORARY TABLE IF EXISTS tmp_final_result;
			CREATE TEMPORARY TABLE tmp_final_result (
				Component  VARCHAR(100)
			);
			DROP TEMPORARY TABLE IF EXISTS tmp_vendor_position;
			CREATE TEMPORARY TABLE tmp_vendor_position (
				VendorID INT,
				vPosition INT,
				Code VARCHAR(100),
				Total1 DECIMAL(18,8),
				VName VARCHAR(100),
				VendorConnectionName VARCHAR(200),
				VCurrencySymbol VARCHAR(10),
				RateEffectiveDate Date,
				VDisplayValue VARCHAR(500)
			);
			DROP TEMPORARY TABLE IF EXISTS tmp_timezones;
			CREATE TEMPORARY TABLE tmp_timezones (
				ID INT AUTO_INCREMENT,
				TimezonesID INT,
				PRIMARY KEY (ID)
			);
			DROP TEMPORARY TABLE IF EXISTS tmp_timezone_minutes;
			CREATE TEMPORARY TABLE tmp_timezone_minutes (
				TimezonesID INT,
				minutes INT
			);			
			
			
			
			DROP TEMPORARY TABLE IF EXISTS tmp_timezone_minutes_2;
			CREATE TEMPORARY TABLE tmp_timezone_minutes_2 (
				TimezonesID INT,
				minutes INT
			);
			DROP TEMPORARY TABLE IF EXISTS tmp_timezone_minutes_3;
			CREATE TEMPORARY TABLE tmp_timezone_minutes_3 (
				TimezonesID INT,
				minutes INT
			);
			DROP TEMPORARY TABLE IF EXISTS tmp_timezone_minutes_4;
			CREATE TEMPORARY TABLE tmp_timezone_minutes_4 (
				TimezonesID INT,
				minutes INT
			);
			
			DROP TEMPORARY TABLE IF EXISTS tmp_disctictPackages;
			CREATE TEMPORARY TABLE tmp_disctictPackages (
				Code  VARCHAR(100),
				VendorID INT,
				Total1 INT,
				RowID  INT AUTO_INCREMENT,
				PRIMARY KEY (RowID)
			);
			
			DROP TEMPORARY TABLE IF EXISTS tmp_disctictPackagesVendorRates;
			CREATE TEMPORARY TABLE tmp_disctictPackagesVendorRates (
				Code  VARCHAR(100),
				VendorID INT,
				Total1 DECIMAL(18,8),
				RowID  INT AUTO_INCREMENT,
				VDisplayValue VARCHAR(500),
				PRIMARY KEY (RowID)
			);
			
			DROP TEMPORARY TABLE IF EXISTS tmp_finalPackagesRates;
			CREATE TEMPORARY TABLE tmp_finalPackagesRates (
				Code  VARCHAR(100),
				Position1  VARCHAR(500),
				Position2  VARCHAR(500),
				Position3  VARCHAR(500),
				Position4  VARCHAR(500),
				Position5  VARCHAR(500),
				Position6  VARCHAR(500),
				Position7  VARCHAR(500),
				Position8  VARCHAR(500),
				Position9  VARCHAR(500),
				Position10  VARCHAR(500)
				
			);
			
			
			SET @p_Calls	 							 = p_Calls;
			SET @p_Minutes	 							 = p_Minutes;
			
			SET @p_CurrencyID = p_CurrencyID;
			SET @p_StartDate	= p_StartDate;
			SET @p_EndDate		= p_EndDate;
		
			SET @v_CallerRate = 1; 
			SET @p_PackageId  = p_PackageId;
			
			-- select @p_Calls,@p_Minutes;
						
			IF @p_Calls = 0 AND @p_Minutes = 0 THEN
			
			
				
				SELECT COUNT(UsageDetailID)  INTO @p_Calls 
				
				FROM speakintelligentCDR.tblUsageDetails  d  
				INNER JOIN speakintelligentCDR.tblUsageHeader h ON d.UsageHeaderID = h.UsageHeaderID   
				WHERE CompanyID = p_companyid AND StartDate >= @p_StartDate AND StartDate <= @p_EndDate AND d.is_inbound = 1;  
				
				
				INSERT INTO tmp_timezone_minutes (TimezonesID, minutes)  
								
				SELECT TimezonesID  , (SUM(billed_duration) / 60) AS minutes
				
				FROM speakintelligentCDR.tblUsageDetails  d  
				INNER JOIN speakintelligentCDR.tblUsageHeader h ON d.UsageHeaderID = h.UsageHeaderID   
				WHERE CompanyID = p_companyid AND StartDate >= @p_StartDate AND StartDate <= @p_EndDate AND d.is_inbound = 1 AND TimezonesID IS NOT NULL
				
				GROUP BY TimezonesID;  
				  
				
			ELSE 
			 
	
					SET @p_PeakTimeZonePercentage	 		 = p_TimezonePercentage;

					
					SET @v_PeakTimeZoneMinutes				 =  ( (@p_Minutes/ 100) * @p_PeakTimeZonePercentage ) 	; 
					SET @v_OffpeakTimeZoneMinutes		 	 =  (@p_Minutes -  @v_PeakTimeZoneMinutes)	; 

					
					
					SET @v_RemainingTimezones = (SELECT COUNT(*) FROM tmp_timezones WHERE TimezonesID != p_Timezone); 
					SET @v_RemainingMinutes = (@p_Minutes - @v_PeakTimeZoneMinutes) / @v_RemainingTimezones ;
					
					IF p_TimezonePercentage = 0 THEN
						SET @p_PeakTimeZonePercentage	 		 = @p_Minutes;		
						SET @v_RemainingMinutes = @p_Minutes;	
						SET @v_PeakTimeZoneMinutes = @p_Minutes;
					END IF;
				
					INSERT INTO tmp_timezones (TimezonesID) SELECT TimezonesID FROM 	tblTimezones;
					
					INSERT INTO tmp_timezone_minutes (TimezonesID, minutes) SELECT p_Timezone, @v_PeakTimeZoneMinutes AS minutes;
				
					
				
					
					SET @v_pointer_ = 1;
					SET @v_rowCount_ = ( SELECT COUNT(*) FROM tmp_timezones );
					WHILE @v_pointer_ <= @v_rowCount_
					DO
							SET @v_TimezonesID = (SELECT TimezonesID FROM tmp_timezones WHERE ID = @v_pointer_ AND TimezonesID != p_Timezone );
							IF @v_TimezonesID > 0 THEN
							
								INSERT INTO tmp_timezone_minutes (TimezonesID, minutes)  SELECT @v_TimezonesID, @v_RemainingMinutes AS minutes;
							END IF ;
						SET @v_pointer_ = @v_pointer_ + 1;
					END WHILE;
				
			END IF;
			
			
			
		SET @v_days =    TIMESTAMPDIFF(DAY, (SELECT @p_StartDate), (SELECT @p_EndDate)) + 1 ;
		SET @v_period1 =      IF(MONTH((SELECT @p_StartDate)) = MONTH((SELECT @p_EndDate)), 0, (TIMESTAMPDIFF(DAY, (SELECT @p_StartDate), LAST_DAY((SELECT @p_StartDate)) + INTERVAL 1 DAY)) / DAY(LAST_DAY((SELECT @p_StartDate))));     
		SET @v_period2 =      TIMESTAMPDIFF(MONTH, LAST_DAY((SELECT @p_StartDate)) + INTERVAL 1 DAY, LAST_DAY((SELECT @p_EndDate))) ;
		SET @v_period3 =      IF(MONTH((SELECT @p_StartDate)) = MONTH((SELECT @p_EndDate)), (SELECT @v_days), DAY((SELECT @p_EndDate))) / DAY(LAST_DAY((SELECT @p_EndDate)));
		SET @p_months =     (SELECT @v_period1) + (SELECT @v_period2) + (SELECT @v_period3);
				
		SET @p_months = ROUND(@p_months,1);
		
		
		SET	@v_PackageType = 3;	
		set @v_ApprovedStatus = 1;

		set @v_AppliedToCustomer = 1; 
		set @v_AppliedToVendor = 2; 
		set @v_AppliedToReseller = 3; 
		
		-- select * from tmp_timezone_minutes;
	--	select p_PackageId;
		
		IF p_PackageId = 0 THEN

								INSERT INTO tmp_table_pkg 
								(
									TimezonesID,
									TimezoneTitle,
									Code,
									CurrencyId,
									RateEffectiveDate,
									VendorID,
									VendorName,
									VendorConnectionName,
									MonthlyCost,
									PackageCostPerMinute,
									RecordingCostPerMinute,
									Total
								)
								SELECT
								drtr.TimezonesID,
								t.Title AS TimezoneTitle,
								r.Code,
								a.CurrencyId,
								EffectiveDate,
								a.AccountID,
								a.AccountName,
								vc.Name,
								@MonthlyCost := CASE WHEN ( MonthlyCostCurrency IS NOT NULL)
								THEN
								CASE WHEN  @p_CurrencyID = MonthlyCostCurrency THEN
									drtr.MonthlyCost
								ELSE
								(
									
									(SELECT VALUE FROM tblCurrencyConversion WHERE tblCurrencyConversion.CurrencyId =  @p_CurrencyID  AND  CompanyID = p_companyid  )
									* (drtr.MonthlyCost  / (SELECT VALUE FROM tblCurrencyConversion WHERE tblCurrencyConversion.CurrencyId = MonthlyCostCurrency AND  CompanyID = p_companyid ))
								)
								END
								WHEN  ( @p_CurrencyID = rt.CurrencyID ) THEN
									drtr.MonthlyCost
								ELSE
									(
										
										(SELECT VALUE FROM tblCurrencyConversion WHERE tblCurrencyConversion.CurrencyId =  @p_CurrencyID  AND  CompanyID = p_companyid )
										* (drtr.MonthlyCost  / (SELECT VALUE FROM tblCurrencyConversion WHERE tblCurrencyConversion.CurrencyId = rt.CurrencyID AND  CompanyID = p_companyid ))
									)
								END * @p_months AS MonthlyCost,

								@PackageCostPerMinute := CASE WHEN ( PackageCostPerMinuteCurrency IS NOT NULL)
								THEN
								CASE WHEN  @p_CurrencyID = PackageCostPerMinuteCurrency THEN
									drtr.PackageCostPerMinute
								ELSE
								(
									
									(SELECT VALUE FROM tblCurrencyConversion WHERE tblCurrencyConversion.CurrencyId =  @p_CurrencyID  AND  CompanyID = p_companyid )
									* (drtr.PackageCostPerMinute  / (SELECT VALUE FROM tblCurrencyConversion WHERE tblCurrencyConversion.CurrencyId = PackageCostPerMinuteCurrency AND  CompanyID = p_companyid ))
								)
								END
								WHEN  ( @p_CurrencyID = rt.CurrencyID ) THEN
									drtr.PackageCostPerMinute
								ELSE
									(
										
										(SELECT VALUE FROM tblCurrencyConversion WHERE tblCurrencyConversion.CurrencyId =  @p_CurrencyID  AND  CompanyID = p_companyid )
										* (drtr.PackageCostPerMinute  / (SELECT VALUE FROM tblCurrencyConversion WHERE tblCurrencyConversion.CurrencyId = rt.CurrencyID AND  CompanyID = p_companyid ))
									)
								END  AS PackageCostPerMinute,
								@RecordingCostPerMinute := CASE WHEN ( RecordingCostPerMinuteCurrency IS NOT NULL)
								THEN
								CASE WHEN  @p_CurrencyID = RecordingCostPerMinuteCurrency THEN
									drtr.RecordingCostPerMinute
								ELSE
								(
									
									(SELECT VALUE FROM tblCurrencyConversion WHERE tblCurrencyConversion.CurrencyId =  @p_CurrencyID  AND  CompanyID = p_companyid )
									* (drtr.RecordingCostPerMinute  / (SELECT VALUE FROM tblCurrencyConversion WHERE tblCurrencyConversion.CurrencyId = RecordingCostPerMinuteCurrency AND  CompanyID = p_companyid ))
								)
								END
								WHEN  ( @p_CurrencyID = rt.CurrencyID ) THEN
									drtr.RecordingCostPerMinute
								ELSE
									(
										
										(SELECT VALUE FROM tblCurrencyConversion WHERE tblCurrencyConversion.CurrencyId =  @p_CurrencyID  AND  CompanyID = p_companyid )
										* (drtr.RecordingCostPerMinute  / (SELECT VALUE FROM tblCurrencyConversion WHERE tblCurrencyConversion.CurrencyId = rt.CurrencyID AND  CompanyID = p_companyid ))
									)
								END  AS RecordingCostPerMinute,
									
								@Total := (
									(	IFNULL(@MonthlyCost,0) 				)				+
									(IFNULL(@PackageCostPerMinute,0) * IFNULL(tm.minutes,0)	)+
									(IFNULL(@RecordingCostPerMinute,0) * IFNULL(tm.minutes,0) )
								)   
								 AS Total
												
								FROM tblRateTablePKGRate  drtr
								INNER JOIN tblRateTable  rt ON rt.RateTableId = drtr.RateTableId 
								INNER JOIN tblVendorConnection vc ON vc.RateTableID = rt.RateTableId  AND vc.CompanyID = rt.CompanyId  AND vc.Active=1 AND vc.RateTypeID = @v_PackageType
								INNER JOIN tblAccount a ON vc.AccountId = a.AccountID AND rt.CompanyId = a.CompanyId
								INNER JOIN tblRate r ON drtr.RateID = r.RateID AND r.CompanyID = vc.CompanyID	
								INNER JOIN tblTimezones t ON t.TimezonesID =  drtr.TimezonesID
								left join tmp_timezone_minutes tm on tm.TimezonesID = t.TimezonesID
								WHERE
								rt.CompanyId =  p_companyid				
								AND rt.Type = @v_PackageType 
								AND rt.AppliedTo = @v_AppliedToVendor 
											
								AND EffectiveDate <= DATE(p_SelectedEffectiveDate)
								
								AND (EndDate IS NULL OR EndDate > NOW() )
								 ;   
								
		ELSE
		
		INSERT INTO tmp_table_pkg 
								(
									TimezonesID,
									TimezoneTitle,
									Code,
									CurrencyId,
									RateEffectiveDate,
									VendorID,
									VendorName,
									VendorConnectionName,
									MonthlyCost,
									PackageCostPerMinute,
									RecordingCostPerMinute,
									Total
								)
								SELECT
								drtr.TimezonesID,
								t.Title AS TimezoneTitle,
								r.Code,
								a.CurrencyId,
								EffectiveDate,
								a.AccountID,
								a.AccountName,
								vc.Name,
								@MonthlyCost := CASE WHEN ( MonthlyCostCurrency IS NOT NULL)
								THEN
								CASE WHEN  @p_CurrencyID = MonthlyCostCurrency THEN
									drtr.MonthlyCost
								ELSE
								(
									
									(SELECT VALUE FROM tblCurrencyConversion WHERE tblCurrencyConversion.CurrencyId =  @p_CurrencyID  AND  CompanyID = p_companyid  )
									* (drtr.MonthlyCost  / (SELECT VALUE FROM tblCurrencyConversion WHERE tblCurrencyConversion.CurrencyId = MonthlyCostCurrency AND  CompanyID = p_companyid ))
								)
								END
								WHEN  ( @p_CurrencyID = rt.CurrencyID ) THEN
									drtr.MonthlyCost
								ELSE
									(
										
										(SELECT VALUE FROM tblCurrencyConversion WHERE tblCurrencyConversion.CurrencyId =  @p_CurrencyID  AND  CompanyID = p_companyid )
										* (drtr.MonthlyCost  / (SELECT VALUE FROM tblCurrencyConversion WHERE tblCurrencyConversion.CurrencyId = rt.CurrencyID AND  CompanyID = p_companyid ))
									)
								END * @p_months AS MonthlyCost,

								@PackageCostPerMinute := CASE WHEN ( PackageCostPerMinuteCurrency IS NOT NULL)
								THEN
								CASE WHEN  @p_CurrencyID = PackageCostPerMinuteCurrency THEN
									drtr.PackageCostPerMinute
								ELSE
								(
									
									(SELECT VALUE FROM tblCurrencyConversion WHERE tblCurrencyConversion.CurrencyId =  @p_CurrencyID  AND  CompanyID = p_companyid )
									* (drtr.PackageCostPerMinute  / (SELECT VALUE FROM tblCurrencyConversion WHERE tblCurrencyConversion.CurrencyId = PackageCostPerMinuteCurrency AND  CompanyID = p_companyid ))
								)
								END
								WHEN  ( @p_CurrencyID = rt.CurrencyID ) THEN
									drtr.PackageCostPerMinute
								ELSE
									(
										
										(SELECT VALUE FROM tblCurrencyConversion WHERE tblCurrencyConversion.CurrencyId =  @p_CurrencyID  AND  CompanyID = p_companyid )
										* (drtr.PackageCostPerMinute  / (SELECT VALUE FROM tblCurrencyConversion WHERE tblCurrencyConversion.CurrencyId = rt.CurrencyID AND  CompanyID = p_companyid ))
									)
								END  AS PackageCostPerMinute,
								@RecordingCostPerMinute := CASE WHEN ( RecordingCostPerMinuteCurrency IS NOT NULL)
								THEN
								CASE WHEN  @p_CurrencyID = RecordingCostPerMinuteCurrency THEN
									drtr.RecordingCostPerMinute
								ELSE
								(
									
									(SELECT VALUE FROM tblCurrencyConversion WHERE tblCurrencyConversion.CurrencyId =  @p_CurrencyID  AND  CompanyID = p_companyid )
									* (drtr.RecordingCostPerMinute  / (SELECT VALUE FROM tblCurrencyConversion WHERE tblCurrencyConversion.CurrencyId = RecordingCostPerMinuteCurrency AND  CompanyID = p_companyid ))
								)
								END
								WHEN  ( @p_CurrencyID = rt.CurrencyID ) THEN
									drtr.RecordingCostPerMinute
								ELSE
									(
										
										(SELECT VALUE FROM tblCurrencyConversion WHERE tblCurrencyConversion.CurrencyId =  @p_CurrencyID  AND  CompanyID = p_companyid )
										* (drtr.RecordingCostPerMinute  / (SELECT VALUE FROM tblCurrencyConversion WHERE tblCurrencyConversion.CurrencyId = rt.CurrencyID AND  CompanyID = p_companyid ))
									)
								END  AS RecordingCostPerMinute,
									
								@Total := (
									(	IFNULL(@MonthlyCost,0) 				)				+
									(IFNULL(@PackageCostPerMinute,0) * IFNULL(tm.minutes,0)	)+
									(IFNULL(@RecordingCostPerMinute,0) * IFNULL(tm.minutes,0) )
								)   
								 AS Total
												
								FROM tblRateTablePKGRate  drtr
								INNER JOIN tblRateTable  rt ON rt.RateTableId = drtr.RateTableId 
								INNER JOIN tblVendorConnection vc ON vc.RateTableID = rt.RateTableId  AND vc.CompanyID = rt.CompanyId  AND vc.Active=1 AND vc.RateTypeID = @v_PackageType
								INNER JOIN tblAccount a ON vc.AccountId = a.AccountID AND rt.CompanyId = a.CompanyId
								INNER JOIN tblRate r ON drtr.RateID = r.RateID AND r.CompanyID = vc.CompanyID	
								INNER JOIN tblPackage st ON st.CompanyID = r.CompanyID AND st.PackageId = @p_PackageId AND  r.Code = st.Name
								INNER JOIN tblTimezones t ON t.TimezonesID =  drtr.TimezonesID
								left join tmp_timezone_minutes tm on tm.TimezonesID = t.TimezonesID
								WHERE
								rt.CompanyId =  p_companyid				
								AND rt.Type = @v_PackageType 
								AND rt.AppliedTo = @v_AppliedToVendor 
											
								AND EffectiveDate <= DATE(p_SelectedEffectiveDate)
								
								AND (EndDate IS NULL OR EndDate > NOW() ) ;   
		
		END IF;

 
		--	select * from tmp_table_pkg;
				
					INSERT INTO tmp_table1_ (
											TimezonesID,
											TimezoneTitle,
											VendorID,
											VendorName,
											VendorConnectionName,
											MonthlyCost,
											PackageCostPerMinute,
											RecordingCostPerMinute,
											Total,Code,CurrencySymbol,RateEffectiveDate

											)
											
											SELECT 
											TimezonesID,
											TimezoneTitle,
											VendorID,
											VendorName,
											VendorConnectionName,
											MonthlyCost,
											PackageCostPerMinute,
											RecordingCostPerMinute,
											Total,Code,(select Symbol from tblCurrency where tblCurrency.CurrencyId = p_CurrencyID) as CurrencySymbol,
											RateEffectiveDate
											from tmp_table_pkg
											WHERE Total IS NOT NULL;
													
		
	
																								
		-- select * from tmp_table1_;								
				
	--	select * from tmp_table1_;	
		
		-- SELECT DISTINCT  VendorID ,Code, SUM(Total) AS Total1 FROM tmp_table1_ GROUP BY VendorID,Code having Code = 'Basic' order by Total1;
		
		INSERT INTO tmp_disctictPackages(Code,RowID)
		SELECT DISTINCT Code,NULL FROM tmp_table_pkg;
		
			SET @v_pointer_ = 1;
		SET @v_rowCount_ = ( SELECT COUNT(*) FROM tmp_disctictPackages );
		WHILE @v_pointer_ <= @v_rowCount_
		DO
		SET @v_Code = ( SELECT Code FROM tmp_disctictPackages WHERE RowID = @v_pointer_ );
	
		SET @prev_VendorID = 0;
		SET @rank = 0;
		SET @prev_Total = 0;
		
			
			INSERT INTO tmp_vendor_position (VendorID , vPosition,Code,Total1,VName,VCurrencySymbol,RateEffectiveDate,VDisplayValue,VendorConnectionName)
			SELECT
			VendorID , vPosition,Code,Total1,VName,VCurrencySymbol,RateEffectiveDate,concat(VCurrencySymbol,Total1,";",VendorConnectionName,";",RateEffectiveDate),VendorConnectionName
			FROM (
				SELECT
					DISTINCT
					v.VendorID,
					v.Total1,
						@rank := ( CASE WHEN(@prev_VendorID != v.VendorID AND @prev_Total <= v.Total1  )
						THEN  @rank + 1
										 ELSE 1
										 END
					) AS vPosition,
					@prev_VendorID := v.VendorID,
					@prev_Total := v.Total1,
					v.Code,v.VendorName as VName,
					v.CurrencySymbol as VCurrencySymbol,v.RateEffectiveDate,
					v.VendorConnectionName
				FROM (
				
						SELECT DISTINCT  VendorID ,Code, SUM(Total) AS Total1,VendorName,CurrencySymbol,RateEffectiveDate,VendorConnectionName FROM tmp_table1_ GROUP BY VendorID,Code,VendorName,CurrencySymbol,RateEffectiveDate,VendorConnectionName having Code = @v_Code order by Total1
					) v
					
				ORDER BY v.Total1,v.VendorID ASC
			) tmp
			WHERE vPosition <= p_Position;
			
			SET @v_pointer_ = @v_pointer_ + 1;
		
		END WHILE;
		
	--	 select * from tmp_vendor_position;	
		

		truncate tmp_disctictPackages;
		INSERT INTO tmp_disctictPackages(Code,RowID)
		SELECT DISTINCT Code,NULL FROM tmp_vendor_position;
		
		 -- select * from tmp_disctictPackages;
		 -- select * from tmp_vendor_position;
		
	
		SET @v_pointer_ = 1;
		SET @v_rowCount_ = ( SELECT COUNT(*) FROM tmp_disctictPackages);
		-- select @v_rowCount_;
		WHILE @v_pointer_ <= @v_rowCount_
		DO
		SET @v_Code = ( SELECT Code FROM tmp_disctictPackages WHERE RowID = @v_pointer_ );
		
		INSERT INTO tmp_disctictPackagesVendorRates(Code,VendorID,Total1,VDisplayValue,RowID)
		SELECT DISTINCT Code,VendorID,Total1,VDisplayValue,NULL FROM tmp_vendor_position where Code = @v_Code order by Total1 limit p_Position;
		
--		SET @v_VendorID = ( SELECT VendorID FROM tmp_disctictPackages WHERE RowID = @v_pointer_ );
		
		if p_Position = 5 THEN
			select VDisplayValue into @Position1 from tmp_disctictPackagesVendorRates where RowID = 1 and Code = @v_Code;
			select VDisplayValue into @Position2 from tmp_disctictPackagesVendorRates where RowID = 2 and Code = @v_Code;
			select VDisplayValue into @Position3 from tmp_disctictPackagesVendorRates where RowID = 3 and Code = @v_Code;
			select VDisplayValue into @Position4 from tmp_disctictPackagesVendorRates where RowID = 4 and Code = @v_Code;
			select VDisplayValue into @Position5 from tmp_disctictPackagesVendorRates where RowID = 5 and Code = @v_Code;
			
				insert into tmp_finalPackagesRates (Code,Position1,Position2,Position3,Position4,Position5)
				select @v_Code,@Position1 as Position1,@Position2 as Position2,@Position3 as Position3,@Position4 as Position4,@Position5 as Position5;
				SET @Position1 = null,@Position2 = null,@Position3 = null,@Position4 = null,@Position5 = null;
		ELSE
		
			select VDisplayValue into @Position1 from tmp_disctictPackagesVendorRates where RowID = 1 and Code = @v_Code;
			select VDisplayValue into @Position2 from tmp_disctictPackagesVendorRates where RowID = 2 and Code = @v_Code;
			select VDisplayValue into @Position3 from tmp_disctictPackagesVendorRates where RowID = 3 and Code = @v_Code;
			select VDisplayValue into @Position4 from tmp_disctictPackagesVendorRates where RowID = 4 and Code = @v_Code;
			select VDisplayValue into @Position5 from tmp_disctictPackagesVendorRates where RowID = 5 and Code = @v_Code;
			
			select VDisplayValue into @Position6 from tmp_disctictPackagesVendorRates where RowID = 6 and Code = @v_Code;
			select VDisplayValue into @Position6 from tmp_disctictPackagesVendorRates where RowID = 7 and Code = @v_Code;
			select VDisplayValue into @Position6 from tmp_disctictPackagesVendorRates where RowID = 8 and Code = @v_Code;
			select VDisplayValue into @Position6 from tmp_disctictPackagesVendorRates where RowID = 9 and Code = @v_Code;
			select VDisplayValue into @Position6 from tmp_disctictPackagesVendorRates where RowID = 10 and Code = @v_Code;
			
			
				insert into tmp_finalPackagesRates (Code,Position1,Position2,Position3,Position4,Position5,Position6,Position7,Position8,Position9,Position10)
				select @v_Code,@Position1 as Position1,@Position2 as Position2,@Position3 as Position3,@Position4 as Position4,@Position5 as Position5,
				@Position6 as Position6,@Position7 as Position7,@Position8 as Position8,@Position9 as Position9,@Position10 as Position10;
				SET @Position1 = null,@Position2 = null,@Position3 = null,@Position4 = null,@Position5 = null,
				@Position6 = null,@Position7 = null,@Position8 = null,@Position9 = null,@Position10 = null;
		
			
		END IF;
		
	
		
		SET @v_pointer_ = @v_pointer_ + 1;
		truncate tmp_disctictPackagesVendorRates;
		
		END WHILE;
		
		
	--	SELECT * FROM tmp_final_result;
		
		if p_Position = 5 THEN
			select Code,Position1,Position2,Position3,Position4,Position5 from tmp_finalPackagesRates;
		ELSE
		select Code,Position1,Position2,Position3,Position4,Position5,Position6,Position7,Position8,Position9,Position10 from tmp_finalPackagesRates;
		END IF;
		SELECT COUNT(*) AS totalcount FROM tmp_finalPackagesRates;
		

	
	
	SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	
	
END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
