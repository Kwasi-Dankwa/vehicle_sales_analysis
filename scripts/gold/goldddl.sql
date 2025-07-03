/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse. 
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Silver layer 
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
*/ -- Star Schema
-- Fact Table: gold.fact_car_sales

-- Dimensions: gold.dim_vehicle, gold.dim_seller, gold.dim_date

-- =============================================================================

-- =============================================================================
USE CARDB
go

-- This dimension describes a unique vehicle (by VIN). Includes make, model, trim, etc.
IF OBJECT_ID('gold.dim_vehicle', 'V') IS NOT NULL
    DROP VIEW gold.dim_vehicle;
GO

CREATE VIEW gold.dim_vehicle AS
SELECT
    ROW_NUMBER() OVER (ORDER BY vin) AS vehicle_key,
    vin,
    yr        AS year,
    make,
    model,
    trm       AS trim,
    body,
    transmission,
    color,
    interior,
    condition,
    odometer
FROM (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY vin ORDER BY saledate DESC) AS rn
    FROM silver.carprices
) latest
WHERE rn = 1;
GO


-- This groups sellers to a surrogate key. One row per unique seller name.
IF OBJECT_ID('gold.dim_seller', 'V') IS NOT NULL
    DROP VIEW gold.dim_seller;
GO

CREATE VIEW gold.dim_seller AS
SELECT
    ROW_NUMBER() OVER (ORDER BY seller) AS seller_key,
    seller
FROM (
    SELECT DISTINCT seller
    FROM silver.carprices
    WHERE seller IS NOT NULL
) sellers;
GO

-- A standard calendar dimension for time-series analytics
IF OBJECT_ID('gold.dim_date', 'V') IS NOT NULL
    DROP VIEW gold.dim_date;
GO

CREATE VIEW gold.dim_date AS
SELECT
    ROW_NUMBER() OVER (ORDER BY saledate) AS date_key,
    saledate,
    YEAR(saledate) AS year,
    MONTH(saledate) AS month,
    DAY(saledate) AS day,
    DATENAME(month, saledate) AS month_name,
    DATEPART(quarter, saledate) AS quarter
FROM (
    SELECT DISTINCT saledate
    FROM silver.carprices
    WHERE saledate IS NOT NULL
) dates;
GO

-- This fact table links to the three dimensions and includes price metrics
IF OBJECT_ID('gold.fact_car_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_car_sales;
GO

CREATE VIEW gold.fact_car_sales AS
SELECT
    v.vehicle_key,
    s.seller_key,
    d.date_key,
    --kpis
    cp.sellingprice,
    cp.mmr,
    cp.sellingprice - cp.mmr AS price_diff_from_mmr,
    CASE 
        WHEN cp.mmr = 0 THEN NULL 
        ELSE cp.sellingprice / cp.mmr 
    END AS price_to_mmr_ratio,
    
    cp.ste AS sale_state
FROM (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY vin ORDER BY saledate DESC) AS rn
    FROM silver.carprices
) cp
JOIN gold.dim_vehicle v ON cp.vin = v.vin
JOIN gold.dim_seller s ON cp.seller = s.seller
JOIN gold.dim_date d ON cp.saledate = d.saledate
WHERE cp.rn = 1;
GO
