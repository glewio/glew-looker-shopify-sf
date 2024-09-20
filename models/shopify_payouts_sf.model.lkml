connection: "snowflake_dev"
include: "/**/*.view.lkml"                 # include all views in this project
include: "//glew_looker_glew/views/*.view.lkml"

explore: fact_shopify_payouts {
  access_filter: {
    field: glew_account_id
    user_attribute: glew_account_id
  }
  label: "Payouts"
  group_label: "Shopify"

  join: dim_glew_accounts {
    relationship: many_to_one
    sql_on: ${fact_shopify_payouts.glew_account_id} = ${dim_glew_accounts.glew_account_id} ;;
    type: left_outer
  }
  join: fact_exchange_rates {
    relationship: one_to_one
    sql_on: ${fact_exchange_rates.base} = ${dim_glew_accounts.currency}
      and ${fact_exchange_rates.timestamp_date} = ${fact_shopify_payouts.timestamp_date};;
  }
  join: fact_shopify_payout_transactions {
    relationship: one_to_many
    sql_on: ${fact_shopify_payout_transactions.glew_account_id} = ${fact_shopify_payouts.glew_account_id}
      and ${fact_shopify_payout_transactions.payout_id} = ${fact_shopify_payouts.payout_id};;
  }
}
