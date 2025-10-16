{{ config(materialized='table') }}

with deduped as (
    {{ remove_duplicates(ref('cust_loc'), 'CID', 'CID') }}
),

cleaned as (
    select
        CID,
        {{ trim_name(CNTRY) }} as COUNTRY
    from deduped
)

select * from cleaned