connection: "silo_routing"
include: "/**/*.view.lkml"                 # include all views in this project
include: "//glew_looker_glew/views/*.view.lkml"

explore: fact_shopify_products {
  access_filter: {
    field: glew_account_id
    user_attribute: glew_account_id
  }
  label: "Products"
  group_label: "Shopify"
  description: "View/Report on your Shopify product data including product tags and categories with this explore"

  join: dim_glew_accounts {
    relationship: many_to_one
    sql_on: ${fact_shopify_products.glew_account_id} = ${dim_glew_accounts.glew_account_id} ;;
    type: left_outer
  }
  join: dim_shopify_product_category_map {
    relationship: one_to_many
    sql_on: ${fact_shopify_products.glew_account_id} = ${dim_shopify_product_category_map.glew_account_id}
      and ${fact_shopify_products.product_id} = ${dim_shopify_product_category_map.product_id};;
    type:  left_outer
  }
  join: dim_shopify_product_collection_map {
    relationship: one_to_many
    sql_on: ${fact_shopify_products.glew_account_id} = ${dim_shopify_product_collection_map.glew_account_id}
      and ${fact_shopify_products.base_product_id} = ${dim_shopify_product_collection_map.product_id};;
    type:  left_outer
  }
  join: dim_shopify_collections {
    relationship: many_to_one
    sql_on: ${dim_shopify_collections.glew_account_id} = ${dim_shopify_product_collection_map.glew_account_id}
      and ${dim_shopify_collections.collection_id} = ${dim_shopify_product_collection_map.collection_id};;
    type:  left_outer
  }
}
