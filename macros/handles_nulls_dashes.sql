{% macro handle_nulls_and_dashes(column_name) %}
   case
       when {{ column_name }} is null
            or trim({{ column_name }}) = ''
            or regexp_like(trim({{ column_name }}), '^-+$')
       then 'Unknown'
       else trim({{ column_name }})
   end
{% endmacro %}