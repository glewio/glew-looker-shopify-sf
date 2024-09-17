connection: "silo_routing"
include: "/**/*.view.lkml"                 # include all views in this project
include: "//glew_looker_glew/views/*.view.lkml"

explore: fact_shopify_customer_events {
  access_filter: {
    field: glew_account_id
    user_attribute: glew_account_id
  }
  label: "Customer Events"
  group_label: "Shopify"
  description: "View/Report on your Shopify customer related events including orders, refunds, and account creation with this explore"

  join: dim_glew_accounts {
    relationship: many_to_one
    sql_on: ${fact_shopify_customer_events.glew_account_id} = ${dim_glew_accounts.glew_account_id} ;;
    type: left_outer
  }
  join: fact_exchange_rates {
    relationship: one_to_one
    sql_on: ${fact_exchange_rates.base} = ${dim_glew_accounts.currency}
      and ${fact_exchange_rates.timestamp_date} = ${fact_shopify_customer_events.event_date};;
  }
  join: dim_shopify_customers {
    relationship: many_to_one
    sql_on: ${dim_shopify_customers.glew_account_id} = ${fact_shopify_customer_events.glew_account_id}
      and ${dim_shopify_customers.email} = ${fact_shopify_customer_events.customer_email};;
    type:  left_outer
  }
}
