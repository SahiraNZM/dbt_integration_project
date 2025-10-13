{{ config(materialized='view') }}

-- Step 1: Deduplicate and clean location data
WITH ranked AS (
    SELECT
        CID,
        CNTRY,
        ROW_NUMBER() OVER (
            PARTITION BY CID 
            ORDER BY CID
        ) AS row_num
    FROM {{ ref('cust_loc') }}
)

-- Step 2: Keep only unique, valid rows
SELECT
    CID,
    INITCAP(TRIM(CNTRY)) AS CNTRY   -- standardize country name format
FROM ranked
WHERE row_num = 1
  AND CID IS NOT NULL
  AND CNTRY IS NOT NULL