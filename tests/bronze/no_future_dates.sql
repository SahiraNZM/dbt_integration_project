{% test no_future_dates(model, column_name) %}
select *
from {{ model }}
where try_to_date({{ column_name }}) > current_date()
{% endtest %}
