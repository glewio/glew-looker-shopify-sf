view: dim_shopify_order_note_attributes {
  sql_table_name: dim_shopify_order_note_attributes ;;
  view_label: "Shopify Order Note Attributes"

  dimension: primary_key {
    type: string
    sql: CONCAT(${glew_account_id},${order_id},${name}) ;;
    primary_key: yes
    hidden: yes
  }

  dimension: glew_account_id {
    type: number
    value_format: "0"
    sql: ${TABLE}.glew_account_id ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: order_id {
    type: number
    value_format: "0"
    sql: ${TABLE}.order_id ;;
  }

  dimension: value {
    type: string
    sql: ${TABLE}.value ;;
  }
}
