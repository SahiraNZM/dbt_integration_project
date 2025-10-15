-- models/gold/gold_fact_sales.sql
{{ config(materialized='table') }}

select
    s.sls_ord_num as order_id,
    s.sls_cust_id as customer_id,
    s.sls_prd_key as product_key,
    s.sls_order_dt as order_date,
    s.sls_ship_dt as ship_date,
    s.sls_due_dt as due_date,
    s.sls_sales as sales_amount,
    s.sls_quantity as quantity,
    s.sls_price as unit_price
from {{ ref('stg_sales_details') }}