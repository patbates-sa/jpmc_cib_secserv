with 

source as (

    select * from {{ source('jpmc_secserv_workshop', 'jpmc_cib_secserv_trade_position_events_raw') }}

),

renamed as (

    select
        event_id,
        source_system,
        source_record_id,
        source_row_version,
        event_ts_utc,
        as_of_date,
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
        quantity,
        unit_price,
        notional_amount,
        market_value,
        cost_basis,
        unrealized_pnl,
        trade_date,
        settlement_date,
        counterparty_id,
        counterparty_name,
        custodian,
        position_status,
        reconciliation_status,
        is_cancelled,
        ingest_batch_id as ingest_batch_id

    from source

)

select * from renamed