{{ config(materialized='table') }}

-- Step 1: Deduplicate using the macro
WITH deduped AS (
    {{ remove_duplicates(ref('cust_personal'), 'CID', 'BDATE') }}
)

-- Step 2: Filter out null values
SELECT
    CID,
    BDATE,
    GEN AS GENDER
FROM deduped
WHERE CID IS NOT NULL
  AND BDATE IS NOT NULL
  AND GEN IS NOT NULL
