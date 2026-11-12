select
    seller_id,
    seller_zip_code_prefix as zip_code_prefix,
    initcap(seller_city)   as city,
    seller_state           as state
from {{ source('olist', 'raw_sellers') }}