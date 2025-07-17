# Vehicle Sales Data Warehouse Project

## 📌 Project Overview
This project involves the design and implementation of a data warehouse using SQL Server Management Studio (SSMS), based on a comprehensive Vehicle Sales and Market Trends Dataset. The purpose of this data warehouse is to consolidate, organize, and optimize vehicle sales data from to support data-driven decision-making across sales, operations, and business strategy. It enables historical analysis, trend forecasting, and performance benchmarking related to vehicle sales, sellers, pricing, and market value (MMR) primarily especially for Auto insurers who may use vehicle condition, age, and sales data to improve claims valuation or adjust premiums based on real-world resale value trends.

## 🗃️ Dataset Description
The source [`dataset`](https://www.kaggle.com/datasets/syedanwarafridi/vehicle-sales-data) includes detailed vehicle sales transactions with the following fields:

Vehicle Attributes: Year, Make, Model, Trim, Body Type, Transmission, Exterior/Interior Color, VIN

Sales Data: Sale Date, Selling Price, Seller Information, State of Sale

Condition & Usage: Odometer Reading, Condition Rating

Market Value: Manheim Market Report (MMR) Values

## 🧱 Data Warehouse Architecture

### Medallion Architecture

The data architecture for this project follows Medallion Architecture Bronze, Silver, and Gold layers:

![Architecture](assets/architecturediagram.png "Architecture")

* Bronze Layer (has stored procedure): Stores raw data as-is from the source systems. Data is ingested from CSV Files into SQL Server Database.
* Silver Layer (has stored procedure): This layer includes data cleansing, standardization, and normalization processes to prepare data for analysis.
* Gold Layer: Contains business-ready data modeled into a star schema required for reporting and analytics and ML purposes.


### 🏗️ Schema Design: Star Schema for Car Pricing

Fact Table:

* gold.fact_car_sales

Dimensions:

* gold.dim_vehicle

* gold.dim_seller

* gold.dim_date

#### Relationship

![Relationship](assets/starschema.png "Relationship")

## 🧰 Technologies Used
* SQL (Microsoft SQL Server)
* Storage & compute (local, cloud, etc.)


## ⚙️ ETL Process
The ETL (Extract, Transform, Load) process is responsible for ingesting raw vehicle sales data from kaggle, transforming it into a clean, consistent format, and loading it into the star schema of the data warehouse. This process ensures the data is reliable, timely, and optimized for analysis.

1. Extract
Raw CSV data loaded from local storage using SSMS.

```sql
CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
    BEGIN TRY
        SET @batch_start_time = GETDATE();
        PRINT '================================================';
        PRINT 'Loading Bronze Layer';
        PRINT '================================================';

        PRINT '------------------------------------------------';
        PRINT 'Loading CRM Tables';
        PRINT '------------------------------------------------';

        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.carprices';
        TRUNCATE TABLE bronze.carprices;
        PRINT '>> Inserting Data Into: bronze.carprices';

        BULK INSERT bronze.carprices
        FROM 'C:\Users\kdank\Downloads\car_prices.csv\car_prices.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        -- Additional logging or SET @end_time = GETDATE(); can go here

    END TRY
    BEGIN CATCH
        PRINT '❌ Error loading bronze layer.';
        -- Error handling logic can be added here
    END CATCH
END;
```

> This stored procedure, bronze.load_bronze, loads raw car pricing data into the bronze.carprices table as part of the ETL pipeline. It begins by logging the start time, truncating the existing data in the target table, and then performing a BULK INSERT from a local CSV file. The process includes basic logging for traceability and is wrapped in a TRY-CATCH block to handle errors.

2. Transform
Raw data undergoes several transformation steps before being loaded into the gold schema to create dimensional and fact tables:

```
--load--
INSERT INTO silver.carprices(
    yr,
    make,
    model,
    trm,
    body,
    transmission,
    vin,
    ste,
    condition,
    odometer,
    color,
    interior,
    seller,
    mmr,
    sellingprice,
    saledate            -- This will receive the original nvarchar(max) saledate from bronze
)

SELECT
    yr,
    UPPER(TRIM(make)) as make,
    UPPER(TRIM(model)) as model,
    UPPER(TRIM(trm)) as trm,
    UPPER(TRIM(body)) as body,
    UPPER(TRIM(transmission)) as transmission,
    vin,
    CASE
        WHEN LEN(ste) > 2 THEN NULL  
        ELSE UPPER(ste)             
    END AS ste,
    condition,
    odometer,
    CASE
        WHEN TRY_CAST(color AS INT) IS NOT NULL THEN NULL
        ELSE color
    END AS color,
    UPPER(TRIM(interior)) as interior,
    UPPER(TRIM(seller)) as seller,
    mmr,
    sellingprice,
    CASE
        WHEN saledate IS NOT NULL AND CHARINDEX(' GMT', saledate) > 4 THEN
            TRY_CONVERT(DATE, SUBSTRING(saledate, 5, CHARINDEX(' GMT', saledate) - 5))
        ELSE
            NULL
    END AS saledate -- Calculates the Formated SaleDate from the bronze saledate
FROM
    bronze.carprices;
```

> Transformations (Silver Layer)
Data Cleaning.	Remove duplicates VINs, null VINs, and invalid sale dates. This was done since VIN was the primary key. Additionally duplicate VIN values were filtered by keeping the most recent sale date. Additionally, Values in certain columns  were Standardized and Normalized through capitalization (e.g., vehicle color, transmission type)


The Gold Layer 🟡 represents the final and business-ready schema in the data warehouse, modeled using a star schema. This [`script`](https://github.com/Kwasi-Dankwa/vehicle_sales_analysis/blob/main/scripts/gold/goldddl.sql) creates four SQL views—three dimension views (dim_vehicle, dim_seller, dim_date) and one fact view (fact_car_sales)—by transforming and cleaning data from the Silver Layer.

* dim_vehicle: Deduplicates vehicles by VIN and keeps only the latest record per vehicle.

* dim_seller: Assigns a unique key to each distinct seller.

* dim_date: Generates a date dimension from unique sale dates for time-based analysis.

* fact_car_sales: Links all three dimensions and calculates key metrics such as price difference from MMR and price-to-MMR ratio.

These views serve as the final output layer, optimized for analytics, reporting, and dashboarding.

> Surrogate Key Assignment,	Assign vehicle_key, seller_key, and date_key for consistency,
Calculated Metrics (for Gold Layer) are created to store price_diff_from_mmr and price_to_mmr_ratio,
Date Enrichment (Gold Layer) to	Derive year, month, day, and quarter from sale date,
Data Type Conversion is also carried to Convert fields into appropriate SQL data types for loading

Business rules were applied to ensure consistency across vehicle records and to handle outliers (e.g., negative odometer readings or extreme price values).

3. Load
Transformed data loaded into fact and dimension tables.
> Script: [`script`](https://github.com/Kwasi-Dankwa/vehicle_sales_analysis/blob/main/scripts/gold/goldddl.sql)
Referential integrity enforced using foreign keys.

## 🚀 Future Improvements
* Automate ETL using additional tools such as snowflake and dbt
* Adding more dimensions (e.g., buyers, location)
* Conducting Advanced Analytics and Setting up dashboarding
* Incorporate real-time data


