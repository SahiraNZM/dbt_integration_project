{% macro safe_to_date(column_name) %}
    case
        when {{ column_name }} is null 
             or trim({{ column_name }}) = '' 
             or regexp_like({{ column_name }}, '^-+$') then null
        else try_to_date({{ column_name }})
    end
{% endmacro %}
