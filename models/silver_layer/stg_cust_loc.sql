{{ config(materialized='table') }}

-- Step 1: Deduplicate records
with deduped as (
    {{ remove_duplicates(ref('cust_loc'), 'CID', 'CID') }}
),

-- Step 2: Standardize country names
cleaned as (
    select
        trim(CID) as cid,
        upper(trim(CNTRY)) as country
    from deduped
    where CID is not null
      and CNTRY is not null
)

select * from cleaned