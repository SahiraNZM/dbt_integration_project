-- models/gold/gold_fact_sales.sql
{{ config(materialized='view') }}

select
    sls_ord_num as order_id,
    sls_cust_id as customer_id,
    sls_prd_key as product_key,
    sls_order_dt as order_date,
    sls_ship_dt as ship_date,
    sls_due_dt as due_date,
    sls_sales as sales_amount,
    sls_quantity as quantity,
    sls_price as unit_price
from {{ ref('stg_sales_details') }}