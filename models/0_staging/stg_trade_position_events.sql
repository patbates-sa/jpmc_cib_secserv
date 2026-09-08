with source as (

    select * from {{ source('jpmc_secserv_workshop', 'jpmc_cib_secserv_trade_position_events_raw') }}

),

normalized as (

    select
        upper(nullif(trim(event_id), '')) as event_id,
        upper(nullif(trim(source_system), '')) as source_system,
        upper(nullif(trim(source_record_id), '')) as source_record_id,
        nullif(trim(source_row_version), '') as source_row_version,
        nullif(trim(event_ts_utc), '') as event_ts_utc,
        nullif(trim(as_of_date), '') as as_of_date,
        upper(nullif(trim(portfolio_id), '')) as portfolio_id,
        upper(nullif(trim(fund_id), '')) as fund_id,
        nullif(trim(fund_name), '') as fund_name,
        nullif(trim(strategy), '') as strategy,
        upper(nullif(trim(account_id), '')) as account_id,
        upper(nullif(trim(instrument_id), '')) as instrument_id,
        upper(nullif(trim(instrument_type), '')) as instrument_type,
        upper(nullif(trim(asset_class), '')) as asset_class,
        upper(nullif(trim(identifier_type), '')) as identifier_type,
        upper(nullif(trim(security_identifier), '')) as security_identifier,
        nullif(trim(issuer_name), '') as issuer_name,
        upper(nullif(trim(trade_currency), '')) as trade_currency,
        upper(nullif(trim(base_currency), '')) as base_currency,
        nullif(trim(quantity), '') as quantity,
        nullif(trim(unit_price), '') as unit_price,
        nullif(trim(notional_amount), '') as notional_amount,
        nullif(trim(market_value), '') as market_value,
        nullif(trim(cost_basis), '') as cost_basis,
        nullif(trim(unrealized_pnl), '') as unrealized_pnl,
        nullif(trim(trade_date), '') as trade_date,
        nullif(trim(settlement_date), '') as settlement_date,
        upper(nullif(trim(counterparty_id), '')) as counterparty_id,
        nullif(trim(counterparty_name), '') as counterparty_name,
        nullif(trim(custodian), '') as custodian,
        upper(nullif(trim(position_status), '')) as position_status,
        upper(nullif(trim(reconciliation_status), '')) as reconciliation_status,
        upper(nullif(trim(is_cancelled), '')) as is_cancelled,
        upper(nullif(trim(ingest_batch_id), '')) as ingest_batch_id

    from source

),

typed as (

    select
        event_id,
        source_system,
        source_record_id,
        try_cast(source_row_version as int) as source_row_version,
        try_cast(event_ts_utc as timestamp) as event_ts_utc,
        try_cast(as_of_date as date) as as_of_date,
        portfolio_id,
        fund_id,
        fund_name,
        strategy,
        account_id,
        instrument_id,
        instrument_type,
        asset_class,
        identifier_type,
        security_identifier,
        issuer_name,
        trade_currency,
        base_currency,
        try_cast(quantity as decimal(38, 6)) as quantity,
        try_cast(unit_price as decimal(38, 6)) as unit_price,
        try_cast(notional_amount as decimal(38, 6)) as notional_amount,
        try_cast(market_value as decimal(38, 6)) as market_value,
        try_cast(cost_basis as decimal(38, 6)) as cost_basis,
        try_cast(unrealized_pnl as decimal(38, 6)) as unrealized_pnl,
        try_cast(trade_date as date) as trade_date,
        try_cast(settlement_date as date) as settlement_date,
        counterparty_id,
        counterparty_name,
        custodian,
        position_status,
        reconciliation_status,
        case
            when is_cancelled = 'Y' then true
            when is_cancelled = 'N' then false
            else null
        end as is_cancelled,
        ingest_batch_id

    from normalized

)

select * from typed
