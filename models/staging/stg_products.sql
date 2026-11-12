with products as (

    select * from {{ source('olist', 'raw_products') }}

),

translation as (

    select * from {{ ref('stg_product_category_translation') }}

)

select
    p.product_id,
    p.product_category_name,
    coalesce(t.product_category_name_english,
             p.product_category_name,
             'unknown')                       as category_name_english,
    p.product_name_lenght::int                as name_length,
    p.product_description_lenght::int         as description_length,
    p.product_photos_qty::int                 as photos_qty,
    p.product_weight_g                        as weight_g,
    p.product_length_cm                       as length_cm,
    p.product_height_cm                       as height_cm,
    p.product_width_cm                        as width_cm

from products p
left join translation t
    on p.product_category_name = t.product_category_name