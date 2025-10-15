{% macro standardize_maintenance_flag(column_name) %}
    case
        when upper(trim({{ column_name }})) in ('Y', 'YES', 'TRUE', '1') then 'YES'
        when upper(trim({{ column_name }})) in ('N', 'NO', 'FALSE', '0') then 'NO'
        else 'Unknown'
    end
{% endmacro %}
