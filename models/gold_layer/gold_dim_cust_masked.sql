{{ config(materialized='view') }}

SELECT
    CUSTOMER_KEY,
    CUSTOMER_ID,

    -- Masked First Name
    CASE
        WHEN CURRENT_ROLE() IN ('FULL_ACCESS_ROLE', 'SYSADMIN') THEN
            FIRST_NAME
        ELSE
            CONCAT(LEFT(FIRST_NAME, 1), REPEAT('*', LENGTH(FIRST_NAME) - 1))
    END AS FIRST_NAME,

    -- Masked Last Name
    CASE
        WHEN CURRENT_ROLE() IN ('FULL_ACCESS_ROLE', 'SYSADMIN') THEN
            LAST_NAME
        ELSE
            CONCAT(LEFT(LAST_NAME, 1), REPEAT('*', LENGTH(LAST_NAME) - 1))
    END AS LAST_NAME,

    -- Gender
    CASE
        WHEN CURRENT_ROLE() IN ('FULL_ACCESS_ROLE', 'SYSADMIN') THEN GENDER
        ELSE 'MASKED'
    END AS GENDER,

    -- Marital Status
    CASE
        WHEN CURRENT_ROLE() IN ('FULL_ACCESS_ROLE', 'SYSADMIN') THEN MARITAL_STATUS
        ELSE 'MASKED'
    END AS MARITAL_STATUS,

    -- Birthdate (convert to varchar for masking)
    CASE
        WHEN CURRENT_ROLE() IN ('FULL_ACCESS_ROLE', 'SYSADMIN') THEN TO_VARCHAR(BIRTHDATE)
        ELSE 'MASKED'
    END AS BIRTHDATE,

    -- Country
    CASE
        WHEN CURRENT_ROLE() IN ('FULL_ACCESS_ROLE', 'SYSADMIN') THEN COUNTRY
        ELSE 'MASKED'
    END AS COUNTRY

FROM {{ ref('gold_dim_cust') }}