{{ config(materialized='table', unique_key='vehicle_key') }}

WITH stg_vehicles AS (
    SELECT
        vin,
        yr AS year, -- Assuming 'yr' in staging corresponds to 'year' in dim_vehicles
        make,
        model,
        trm AS trim, -- Assuming 'trm' in staging corresponds to 'trim' in dim_vehicles
        body,
        transmission,
        color,
        interior,
        condition,
        odometer
    FROM {{ ref('stg_car_sales') }}
    WHERE vin IS NOT NULL -- Ensure VIN is not null for the unique key
),

-- Assign a surrogate key for each unique vehicle
final AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['vin']) }} AS vehicle_key,
        vin,
        year,
        make,
        model,
        trim,
        body,
        transmission,
        color,
        interior,
        condition,
        odometer
    FROM stg_vehicles
    QUALIFY ROW_NUMBER() OVER (PARTITION BY vin ORDER BY year DESC, make DESC) = 1 -- Deduplicate if any still exist
)

SELECT * FROM final