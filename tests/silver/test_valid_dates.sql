-- Ensure dates are not null and not in the future
select *
from {{ ref('stg_sales_details') }}
where sls_order_dt > current_date
   or sls_ship_dt > current_date
   or sls_due_dt > current_date
   or sls_order_dt is null
