view: fact_shopify_abandoned_carts {
  sql_table_name: fact_shopify_abandoned_carts ;;
  view_label: "Shopify Abandoned Carts"

  dimension: primary_key {
    type: string
    sql: CONCAT(${glew_account_id},${cart_id}) ;;
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
    sql: date_trunc('week', ${timestamp_date} + interval {% parameter week_start %}) - interval {% parameter week_start %};;
  }
  dimension: alternate_day_start {
    sql: to_char(date_trunc('Day',${timestamp_date} - interval {% parameter week_start %}), 'YYYY-MM-DD') ;;
  }

  dimension: cart_id {
    type: number
    value_format: "0"
    sql: ${TABLE}.cart_id ;;
  }

  dimension: glew_account_id {
    type: number
    value_format: "0"
    sql: ${TABLE}.glew_account_id ;;
  }

  dimension_group: timestamp {
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
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: total {
    type: number
    group_label: "Glew Custom Measure"
    sql: ${TABLE}.total ;;
  }

  dimension: discount {
    type: number
    group_label: "Glew Custom Measure"
    sql: ${TABLE}.discount ;;
  }

  dimension: customer_id {
    type: number
    value_format: "0"
    sql: ${TABLE}.customer_id ;;
  }
  measure: number_of_abandoned_carts {
    type: count_distinct
    sql: ${cart_id} ;;
    description: "Distinct Count of Cart ID"
  }
  measure: sum_of_total {
    type: sum
    sql: ${TABLE}.total ;;
  }

  measure: sum_of_discount {
    type: sum
    sql: ${TABLE}.discount ;;
  }
}
