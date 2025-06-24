/*
===============================================================================
DDL Script: Create Bronze Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'bronze' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'bronze' Tables
===============================================================================
*/

USE CARDB
GO

IF OBJECT_ID('bronze.carprices', 'U') IS NOT NULL
    DROP TABLE bronze.carprices;
GO

CREATE TABLE bronze.carprices (
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
    saledate NVARCHAR(MAX)

);

go
