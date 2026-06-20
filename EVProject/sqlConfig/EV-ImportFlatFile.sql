

-- connecting string here
-- sp=r&st=2026-05-25T02:53:58Z&se=2026-06-05T11:08:58Z&spr=https&sv=2026-02-06&sr=c&sig=XzRIcf9l6A%2FZNs1W%2B1noPDp6YjxMu8GTCzY20zMTVCA%3D

-- SETUP DATABASE CREDENTIAL FROM AZURE SQL


USE jgdigitalDB

CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Motorpool091996@!';

-- create db scoped

CREATE DATABASE SCOPED CREDENTIAL MyBlobCredential
WITH IDENTITY = 'SHARED ACCESS SIGNATURE',
SECRET = 'sp=r&st=2026-05-25T02:53:58Z&se=2026-06-05T11:08:58Z&spr=https&sv=2026-02-06&sr=c&sig=XzRIcf9l6A%2FZNs1W%2B1noPDp6YjxMu8GTCzY20zMTVCA%3D';


-- create the external data source

CREATE EXTERNAL DATA SOURCE jgdigitalazurestorage
WITH (
    TYPE = BLOB_STORAGE,
    LOCATION = 'https://jgdigitalazurestaorage.blob.core.windows.net/jgdigitalazurecontainer',
    CREDENTIAL = MyBlobCredential
);


-- success

-- step 1 bulk insert refvehicle info

    -- Example for one dimension file
    BULK INSERT dbo.refVehicleInfo
    FROM 'refVehicleInfo.csv'
    WITH (
        DATA_SOURCE = 'jgdigitalazurestorage',
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n',
        FIRSTROW = 2
    );


    -- success
    -- view table


        -- create staging

        CREATE TABLE dbo.refVehicleInfo_staging (
                Make NVARCHAR(50),
                Model NVARCHAR(50),
                ModelYear INT,
                VehicleID INT
            );


                BULK INSERT dbo.refVehicleInfo_staging
                FROM 'refVehicleInfo.csv'
                WITH (
                    DATA_SOURCE = 'jgdigitalazurestorage',
                    FIELDTERMINATOR = ',',
                    ROWTERMINATOR = '\n',
                    FIRSTROW = 2
                );


SELECT * FROM dbo.refVehicleInfo_staging;


-- bulk insert

BULK INSERT dbo.refVehicleInfo_staging
FROM 'refVehicleInfo.csv'
WITH (
    DATA_SOURCE = 'jgdigitalazurestorage',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\r\n',
    FIRSTROW = 2
);


-- Unix style
BULK INSERT dbo.refVehicleInfo_staging
FROM 'refVehicleInfo.csv'
WITH (
    DATA_SOURCE = 'jgdigitalazurestorage',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

-- Windows style
BULK INSERT dbo.refVehicleInfo_staging
FROM 'refVehicleInfo.csv'
WITH (
    DATA_SOURCE = 'jgdigitalazurestorage',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\r\n',
    FIRSTROW = 2
);


SELECT *
FROM OPENROWSET(
    BULK 'refVehicleInfo.csv',
    DATA_SOURCE = 'jgdigitalazurestorage',
    FORMAT = 'CSV',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
) AS rows2;
