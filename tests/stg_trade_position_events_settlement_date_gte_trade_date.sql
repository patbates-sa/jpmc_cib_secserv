{{ config(severity='warn', store_failures=true) }}

{% set failing_rows_query %}
select
    event_id,
    trade_date,
    settlement_date,
    position_status,
    reconciliation_status
from {{ ref('stg_trade_position_events') }}
where settlement_date is not null
  and trade_date is not null
  and settlement_date < trade_date
{% endset %}

{% if execute %}
    {% set failing_rows = run_query(failing_rows_query) %}

    {% for row in failing_rows.rows %}
        {{ log(
            'stg_trade_position_events_settlement_date_gte_trade_date failure: '
            ~ 'event_id=' ~ row['event_id']
            ~ ', trade_date=' ~ row['trade_date']
            ~ ', settlement_date=' ~ row['settlement_date']
            ~ ', position_status=' ~ row['position_status']
            ~ ', reconciliation_status=' ~ row['reconciliation_status'],
            info=true
        ) }}
    {% endfor %}
{% endif %}

{{ failing_rows_query }}
