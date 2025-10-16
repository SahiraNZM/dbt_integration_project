{% macro trim_name(column_name) %}
    trim({{ column_name }})
{% endmacro %}