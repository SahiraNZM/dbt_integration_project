{% macro standardize_marital_status(column_name) %}
    case 
        when upper({{ column_name }}) in ('M', 'MARRIED') then 'Married'
        when upper({{ column_name }}) in ('S', 'SINGLE') then 'Single'
        when upper({{ column_name }}) in ('D', 'DIVORCED') then 'Divorced'
        when upper({{ column_name }}) in ('W', 'WIDOWED') then 'Widowed'
        else 'Unknown'
    end
{% endmacro %}
