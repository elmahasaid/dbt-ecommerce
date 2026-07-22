with order_items as (

    select * from {{ ref('stg_order_items') }}

),

orders as (

    select * from {{ ref('stg_orders') }}

),

products as (

    select * from {{ ref('stg_products') }}

),

final as (

    select
        oi.order_item_id,
        oi.order_id,
        oi.user_id,
        o.status as order_status,
        o.created_at as order_created_at,
        o.shipped_at as order_shipped_at,
        o.delivered_at as order_delivered_at,
        o.returned_at as order_returned_at,
        oi.product_id,
        p.product_name,
        p.product_category,
        p.product_department,
        p.product_brand,
        oi.sale_price,
        p.product_cost,
        oi.sale_price - p.product_cost as gross_margin

    from order_items oi
    left join orders o on oi.order_id = o.order_id
    left join products p on oi.product_id = p.product_id

)

select * from final