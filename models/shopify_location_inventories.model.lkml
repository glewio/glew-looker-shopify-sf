connection: "silo_routing"
include: "/**/*.view.lkml"                 # include all views in this project
include: "//glew_looker_glew/views/*.view.lkml"

explore: fact_shopify_location_inventory {
  access_filter: {
    field: glew_account_id
    user_attribute: glew_account_id
  }
  label: "Inventory"
  group_label: "Shopify"
  description: "View/Report on your Shopify inventory levels per warehouse per product per day with this explore"

  join: dim_glew_accounts {
    relationship: many_to_one
    sql_on: ${fact_shopify_location_inventory.glew_account_id} = ${dim_glew_accounts.glew_account_id} ;;
    type: left_outer
  }
  join: fact_exchange_rates {
    relationship: one_to_one
    sql_on: ${fact_exchange_rates.base} = ${dim_glew_accounts.currency}
      and ${fact_exchange_rates.timestamp_date} = ${fact_shopify_location_inventory.inventory_date};;
  }
  join: dim_shopify_locations {
    relationship: many_to_one
    sql_on: ${dim_shopify_locations.glew_account_id} = ${fact_shopify_location_inventory.glew_account_id}
      and ${dim_shopify_locations.location_id} = ${fact_shopify_location_inventory.location_id};;
    type:  left_outer
  }
  join: fact_shopify_products {
    relationship: many_to_one
    sql_on: ${fact_shopify_products.glew_account_id} = ${fact_shopify_location_inventory.glew_account_id}
      and ${fact_shopify_products.product_id} = ${fact_shopify_location_inventory.product_id};;
    type:  left_outer
  }
  join: dim_shopify_product_category_map {
    relationship: one_to_many
    sql_on: ${fact_shopify_products.glew_account_id} = ${dim_shopify_product_category_map.glew_account_id}
      and ${fact_shopify_products.product_id} = ${dim_shopify_product_category_map.product_id};;
    type:  left_outer
  }
  join: dim_shopify_product_collection_map {
    relationship: many_to_many
    sql_on: ${dim_shopify_product_collection_map.glew_account_id} = ${fact_shopify_products.glew_account_id}
      and ${dim_shopify_product_collection_map.product_id} = ${fact_shopify_products.base_product_id};;
    type:  left_outer
  }
  join: dim_shopify_collections {
    relationship: many_to_one
    sql_on: ${dim_shopify_product_collection_map.glew_account_id} = ${dim_shopify_collections.glew_account_id}
      and ${dim_shopify_product_collection_map.collection_id} = ${dim_shopify_collections.collection_id};;
    type:  left_outer
  }
}
