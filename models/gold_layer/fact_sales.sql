{{ config(materialized='table') }}

WITH sales AS (
    SELECT *
    FROM {{ ref('stg_sales_details') }}
),

products AS (
    SELECT *
    FROM {{ ref('stg_prod_details') }}
),

categories AS (
    SELECT *
    FROM {{ ref('stg_prod_category') }}
),

customers AS (
    SELECT *
    FROM {{ ref('stg_cust_personal') }}
),

locations AS (
    SELECT *
    FROM {{ ref('stg_cust_loc') }}
)

SELECT
    s.SLS_ORDER_NUM,           
    s.SLS_CUST_ID,
    s.SLS_PRD_KEY,
    s.SLS_ORDER_DT,
    s.SLS_SHIP_DT,
    s.SLS_DUE_DT,
    s.SLS_SALES,
    s.SLS_QUANTITY,
    s.SLS_PRICE,

    p.PRD_NM,
    p.PRD_COST,
    p.PRD_LINE,

    c.CAT AS CATEGORY,
    c.SUBCAT AS SUBCATEGORY,

    cust.GEN AS CUSTOMER_GENDER,
    cust.BDATE AS CUSTOMER_BIRTHDATE,
    loc.CNTRY AS CUSTOMER_COUNTRY

FROM sales s
LEFT JOIN products p
    ON s.SLS_PRD_KEY = p.PRD_KEY
LEFT JOIN categories c
    ON LEFT(s.SLS_PRD_KEY, 2) = LEFT(c.ID, 2)  
LEFT JOIN customers cust
    ON s.SLS_CUST_ID = cust.CID
LEFT JOIN locations loc
    ON s.SLS_CUST_ID = loc.CID;