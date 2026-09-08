with trade_position_events as (

    select *
    from {{ ref('stg_trade_position_events') }}

),

instrument_reference as (

    select *
    from {{ ref('stg_instrument_reference') }}

),

latest_source_records as (

    select
        *,
        row_number() over (
            partition by source_system, source_record_id
            order by
                coalesce(source_row_version, 0) desc,
                event_ts_utc desc,
                event_id desc
        ) as source_record_rank
    from trade_position_events

),

current_positions as (

    select *
    from latest_source_records
    where source_record_rank = 1
      and not is_cancelled

),

enriched_positions as (

    select
        md5(concat_ws('||', cp.source_system, cp.source_record_id)) as position_record_key,
        cp.as_of_date,
        cp.event_ts_utc,
        cp.event_id,
        cp.source_system,
        cp.source_record_id,
        cp.source_row_version,
        cp.portfolio_id,
        cp.fund_id,
        cp.fund_name,
        cp.strategy,
        cp.account_id,
        cp.instrument_id,
        coalesce(ir.instrument_type, cp.instrument_type) as instrument_type,
        coalesce(ir.asset_class, cp.asset_class) as asset_class,
        coalesce(ir.identifier_type, cp.identifier_type) as identifier_type,
        coalesce(ir.security_identifier_normalized, cp.security_identifier) as security_identifier,
        coalesce(ir.issuer_name, cp.issuer_name) as issuer_name,
        cp.trade_currency,
        ir.instrument_currency,
        cp.base_currency,
        cp.quantity,
        cp.unit_price,
        cp.notional_amount,
        cp.market_value,
        cp.cost_basis,
        cp.unrealized_pnl,
        case
            when cp.cost_basis = 0 then null
            else cp.unrealized_pnl / cp.cost_basis
        end as unrealized_pnl_pct,
        cp.trade_date,
        cp.settlement_date,
        datediff(cp.settlement_date, cp.trade_date) as settlement_lag_days,
        datediff(cp.as_of_date, cp.trade_date) as position_age_days,
        cp.counterparty_id,
        cp.counterparty_name,
        cp.custodian,
        cp.position_status,
        cp.reconciliation_status,
        ir.reference_status,
        ir.instrument_id is not null as has_reference_match,
        cp.position_status = 'OPEN' as is_open_position,
        cp.reconciliation_status in ('PENDING', 'UNMATCHED') as is_reconciliation_break,
        cp.ingest_batch_id
    from current_positions cp
    left join instrument_reference ir
        on cp.instrument_id = ir.instrument_id

)

select *
from enriched_positions
