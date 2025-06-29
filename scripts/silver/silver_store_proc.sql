USE CARDB
GO

-- deleting null values in dataset since vin is primary key
DELETE FROM bronze.carprices
WHERE vin IS NULL;

DELETE FROM bronze.carprices
WHERE make IS NULL;






--load--
INSERT INTO silver.carprices(
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
    saledate            -- This will receive the original nvarchar(max) saledate from bronze
)

SELECT
    yr,
    UPPER(TRIM(make)) as make,
    model,
    UPPER(TRIM(trm)) as trm,
    body,
    transmission,
    vin,
    ste,
    condition,
    odometer,
    color,
    UPPER(TRIM(interior)) as interior,
    UPPER(TRIM(seller)) as seller,
    mmr,
    sellingprice,
    CASE
        WHEN saledate IS NOT NULL AND CHARINDEX(' GMT', saledate) > 4 THEN
            TRY_CONVERT(DATE, SUBSTRING(saledate, 5, CHARINDEX(' GMT', saledate) - 5))
        ELSE
            NULL
    END AS saledate -- Calculates the FormatedSaleDate from the bronze saledate
FROM
    bronze.carprices;

select *
from silver.carprices
where make is null
-- inserted data removed columns with null make
-- further cleaning is needed to normalize data and remove other null values and duplicates
