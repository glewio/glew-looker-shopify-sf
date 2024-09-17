view: fact_shopify_fulfillment_order_items {
  sql_table_name: fact_shopify_fulfillment_order_items ;;
  view_label: "Shopify Fulfillment Order Items"

  dimension: primary_key {
    type: string
    sql:CONCAT(CAST(${order_item_id} as VARCHAR), CAST(${glew_account_id} as VARCHAR));;
    primary_key: yes
    hidden: yes
  }

  dimension: order_item_id {
    type: number
    value_format: "0"
    sql: ${TABLE}.order_item_id ;;
  }

  dimension: glew_account_id {
    type: number
    value_format: "0"
    sql: ${TABLE}.glew_account_id ;;
  }

  dimension: shop_id {
    type: number
    value_format: "0"
    sql: ${TABLE}.shop_id ;;
  }

  dimension: fulfillment_order_id {
    type: number
    value_format: "0"
    sql: ${TABLE}.fulfillment_order_id ;;
  }

  dimension: quantity {
    type: number
    group_label: "Glew Custom Measure"
    sql: ${TABLE}.quantity ;;
  }

  dimension: line_item_id {
    type: number
    value_format: "0"
    sql: ${TABLE}.line_item_id ;;
  }

  dimension: inventory_item_id {
    type: number
    value_format: "0"
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: fulfillable_quantity {
    type: number
    group_label: "Glew Custom Measure"
    sql: ${TABLE}.fulfillable_quantity ;;
  }

  dimension: variant_id {
    type: number
    value_format: "0"
    sql: ${TABLE}.variant_id ;;
  }
  measure: number_of_fulfillment_order_items {
    type: count_distinct
    sql: ${order_item_id} ;;
    description: "Distinct Count of Order Item ID"
  }
  measure: sum_of_quantity {
    type: sum
    sql: ${TABLE}.quantity ;;
  }
  measure: sum_of_fulfillable_quantity {
    type: sum
    sql: ${TABLE}.fulfillable_quantity ;;
  }
}
