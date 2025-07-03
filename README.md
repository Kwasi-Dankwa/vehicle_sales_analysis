# Vehicle Sales Data Warehouse Project

## 📌 Project Overview
This project involves the design and implementation of a data warehouse using SQL Server Management Studio (SSMS), based on a comprehensive Vehicle Sales and Market Trends Dataset. The data warehouse facilitates efficient querying, reporting, and analytical processing of vehicle sales, pricing trends, and market behavior.

## 🗃️ Dataset Description
The source [`dataset`] (https://www.kaggle.com/datasets/syedanwarafridi/vehicle-sales-data) includes detailed vehicle sales transactions with the following fields:

Vehicle Attributes: Year, Make, Model, Trim, Body Type, Transmission, Exterior/Interior Color, VIN

Sales Data: Sale Date, Selling Price, Seller Information, State of Sale

Condition & Usage: Odometer Reading, Condition Rating

Market Value: Manheim Market Report (MMR) Values

## 🧱 Data Warehouse Architecture
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


