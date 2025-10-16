{% macro standardize_gender(table, column_name) %}
    select
        *,
        case 
            when upper({{ column_name }}) in ('M', 'MALE') then 'Male'
            when upper({{ column_name }}) in ('F', 'FEMALE') then 'Female'
            else 'Unknown'
        end as Gender
    from {{ table }}
{% endmacro %}
