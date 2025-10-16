{{ config(materialized='table') }}

-- Step 1: Deduplicate using the macro
with deduped as (
    {{ remove_duplicates(ref('cust_personal'), 'CID', 'BDATE') }}
),

-- Step 2: Clean and standardize gender
gender_standardized as (
    {{ standardize_gender('deduped', 'GEN') }}
)

select
    trim(CID) as cid,
    BDATE as birthdate,
    Gender
from gender_standardized
where CID is not null
  and BDATE is not null
  and GEN is not null