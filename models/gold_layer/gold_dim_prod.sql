-- models/gold/gold_dim_product.sql
{{ config(materialized='table') }}

with prod as (
    select
        prd_id,
        prd_key,
        prd_nm,
        prd_cost,
        prd_line,
        prd_start_dt,
        prd_end_dt
    from {{ ref('stg_prod_details') }}
),

cat as (
    select
        id,
        cat as category,
        subcat as subcategory,
        maintenance
    from {{ ref('stg_prod_category') }}
)

select
    p.prd_id,
    p.prd_key,
    p.prd_nm,
    p.prd_cost,
    p.prd_line,
    c.category,
    c.subcategory,
    c.maintenance,
    p.prd_start_dt,
    p.prd_end_dt
from prod p
left join cat c
    on p.prd_key like concat(c.id, '%')