-- Sales and quantity should always be positive
select *
from {{ ref('stg_sales_details') }}
where sls_quantity <= 0 or sls_price <= 0 or sls_sales <= 0
