view: fact_shopify_fulfillments {
  sql_table_name: fact_shopify_fulfillments ;;
  view_label: "Shopify Fulfillments"

  dimension: primary_key {
    type: string
    sql:CONCAT(CONCAT(CAST(${order_id} as VARCHAR), CAST(${glew_account_id} as VARCHAR)),  CAST(${fulfillment_id} as VARCHAR)) ;;
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

  dimension: glew_account_id {
    type: number
    value_format: "0"
    sql: ${TABLE}.glew_account_id ;;
  }

  dimension: location_id {
    type: number
    value_format: "0"
    sql: ${TABLE}.location_id ;;
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

  dimension: order_number {
    type: string
    sql: ${TABLE}.order_number ;;
  }

  dimension: service {
    type: string
    sql: ${TABLE}.service ;;
  }

  dimension: shipment_status {
    type: string
    sql: ${TABLE}.shipment_status ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
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

  dimension: tracking_company {
    type: string
    sql: ${TABLE}.tracking_company ;;
  }

  dimension: tracking_number {
    type: string
    sql: ${TABLE}.tracking_number ;;
  }

  dimension_group: updated_at {
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
    sql: ${TABLE}.updated_at ;;
    drill_fields: [updated_at_year,updated_at_quarter,updated_at_month,updated_at_week,updated_at_date]
  }
  measure: number_of_fulfillments {
    type: count_distinct
    sql: ${fulfillment_id} ;;
    description: "Distinct Count of Fulfillment ID"
  }
}
