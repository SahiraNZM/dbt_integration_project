{{ config(materialized='view') }}

SELECT
    -- Mask Order ID (show first 2 characters, rest as ****)
    CASE
        WHEN CURRENT_ROLE() IN ('FULL_ACCESS_ROLE', 'SYSADMIN') THEN order_id
        ELSE CONCAT(LEFT(order_id, 2), REPEAT('*', LENGTH(order_id) - 2))
    END AS order_id,

    -- Mask Customer ID (partial masking)
    CASE
        WHEN CURRENT_ROLE() IN ('FULL_ACCESS_ROLE', 'SYSADMIN') THEN TO_VARCHAR(customer_id)
        ELSE CONCAT(LEFT(TO_VARCHAR(customer_id), 2), REPEAT('*', LENGTH(TO_VARCHAR(customer_id)) - 2))
    END AS customer_id,

    -- Product key (not sensitive)
    product_key,

    -- Mask dates (convert to varchar for masking)
    CASE
        WHEN CURRENT_ROLE() IN ('FULL_ACCESS_ROLE', 'SYSADMIN') THEN TO_VARCHAR(order_date)
        ELSE '1970-01-01'
    END AS order_date,

    CASE
        WHEN CURRENT_ROLE() IN ('FULL_ACCESS_ROLE', 'SYSADMIN') THEN TO_VARCHAR(ship_date)
        ELSE '1970-01-01'
    END AS ship_date,

    CASE
        WHEN CURRENT_ROLE() IN ('FULL_ACCESS_ROLE', 'SYSADMIN') THEN TO_VARCHAR(due_date)
        ELSE '1970-01-01'
    END AS due_date,

    -- Mask sensitive numeric values
    CASE
        WHEN CURRENT_ROLE() IN ('FULL_ACCESS_ROLE', 'SYSADMIN') THEN sales_amount
        ELSE 0
    END AS sales_amount,

    quantity,

    CASE
        WHEN CURRENT_ROLE() IN ('FULL_ACCESS_ROLE', 'SYSADMIN') THEN unit_price
        ELSE 0
    END AS unit_price

FROM {{ ref('gold_dim_fact_sales') }}
