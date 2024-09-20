connection: "snowflake_dev"
include: "/**/*.view.lkml"                 # include all views in this project
include: "//glew_looker_glew/views/*.view.lkml"

explore: dim_shopify_customers {
  access_filter: {
    field: glew_account_id
    user_attribute: glew_account_id
  }
  label: "Customers"
  group_label: "Shopify"
  description: "View/Report on your Shopify customer level data including customer tags with this explore"

  join: dim_glew_accounts {
    relationship: many_to_one
    sql_on: ${dim_shopify_customers.glew_account_id} = ${dim_glew_accounts.glew_account_id} ;;
    type: left_outer
  }
  join: dim_shopify_customer_group_map {
    relationship: one_to_many
    sql_on: ${dim_shopify_customers.glew_account_id} = ${dim_shopify_customer_group_map.glew_account_id}
      and ${dim_shopify_customers.email} = ${dim_shopify_customer_group_map.email};;
    type:  left_outer
  }
}
