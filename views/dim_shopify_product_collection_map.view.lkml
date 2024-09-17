view: dim_shopify_product_collection_map {
  sql_table_name: dim_shopify_product_collection_map ;;
  view_label: "Shopify Product Collection Map"

  dimension: primary_key {
    type: string
    sql: CONCAT(${glew_account_id},${collection_id},${collect_id}) ;;
    primary_key: yes
    hidden: yes
  }

  dimension: collect_id {
    type: number
    value_format: "0"
    sql: ${TABLE}.collect_id ;;
  }

  dimension: collection_id {
    type: number
    value_format: "0"
    sql: ${TABLE}.collection_id ;;
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
    sql: ${TABLE}.created_date ;;
    drill_fields: [created_year, created_quarter, created_month, created_week, created_date]
  }

  dimension: glew_account_id {
    type: number
    value_format: "0"
    sql: ${TABLE}.glew_account_id ;;
  }

  dimension: position {
    type: number
    sql: ${TABLE}.position ;;
  }

  dimension: product_id {
    type: number
    value_format: "0"
    sql: ${TABLE}.product_id ;;
  }

  dimension: sort_value {
    type: string
    sql: ${TABLE}.sort_value ;;
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
    sql: ${TABLE}.updated_date ;;
    drill_fields: [updated_year,updated_quarter,updated_month,updated_week,updated_date]
  }

  measure: number_of_product_collection_maps {
    type: count_distinct
    sql: ${collection_id} ;;
    description: "Distinct Count of Collection ID"
  }
}
