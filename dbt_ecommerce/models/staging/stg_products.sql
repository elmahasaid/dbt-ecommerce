with source as (

    select * from {{ source('thelook_ecommerce', 'products') }}

),

renamed as (

    select
        id as product_id,
        name as product_name,
        category as product_category,
        department as product_department,
        brand as product_brand,
        sku as product_sku,
        cost as product_cost,
        retail_price as product_retail_price,
        distribution_center_id

    from source

)

select * from renamed