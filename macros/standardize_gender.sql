{% macro standardize_gender(column_name) %}
    case 
        when upper({{ column_name }}) in ('M', 'MALE') then 'Male'
        when upper({{ column_name }}) in ('F', 'FEMALE') then 'Female'
        else 'Unknown'
    end
{% endmacro %}
