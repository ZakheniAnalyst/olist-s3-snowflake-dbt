select
    order_id || '-' || payment_sequential as payment_key,
    order_id,
    payment_sequential,
    payment_type,
    payment_installments                  as installments,
    payment_value
from {{ source('olist', 'raw_order_payments') }}