{% macro standardize_text_case(column_name) %}
    INITCAP(
        {{ handle_nulls_and_dashes(trim_name(column_name)) }}
    )
{% endmacro %}
