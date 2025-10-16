{{ config(
    materialized = 'view',
    tags = ['gold', 'customer']
) }}

-- Create unified customer dimension view
with info as (
    select
        cst_id,
        customer_firstname,
        customer_lastname,
        gender as info_gender,
        marital_status
    from {{ ref('stg_cust_info') }}
),

personal as (
    select
        cid,
        bdate,
        gender as personal_gender
    from {{ ref('stg_cust_personal') }}
),

loc as (
    select
        "CID" as cid,
        "COUNTRY" as country
    from {{ ref('stg_cust_loc') }}
)

select
    row_number() over (order by i.cst_id) as customer_key,  -- surrogate key
    i.cst_id as customer_id,
    i.customer_firstname as first_name,
    i.customer_lastname as last_name,
    
    -- Prefer gender from info, else fallback to personal
    case
        when i.info_gender is not null and i.info_gender not in ('', 'Unknown')
            then i.info_gender
        else coalesce(p.personal_gender, 'Unknown')
    end as gender,

    i.marital_status,
    p.bdate as birthdate,
    l.country
from info i
left join personal p
    on lower(i.cst_id) = lower(p.cid)  -- only if patterns match
left join loc l
    on lower(i.cst_id) = lower(l.cid)