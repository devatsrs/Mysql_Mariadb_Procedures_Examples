use speakintelligentRM;
DROP PROCEDURE IF EXISTS `prc_WSGenerateRateTablePackage`;
DELIMITER //
CREATE PROCEDURE `prc_WSGenerateRateTablePackage`(
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

 		DROP TEMPORARY TABLE IF EXISTS tmp_table_pkg;
		CREATE TEMPORARY TABLE tmp_table_pkg (
				RateTableID int,
				TimezonesID  int,
				-- TimezoneTitle  varchar(100),
				CodeDeckId int,
				PackageID int,
				Code varchar(100),
				VendorID int,
				-- VendorName varchar(200),
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
				-- TimezoneTitle  varchar(100),
				CodeDeckId int,
				PackageID int,
				Code varchar(100),
				VendorID int,
				-- VendorName varchar(200),
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
				-- TimezoneTitle  varchar(100),
				CodeDeckId int,
				PackageID int,
				Code varchar(100),
				VendorID int,
				-- VendorName varchar(200),
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
 


		DROP TEMPORARY TABLE IF EXISTS tmp_tblRateTableRatePackage;
		CREATE TEMPORARY TABLE tmp_tblRateTableRatePackage (
				RateTableID int,
				TimezonesID  int,
				-- TimezoneTitle  varchar(100),
				CodeDeckId int,
				PackageID int,
				Code varchar(100),
				VendorID int,
				-- VendorName varchar(200),
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

		DROP TEMPORARY TABLE IF EXISTS tmp_SelectedVendortblRateTableRatePackage;
		CREATE TEMPORARY TABLE tmp_SelectedVendortblRateTableRatePackage (
				RateTableID int,
				TimezonesID  int,
				-- TimezoneTitle  varchar(100),
				CodeDeckId int,
				PackageID int,
				Code varchar(100),
				VendorID int,
				-- VendorName varchar(200),
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

			DROP TEMPORARY TABLE IF EXISTS tmp_vendor_position;
			CREATE TEMPORARY TABLE tmp_vendor_position (
				VendorID int,
				vPosition int,
				Total DECIMAL(18, 8)

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
 
 
			IF /*@p_Calls = 0 AND */ @p_Minutes = 0 THEN

				-- AccountID is not confirmed yet by Sumera in CDR

				insert into tmp_timezone_minutes (TimezonesID,PackageID, PackageCostPerMinute,RecordingCostPerMinute)

				select PackageTimezonesID  , AccountServicePackageID, sum(PackageCostPerMinute)  ,sum(RecordingCostPerMinute)  

				from speakintelligentCDR.tblUsageDetails  d

				inner join speakintelligentCDR.tblUsageHeader h on d.UsageHeaderID = h.UsageHeaderID

				where StartDate >= @v_StartDate_ AND StartDate <= @v_EndDate_ 

                AND d.is_inbound = 1 

				AND ( @v_PackageID_ = 0 OR d.AccountServicePackageID = @v_PackageID_  )

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

					insert into tmp_timezone_minutes (AccountID, TimezonesID, PackageID, PackageCostPerMinute , RecordingCostPerMinute )
		
					Select 	AccountId, TimezonesID, PackageID, PackageCostPerMinute, RecordingCostPerMinute
					FROM (

						Select 	distinct vc.AccountId,drtr.TimezonesID,pk.PackageID, SUM(drtr.PackageCostPerMinute) as PackageCostPerMinute,SUM(drtr.RecordingCostPerMinute) as RecordingCostPerMinute

						FROM tblRateTablePKGRate  drtr
						INNER JOIN tblRateTable  rt ON rt.RateTableId = drtr.RateTableId 
						INNER JOIN tblVendorConnection vc ON vc.RateTableID = rt.RateTableId  AND vc.CompanyID = rt.CompanyId  AND vc.Active=1 AND vc.RateTypeID = @v_PackageType
						INNER JOIN tblAccount a ON vc.AccountId = a.AccountID AND rt.CompanyId = a.CompanyId
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

						GROUP BY vc.AccountId,drtr.TimezonesID,pk.PackageID

					) TMP;   

   

					insert into tmp_timezones (TimezonesID) select TimezonesID from tblTimezones;

					SET @v_rowCount_ = ( SELECT COUNT(*) FROM tmp_timezones );

					-- SET @p_PeakTimeZonePercentage	 		 = @p_TimezonePercentage;

					-- // account loop

					INSERT INTO tmp_accounts ( AccountID , PackageID )  SELECT DISTINCT AccountID , PackageID FROM tmp_timezone_minutes order by AccountID , PackageID;

					SET @v_v_pointer_ = 1;

					SET @v_v_rowCount_ = ( SELECT COUNT(*) FROM tmp_accounts );

					WHILE @v_v_pointer_ <= @v_v_rowCount_
					DO

								SET @v_AccountID = ( SELECT AccountID FROM tmp_accounts WHERE ID = @v_v_pointer_ );
								SET @v_PackageID = ( SELECT PackageID FROM tmp_accounts WHERE ID = @v_v_pointer_ );
 
 							 	IF @p_PeakTimeZonePercentage > 0 THEN

									SET @v_PeakTimeZoneMinutes				 =  ( (@p_Minutes/ 100) * @p_PeakTimeZonePercentage ) 	;

								ELSE 

									SET @v_no_of_timezones 				= 		(select count(DISTINCT TimezonesID) from tmp_timezone_minutes WHERE AccountID = @v_AccountID AND PackageID = @v_PackageID );
									SET @v_PeakTimeZoneMinutes				 =   @p_Minutes /  @v_no_of_timezones	;

								END IF;	


 								
								UPDATE  tmp_timezone_minutes SET minute_PackageCostPerMinute =  @v_PeakTimeZoneMinutes
								WHERE  TimezonesID = @v_PeakTimeZoneID AND AccountID = @v_AccountID AND PackageID = @v_PackageID  AND PackageCostPerMinute IS NOT NULL;


								UPDATE  tmp_timezone_minutes SET minute_RecordingCostPerMinute =  @v_PeakTimeZoneMinutes
								WHERE  TimezonesID = @v_PeakTimeZoneID AND AccountID = @v_AccountID AND PackageID = @v_PackageID  AND RecordingCostPerMinute IS NOT NULL;

 
					
								SET @v_RemainingTimezonesForPackageCostPerMinute = ( SELECT count(*) FROM tmp_timezone_minutes where TimezonesID != @v_PeakTimeZoneID AND AccountID = @v_AccountID AND PackageID = @v_PackageID AND PackageCostPerMinute IS NOT NULL );
								SET @v_RemainingTimezonesForRecordingCostPerMinute = ( SELECT count(*) FROM tmp_timezone_minutes where TimezonesID != @v_PeakTimeZoneID AND AccountID = @v_AccountID AND PackageID = @v_PackageID AND RecordingCostPerMinute IS NOT NULL );

								SET @v_RemainingPackageCostPerMinute = (@p_Minutes - IFNULL((select minute_PackageCostPerMinute FROM tmp_timezone_minutes WHERE  TimezonesID = @v_PeakTimeZoneID AND AccountID = @v_AccountID AND PackageID = @v_PackageID),0)  ) / @v_RemainingTimezonesForPackageCostPerMinute ;
								SET @v_RemainingRecordingCostPerMinute = (@p_Minutes - IFNULL((select minute_RecordingCostPerMinute FROM tmp_timezone_minutes WHERE  TimezonesID = @v_PeakTimeZoneID AND AccountID = @v_AccountID AND PackageID = @v_PackageID),0) ) / @v_RemainingTimezonesForRecordingCostPerMinute ;

								SET @v_pointer_ = 1;

								WHILE @v_pointer_ <= @v_rowCount_
								DO

										SET @v_TimezonesID = ( SELECT TimezonesID FROM tmp_timezones WHERE ID = @v_pointer_ AND TimezonesID != @v_PeakTimeZoneID );

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

		SET @v_days =    TIMESTAMPDIFF(DAY, (SELECT @v_StartDate_), (SELECT @v_EndDate_)) + 1 ;
		SET @v_period1 =      IF(MONTH((SELECT @v_StartDate_)) = MONTH((SELECT @v_EndDate_)), 0, (TIMESTAMPDIFF(DAY, (SELECT @v_StartDate_), LAST_DAY((SELECT @v_StartDate_)) + INTERVAL 1 DAY)) / DAY(LAST_DAY((SELECT @v_StartDate_))));
		SET @v_period2 =      TIMESTAMPDIFF(MONTH, LAST_DAY((SELECT @v_StartDate_)) + INTERVAL 1 DAY, LAST_DAY((SELECT @v_EndDate_))) ;
		SET @v_period3 =      IF(MONTH((SELECT @v_StartDate_)) = MONTH((SELECT @v_EndDate_)), (SELECT @v_days), DAY((SELECT @v_EndDate_))) / DAY(LAST_DAY((SELECT @v_EndDate_)));
		SET @v_months =     (SELECT @v_period1) + (SELECT @v_period2) + (SELECT @v_period3);

		SET @v_months = fn_Round(@v_months,1);
	
				

		insert into tmp_table_pkg (
																RateTableID,
																TimezonesID,
																-- TimezoneTitle,
																CodeDeckId,
																PackageID,
																Code,
																VendorID,
																-- VendorName,
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
																RateTableID,
																TimezonesID,
																-- TimezoneTitle,
																CodeDeckId,
																PackageID,
																Code,
																VendorID,
																-- VendorName,
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
					from (																 																

								select
								rt.RateTableID,
								drtr.TimezonesID,
								-- t.Title as TimezoneTitle,
								rt.CodeDeckId,
								pk.PackageID,
								r.Code,
								a.AccountID as VendorID,
								-- a.AccountName,
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
								END  AS RecordingCostPerMinute,
								

								@v_CurrencyID_ as OneOffCostCurrency,
								@v_CurrencyID_ as MonthlyCostCurrency,
								@v_CurrencyID_ as PackageCostPerMinuteCurrency,
								@v_CurrencyID_ as RecordingCostPerMinuteCurrency,

									
								@Total := (
									(	IFNULL(@MonthlyCost,0) * @v_months )				+
									(IFNULL(@PackageCostPerMinute,0) * IFNULL(tm.minute_PackageCostPerMinute,0)	)+
									(IFNULL(@RecordingCostPerMinute,0) * IFNULL(tm.minute_RecordingCostPerMinute,0) )
								)   
								 AS Total


				FROM tblRateTablePKGRate  drtr
				INNER JOIN tblRateTable  rt ON rt.RateTableId = drtr.RateTableId 
				INNER JOIN tblVendorConnection vc ON vc.RateTableID = rt.RateTableId  AND vc.CompanyID = rt.CompanyId  AND vc.Active=1 AND vc.RateTypeID = @v_PackageType
				INNER JOIN tblAccount a ON vc.AccountId = a.AccountID AND rt.CompanyId = a.CompanyId
				INNER JOIN tblRate r ON drtr.RateID = r.RateID AND r.CompanyID = vc.CompanyID	
				INNER JOIN tblPackage pk ON pk.CompanyID = r.CompanyID AND pk.Name = r.Code 
				INNER JOIN tblTimezones t ON t.TimezonesID =  drtr.TimezonesID
		        left join tmp_timezone_minutes tm on tm.TimezonesID = t.TimezonesID AND tm.PackageID = pk.PackageID  AND ( tm.AccountID IS NULL OR tm.AccountID = a.AccountID) -- Sumera Not confirmed yet Accountid for CDR
				
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
		 ) tmp		 ;   
				 

			    INSERT INTO  tmp_table_output_1
				(

				 	RateTableID,
					TimezonesID,
					-- TimezoneTitle,
					CodedeckID,
					EffectiveDate,
					EndDate,
					Code,
					PackageID,
					VendorID,
					-- VendorName,
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
					-- TimezoneTitle,
					CodedeckID,
					EffectiveDate,
					EndDate,
					Code,
					PackageID,
					VendorID,
					-- VendorName,
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

 
 
   				INSERT INTO tmp_table_output_2 
				(

				 	RateTableID,
					TimezonesID,
					-- TimezoneTitle,
					CodedeckID,
					EffectiveDate,
					EndDate,
					Code,
					PackageID,
					VendorID,
					-- VendorName,
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
					RateTableID,
					TimezonesID,
					-- TimezoneTitle,
					CodedeckID,
					EffectiveDate,
					EndDate,
					Code,
					PackageID,
					VendorID,
					-- VendorName,
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
							RateTableID,
							TimezonesID,
							-- TimezoneTitle,
							CodedeckID,
							EffectiveDate,
							EndDate,
							Code,
							PackageID,
							VendorID,
							-- VendorName,
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
						 		CASE WHEN (@prev_TimezonesID = TimezonesID AND @prev_PackageID = PackageID  AND @prev_Total <=  Total
                              )
                      THEN
                          @vPosition + 1
                      ELSE
                        1
                      END) as  vPosition,
					  @prev_TimezonesID  := TimezonesID,
                      @prev_PackageID := PackageID ,
                      @prev_Total := Total

					from tmp_table_output_1
					,(SELECT  @vPosition := 0 , @prev_TimezonesID := '' , @prev_PackageID := '' , @prev_Total := 0 ) t
					order by PackageID ,TimezonesID,Total
 
 
				) tmp	
				where vPosition  <= @v_RatePosition_ ;


				INSERT INTO tmp_tblRateTableRatePackage 
				(

				 	RateTableID,
					TimezonesID,
					-- TimezoneTitle,
					CodedeckID,
					EffectiveDate,
					EndDate,
					Code,
					PackageID,
					VendorID,
					-- VendorName,
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
					-- TimezoneTitle,
					CodedeckID,
					EffectiveDate,
					EndDate,
					Code,
					PackageID,
					VendorID,
					-- VendorName,
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
				(
					select 
							RateTableID,
							TimezonesID,
							-- TimezoneTitle,
							CodedeckID,
							EffectiveDate,
							EndDate,
							Code,
							PackageID,
							VendorID,
							-- VendorName,
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
							        WHEN (@prev_TimezonesID = TimezonesID AND @prev_PackageID = PackageID  AND @prev_Total =  Total )  THEN @vPosition + 1
		
		                      ELSE
                        1
                      END) as  vPosition,
					  @prev_TimezonesID  := TimezonesID,
                      @prev_PackageID := PackageID ,
                      @prev_Total := Total

					from tmp_table_output_1
					,(SELECT  @vPosition := 0 , @prev_TimezonesID := '' , @prev_PackageID := '' , @prev_Total := 0 ) t
					order by PackageID ,TimezonesID,Total desc
 
 
				) tmp	
				where vPosition  = 1 ;

			-- SET @v_SelectedVendor = ( select VendorID from tmp_vendor_position where vPosition <= @v_RatePosition_ order by vPosition , Total  limit 1 );

			insert into tmp_SelectedVendortblRateTableRatePackage
			(
					RateTableID,
					TimezonesID,
					-- TimezoneTitle,
					CodedeckID,
					EffectiveDate,
					EndDate,
					Code,
					PackageID,
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
			select
					RateTableID,
					TimezonesID,
					-- TimezoneTitle,
					CodedeckID,
					EffectiveDate,
					EndDate,
					Code,
					PackageID,
					VendorID,
 					
					IFNULL(OneOffCost,0),
					IFNULL(MonthlyCost,0),
					IFNULL(PackageCostPerMinute,0),
					IFNULL(RecordingCostPerMinute,0),

					OneOffCostCurrency,
					MonthlyCostCurrency,
					PackageCostPerMinuteCurrency,
					RecordingCostPerMinuteCurrency
  
			from tmp_tblRateTableRatePackage;

			-- where VendorID = @v_SelectedVendor ;


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



		-- ####################################
		-- margin component  starts
		-- ####################################

	 	SET @v_pointer_ = 1;
		SET @v_rowCount_ = ( SELECT COUNT(*) FROM tmp_Raterules_ );

		WHILE @v_pointer_ <= @v_rowCount_
		DO

			SET @v_rateRuleId_ = (SELECT rateruleid FROM tmp_Raterules_ rr WHERE rr.RowNo = @v_pointer_);


						update tmp_SelectedVendortblRateTableRatePackage rt
						inner join tmp_Raterules_ rr on rr.RowNo  = @v_pointer_
						and  rr.TimezonesID  = rt.TimezonesID
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

		-- ####################################
		-- margin component  over
		-- ####################################



		-- ####################################
		-- calculated rate  start
		-- ####################################


	 	SET @v_pointer_ = 1;
		SET @v_rowCount_ = ( SELECT COUNT(*) FROM tmp_RateGeneratorCalculatedRate_ );

		WHILE @v_pointer_ <= @v_rowCount_
		DO

						update tmp_SelectedVendortblRateTableRatePackage rt
						inner join tmp_RateGeneratorCalculatedRate_ rr on
						rr.RowNo  = @v_pointer_  
						AND rr.TimezonesID  = rt.TimezonesID 
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


		-- ####################################
		-- calculated rate  over
		-- ####################################


		-- ####################################
		-- merge component  starts
		-- ####################################

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

									from tmp_tblRateTableRatePackage

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
							-- TimezoneTitle,
							CodeDeckId,
							PackageID,
							Code,
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
							-- TimezoneTitle,
							CodeDeckId,
							PackageID,
							Code,
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

  
						from tmp_tblRateTableRatePackage

						where
							-- VendorID = @v_SelectedVendor
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


		-- ####################################
		-- merge component  over
		-- ####################################


 

		-- leave GenerateRateTable;



		SET @v_SelectedRateTableID = ( select RateTableID from tmp_SelectedVendortblRateTableRatePackage limit 1 );

		SET @v_AffectedRecords_ = 0;

		START TRANSACTION;

		SET @v_RATE_STATUS_AWAITING  = 0;
		SET @v_RATE_STATUS_APPROVED  = 1;
		SET @v_RATE_STATUS_REJECTED  = 2;
		SET @v_RATE_STATUS_DELETE    = 3;

		IF @p_RateTableId = -1
		THEN

			-- SET @v_codedeckid_ = ( select CodeDeckId from tmp_SelectedVendortblRateTableRatePackage limit 1 );

			INSERT INTO tblRateTable (Type, CompanyId, RateTableName, RateGeneratorID, TrunkID, CodeDeckId,CurrencyID,Status, RoundChargedAmount,MinimumCallCharge,AppliedTo,Reseller,created_at,updated_at, CreatedBy,ModifiedBy)
			select  @v_PackageType as Type, @v_CompanyId_, @p_rateTableName , @p_RateGeneratorId, 0 as TrunkID,   CodeDeckId , @v_CurrencyID_ as CurrencyID, Status, RoundChargedAmount,MinimumCallCharge, @p_AppliedTo as AppliedTo, @p_Reseller as Reseller , now() ,now() ,@p_ModifiedBy,@p_ModifiedBy 
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


		END IF; -- @p_RateTableId = -1 over


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

				OneOffCost = IF(OneOffCost = 0 , NULL, fn_Round(OneOffCost,IFNULL(@v_RoundChargedAmount,@v_CompanyRoundChargesAmount))),
				MonthlyCost = IF(MonthlyCost = 0 , NULL, fn_Round(MonthlyCost,IFNULL(@v_RoundChargedAmount,@v_CompanyRoundChargesAmount))),
				PackageCostPerMinute = IF(PackageCostPerMinute = 0 , NULL, fn_Round(PackageCostPerMinute,IFNULL(@v_RoundChargedAmount,@v_CompanyRoundChargesAmount))),
				RecordingCostPerMinute = IF(RecordingCostPerMinute = 0 , NULL, fn_Round(RecordingCostPerMinute,IFNULL(@v_RoundChargedAmount,@v_CompanyRoundChargesAmount))),
				
				updated_at = now(),
				ModifiedBy = @p_ModifiedBy

				where
				RateTableID = @p_RateTableId;



			ELSE


				update tblRateTablePKGRate
				SET

				OneOffCost = IF(OneOffCost = 0 , NULL, fn_Round(OneOffCost,IFNULL(@v_RoundChargedAmount,@v_CompanyRoundChargesAmount))),
				MonthlyCost = IF(MonthlyCost = 0 , NULL, fn_Round(MonthlyCost,IFNULL(@v_RoundChargedAmount,@v_CompanyRoundChargesAmount))),
				PackageCostPerMinute = IF(PackageCostPerMinute = 0 , NULL, fn_Round(PackageCostPerMinute,IFNULL(@v_RoundChargedAmount,@v_CompanyRoundChargesAmount))),
				RecordingCostPerMinute = IF(RecordingCostPerMinute = 0 , NULL, fn_Round(RecordingCostPerMinute,IFNULL(@v_RoundChargedAmount,@v_CompanyRoundChargesAmount))),
				
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