

-- this script covers the stored procedure to execute READ operations for ACT 1
--- EV Registrations by model/year
--- Year over Year Growth

/*
USE jgdigitalDB;

    GO

-- BEGIN CREATION OF STORED PROC TO RETRIEVE YEAR OVER YEAR GROWTH, LINE CHART OF MODEL NAME REGISTERED BY YEAR, YEARLY COMPARISON OF BHEV vs PHEV

    CREATE OR ALTER PROCEDURE SP_EVRegistrationsByYearV1

        AS
        BEGIN
            
            SET NOCOUNT ON;

            ;WITH EVRegistrationsCTE AS
            
                (
                    SELECT 
                    B.ModelYear, 
                    B.ModelName, 
                    C.EVType,
                    A.RegistrationID,
                    A.CreatedAt,
                    DATEPART(YEAR, A.CreatedAt) AS RegistrationYear


                    FROM tblRegistrationInfo A

                    LEFT JOIN refVehicleinfo B ON A.VID = B.VID
                    LEFT JOIN refEVTypeInfo C ON A.EVID = C.EVID
                )
            SELECT
                RegistrationYear,
                COUNT(*) AS TotalRegistrations
            FROM EVRegistrationsCTE
            GROUP BY RegistrationYear
            ORDER BY RegistrationYear;

    END;
    GO
                

        -- ADDED SUCCESSFULLY


        -- BEGIN INTEGRATION TESTING

        -- EXEC SP_EVRegistrationsByYearV1;

       -- DROP PROCEDURE SP_EVRegistrationsByYearV1;



        -- REDO

        CREATE OR ALTER PROCEDURE SP_EVAdoptionTable

        AS
        BEGIN

            SET NOCOUNT ON;
    

            WITH registrationsByModelYear AS
            (

            SELECT

                    A.RegistrationID,
                    A.VID,
                    A.EVID,
                    A.ElectricRange,
                    B.Make,
                    B.ModelYear,
                    B.ModelName,
                    C.EVType,

                CASE 
                    WHEN A.ElectricRange < 100 THEN '0-100 Miles'
                    WHEN A.ElectricRange >= 100 AND A.ElectricRange < 200 THEN '100-200 Miles'
                    WHEN A.ElectricRange >= 200 AND A.ElectricRange < 300 THEN '200-300 Miles'
                    ELSE '300+ Miles'
                END AS RangeCategory
                    
                    FROM tblRegistrationInfo A

                    LEFT JOIN refVehicleinfo B ON A.VID = B.VID
                    LEFT JOIN refEVTypeInfo C ON A.EVID = C.EVID

            )

                SELECT * FROM registrationsByModelYear
                ORDER BY ModelYear DESC, MAKE, ModelName;

                END;


-- ADDED SUCCESSFULLY


-- RUNNING TEST


CREATE OR ALTER PROCEDURE SP_EVAdoptionTableV2

        AS
        BEGIN
            SET NOCOUNT ON;

                SELECT
                B.ModelYear,
                COUNT(*) AS TotalRegistrations

                FROM tblRegistrationInfo A

                LEFT JOIN refVehicleinfo B ON A.VID = B.VID
                GROUP BY B.ModelYear
            ORDER BY B.ModelYear
        

    END;


            -- ADDED SUCCESSFULLY

            -- INTEGRATION TEST BEGIN

            EXEC SP_EVAdoptionTableV2


    CREATE OR ALTER PROCEDURE SP_EVAdoptionByType

        AS
        BEGIN
            SET NOCOUNT ON;

                SELECT
                C.EVType,
                COUNT(*) AS TotalRegistrations

                FROM tblRegistrationInfo A

                LEFT JOIN refEVTypeInfo c ON A.EVID = C.EVID
                GROUP BY C.EVType
            ORDER BY C.EVType
        

    END;




    CREATE OR ALTER PROCEDURE dbo.SP_EVAdoptionSummary

                AS
                BEGIN
                    SET NOCOUNT ON;

                    ------------------------------------------------------------------
                    -- Result Set #1: Registrations by Model Year
                    ------------------------------------------------------------------
                    SELECT

                        B.ModelYear,
                        COUNT(*) AS TotalRegistrations

                        FROM tblRegistrationInfo A
                        LEFT JOIN refVehicleInfo B ON A.VID = B.VID
                            GROUP BY
                                B.ModelYear
                            ORDER BY
                                B.ModelYear;

                    ------------------------------------------------------------------
                    -- Result Set #2: Registrations by EV Type
                    ------------------------------------------------------------------
                    SELECT
                        C.EVType,
                        COUNT(*) AS TotalRegistrations

                    FROM tblRegistrationInfo A
                    LEFT JOIN refEVTypeInfo C ON A.EVID = C.EVID
                    GROUP BY
                        C.EVType
                    ORDER BY
                        C.EVType;

                END;
                GO


    */
        
        

    CREATE OR ALTER PROCEDURE dbo.SP_EVAdoptionSummary

                -- input params
                @modelYearParam    NVARCHAR(100) = NULL,
                @modelNameParam    NVARCHAR(50) = NULL, 
                @makeParam         NVARCHAR(50) = NULL,
                @evTypeParam       NVARCHAR(50) = NULL

                AS
                BEGIN
                    SET NOCOUNT ON;

                    ------------------------------------------------------------------
                    -- Result Set #1: Registrations by Model Year
                    ------------------------------------------------------------------
                    SELECT

                        B.ModelYear,
                        B.Make,
                        B.ModelName,
                        C.EVType,
                        COUNT(*) AS TotalRegistrations

                        FROM tblRegistrationInfo A
                        LEFT JOIN refVehicleInfo B ON A.VID = B.VID
                        LEFT JOIN refEVTypeInfo C ON A.EVID = C.EVID

                        WHERE (
                                    @modelYearParam IS NULL
                                    OR
                                    @modelYearParam = ''
                                    OR
                                    B.ModelYear IN (SELECT TRY_CAST(TRIM(value) AS INT)
                                    FROM STRING_SPLIT(@modelYearParam, ';')
                                    WHERE TRY_CAST(TRIM(value) AS INT) IS NOT NULL                        
                                )
                              )
                        AND (
                                    @modelNameParam IS NULL
                                    OR
                                    @modelNameParam = ''
                                    OR
                                    B.ModelName IN (SELECT TRIM(value)
                                    FROM STRING_SPLIT(@modelNameParam, ';')
                                    WHERE TRIM(value) <> '')
                                )
                        AND (
                                    @makeParam IS NULL
                                    OR
                                    @makeParam = ''
                                    OR
                                    B.Make IN (SELECT TRIM(value)
                                    FROM STRING_SPLIT(@makeParam, ';')
                                    WHERE TRIM(value) <> '')
                        )
                        AND (
                                    @evTypeParam IS NULL
                                    OR
                                    @evTypeParam = ''
                                    OR
                                    C.EVType IN (SELECT TRIM(value)
                                    FROM STRING_SPLIT(@evTypeParam, ';')
                                    WHERE TRIM(value) <> '')
                        )

                            GROUP BY
                                B.ModelYear, B.Make, B.ModelName, C.EVType
                            ORDER BY
                                B.ModelYear, B.Make, B.ModelName;

                END;
                GO

                -- ADDED SUCCESSFULLY

        --- BEGIN TESTING
        ---- WITH PARAMS
        
        EXEC SP_EVAdoptionSummary
            @modelNameParam = 'E-TRON;A3',
            @makeParam = 'AUDI';

        -- WITHOUT PARAMS
            EXEC SP_EVAdoptionSummary

        -- CONCLUSION: SUCCESS


