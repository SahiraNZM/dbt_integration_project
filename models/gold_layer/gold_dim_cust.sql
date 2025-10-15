{{ config(materialized='table') }}

with info as (
    select
        cst_id as customer_id,
        customer_firstname,
        customer_lastname,
        gender,
        marital_status
    from {{ ref('stg_cust_info') }}
),

personal as (
    select
        REGEXP_REPLACE(cid, '[^0-9]', '') as customer_id,
        bdate as birth_date,
        gender as personal_gender
    from {{ ref('stg_cust_personal') }}
),

loc as (
    select
        REGEXP_REPLACE(cid, '[^0-9]', '') as customer_id,
        "TRIM(CNTRY)" as country
    from {{ ref('stg_cust_loc') }}
)

select
    i.customer_id,
    i.customer_firstname,
    i.customer_lastname,
    coalesce(i.gender, p.personal_gender, 'Unknown') as gender,
    i.marital_status,
    p.birth_date,
    l.country
from info i
left join personal p on REGEXP_REPLACE(i.customer_id, '[^0-9]', '') = p.customer_id
left join loc l on REGEXP_REPLACE(i.customer_id, '[^0-9]', '') = l.customer_id