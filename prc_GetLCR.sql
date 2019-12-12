use speakintelligentRM;
DROP PROCEDURE IF EXISTS `prc_GetLCR`;
DELIMITER //
CREATE PROCEDURE `prc_GetLCR`(
	IN `p_companyid` INT,
	IN `p_trunkID` INT,
	IN `p_codedeckID` INT,
	IN `p_CurrencyID` INT,
	IN `p_Originationcode` VARCHAR(50),
	IN `p_OriginationDescription` VARCHAR(250),
	IN `p_code` VARCHAR(50),
	IN `p_Description` VARCHAR(250),
	IN `p_AccountIds` TEXT,
	IN `p_PageNumber` INT,
	IN `p_RowspPage` INT,
	IN `p_SortOrder` VARCHAR(50),
	IN `p_Preference` INT,
	IN `p_Position` INT,
	IN `p_vendor_block` INT,
	IN `p_SelectedEffectiveDate` DATE,
	IN `p_isExport` INT





































)
ThisSP:BEGIN


        SET @p_companyid                    = p_companyid;
        SET @p_trunkID                      = p_trunkID;
        
        SET @p_codedeckID                   = p_codedeckID;
        SET @p_CurrencyID                   = p_CurrencyID;
        SET @p_Originationcode              = p_Originationcode;
        SET @p_OriginationDescription       = p_OriginationDescription;
        SET @p_code                         = p_code;
        SET @p_Description                  = p_Description;
        SET @p_AccountIds                   = p_AccountIds;
        SET @p_PageNumber                   = p_PageNumber;
        SET @p_RowspPage                    = p_RowspPage;
        SET @p_SortOrder                    = p_SortOrder;
        SET @p_Preference                   = p_Preference;
        SET @p_Position                     = p_Position;
        SET @p_vendor_block                 = p_vendor_block;
        
        SET @p_SelectedEffectiveDate        = p_SelectedEffectiveDate;
        
        
        
        SET @p_isExport                     = p_isExport;



        SET	@v_RateTypeID = 1;	
        set @v_AppliedToCustomer = 1; 
        set @v_AppliedToVendor = 2; 
        set @v_AppliedToReseller = 3; 


		SET @v_default_TimezonesID = (SELECT TimezonesID from tblTimezones where Title = 'Default');

		SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

		SET @@session.collation_connection='utf8_unicode_ci';
		SET @@session.character_set_results='utf8';



		SET @v_OffSet_ = (@p_PageNumber * @p_RowspPage) - @p_RowspPage;

			DROP TEMPORARY TABLE IF EXISTS tmp_timezones;
			CREATE TEMPORARY TABLE tmp_timezones (
				ID int auto_increment,
				TimezonesID int,
				primary key (ID)
			);

 		DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_stage_1;
		CREATE TEMPORARY TABLE tmp_VendorRate_stage_1 (
			RateTableRateID int,
			RowCode VARCHAR(50) ,
			RowOriginationCode VARCHAR(50) ,
			RowOriginationDescription VARCHAR(255),
			VendorConnectionID INT ,
			TimezonesID int,
			Blocked INT DEFAULT 0,
			VendorConnectionName VARCHAR(100) ,
			OriginationCode VARCHAR(50) ,
			Code VARCHAR(50) ,
			Rate DECIMAL(18,8) ,
			ConnectionFee DECIMAL(18,8) ,
			EffectiveDate DATETIME ,
			OriginationDescription VARCHAR(255),
			Description VARCHAR(255),
			Preference INT,
			MaxMatchRank int ,
			prev_OriginationCode VARCHAR(255),
			prev_RowCode VARCHAR(50),
			prev_VendorConnectionID int,
			prev_TimezonesID int,
			INDEX Index1 (RowCode,TimezonesID,VendorConnectionID),
			INDEX Index2 (OriginationCode,Code)

		);

 		DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_stage_;
		CREATE TEMPORARY TABLE tmp_VendorRate_stage_ (
			RateTableRateID int,
			RowCode VARCHAR(50) ,
			RowOriginationCode VARCHAR(50) ,
			RowOriginationDescription VARCHAR(255),
			VendorConnectionID INT ,
			TimezonesID int,
			Blocked INT DEFAULT 0,
			VendorConnectionName VARCHAR(100) ,
			OriginationCode VARCHAR(50) ,
			Code VARCHAR(50) ,
			Rate DECIMAL(18,8) ,
			ConnectionFee DECIMAL(18,8) ,
			EffectiveDate DATETIME ,
			OriginationDescription VARCHAR(255),
			Description VARCHAR(255),
			Preference INT,
			MaxMatchRank int ,
			prev_OriginationCode VARCHAR(255),
			prev_RowCode VARCHAR(50),
			prev_VendorConnectionID int,
			prev_TimezonesID int	,
			INDEX Index1 (RowCode,TimezonesID,VendorConnectionID),
			INDEX Index2 (OriginationCode,Code),
			INDEX Index3 (MaxMatchRank)

		);


 		DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_stage_1_DEFAULT;
		CREATE TEMPORARY TABLE tmp_VendorRate_stage_1_DEFAULT (
			RateTableRateID int,
			RowCode VARCHAR(50) ,
			RowOriginationCode VARCHAR(50) ,
			RowOriginationDescription VARCHAR(255),
			VendorConnectionID INT ,
			TimezonesID int,
			Blocked INT DEFAULT 0,
			VendorConnectionName VARCHAR(100) ,
			OriginationCode VARCHAR(50) ,
			Code VARCHAR(50) ,
			Rate DECIMAL(18,8) ,
			ConnectionFee DECIMAL(18,8) ,
			EffectiveDate DATETIME ,
			OriginationDescription VARCHAR(255),
			Description VARCHAR(255),
			Preference INT,
			MaxMatchRank int ,
			prev_OriginationCode VARCHAR(255),
			prev_RowCode VARCHAR(50),
			prev_VendorConnectionID int,
			prev_TimezonesID int,
			INDEX Index1 (VendorConnectionID),
			INDEX Index2 (OriginationCode,RowCode)

		);


 		DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_stage_1_dup;
		CREATE TEMPORARY TABLE tmp_VendorRate_stage_1_dup (
			RateTableRateID int,
			RowCode VARCHAR(50) ,
			RowOriginationCode VARCHAR(50) ,
			RowOriginationDescription VARCHAR(255),
			VendorConnectionID INT ,
			TimezonesID int,
			Blocked INT DEFAULT 0,
			VendorConnectionName VARCHAR(100) ,
			OriginationCode VARCHAR(50) ,
			Code VARCHAR(50) ,
			Rate DECIMAL(18,8) ,
			ConnectionFee DECIMAL(18,8) ,
			EffectiveDate DATETIME ,
			OriginationDescription VARCHAR(255),
			Description VARCHAR(255),
			Preference INT,
			MaxMatchRank int ,
			prev_OriginationCode VARCHAR(255),
			prev_RowCode VARCHAR(50),
			prev_VendorConnectionID int,
			prev_TimezonesID int,

			INDEX Index1 (VendorConnectionID),
			INDEX Index2 (TimezonesID,OriginationCode,RowCode)
			
		);

		DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_stage2_;
		CREATE TEMPORARY TABLE tmp_VendorRate_stage2_ (
			RateTableRateID int,
			
			RowCode VARCHAR(50) ,
			RowOriginationCode VARCHAR(50) ,
			RowOriginationDescription VARCHAR(255),
			VendorConnectionID INT ,
			TimezonesID int,
			Blocked INT DEFAULT 0,
			VendorConnectionName VARCHAR(100) ,
			OriginationCode VARCHAR(50) ,
			Code VARCHAR(50) ,
			Rate DECIMAL(18,8) ,
			ConnectionFee DECIMAL(18,8) ,
			EffectiveDate DATETIME ,
			OriginationDescription VARCHAR(255),
			Description VARCHAR(255),
			Preference INT,
			MaxMatchRank int ,
			prev_prev_RowCode VARCHAR(50),
			prev_VendorConnectionID int,
			prev_TimezonesID int			
		)
		;

		DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_;
		CREATE TEMPORARY TABLE tmp_VendorRate_ (
			RateTableRateID int,
			
			VendorConnectionID INT ,
			TimezonesID int,
			Blocked INT DEFAULT 0,
			VendorConnectionName VARCHAR(100) ,
			OriginationCode VARCHAR(50) ,
			Code VARCHAR(50) ,
			Rate DECIMAL(18,8) ,
			ConnectionFee DECIMAL(18,8) ,
			EffectiveDate DATETIME ,
			OriginationDescription VARCHAR(255),
			Description VARCHAR(255),
			Preference INT,
			RowCode VARCHAR(50),
			RowOriginationCode VARCHAR(50) ,
			RowOriginationDescription VARCHAR(255),

			INDEX Index1 (OriginationCode,RowCode),
			INDEX Index2 (TimezonesID,Rate,VendorConnectionID)
		
		)
		;

		DROP TEMPORARY TABLE IF EXISTS tmp_final_VendorRate_;
		CREATE TEMPORARY TABLE tmp_final_VendorRate_ (
			RateTableRateID int,
			VendorConnectionID INT ,
			TimezonesID int,
			TimezoneName VARCHAR(100) ,
			Blocked INT DEFAULT 0,
			VendorConnectionName VARCHAR(100) ,
			OriginationCode VARCHAR(50) ,
			Code VARCHAR(50) ,
			Rate DECIMAL(18,8) ,
			ConnectionFee DECIMAL(18,8) ,
			EffectiveDate DATETIME ,
			OriginationDescription VARCHAR(255),
			Description VARCHAR(255),
			Preference INT,
			RowCode VARCHAR(50),
			RowOriginationCode VARCHAR(50) ,
			RowOriginationDescription VARCHAR(255),
			FinalRankNumber int,
			INDEX Index1 (TimezoneName,OriginationCode,RowCode)

		)
		;



		DROP TEMPORARY TABLE IF EXISTS tmp_search_code_;
		CREATE TEMPORARY TABLE tmp_search_code_ (
			Code  varchar(50),
			RowCode  varchar(50),
			INDEX INDEX3(Code)
			
		);



		/*DROP TEMPORARY TABLE IF EXISTS tmp_search_code_dup;
		CREATE TEMPORARY TABLE tmp_search_code_dup (
			Code  varchar(50),
			RowCode  varchar(50)
			
		);*/



		


		


		DROP TEMPORARY TABLE IF EXISTS tmp_VendorCurrentRates_;
		CREATE TEMPORARY TABLE IF NOT EXISTS tmp_VendorCurrentRates_(
			RateTableRateID int,
			VendorConnectionID int,
			TimezonesID int,
			Blocked INT DEFAULT 0,
			VendorConnectionName varchar(200),
			OriginationCode varchar(50),
			Code varchar(50),
			OriginationDescription varchar(200),
			Description varchar(200),
			Rate DECIMAL(18,8) ,
			ConnectionFee DECIMAL(18,8) ,
			EffectiveDate date,
			TrunkID int,
			CountryID int,
			RateID int,
			Preference int,
			INDEX IX_Code (Code)
		)
		;

		DROP TEMPORARY TABLE IF EXISTS tmp_VendorCurrentRates1_;
		CREATE TEMPORARY TABLE IF NOT EXISTS tmp_VendorCurrentRates1_(
			RateTableRateID int,
			VendorConnectionID int,
			TimezonesID int,
			Blocked INT DEFAULT 0,
			VendorConnectionName varchar(200),
			OriginationCode varchar(50),
			Code varchar(50),
			OriginationDescription varchar(200),
			Description varchar(200),
			Rate DECIMAL(18,8) ,
			ConnectionFee DECIMAL(18,8) ,
			EffectiveDate date,
			TrunkID int,
			CountryID int,
			OriginationRateID int,
			RateID int,
			Preference int,
			INDEX IX_Code (Code),
			INDEX tmp_VendorCurrentRates_VendorConnectionID (`VendorConnectionID`,`TimezonesID`,`RateId`,`EffectiveDate`)
		)
		;

		DROP TEMPORARY TABLE IF EXISTS tmp_VendorRateByRank_;
		CREATE TEMPORARY TABLE tmp_VendorRateByRank_ (
			RateTableRateID int,
			VendorConnectionID INT ,
			TimezonesID int,
			Blocked INT DEFAULT 0,
			VendorConnectionName VARCHAR(100) ,
			OriginationCode VARCHAR(50) ,
			Code VARCHAR(50) ,
			Rate DECIMAL(18,8) ,
			ConnectionFee DECIMAL(18,8) ,
			EffectiveDate DATETIME ,
			OriginationDescription VARCHAR(255),
			Description VARCHAR(255),
			Preference INT,
			rankname INT,
			INDEX IX_Code (Code,rankname)
		);

		SELECT CurrencyId INTO @v_CompanyCurrencyID_ FROM  tblCompany WHERE CompanyID = @p_companyid;

        Select Value INTO @v_DestinationCurrencyConversionRate from tblCurrencyConversion where tblCurrencyConversion.CurrencyId =  @p_CurrencyID  and  CompanyID = @p_companyid;
        Select Value INTO @v_CompanyCurrencyConversionRate from tblCurrencyConversion where tblCurrencyConversion.CurrencyId =  @v_CompanyCurrencyID_  and  CompanyID = @p_companyid;

		 

		insert into tmp_search_code_ ( RowCode, Code )
			SELECT  DISTINCT rsc.RowCode, rsc.Code 
				FROM tblRateSearchCode rsc
				INNER JOIN tblRate r on r.Code = rsc.RowCode AND r.CodeDeckID = rsc.CodeDeckID AND r.CompanyID = rsc.CompanyID
				WHERE r.CompanyID = @p_companyid  AND r.CodeDeckId = @p_codedeckID    
					AND
					(
						(
							( CHAR_LENGTH(RTRIM(@p_code)) = 0 OR @p_code = '*'  OR r.Code LIKE REPLACE(@p_code,'*', '%') )
							AND ( @p_Description = ''  OR @p_Description = '*' OR  r.Description LIKE REPLACE(@p_Description,'*', '%') )
						)
						
					);
		
		

		-- insert into tmp_search_code_dup select * from tmp_search_code_; not in use

			
			
			INSERT INTO tmp_VendorCurrentRates1_
				 
					 SELECT distinct
						RateTableRateID,
						vt.VendorConnectionID,
						tblRateTableRate.TimezonesID,
						tblRateTableRate.Blocked,
						vt.Name as VendorConnectionName,
						IFNULL(r2.Code,"") as OriginationCode,
						tblRate.Code,
						IFNULL(r2.Description,"") as OriginationDescription ,
						tblRate.Description,
						CASE WHEN  tblRateTableRate.RateCurrency IS NOT NULL 
                        THEN
                            CASE WHEN  tblRateTableRate.RateCurrency = @p_CurrencyID
                            THEN
                                tblRateTableRate.Rate
                            ELSE
                            (
								(@v_DestinationCurrencyConversionRate  ) * (tblRateTableRate.rate  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = tblRateTableRate.RateCurrency and  CompanyID = @p_companyid ))
                            )
                            END
                        ELSE 
                            (
								( @v_DestinationCurrencyConversionRate ) * ( tblRateTableRate.rate  / ( @v_CompanyCurrencyConversionRate ) )
                            )
                        END    
                        as Rate,
						CASE WHEN  tblRateTableRate.RateCurrency IS NOT NULL 
                        THEN
                            CASE WHEN  tblRateTableRate.RateCurrency = @p_CurrencyID
                            THEN
                                tblRateTableRate.ConnectionFee
                            ELSE
                            (

								(@v_DestinationCurrencyConversionRate  ) * (tblRateTableRate.ConnectionFee  / (Select Value from tblCurrencyConversion where tblCurrencyConversion.CurrencyId = tblRateTableRate.RateCurrency and  CompanyID = @p_companyid ))
                                
                            )
                            END
                        ELSE 
                            (
								( @v_DestinationCurrencyConversionRate ) * ( tblRateTableRate.ConnectionFee  / (@v_CompanyCurrencyConversionRate ) )

                            )
                        END    
                        as ConnectionFee,
						DATE_FORMAT(tblRateTableRate.EffectiveDate,"%Y-%m-%d") AS EffectiveDate, 
                        vt.TrunkID, 
                        tblRate.CountryID,
						r2.RateID as OriginationRateID,
						tblRate.RateID,
                        IFNULL(Preference, 5) AS Preference
					FROM
						tblRateTableRate
                    INNER JOIN tblRateTable ON tblRateTable.RateTableID = tblRateTableRate.RateTableID AND  tblRateTable.CompanyID = @p_companyid AND tblRateTable.Type = @v_RateTypeID AND tblRateTable.AppliedTo = @v_AppliedToVendor
					INNER JOIN tblVendorConnection vt ON vt.CompanyID = @p_companyid and vt.RateTableID = tblRateTableRate.RateTableID  and vt.RateTypeID = 1   and vt.Active = 1 and vt.TrunkID = @p_trunkID
					INNER JOIN tblAccount ON tblAccount.AccountID = vt.AccountId AND  tblAccount.CompanyID = @p_companyid AND vt.AccountId = tblAccount.AccountID
					INNER JOIN tblRate ON tblRate.CompanyID = @p_companyid AND tblRateTableRate.RateId = tblRate.RateID 
					INNER JOIN ( select distinct Code from tmp_search_code_ ) SplitCode ON tblRate.Code = SplitCode.Code
					
					LEFT JOIN tblRate r2 ON r2.CompanyID = @p_companyid AND tblRateTableRate.OriginationRateID = r2.RateID

					WHERE
						
						( EffectiveDate <= DATE(@p_SelectedEffectiveDate) )

						AND ( fn_IsEmpty(@p_Originationcode) OR  ( @p_Originationcode = 'blank' AND r2.Code IS NULL ) OR r2.Code LIKE REPLACE(@p_Originationcode,"*", "%") OR r2.Code IS NULL )
						AND ( fn_IsEmpty(@p_OriginationDescription) OR ( @p_OriginationDescription = 'blank'  AND r2.Description IS NULL ) OR r2.Description LIKE REPLACE(@p_OriginationDescription,"*", "%")  OR r2.Description IS NULL  )


						AND ( fn_IsEmpty(@p_Originationcode)  OR  ( @p_Originationcode = 'blank' AND r2.RateID IS NULL ) OR  ( r2.RateID IS NOT NULL  ) OR r2.RateID IS NULL )
						AND ( fn_IsEmpty(@p_OriginationDescription) OR  ( @p_OriginationDescription = 'blank' AND r2.RateID IS NULL ) OR  ( r2.RateID IS NOT NULL  ) OR r2.RateID IS NULL )
						

						AND ( tblRateTableRate.EndDate IS NULL OR  tblRateTableRate.EndDate > Now() )   
						AND ( fn_IsEmpty(@p_AccountIds) OR FIND_IN_SET(tblAccount.AccountID,@p_AccountIds) != 0 )
						AND tblAccount.IsVendor = 1
						AND tblAccount.Status = 1
                        AND
						(
							( @p_vendor_block = 1 )
							OR
							( @p_vendor_block = 0 AND tblRateTableRate.Blocked = 0	)
						);
		

			INSERT INTO tmp_VendorCurrentRates_
			Select RateTableRateID,VendorConnectionID,TimezonesID,Blocked,VendorConnectionName,OriginationCode,Code,OriginationDescription,Description, Rate,ConnectionFee,EffectiveDate,TrunkID,CountryID,RateID,Preference
				FROM (
						SELECT * ,
							@row_num := IF(@prev_RateTableRateID = RateTableRateID AND @prev_VendorConnectionID = VendorConnectionID AND  @prev_TimezonesID = TimezonesID AND @prev_TrunkID = TrunkID AND @prev_OriginationRateID = OriginationRateID AND  @prev_RateId = RateID AND @prev_EffectiveDate >= EffectiveDate, @row_num + 1, 1) AS RowID,
							@prev_RateTableRateID := RateTableRateID,
							@prev_VendorConnectionID := VendorConnectionID,
							@prev_TimezonesID := TimezonesID,
							@prev_TrunkID := TrunkID,
							@prev_OriginationRateID := OriginationRateID,
							@prev_RateId := RateID,
							@prev_EffectiveDate := EffectiveDate
						FROM tmp_VendorCurrentRates1_
							, ( SELECT @row_num := 1, @prev_RateTableRateID := '',  @prev_VendorConnectionID := '', @prev_TimezonesID := '', @prev_TrunkID := '', @prev_OriginationRateID := '', @prev_RateId := '', @prev_EffectiveDate := '' ) x
						ORDER BY VendorConnectionID,TimezonesID,TrunkID, OriginationRateID,RateId, EffectiveDate , RateTableRateID DESC
				) tbl
				WHERE RowID = 1;
  



		
			/*
			
			ORIGINATION CHANGE:
			On every Origination there should be exact match or Null.


			
			*/
 

			insert ignore into tmp_VendorRate_stage_1 (
				RateTableRateID,
				RowCode,
				RowOriginationCode,
				RowOriginationDescription,
				VendorConnectionID ,
				TimezonesID,
				Blocked,
				VendorConnectionName ,
				OriginationCode ,
				Code ,
				Rate ,
				ConnectionFee,
				EffectiveDate ,
				OriginationDescription ,
				Description ,
				Preference
			)
			SELECT
				distinct
				RateTableRateID,
				SplitCode.RowCode,
				IFNULL(v.OriginationCode,'') as RowOriginationCode,
				IFNULL(tr1.Description,'') as RowOriginationDescription,

				v.VendorConnectionID ,
				v.TimezonesID,
				Blocked,
				v.VendorConnectionName ,
				IFNULL(v.OriginationCode,'') as OriginationCode,
				v.Code,
				v.Rate,
				v.ConnectionFee,
				v.EffectiveDate,
				IFNULL(tr1.Description,'') as OriginationDescription,
				tr.Description,
				v.Preference

			FROM tmp_VendorCurrentRates_ v

			INNER join  tmp_search_code_ 		SplitCode   on v.Code = SplitCode.Code
			INNER join tblRate tr on tr.CodeDeckId = @p_codedeckID and SplitCode.Code = tr.Code
			left join tblRate tr1 on tr1.CodeDeckId = @p_codedeckID and v.OriginationCode != '' AND v.OriginationCode = tr1.Code;
			




		update tmp_VendorRate_stage_1 v 
		INNER JOIN tblTimezones t on v.TimezonesID = t.TimezonesID
		SET  v.VendorConnectionName = concat(v.VendorConnectionName ,' - ' , t.Title  );



		/* https://trello.com/c/lNoBb2bb/48-termination-comparison

		+---------------------------------------- ----+----------+------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------+----------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------+
		| Destination                                 | Timezone | POSITION 1                                                                                                                               | POSITION 2                                                                                                                               | POSITION 3                                                                                                         | POSITION 4                                                                                                     | POSITION 5                                                                                                             | POSITION 6                                                                                                       | POSITION 7                                                                                                             | POSITION 8                                                                                                         | POSITION 9                                                                                                       | POSITION 10                                                                                                        |
		+-------------------------               -----+----------+------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------+----------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------+
		| :       => 32 : belgium                     | Default  |         32    belgium    0.01190000    Ziggo - International Termination (origin based) - Default    07/11/2019=45125968-10-32-0-5-1     |         32    belgium    0.02255327    Telecom2 - Termination - Default    05/12/2019=177155727-2-32-0-5-1                               |         32    belgium    0.06640000    VoiceON - All Origin based - Default    22/11/2019=29790754-22-32-0-5-1     |         32    belgium    0.07313770    PCCW - Termination - Default    08/12/2019=120077145-34-32-0-5-1        |         32    belgium    0.07575000    Deutsche Telekom - Termination - Default    10/12/2019=176800205-3-32-0-5-1     |         32    belgium    0.08234910    Telecom2 - BT Termination - Default    05/11/2019=2301272-11-32-0-5-1     |         32    belgium    0.26000000    CM - Termination - Default    11/11/2019=12332884-15-32-0-5-1                   |         32    belgium    0.32500000    Globtel - All Origin based - Default    22/11/2019=16428846-28-32-0-5-1     |                                                                                                                  |                                                                                                                    |
		+------------- ------------------------ --    +----------+------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------+----------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------+
		| 31 : netherlands      => 32 : belgium		  | Default  | 31    netherlands    32    belgium    0.01000000    CM - Termination - Default    11/11/2019=29790760-15-32-0-5-1                        |         32    belgium    0.01190000    Ziggo - International Termination (origin based) - Default    07/11/2019=45125968-10-32-0-5-1     | 31    netherlands    32    belgium    0.02173000    Globtel - EU - Default    11/11/2019=14439409-31-32-0-5-1      |         32    belgium    0.02255327    Telecom2 - Termination - Default    05/12/2019=177155727-2-32-0-5-1     |         32    belgium    0.06640000    VoiceON - All Origin based - Default    22/11/2019=29790754-22-32-0-5-1         |         32    belgium    0.07313770    PCCW - Termination - Default    08/12/2019=120077145-34-32-0-5-1          |         32    belgium    0.07575000    Deutsche Telekom - Termination - Default    10/12/2019=176800205-3-32-0-5-1     | 31    netherlands    32    belgium    0.07620000    VoiceON - EU - Default    12/11/2019=15778315-25-32-0-5-1      |         32    belgium    0.08234910    Telecom2 - BT Termination - Default    05/11/2019=2301272-11-32-0-5-1     |         32    belgium    0.32500000    Globtel - All Origin based - Default    22/11/2019=16428846-28-32-0-5-1     |
		+------------- ------------------------ --    +----------+------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------+----------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------+

			Show Bank origination code in position where Origination code is not matched.
			ORIGINATION CHANGE:
			When the Origination code cannot be matched the Blank code should be used.

						Ziggo purchase
						- Origination: Blank	(NULL)
						- Destination: prefix 32
						- Rate: 0.011900

						CM purchase
						- Origination: 32
						- Destination prefix 32
						- Rate: 0.01000

						Comparison
						Input
						- Origination: 32
						- Destination: 32

						Output
						- Position 1: CM

						Output Expected
						- Position 1: CM
						- Position 2: Ziggo

				-- -------------------------------------------------------
				Origination		Code 		Vendor 			Rate
				91				91			 Vendor1		0.001
				NULL			91			 Vendor2		0.1

				FILTER:
				Origination: 91
				Destination: 91

				OUTPUT
				Position1			Position2
				Vendor1				Vendor2
				0.001				0.1
			*/
			-- At this change get all exact match or Null Origination.
	
		DROP TABLE IF EXISTS tmp_VendorRate_stage_1_dup1;
		DROP TABLE IF EXISTS tmp_VendorRate_stage_1_dup2;

		CREATE TEMPORARY TABLE tmp_VendorRate_stage_1_dup1 LIKE tmp_VendorRate_stage_1;
		CREATE TEMPORARY TABLE tmp_VendorRate_stage_1_dup2 LIKE tmp_VendorRate_stage_1;

		INSERT INTO tmp_VendorRate_stage_1_dup1 SELECT * FROM  tmp_VendorRate_stage_1;
		INSERT INTO tmp_VendorRate_stage_1_dup2 SELECT * FROM  tmp_VendorRate_stage_1;

		
			-- new change 
			insert ignore into tmp_VendorRate_stage_1 (
				RateTableRateID,
				RowCode,
				RowOriginationCode,
				RowOriginationDescription,
				VendorConnectionID ,
				TimezonesID,
				Blocked,
				VendorConnectionName ,
				OriginationCode ,
				Code ,
				Rate ,
				ConnectionFee,
				EffectiveDate ,
				OriginationDescription ,
				Description ,
				Preference
			)
			SELECT
				distinct
				v.RateTableRateID,
				v.RowCode,
				v2.RowOriginationCode,
				v2.RowOriginationDescription,
				v.VendorConnectionID ,
				v.TimezonesID,
				v.Blocked,
				v.VendorConnectionName ,
				v.OriginationCode,
				v.Code,
				v.Rate,
				v.ConnectionFee,
				v.EffectiveDate,
				v.OriginationDescription,
				v.Description,
				v.Preference

			FROM tmp_VendorRate_stage_1_dup1 v
			INNER JOIN tmp_VendorRate_stage_1_dup2 v2
			WHERE v.OriginationCode = '' AND v2.OriginationCode != '' and v.Code = v2.Code AND  v.VendorConnectionID != v2.VendorConnectionID;
			
			
		/* just for display: Remove blank RowOriginationCode records when data is present with RowOriginationCode with  RowCode */
		DROP TEMPORARY TABLE IF EXISTS tmp_VendorRate_stage_1_orig;
		CREATE TEMPORARY TABLE tmp_VendorRate_stage_1_orig (
			RowOriginationCode VARCHAR(50) ,
			RowCode VARCHAR(50) ,
			TimezonesID int,
			INDEX Index1 (RowCode,TimezonesID)
		);

		insert into tmp_VendorRate_stage_1_orig
		select  distinct 
		RowOriginationCode,
		RowCode,
		TimezonesID
		from tmp_VendorRate_stage_1
		where RowOriginationCode != '' and RowCode != '';


		delete v from tmp_VendorRate_stage_1 v
		inner join tmp_VendorRate_stage_1_orig vd on 
		v.RowOriginationCode = '' -- vd.RowOriginationCode 
		and v.RowCode = vd.RowCode 
		and v.TimezonesID = vd.TimezonesID;





 
		         /*
             Purchase CASE 1
             Vendor A, destination 31:
                Default: 0.01
             Vendor B, destination 31:
                Peak: 0.025
                Off peak: 0.017
                Weekend 
             Vendor C, destination 31:
                Default: 0.015
             Routing
             Call comes in during peak: Vendor A, C, B
             Call comes in during Off peak: Vendor A, C, B
             Comparison
             In case there is a single Vendor involved with non-Default pricing (as given in this example):
             
 
             Destination    Time of day    Position 1          Position 2            Position 3
             31             Peak        Vendor A (0.01)        Vendor C (0.015)    Vendor B (0.025)
             31             Off peak    Vendor A (0.01)        Vendor C (0.015)    Vendor B (0.017)
 
 
             Purchase CASE 2 
             Vendor A, destination 42:
                Default: 0.01
             Vendor B, destination 42:
                Peak: 0.02
                Off peak: 0.005
             Vendor C, destination 42:
                Default: 0.015
             Routing
             Call comes in during peak: Vendor A, C, B
             Call comes in during Off peak: Vendor B, A, C
             Comparison
             In case there is a single Vendor involved with non-Default pricing (as given in this example):
           
             Destination    Time of day    Position 1            Position 2            Position 3
             42             Peak        Vendor A (0.01)     Vendor C (0.015)    Vendor B (0.02)
             42             Off peak    Vendor B (0.005)    Vendor A (0.01)        Vendor C (0.015)
 
             lOGIC : when all vendors are not giving default rates
             ASSUMPTION : VENDOR CANT HAVE PEAK OR OFF PEAK WITH DEFAULT RATES.
             STEP 1 COLLECT ALL DEFAULT TIMEZONE RATES INTO TEMP TABLE tmp_VendorRate_stage_1_DEFAULT
             STEP 2 DELETE ALL DEFAULT TIMEZONE RATES FROM ORIGINAL TABLE tmp_VendorRate_stage_1
             STEP 3 INSERT INTO ORIGINAL TABLE WITH ALL DEFAULT AS PEAK 
             STEP 4 INSERT INTO ORIGINAL TABLE WITH ALL DEFAULT AS OFF PEAK AND SO ON
		 */

		SET @v_hasDefault_ = ( SELECT COUNT(TimezonesID) FROM ( SELECT DISTINCT TimezonesID FROM tmp_VendorRate_stage_1 WHERE TimezonesID = @v_default_TimezonesID group by TimezonesID ) tmp );
		SET @v_rowCount_ = ( SELECT COUNT(TimezonesID) FROM ( SELECT DISTINCT TimezonesID FROM tmp_VendorRate_stage_1 WHERE TimezonesID != @v_default_TimezonesID group by TimezonesID ) tmp );
		SET @v_pointer_ = 1;
		
		IF @v_rowCount_ > 0 AND @v_hasDefault_ = 1 THEN 
				
				INSERT INTO tmp_VendorRate_stage_1_DEFAULT
				SELECT * FROM tmp_VendorRate_stage_1 WHERE TimezonesID = @v_default_TimezonesID;

				DELETE  FROM tmp_VendorRate_stage_1 WHERE TimezonesID = @v_default_TimezonesID;

				INSERT INTO tmp_VendorRate_stage_1_dup SELECT * FROM tmp_VendorRate_stage_1;

				
				select GROUP_CONCAT(TimezonesID)  INTO @v_rest_TimezonesIDs from tblTimezones WHERE TimezonesID != @v_default_TimezonesID;


									INSERT INTO tmp_VendorRate_stage_1 (
														RateTableRateID,
														RowCode,
														RowOriginationCode,
														RowOriginationDescription,
														VendorConnectionID ,
														TimezonesID,
														Blocked,
														VendorConnectionName ,
														OriginationCode ,
														Code ,
														Rate ,
														ConnectionFee,
														EffectiveDate ,
														OriginationDescription ,
														Description ,
														Preference

													)
													SELECT 
														vd.RateTableRateID,
														vd.RowCode,
														vd.RowOriginationCode,
														vd.RowOriginationDescription,
														vd.VendorConnectionID ,
														v.TimezonesID,
														vd.Blocked,
														vd.VendorConnectionName ,
														vd.OriginationCode ,
														vd.Code ,
														vd.Rate ,
														vd.ConnectionFee,
														vd.EffectiveDate ,
														vd.OriginationDescription ,
														vd.Description ,
														vd.Preference

							FROM tmp_VendorRate_stage_1_DEFAULT vd
							INNER JOIN tmp_VendorRate_stage_1_dup v on 
												v.VendorConnectionID != vd.VendorConnectionID AND
												FIND_IN_SET(v.TimezonesID, @v_rest_TimezonesIDs) != 0 AND
												vd.RowOriginationCode = v.RowOriginationCode AND
												vd.RowCode = v.RowCode;

				
		END IF;

		

		-- remove multiple vendor per rowcode

		insert ignore into tmp_VendorRate_stage_
			SELECT
				RateTableRateID,
				RowCode,
				v.RowOriginationCode,
				v.RowOriginationDescription,
				v.VendorConnectionID ,
				v.TimezonesID,
				Blocked,
				v.VendorConnectionName ,
				v.OriginationCode ,
				v.Code ,
				v.Rate ,
				v.ConnectionFee,
				v.EffectiveDate ,
				v.OriginationDescription,
				v.Description,
				v.Preference,
				@rank := ( CASE WHEN ( ( @prev_TimezonesID = v.TimezonesID ) AND @prev_OriginationCode = v.RowOriginationCode and  @prev_RowCode = RowCode  AND @prev_VendorConnectionID = v.VendorConnectionID ) THEN  @rank + 1
								ELSE 1
								END
				) AS MaxMatchRank,
				@prev_TimezonesID := v.TimezonesID,
				@prev_OriginationCode := v.RowOriginationCode,
				@prev_RowCode := RowCode	 ,
				@prev_VendorConnectionID := v.VendorConnectionID

			FROM tmp_VendorRate_stage_1 v
			inner join tblRate tr on tr.CompanyID = @p_companyid AND tr.CodeDeckId = @p_codedeckID and tr.Code = v.RowCode		
				, (SELECT  @prev_OriginationCode := NUll , @prev_RowCode := '',  @rank := 0 , @prev_Code := '' , @prev_TimezonesID := '' , @prev_VendorConnectionID := Null) f
			order by  RowCode,TimezonesID,VendorConnectionID,RowOriginationCode,Code desc;

		 
			insert ignore into tmp_VendorRate_
			select
				distinct
				RateTableRateID,
				VendorConnectionID ,
				TimezonesID,
				Blocked,
				VendorConnectionName ,
				OriginationCode ,
				Code ,
				Rate ,
				ConnectionFee,
				EffectiveDate ,
				OriginationDescription ,
				Description ,
				Preference,
				RowCode,
				RowOriginationCode,
				RowOriginationDescription
			from tmp_VendorRate_stage_
			where MaxMatchRank = 1;


		IF( @p_Preference = 0 )
		THEN

				insert into tmp_final_VendorRate_ (
						RateTableRateID,
						VendorConnectionID ,
						TimezonesID,
						Blocked,
						VendorConnectionName ,
						OriginationCode ,
						Code ,
						Rate ,
						ConnectionFee,
						EffectiveDate ,
						OriginationDescription ,
						Description ,
						Preference,
						RowCode,
						RowOriginationCode,
						RowOriginationDescription,
						FinalRankNumber
				)
					SELECT
						RateTableRateID,
						VendorConnectionID ,
						TimezonesID,
						Blocked,
						VendorConnectionName ,
						OriginationCode ,
						Code ,
						Rate ,
						ConnectionFee,
						EffectiveDate ,
						OriginationDescription ,
						Description ,
						Preference,
						RowCode,
						RowOriginationCode,
						RowOriginationDescription,
						FinalRankNumber
					from
						(
							SELECT
								RateTableRateID,
								VendorConnectionID ,
								TimezonesID,
								Blocked,
								VendorConnectionName ,
								OriginationCode ,
								Code ,
								Rate ,
								ConnectionFee,
								EffectiveDate ,
								OriginationDescription ,
								Description ,
								Preference,
								RowCode,
								RowOriginationCode,
								RowOriginationDescription,
								@rank := CASE WHEN ( ( @prev_TimezonesID = TimezonesID ) AND @prev_OriginationCode    = RowOriginationCode AND  @prev_RowCode     = RowCode AND @prev_Rate <  Rate ) THEN @rank+1
											  WHEN ( ( @prev_TimezonesID = TimezonesID ) AND @prev_OriginationCode    = RowOriginationCode AND   @prev_RowCode    = RowCode AND @prev_Rate = Rate ) THEN @rank
											  ELSE
												 1
											  END
									AS FinalRankNumber,
								@prev_TimezonesID  := TimezonesID,
								@prev_OriginationCode  := RowOriginationCode,
								@prev_RowCode  := RowCode,
								@prev_Rate  := Rate
							from tmp_VendorRate_
								,( SELECT @rank := 0 , @prev_RowCode := '' , @prev_TimezonesID := '', @prev_OriginationCode := '', @prev_Rate := 0 ) x
							order by RowOriginationCode,RowCode,TimezonesID,Rate,VendorConnectionID ASC
							

						) tbl1
					where
						(@p_isExport = 1  OR @p_isExport = 2) OR (@p_isExport = 0 AND FinalRankNumber <= @p_Position);

 
		ELSE

			 

				insert into tmp_final_VendorRate_
						(
								RateTableRateID,
								VendorConnectionID ,
								TimezonesID,
								Blocked,
								VendorConnectionName ,
								OriginationCode ,
								Code ,
								Rate ,
								ConnectionFee,
								EffectiveDate ,
								OriginationDescription ,
								Description ,
								Preference,
								RowCode,
								RowOriginationCode,
								RowOriginationDescription,
								FinalRankNumber
						)
					SELECT
						RateTableRateID,
						VendorConnectionID ,
						TimezonesID,
						Blocked,
						VendorConnectionName ,
						OriginationCode ,
						Code ,
						Rate ,
						ConnectionFee,
						EffectiveDate ,
						OriginationDescription ,
						Description ,
						Preference,
						RowCode,
						RowOriginationCode,
						RowOriginationDescription,
						FinalRankNumber
					from
						(
							SELECT
								RateTableRateID,
								VendorConnectionID ,
								TimezonesID,
								Blocked,
								VendorConnectionName ,
								OriginationCode ,
								Code ,
								Rate ,
								ConnectionFee,
								EffectiveDate ,
								OriginationDescription ,
								Description ,
								Preference,
								RowCode,
								RowOriginationCode,
								RowOriginationDescription,
								@preference_rank := CASE WHEN (	( @prev_TimezonesID = TimezonesID ) AND @prev_OriginationCode    = RowOriginationCode AND  @prev_Code     = RowCode AND @prev_Preference > Preference  )   THEN @preference_rank + 1
														WHEN (( @prev_TimezonesID = TimezonesID ) AND @prev_OriginationCode    = RowOriginationCode AND  @prev_Code     = RowCode AND @prev_Preference = Preference AND @prev_Rate < Rate) THEN @preference_rank + 1
														WHEN (( @prev_TimezonesID = TimezonesID ) AND @prev_OriginationCode    = RowOriginationCode AND  @prev_Code    = RowCode AND @prev_Preference = Preference AND @prev_Rate = Rate) THEN @preference_rank
														ELSE 1 END AS FinalRankNumber,
								@prev_TimezonesID := TimezonesID,
								@prev_OriginationCode := RowOriginationCode,
								@prev_Code := RowCode,
								@prev_Preference := Preference,
								@prev_Rate := Rate
							from tmp_VendorRate_
								,(SELECT @preference_rank := 0 ,@prev_TimezonesID := '', @prev_OriginationCode := ''  , @prev_Code := ''  , @prev_Preference := 5,  @prev_Rate := 0) x
								order by RowOriginationCode,RowCode,TimezonesID asc ,Preference desc ,VendorConnectionID ASC
							

						) tbl1
					where
						(@p_isExport = 1  OR @p_isExport = 2 ) OR (@p_isExport = 0 AND FinalRankNumber <= @p_Position);
 
		END IF;


		SET @stm_columns = "";


		IF @p_isExport = 0 AND @p_Position > 10 THEN
			SET @p_Position = 10;
		END IF;

		
		update tmp_final_VendorRate_
			SET
			 RowOriginationDescription = ifnull(REPLACE(RowOriginationDescription,",","-"),''),
			 OriginationDescription = ifnull(REPLACE(OriginationDescription,",","-"),''),
			 Description = ifnull(REPLACE(Description,",","-"),'');

				
		update tmp_final_VendorRate_ v 
		INNER JOIN tblTimezones t on v.TimezonesID = t.TimezonesID
		SET  v.TimezoneName = t.Title;


		delete from tmp_final_VendorRate_ where Rate is null;


		IF @p_isExport = 2
		THEN
 
				SELECT
					distinct
					MIN(RateTableRateID) as RateTableRateID,
					MIN(VendorConnectionID) as VendorConnectionID,
					TimezoneName as TimezoneName,
					MIN(Blocked) as Blocked,
					MIN(VendorConnectionName) as VendorConnectionName,
					OriginationCode as OriginationCode,
					MIN(Code) as Code,
					MIN(Rate) as Rate,
					MIN(ConnectionFee) as ConnectionFee,
					MIN(EffectiveDate ) as EffectiveDate,
					MIN(OriginationDescription) as OriginationDescription,
					MIN(Description) as Description,
					MIN(Preference) as Preference,
					RowCode as RowCode,
					MIN(FinalRankNumber) as FinalRankNumber
				from tmp_final_VendorRate_
				GROUP BY  TimezoneName,OriginationCode,RowCode ORDER BY TimezoneName,OriginationCode,RowCode ASC;

		ELSE


			IF @p_isExport = 1  OR @p_isExport = 2 THEN
				SELECT MAX(FinalRankNumber) INTO @p_Position FROM tmp_final_VendorRate_;
			END IF;


			SET @v_pointer_=1;
			WHILE @v_pointer_ <= @p_Position
			DO

				IF (@p_isExport = 0)
				THEN
					SET @stm_columns = CONCAT(@stm_columns, "GROUP_CONCAT(if(FinalRankNumber = ",@v_pointer_,", CONCAT(OriginationCode, '<br>', OriginationDescription, '<br>', Code , '<br>', Description, '<br>', Rate, '<br>', VendorConnectionName, '<br>', DATE_FORMAT(EffectiveDate, '%d/%m/%Y'),'', '=', RateTableRateID, '-', VendorConnectionID, '-', Code, '-', Blocked , '-', Preference, '-', TimezonesID  ), NULL) , '<BR>') AS `POSITION ",@v_pointer_,"`,");
				ELSE
					SET @stm_columns = CONCAT(@stm_columns, "GROUP_CONCAT(if(FinalRankNumber = ",@v_pointer_,", CONCAT(Code, '<br>', Description, '<br>', Rate, '<br>', VendorConnectionName, '<br>', DATE_FORMAT(EffectiveDate, '%d/%m/%Y')), NULL) SEPARATOR '<br>' )  AS `POSITION ",@v_pointer_,"`,");
				END IF;

				SET @v_pointer_ = @v_pointer_ + 1;

			END WHILE;

			SET @stm_columns = TRIM(TRAILING ',' FROM @stm_columns);



			IF ( @p_isExport = 0 )
			THEN

 
					SET @stm_query = CONCAT("SELECT GROUP_CONCAT(RowOriginationCode , ' : ' , RowOriginationDescription, ' <br> => '  , RowCode , ' : ' , Description) as Destination, TimezoneName as Timezone, ", @stm_columns," FROM tmp_final_VendorRate_  GROUP BY  RowOriginationCode,RowCode,TimezoneName ORDER BY OriginationCode,RowCode,TimezoneName ASC LIMIT ",@p_RowspPage," OFFSET ",@v_OffSet_," ;");

					select count(RowCode) as totalcount  from ( SELECT RowCode  from tmp_final_VendorRate_ GROUP BY RowOriginationCode, RowCode,TimezoneName ) tmp;

 

			END IF;

			IF @p_isExport = 1
			THEN

 
					SET @stm_query = CONCAT("SELECT GROUP_CONCAT(RowOriginationCode , ' : ' , RowOriginationDescription, '  => '  , RowCode , ' : ' , Description) as Destination, TimezoneName as Timezone, ", @stm_columns," FROM tmp_final_VendorRate_   GROUP BY  RowOriginationCode,RowCode ORDER BY RowCode ASC;");


 

			END IF;




			PREPARE stm_query FROM @stm_query;
			EXECUTE stm_query;
			DEALLOCATE PREPARE stm_query;

		END IF;


		SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

	END//
DELIMITER ;