Welcome to your new dbt project!

### Using the starter project

Try running the following commands:
- dbt run
- dbt test

# 🚗 Vehicle Sales Data Warehouse (Snowflake + dbt)

This project is a modern revamp of my original SQL Server-based vehicle sales analysis pipeline. It implements a **cloud-native data warehouse** using **Snowflake** and **dbt (data build tool)**, structured with the **Medallion Architecture** (Bronze, Silver, Gold) to enable clean, scalable, and auditable analytics workflows.

---

## 📌 Project Purpose

The goal is to support **data-driven insights** into vehicle sales trends, seller performance, and market value benchmarking — especially for use cases like **auto insurers** adjusting premiums based on real-world resale trends.

---

## 🧰 Tools & Technologies

| Tool          | Purpose |
|---------------|---------|
| **Snowflake** | Cloud data warehouse for scalable storage and compute |
| **dbt**       | Transformation layer — modeling, testing, and documentation |
| **Git/GitHub**| Version control and collaboration |
| **VS Code**   | Development environment |
| **Kaggle Dataset** | Source data containing detailed car sales records |

---

## 🗃️ Data Model (Star Schema)

The warehouse follows a **star schema** design:

### 📂 Fact Table:
- `fact_car_sales`: Core metrics such as selling price, price-to-MMR ratio, and foreign key references to dimensions.

### 📂 Dimension Tables:
- `dim_vehicle`: Unique vehicles by VIN
- `dim_seller`: Distinct seller profiles
- `dim_date`: Calendar date dimension for temporal analysis

---

## 🏗 Architecture: Medallion Layers

| Layer  | Description |
|--------|-------------|
| **Bronze** | Raw ingested CSV data `car_prices.csv` |
| **Silver** | Cleaned & normalized data (deduplicated VINs, valid sale dates) |
| **Gold** | Business-ready tables with surrogate keys, calculated fields, and star schema modeling |

---

## ⚙️ ETL Workflow with dbt

- `stg_car_prices`: Raw staging model (Bronze)
- `clean_car_prices`: Cleansed Silver model
- `dim_vehicle`, `dim_seller`, `dim_date`, `fact_car_sales`: Gold-layer models

All transformations are **declarative** and **version-controlled** using dbt, with automated tests (e.g. not-null, uniqueness) and dependency tracking via `ref()`.

---

## 📈 Future Enhancements

- Add dbt docs and data lineage diagrams
- Integrate Snowflake’s native tasks & streams for incremental loading
- Build Tableau or Streamlit dashboard for real-time insights
- Schedule automated runs via dbt Cloud or Airflow

---

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




### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](https://community.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
