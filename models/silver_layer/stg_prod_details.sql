{{ config(materialized='table') }}

-- Step 1: Clean and deduplicate product data
WITH ranked AS (
  SELECT 
    PRD_ID,
    PRD_KEY,
    PRD_NM,
    TRY_TO_NUMBER(PRD_COST) AS PRD_COST,
    PRD_LINE,
    TO_DATE(PRD_START_DT) AS PRD_START_DT,
    TO_DATE(PRD_END_DT) AS PRD_END_DT,

    ROW_NUMBER() OVER (
      PARTITION BY PRD_ID 
      ORDER BY TO_DATE(PRD_START_DT) DESC
    ) AS row_num
  FROM {{ ref('prod_details') }}
)

-- Step 2: Select only latest and valid rows
SELECT
  PRD_ID,
  PRD_KEY,
  PRD_NM,
  PRD_COST,
  PRD_LINE,
  PRD_START_DT,
  PRD_END_DT
FROM ranked
WHERE row_num = 1
  AND PRD_ID IS NOT NULL
  AND PRD_KEY IS NOT NULL
  AND PRD_NM IS NOT NULL