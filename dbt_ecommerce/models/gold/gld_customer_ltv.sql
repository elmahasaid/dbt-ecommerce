with customers as (

    select * from {{ ref('slv_customers') }}

),

orders_enriched as (

    select * from {{ ref('slv_orders_enriched') }}

),

customer_revenue as (

    select
        user_id,
        round(sum(sale_price), 2) as lifetime_value

    from orders_enriched
    where order_status != 'Cancelled'
    group by user_id

),

final as (

    select
        c.user_id,
        c.first_name,
        c.last_name,
        c.country,
        c.total_orders,
        c.first_order_at,
        c.last_order_at,
        coalesce(cr.lifetime_value, 0) as lifetime_value,
        case
            when c.total_orders = 0 then 'Aucune commande'
            when c.total_orders = 1 then 'Nouveau client'
            when c.total_orders between 2 and 4 then 'Client récurrent'
            else 'Client VIP'
        end as customer_segment

    from customers c
    left join customer_revenue cr on c.user_id = cr.user_id

)

select * from final