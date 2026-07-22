with inventory_items as (

    select * from {{ ref('stg_inventory_items') }}

),

final as (

    select
        product_id,
        product_name,
        product_category,
        product_brand,
        count(*) as total_units,
        count(case when sold_at is not null then 1 end) as units_sold,
        count(case when sold_at is null then 1 end) as units_in_stock,
        round(sum(case when sold_at is null then product_retail_price else 0 end), 2) as stock_value

    from inventory_items
    group by product_id, product_name, product_category, product_brand

)

select * from final