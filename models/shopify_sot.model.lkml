connection: "silo_routing"
include: "/**/*.view.lkml"                 # include all views in this project
include: "//glew_looker_glew/views/*.view.lkml"
include: "//glew_looker_shopify/views/*.view.lkml"


explore:  mv_shopify_sales {
  access_filter: {
    field: glew_account_id
    user_attribute: glew_account_id
  }
  label: "Shopify Sales Over Time"
  group_label: "Shopify"
  description: "View/Report on your Shopify transaction data on the order and order product level with this explore"

  join: dim_glew_accounts {
    relationship: many_to_one
    sql_on: ${mv_shopify_sales.glew_account_id} = ${dim_glew_accounts.glew_account_id} ;;
    type: left_outer
  }
  join: fact_shopify_orders {
    relationship: many_to_one
    sql_on: ${fact_shopify_orders.glew_account_id} = ${mv_shopify_sales.glew_account_id}
      and ${fact_shopify_orders.order_id} = ${mv_shopify_sales.order_id}  ;;
    type: left_outer
  }
  join: fact_shopify_products {
    relationship: many_to_one
    sql_on: ${fact_shopify_products.glew_account_id} = ${mv_shopify_sales.glew_account_id}
      and ${fact_shopify_products.product_id} = ${mv_shopify_sales.product_id}  ;;
    type: left_outer
  }
  join: dim_shopify_customers {
    relationship: many_to_one
    sql_on: ${dim_shopify_customers.glew_account_id} = ${fact_shopify_orders.glew_account_id}
      and ${dim_shopify_customers.customer_id} = ${fact_shopify_orders.customer_id}  ;;
    type: left_outer
  }
  join: dim_shopify_base_products {
    relationship: many_to_one
    sql_on: ${dim_shopify_base_products.glew_account_id} = ${mv_shopify_sales.glew_account_id}
      and ${dim_shopify_base_products.base_product_id} = ${mv_shopify_sales.base_product_id}  ;;
    type: left_outer
  }
  join: fact_shopify_fulfillments {
    relationship: many_to_one
    sql_on: ${fact_shopify_fulfillments.glew_account_id} = ${mv_shopify_sales.glew_account_id}
      and ${fact_shopify_fulfillments.order_id} = ${mv_shopify_sales.order_id};;
    type:  left_outer
  }
  join: fact_shopify_fulfillment_items {
    relationship: one_to_one
    sql_on: ${mv_shopify_sales.glew_account_id} = ${fact_shopify_fulfillment_items.glew_account_id}
      and ${mv_shopify_sales.order_id} = ${fact_shopify_fulfillment_items.order_id}
      and ${mv_shopify_sales.product_id} = ${fact_shopify_fulfillment_items.variant_id};;
    type:  left_outer
  }
  join: dim_shopify_product_meta {
    relationship: one_to_many
    sql_on: ${dim_shopify_product_meta.glew_account_id} = ${fact_shopify_products.glew_account_id}
      and ${dim_shopify_product_meta.product_id} = ${fact_shopify_products.base_product_id};;
    type:  left_outer
  }
  join: shopify_order_number {
    relationship: one_to_one
    sql_on: ${fact_shopify_orders.glew_account_id} = ${shopify_order_number.glew_account_id}
      and ${fact_shopify_orders.order_id} = ${shopify_order_number.order_id}
      and ${fact_shopify_orders.customer_id} = ${shopify_order_number.customer_id};;
    type:  left_outer
  }
  join: fact_shopify_order_items {
    relationship: one_to_one
    sql_on: ${fact_shopify_order_items.glew_account_id} = ${mv_shopify_sales.glew_account_id}
      and ${fact_shopify_order_items.order_id} = ${mv_shopify_sales.order_id}
      and ${fact_shopify_order_items.line_item_id} = ${mv_shopify_sales.line_item_id};;
    type:  left_outer
  }
  join: fact_shopify_order_coupons {
    relationship: one_to_many
    sql_on: ${fact_shopify_order_coupons.glew_account_id} = ${fact_shopify_orders.glew_account_id}
      and ${fact_shopify_order_coupons.order_id} = ${fact_shopify_orders.order_id};;
    type:  left_outer
  }
  join: dim_shopify_product_category_map {
    relationship: many_to_many
    sql_on: ${dim_shopify_product_category_map.glew_account_id} = ${mv_shopify_sales.glew_account_id}
      and ${dim_shopify_product_category_map.product_id} = ${mv_shopify_sales.product_id};;
    type:  left_outer
  }
  join: dim_shopify_order_tag_map {
    relationship: one_to_many
    sql_on: ${dim_shopify_order_tag_map.glew_account_id} = ${fact_shopify_orders.glew_account_id}
      and ${dim_shopify_order_tag_map.order_id} = ${fact_shopify_orders.order_id};;
    type:  left_outer
  }
}
