connection: "snowflake_dev"
include: "/**/*.view.lkml"                 # include all views in this project
include: "//glew_looker_glew/views/*.view.lkml"


explore: fact_shopify_order_items {
  access_filter: {
    field: glew_account_id
    user_attribute: glew_account_id
  }
  label: "Orders"
  group_label: "Shopify"
  description: "View/Report on your Shopify transaction data on the order and order product level with this explore"

  join: dim_glew_accounts {
    relationship: many_to_one
    sql_on: ${fact_shopify_order_items.glew_account_id} = ${dim_glew_accounts.glew_account_id} ;;
    type: left_outer
  }
  join: dim_calender_dates {
    relationship: many_to_one
    sql_on: ${fact_shopify_order_items.order_date} = ${dim_calender_dates.alternate_day_start_date} ;;
    type: left_outer
  }
  join: fact_exchange_rates {
    relationship: one_to_one
    sql_on: ${fact_exchange_rates.base} = ${dim_glew_accounts.currency}
      and ${fact_exchange_rates.timestamp_date} = ${fact_shopify_order_items.order_date};;
  }
  join: fact_shopify_orders {
    relationship: many_to_one
    sql_on: ${fact_shopify_orders.glew_account_id} = ${fact_shopify_order_items.glew_account_id}
      and ${fact_shopify_orders.order_id} = ${fact_shopify_order_items.order_id};;
    type:  left_outer
  }
  join: fact_shopify_order_coupons {
    relationship: one_to_many
    sql_on: ${fact_shopify_orders.glew_account_id} = ${fact_shopify_order_coupons.glew_account_id}
      and ${fact_shopify_orders.order_id} = ${fact_shopify_order_coupons.order_id};;
    type:  left_outer
  }
  join: fact_shopify_tender_transactions {
    relationship: one_to_many
    sql_on: ${fact_shopify_orders.glew_account_id} = ${fact_shopify_tender_transactions.glew_account_id}
      and ${fact_shopify_orders.order_id} = ${fact_shopify_tender_transactions.order_id};;
    type:  left_outer
  }
  join: fact_shopify_fulfillments {
    relationship: one_to_many
    sql_on: ${fact_shopify_fulfillments.glew_account_id} = ${fact_shopify_orders.glew_account_id}
      and ${fact_shopify_fulfillments.order_id} = ${fact_shopify_orders.order_id};;
    type:  left_outer
  }
  join: fact_shopify_fulfillment_items {
    relationship: one_to_many
    sql_on: ${fact_shopify_fulfillments.glew_account_id} = ${fact_shopify_fulfillment_items.glew_account_id}
      and ${fact_shopify_fulfillments.fulfillment_id} = ${fact_shopify_fulfillment_items.fulfillment_id};;
    type:  left_outer
  }
  join: fact_shopify_fulfillment_orders {
    relationship: one_to_one
    sql_on: ${fact_shopify_fulfillment_orders.glew_account_id} = ${fact_shopify_orders.glew_account_id}
      and ${fact_shopify_fulfillment_orders.order_id} = ${fact_shopify_orders.order_id};;
    type:  left_outer
  }
  join: fact_shopify_products {
    relationship: many_to_one
    sql_on: ${fact_shopify_products.glew_account_id} = ${fact_shopify_order_items.glew_account_id}
      and ${fact_shopify_products.product_id} = ${fact_shopify_order_items.product_id};;
    type:  left_outer
  }
  join: dim_shopify_base_products {
    relationship: many_to_one
    sql_on: ${dim_shopify_base_products.glew_account_id} = ${fact_shopify_order_items.glew_account_id}
      and ${dim_shopify_base_products.base_product_id} = ${fact_shopify_order_items.base_product_id};;
    type:  left_outer
  }
  join: dim_shopify_customers {
    relationship: many_to_one
    sql_on: ${dim_shopify_customers.glew_account_id} = ${fact_shopify_orders.glew_account_id}
      and ${dim_shopify_customers.email} = ${fact_shopify_orders.customer_email};;
    type:  left_outer
  }
  join: dim_shopify_order_tag_map {
    relationship: one_to_many
    sql_on: ${dim_shopify_order_tag_map.glew_account_id} = ${fact_shopify_orders.glew_account_id}
      and ${dim_shopify_order_tag_map.order_id} = ${fact_shopify_orders.order_id};;
    type:  left_outer
  }
  join: dim_shopify_customer_group_map {
    relationship: many_to_many
    sql_on: ${dim_shopify_customer_group_map.glew_account_id} = ${fact_shopify_orders.glew_account_id}
      and ${dim_shopify_customer_group_map.email} = ${fact_shopify_orders.customer_email};;
    type:  left_outer
  }
  join: shopify_order_number {
    relationship: one_to_one
    sql_on: ${fact_shopify_orders.glew_account_id} = ${shopify_order_number.glew_account_id}
      and ${fact_shopify_orders.order_id} = ${shopify_order_number.order_id}
      and ${fact_shopify_orders.customer_id} = ${shopify_order_number.customer_id};;
    type:  left_outer
  }
  join: dim_shopify_product_category_map {
    relationship: many_to_many
    sql_on: ${dim_shopify_product_category_map.glew_account_id} = ${fact_shopify_order_items.glew_account_id}
      and ${dim_shopify_product_category_map.product_id} = ${fact_shopify_order_items.product_id};;
    type:  left_outer
  }
  join: dim_shopify_product_collection_map {
    relationship: many_to_many
    sql_on: ${dim_shopify_product_collection_map.glew_account_id} = ${fact_shopify_order_items.glew_account_id}
      and ${dim_shopify_product_collection_map.product_id} = ${fact_shopify_order_items.base_product_id};;
    type:  left_outer
  }
  join: dim_shopify_collections {
    relationship: many_to_one
    sql_on: ${dim_shopify_product_collection_map.glew_account_id} = ${dim_shopify_collections.glew_account_id}
      and ${dim_shopify_product_collection_map.collection_id} = ${dim_shopify_collections.collection_id};;
    type:  left_outer
  }
  join: fact_shopify_order_item_properties {
    relationship: one_to_many
    sql_on: ${fact_shopify_order_item_properties.glew_account_id} = ${fact_shopify_order_items.glew_account_id}
      and ${fact_shopify_order_item_properties.line_item_id} = ${fact_shopify_order_items.line_item_id};;
    type:  left_outer
  }
  join: dim_shopify_order_note_attributes {
    relationship: one_to_many
    sql_on: ${dim_shopify_order_note_attributes.glew_account_id} = ${fact_shopify_orders.glew_account_id}
      and ${dim_shopify_order_note_attributes.order_id} = ${fact_shopify_orders.order_id};;
    type:  left_outer
  }
  join: dim_shopify_product_meta {
    relationship: many_to_many
    sql_on: ${dim_shopify_product_meta.glew_account_id} = ${fact_shopify_order_items.glew_account_id}
      and ${dim_shopify_product_meta.product_id} = ${fact_shopify_order_items.base_product_id};;
    type:  left_outer
  }
  join: dim_shopify_variant_meta {
    relationship: many_to_many
    sql_on: ${dim_shopify_variant_meta.glew_account_id} = ${fact_shopify_order_items.glew_account_id}
      and ${dim_shopify_variant_meta.variant_id} = ${fact_shopify_order_items.product_id};;
    type:  left_outer
  }
  join: dim_shopify_order_payment_method {
    relationship: many_to_one
    sql_on: ${dim_shopify_order_payment_method.glew_account_id} = ${fact_shopify_order_items.glew_account_id}
      and ${dim_shopify_order_payment_method.order_id} = ${fact_shopify_order_items.order_id};;
    type:  left_outer
  }
}
