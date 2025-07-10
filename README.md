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


## ⚙️ ETL Process
The ETL (Extract, Transform, Load) process is responsible for ingesting raw vehicle sales data from kaggle, transforming it into a clean, consistent format, and loading it into the star schema of the data warehouse. This process ensures the data is reliable, timely, and optimized for analysis.

1. Extract
Raw CSV data loaded using SSMS.

2. Transform
Raw data undergoes several transformation steps before being loaded into dimensional tables:

## Transformations (Silver Layer)
Data Cleaning	Remove duplicates VINs, null VINs, and invalid sale dates. This was done since VIN was the primary key.

Standardization	Normalize fields through capitalization (e.g., vehicle color, transmission type)
Surrogate Key Assignment	Assign vehicle_key, seller_key, and date_key for consistency
Calculated Metrics (for Gold Layer)	Compute price_diff_from_mmr and price_to_mmr_ratio
Date Enrichment (Gold Layer)	Derive year, month, day, and quarter from sale date
Data Type Conversion	Convert fields into appropriate SQL data types for loading

Business rules were applied to ensure consistency across vehicle records and to handle outliers (e.g., negative odometer readings or extreme price values).

3. Load
Transformed data loaded into fact and dimension tables
Referential integrity enforced using foreign keys.


