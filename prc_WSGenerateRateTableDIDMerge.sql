use speakintelligentRM;

DROP PROCEDURE IF EXISTS `prc_WSGenerateRateTableDIDMerge`;
DELIMITER //
CREATE PROCEDURE `prc_WSGenerateRateTableDIDMerge` (
)
BEGIN

			SET global auto_increment_increment = 1;
			SET global auto_increment_offset = 1;

			DROP TEMPORARY TABLE IF EXISTS tmp_MergeComponents;
			CREATE TEMPORARY TABLE tmp_MergeComponents (
				ID int auto_increment,
				Component TEXT  ,
				Origination TEXT  ,
				ToOrigination TEXT  ,
				TimezonesID VARCHAR(50),	-- changed
				ToTimezonesID INT(11),
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

			-- load merge data 
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
 
        /*
		Destination= Outpayment: 
			All outpayment components should be added
			All other cost components should be deducted
			Destination = Other cost component:
			All outpayment components should be deducted
			All other cost components should be added
        */
		-- TEST
		-- sheet 1 Sales with all time of day merge into Default (max)
		-- truncate table `tmp_MergeComponents`;
		
		/*INSERT INTO `tmp_MergeComponents` 
			   (`Component`, `Origination`, `ToOrigination`, `TimezonesID`, `ToTimezonesID`, `Action`, `MergeTo`, `FromCountryID`, `ToCountryID`      , `FromAccessType`, 		`ToAccessType`, 		`FromPrefix`  , `ToPrefix`	, `FromCity`, `FromTariff`	, `ToCity`,	   `ToTariff`) 
		VALUES (''			, ''			, ''		    , '0'  			, 1			    , 'max', 	 ''		, 475				, 475		  , 'Premium Rate Number'  , 'Premium Rate Number'	 ,   '900'			, '900'		,     ''	, '0.1 per call'   , ''		, '0.1 per call');
		*/
		
		
		-- sheet 1 Sales with partial (example with only Weekend and Off peak merged into Offpeak) time of day merge (max)
		-- 16 Weekend 10 Off Peak 
		/*INSERT INTO `tmp_MergeComponents` 
			   (`Component`, `Origination`, `ToOrigination`, `TimezonesID`, `ToTimezonesID`, `Action`, `MergeTo`, `FromCountryID`, `ToCountryID`      , `FromAccessType`, 		`ToAccessType`, 		`FromPrefix`  , `ToPrefix`	, `FromCity`, `FromTariff`	, `ToCity`,	   `ToTariff`) 
		VALUES (''			, ''			, ''		 	 , '16,10'			, 10		 , 'max', 	 ''			, 475			 , 475		  	 , 'Premium Rate Number'  , 'Premium Rate Number',   '900'			, '900'		,     ''	, '0.1 per call'   , ''		, '0.1 per call');
		*/

		-- sheet 2
		/*INSERT INTO `tmp_MergeComponents` 
			   (`Component`, `Origination`, `ToOrigination`, `TimezonesID`, `ToTimezonesID`, `Action`, `MergeTo`, `FromCountryID`, `ToCountryID`      , `FromAccessType`, 		`ToAccessType`, 		`FromPrefix` 		 , `ToPrefix`			, `FromCity`, `FromTariff`		, `ToCity`,	   `ToTariff`) 
		VALUES (''			, 'FIX'			, 'FIX'		  , '0'				, 0		 	, 'max', 	 ''		, 334				, 334		  , 'Premium Rate Number'  , 'Premium Rate Number',   '08998408'			, '08998408'		,     ''	, '1.22 per minute'   , ''		, '1.22 per minute'),
			   (''			, 'MOB'			, 'MOB'		  , '0'				, 0		 	, 'max', 	 ''		, 334				, 334		  , 'Premium Rate Number'  , 'Premium Rate Number',   '08998408'			, '08998408'		,     ''	, '1.22 per minute'   , ''		, '1.22 per minute');
		

		INSERT INTO `tmp_MergeComponents` 
			   (`Component`, `Origination`, 					`ToOrigination`, `TimezonesID`, `ToTimezonesID`, `Action`, `MergeTo`, `FromCountryID`, `ToCountryID`      , `FromAccessType`, 		`ToAccessType`, 		`FromPrefix` 		 , `ToPrefix`		, `FromCity`, `FromTariff`	 	, `ToCity`,	   `ToTariff`) 
		VALUES (''			, 'FIX'								, 'FIX'		  ,   '0'				, 0		 	 , 'max', 	 ''		, 334				, 334		  , 'Premium Rate Number'  , 'Premium Rate Number',   '08998408'			, '08998408'		,     ''	, '1.22 per minute'   , ''		, '1.22 per minute'),
			   (''			, 'MOB-H3G,MOB-Vodafone,MOB-Wind'	, 'MOB-Other'	 , '0'				, 0		 	 , 'max', 	 ''		, 334				, 334		  , 'Premium Rate Number'  , 'Premium Rate Number',   '08998408'			, '08998408'		,     ''	, '1.22 per minute'   , ''		, '1.22 per minute');
		*/
		
		-- sheet 3
		/*INSERT INTO `tmp_MergeComponents` 
			   (`Component`, 										`Origination`, `ToOrigination`, `TimezonesID`, `ToTimezonesID`, `Action`, `MergeTo`, 			`FromCountryID`, `ToCountryID`      , `FromAccessType`, 		`ToAccessType`, 		`FromPrefix` 		 , `ToPrefix`			, `FromCity`, 		`FromTariff`		, `ToCity`,	   `ToTariff`) 
		VALUES (''	,												 ''				, ''		  , '0'  			, 1			    , 'max',   ''	, 				475			, 475		  		, 'Premium Rate Number'  , 'Premium Rate Number',   '0900'			, '0900'					,     ''			, '0.8 per minute'   , ''		, '0.8 per minute'),
			   ('CostPerMinute,OutpaymentPerMinute,CollectionCostAmount', ''			, ''		  , '0'  			, 1			, 'max',  'OutpaymentPerMinute'	, 	475			, 475		  		, 'Premium Rate Number'  , 'Premium Rate Number',   '0900'			, '0900'					,     ''			, '0.8 per minute'   , ''		, '0.8 per minute');
		*/



	 	SET @v_pointer_ = 1;
		SET @v_rowCount_ = ( SELECT COUNT(*) FROM tmp_MergeComponents );

		IF @v_rowCount_ > 0 THEN 

			-- outpayment
			ALTER TABLE tmp_SelectedVendortblRateTableDIDRate
			ADD COLUMN Outpayment DECIMAL(18, 8) AFTER RegistrationCostPerNumber;

			ALTER TABLE tmp_SelectedVendortblRateTableDIDRate_dup
			ADD COLUMN Outpayment DECIMAL(18, 8) AFTER RegistrationCostPerNumber;


			ALTER TABLE tmp_SelectedVendortblRateTableDIDRate
			ADD COLUMN OriginationCode2 VARCHAR(50) AFTER OriginationCode;

			ALTER TABLE tmp_SelectedVendortblRateTableDIDRate_dup
			ADD COLUMN OriginationCode2 VARCHAR(50) AFTER OriginationCode;
					
			-- update OriginationCode2 for condition
			UPDATE tmp_SelectedVendortblRateTableDIDRate
			SET OriginationCode2 = ( CASE WHEN OriginationCode LIKE '%MOB%' THEN 
									'MOB'
										WHEN OriginationCode LIKE '%FIX%' THEN
									'FIX'
									ELSE	
									OriginationCode
									END );



			update tmp_SelectedVendortblRateTableDIDRate rtr
			INNER JOIN tmp_table_without_origination two
			on
				   rtr.TimezonesID = two.TimezonesID
			AND    rtr.OriginationCode = two.OriginationCode
			AND    rtr.CountryID = two.CountryID
			AND    rtr.AccessType = two.AccessType
			AND    rtr.Code = two.Code
			AND    rtr.City = two.City
			AND    rtr.Tariff = two.Tariff
			SET rtr.Outpayment = two.Outpayment;

			-- DROP TEMPORARY TABLE IF EXISTS tmp_SelectedVendortblRateTableDIDRate_ori;
			-- CREATE TEMPORARY TABLE tmp_SelectedVendortblRateTableDIDRate_ori LIKE tmp_SelectedVendortblRateTableDIDRate;

			-- Merging rules have to be applied per product  (  from client given by sumera)
			-- A product is defined by Country, Type, Prefix, Tariff and City . At the moment merging rules are not applied per prefix but all prefixes are merged together

			WHILE @v_pointer_ <= @v_rowCount_
			DO

					-- load current row setting
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
							@p_FromOrigination,
							@v_ToOrigination,
							@p_FromTimezone,
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

					-- ------------------------------------------------------------------------------------------------
					SET @v_ResultField = '';
					
					
					-- when max action
					IF (fn_IsEmpty(@v_Component) AND @v_Action = 'max' ) THEN
					
							SET @v_ResultField = 'MAX(OneOffCost) as OneOffCost ,MAX(MonthlyCost) as MonthlyCost ,MAX(CostPerCall) as CostPerCall ,MAX(CostPerMinute) as CostPerMinute ,MAX(SurchargePerCall) as SurchargePerCall ,MAX(SurchargePerMinute) as SurchargePerMinute ,MIN(NULLIF(OutpaymentPerCall, 0))  as OutpaymentPerCall ,MIN(NULLIF(OutpaymentPerMinute, 0)) as OutpaymentPerMinute ,MAX(Surcharges) as Surcharges ,MAX(Chargeback) as Chargeback ,MAX(CollectionCostAmount) as CollectionCostAmount ,MAX(CollectionCostPercentage) as CollectionCostPercentage ,MAX(RegistrationCostPerNumber) as RegistrationCostPerNumber ';
					
					-- when action = sum
					ELSEIF (fn_IsEmpty(@v_Component) AND @v_Action = 'sum' ) THEN
					
							SET @v_ResultField = 'SUM(OneOffCost) as OneOffCost ,SUM(MonthlyCost) as MonthlyCost ,SUM(CostPerCall) as CostPerCall ,SUM(CostPerMinute) as CostPerMinute ,SUM(SurchargePerCall) as SurchargePerCall ,SUM(SurchargePerMinute) as SurchargePerMinute ,SUM(OutpaymentPerCall) as OutpaymentPerCall ,SUM(OutpaymentPerMinute) as OutpaymentPerMinute ,SUM(Surcharges) as Surcharges ,SUM(Chargeback) as Chargeback ,SUM(CollectionCostAmount) as CollectionCostAmount ,SUM(CollectionCostPercentage) as CollectionCostPercentage ,SUM(RegistrationCostPerNumber) as RegistrationCostPerNumber ';
					ELSE 

						-- when selected components 

						SET @v_ResultField = 'OneOffCost,MonthlyCost,CostPerCall,CostPerMinute,SurchargePerCall,SurchargePerMinute,OutpaymentPerCall,OutpaymentPerMinute,Surcharges,Chargeback,CollectionCostAmount,CollectionCostPercentage,RegistrationCostPerNumber';
						SET @v_ResultField_2 = '';

						IF ( @v_Action = 'max' ) THEN

								SET @v_no_Components =  LENGTH(@v_Component) - LENGTH(REPLACE(@v_Component, ',', '')) + 1 ;

								IF @v_no_Components = 1 THEN 
									
									SET @v_ResultField_2 = CONCAT( 'max(' , @v_Component , ') as ' , @v_MergeTo );

								ELSE
								 
								 	SET @v_ResultField_2 = CONCAT( 'GREATEST(' , @v_Component , ') as ' , @v_MergeTo );

								END IF;

						ELSE 
	
								-- ( ( (@OutPayment * 1.21) ) * IFNULL(drtr.CollectionCostPercentage,0)/100 ) +

								

							set @v_Component_ = REPLACE( @v_Component , 'CollectionCostPercentage' , '( ( (OutPayment * 1.21) ) * CollectionCostPercentage/100 ) ' );

							-- when v_MergeTo= outpayment minus component
							IF @v_MergeTo like 'Outpayment%' THEN

								set @v_ResultField_2 = REPLACE(@v_Component_,',',' - ');
								set @v_ResultField_2 = REPLACE(@v_ResultField_2,'- Outpayment','+ Outpayment');
								
							ELSE 
								-- v_MergeTo ! = Outpayment add component plus 
								set @v_ResultField_2 = REPLACE(@v_Component_,',',' + ');
								set @v_ResultField_2 = REPLACE(@v_ResultField_2,'+ Outpayment','- Outpayment');


							END IF ;

							set @v_ResultField_2 = CONCAT('(' , @v_ResultField_2 , ') as ' , @v_MergeTo );

						END IF;


						set @v_ResultField =  REPLACE(@v_ResultField, @v_MergeTo , @v_ResultField_2 );


					END IF;


					SET	@v_RateTypeID = 2;	-- //1 - Termination,  2 - DID,   3 - Package


					IF !fn_IsEmpty(@v_ToOrigination) THEN 

						select count(*) INTO @v_IsOriginationExists from tblRate r inner join tblCodeDeck cd on cd.Type = @v_RateTypeID and r.CodeDeckId = cd.CodeDeckId  Where r.Code = @v_ToOrigination;
						
						-- when new code in v_ToOrigination
						IF @v_IsOriginationExists = 0 THEN 

							select CodeDeckId INTO @v_CodeDeckId from tmp_SelectedVendortblRateTableDIDRate limit 1;

							INSERT INTO `tblRate` (`CompanyID`, `CodeDeckId`, `Code`, `Description`) VALUES (@v_CompanyId_, @v_CodeDeckId, @v_ToOrigination, @v_ToOrigination);

						END IF;
					END IF;

					TRUNCATE TABLE tmp_SelectedVendortblRateTableDIDRate_dup;
					-- load final data to insert 
					SET @stm1 = CONCAT('
					INSERT INTO tmp_SelectedVendortblRateTableDIDRate_dup(
											TimezonesID,
											CountryID,
											AccessType,
											City,
											Tariff,
											Code,
											OriginationCode,
											OriginationCode2,
											RateTableID,
											CountryPrefix,
											TimezoneTitle,
											CodeDeckId,
											VendorConnectionID ,
											VendorID ,
											EndDate ,

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

											OneOffCostCurrency ,
											MonthlyCostCurrency ,
											CostPerCallCurrency ,
											CostPerMinuteCurrency ,
											SurchargePerCallCurrency ,
											SurchargePerMinuteCurrency ,
											OutpaymentPerCallCurrency ,
											OutpaymentPerMinuteCurrency ,
											SurchargesCurrency ,
											ChargebackCurrency ,
											CollectionCostAmountCurrency ,
											RegistrationCostPerNumberCurrency 

					)
					select 
									DISTINCT

									IF(fn_IsEmpty(@v_ToTimezonesID),TimezonesID, @v_ToTimezonesID) as TimezonesID,
									IF(fn_IsEmpty(@v_ToCountryID), CountryID,@v_ToCountryID) as CountryID,
									IF(fn_IsEmpty(@v_ToAccessType), AccessType,@v_ToAccessType) as AccessType,
									IF(fn_IsEmpty(@v_ToCity),City,@v_ToCity) as City,
									IF(fn_IsEmpty(@v_ToTariff),Tariff,@v_ToTariff) as Tariff,
									IF(fn_IsEmpty(@v_ToPrefix), Code, concat(CountryPrefix ,@v_ToPrefix)) as Code,
									IF(fn_IsEmpty(@v_ToOrigination),OriginationCode,@v_ToOrigination) as OriginationCode,
									OriginationCode2,
									RateTableID,
									CountryPrefix,
									TimezoneTitle,
									CodeDeckId,
									VendorConnectionID,
									VendorID,
									EndDate, 
									' , @v_ResultField , ' ,
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
				
					from tmp_SelectedVendortblRateTableDIDRate
					where 
							(  fn_IsEmpty(@p_FromTimezone) 		 OR FIND_IN_SET(TimezonesID,@p_FromTimezone) != 0 )
						AND (  fn_IsEmpty(@p_FromOrigination)  	 OR FIND_IN_SET(OriginationCode,@p_FromOrigination) != 0 OR FIND_IN_SET(OriginationCode2,@p_FromOrigination) != 0)
						AND (  fn_IsEmpty(@v_FromCountryID)  OR CountryID = 	@v_FromCountryID )
						AND (  fn_IsEmpty(@v_FromAccessType) OR AccessType = 	@v_FromAccessType )
						AND (  fn_IsEmpty(@v_FromPrefix)  	 OR Code = 	concat(CountryPrefix ,@v_FromPrefix) )
						AND (  fn_IsEmpty(@v_FromCity)  	 OR City = 	@v_FromCity )
						AND (  fn_IsEmpty(@v_FromTariff)  	 OR Tariff = 	@v_FromTariff )

						GROUP BY 
						tmp_SelectedVendortblRateTableDIDRate.TimezonesID,
						tmp_SelectedVendortblRateTableDIDRate.CountryID,
						tmp_SelectedVendortblRateTableDIDRate.AccessType,
						tmp_SelectedVendortblRateTableDIDRate.City,
						tmp_SelectedVendortblRateTableDIDRate.Tariff,
						tmp_SelectedVendortblRateTableDIDRate.Code
					');

					PREPARE stm1 FROM @stm1;
					EXECUTE stm1;
					DEALLOCATE PREPARE stm1;

					IF (SELECT COUNT(*) FROM tmp_SelectedVendortblRateTableDIDRate_dup ) > 0 THEN 

						-- delete source  records  
						DELETE 
						from tmp_SelectedVendortblRateTableDIDRate
						where 
								(  fn_IsEmpty(@p_FromTimezone) 		OR  FIND_IN_SET(TimezonesID,@p_FromTimezone) != 0 )
							AND (  fn_IsEmpty(@p_FromOrigination)  	 OR FIND_IN_SET(OriginationCode,@p_FromOrigination) != 0 OR FIND_IN_SET(OriginationCode2,@p_FromOrigination) != 0)
							AND (  fn_IsEmpty(@v_FromCountryID) OR CountryID = 	@v_FromCountryID )
							AND (  fn_IsEmpty(@v_FromAccessType) OR AccessType = 	@v_FromAccessType )
							AND (  fn_IsEmpty(@v_FromPrefix)  OR Code = 	concat(CountryPrefix ,@v_FromPrefix) )
							AND (  fn_IsEmpty(@v_FromCity)  OR City = 	@v_FromCity )
							AND (  fn_IsEmpty(@v_FromTariff)  OR Tariff = 	@v_FromTariff );
						

						-- delete destination  records   ( as it will be created again. )
						DELETE 
						from tmp_SelectedVendortblRateTableDIDRate
						where 
								(  fn_IsEmpty(@v_ToTimezonesID) OR  TimezonesID = @v_ToTimezonesID)
							AND (  fn_IsEmpty(@v_ToOrigination)  	 OR FIND_IN_SET(OriginationCode,@v_ToOrigination) != 0 OR FIND_IN_SET(OriginationCode2,@v_ToOrigination) != 0)
							AND (  fn_IsEmpty(@v_ToCountryID)  OR CountryID = 	@v_ToCountryID )
							AND (  fn_IsEmpty(@v_ToAccessType)   OR AccessType = 	@v_ToAccessType )
							AND (  fn_IsEmpty(@v_ToPrefix)  OR Code = 	concat(CountryPrefix ,@v_ToPrefix) )
							AND (  fn_IsEmpty(@v_ToCity)  OR City = 	@v_ToCity )
							AND (  fn_IsEmpty(@v_ToTariff)  OR Tariff = 	@v_ToTariff );
		

						-- insert final data to load
						insert into tmp_SelectedVendortblRateTableDIDRate				
						select DISTINCT * from tmp_SelectedVendortblRateTableDIDRate_dup;

 
						-- CLEAR/EMPTY COMPONENT WHICH IS SELECTED IN RULE (SHEET-3).
						IF ( !fn_IsEmpty(@v_Component) ) THEN

							UPDATE tmp_SelectedVendortblRateTableDIDRate

							SET	OneOffCost = CASE WHEN FIND_IN_SET('OneOffCost',@v_Component) != 0 AND 'OneOffCost'!= @v_MergeTo  THEN
													0
											ELSE
												OneOffCost
											END,
								MonthlyCost = CASE WHEN FIND_IN_SET('MonthlyCost',@v_Component) != 0  AND 'MonthlyCost'!= @v_MergeTo  THEN
													0
											ELSE
												MonthlyCost
											END,
								CostPerCall = CASE WHEN FIND_IN_SET('CostPerCall',@v_Component) != 0  AND 'CostPerCall'!= @v_MergeTo  THEN
													0
											ELSE
												CostPerCall
											END,
								CostPerMinute = CASE WHEN FIND_IN_SET('CostPerMinute',@v_Component) != 0  AND 'CostPerMinute'!= @v_MergeTo  THEN
													0
											ELSE
												CostPerMinute
											END,
								SurchargePerCall = CASE WHEN FIND_IN_SET('SurchargePerCall',@v_Component) != 0  AND 'SurchargePerCall'!= @v_MergeTo  THEN
													0
											ELSE
												SurchargePerCall
											END,
								SurchargePerMinute = CASE WHEN FIND_IN_SET('SurchargePerMinute',@v_Component) != 0  AND 'SurchargePerMinute'!= @v_MergeTo  THEN
													0
											ELSE
												SurchargePerMinute
											END,
								OutpaymentPerCall = CASE WHEN FIND_IN_SET('OutpaymentPerCall',@v_Component) != 0  AND 'OutpaymentPerCall'!= @v_MergeTo  THEN
													0
											ELSE
												OutpaymentPerCall
											END,
								OutpaymentPerMinute = CASE WHEN FIND_IN_SET('OutpaymentPerMinute',@v_Component) != 0  AND 'OutpaymentPerMinute'!= @v_MergeTo  THEN
													0
											ELSE
												OutpaymentPerMinute
											END,
								Surcharges = CASE WHEN FIND_IN_SET('Surcharges',@v_Component) != 0  AND 'Surcharges'!= @v_MergeTo  THEN
													0
											ELSE
												Surcharges
											END,
								Chargeback = CASE WHEN FIND_IN_SET('Chargeback',@v_Component) != 0  AND 'Chargeback'!= @v_MergeTo  THEN
													0
											ELSE
												Chargeback
											END,
								CollectionCostAmount = CASE WHEN FIND_IN_SET('CollectionCostAmount',@v_Component) != 0  AND 'CollectionCostAmount'!= @v_MergeTo  THEN
													0
											ELSE
												CollectionCostAmount
											END,
								CollectionCostPercentage = CASE WHEN FIND_IN_SET('CollectionCostPercentage',@v_Component) != 0  AND 'CollectionCostPercentage'!= @v_MergeTo  THEN
													0
											ELSE
												CollectionCostPercentage
											END,
								RegistrationCostPerNumber = CASE WHEN FIND_IN_SET('RegistrationCostPerNumber',@v_Component) != 0  AND 'OneOffCost'!= @v_MergeTo  THEN
													0
											ELSE
												RegistrationCostPerNumber
											END
									
								where 
									(  fn_IsEmpty(@p_FromTimezone) 		OR  FIND_IN_SET(TimezonesID,@p_FromTimezone) != 0 )
								AND (  fn_IsEmpty(@p_FromOrigination)  	 OR FIND_IN_SET(OriginationCode,@p_FromOrigination) != 0 OR FIND_IN_SET(OriginationCode2,@p_FromOrigination) != 0)
								AND (  fn_IsEmpty(@v_FromCountryID) OR CountryID = 	@v_FromCountryID )
								AND (  fn_IsEmpty(@v_FromAccessType) OR AccessType = 	@v_FromAccessType )
								AND (  fn_IsEmpty(@v_FromPrefix)  OR Code = 	concat(CountryPrefix ,@v_FromPrefix) )
								AND (  fn_IsEmpty(@v_FromCity)  OR City = 	@v_FromCity )
								AND (  fn_IsEmpty(@v_FromTariff)  OR Tariff = 	@v_FromTariff );


						END IF;

					END IF;					


	
				SET @v_pointer_ = @v_pointer_ + 1;

			END WHILE;


			ALTER TABLE tmp_SelectedVendortblRateTableDIDRate DROP COLUMN OriginationCode2;
			ALTER TABLE tmp_SelectedVendortblRateTableDIDRate_dup DROP COLUMN OriginationCode2;


			
		END IF ;


	END//
DELIMITER ;