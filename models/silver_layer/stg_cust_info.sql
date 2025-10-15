{{ config(materialized='table') }}

with deduped as (
    {{ remove_duplicates(ref('cust_details'), 'CST_ID', 'CST_ID') }}
),

cleaned as (
    select CST_ID,
        {{ handle_nulls_and_dashes('CST_LASTNAME') }} as Customer_Lastname,
        {{ handle_nulls_and_dashes('CST_FIRSTNAME') }} as Customer_Firstname,
        {{ standardize_gender('CST_GNDR') }} as Gender,
        {{ standardize_marital_status('CST_MARITAL_STATUS') }} as Marital_Status
    from deduped
)

select * from cleaned