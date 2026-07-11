

-- here we create the stored procedure to view EV registrations by geography.
--- it covers where EV Adoption is the strongest.
--- the audience are then able to view by counties, by region etc.

-- BEGIN CODE

CREATE OR ALTER PROCEDURE dbo.SP_EVAdoptionGeography

    @cityParam      NVARCHAR(50) = NULL,
    @stateParam     NVARCHAR(50) = NULL,
    @countyParam    NVARCHAR(50) = NULL

    AS
    BEGIN

    SET NOCOUNT ON;

        -- RESULT AFTER INPUT PARAMETER HAS BEEN FULFILLED
    ;WITH GROUPED AS (
                    

                SELECT
                    
                    B.State,
                    B.County,
                    
                    COUNT(*) AS TotalRegistrations
                    
                    
                    FROM tblRegistrationInfo A
                    LEFT JOIN refGeographyInfo B ON A.LocationID = B.LocationID
                    LEFT JOIN refEVTypeInfo C ON A.EVID = C.EVID
                    LEFT JOIN refVehicleinfo D ON A.VID = D.VID


                    WHERE (
                        
                        -- covers string split for multi selection and null handling values

                            @cityParam IS NULL
                            OR
                            @cityParam = ''
                            OR
                            B.City IN (SELECT TRIM(value)
                                FROM STRING_SPLIT(@cityParam, ';')
                                WHERE TRIM(value) <> '') 
                            )

                    AND
                        (
                        
                        -- covers string split for multi selection and null handling values

                            @stateParam IS NULL
                            OR
                            @stateParam = ''
                            OR
                            B.State IN (SELECT TRIM(value)
                                FROM STRING_SPLIT(@stateParam, ';')
                                WHERE TRIM(value) <> '') 
                            )
                    AND
                        (
                        
                        -- covers string split for multi selection and null handling values

                            @countyParam IS NULL
                            OR
                            @countyParam = ''
                            OR
                            B.County IN (SELECT TRIM(value)
                                FROM STRING_SPLIT(@countyParam, ';')
                                WHERE TRIM(value) <> '') 
                            )

                            GROUP BY 
                                B.State, B.County, B.City,
                    )

                    SELECT
                        State,
                        County,

                        TotalRegistrations,

                        AVG(TotalRegistrations) 
                            OVER (
                            PARTITION BY State, County
                        ) 
                        AS AvgRegistrationsByCounty,

                        CASE WHEN
                           TotalRegistrations > AVG(TotalRegistrations) OVER (PARTITION BY State, County)
                           THEN
                           '▲ Above'
                           ELSE
                           'Below'
                        END AS
                            ComparisonToState

                    FROM GROUPED
                    ORDER BY State, County;

                    END;

                    GO


-- ADDED SUCCESSFULLY

-- BEGIN TESTING

    EXEC SP_EVAdoptionGeography

