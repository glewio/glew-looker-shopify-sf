view: fact_shopify_fulfillment_items {
  sql_table_name: fact_shopify_fulfillment_items ;;
  view_label: "Shopify Fulfillment Items"

  dimension: primary_key {
    type: string
    sql:CONCAT(CONCAT(CAST(${fulfillment_item_id} as VARCHAR), CAST(${glew_account_id} as VARCHAR)),  CAST(${fulfillment_id} as VARCHAR)) ;;
    primary_key: yes
    hidden: yes
  }

  parameter: week_start {
    type: string
    allowed_value: {
      label: "Monday"
      value: "0 day"
    }
    allowed_value: {
      label: "Tuesday"
      value: "6 day"
    }
    allowed_value: {
      label: "Wednesday"
      value: "5 day"
    }
    allowed_value: {
      label: "Thursday"
      value: "4 day"
    }
    allowed_value: {
      label: "Friday"
      value: "3 day"
    }
    allowed_value: {
      label: "Saturday"
      value: "2 day"
    }
    allowed_value: {
      label: "Sunday"
      value: "1 day"
    }
  }

  dimension: alternate_week_start {
    sql: date_trunc('week', ${fulfillment_date} + interval {% parameter week_start %}) - interval {% parameter week_start %};;
  }
  dimension: alternate_day_start {
    sql: to_char(date_trunc('Day',${fulfillment_date} - interval {% parameter week_start %}), 'YYYY-MM-DD') ;;
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

  dimension: fulfillment_id {
    type: number
    value_format: "0"
    sql: ${TABLE}.fulfillment_id ;;
  }

  dimension: fulfillment_item_id {
    type: number
    value_format: "0"
    sql: ${TABLE}.fulfillment_item_id ;;
  }

  dimension: fulfillment_service {
    type: string
    sql: ${TABLE}.fulfillment_service ;;
  }

  dimension: fulfillment_status {
    type: string
    sql: ${TABLE}.fulfillment_status ;;
  }

  dimension: gift_card {
    type: yesno
    sql: ${TABLE}.gift_card ;;
  }

  dimension: glew_account_id {
    type: number
    value_format: "0"
    sql: ${TABLE}.glew_account_id ;;
  }

  dimension: location {
    type: string
    sql: ${TABLE}.location ;;
  }

  dimension: location_id {
    type: number
    value_format: "0"
    sql: ${TABLE}.location_id ;;
  }

  dimension: order_id {
    type: number
    value_format: "0"
    sql: ${TABLE}.order_id ;;
  }

  dimension: order_number {
    type: string
    sql: ${TABLE}.order_number ;;
  }

  dimension: pre_tax_price {
    type: number
    sql: ${TABLE}.pre_tax_price ;;
  }

  dimension: price {
    type: number
    sql: ${TABLE}.price ;;
  }

  dimension: product {
    type: string
    sql: ${TABLE}.product ;;
  }

  dimension: product_exists {
    type: yesno
    sql: ${TABLE}.product_exists ;;
  }

  dimension: product_id {
    type: number
    value_format: "0"
    sql: ${TABLE}.product_id ;;
  }

  dimension: product_variant {
    type: string
    sql: ${TABLE}.product_variant ;;
  }

  dimension: quantity {
    type: number
    group_label: "Glew Custom Measure"
    sql: ${TABLE}.quantity ;;
  }

  dimension: requires_shipping {
    type: yesno
    sql: ${TABLE}.requires_shipping ;;
  }

  dimension: shipment_status {
    type: string
    sql: ${TABLE}.shipment_status ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }

  dimension: taxable {
    type: yesno
    sql: ${TABLE}.taxable ;;
  }

  dimension_group: fulfillment {
    type: time
    timeframes: [raw,
      time,
      date,
      hour_of_day,
      day_of_week,
      day_of_week_index,
      day_of_month,
      day_of_year,
      week,
      week_of_year,
      month,
      month_name,
      month_num,
      quarter,
      year]
    sql: ${TABLE}.timestamp ;;
    drill_fields: [fulfillment_year,fulfillment_quarter,fulfillment_month,fulfillment_week,fulfillment_date]
  }

  dimension: total_discount {
    type: number
    group_label: "Glew Custom Measure"
    sql: ${TABLE}.total_discount ;;
  }

  dimension: tracking_company {
    type: string
    sql: ${TABLE}.tracking_company ;;
  }

  dimension: tracking_number {
    type: string
    sql: ${TABLE}.tracking_number ;;
  }

  dimension: variant_id {
    type: number
    value_format: "0"
    sql: ${TABLE}.variant_id ;;
  }

  dimension: vendor {
    type: string
    sql: ${TABLE}.vendor ;;
  }

  dimension: weight {
    type: number
    group_label: "Glew Custom Measure"
    sql: ${TABLE}.weight ;;
  }
  measure: number_of_fulfillment_items {
    type: count_distinct
    sql: ${fulfillment_item_id} ;;
    description: "Distinct Count of Fulfillment Item ID"
  }
  measure: sum_of_quantity {
    type: sum
    sql: ${TABLE}.quantity ;;
  }
  measure: sum_of_total_discount {
    type: sum
    sql: ${TABLE}.total_discount ;;
  }
  measure: sum_of_weight {
    type: sum
    sql: ${TABLE}.weight ;;
  }
}
