{{ config(materialized='table') }}

SELECT * FROM {{ source('erp', 'LOC_A101') }}
