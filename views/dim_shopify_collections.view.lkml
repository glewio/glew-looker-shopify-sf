view: dim_shopify_collections {
  sql_table_name: dim_shopify_collections ;;
  view_label: "Shopify Collections"

  dimension: primary_key {
    type: string
    sql: CONCAT(${glew_account_id},${collection_id}) ;;
    primary_key: yes
    hidden: yes
  }

  dimension: collection_id {
    type: number
    value_format: "0"
    sql: ${TABLE}.collection_id ;;
  }

  dimension: glew_account_id {
    type: number
    value_format: "0"
    sql: ${TABLE}.glew_account_id ;;
  }

  dimension: handle {
    type: string
    sql: ${TABLE}.handle ;;
  }

  dimension: html {
    type: string
    sql: ${TABLE}.html ;;
  }

  dimension: image_alt {
    type: string
    sql: ${TABLE}.image_alt ;;
  }

  dimension_group: image_created {
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
    sql: ${TABLE}.image_created_date ;;
    drill_fields: [image_created_year,image_created_quarter,image_created_month,image_created_week,image_created_date]
  }

  dimension: image_height {
    type: number
    sql: ${TABLE}.image_height ;;
  }

  dimension: image_src {
    type: string
    sql: ${TABLE}.image_src ;;
  }

  dimension: image_width {
    type: number
    sql: ${TABLE}.image_width ;;
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
    sql: ${TABLE}.published_date ;;
    drill_fields: [published_year,published_quarter,published_month,published_week,published_date]
  }

  dimension: published_scope {
    type: string
    sql: ${TABLE}.published_scope ;;
  }

  dimension: sort_order {
    type: string
    sql: ${TABLE}.sort_order ;;
  }

  dimension: template_suffix {
    type: string
    sql: ${TABLE}.template_suffix ;;
  }

  dimension: title {
    type: string
    sql: ${TABLE}.title ;;
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

  measure: number_of_collections {
    type: count_distinct
    sql: ${collection_id} ;;
    description: "Distinct Count of Collection ID"
  }
}
