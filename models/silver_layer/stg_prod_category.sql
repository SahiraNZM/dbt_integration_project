{{ config(materialized='table') }}

-- Step 1: Deduplicate product category data
WITH deduped AS (
    {{ remove_duplicates(ref('prod_category'), 'ID', 'ID') }}
),

-- Step 2: Clean and standardize fields
cleaned AS (
    SELECT
        ID,
        {{ standardize_text_case('CAT') }} AS CAT,
        {{ standardize_text_case('SUBCAT') }} AS SUBCAT,
        {{ standardize_maintenance_flag('MAINTENANCE') }} AS MAINTENANCE
    FROM deduped
    WHERE ID IS NOT NULL
)

-- Step 3: Final select
SELECT * FROM cleaned
WHERE CAT IS NOT NULL
  AND SUBCAT IS NOT NULL
  AND MAINTENANCE IS NOT NULL