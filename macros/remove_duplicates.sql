{% macro remove_duplicates(table, key_column, order_column='_load_timestamp') %}
    select *
    from {{ table }}
    qualify row_number() over (
        partition by {{ key_column }}
        order by {{ order_column }} desc
    ) = 1
{% endmacro %}
