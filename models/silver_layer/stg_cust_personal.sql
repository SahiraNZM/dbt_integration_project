{{ config(materialized='view') }}

-- Step 1: Deduplicate and clean personal data
WITH ranked AS (
    SELECT
        CID,
        TRY_TO_DATE(BDATE::STRING, 'YYYYMMDD') AS BDATE,  -- convert text to date
        INITCAP(TRIM(GEN)) AS GEN,                  -- format gender text cleanly
        ROW_NUMBER() OVER (
            PARTITION BY CID
            ORDER BY TRY_TO_DATE(BDATE::STRING, 'YYYYMMDD') DESC
        ) AS row_num
    FROM {{ ref('cust_personal') }}
)

-- Step 2: Keep only unique and valid records
SELECT
    CID,
    BDATE,
    GEN
FROM ranked
WHERE row_num = 1
  AND CID IS NOT NULL
  AND BDATE IS NOT NULL
  AND GEN IS NOT NULL