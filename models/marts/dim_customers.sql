with customers as (

    select * from {{ ref('stg_customers') }}

),

orders as (

    select customer_id, purchased_at from {{ ref('stg_orders') }}

),

geo as (

    select * from {{ ref('stg_geolocation') }}

),

joined as (

    select
        c.customer_unique_id,
        c.customer_id,
        c.zip_code_prefix,
        c.city,
        c.state,
        o.purchased_at
    from customers c
    left join orders o using (customer_id)

),

latest_location as (

    select *
    from joined
    qualify row_number() over (
        partition by customer_unique_id
        order by purchased_at desc nulls last, customer_id
    ) = 1

),

lifetime as (

    select
        customer_unique_id,
        min(purchased_at)            as first_order_at,
        max(purchased_at)            as last_order_at,
        count(distinct customer_id)  as order_count
    from joined
    group by customer_unique_id

)

select
    l.customer_unique_id,
    l.zip_code_prefix,
    l.city,
    l.state,
    g.lat,
    g.lng,
    t.first_order_at,
    t.last_order_at,
    t.order_count,
    t.order_count > 1 as is_repeat_customer
from latest_location l
join lifetime t using (customer_unique_id)
left join geo g on l.zip_code_prefix = g.zip_code_prefix