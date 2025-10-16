{{ config(materialized='table') }}

-- Step 1: Deduplicate by order, product, and customer
WITH deduped AS (
    {{ remove_duplicates(
        ref('sales_details_bronze'),
        "concat(SLS_ORD_NUM, '-', SLS_PRD_KEY, '-', SLS_CUST_ID)",
        'SLS_ORDER_DT'
    ) }}
),

-- Step 2: Clean, convert, and standardize
cleaned AS (
    SELECT
        trim(SLS_ORD_NUM)  AS SLS_ORD_NUM,
        trim(SLS_PRD_KEY)  AS SLS_PRD_KEY,
        {{ safe_to_number('SLS_CUST_ID') }} AS SLS_CUST_ID,

        {{ safe_to_date('SLS_ORDER_DT::STRING') }} AS SLS_ORDER_DT,
        {{ safe_to_date('SLS_SHIP_DT::STRING') }}  AS SLS_SHIP_DT,
        {{ safe_to_date('SLS_DUE_DT::STRING') }}   AS SLS_DUE_DT,

        {{ safe_to_number('SLS_SALES') }}    AS SLS_SALES,
        {{ safe_to_number('SLS_QUANTITY') }} AS SLS_QUANTITY,
        {{ safe_to_number('SLS_PRICE') }}    AS SLS_PRICE
    FROM deduped
)

-- Step 3: Final filtered results
SELECT *
FROM cleaned
WHERE SLS_ORD_NUM IS NOT NULL
  AND SLS_PRD_KEY IS NOT NULL
  AND SLS_CUST_ID IS NOT NULL
  AND SLS_ORDER_DT IS NOT NULL
