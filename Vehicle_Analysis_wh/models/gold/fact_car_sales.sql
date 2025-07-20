{{ config(materialized='table') }}

WITH stg_sales AS (
    SELECT
        vin,
        saledate,
        sellingprice,
        mmr,
        ste,
        seller
    FROM {{ ref('stg_car_sales') }}
    WHERE sellingprice IS NOT NULL
      AND mmr IS NOT NULL
      AND saledate IS NOT NULL
      AND vin IS NOT NULL
),

-- Join with dimension keys
joined_data AS (
    SELECT
        s.saledate,
        dv.vehicle_key,
        ds.seller_key,
        dd.date_key,
        s.sellingprice,
        s.mmr,
        s.ste AS sale_state
    FROM stg_sales s
    LEFT JOIN {{ ref('dim_vehicles') }} dv ON s.vin = dv.vin
    LEFT JOIN {{ ref('dim_seller') }} ds ON s.seller = ds.seller
    LEFT JOIN {{ ref('dim_date') }} dd ON s.saledate = dd.sale_date
),

-- Calculate KPIs
final AS (
    SELECT
        vehicle_key,
        seller_key,
        date_key,
        sellingprice,
        mmr,
        (sellingprice - mmr) AS price_diff_from_mmr,
        CASE
            WHEN mmr > 0 THEN (sellingprice / mmr)
            ELSE NULL
        END AS price_to_mmr_ratio,
        sale_state
    FROM joined_data
)

SELECT * FROM final
