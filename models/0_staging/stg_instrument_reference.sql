with 

source as (

    select * from {{ source('jpmc_secserv_workshop', 'jpmc_cib_secserv_instrument_reference_raw') }}

),

renamed as (

    select
        instrument_id,
        instrument_type,
        asset_class,
        identifier_type,
        security_identifier_normalized,
        issuer_name,
        instrument_currency,
        reference_status

    from source

)

select * from renamed