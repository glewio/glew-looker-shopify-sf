view: fact_shopify_fulfillment_orders {
  sql_table_name: fact_shopify_fulfillment_orders ;;
  view_label: "Shopify Fulfillment Orders"

  dimension: primary_key {
    type: string
    sql:CONCAT(CAST(${fulfillment_order_id} as VARCHAR), CAST(${glew_account_id} as VARCHAR));;
    primary_key: yes
    hidden: yes
  }


  dimension: fulfillment_order_id {
    type: number
    value_format: "0"
    sql: ${TABLE}.fulfillment_order_id ;;
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

  dimension: order_id {
    type: number
    value_format: "0"
    sql: ${TABLE}.order_id ;;
  }

  dimension: assigned_location_id {
    type: number
    value_format: "0"
    sql: ${TABLE}.assigned_location_id ;;
  }

  dimension: request_status {
    type: string
    sql: ${TABLE}.request_status ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension_group: fulfill_at {
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
    sql: ${TABLE}.fulfill_at ;;
    drill_fields: [fulfill_at_year,fulfill_at_quarter,fulfill_at_month,fulfill_at_week,fulfill_at_date]
  }

  dimension: delivery_method_id {
    type: number
    value_format: "0"
    sql: ${TABLE}.delivery_method_id ;;
  }

  dimension: delivery_method_method_type {
    type: string
    sql: ${TABLE}.delivery_method_method_type ;;
  }

  dimension: assigned_location_address1 {
    type: string
    sql: ${TABLE}.assigned_location_address1 ;;
  }

  dimension: assigned_location_address2 {
    type: string
    sql: ${TABLE}.assigned_location_address2 ;;
  }

  dimension: assigned_location_city {
    type: string
    sql: ${TABLE}.assigned_location_city ;;
  }

  dimension: assigned_location_country_code {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.assigned_location_country_code ;;
  }

  dimension: assigned_location_location_id {
    type: number
    value_format: "0"
    sql: ${TABLE}.assigned_location_location_id ;;
  }

  dimension: assigned_location_name {
    type: string
    sql: ${TABLE}.assigned_location_name ;;
  }

  dimension: assigned_location_phone {
    type: string
    sql: ${TABLE}.assigned_location_phone ;;
  }

  dimension: assigned_location_province {
    type: string
    map_layer_name: us_states
    sql: ${TABLE}.assigned_location_province ;;
  }

  dimension: assigned_location_zip {
    type: zipcode
    map_layer_name: us_zipcode_tabulation_areas
    sql: ${TABLE}.assigned_location_zip ;;
  }
  measure: number_of_fulfillment_orders {
   type: count_distinct
    sql: ${fulfillment_order_id} ;;
    description: "Distinct Count of Fulfillment Order ID"
  }
}
