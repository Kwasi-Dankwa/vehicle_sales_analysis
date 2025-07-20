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

        -- Step 1: Extracted the first 15 characters: "Tue Dec 16 2014"
        -- Step 2: Converted to DATE
        TRY_TO_DATE(SUBSTR(saledate, 1, 15), 'DY MON DD YYYY') AS saledate_date

    FROM {{ source('cardb', 'car_sales') }}
    WHERE vin IS NOT NULL AND make IS NOT NULL
),

-- retains unique vin by keeping the most recent saledate--
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

    -- Format as 'YYYY/MM/DD'
    TO_CHAR(saledate_date, 'YYYY/MM/DD') AS saledate

FROM deduped_data




