

    /* view the table structure */
    USE EVProjectDB
        
        SELECT *
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_NAME = 'tblRegistrationInfo';


    -- added

    -- view table meta data

            SELECT * FROM tblRegistrationInfo;
            SELECT * FROM refCAFVInfo;
            SELECT * FROM refDistrictInfo;
            SELECT * FROM refEVTypeInfo;
            SELECT * FROM refGeographyInfo;
            SELECT * FROM refUtilityInfo;
            SELECT * FROM refVehicleInfo;


-- View stage tables


-- ev type
-- refCAFVInfo
-- location done
-- utility


EXEC SP_HELP refUtilityInfo;

ALTER TABLE refUtilityInfo
DROP COLUMN ElectricUtility


ALTER TABLE refUtilityInfo
ADD ElectricUtility NVARCHAR(255) NULL;

SELECT * FROM refUtilityInfo;

-- create the raw landing table BRONZE Layer

CREATE TABLE RawRegistrationEV
(
    INITIALid int IDENTITY(1,1) NOT NULL,
    rawID NVARCHAR(200) NULL,
    VINPrefix VARCHAR(50) NULL,
    County VARCHAR(50) NULL,
    City VARCHAR(50) NULL,
    State VARCHAR(50) NULL,
    PostalCode VARCHAR(50) NULL,
    ModelYear INT NULL,
    Make VARCHAR(50) NULL,
    Model VARCHAR(50) NULL,
    EVType VARCHAR(100) NULL,
    CAFVEligibility VARCHAR(100) NULL,
    ElectricRange FLOAT NULL,
    LegislativeDistrict INT NULL,
    DOLVehicleID VARCHAR(100) NULL,
    VehicleLocation VARCHAR(100) NULL,
    ElectricUtility NVARCHAR(255) NULL,
    CensusTract VARCHAR(250) NULL,
    Counties INT NULL,
    CongressionalDistricts INT NULL,
    CreatedDate DATETIME NULL,
    PRIMARY KEY (INITIALid)
)



-- view result
SELECT * FROM RawRegistrationEV



SELECT * FROM 