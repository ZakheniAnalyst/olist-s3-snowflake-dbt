select
    order_id || '-' || order_item_id as order_item_key,
    order_id,
    order_item_id,
    product_id,
    seller_id,
    shipping_limit_date              as shipping_limit_at,
    price,
    freight_value,
    price + freight_value            as item_total
from {{ source('olist', 'raw_order_items') }}