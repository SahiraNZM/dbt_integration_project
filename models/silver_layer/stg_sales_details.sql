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
        trim(SLS_ORD_NUM)              AS SLS_ORD_NUM,
        trim(SLS_PRD_KEY)              AS SLS_PRD_KEY,
        TRY_TO_NUMBER(SLS_CUST_ID)     AS SLS_CUST_ID,

        TRY_TO_DATE(SLS_ORDER_DT::STRING, 'YYYYMMDD') AS SLS_ORDER_DT,
        TRY_TO_DATE(SLS_SHIP_DT::STRING, 'YYYYMMDD')  AS SLS_SHIP_DT,
        TRY_TO_DATE(SLS_DUE_DT::STRING,  'YYYYMMDD')  AS SLS_DUE_DT,

        TRY_TO_NUMBER(SLS_SALES)     AS SLS_SALES,
        TRY_TO_NUMBER(SLS_QUANTITY)  AS SLS_QUANTITY,
        TRY_TO_NUMBER(SLS_PRICE)     AS SLS_PRICE
    FROM deduped
)

-- Step 3: Final filtered results
SELECT *
FROM cleaned
WHERE SLS_ORD_NUM IS NOT NULL
  AND SLS_PRD_KEY IS NOT NULL
  AND SLS_CUST_ID IS NOT NULL
  AND SLS_ORDER_DT IS NOT NULL