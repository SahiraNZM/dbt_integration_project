{% macro safe_to_number(column_name) %}
    case
        when {{ column_name }} is null 
             or trim({{ column_name }}) = '' 
             or not regexp_like({{ column_name }}, '^[0-9]+(\.[0-9]+)?$') then null
        else try_to_number({{ column_name }})
    end
{% endmacro %}
