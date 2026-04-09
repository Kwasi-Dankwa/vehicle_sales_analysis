Welcome to your new dbt project!

### Using the starter project

Try running the following commands:
- dbt run
- dbt test

# 🚗 Vehicle Sales Data Warehouse (Snowflake + dbt)

This project is a modern revamp of my original SQL Server-based vehicle sales analysis pipeline. It implements a **cloud-native data warehouse** using **Snowflake** and **dbt (data build tool)**, structured with the **Medallion Architecture** (Bronze, Silver, Gold) to enable clean, scalable, and auditable analytics workflows.

---

## 📌 Project Purpose

The purpose of this data warehouse is to consolidate, organize, and optimize vehicle sales data from to support data-driven decision-making across sales, operations, and business strategy. It enables historical analysis, trend forecasting, **data-driven insights** and performance benchmarking related to vehicle sales, sellers, pricing, and market value (MMR) primarily especially for **Auto insurers** who may use vehicle condition, age, and sales data to improve claims valuation or adjust premiums based on real-world resale value trends

---

## 🧰 Tools & Technologies

| Tool          | Purpose |
|---------------|---------|
| **Snowflake** | Cloud data warehouse for scalable storage and compute |
| **dbt**       | Transformation layer — modeling, testing, and documentation |
| **Git/GitHub**| Version control and collaboration |
| **VS Code**   | Development environment |
| **[`Kaggle Dataset`](https://www.kaggle.com/datasets/syedanwarafridi/vehicle-sales-data)**| Source data containing detailed car sales records |

---

## 🗃️ Data Model (Star Schema)

The warehouse follows a **star schema** design:

### 📂 Fact Table:
- `fact_car_sales`: Core metrics such as selling price, price-to-MMR ratio, and foreign key references to dimensions.

### 📂 Dimension Tables:
- `dim_vehicle`: Unique vehicles by VIN
- `dim_seller`: Distinct seller profiles
- `dim_date`: Calendar date dimension for temporal analysis

### Diagram
![Relationship](snapshots/starschema.png "Relationship")

---

## 🏗️ Architecture

This project follows a simplified **Medallion-style architecture** adapted for dbt and Snowflake:

| Layer | Folder      | Description |
|-------|-------------|-------------|
| Silver | `models/staging/` | Cleans raw CSV data during load (fixes nulls, deduplicates VINs, formats sale dates) |
| Gold   | `models/gold/`    | Star schema for analytics (fact + dimension tables) |

---
### SIlver Layer

```
{{ config(materialized='view') }}

WITH base_data AS (
    SELECT
        yr,
        UPPER(TRIM(make)) AS make,
        UPPER(TRIM(model)) AS model,
        UPPER(TRIM(trm)) AS trm,
        UPPER(TRIM(body)) AS body,
        UPPER(TRIM(transmission)) AS transmission,
        vin,
        CASE
            WHEN LENGTH(ste) > 2 THEN NULL  
            ELSE UPPER(TRIM(ste))
        END AS ste,
        condition,
        odometer,
        CASE
            WHEN TRY_TO_NUMBER(color) IS NOT NULL THEN NULL
            ELSE UPPER(TRIM(color))
        END AS color,
        UPPER(TRIM(interior)) AS interior,
        UPPER(TRIM(seller)) AS seller,
        mmr,
        sellingprice,

        -- Extract just 'Dec 16 2014' from 'Tue Dec 16 2014 00:00:00 GMT+0000 (UTC)'
        TRY_TO_DATE(SUBSTR(saledate, 5, 11), 'MON DD YYYY') AS saledate_date

    FROM {{ source('cardb', 'car_sales') }}
    WHERE vin IS NOT NULL AND make IS NOT NULL
),

-- Retain only the most recent entry per VIN
deduped_data AS (
    SELECT *
    FROM (
        SELECT *,
            ROW_NUMBER() OVER (PARTITION BY vin ORDER BY saledate_date DESC) AS row_num
        FROM base_data
    )
    WHERE row_num = 1
)

SELECT
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

    -- Final cleaned saledate as a DATE type
    saledate_date AS saledate

FROM deduped_data
```

>This stg_car_sales.sql model performs critical data cleaning and transformation to prepare raw vehicle sales data for analytics. It standardizes text fields (e.g., make, model, transmission), removes invalid or duplicate records based on VIN, and extracts a clean saledate as a proper DATE type. By filtering out nulls and deduplicating based on the latest sale per vehicle, this staging model ensures consistent, high-quality input for downstream dimensional modeling — forming the foundation of a business-ready data pipeline in the gold layer.

### Diagram
![Diagram](snapshots/architectureflow.png "Arhitecture")

> dbt pipeline started at the Silver layer

---

## ⚙️ ELT Workflow with dbt

- `car_prices.csv`: Raw data loaded into Snowflake table (Bronze)
- `stg_car_sales.sql`: Silver stage
- `dim_vehicle`, `dim_seller`, `dim_date`, `fact_car_sales`: Gold-layer models

All transformations are **declarative** and **version-controlled** using dbt, with automated tests (e.g. not-null, uniqueness) and dependency tracking via `ref()`.

## 📂 Folder Structure
``` Vehicle_Analysis_wh/
├── models/
│ ├── staging/
│ │ ├── sources.yml # Source definition for raw car sales CSV
│ │ └── stg_car_sales.sql # Raw cleaned-up staging model
│ └── gold/
│ ├── dim_date.sql # Date dimension
│ ├── dim_seller.sql # Seller dimension
│ ├── dim_vehicles.sql # Vehicle dimension
│ └── fact_car_sales.sql # Fact table with price, MMR metrics
├── macros/ # Custom Jinja macros (if needed)
├── analyses/ # Optional ad hoc analysis queries
├── dbt_project.yml # Main dbt project config
```
> This project uses dbt’s recommended directory structure for model organization

---

## 📈 Future Enhancements

- Add dbt docs and data lineage diagrams
- Integrate Snowflake’s native tasks & streams for incremental loading
- Build Tableau or Streamlit dashboard for real-time insights
- Schedule automated runs via dbt Cloud or Airflow

---

## 🚀 How to Run This Project Locally
---
### 🧱 Prerequisites

- Python 3.7+
- dbt (Snowflake adapter):  
  Install with pip  
  ```bash
  pip install dbt-snowflake
---
### Clone repo
```
git clone https://github.com/Kwasi-Dankwa/vehicle_sales_analysis.git
cd vehicle_sales_analysis
git checkout snowflake-dbt
```
- Set up profiles.yml
Example
```
vehicle_analysis_wh:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: <your_account>  # e.g., ab12345.us-east-1
      user: <your_user>
      password: <your_password>
      role: <your_role>        # e.g., ACCOUNTADMIN
      warehouse: <your_warehouse>
      database: <your_database>
      schema: <your_schema>

```
---
### Run Project
```
dbt debug         # Test connection
dbt deps          # Install dependencies (if any)
dbt seed          # Optional: if you're using CSV seeds
dbt run           # Build all models
dbt test          # Run data quality tests
```
---

### Generate and View docs
```
dbt docs generate
dbt docs serve
```








### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](https://community.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
