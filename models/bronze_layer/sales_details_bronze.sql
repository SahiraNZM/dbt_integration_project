{{ config(materialized='table') }}

SELECT * FROM {{ source('crm', 'sales_details') }}
