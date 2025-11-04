-- Ensure no invalid gender values exist in stg_cust_info
select *
from {{ ref('stg_cust_info') }}
where gender not in ('Male', 'Female', 'Unknown')
