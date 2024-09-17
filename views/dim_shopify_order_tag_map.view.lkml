view: dim_shopify_order_tag_map {
  sql_table_name: dim_shopify_order_tag_map ;;
  view_label: "Shopify Order Tag Map"


  dimension: primary_key {
    type: string
    sql:CONCAT(CONCAT(CAST(${order_id} as VARCHAR), CAST(${glew_account_id} as VARCHAR)),  CAST(${order_tag} as VARCHAR)) ;;
    primary_key: yes
    hidden: yes
  }

  dimension: customer_email {
    type: string
    sql: ${TABLE}.customer_email ;;
  }

  dimension: customer_id {
    type: number
    value_format: "0"
    sql: ${TABLE}.customer_id ;;
  }

  dimension: glew_account_id {
    type: number
    value_format: "0"
    sql: ${TABLE}.glew_account_id ;;
  }

  dimension: order_id {
    type: number
    value_format: "0"
    sql: ${TABLE}.order_id ;;
  }

  dimension: order_tag {
    type: string
    sql: ${TABLE}.order_tag ;;
  }

  measure: number_of_order_tags {
    type: count_distinct
    sql: ${order_tag} ;;
    description: "Distinct Count of Order Tag"
  }
}
