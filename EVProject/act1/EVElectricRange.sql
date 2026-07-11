

    -- BEGIN CREATION OF STORED PROC OF EV Electric Range


    CREATE OR ALTER PROCEDURE dbo.SP_EVAdoptionElectricRange

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

                        MS.ModelYear,
                        MS.Make,
                        MS.ModelName,
                        MS.EVType,
                        MS.MedianElectricRange

                    FROM(
                        SELECT
                        B.ModelYear,
                        B.Make,
                        B.ModelName,
                        C.EVType,
                        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY A.ElectricRange)
                            OVER(
                                PARTITION BY B.ModelYear, B.Make, B.ModelName, C.EVType
                            )
                            AS MedianElectricRange

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
                        AND
                            (A.ElectricRange IS NOT NULL AND A.ElectricRange > 0)
                    ) AS MS

                            GROUP BY
                                MS.ModelYear, MS.Make, MS.ModelName, MS.EVType, MS.MedianElectricRange
                            ORDER BY
                                MS.ModelYear, MS.Make, MS.ModelName ASC;

                END;
                GO

                -- ADDED SUCCESSFULLY

        --- BEGIN TESTING
        ---- WITH PARAMS
EXEC SP_EVAdoptionElectricRange

select * from tblRegistrationInfo