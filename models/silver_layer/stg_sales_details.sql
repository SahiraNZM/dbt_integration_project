{{ config(materialized='table') }}

-- Step 1: Clean and deduplicate sales data
WITH ranked AS (
    SELECT 
        SLS_ORD_NUM,
        SLS_PRD_KEY,
        SLS_CUST_ID,
        
        -- Convert YYYYMMDD into real DATEs safely
        TRY_TO_DATE(SLS_ORDER_DT::STRING, 'YYYYMMDD') AS SLS_ORDER_DT,
        TRY_TO_DATE(SLS_SHIP_DT::STRING, 'YYYYMMDD')  AS SLS_SHIP_DT,
        TRY_TO_DATE(SLS_DUE_DT::STRING,  'YYYYMMDD')  AS SLS_DUE_DT,

        TRY_TO_NUMBER(SLS_SALES)     AS SLS_SALES,
        TRY_TO_NUMBER(SLS_QUANTITY)  AS SLS_QUANTITY,
        TRY_TO_NUMBER(SLS_PRICE)     AS SLS_PRICE,

        ROW_NUMBER() OVER (
            PARTITION BY SLS_ORD_NUM, SLS_PRD_KEY, SLS_CUST_ID
            ORDER BY TRY_TO_DATE(SLS_ORDER_DT::STRING, 'YYYYMMDD') DESC
        ) AS row_num
    FROM {{ ref('sales_details_bronze') }}
)

-- Step 2: Select only clean, latest rows
SELECT
    SLS_ORD_NUM,
    SLS_PRD_KEY,
    SLS_CUST_ID,
    SLS_ORDER_DT,
    SLS_SHIP_DT,
    SLS_DUE_DT,
    SLS_SALES,
    SLS_QUANTITY,
    SLS_PRICE
FROM ranked
WHERE row_num = 1
  AND SLS_ORD_NUM IS NOT NULL
  AND SLS_PRD_KEY IS NOT NULL
  AND SLS_CUST_ID IS NOT NULL