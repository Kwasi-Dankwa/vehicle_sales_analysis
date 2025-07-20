{{ config(materialized='table', unique_key='seller_key') }}

WITH stg_sellers AS (
    SELECT
        seller
    FROM {{ ref('stg_car_sales') }}
    WHERE seller IS NOT NULL
),

-- Assign a surrogate key for each unique seller
final AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['seller']) }} AS seller_key,
        seller
    FROM stg_sellers
    QUALIFY ROW_NUMBER() OVER (PARTITION BY seller ORDER BY seller) = 1 -- Deduplicate
)

SELECT * FROM final