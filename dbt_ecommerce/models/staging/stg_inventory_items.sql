with source as (

    select * from {{ source('thelook_ecommerce', 'inventory_items') }}

),

renamed as (

    select
        id as inventory_item_id,
        product_id,
        product_distribution_center_id,
        product_name,
        product_category,
        product_brand,
        product_department,
        product_sku,
        cost,
        product_retail_price,
        created_at,
        sold_at

    from source

)

select * from renamed