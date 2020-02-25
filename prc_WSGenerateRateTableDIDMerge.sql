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


			/* old DROP TEMPORARY TABLE IF EXISTS tmp_MergeComponents;
			CREATE TEMPORARY TABLE tmp_MergeComponents (
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
			);*/

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



			/*DROP TEMPORARY TABLE IF EXISTS tmp_Components;
			CREATE TEMPORARY TABLE tmp_Components (
				ID int auto_increment,
				Component VARCHAR(250)  ,
				primary key (ID)
			);

            INSERT INTO tmp_Components(Component) VALUES
										('OneOffCost'),
										('MonthlyCost'),
										('CostPerCall'),
										('CostPerMinute'),
										('SurchargePerCall'),
										('SurchargePerMinute'),
										('OutpaymentPerCall'),
										('OutpaymentPerMinute'),
										('Surcharges'),
										('Chargeback'),
										('CollectionCostAmount'),
										('CollectionCostPercentage'),
										('RegistrationCostPerNumber');*/




        /*
        SHEET 1 

        INSERT INTO TMP_TABLE
        select max(OneOffCost) as OneOffCost , max(MonthlyCost) as MonthlyCost ...  from tmp_SelectedVendortblRateTableDIDRate
        where Timezones = all

        DELETE   from tmp_SelectedVendortblRateTableDIDRate
        where Timezones = all

        INSERT INTO tmp_SelectedVendortblRateTableDIDRate
        select default as Timezones, max(OneOffCost) as OneOffCost , max(MonthlyCost) as MonthlyCost ...  from TMP_TABLE
        
		Destination= Outpayment:
			All outpayment components should be added
			All other cost components should be deducted
			Destination = Other cost component:
			All outpayment components should be deducted
			All other cost components should be added


        */
		-- TEST
		-- sheet 1 Sales with all time of day merge into Default (max)
		truncate table `tmp_MergeComponents`;
		
		/*INSERT INTO `tmp_MergeComponents` 
			   (`Component`, `Origination`, `ToOrigination`, `TimezonesID`, `ToTimezonesID`, `Action`, `MergeTo`, `FromCountryID`, `ToCountryID`      , `FromAccessType`, 		`ToAccessType`, 		`FromPrefix`  , `ToPrefix`	, `FromCity`, `FromTariff`	, `ToCity`,	   `ToTariff`) 
		VALUES ('all'			, ''			, ''		  , '0'  			, 1			 , 'max', 	 'all'		, 475				, 475		  , 'Premium Rate Number'  , 'Premium Rate Number',   '900'			, '900'		,     ''	, '0.1 per call'   , ''		, '0.1 per call');
		
		*/
		
		-- sheet 1 Sales with partial (example with only Weekend and Off peak merged into Offpeak) time of day merge (max)
		-- 16 Weekend 10 Off Peak 
		/*INSERT INTO `tmp_MergeComponents` 
			   (`Component`, `Origination`, `ToOrigination`, `TimezonesID`, `ToTimezonesID`, `Action`, `MergeTo`, `FromCountryID`, `ToCountryID`      , `FromAccessType`, 		`ToAccessType`, 		`FromPrefix`  , `ToPrefix`	, `FromCity`, `FromTariff`	, `ToCity`,	   `ToTariff`) 
		VALUES ('all'			, ''			, ''		  , '16,10'			, 10		 , 'max', 	 'all'		, 475				, 475		  , 'Premium Rate Number'  , 'Premium Rate Number',   '900'			, '900'		,     ''	, '0.1 per call'   , ''		, '0.1 per call');
		*/

		-- sheet 2
		/*INSERT INTO `tmp_MergeComponents` 
			   (`Component`, `Origination`, `ToOrigination`, `TimezonesID`, `ToTimezonesID`, `Action`, `MergeTo`, `FromCountryID`, `ToCountryID`      , `FromAccessType`, 		`ToAccessType`, 		`FromPrefix` 		 , `ToPrefix`			, `FromCity`, `FromTariff`		, `ToCity`,	   `ToTariff`) 
		VALUES ('all'			, 'FIX'			, 'FIX'		  , '0'				, 0		 	, 'max', 	 'all'		, 334				, 334		  , 'Premium Rate Number'  , 'Premium Rate Number',   '08998408'			, '08998408'		,     ''	, '1.22 per minute'   , ''		, '1.22 per minute'),
			   ('all'			, 'MOB'			, 'MOB'		  , '0'				, 0		 	, 'max', 	 'all'		, 334				, 334		  , 'Premium Rate Number'  , 'Premium Rate Number',   '08998408'			, '08998408'		,     ''	, '1.22 per minute'   , ''		, '1.22 per minute');
		*/

		/*INSERT INTO `tmp_MergeComponents` 
			   (`Component`, `Origination`, `ToOrigination`, `TimezonesID`, `ToTimezonesID`, `Action`, `MergeTo`, `FromCountryID`, `ToCountryID`      , `FromAccessType`, 		`ToAccessType`, 		`FromPrefix` 		 , `ToPrefix`			, `FromCity`, `FromTariff`		, `ToCity`,	   `ToTariff`) 
		VALUES ('all'			, 'FIX'			, 'FIX'		  , '0'				, 0		 	, 'max', 	 'all'		, 334				, 334		  , 'Premium Rate Number'  , 'Premium Rate Number',   '08998408'			, '08998408'		,     ''	, '1.22 per minute'   , ''		, '1.22 per minute'),
			   ('all'			, 'MOB-H3G,MOB-Vodafone,MOB-Wind'			, 'MOB-Other'		  , '0'				, 0		 	, 'max', 	 'all'		, 334				, 334		  , 'Premium Rate Number'  , 'Premium Rate Number',   '08998408'			, '08998408'		,     ''	, '1.22 per minute'   , ''		, '1.22 per minute');
		*/
		
		-- sheet 3
		INSERT INTO `tmp_MergeComponents` 
			   (`Component`, 										`Origination`, `ToOrigination`, `TimezonesID`, `ToTimezonesID`, `Action`, `MergeTo`, 			`FromCountryID`, `ToCountryID`      , `FromAccessType`, 		`ToAccessType`, 		`FromPrefix` 		 , `ToPrefix`			, `FromCity`, 		`FromTariff`		, `ToCity`,	   `ToTariff`) 
		VALUES ('all'	,												 ''			, ''		  , '0'  			, 1			    , 'max',   'all'	, 				475			, 475		  		, 'Premium Rate Number'  , 'Premium Rate Number',   '0900'			, '0900'					,     ''			, '0.8 per minute'   , ''		, '0.8 per minute'),
			   ('OutpaymentPerMinute,CostPerMinute,CollectionCostAmount', ''			, ''		  , '0'  			, 1			, 'max',  'OutpaymentPerMinute'	, 	475			, 475		  		, 'Premium Rate Number'  , 'Premium Rate Number',   '0900'			, '0900'					,     ''			, '0.8 per minute'   , ''		, '0.8 per minute');



		ALTER TABLE tmp_SelectedVendortblRateTableDIDRate
		ADD COLUMN OriginationCode2 VARCHAR(50) AFTER OriginationCode;

		ALTER TABLE tmp_SelectedVendortblRateTableDIDRate_dup
		ADD COLUMN OriginationCode2 VARCHAR(50) AFTER OriginationCode;
				

		UPDATE tmp_SelectedVendortblRateTableDIDRate
		SET OriginationCode2 = ( CASE WHEN OriginationCode LIKE '%MOB%' THEN 
								'MOB'
									WHEN OriginationCode LIKE '%FIX%' THEN
								'FIX'
								ELSE	
								OriginationCode
								END );



		-- insert into tmp_SelectedVendortblRateTableDIDRate_dup		select * from tmp_SelectedVendortblRateTableDIDRate;

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
						@p_Origination,
						@v_ToOrigination,
						@p_Timezone,
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

    			IF (@v_Component = 'ALL' AND @v_Action = 'max' ) THEN
                
                        SET @v_ResultField = 'MAX(OneOffCost) as OneOffCost ,MAX(MonthlyCost) as MonthlyCost ,MAX(CostPerCall) as CostPerCall ,MAX(CostPerMinute) as CostPerMinute ,MAX(SurchargePerCall) as SurchargePerCall ,MAX(SurchargePerMinute) as SurchargePerMinute ,MIN(NULLIF(OutpaymentPerCall, 0))  as OutpaymentPerCall ,MIN(NULLIF(OutpaymentPerMinute, 0)) as OutpaymentPerMinute ,MAX(Surcharges) as Surcharges ,MAX(Chargeback) as Chargeback ,MAX(CollectionCostAmount) as CollectionCostAmount ,MAX(CollectionCostPercentage) as CollectionCostPercentage ,MAX(RegistrationCostPerNumber) as RegistrationCostPerNumber ';
                
                ELSEIF (@v_Component = 'ALL' AND @v_Action = 'sum' ) THEN
                
                        SET @v_ResultField = 'SUM(OneOffCost) as OneOffCost ,SUM(MonthlyCost) as MonthlyCost ,SUM(CostPerCall) as CostPerCall ,SUM(CostPerMinute) as CostPerMinute ,SUM(SurchargePerCall) as SurchargePerCall ,SUM(SurchargePerMinute) as SurchargePerMinute ,SUM(OutpaymentPerCall) as OutpaymentPerCall ,SUM(OutpaymentPerMinute) as OutpaymentPerMinute ,SUM(Surcharges) as Surcharges ,SUM(Chargeback) as Chargeback ,SUM(CollectionCostAmount) as CollectionCostAmount ,SUM(CollectionCostPercentage) as CollectionCostPercentage ,SUM(RegistrationCostPerNumber) as RegistrationCostPerNumber ';
				ELSE 


					SET @v_ResultField = 'OneOffCost,MonthlyCost,CostPerCall,CostPerMinute,SurchargePerCall,SurchargePerMinute,OutpaymentPerCall,OutpaymentPerMinute,Surcharges,Chargeback,CollectionCostAmount,CollectionCostPercentage,RegistrationCostPerNumber';
					SET @v_ResultField_2 = '';

					IF @v_MergeTo like 'Outpayment%' THEN

						set @v_ResultField_2 = REPLACE(@v_Component,',',' - ');
						set @v_ResultField_2 = REPLACE(@v_ResultField_2,'- Outpayment','+ Outpayment');
						
					ELSE 

						set @v_ResultField_2 = REPLACE(@v_Component,',',' + ');
						set @v_ResultField_2 = REPLACE(@v_ResultField_2,'+ Outpayment','- Outpayment');


					END IF ;

					set @v_ResultField_2 = CONCAT('(' , @v_ResultField_2 , ') as ' , @v_MergeTo );

					set @v_ResultField =  REPLACE(@v_ResultField, @v_MergeTo , @v_ResultField_2 );


                END IF;

				TRUNCATE TABLE tmp_SelectedVendortblRateTableDIDRate_dup;

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
                        (  fn_IsEmpty(@p_Timezone) 		 OR FIND_IN_SET(TimezonesID,@p_Timezone) != 0 )
                    AND (  fn_IsEmpty(@p_Origination)  	 OR FIND_IN_SET(OriginationCode,@p_Origination) != 0 OR FIND_IN_SET(OriginationCode2,@p_Origination) != 0)
                    AND (  fn_IsEmpty(@v_FromCountryID)  OR CountryID = 	@v_FromCountryID )
                    AND (  fn_IsEmpty(@v_FromAccessType) OR AccessType = 	@v_FromAccessType )
                    AND (  fn_IsEmpty(@v_FromPrefix)  	 OR Code = 	concat(CountryPrefix ,@v_FromPrefix) )
                    AND (  fn_IsEmpty(@v_FromCity)  	 OR City = 	@v_FromCity )
                    AND (  fn_IsEmpty(@v_FromTariff)  	 OR Tariff = 	@v_FromTariff );
				');

				PREPARE stm1 FROM @stm1;
				EXECUTE stm1;
				DEALLOCATE PREPARE stm1;


				-- delete source  records  
                DELETE 
                from tmp_SelectedVendortblRateTableDIDRate
                where 
                        (  fn_IsEmpty(@p_Timezone) 		OR  FIND_IN_SET(TimezonesID,@p_Timezone) != 0 )
                    AND (  fn_IsEmpty(@p_Origination)  	 OR FIND_IN_SET(OriginationCode,@p_Origination) != 0 OR FIND_IN_SET(OriginationCode2,@p_Origination) != 0)
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
 
 

				insert into tmp_SelectedVendortblRateTableDIDRate
				(
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

					from tmp_SelectedVendortblRateTableDIDRate_dup;


				-- CLEARE COMPONENT WHICH IS SELECTED IN RULE.

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
                        (  fn_IsEmpty(@p_Timezone) 		OR  FIND_IN_SET(TimezonesID,@p_Timezone) != 0 )
                    AND (  fn_IsEmpty(@p_Origination)  	 OR FIND_IN_SET(OriginationCode,@p_Origination) != 0 OR FIND_IN_SET(OriginationCode2,@p_Origination) != 0)
                    AND (  fn_IsEmpty(@v_FromCountryID) OR CountryID = 	@v_FromCountryID )
                    AND (  fn_IsEmpty(@v_FromAccessType) OR AccessType = 	@v_FromAccessType )
                    AND (  fn_IsEmpty(@v_FromPrefix)  OR Code = 	concat(CountryPrefix ,@v_FromPrefix) )
                    AND (  fn_IsEmpty(@v_FromCity)  OR City = 	@v_FromCity )
                    AND (  fn_IsEmpty(@v_FromTariff)  OR Tariff = 	@v_FromTariff );
			 
								  


 
			SET @v_pointer_ = @v_pointer_ + 1;

		END WHILE;


		ALTER TABLE tmp_SelectedVendortblRateTableDIDRate DROP COLUMN OriginationCode2;
		ALTER TABLE tmp_SelectedVendortblRateTableDIDRate_dup DROP COLUMN OriginationCode2;


	END//
DELIMITER ;



/*AccessType,
CountryID,
OriginationCode,
tblRate.Code,
City,
Tariff,
TimezoneTitle,
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

EffectiveDate,
EndDate,
updated_at,
ModifiedBy,*/