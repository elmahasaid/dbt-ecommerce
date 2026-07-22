with orders_enriched as (

    select * from {{ ref('slv_orders_enriched') }}

),

final as (

    select
        date_trunc(order_created_at, month) as order_month,
        count(distinct order_id) as total_orders,
        count(order_item_id) as total_items_sold,
        round(sum(sale_price), 2) as total_revenue,
        round(sum(gross_margin), 2) as total_gross_margin,
        round(sum(sale_price) / count(distinct order_id), 2) as avg_order_value

    from orders_enriched
    where order_status != 'Cancelled'
    group by order_month

)

select * from final
order by order_month