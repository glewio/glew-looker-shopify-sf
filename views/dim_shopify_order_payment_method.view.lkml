view: dim_shopify_order_payment_method {
  sql_table_name: dim_shopify_order_payment_method ;;
  view_label: "Shopify Order Payment Method"

  dimension: primary_key {
    type: string
    sql: CONCAT(${glew_account_id},${order_id},${payment_method}) ;;
    primary_key: yes
    hidden: yes
  }

  dimension: glew_account_id {
    type: number
    sql: ${TABLE}.glew_account_id ;;
  }
  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
  }
  dimension: payment_method {
    type: string
    sql: ${TABLE}.payment_method ;;
  }
}
