{{ config(materialized='table') }}

SELECT * FROM {{ source('crm', 'cust_info') }}