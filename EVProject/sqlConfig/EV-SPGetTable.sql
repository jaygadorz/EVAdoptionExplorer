

-- Create stored proc to retrieve all rows from a specified table
CREATE OR ALTER PROCEDURE dbo.SPGetTableData
(
    @SchemaName SYSNAME = 'dbo',
    @TableName  SYSNAME
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ObjectId INT;
    DECLARE @SQL NVARCHAR(MAX);
    DECLARE @ErrorMessage NVARCHAR(4000);

    -- Validate table exists
    SELECT @ObjectId = t.object_id
    FROM sys.tables t
    INNER JOIN sys.schemas s
        ON t.schema_id = s.schema_id
    WHERE s.name = @SchemaName
      AND t.name = @TableName;

    IF @ObjectId IS NULL
    BEGIN
        SET @ErrorMessage =
            'Table not found: '
            + QUOTENAME(@SchemaName)
            + '.'
            + QUOTENAME(@TableName);

        THROW 50001, @ErrorMessage, 1;
    END;

    -- Build dynamic SQL safely
    SET @SQL =
        N'SELECT * FROM '
        + QUOTENAME(@SchemaName)
        + N'.'
        + QUOTENAME(@TableName);

    EXEC sys.sp_executesql @SQL;
END;
GO

-- successfully added 

-- unit testing begin

USE jgdigitalDB;

EXEC dbo.SPGetTableData @SchemaName = 'dbo', @TableName = 'refVehicleInfo';