with source as (

    select * from {{ source('jpmc_secserv_workshop', 'jpmc_cib_secserv_instrument_reference_raw') }}

),

normalized as (

    select
        upper(nullif(trim(instrument_id), '')) as instrument_id,
        upper(nullif(trim(instrument_type), '')) as instrument_type,
        upper(nullif(trim(asset_class), '')) as asset_class,
        upper(nullif(trim(identifier_type), '')) as identifier_type,
        upper(nullif(trim(security_identifier_normalized), '')) as security_identifier_normalized,
        nullif(trim(issuer_name), '') as issuer_name,
        upper(nullif(trim(instrument_currency), '')) as instrument_currency,
        upper(nullif(trim(reference_status), '')) as reference_status

    from source

)

select * from normalized
