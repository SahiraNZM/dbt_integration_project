{{ config(materialized='table') }}

SELECT * FROM {{ source('crm', 'prd_info') }}
