-- models/staging/stg_car_sales.sql
{{ config(materialized='view') }}

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
        ELSE UPPER(ste)
    END AS ste,
    condition,
    odometer,
    CASE
        WHEN TRY_TO_NUMBER(color) IS NOT NULL THEN NULL
        ELSE color
    END AS color,
    UPPER(TRIM(interior)) AS interior,
    UPPER(TRIM(seller)) AS seller,
    mmr,
    sellingprice,
    CASE
        WHEN saledate IS NOT NULL AND POSITION(' GMT' IN saledate) > 4 THEN
            TRY_TO_DATE(SUBSTR(saledate, 5, POSITION(' GMT' IN saledate) - 5))
        ELSE NULL
    END AS saledate
FROM {{ source('cardb', 'car_sales') }}
WHERE vin IS NOT NULL
AND make IS NOT NULL
