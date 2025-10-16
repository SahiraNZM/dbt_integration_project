{{ config(
    materialized = 'view',
    tags = ['gold', 'customer']
) }}

-- Customer info
with info as (
    select
        cst_id,
        customer_firstname,
        customer_lastname,
        gender as info_gender,
        marital_status
    from {{ ref('stg_cust_info') }}
),

-- Personal details
personal as (
    select
        regexp_replace(cid, '[^0-9]', '') as clean_cid,  -- remove letters & dashes
        bdate,
        gender as personal_gender
    from {{ ref('stg_cust_personal') }}
),

-- Location details
loc as (
    select
        regexp_replace(cid, '[^0-9]', '') as clean_cid,
        'trim(cntry)' as country
    from {{ ref('stg_cust_loc') }}
)

-- Final unified customer dimension
select
    row_number() over (order by i.cst_id) as customer_key,
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
    on i.cst_id = p.clean_cid
left join loc l
    on i.cst_id = l.clean_cid