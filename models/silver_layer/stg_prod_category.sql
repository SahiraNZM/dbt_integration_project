{{ config(materialized='view') }}

-- Step 1: Deduplicate and clean product category data
WITH ranked AS (
    SELECT
        ID,
        INITCAP(TRIM(CAT)) AS CAT,                -- Standardize Category text
        INITCAP(TRIM(SUBCAT)) AS SUBCAT,          -- Standardize Subcategory text
        UPPER(TRIM(MAINTENANCE)) AS MAINTENANCE,  -- Make maintenance flag consistent (YES/NO)
        ROW_NUMBER() OVER (
            PARTITION BY ID
            ORDER BY ID
        ) AS row_num
    FROM {{ ref('prod_category') }}
)

-- Step 2: Keep only unique and valid records
SELECT
    ID,
    CAT,
    SUBCAT,
    MAINTENANCE
FROM ranked
WHERE row_num = 1
  AND ID IS NOT NULL
  AND CAT IS NOT NULL
  AND SUBCAT IS NOT NULL
  AND MAINTENANCE IS NOT NULL