


/* this query holds the bulk insert operations from raw registrations into the fact table */

-- preview RAW data first
SELECT * FROM RawRegistrationEV

-- preview target table
SELECT * FROM tblRegistrationInfo

EXEC SP_HELP RawRegistrationEV


EXEC SP_HELP tblRegistrationInfo

-- PREVIEW NA LOOKUPS

--- begin insert stored proc

CREATE PROCEDURE SPLoadFactRegistration

AS
BEGIN

    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY

        BEGIN TRANSACTION;

        INSERT INTO tblRegistrationInfo
        (
            VINPrefix,
            DOLVehicleID,
            VehicleLocation,
            ElectricRange,
            CreatedAt,
            UpdatedAt,
            LocationID,
            VID,
            UtilityID,
            DistrictID,
            EVID,
            CAFVID
        )
        SELECT
            r.VINPrefix,
            r.DOLVehicleID,
            r.VehicleLocation,
            r.ElectricRange,
            r.CreatedDate,
            GETDATE(),

            g.LocationID,
            v.VID,
            u.UtilityID,
            d.DistrictID,
            e.EVID,
            c.CAFVID

        FROM RawRegistrationEV r

        INNER JOIN refGeographyInfo g
            ON  r.City = g.City
            AND r.State = g.State
            AND r.PostalCode = g.PostalCode
            AND r.County = g.County
            AND r.CensusTract = g.CensusTract

        INNER JOIN refVehicleInfo v
            ON  r.Make = v.Make
            AND r.Model = v.ModelName
            AND r.ModelYear = v.ModelYear

        INNER JOIN refUtilityInfo u
            ON r.ElectricUtility = u.ElectricUtility

        INNER JOIN refDistrictInfo d
            ON  r.LegislativeDistrict = d.LegislativeDistricts
            AND r.CongressionalDistricts = d.CongressionalDistricts

        INNER JOIN refEVTypeInfo e
            ON r.EVType = e.EVType

        INNER JOIN refCAFVInfo c
            ON r.CAFVEligibility = c.CAFVEligibility;

        COMMIT TRANSACTION;

    END TRY

    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;

    END CATCH

END;


-- ADDED SUCCESSFULLY

USE jgdigitalDB GO;
EXEC SPLoadFactRegistration



EXEC SP_HELP tblRegistrationInfo


-- RE CONFIGURE COLUMN REGISTRATIONID


-- 1. DROP CONSTRAINTS
ALTER TABLE tblRegistrationInfo
DROP CONSTRAINT PK__tblRegis__6EF58830699947CE;


-- 2. DROP COLUMN AND RESET

ALTER TABLE tblRegistrationInfo
DROP COLUMN RegistrationID

-- 3. ADD COLUMN AND IDENTITY
ALTER TABLE tblRegistrationInfo
ADD RegistrationID INT IDENTITY(1,1) PRIMARY KEY


-- 4. add primary key registrationID
ALTER TABLE tblRegistrationInfo
ADD CONSTRAINT PK__tblRegis__RegistrationID
PRIMARY KEY (RegistrationID);


-- 5. EXEC stored procedure to load raw data from raw staging to tblRegistationInfo final

EXEC SPLoadFactRegistration;

--- 6. PREVIEW TABLE

SELECT * FROM tblRegistrationInfo

EXEC SP_HELP tblRegistrationInfo


SELECT * FROM refVehicleInfo