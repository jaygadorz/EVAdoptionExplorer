

-- create the DATABASE FOR EV PROJECT

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'EVProjectDB')
BEGIN
    CREATE DATABASE EVProjectDB;
END
GO

-- SUCCESSFULLY ADDED

USE EVProjectDB




    USE EVProjectDB

    SELECT * FROM refDistrictInfo