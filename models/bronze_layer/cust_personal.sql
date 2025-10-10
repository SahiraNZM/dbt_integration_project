{{ config(materialized='table') }}

SELECT * FROM {{ source('erp', 'CUST_AZ12') }}
