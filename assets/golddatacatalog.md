# Data Catalog for Gold Layer

## Overview
The Gold Layer is the business-level data representation, structured to support analytical and reporting use cases. It consists of **dimension tables** and **fact tables** for specific business metrics.

---

### 1. **gold.dim_vehicles**
- **Purpose:** Stores cars by their unique vehicle number (VIN). Includes makes, model, trim
- **Columns:**

| Column Name      | Data Type     | Description                                                                                   |
|------------------|---------------|-----------------------------------------------------------------------------------------------|
| vehicle_key      | BIGINT        | Surrogate key uniquely identifying each car record in the dimension table.               |
| vin              | NVARCHAR(50)  | Unique numerical identifier assigned to each car.                                        |
| year  | INT  | Year car was produced        |
| make       | NVARCHAR(50)  | car brand or manufacturer                                      |
| model        | NVARCHAR(100)  | the specific model                                                    |
| trim        | NVARCHAR(100)  | additional designation                             |
| body  | NVARCHAR(80)  | body type(sedan, suv, etc)                              |
| transmission     | NVARCHAR(20)  | the type of transmission in the vehicle                                 |
| color      | NVARCHAR(100)         | the vehicle color               |
| interior     | NVARCHAR(100)          | interior color of the vehicle |
| condition     | INT            | condition of vehicle rated from 1 to 49|
| odometer     | INT         | The mileage or distance traveled by vehicle|
---

### 2. **gold.dim_seller**
- **Purpose:** groups sellers to a surrogate key. one row per unique seller name
- **Columns:**

| Column Name         | Data Type     | Description                                                                                   |
|---------------------|---------------|-----------------------------------------------------------------------------------------------|
| seller_key         | BIGINT           | Surrogate key uniquely identifying each seller in the seller dimension table.         |
| seller        | NVARCHAR(200)          | The seller            |


---

### 3. **gold.dim_date**
- **Purpose:** Stores the date of sales. Use for time series-analytics
- **Columns:**

| Column Name      | Data Type     | Description                                                                                   |
|------------------|---------------|-----------------------------------------------------------------------------------------------|
| date_key      | BIGINT        | Surrogate key uniquely identifying each date a car was sold               |
| sale_date              | DATE  | the date a car was sold                                        |
| year  | INT  | Year of the sale       |
| month       | INT  | month the car was sold                                    |
| day       | INT | the day of the sale                                                    |
| month_name       | NVARCHAR(30)  | the month name                        |
| quarter | int | the quarter in which the sale was made                          |




### 3. **gold.fact_car_sales**
- **Purpose:** links the 3 dimensions and includes kpis(car metrics)
- **Columns:**

| Column Name     | Data Type     | Description                                                                                   |
|-----------------|---------------|-----------------------------------------------------------------------------------------------|
| vehicle_key      | BIGINT        | Surrogate key uniquely identifying each car record in the dimension table.               |
| seller_key         | BIGINT           | Surrogate key uniquely identifying each seller in the seller dimension table.         |
| date_key      | BIGINT        | Surrogate key uniquely identifying each date a car was sold               |
| sellingprice      | INT          | The price at which a car was sold                                                          |
| mmr  | INT          | Manheim Market Report which indicates the estimated market value of the vehicle                                        |
| price_diff_from_mmr       | INT         |       the difference between mmr and selling price                                               |
| price_to_mmr_ratio    | INT           | The price to mmr ratio   |
| sale_state       | NVARCHAR(100)          |           The state in which the car was sold            |
