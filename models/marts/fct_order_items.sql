select
    i.order_item_key,
    i.order_id,
    i.order_item_id,
    o.customer_unique_id,
    i.product_id,
    i.seller_id,
    o.order_status,
    o.purchase_date,
    i.shipping_limit_at,
    i.price,
    i.freight_value,
    i.item_total
from {{ ref('stg_order_items') }} i
join {{ ref('fct_orders') }} o using (order_id)