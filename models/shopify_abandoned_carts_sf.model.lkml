connection: "snowflake_dev"
include: "/**/*.view.lkml"                 # include all views in this project
include: "//glew_looker_glew/views/*.view.lkml"


explore: fact_shopify_abandoned_cart_products {
  access_filter: {
    field: glew_account_id
    user_attribute: glew_account_id
  }
  label: "Abandoned Carts"
  group_label: "Shopify"
  description: "View/Report on your Shopify abandoned carts and abandoned cart products data with this explore"

  join: dim_glew_accounts {
    relationship: many_to_one
    sql_on: ${fact_shopify_abandoned_cart_products.glew_account_id} = ${dim_glew_accounts.glew_account_id} ;;
    type: left_outer
  }
  join: fact_shopify_abandoned_carts {
    relationship: many_to_one
    sql_on: ${fact_shopify_abandoned_carts.glew_account_id} = ${fact_shopify_abandoned_cart_products.glew_account_id}
      and ${fact_shopify_abandoned_carts.cart_id} = ${fact_shopify_abandoned_cart_products.cart_id};;
    type:  left_outer
  }
  join: fact_shopify_products {
    relationship: many_to_one
    sql_on: ${fact_shopify_products.glew_account_id} = ${fact_shopify_abandoned_cart_products.glew_account_id}
      and ${fact_shopify_products.product_id} = ${fact_shopify_abandoned_cart_products.product_id};;
    type:  left_outer
  }
 }
