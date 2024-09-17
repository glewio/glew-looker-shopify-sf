connection: "silo_routing"
include: "/**/*.view.lkml"                 # include all views in this project
include: "//glew_looker_glew/views/*.view.lkml"

explore: fact_shopify_refund_line_items {
  access_filter: {
    field: glew_account_id
    user_attribute: glew_account_id
  }
  label: "Refunds"
  group_label: "Shopify"
  description: "View/Report on your Shopify refund transaction data on the order and order product level with this explore"

  join: dim_glew_accounts {
    relationship: many_to_one
    sql_on: ${fact_shopify_refund_line_items.glew_account_id} = ${dim_glew_accounts.glew_account_id} ;;
    type: left_outer
  }
  join: fact_exchange_rates {
    relationship: one_to_one
    sql_on: ${fact_exchange_rates.base} = ${dim_glew_accounts.currency}
      and ${fact_exchange_rates.timestamp_date} = ${fact_shopify_refund_line_items.refund_date};;
  }
  join: fact_shopify_refunds {
    relationship: many_to_one
    sql_on: ${fact_shopify_refunds.glew_account_id} = ${fact_shopify_refund_line_items.glew_account_id}
      and ${fact_shopify_refunds.refund_id} = ${fact_shopify_refund_line_items.refund_id};;
    type:  left_outer
  }
  join: fact_shopify_products {
    relationship: many_to_one
    sql_on: ${fact_shopify_products.glew_account_id} = ${fact_shopify_refund_line_items.glew_account_id}
      and ${fact_shopify_products.product_id} = ${fact_shopify_refund_line_items.product_id};;
    type:  left_outer
  }
  join: dim_shopify_product_category_map {
    relationship: one_to_many
    sql_on: ${fact_shopify_products.glew_account_id} = ${dim_shopify_product_category_map.glew_account_id}
      and ${fact_shopify_products.product_id} = ${dim_shopify_product_category_map.product_id};;
    type:  left_outer
  }
  join: fact_shopify_order_coupons {
    relationship: many_to_many
    sql_on: ${fact_shopify_order_coupons.glew_account_id} = ${fact_shopify_refunds.glew_account_id}
      and ${fact_shopify_order_coupons.order_id} = ${fact_shopify_refunds.order_id};;
    type:  left_outer
  }
}
