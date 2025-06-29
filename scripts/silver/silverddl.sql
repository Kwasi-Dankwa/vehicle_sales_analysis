USE CARDB
Go

-- Silver DDL --
IF OBJECT_ID('silver.carprices', 'U') IS NOT NULL
    DROP TABLE silver.carprices;
GO

CREATE TABLE silver.carprices (
    yr INT,
    make NVARCHAR(50),
    model NVARCHAR(100),
    trm NVARCHAR(100),
    body NVARCHAR(80),
    transmission NVARCHAR(20),
    vin NVARCHAR(200),
    ste NVARCHAR(100),
    condition INT,
    odometer INT,
    color NVARCHAR(100),
    interior NVARCHAR(100),
    seller NVARCHAR(200),
    mmr INT,
    sellingprice INT,
    saledate DATE

);
