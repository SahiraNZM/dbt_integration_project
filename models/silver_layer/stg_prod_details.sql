{{ config(materialized='table') }}

-- Step 1: Deduplicate product data
WITH deduped AS (
    {{ remove_duplicates(ref('prod_details'), 'PRD_ID', 'PRD_START_DT') }}
),

-- Step 2: Clean and standardize columns
cleaned AS (
    SELECT
        PRD_ID,
        {{ handle_nulls_and_dashes(trim_name('PRD_KEY')) }} AS PRD_KEY,
        {{ handle_nulls_and_dashes(trim_name('PRD_NM')) }} AS PRD_NM,
        {{ safe_to_number('PRD_COST') }} AS PRD_COST,
        {{ handle_nulls_and_dashes(trim_name('PRD_LINE')) }} AS PRD_LINE,
        {{ safe_to_date('PRD_START_DT') }} AS PRD_START_DT,
        {{ safe_to_date('PRD_END_DT') }} AS PRD_END_DT
    FROM deduped
    WHERE PRD_ID IS NOT NULL
)

-- Step 3: Final select
SELECT * FROM cleaned
WHERE PRD_KEY IS NOT NULL
AND PRD_NM IS NOT NULL
