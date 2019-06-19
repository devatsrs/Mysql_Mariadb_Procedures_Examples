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

-- Dumping structure for procedure speakintelligentRM.prc_WSGenerateRateTablePkg
DROP PROCEDURE IF EXISTS `prc_WSGenerateRateTablePkg`;
DELIMITER //
CREATE DEFINER=`neon-user`@`117.247.87.156` PROCEDURE `prc_WSGenerateRateTablePkg`(
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


 		DECLARE v_RateGeneratorPackageComponent Text;

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

		SET @@session.collation_connection='utf8_unicode_ci';
		SET @@session.character_set_client='utf8';
		SET SESSION group_concat_max_len = 1000000; 

		SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;


		
		DROP TEMPORARY TABLE IF EXISTS tmp_Raterules_;
		CREATE TEMPORARY TABLE tmp_Raterules_  (
			rateruleid INT,
			Component VARCHAR(50) COLLATE utf8_unicode_ci,
			TimezonesID int,
			PackageID VARCHAR(50),
			`Order` INT,
			RowNo INT
		);
		
		DROP TEMPORARY TABLE IF EXISTS tmp_RateGeneratorCalculatedRate_;
		CREATE TEMPORARY TABLE tmp_RateGeneratorCalculatedRate_  (
			CalculatedRateID INT,
			Component VARCHAR(50),
			TimezonesID int,
			RateLessThen	DECIMAL(18, 8),
			ChangeRateTo DECIMAL(18, 8),
			PackageID VARCHAR(50),
			RowNo INT
		);
		
		

		DROP TEMPORARY TABLE IF EXISTS tmp_table_with_origination;
		CREATE TEMPORARY TABLE tmp_table_with_origination (
				RateTableID int,			
				TimezonesID  int,
				TimezoneTitle  varchar(100),
				CodeDeckId int,
				Code varchar(100),
				OriginationCode  varchar(100),
				VendorID int,
				VendorName varchar(200),
				EndDate datetime,
				PackageID VARCHAR(50),
				OneOffCost DECIMAL(18, 8),
				MonthlyCost DECIMAL(18, 8),
				PackageCostPerMinute  DECIMAL(18, 8),
				RecordingCostPerMinute  DECIMAL(18, 8),
				
				
				OneOffCostCurrency int,
				MonthlyCostCurrency int,
				PackageCostPerMinuteCurrency int,
				RecordingCostPerMinuteCurrency int,
					
					
				Total1 DECIMAL(18, 8),
				Total DECIMAL(18, 8)
			);

			
 			
		DROP TEMPORARY TABLE IF EXISTS tmp_tblRateTablePKGRate;
		CREATE TEMPORARY TABLE tmp_tblRateTablePKGRate (
				RateTableID int,
				TimezonesID  int,
				TimezoneTitle  varchar(100),
				CodeDeckId int,
				PackageID VARCHAR(50),
				Code  varchar(100),
				VendorID int,
				VendorName varchar(200),
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

		DROP TEMPORARY TABLE IF EXISTS tmp_SelectedVendortblRateTablePKGRate;
		CREATE TEMPORARY TABLE tmp_SelectedVendortblRateTablePKGRate (
				RateTableID int,
				TimezonesID  int,
				TimezoneTitle  varchar(100),
				CodeDeckId int,
				PackageID VARCHAR(50),
				Code varchar(100),
				OriginationCode  varchar(100),
				VendorID int,
				VendorName varchar(200),
				EndDate datetime,
				OneOffCost DECIMAL(18,8) NULL DEFAULT NULL,
	MonthlyCost DECIMAL(18,8) NULL DEFAULT NULL,
	PackageCostPerMinute DECIMAL(18,8) NULL DEFAULT NULL,
	RecordingCostPerMinute DECIMAL(18,8) NULL DEFAULT NULL,
	OneOffCostCurrency INT(11) NULL DEFAULT NULL,
	MonthlyCostCurrency INT(11) NULL DEFAULT NULL,
	PackageCostPerMinuteCurrency INT(11) NULL DEFAULT NULL,
	RecordingCostPerMinuteCurrency INT(11) NULL DEFAULT NULL,

				

				new_OneOffCost DECIMAL(18,8) NULL DEFAULT NULL,
	new_MonthlyCost DECIMAL(18,8) NULL DEFAULT NULL,
	new_PackageCostPerMinute DECIMAL(18,8) NULL DEFAULT NULL,
	new_RecordingCostPerMinute DECIMAL(18,8) NULL DEFAULT NULL

			);

			DROP TEMPORARY TABLE IF EXISTS tmp_vendor_position;
			CREATE TEMPORARY TABLE tmp_vendor_position (
				VendorID int,
				vPosition int,
				Total DECIMAL(18, 8),
				Package int

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
				minutes int
			);
			DROP TEMPORARY TABLE IF EXISTS tmp_timezone_minutes_2;
			CREATE TEMPORARY TABLE tmp_timezone_minutes_2 (
				TimezonesID int,
				minutes int
			);
			DROP TEMPORARY TABLE IF EXISTS tmp_timezone_minutes_3;
			CREATE TEMPORARY TABLE tmp_timezone_minutes_3 (
				TimezonesID int,
				minutes int
			);

		DROP TEMPORARY TABLE IF EXISTS tmp_tblVendorConnection;
			CREATE TEMPORARY TABLE tmp_tblVendorConnection (
				AccountID int,
				RateTableId int
			);
			
		DROP TEMPORARY TABLE IF EXISTS tmp_RaterGeneratorComponent;
		CREATE TEMPORARY TABLE tmp_RaterGeneratorComponent  (
			Component Text
		);

	set @p_RateGeneratorId = p_RateGeneratorId;
 
   insert into tmp_RaterGeneratorComponent (Component) select distinct Component from tblRateGeneratorCostComponent where RateGeneratorId = p_RateGeneratorId;
   insert into tmp_RaterGeneratorComponent (Component) select distinct Component from tblRateGeneratorCalculatedRate where RateGeneratorId = p_RateGeneratorId;
   insert into tmp_RaterGeneratorComponent (Component) select distinct Component from tblRateRule where RateGeneratorId = p_RateGeneratorId;
   select GROUP_CONCAT(distinct Component)  into v_RateGeneratorPackageComponent from tmp_RaterGeneratorComponent;
   

		IF p_rateTableName IS NOT NULL
		THEN


			SET @v_RTRowCount_ = (SELECT COUNT(*)
													 FROM tblRateTable
													 WHERE RateTableName = p_rateTableName
																 AND CompanyId = (SELECT
																										CompanyId
																									FROM tblRateGenerator
																									WHERE RateGeneratorID = p_RateGeneratorId));

			IF @v_RTRowCount_ > 0
			THEN
				INSERT INTO tmp_JobLog_ (Message) VALUES ('RateTable Name is already exist, Please try using another RateTable Name');
				SELECT * FROM tmp_JobLog_;
				LEAVE GenerateRateTable;
			END IF;
			
			
		END IF;


		
		 SELECT CurrencyID,PackageID,CompanyID INTO @v_RateGenatorCurrencyID_,@v_RateGenartorPackageID,@v_RateGenatorCompanyID FROM  tblRateGenerator WHERE RateGeneratorId = @p_RateGeneratorId;
		SET @p_EffectiveDate = p_EffectiveDate;

		
		
		
		IF @v_RateGenartorPackageID = 0 THEN

		SELECT
			rateposition,
			rateGen.companyid ,
			rateGen.RateGeneratorName,
			rateGen.RateGeneratorId,
			rateGen.CurrencyID,
		
			rateGen.Calls,
			rateGen.Minutes,
			rateGen.DateFrom,
			rateGen.DateTo,
			rateGen.TimezonesID,
			rateGen.TimezonesPercentage,
			0,
			IF( percentageRate = '' OR percentageRate is null	,0, percentageRate ),rateGen.SelectType,
			IFNULL(AppliedTo,''),
			IFNULL(Reseller,'0')
			
			INTO @v_RatePosition_, @v_CompanyId_,   @v_RateGeneratorName_,@p_RateGeneratorId, @v_CurrencyID_,
			
			@v_Calls,
			@v_Minutes,
			@v_StartDate_ ,@v_EndDate_ ,@v_TimezonesID, @v_TimezonesPercentage,@v_PackageID,
			@v_percentageRate_,@v_PackageType ,
			@p_AppliedTo,
			@p_Reseller
		FROM tblRateGenerator rateGen 
		WHERE RateGeneratorId = @p_RateGeneratorId;
		
	ELSE
	
	SELECT
			rateposition,
			rateGen.companyid ,
			rateGen.RateGeneratorName,
			rateGen.RateGeneratorId,
			rateGen.CurrencyID,
		
			rateGen.Calls,
			rateGen.Minutes,
			rateGen.DateFrom,
			rateGen.DateTo,
			rateGen.TimezonesID,
			rateGen.TimezonesPercentage,
			IF(rateGen.PackageID = 0, "1", IFNULL(st.Name,'')),
			IF( percentageRate = '' OR percentageRate is null	,0, percentageRate ),rateGen.SelectType,IFNULL(Reseller,'0'),IFNULL(AppliedTo,'')
			INTO @v_RatePosition_, @v_CompanyId_,   @v_RateGeneratorName_,@p_RateGeneratorId, @v_CurrencyID_,
			
			@v_Calls,
			@v_Minutes,
			@v_StartDate_ ,@v_EndDate_ ,@v_TimezonesID, @v_TimezonesPercentage,@v_PackageID,
			@v_percentageRate_,@v_PackageType,@p_Reseller,@p_AppliedTo
		FROM tblRateGenerator rateGen INNER JOIN tblPackage st ON  st.PackageId =  rateGen.PackageID
		WHERE RateGeneratorId = @p_RateGeneratorId;
	
	END IF;
	

	
			

		select CodeDeckId INTO @v_CodeDeckId from tblCodeDeck where CompanyId = @v_CompanyId_ and CodeDeckName = 'Default Codedeck';
		
		SELECT CurrencyId INTO @v_CompanyCurrencyID_ FROM  tblCompany WHERE CompanyID = @v_CompanyId_;
		
		SELECT IFNULL(Value,1) INTO @v_RateApprovalProcess_ FROM tblCompanySetting WHERE CompanyID = @v_CompanyId_ AND `Key`='RateApprovalProcess';

		SET @v_RateApprovalStatus_ = 0;
		IF @v_RateApprovalProcess_ = 1 THEN
			SET @v_RateApprovalStatus_ = 0;
		END IF;
		IF @v_RateApprovalProcess_ = 0 THEN
			SET @v_RateApprovalStatus_ = 1;
		END IF;
		
		INSERT INTO tmp_Raterules_(
			rateruleid ,
			Component,
			
			TimezonesID ,
			PackageID,
			`Order` ,
			RowNo 
		)
			SELECT
				rateruleid,
				Component,
				
				TimeOfDay as TimezonesID,
				IF(Package = '' OR Package is null, "0", Package),
				`Order`,
				@row_num := @row_num+1 AS RowID
			FROM tblRateRule,(SELECT @row_num := 0) x
			WHERE rategeneratorid = @p_RateGeneratorId
			ORDER BY `Order` ASC;  


		
		INSERT INTO tmp_RateGeneratorCalculatedRate_
			(
			CalculatedRateID ,
			Component ,
			
			TimezonesID ,
			RateLessThen,
			ChangeRateTo ,
			PackageID,
			RowNo )
			SELECT
			
			CalculatedRateID ,
			Component ,
			
			TimezonesID ,
			RateLessThen	,
			ChangeRateTo ,
			IF(Package = '', "0", Package),
			@row_num := @row_num+1 AS RowID
			FROM tblRateGeneratorCalculatedRate,(SELECT @row_num := 0) x
			WHERE RateGeneratorId = @p_RateGeneratorId
			ORDER BY CalculatedRateID ASC;  			



				set @v_ApprovedStatus = 1;

				set @v_PKGType = 3; 

			  	set @v_AppliedToCustomer = 1; 
				set @v_AppliedToVendor = 2; 
				set @v_AppliedToReseller = 3; 
				
				


	
			SET @p_Calls	 							 = @v_Calls;
			SET @p_Minutes	 							 = @v_Minutes;
			SET @v_PeakTimeZoneID	 				 = @v_TimezonesID;
			SET @p_PeakTimeZonePercentage	 		 = @v_TimezonesPercentage;		
			SET @p_MobileOriginationPercentage	 = @v_OriginationPercentage ;	

			SET @p_Prefix = TRIM(LEADING '0' FROM @p_Prefix);

		
			
			IF @p_Calls = 0 AND @p_Minutes = 0 THEN
			
			
				
				select count(UsageDetailID)  into @p_Calls 
				
				from speakintelligentCDR.tblUsageDetails  d  

				inner join speakintelligentCDR.tblUsageHeader h on d.UsageHeaderID = h.UsageHeaderID   
				where CompanyID = @v_CompanyId_ AND StartDate >= @v_StartDate_ AND StartDate <= @v_EndDate_ and d.is_inbound = 1;  

				
				
				insert into tmp_timezone_minutes (TimezonesID, minutes)  
								
				select TimezonesID as TimezonesID , (sum(billed_duration) / 60) as minutes
				
				from speakintelligentCDR.tblUsageDetails  d  
				inner join speakintelligentCDR.tblUsageHeader h on d.UsageHeaderID = h.UsageHeaderID   
				where CompanyID = @v_CompanyId_ AND StartDate >= @v_StartDate_ AND StartDate <= @v_EndDate_ and d.is_inbound = 1 and TimezonesID is not null
				group by TimezonesID;  
				

					
					
				

			SET @v_timeZoneCount = ( SELECT COUNT(*) FROM tmp_timezone_minutes );
			if @v_timeZoneCount = 0 THEN
				insert into tmp_timezone_minutes (TimezonesID, minutes) values (1,1);
			end if;

				
			ELSE 
			
			
				
				
				SET @p_MobileOrigination				 = @v_Origination ; 
				SET @v_PeakTimeZoneMinutes				 =  ( (@p_Minutes/ 100) * @p_PeakTimeZonePercentage ) 	; 
				SET @v_MinutesFromMobileOrigination  =  ( (@p_Minutes/ 100) * @p_MobileOriginationPercentage ) 	; 

		 
				 
				insert into tmp_timezones (TimezonesID) select TimezonesID from 	tblTimezones;
				
				insert into tmp_timezone_minutes (TimezonesID, minutes) select @v_TimezonesID, @v_PeakTimeZoneMinutes as minutes;
				
				SET @v_RemainingTimezones = (select count(*) from tmp_timezones where TimezonesID != @v_TimezonesID); 
				SET @v_RemainingMinutes = (@p_Minutes - @v_PeakTimeZoneMinutes) / @v_RemainingTimezones ;
				
				SET @v_pointer_ = 1;
				SET @v_rowCount_ = ( SELECT COUNT(*) FROM tmp_timezones );

				WHILE @v_pointer_ <= @v_rowCount_
				DO

						SET @v_NewTimezonesID = (SELECT TimezonesID FROM tmp_timezones WHERE ID = @v_pointer_ AND TimezonesID != @v_TimezonesID );

						if @v_NewTimezonesID > 0  THEN
						
							insert into tmp_timezone_minutes (TimezonesID, minutes)  select @v_NewTimezonesID, @v_RemainingMinutes as minutes;

						END IF ;

					SET @v_pointer_ = @v_pointer_ + 1;

				END WHILE;
			
			
			
			
				

				
		END IF;
		
		
		
		SET @v_days =    TIMESTAMPDIFF(DAY, (SELECT @v_StartDate_), (SELECT @v_EndDate_)) + 1 ;
		SET @v_period1 =      IF(MONTH((SELECT @v_StartDate_)) = MONTH((SELECT @v_EndDate_)), 0, (TIMESTAMPDIFF(DAY, (SELECT @v_StartDate_), LAST_DAY((SELECT @v_StartDate_)) + INTERVAL 1 DAY)) / DAY(LAST_DAY((SELECT @v_StartDate_))));     
		SET @v_period2 =      TIMESTAMPDIFF(MONTH, LAST_DAY((SELECT @v_StartDate_)) + INTERVAL 1 DAY, LAST_DAY((SELECT @v_EndDate_))) ;
		SET @v_period3 =      IF(MONTH((SELECT @v_StartDate_)) = MONTH((SELECT @v_EndDate_)), (SELECT @v_days), DAY((SELECT @v_EndDate_))) / DAY(LAST_DAY((SELECT @v_EndDate_)));
		SET @v_months =     (SELECT @v_period1) + (SELECT @v_period2) + (SELECT @v_period3);

		SET @v_months = ROUND(@v_months,1);
		
		
		insert into tmp_timezone_minutes_2 (TimezonesID, minutes) select TimezonesID, minutes from tmp_timezone_minutes;
		insert into tmp_timezone_minutes_3 (TimezonesID, minutes) select TimezonesID, minutes from tmp_timezone_minutes;
		
	
			
	IF @v_RateGenartorPackageID = 0 THEN
	


										insert into tmp_table_with_origination (
																RateTableID,
																TimezonesID,
																TimezoneTitle,
																CodeDeckId,
																PackageID,
																Code,
																
																VendorID,
																VendorName,
																EndDate,
																OneOffCost,
																MonthlyCost,
																PackageCostPerMinute,
																RecordingCostPerMinute,
																
																OneOffCostCurrency,
																MonthlyCostCurrency,
																PackageCostPerMinuteCurrency,
																RecordingCostPerMinuteCurrency,															

																Total1,
																Total
																)
																
	select
								rt.RateTableID,
								drtr.TimezonesID,
								t.Title as TimezoneTitle,
								r.CodeDeckId,
								(select PackageId from tblPackage where Name =r.Code and CompanyID = @v_RateGenatorCompanyID) ,
								r.Code,
								
								a.AccountID,
								a.AccountName,
								drtr.EndDate,
								@OneOffCost := CASE WHEN ( OneOffCostCurrency is not null)
								THEN

								CASE WHEN  @v_CurrencyID_ = OneOffCostCurrency THEN
									drtr.OneOffCost
								ELSE
								(
									
									(Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId =  @v_CurrencyID_  and  CompanyID = @v_CompanyId_  )
									* (drtr.OneOffCost  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = OneOffCostCurrency and  CompanyID = @v_CompanyId_ ))
								)
								END

								WHEN  ( @v_CurrencyID_ = rt.CurrencyID ) THEN
									drtr.OneOffCost
								ELSE
									(
										
										(Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId =  @v_CurrencyID_  and  CompanyID = @v_CompanyId_ )
										* (drtr.OneOffCost  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = rt.CurrencyID and  CompanyID = @v_CompanyId_ ))
									)
								END as OneOffCost,
								@MonthlyCost := ( ( CASE WHEN ( MonthlyCostCurrency is not null)  
								THEN

								CASE WHEN  @v_CurrencyID_ = MonthlyCostCurrency THEN
									drtr.MonthlyCost
								ELSE
								(
									
									(Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId =  @v_CurrencyID_  and  CompanyID = @v_CompanyId_  )
									* (drtr.MonthlyCost  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = MonthlyCostCurrency and  CompanyID = @v_CompanyId_ ))
								)
								END

								WHEN  ( @v_CurrencyID_ = rt.CurrencyID ) THEN
									drtr.MonthlyCost
								ELSE
									(
										
										(Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId =  @v_CurrencyID_  and  CompanyID = @v_CompanyId_ )
										* (drtr.MonthlyCost  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = rt.CurrencyID and  CompanyID = @v_CompanyId_ ))
									)
								END) * @v_months) as MonthlyCost,

								@PackageCostPerMinute := CASE WHEN ( PackageCostPerMinuteCurrency is not null)
								THEN

								CASE WHEN  @v_CurrencyID_ = PackageCostPerMinuteCurrency THEN
									drtr.PackageCostPerMinute
								ELSE
								(
									
									(Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId =  @v_CurrencyID_  and  CompanyID = @v_CompanyId_ )
									* (drtr.PackageCostPerMinute  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = PackageCostPerMinuteCurrency and  CompanyID = @v_CompanyId_ ))
								)
								END

								WHEN  ( @v_CurrencyID_ = rt.CurrencyID ) THEN
									drtr.PackageCostPerMinute
								ELSE
									(
										
										(Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId =  @v_CurrencyID_  and  CompanyID = @v_CompanyId_ )
										* (drtr.PackageCostPerMinute  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = rt.CurrencyID and  CompanyID = @v_CompanyId_ ))
									)
								END as PackageCostPerMinute,

								@RecordingCostPerMinute := CASE WHEN ( RecordingCostPerMinuteCurrency is not null)
								THEN

								CASE WHEN  @v_CurrencyID_ = RecordingCostPerMinuteCurrency THEN
									drtr.RecordingCostPerMinute
								ELSE
								(
									
									(Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId =  @v_CurrencyID_  and  CompanyID = @v_CompanyId_ )
									* (drtr.RecordingCostPerMinute  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = RecordingCostPerMinuteCurrency and  CompanyID = @v_CompanyId_ ))
								)
								END

								WHEN  ( @v_CurrencyID_ = rt.CurrencyID ) THEN
									drtr.RecordingCostPerMinute
								ELSE
									(
										
										(Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId =  @v_CurrencyID_  and  CompanyID = @v_CompanyId_ )
										* (drtr.RecordingCostPerMinute  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = rt.CurrencyID and  CompanyID = @v_CompanyId_ ))
									)
								END as RecordingCostPerMinute,


								
								
								OneOffCostCurrency,
								MonthlyCostCurrency,
								PackageCostPerMinuteCurrency,
								RecordingCostPerMinuteCurrency,
																
								
								
								
							 
							 
							 @Total1 := (
									(	IFNULL(@MonthlyCost,0) 				)				+
									(IFNULL(@PackageCostPerMinute,0) * IFNULL(tom.minutes,0))	+
											+
									(IFNULL(@RecordingCostPerMinute,0) * IFNULL(tom.minutes,0)) 


								) as Total1,

								@Total := @Total1 as Total
								
 
				from tblRateTablePKGRate  drtr
				inner join tblRateTable  rt on rt.RateTableId = drtr.RateTableId 
				 inner join tblVendorConnection vc on vc.RateTableID = rt.RateTableId and vc.CompanyID = rt.CompanyId  and vc.Active=1
				inner join tblAccount a on vc.AccountId = a.AccountID and rt.CompanyId = a.CompanyId
				inner join tblRate r on drtr.RateID = r.RateID and r.CompanyID = vc.CompanyID
				
				
				
				
				inner join tblTimezones t on t.TimezonesID =  drtr.TimezonesID
				left join tmp_timezone_minutes tom on tom.TimezonesID = t.TimezonesID
				WHERE
								rt.CompanyId =  @v_CompanyId_			
								AND rt.Type = @v_PackageType 
								AND rt.AppliedTo = @v_AppliedToVendor 
								and (
							 (p_EffectiveRate = 'now' AND EffectiveDate <= NOW())
					 OR
					 (p_EffectiveRate = 'future' AND EffectiveDate > NOW()  )
					 OR
					 (	 p_EffectiveRate = 'effective' AND EffectiveDate <= @p_EffectiveDate
							 AND ( drtr.EndDate IS NULL OR (drtr.EndDate > DATE(@p_EffectiveDate)) )
					 )  
				)			
								 ;

	ELSE
			
			insert into tmp_table_with_origination (
																RateTableID,
																TimezonesID,
																TimezoneTitle,
																CodeDeckId,
																PackageID,
																Code,
																
																VendorID,
																VendorName,
																EndDate,
																OneOffCost,
																MonthlyCost,
																PackageCostPerMinute,
																RecordingCostPerMinute,
																
																OneOffCostCurrency,
																MonthlyCostCurrency,
																PackageCostPerMinuteCurrency,
																RecordingCostPerMinuteCurrency,															

																Total1,
																Total
																)
																
	select
								rt.RateTableID,
								drtr.TimezonesID,
								t.Title as TimezoneTitle,
								r.CodeDeckId,
								st.PackageId,
								r.Code,
								
								a.AccountID,
								a.AccountName,
								drtr.EndDate,
								@OneOffCost := CASE WHEN ( OneOffCostCurrency is not null)
								THEN

								CASE WHEN  @v_CurrencyID_ = OneOffCostCurrency THEN
									drtr.OneOffCost
								ELSE
								(
									
									(Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId =  @v_CurrencyID_  and  CompanyID = @v_CompanyId_  )
									* (drtr.OneOffCost  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = OneOffCostCurrency and  CompanyID = @v_CompanyId_ ))
								)
								END

								WHEN  ( @v_CurrencyID_ = rt.CurrencyID ) THEN
									drtr.OneOffCost
								ELSE
									(
										
										(Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId =  @v_CurrencyID_  and  CompanyID = @v_CompanyId_ )
										* (drtr.OneOffCost  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = rt.CurrencyID and  CompanyID = @v_CompanyId_ ))
									)
								END as OneOffCost,
								@MonthlyCost := ( ( CASE WHEN ( MonthlyCostCurrency is not null)  
								THEN

								CASE WHEN  @v_CurrencyID_ = MonthlyCostCurrency THEN
									drtr.MonthlyCost
								ELSE
								(
									
									(Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId =  @v_CurrencyID_  and  CompanyID = @v_CompanyId_  )
									* (drtr.MonthlyCost  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = MonthlyCostCurrency and  CompanyID = @v_CompanyId_ ))
								)
								END

								WHEN  ( @v_CurrencyID_ = rt.CurrencyID ) THEN
									drtr.MonthlyCost
								ELSE
									(
										
										(Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId =  @v_CurrencyID_  and  CompanyID = @v_CompanyId_ )
										* (drtr.MonthlyCost  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = rt.CurrencyID and  CompanyID = @v_CompanyId_ ))
									)
								END) * @v_months) as MonthlyCost,

								@PackageCostPerMinute := CASE WHEN ( PackageCostPerMinuteCurrency is not null)
								THEN

								CASE WHEN  @v_CurrencyID_ = PackageCostPerMinuteCurrency THEN
									drtr.PackageCostPerMinute
								ELSE
								(
									
									(Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId =  @v_CurrencyID_  and  CompanyID = @v_CompanyId_ )
									* (drtr.PackageCostPerMinute  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = PackageCostPerMinuteCurrency and  CompanyID = @v_CompanyId_ ))
								)
								END

								WHEN  ( @v_CurrencyID_ = rt.CurrencyID ) THEN
									drtr.PackageCostPerMinute
								ELSE
									(
										
										(Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId =  @v_CurrencyID_  and  CompanyID = @v_CompanyId_ )
										* (drtr.PackageCostPerMinute  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = rt.CurrencyID and  CompanyID = @v_CompanyId_ ))
									)
								END as PackageCostPerMinute,

								@RecordingCostPerMinute := CASE WHEN ( RecordingCostPerMinuteCurrency is not null)
								THEN

								CASE WHEN  @v_CurrencyID_ = RecordingCostPerMinuteCurrency THEN
									drtr.RecordingCostPerMinute
								ELSE
								(
									
									(Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId =  @v_CurrencyID_  and  CompanyID = @v_CompanyId_ )
									* (drtr.RecordingCostPerMinute  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = RecordingCostPerMinuteCurrency and  CompanyID = @v_CompanyId_ ))
								)
								END

								WHEN  ( @v_CurrencyID_ = rt.CurrencyID ) THEN
									drtr.RecordingCostPerMinute
								ELSE
									(
										
										(Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId =  @v_CurrencyID_  and  CompanyID = @v_CompanyId_ )
										* (drtr.RecordingCostPerMinute  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = rt.CurrencyID and  CompanyID = @v_CompanyId_ ))
									)
								END as RecordingCostPerMinute,


								
								
								OneOffCostCurrency,
								MonthlyCostCurrency,
								PackageCostPerMinuteCurrency,
								RecordingCostPerMinuteCurrency,
																
								
								
								
							 
							 
							 @Total1 := (
									(	IFNULL(@MonthlyCost,0) 				)				+
									(IFNULL(@PackageCostPerMinute,0) * IFNULL(tom.minutes,0))	+
											+
									(IFNULL(@RecordingCostPerMinute,0) * IFNULL(tom.minutes,0)) 


								) as Total1,

								@Total := @Total1 as Total
								
 
				from tblRateTablePKGRate  drtr
				inner join tblRateTable  rt on rt.RateTableId = drtr.RateTableId 
				 inner join tblVendorConnection vc on vc.RateTableID = rt.RateTableId and vc.CompanyID = rt.CompanyId  and vc.Active=1
				inner join tblAccount a on vc.AccountId = a.AccountID and rt.CompanyId = a.CompanyId
				inner join tblRate r on drtr.RateID = r.RateID and r.CompanyID = vc.CompanyID
				INNER JOIN tblPackage st ON st.CompanyID = r.CompanyID AND st.Name = @v_PackageID AND  r.Code = st.Name
				
				
				
				inner join tblTimezones t on t.TimezonesID =  drtr.TimezonesID
				left join tmp_timezone_minutes tom on tom.TimezonesID = t.TimezonesID
				WHERE
								rt.CompanyId =  @v_CompanyId_			
								AND rt.Type = @v_PackageType 
								AND rt.AppliedTo = @v_AppliedToVendor 
								and (
							 (p_EffectiveRate = 'now' AND EffectiveDate <= NOW())
					 OR
					 (p_EffectiveRate = 'future' AND EffectiveDate > NOW()  )
					 OR
					 (	 p_EffectiveRate = 'effective' AND EffectiveDate <= @p_EffectiveDate
							 AND ( drtr.EndDate IS NULL OR (drtr.EndDate > DATE(@p_EffectiveDate)) )
					 )  
				)			
								 ;
																			
	END IF;
		 
		 
			
		-- select * from tmp_table_with_origination;
			
				insert into tmp_tblRateTablePKGRate (
										RateTableID,
										TimezonesID,
										TimezoneTitle,
										CodeDeckId,
										PackageID,
										Code,
										
										VendorID,
										VendorName,
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
										RateTableID,
										TimezonesID,
										TimezoneTitle,
										CodeDeckId,
										PackageID,
										Code,
										
										VendorID,
										VendorName,
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
										from 
												tmp_table_with_origination
						
										
										where Total is not null;
																		
 
 		
		 -- select * from tmp_tblRateTablePKGRate;

		 
			insert into tmp_vendor_position (VendorID , vPosition,Total,Package)
			select
			VendorID , vPosition,Total,Package
			from (

				SELECT
					distinct
					v.VendorID,
					v.Total,
					v.Package,
					@rank := ( CASE WHEN(@prev_VendorID != v.VendorID and @prev_Total <= v.Total AND (@v_percentageRate_ = 0 OR  (IFNULL(@prev_Total,0) != 0 and  @v_percentageRate_ > 0 AND ROUND(((v.Total - @prev_Total) /( @prev_Total * 100)),2) > @v_percentageRate_) )   )
						THEN  @rank + 1
										 ELSE 1
										 END
					) AS vPosition,
					@prev_VendorID := v.VendorID,
					@prev_Total := v.Total

				FROM (
				
						select distinct  VendorID , sum(Total) as Total,PackageID as Package  from tmp_tblRateTablePKGRate group by VendorID,PackageID
					) v
					, (SELECT  @prev_VendorID := NUll ,  @rank := 0 ,  @prev_Total := 0 ) f

				order by v.Total,v.VendorID asc
			) tmp
			where vPosition <= @v_RatePosition_; 
			
			insert into tmp_vendor_position (VendorID , vPosition,Total,Package)
			select
			VendorID , vPosition,Total,Package
			from (

				SELECT
					distinct
					v.VendorID,
					v.Total,
					v.Package,
					@rank := ( CASE WHEN(@prev_VendorID != v.VendorID and @prev_Total <= v.Total AND (@v_percentageRate_ = 0 OR  (IFNULL(@prev_Total,0) != 0 and  @v_percentageRate_ > 0 AND ROUND(((v.Total - @prev_Total) /( @prev_Total * 100)),2) > @v_percentageRate_) )   )
						THEN  @rank + 1
										 ELSE 1
										 END
					) AS vPosition,
					@prev_VendorID := v.VendorID,
					@prev_Total := v.Total

				FROM (
				
						select distinct  VendorID , sum(Total) as Total,0 as Package  from tmp_tblRateTablePKGRate group by VendorID
					) v
					, (SELECT  @prev_VendorID := NUll ,  @rank := 0 ,  @prev_Total := 0 ) f

				order by v.Total,v.VendorID asc
			) tmp
			where vPosition <= @v_RatePosition_; 

			SET @v_SelectedVendor = ( select VendorID from tmp_vendor_position where vPosition <= @v_RatePosition_ order by vPosition , Total  limit 1 );
		
		
	--	 select * from tmp_vendor_position;
	--	 select @v_SelectedVendor;
		 

	
	insert into tmp_SelectedVendortblRateTablePKGRate
			(
					RateTableID,
					TimezonesID,
					TimezoneTitle,
					Code,
					
					VendorID,
					CodeDeckId,
					PackageID,
					VendorName,
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
					TimezonesID,
					TimezoneTitle,
					Code,
					
					VendorID,
					CodeDeckId,
					PackageID,
					VendorName,
					EndDate,

					IFNULL(OneOffCost,0),
					IFNULL(MonthlyCost,0),
					IFNULL(PackageCostPerMinute,0),
					IFNULL(RecordingCostPerMinute,0),
					
					
					OneOffCostCurrency,
	MonthlyCostCurrency,
	PackageCostPerMinuteCurrency,
	RecordingCostPerMinuteCurrency					
					
			from tmp_tblRateTablePKGRate
			
			where VendorID = @v_SelectedVendor ;
	

			
		 -- select * from tmp_SelectedVendortblRateTablePKGRate;
		

		
			DROP TEMPORARY TABLE IF EXISTS tmp_MergeComponents;
			CREATE TEMPORARY TABLE tmp_MergeComponents(
				ID int auto_increment,
				Component TEXT  ,
				TimezonesID INT(11)   ,
				ToTimezonesID INT(11)   ,
				Action CHAR(4)    ,
				MergeTo TEXT  ,
				Package INT(11)   ,
				
				primary key (ID)
			);
			
			insert into tmp_MergeComponents ( 
									Component,
									TimezonesID,
									ToTimezonesID,
									Action,
									MergeTo,
									Package
									

			)
			select 
									Component,
									TimezonesID,
									ToTimezonesID,
									Action,
									MergeTo,
									IF(Package = '' OR Package is null, "0", Package)
									

			from tblRateGeneratorCostComponent 
			where RateGeneratorId = @p_RateGeneratorId 
			order by CostComponentID asc;
 
		 
	--	select * from tmp_MergeComponents;
	--	select * from tmp_SelectedVendortblRateTablePKGRate;
		
 
	 	SET @v_pointer_ = 1;
		SET @v_rowCount_ = ( SELECT COUNT(*) FROM tmp_MergeComponents );
		SET @v_MOneOffCost = '';
		SET @v_MMonthlyCost = '';
		SET @v_MPackageCostPerMinute = '';
		SET @v_MRecordingCostPerMinute = '';			
		SET @v_costMergeCompnents = '';


		WHILE @v_pointer_ <= @v_rowCount_
		DO
		SET @v_MOneOffCost = '';
		SET @v_MMonthlyCost = '';
		SET @v_MPackageCostPerMinute = '';
		SET @v_MRecordingCostPerMinute = '';
		SET @v_costMergeCompnents = '';
				
				SELECT 
						Component,
						TimezonesID,
						ToTimezonesID,
						Action,
						MergeTo,
						Package
						
				
				INTO
				
						@v_Component,
						@v_TimezonesID,
						@v_ToTimezonesID,
						@v_Action,
						@v_MergeTo,
						@v_MergePackage
					
				
				FROM tmp_MergeComponents WHERE ID = @v_pointer_;

				IF @v_Action = 'sum' THEN
				
					SET @ResultField = concat('(' ,  REPLACE(@v_Component,',',' + ') , ') ');
				

				ELSE 
				
					
					if INSTR(@v_Component,',') > 0 then
					if INSTR(@v_Component,'OneOffCost') THEN
						SET @v_MOneOffCost = 'OneOffCost';
						
					END IF;
					if INSTR(@v_Component,'MonthlyCost') THEN
						SET @v_MMonthlyCost = 'MonthlyCost';
						
					END IF;
					if INSTR(@v_Component,'PackageCostPerMinute') THEN
						SET @v_MPackageCostPerMinute = 'PackageCostPerMinute';
						
					END IF;
					if INSTR(@v_Component,'RecordingCostPerMinute') THEN
						SET @v_MRecordingCostPerMinute = 'RecordingCostPerMinute';
						
					END IF;
					select GREATEST(@v_MOneOffCost,@v_MMonthlyCost,@v_MPackageCostPerMinute,@v_MRecordingCostPerMinute) into @ResultField;
					
					ELSE
						SET @ResultField = @v_Component;
					end if;
				
				END IF;	
				
						

				IF @v_MergePackage = 0 THEN
				
				SET @v_SelectedVendor = ( select VendorID from tmp_vendor_position where vPosition <= @v_RatePosition_ and Package=@v_MergePackage order by vPosition , Total  limit 1 );
			
				SET @stm1 = CONCAT('					
						update tmp_SelectedVendortblRateTablePKGRate srt
						inner join (

								select 
								
									TimezonesID,
									Code,
									
									', @ResultField , ' as componentValue
									
									from tmp_tblRateTablePKGRate 
									
							
								where 
									VendorID = @v_SelectedVendor
									
								AND (  @v_TimezonesID = "" OR  TimezonesID = @v_TimezonesID)
								
								
									
									 
									
						) tmp on 
								  @v_ToTimezonesID = "" OR  srt.TimezonesID = @v_ToTimezonesID
								
						set 
						
						' , 'new_', @v_MergeTo , ' = tmp.componentValue;
				');
				
			--	select @stm1;
					if @stm1 is not null then
						PREPARE stm1 FROM @stm1;
						EXECUTE stm1;
					end if;
			
			ELSE
			SET @v_SelectedVendor = ( select VendorID from tmp_vendor_position where vPosition <= @v_RatePosition_ and Package=@v_MergePackage order by vPosition , Total  limit 1 );
			SET @stm1 = CONCAT('					
						update tmp_SelectedVendortblRateTablePKGRate srt
						inner join (

								select 
								
									TimezonesID,
									Code,
									
									', @ResultField , ' as componentValue
									
									from tmp_tblRateTablePKGRate 
									
							
								where 
									VendorID = @v_SelectedVendor
									AND PackageID = @v_MergePackage
								AND (  @v_TimezonesID = "" OR  TimezonesID = @v_TimezonesID)
								
								
									
									 
									
						) tmp on 
								tmp.Code = srt.Code
								AND (  @v_ToTimezonesID = "" OR  srt.TimezonesID = @v_ToTimezonesID)
								
						set 
						
						' , 'new_', @v_MergeTo , ' = tmp.componentValue;
				');
				
				--	select @stm1;
					if @stm1 is not null then
						PREPARE stm1 FROM @stm1;
						EXECUTE stm1;
					end if;
			
			END IF;
		
			
				
			
				IF ROW_COUNT()  = 0 THEN
				
				
				
						insert into tmp_SelectedVendortblRateTablePKGRate
						(
								TimezonesID,
								TimezoneTitle,
								Code,
								
								VendorID,
								CodeDeckId,
								PackageID,
								VendorName,
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
								IF(@v_ToTimezonesID = '',TimezonesID,@v_ToTimezonesID) as TimezonesID,
								TimezoneTitle,
								 Code,
								
								VendorID,
								CodeDeckId,
								PackageID,
								VendorName,
								EndDate,
								OneOffCost,
										MonthlyCost,
										PackageCostPerMinute,
	RecordingCostPerMinute,
	OneOffCostCurrency,
	MonthlyCostCurrency,
	PackageCostPerMinuteCurrency,
	RecordingCostPerMinuteCurrency
								
						from tmp_tblRateTablePKGRate
					
						where 
							VendorID = @v_SelectedVendor
							AND (  @v_TimezonesID = "" OR  TimezonesID = @v_TimezonesID)
							
							;
							
							
				
				END IF;

		if @stm1 is not null then
				DEALLOCATE PREPARE stm1;
		end if;
		
				 

			SET @v_pointer_ = @v_pointer_ + 1;

		END WHILE;
		
	
		 
	--	 select * from tmp_SelectedVendortblRateTablePKGRate;	
	

		update tmp_SelectedVendortblRateTablePKGRate	
		SET 
			OneOffCost  = IF(new_OneOffCost is null , OneOffCost ,new_OneOffCost)  	,
			MonthlyCost  = IF(new_MonthlyCost is null , MonthlyCost ,new_MonthlyCost)  	,
			PackageCostPerMinute  = IF(new_PackageCostPerMinute is null , PackageCostPerMinute ,new_PackageCostPerMinute)  	,
			RecordingCostPerMinute  = IF(new_RecordingCostPerMinute is null , RecordingCostPerMinute ,new_RecordingCostPerMinute)  	
			;


	
 
		 
		
		

	 	SET @v_pointer_ = 1;
		SET @v_rowCount_ = ( SELECT COUNT(*) FROM tmp_Raterules_ );
		
		-- select * from tmp_Raterules_;
		-- select * from tmp_SelectedVendortblRateTablePKGRate;

		WHILE @v_pointer_ <= @v_rowCount_
		DO

			SET @v_rateRuleId_ = (SELECT rateruleid FROM tmp_Raterules_ rr WHERE rr.RowNo = @v_pointer_);
			SET @v_rateRulePackageId = (SELECT PackageID FROM tmp_Raterules_ rr WHERE rr.RowNo = @v_pointer_);
		
		
		
		
		
				IF @v_rateRulePackageId = 0 THEN
						update tmp_SelectedVendortblRateTablePKGRate rt
						inner join tmp_Raterules_ rr on rr.RowNo  = @v_pointer_  
						and  rr.TimezonesID  = rt.TimezonesID 
						and rr.PackageID = 0 
					
					

						LEFT join tblRateRuleMargin rule_mgn1 on  rule_mgn1.RateRuleId = @v_rateRuleId_
						AND
						(
							(rr.Component = 'OneOffCost' AND (OneOffCost Between rule_mgn1.MinRate and rule_mgn1.MaxRate OR rule_mgn1.MinRate is null and rule_mgn1.MaxRate is null)) OR
							(rr.Component = 'MonthlyCost' AND (MonthlyCost Between rule_mgn1.MinRate and rule_mgn1.MaxRate OR rule_mgn1.MinRate is null and rule_mgn1.MaxRate is null)) OR
							(rr.Component = 'PackageCostPerMinute' AND (PackageCostPerMinute Between rule_mgn1.MinRate and rule_mgn1.MaxRate OR rule_mgn1.MinRate is null and rule_mgn1.MaxRate is null)) OR
							(rr.Component = 'RecordingCostPerMinute' AND (RecordingCostPerMinute Between rule_mgn1.MinRate and rule_mgn1.MaxRate OR rule_mgn1.MinRate is null and rule_mgn1.MaxRate is null))
							
							
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
			
			ELSE
			
			update tmp_SelectedVendortblRateTablePKGRate rt
						inner join tmp_Raterules_ rr on rr.RowNo  = @v_pointer_  
						and  rr.TimezonesID  = rt.TimezonesID 
						and (rr.PackageID = rt.PackageID )
					
					

						LEFT join tblRateRuleMargin rule_mgn1 on  rule_mgn1.RateRuleId = @v_rateRuleId_
						AND
						(
							(rr.Component = 'OneOffCost' AND (OneOffCost Between rule_mgn1.MinRate and rule_mgn1.MaxRate  OR rule_mgn1.MinRate is null and rule_mgn1.MaxRate is null)) OR
							(rr.Component = 'MonthlyCost' AND (MonthlyCost Between rule_mgn1.MinRate and rule_mgn1.MaxRate  OR rule_mgn1.MinRate is null and rule_mgn1.MaxRate is null)) OR
							(rr.Component = 'PackageCostPerMinute' AND (PackageCostPerMinute Between rule_mgn1.MinRate and rule_mgn1.MaxRate  OR rule_mgn1.MinRate is null and rule_mgn1.MaxRate is null)) OR
							(rr.Component = 'RecordingCostPerMinute' AND (RecordingCostPerMinute Between rule_mgn1.MinRate and rule_mgn1.MaxRate  OR rule_mgn1.MinRate is null and rule_mgn1.MaxRate is null))
							
							
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
			

				END IF;
			
			
			SET @v_pointer_ = @v_pointer_ + 1;

		END WHILE;



	
	 
		-- select * from tmp_SelectedVendortblRateTablePKGRate;
	
		-- select * from tmp_RateGeneratorCalculatedRate_;
	 	SET @v_pointer_ = 1;
		SET @v_rowCount_ = ( SELECT COUNT(*) FROM tmp_RateGeneratorCalculatedRate_ );


		WHILE @v_pointer_ <= @v_rowCount_
		DO

					select PackageID into @CalculatedRatePackageID from	tmp_RateGeneratorCalculatedRate_ rr where rr.RowNo  = @v_pointer_;
			
						
						if @CalculatedRatePackageID = 0 THEN
						
						update tmp_SelectedVendortblRateTablePKGRate rt
						inner join tmp_RateGeneratorCalculatedRate_ rr on 
						rr.RowNo  = @v_pointer_  AND rr.TimezonesID  = rt.TimezonesID	 and  rr.PackageID = 0 
						
						
						
						

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
						PackageCostPerMinute = CASE WHEN FIND_IN_SET(rr.Component,'PackageCostPerMinute') != 0 AND PackageCostPerMinute < RateLessThen AND rr.CalculatedRateID is not null THEN
						ChangeRateTo
						ELSE
						PackageCostPerMinute
						END,
						RecordingCostPerMinute = CASE WHEN FIND_IN_SET(rr.Component,'RecordingCostPerMinute') != 0 AND RecordingCostPerMinute < RateLessThen AND rr.CalculatedRateID is not null THEN
						ChangeRateTo
						ELSE
						RecordingCostPerMinute
						END
						;
						
			ELSE 
			
			update tmp_SelectedVendortblRateTablePKGRate rt
						inner join tmp_RateGeneratorCalculatedRate_ rr on 
						rr.RowNo  = @v_pointer_  AND rr.TimezonesID  = rt.TimezonesID  
						
						and rt.PackageID = 	rr.PackageID
						
						
						
						

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
						PackageCostPerMinute = CASE WHEN FIND_IN_SET(rr.Component,'PackageCostPerMinute') != 0 AND PackageCostPerMinute < RateLessThen AND rr.CalculatedRateID is not null THEN
						ChangeRateTo
						ELSE
						PackageCostPerMinute
						END,
						RecordingCostPerMinute = CASE WHEN FIND_IN_SET(rr.Component,'RecordingCostPerMinute') != 0 AND RecordingCostPerMinute < RateLessThen AND rr.CalculatedRateID is not null THEN
						ChangeRateTo
						ELSE
						RecordingCostPerMinute
						END
						;
 
			 END IF;

			SET @v_pointer_ = @v_pointer_ + 1;
			
			

		END WHILE;



	 
	
	 
		
		-- select * from tmp_SelectedVendortblRateTablePKGRate;	
		
		SET @v_SelectedRateTableID = ( select RateTableID from tmp_SelectedVendortblRateTablePKGRate limit 1 );

		SET @v_AffectedRecords_ = 0;
					
		START TRANSACTION;
		

		
		IF p_RateTableId = -1 THEN
		
			SET @v_codedeckid_ = ( select CodeDeckId from tmp_SelectedVendortblRateTablePKGRate limit 1 );
			
			INSERT INTO tblRateTable (Type, CompanyId, RateTableName, RateGeneratorID,DIDCategoryID, TrunkID, CodeDeckId,CurrencyID,Status, RoundChargedAmount,MinimumCallCharge,AppliedTo,Reseller,created_at,updated_at, CreatedBy,ModifiedBy)
			select  @v_PKGType as Type, @v_CompanyId_, p_rateTableName , @p_RateGeneratorId,0 as DIDCategoryID, 0 as TrunkID,  @v_CodeDeckId as CodeDeckId , @v_RateGenatorCurrencyID_ as CurrencyID, Status, RoundChargedAmount,MinimumCallCharge, @p_AppliedTo as AppliedTo, @p_Reseller as Reseller , now() ,now() ,p_ModifiedBy,p_ModifiedBy 
			from tblRateTable where RateTableID = @v_SelectedRateTableID  limit 1;
			
			SET @p_RateTableId = LAST_INSERT_ID();
			
			-- select  `AccountId`,  `RateTypeID`,  `ConnectionType`,  `CompanyID`,  `Name`,  `DIDCategoryID`,  `Active`,  `Tariff`,  `RateTableID`,  `TrunkID`,  `CLIRule`,  `CLDRule`,  `CallPrefix`,  `IP`,  `Port`,  `Username`,  Password,  now(),  `updated_at`,  `created_by`,  `updated_by` from tblVendorConnection where (AccountId,RateTableID) in (select RateTableID,VendorID from tmp_SelectedVendortblRateTablePKGRate group by VendorID);
		--	insert into tmp_tblVendorConnection	(AccountID,RateTableId)
		--	select VendorID,RateTableID from tmp_SelectedVendortblRateTablePKGRate group by VendorID;
		--	select * from tmp_tblVendorConnection;
		--	insert into tblVendorConnection(`AccountId`,  `RateTypeID`,  `ConnectionType`,  `CompanyID`,  `Name`,  `DIDCategoryID`,  `Active`,  `Tariff`,  RateTableID,  `TrunkID`,  `CLIRule`,  `CLDRule`,  `CallPrefix`,  `IP`,  `Port`,  `Username`,  Password,  created_at,  `updated_at`,  `created_by`,  `updated_by`)
		--	select  vConn.`AccountId`,  `RateTypeID`,  `ConnectionType`,  `CompanyID`,  `Name`,  `DIDCategoryID`,  `Active`,  `Tariff`,  @p_RateTableId,  `TrunkID`,  `CLIRule`,  `CLDRule`,  `CallPrefix`,  `IP`,  `Port`,  `Username`,  Password,  now(),  `updated_at`,  `created_by`,  `updated_by` from tblVendorConnection vConn,tmp_tblVendorConnection tvConn where vConn.AccountId = tvConn.AccountID and vConn.RateTableID = tvConn.RateTableId;
			
			
		ELSE 
		
			SET @p_RateTableId = p_RateTableId;
			
			IF p_delete_exiting_rate = 1 THEN
			
				UPDATE
					tblRateTablePKGRate
				SET
					EndDate = NOW()
				WHERE
					RateTableId = @p_RateTableId;

			
			 call prc_ArchiveOldRateTablePKGRate(@p_RateTableId, NULL,p_ModifiedBy);
			
			END IF;

			
			
			IF @v_RateApprovalProcess_ = 0 THEN
				update tblRateTablePKGRate rtd
				INNER JOIN tblRateTable rt  on rt.RateTableID = rtd.RateTableID
				INNER JOIN tblRate r
					ON rtd.RateID  = r.RateID  
				INNER JOIN tblPackage st ON st.CompanyID = r.CompanyID AND st.Name = drtr.Code AND  r.Code = st.Name
				inner join tmp_SelectedVendortblRateTablePKGRate drtr on
				drtr.Code = r.Code 
				and rtd.TimezonesID = drtr.TimezonesID 
				
				SET rtd.EndDate = NOW()
				
				where 
				rtd.RateTableID = @p_RateTableId and rtd.EffectiveDate = @p_EffectiveDate;
			END IF;
			
			IF @v_RateApprovalProcess_ = 1 THEN
				update tblRateTablePKGRateAA rtd
				INNER JOIN tblRateTable rt  on rt.RateTableID = rtd.RateTableID
				INNER JOIN tblRate r
					ON rtd.RateID  = r.RateID  
				INNER JOIN tblPackage st ON st.CompanyID = r.CompanyID AND st.Name = drtr.Code AND  r.Code = st.Name
				inner join tmp_SelectedVendortblRateTablePKGRate drtr on
				drtr.Code = r.Code 
				and rtd.TimezonesID = drtr.TimezonesID 
				
				SET rtd.EndDate = NOW()
				
				where 
				rtd.RateTableID = @p_RateTableId and rtd.EffectiveDate = @p_EffectiveDate;
			END IF;
			
			
			IF @v_RateApprovalProcess_ = 0 THEN	
		 call prc_ArchiveOldRateTablePKGRate(@p_RateTableId, NULL,p_ModifiedBy);
		END IF;
		IF @v_RateApprovalProcess_ = 1 THEN	
		 call prc_ArchiveOldRateTablePKGRateAA(@p_RateTableId, NULL,p_ModifiedBy);
		END IF;

		
		
			SET @v_AffectedRecords_ = @v_AffectedRecords_ + FOUND_ROWS();


		END IF;

   
	--  select @v_RateApprovalProcess_;
	-- select * from tmp_SelectedVendortblRateTablePKGRate order by Code;
	
	
	IF @v_RateApprovalProcess_ = 0 THEN	
	
	
						
	
						
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
						
						
		
						CASE WHEN ( drtr.OneOffCostCurrency is not null)
						THEN

						CASE WHEN  @v_CurrencyID_ = drtr.OneOffCostCurrency THEN
						drtr.OneOffCost
						ELSE
						(
						
						(Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId =  drtr.OneOffCostCurrency  and  CompanyID = @v_CompanyId_  )
						* (drtr.OneOffCost  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = @v_CurrencyID_ and  CompanyID = @v_CompanyId_ ))
						)
						END

						WHEN  ( @v_CurrencyID_ = rt.CurrencyID ) THEN
						drtr.OneOffCost
						ELSE
						(
							
							(Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId =  rt.CurrencyID  and  CompanyID = @v_CompanyId_ )
							* (drtr.OneOffCost  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = @v_CurrencyID_ and  CompanyID = @v_CompanyId_ ))
						)
						END as OneOffCost,
						
						( CASE WHEN ( drtr.MonthlyCostCurrency is not null)  
						THEN

						CASE WHEN  @v_CurrencyID_ = drtr.MonthlyCostCurrency THEN
						drtr.MonthlyCost
						ELSE
						(
						
						(Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId =  drtr.MonthlyCostCurrency  and  CompanyID = @v_CompanyId_  )
						* (drtr.MonthlyCost  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = @v_CurrencyID_ and  CompanyID = @v_CompanyId_ ))
						)
						END

						WHEN  ( @v_CurrencyID_ = rt.CurrencyID ) THEN
						drtr.MonthlyCost
						ELSE
						(
							
							(Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = rt.CurrencyID  and  CompanyID = @v_CompanyId_ )
							* (drtr.MonthlyCost  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = @v_CurrencyID_  and  CompanyID = @v_CompanyId_ ))
						)
						END) as MonthlyCost,

						CASE WHEN ( drtr.PackageCostPerMinuteCurrency is not null)
						THEN

						CASE WHEN  @v_CurrencyID_ = drtr.PackageCostPerMinuteCurrency THEN
						drtr.PackageCostPerMinute
						ELSE
						(
						
						(Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = drtr.PackageCostPerMinuteCurrency and  CompanyID = @v_CompanyId_ )
						* (drtr.PackageCostPerMinute  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = @v_CurrencyID_   and  CompanyID = @v_CompanyId_ ))
						)
						END

						WHEN  ( @v_CurrencyID_ = rt.CurrencyID ) THEN
						drtr.PackageCostPerMinute
						ELSE
						(
							
							(Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId =  rt.CurrencyID  and  CompanyID = @v_CompanyId_ )
							* (drtr.PackageCostPerMinute  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = @v_CurrencyID_  and  CompanyID = @v_CompanyId_ ))
						)
						END as PackageCostPerMinute,

						CASE WHEN ( drtr.RecordingCostPerMinuteCurrency is not null)
						THEN

						CASE WHEN  @v_CurrencyID_ = drtr.RecordingCostPerMinuteCurrency THEN
						drtr.RecordingCostPerMinute
						ELSE
						(
						
						(Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId =  drtr.RecordingCostPerMinuteCurrency  and  CompanyID = @v_CompanyId_ )
						* (drtr.RecordingCostPerMinute  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = @v_CurrencyID_ and  CompanyID = @v_CompanyId_ ))
						)
						END

						WHEN  ( @v_CurrencyID_ = rt.CurrencyID ) THEN
						drtr.RecordingCostPerMinute
						ELSE
						(
							
							(Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = rt.CurrencyID and  CompanyID = @v_CompanyId_ )
							* (drtr.RecordingCostPerMinute  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId =  @v_CurrencyID_   and  CompanyID = @v_CompanyId_ ))
						)
						END as RecordingCostPerMinute,


					
						
						
						drtr.OneOffCostCurrency,
						drtr.MonthlyCostCurrency,
						drtr.PackageCostPerMinuteCurrency,
						drtr.RecordingCostPerMinuteCurrency,

						
						@p_EffectiveDate as EffectiveDate,
						date(drtr.EndDate) as EndDate,
						@v_RateApprovalStatus_ as ApprovedStatus,


							now() as  created_at ,
							now() as updated_at ,
							p_ModifiedBy as CreatedBy ,
							p_ModifiedBy as ModifiedBy,
							drtr.VendorID


						
						from tmp_SelectedVendortblRateTablePKGRate drtr 	
						inner join tblRateTable  rt on rt.RateTableId = drtr.RateTableId 
						INNER JOIN tblRate r ON drtr.Code = r.Code and r.CodeDeckId = drtr.CodeDeckId
						INNER JOIN tblPackage st ON st.CompanyID = r.CompanyID AND st.Name = drtr.Code AND  r.Code = st.Name
						LEFT join tblRateTablePKGRate rtd  on rtd.RateID  = r.RateID 
						and  rtd.TimezonesID = drtr.TimezonesID 
						and rtd.RateTableID = @p_RateTableId
						and rtd.EffectiveDate = @p_EffectiveDate 
						WHERE rtd.RateTablePKGRateID is null;
						
						update tblRateTablePKGRate
						SET
						OneOffCost = IF (OneOffCost = 0, NULL,OneOffCost),
						MonthlyCost = IF (MonthlyCost = 0, NULL,MonthlyCost),
						PackageCostPerMinute = IF (PackageCostPerMinute = 0, NULL,PackageCostPerMinute),
						RecordingCostPerMinute = IF (RecordingCostPerMinute = 0, NULL,RecordingCostPerMinute),
						updated_at = now(),
						ModifiedBy = p_ModifiedBy
						where RateTableId = @p_RateTableId;
						
	END IF;


	IF @v_RateApprovalProcess_ = 1 THEN	
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
						
						
		
						CASE WHEN ( drtr.OneOffCostCurrency is not null)
						THEN

						CASE WHEN  @v_CurrencyID_ = drtr.OneOffCostCurrency THEN
						drtr.OneOffCost
						ELSE
						(
						
						(Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId =  drtr.OneOffCostCurrency  and  CompanyID = @v_CompanyId_  )
						* (drtr.OneOffCost  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = @v_CurrencyID_ and  CompanyID = @v_CompanyId_ ))
						)
						END

						WHEN  ( @v_CurrencyID_ = rt.CurrencyID ) THEN
						drtr.OneOffCost
						ELSE
						(
							
							(Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId =  rt.CurrencyID  and  CompanyID = @v_CompanyId_ )
							* (drtr.OneOffCost  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = @v_CurrencyID_ and  CompanyID = @v_CompanyId_ ))
						)
						END as OneOffCost,
						
						( CASE WHEN ( drtr.MonthlyCostCurrency is not null)  
						THEN

						CASE WHEN  @v_CurrencyID_ = drtr.MonthlyCostCurrency THEN
						drtr.MonthlyCost
						ELSE
						(
						
						(Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId =  drtr.MonthlyCostCurrency  and  CompanyID = @v_CompanyId_  )
						* (drtr.MonthlyCost  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = @v_CurrencyID_ and  CompanyID = @v_CompanyId_ ))
						)
						END

						WHEN  ( @v_CurrencyID_ = rt.CurrencyID ) THEN
						drtr.MonthlyCost
						ELSE
						(
							
							(Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = rt.CurrencyID  and  CompanyID = @v_CompanyId_ )
							* (drtr.MonthlyCost  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = @v_CurrencyID_  and  CompanyID = @v_CompanyId_ ))
						)
						END) as MonthlyCost,

						CASE WHEN ( drtr.PackageCostPerMinuteCurrency is not null)
						THEN

						CASE WHEN  @v_CurrencyID_ = drtr.PackageCostPerMinuteCurrency THEN
						drtr.PackageCostPerMinute
						ELSE
						(
						
						(Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = drtr.PackageCostPerMinuteCurrency and  CompanyID = @v_CompanyId_ )
						* (drtr.PackageCostPerMinute  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = @v_CurrencyID_   and  CompanyID = @v_CompanyId_ ))
						)
						END

						WHEN  ( @v_CurrencyID_ = rt.CurrencyID ) THEN
						drtr.PackageCostPerMinute
						ELSE
						(
							
							(Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId =  rt.CurrencyID  and  CompanyID = @v_CompanyId_ )
							* (drtr.PackageCostPerMinute  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = @v_CurrencyID_  and  CompanyID = @v_CompanyId_ ))
						)
						END as PackageCostPerMinute,

						CASE WHEN ( drtr.RecordingCostPerMinuteCurrency is not null)
						THEN

						CASE WHEN  @v_CurrencyID_ = drtr.RecordingCostPerMinuteCurrency THEN
						drtr.RecordingCostPerMinute
						ELSE
						(
						
						(Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId =  drtr.RecordingCostPerMinuteCurrency  and  CompanyID = @v_CompanyId_ )
						* (drtr.RecordingCostPerMinute  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = @v_CurrencyID_ and  CompanyID = @v_CompanyId_ ))
						)
						END

						WHEN  ( @v_CurrencyID_ = rt.CurrencyID ) THEN
						drtr.RecordingCostPerMinute
						ELSE
						(
							
							(Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = rt.CurrencyID and  CompanyID = @v_CompanyId_ )
							* (drtr.RecordingCostPerMinute  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId =  @v_CurrencyID_   and  CompanyID = @v_CompanyId_ ))
						)
						END as RecordingCostPerMinute,


					

						
						drtr.OneOffCostCurrency,
						drtr.MonthlyCostCurrency,
						drtr.PackageCostPerMinuteCurrency,
						drtr.RecordingCostPerMinuteCurrency,

						
						@p_EffectiveDate as EffectiveDate,
						date(drtr.EndDate) as EndDate,
						@v_RateApprovalStatus_ as ApprovedStatus,


							now() as  created_at ,
							now() as updated_at ,
							p_ModifiedBy as CreatedBy ,
							p_ModifiedBy as ModifiedBy,
							drtr.VendorID


						
						from tmp_SelectedVendortblRateTablePKGRate drtr 	
						inner join tblRateTable  rt on rt.RateTableId = drtr.RateTableId 
						INNER JOIN tblRate r ON drtr.Code = r.Code and r.CodeDeckId = drtr.CodeDeckId
						INNER JOIN tblPackage st ON st.CompanyID = r.CompanyID AND st.Name = drtr.Code AND  r.Code = st.Name
						LEFT join tblRateTablePKGRateAA rtd  on rtd.RateID  = r.RateID 
						and  rtd.TimezonesID = drtr.TimezonesID 
						and rtd.RateTableID = @p_RateTableId
						and rtd.EffectiveDate = @p_EffectiveDate 
						WHERE rtd.RateTablePKGRateAAID is null;
						
						update tblRateTablePKGRateAA
						SET
						OneOffCost = IF (OneOffCost = 0, NULL,OneOffCost),
						MonthlyCost = IF (MonthlyCost = 0, NULL,MonthlyCost),
						PackageCostPerMinute = IF (PackageCostPerMinute = 0, NULL,PackageCostPerMinute),
						RecordingCostPerMinute = IF (RecordingCostPerMinute = 0, NULL,RecordingCostPerMinute),
						updated_at = now(),
						ModifiedBy = p_ModifiedBy
						where RateTableId = @p_RateTableId;
	END IF;

							
							
					
   
 
		
		SET @v_AffectedRecords_ = @v_AffectedRecords_ + FOUND_ROWS();
		
		

		DROP TEMPORARY TABLE IF EXISTS tmp_EffectiveDates_;
		CREATE TEMPORARY TABLE tmp_EffectiveDates_ (
			RowID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
			EffectiveDate  Date
		);
		
	IF @v_RateApprovalProcess_ = 0 THEN	
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

	END IF;
	
	IF @v_RateApprovalProcess_ = 1 THEN	
		INSERT INTO tmp_EffectiveDates_ (EffectiveDate)
		SELECT distinct
			EffectiveDate
		FROM
		(
			select distinct EffectiveDate
			from 	tblRateTablePKGRateAA
			WHERE
				RateTableId = @p_RateTableId
			Group By EffectiveDate
			order by EffectiveDate desc
		) tmp
		,(SELECT @row_num := 0) x;

	END IF;

		SET @v_pointer_ = 1;
		SET @v_rowCount_ = ( SELECT COUNT(*) FROM tmp_EffectiveDates_ );
		
		
		
		IF @v_rowCount_ > 0 THEN

			WHILE @v_pointer_ <= @v_rowCount_
			DO
				SET @EffectiveDate = ( SELECT EffectiveDate FROM tmp_EffectiveDates_ WHERE RowID = @v_pointer_ );

				IF @v_RateApprovalProcess_ = 0 THEN	
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
				
				IF @v_RateApprovalProcess_ = 1 THEN	
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
				END IF;


				SET @v_pointer_ = @v_pointer_ + 1;

			END WHILE;

	
	
			
			
			
			
		END IF;

		commit;	
		
			
		
		IF @v_RateApprovalProcess_ = 0 THEN	
		 call prc_ArchiveOldRateTablePKGRate(@p_RateTableId, NULL,p_ModifiedBy);
		END IF;
		IF @v_RateApprovalProcess_ = 1 THEN	
		 call prc_ArchiveOldRateTablePKGRateAA(@p_RateTableId, NULL,p_ModifiedBy);
		END IF;

		INSERT INTO tmp_JobLog_ (Message) VALUES (@p_RateTableId);
		
		SELECT * FROM tmp_JobLog_;
		
		
		SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;



	END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
