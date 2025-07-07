# Vehicle Sales Data Warehouse Project

## 📌 Project Overview
This project involves the design and implementation of a data warehouse using SQL Server Management Studio (SSMS), based on a comprehensive Vehicle Sales and Market Trends Dataset. The data warehouse facilitates efficient querying, reporting, and analytical processing of vehicle sales, pricing trends, and market behavior.

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

* Bronze Layer: Stores raw data as-is from the source systems. Data is ingested from CSV Files into SQL Server Database.
* Silver Layer: This layer includes data cleansing, standardization, and normalization processes to prepare data for analysis.
* Gold Layer: Contains business-ready data modeled into a star schema required for reporting and analytics and ML purposes.


### 🏗️ Schema Design: Star Schema for Car Pricing

Fact Table:

* gold.fact_car_sales

Dimensions:

* gold.dim_vehicle

* gold.dim_seller

* gold.dim_date

## ⚙️ ETL Process
1. Extract
Raw CSV data loaded using SSMS or SQL Server Integration Services (SSIS)

2. Transform
Data cleaning: deduplication, type casting, NULL handling

Dimension normalization: distinct values loaded into dimension tables

Surrogate key creation for dimensions

3. Load
Transformed data loaded into fact and dimension tables

Referential integrity enforced using foreign keys


