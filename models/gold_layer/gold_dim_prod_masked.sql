{{ config(materialized='view') }}

SELECT
    -- Product ID (cast to varchar to avoid numeric conflict)
    CASE
        WHEN CURRENT_ROLE() IN ('FULL_ACCESS_ROLE', 'SYSADMIN') THEN TO_VARCHAR(prd_id)
        ELSE CONCAT(LEFT(TO_VARCHAR(prd_id), 2), REPEAT('*', LENGTH(TO_VARCHAR(prd_id)) - 2))
    END AS prd_id,

    -- Product Key (partial masking)
    CASE
        WHEN CURRENT_ROLE() IN ('FULL_ACCESS_ROLE', 'SYSADMIN') THEN prd_key
        ELSE CONCAT(LEFT(prd_key, 4), REPEAT('*', LENGTH(prd_key) - 4))
    END AS prd_key,

    -- Product Name (partial masking)
    CASE
        WHEN CURRENT_ROLE() IN ('FULL_ACCESS_ROLE', 'SYSADMIN') THEN prd_nm
        ELSE CONCAT(LEFT(prd_nm, 2), REPEAT('*', LENGTH(prd_nm) - 2))
    END AS prd_nm,

    -- Product Cost (numeric masking)
    CASE
        WHEN CURRENT_ROLE() IN ('FULL_ACCESS_ROLE', 'SYSADMIN') THEN prd_cost
        ELSE 0
    END AS prd_cost,

    -- Non-sensitive attributes
    prd_line,
    category,
    subcategory,
    maintenance,

    -- Masked Dates
    CASE
        WHEN CURRENT_ROLE() IN ('FULL_ACCESS_ROLE', 'SYSADMIN') THEN TO_VARCHAR(prd_start_dt)
        ELSE '1970-01-01'
    END AS prd_start_dt,

    CASE
        WHEN CURRENT_ROLE() IN ('FULL_ACCESS_ROLE', 'SYSADMIN') THEN TO_VARCHAR(prd_end_dt)
        ELSE '1970-01-01'
    END AS prd_end_dt

FROM {{ ref('gold_dim_prod') }}
