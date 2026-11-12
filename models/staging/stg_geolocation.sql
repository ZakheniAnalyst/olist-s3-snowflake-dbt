with cleaned as (

    select
        geolocation_zip_code_prefix as zip_code_prefix,
        geolocation_lat             as lat,
        geolocation_lng             as lng,
        initcap(trim(geolocation_city)) as city,
        geolocation_state           as state
    from {{ source('olist', 'raw_geolocation') }}

),

coords as (

    select
        zip_code_prefix,
        avg(lat) as lat,
        avg(lng) as lng
    from cleaned
    group by zip_code_prefix

),

top_city as (

    select zip_code_prefix, city, state
    from cleaned
    group by zip_code_prefix, city, state
    qualify row_number() over (
        partition by zip_code_prefix
        order by count(*) desc, city
    ) = 1

)

select
    c.zip_code_prefix,
    c.lat,
    c.lng,
    t.city,
    t.state
from coords c
join top_city t using (zip_code_prefix)