{{ config(materialized='table') }}

SELECT * FROM {{ source('erp', 'PX_CAT_G1V2') }}
