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
    UPPER(TRIM(model)) as model,
    UPPER(TRIM(trm)) as trm,
    UPPER(TRIM(body)) as body,
    UPPER(TRIM(transmission)) as transmission,
    vin,
    CASE
        WHEN LEN(ste) > 2 THEN NULL  
        ELSE UPPER(ste)             
    END AS ste,
    condition,
    odometer,
    CASE
        WHEN TRY_CAST(color AS INT) IS NOT NULL THEN NULL
        ELSE color
    END AS color,
    UPPER(TRIM(interior)) as interior,
    UPPER(TRIM(seller)) as seller,
    mmr,
    sellingprice,
    CASE
        WHEN saledate IS NOT NULL AND CHARINDEX(' GMT', saledate) > 4 THEN
            TRY_CONVERT(DATE, SUBSTRING(saledate, 5, CHARINDEX(' GMT', saledate) - 5))
        ELSE
            NULL
    END AS saledate -- Calculates the Formated SaleDate from the bronze saledate
FROM
    bronze.carprices;



-- inserted data removed columns with null make
-- further cleaning is needed to normalize data and remove other null values and duplicates

TRUNCATE TABLE silver.carprices
go

