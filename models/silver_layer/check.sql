select * 
from {{ ref('stg_cust_loc') }}
limit 1