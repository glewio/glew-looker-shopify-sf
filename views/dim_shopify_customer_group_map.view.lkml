view: dim_shopify_customer_group_map {
  sql_table_name: dim_shopify_customer_group_map ;;
  view_label: "Shopify Customer Group Map"

  dimension: primary_key {
    type: string
    sql:CONCAT(CAST(${customer_group} as VARCHAR), CAST(${glew_account_id} as VARCHAR)) ;;
    primary_key: yes
    hidden: yes
  }

  dimension: customer_group {
    type: string
    sql: ${TABLE}.customer_group ;;
  }

  dimension: customer_id {
    type: number
    value_format: "0"
    sql: ${TABLE}.customer_id ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: glew_account_id {
    type: number
    value_format: "0"
    sql: ${TABLE}.glew_account_id ;;
  }

  measure: number_of_customer_groups {
    type: count_distinct
    sql: ${customer_group} ;;
    description: "Distinct Count of Customer Group"
  }
}
