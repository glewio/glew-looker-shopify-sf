connection: "snowflake_dev"
include: "/**/*.view.lkml"                 # include all views in this project
include: "//glew_looker_glew/views/*.view.lkml"


explore: fact_shopify_fulfillment_order_items {
  access_filter: {
    field: glew_account_id
    user_attribute: glew_account_id
  }
  label: "Fulfillment Orders"
  group_label: "Shopify"
  description: "View/Report on your Shopify fulfillment orders data with this explore. Please note that this is a special request explore that requires private app set-up and additional permissions. Please contact your account manager to assist in getting this set up."

  join: dim_glew_accounts {
    relationship: many_to_one
    sql_on: ${fact_shopify_fulfillment_order_items.glew_account_id} = ${dim_glew_accounts.glew_account_id} ;;
    type: left_outer
  }
  join: fact_shopify_fulfillment_orders {
    relationship: many_to_one
    sql_on: ${fact_shopify_fulfillment_orders.glew_account_id} = ${fact_shopify_fulfillment_order_items.glew_account_id}
      and ${fact_shopify_fulfillment_orders.fulfillment_order_id} = ${fact_shopify_fulfillment_order_items.fulfillment_order_id};;
    type:  left_outer
  }
  join: fact_shopify_products {
    relationship: many_to_one
    sql_on: ${fact_shopify_products.glew_account_id} = ${fact_shopify_fulfillment_order_items.glew_account_id}
      and ${fact_shopify_products.product_id} = ${fact_shopify_fulfillment_order_items.variant_id};;
    type:  left_outer
  }
  join: fact_shopify_orders {
    relationship: many_to_one
    sql_on: ${fact_shopify_orders.glew_account_id} = ${fact_shopify_fulfillment_orders.glew_account_id}
      and ${fact_shopify_orders.order_id} = ${fact_shopify_fulfillment_orders.order_id};;
    type:  left_outer
  }
  join: fact_shopify_order_items {
    relationship: many_to_one
    sql_on: ${fact_shopify_order_items.glew_account_id} = ${fact_shopify_fulfillment_order_items.glew_account_id}
      and ${fact_shopify_order_items.line_item_id} = ${fact_shopify_fulfillment_order_items.line_item_id};;
    type:  left_outer
  }
  join: dim_shopify_fulfillment_item_property {
    relationship: one_to_many
    sql_on: ${dim_shopify_fulfillment_item_property.glew_account_id} = ${fact_shopify_fulfillment_order_items.glew_account_id}
      and ${dim_shopify_fulfillment_item_property.fulfillment_item_id} = ${fact_shopify_fulfillment_order_items.line_item_id};;
    type:  left_outer
  }
}
