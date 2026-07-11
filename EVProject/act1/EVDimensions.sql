


-- BEGIN CREATION OF STORED PROC TO RETRIEVE ALL DIMENSIONAL ATTRIBUTES

CREATE OR ALTER PROCEDURE SP_EVDimensions

    AS
    BEGIN

        SET NOCOUNT ON;

        SELECT 
            VID AS ID,
            Make AS Value,
            ModelYear AS Value2,
            ModelName AS Value3,
            'refVehicleInfo' AS Source

            FROM refVehicleinfo

            UNION ALL

        SELECT
            EVID AS ID,
            EVType AS Value,
            NULL AS Value2,
            NULL AS Value3,
            'refEVTypeInfo' AS Source

            FROM refEVTypeInfo

            UNION ALL

        SELECT 
            CAFVID AS ID,
            CAFVEligibility AS Value,
            NULL AS Value2,
            NULL AS Value3,
            'refCAFVInfo' AS Source

            FROM refCAFVInfo

            UNION ALL
        
        SELECT
            UtilityID AS ID,
            ElectricUtility AS Value,
            NULL AS Value2,
            NULL AS Value3,
            'refUtilityInfo' AS Source

            FROM refUtilityInfo
            WHERE ElectricUtility <> 'Unknown'

    END;
    GO


    -- SUCCESSFULLY ADDED
    -- RUNNING UNIT TESTING



