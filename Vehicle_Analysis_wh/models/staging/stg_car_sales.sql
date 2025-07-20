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
