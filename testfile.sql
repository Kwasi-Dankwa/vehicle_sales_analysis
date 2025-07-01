--data wrangling---

BEGIN TRANSACTION;

-- deleting null values in dataset since vin is primary key
DELETE FROM bronze.carprices
WHERE vin IS NULL;

DELETE FROM bronze.carprices
WHERE make IS NULL;


--clean and testing process--
select vin, count(*)
from bronze.carprices
group by vin
having count(*) > 1 or vin is NULL

select *
from bronze.carprices
where vin = '19uua5663ya022038'

--testing--
select saledate
from bronze.carprices

-- normalize make --
select UPPER(make) as make 
from bronze.carprices
group by make

-- normalize make --
select UPPER(body) as body 
from bronze.carprices
group by body

select UPPER(transmission) as transmission
from bronze.carprices
group by transmission

-- ste column returns null if column contains value greater than 2 in length
SELECT
    CASE
        WHEN LEN(ste) > 2 THEN NULL  
        ELSE UPPER(ste)             
    END AS ste             
FROM bronze.carprices
;

-- cleaning color column by turning numeric vallues to null
SELECT
    CASE
        WHEN TRY_CAST(color AS INT) IS NOT NULL THEN NULL
        ELSE color
    END AS color 
FROM bronze.carprices
group by color

select count(*)
from bronze.carprices
where odometer is null

select mmr 
from bronze.carprices
where mmr is null

select sellingprice
from bronze.carprices
group by sellingprice

select saledate
from bronze.carprices


-- have to replace inconsistencies with ste column with null--

select UPPER(interior) as interior
from bronze.carprices
group by interior

select count (distinct seller)
from bronze.carprices
-- 14263 distinct sellers --

select model
from bronze.carprices
group by model

-- yr column has no null values --
select *
from bronze.carprices
where yr is null

select *
from bronze.carprices
where model is null





select *
from bronze.carprices

select vin
from bronze.carprices
where vin is null

select vin, count(*),
CASE
        WHEN saledate IS NOT NULL AND CHARINDEX(' GMT', saledate) > 4 THEN
            TRY_CONVERT(DATE, SUBSTRING(saledate, 5, CHARINDEX(' GMT', saledate) - 5))
        ELSE
            NULL
    END AS saledate
from bronze.carprices
group by vin
having count(*) > 1 or vin is NULL

select vin, count(*)
from silver.carprices
group by vin
having count(*) > 1
