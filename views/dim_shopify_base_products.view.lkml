view: dim_shopify_base_products {
  sql_table_name: dim_shopify_base_products ;;
  view_label: "Shopify Base Products"

  dimension: primary_key {
    type: string
    sql: CONCAT(${glew_account_id},${base_product_id}) ;;
    primary_key: yes
    hidden: yes
  }

  dimension: base_product_id {
    type: number
    value_format: "0"
    sql: ${TABLE}.base_product_id ;;
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
    drill_fields: [created_year,created_quarter,created_month,created_week,created_date]
  }

  dimension: glew_account_id {
    type: number
    value_format: "0"
    sql: ${TABLE}.glew_account_id ;;
  }

  dimension: image_url {
    type: string
    sql: ${TABLE}.image ;;
  }
  dimension: image_display {
    sql: ${base_product_id} ;;
    html: <img src= {{ image_url }} height=80 /> ;;
  }

  dimension: manufacturer {
    type: string
    sql: ${TABLE}.manufacturer ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension_group: published {
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
    sql: ${TABLE}.published_at ;;
    drill_fields: [published_year,published_quarter,published_month,published_week,published_date]
  }

  dimension: quantity_left {
    type: number
    group_label: "Glew Custom Measure"
    sql: ${TABLE}.quantity_left ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: type {
    type: string
    sql: ${TABLE}.type ;;
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
    drill_fields: [updated_year,updated_quarter,updated_month,updated_week,updated_date]
  }

  measure: number_of_base_products {
    type: count_distinct
    sql: ${base_product_id} ;;
    description: "Distinct Count of Base Product ID"
  }

  measure: sum_of_quantity_left {
    type: sum
    sql: ${TABLE}.quantity_left ;;
  }
}
