connection: "snowflake_dev"
include: "/**/*.view.lkml"                 # include all views in this project
include: "//glew_looker_glew/views/*.view.lkml"

explore: fact_shopify_channel_spends {
  access_filter: {
    field: glew_account_id
    user_attribute: glew_account_id
  }
  label: "Channel Spends"
  group_label: "Shopify"
  description: "View/Report on your Shopify breakdown of advertising spend by channel and date with this explore"

  join: dim_glew_accounts {
    relationship: many_to_one
    sql_on: ${fact_shopify_channel_spends.glew_account_id} = ${dim_glew_accounts.glew_account_id} ;;
    type: left_outer
  }
  join: fact_exchange_rates {
    relationship: one_to_one
    sql_on: ${fact_exchange_rates.base} = ${dim_glew_accounts.currency}
      and ${fact_exchange_rates.timestamp_date} = ${fact_shopify_channel_spends.spend_date};;
  }
}
