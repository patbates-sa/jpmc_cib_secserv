{{
    config(
        materialized='table',
        file_format='delta'
    )
}}

with date_spine as (

    select
        explode(
            sequence(
                to_date('2020-01-01'),
                to_date('2035-12-31'),
                interval 1 day
            )
        ) as date_day

)

select cast(date_day as date) as date_day
from date_spine
