view: dim_shopify_product_meta {
  sql_table_name: dim_shopify_product_meta ;;
  view_label: "Shopify Product Meta"

  dimension: primary_key {
    type: string
    sql: CONCAT(${glew_account_id},${product_id},${product_meta_id}) ;;
    primary_key: yes
    hidden: yes
  }

  dimension_group: created {
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
    sql: ${TABLE}.created_at ;;
  }

  dimension: description {
    type: string
    sql: ${TABLE}.description ;;
  }

  dimension: glew_account_id {
    type: number
    value_format: "0"
    sql: ${TABLE}.glew_account_id ;;
  }

  dimension: key {
    type: string
    sql: ${TABLE}.key ;;
  }

  dimension: namespace {
    type: string
    sql: ${TABLE}.namespace ;;
  }

  dimension: product_id {
    type: number
    value_format: "0"
    sql: ${TABLE}.product_id ;;
  }

  dimension: product_meta_id {
    type: number
    value_format: "0"
    sql: ${TABLE}.product_meta_id ;;
  }

  dimension_group: updated {
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
  }

  dimension: value {
    type: string
    sql: ${TABLE}.value ;;
  }
}
