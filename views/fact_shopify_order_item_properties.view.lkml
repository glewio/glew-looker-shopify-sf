view: fact_shopify_order_item_properties {
  sql_table_name: fact_shopify_order_item_properties ;;
  view_label: "Shopify Order Item Properties"


  dimension: primary_key {
    type: string
    sql:CONCAT(CONCAT(CAST(${line_item_id} as VARCHAR), CAST(${glew_account_id} as VARCHAR)),  CAST(${name} as VARCHAR)) ;;
    primary_key: yes
    hidden: yes
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: line_item_id {
    type: number
    value_format: "0"
    sql: ${TABLE}.line_item_id ;;
  }

  dimension: glew_account_id {
    type: number
    value_format: "0"
    sql: ${TABLE}.glew_account_id ;;
  }

  dimension: value {
    type: string
    sql: ${TABLE}.value ;;
  }
}
