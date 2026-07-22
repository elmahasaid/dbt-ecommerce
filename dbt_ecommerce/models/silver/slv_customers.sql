with users as (

    select * from {{ ref('stg_users') }}

),

orders as (

    select * from {{ ref('stg_orders') }}

),

order_stats as (

    select
        user_id,
        count(distinct order_id) as total_orders,
        min(created_at) as first_order_at,
        max(created_at) as last_order_at,
        sum(num_of_item) as total_items_ordered

    from orders
    group by user_id

),

final as (

    select
        u.user_id,
        u.first_name,
        u.last_name,
        u.email,
        u.gender,
        u.country,
        u.state,
        u.city,
        u.created_at as user_created_at,
        coalesce(os.total_orders, 0) as total_orders,
        os.first_order_at,
        os.last_order_at,
        coalesce(os.total_items_ordered, 0) as total_items_ordered

    from users u
    left join order_stats os on u.user_id = os.user_id

)

select * from final