{{ config(materialized='table', unique_key='date_key') }}

WITH raw_dates AS (
    SELECT DISTINCT
        saledate
    FROM {{ ref('stg_car_sales') }}
    WHERE saledate IS NOT NULL
),

-- Extract date components and create a surrogate key
final AS (
    SELECT
        -- Generate a date key (e.g., YYYYMMDD)
        CAST(REPLACE(CAST(saledate AS DATE), '-', '') AS BIGINT) AS date_key,
        saledate AS sale_date,
        YEAR(saledate) AS year,
        MONTH(saledate) AS month,
        DAY(saledate) AS day,
        MONTHNAME(saledate) AS month_name,
        QUARTER(saledate) AS quarter
        -- Add more date attributes as needed (e.g., day_of_week, week_of_year, is_weekend)
    FROM raw_dates
    QUALIFY ROW_NUMBER() OVER (PARTITION BY saledate ORDER BY saledate) = 1 -- Ensure unique dates
)

SELECT * FROM final
ORDER BY sale_date