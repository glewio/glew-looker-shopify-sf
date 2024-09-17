view: dim_shopify_fulfillment_item_property {
  sql_table_name: dim_shopify_fulfillment_item_property ;;
  view_label: "Shopify Fulfilment Item Properties"

  dimension: primary_key {
    type: string
    sql: CONCAT(${glew_account_id},${fulfillment_item_id},${name}) ;;
    primary_key: yes
    hidden: yes
  }

  dimension: fulfillment_item_id {
    type: number
    value_format: "0"
    sql: ${TABLE}.fulfillment_item_id ;;
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

  dimension: value {
    type: string
    sql: ${TABLE}.value ;;
  }
}
