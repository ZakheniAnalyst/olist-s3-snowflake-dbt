with orders as (

    select * from {{ ref('stg_orders') }}

),

customers as (

    select customer_id, customer_unique_id from {{ ref('stg_customers') }}

),

items as (

    select
        order_id,
        count(*)           as item_count,
        sum(price)         as items_value,
        sum(freight_value) as freight_value
    from {{ ref('stg_order_items') }}
    group by order_id

),

payments as (

    select
        order_id,
        sum(payment_value) as payment_value
    from {{ ref('stg_order_payments') }}
    group by order_id

),

reviews as (

    select order_id, review_score from {{ ref('stg_order_reviews') }}

)

select
    o.order_id,
    c.customer_unique_id,
    o.order_status,
    o.purchased_at,
    o.purchased_at::date                   as purchase_date,
    o.approved_at,
    o.delivered_to_carrier_at,
    o.delivered_to_customer_at,
    o.estimated_delivery_at,

    coalesce(i.item_count, 0)              as item_count,
    coalesce(i.items_value, 0)             as items_value,
    coalesce(i.freight_value, 0)           as freight_value,
    coalesce(p.payment_value, 0)           as payment_value,
    r.review_score,

    datediff(day, o.purchased_at, o.delivered_to_customer_at) as delivery_days,
    case
        when o.delivered_to_customer_at is null then null
        else o.delivered_to_customer_at::date > o.estimated_delivery_at::date
    end                                    as is_late

from orders o
join customers c using (customer_id)
left join items i using (order_id)
left join payments p using (order_id)
left join reviews r using (order_id)