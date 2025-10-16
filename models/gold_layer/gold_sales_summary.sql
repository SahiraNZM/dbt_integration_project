-- models/gold/gold_sales_summary.sql
{{ config(materialized='table') }}

with sales as (
    select * from {{ ref('gold_dim_fact_sales') }}
),
products as (
    select * from {{ ref('gold_dim_prod') }}
),
customers as (
    select * from {{ ref('gold_dim_cust') }}
)

select
    p.category,
    p.subcategory,
    c.country,
    date_trunc('month', to_date(s.order_date)) as sales_month,
    sum(s.sales_amount) as total_sales,
    sum(s.quantity) as total_quantity,
    count(distinct s.order_id) as total_orders
from sales s
left join products p on s.product_key = p.prd_key
left join customers c on s.customer_id = c.customer_id
group by 1,2,3,4