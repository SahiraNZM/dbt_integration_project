-- Ensure no invalid marital status values exist
select *
from {{ ref('stg_cust_info') }}
where marital_status not in ('Married', 'Single', 'Divorced', 'Widowed', 'Unknown')
