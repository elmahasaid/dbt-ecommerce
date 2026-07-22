with source as (

    select * from {{ source('thelook_ecommerce', 'users') }}

),

renamed as (

    select
        id as user_id,
        first_name,
        last_name,
        email,
        age,
        gender,
        country,
        state,
        city,
        street_address,
        postal_code,
        latitude,
        longitude,
        traffic_source,
        created_at

    from source

)

select * from renamed