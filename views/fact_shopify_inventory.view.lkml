view: fact_shopify_inventory {
  sql_table_name: fact_shopify_inventory ;;
  view_label: "Shopify Inventory"

  dimension: primary_key {
    type: string
    sql: CONCAT(${glew_account_id},${product_id},${inventory_date}) ;;
    primary_key: yes
    hidden: yes
  }

  dimension_group: inventory {
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
    sql: ${TABLE}.date ;;
  }

  dimension: product_id {
    type: number
    sql: ${TABLE}.product_id ;;
  }

  dimension: glew_account_id {
    type: number
    sql: ${TABLE}.glew_account_id ;;
  }

  dimension: quantity {
    type: number
    sql: ${TABLE}.quantity ;;
  }

  dimension: price {
    type: number
    sql: ${TABLE}.price ;;
  }

  dimension: cost {
    type: number
    sql: ${TABLE}.cost ;;
  }

  dimension: base_product_id {
    type: number
    sql: ${TABLE}.base_product_id ;;
  }

  dimension: regular_price {
    type: number
    sql: ${TABLE}.regular_price ;;
  }
  dimension: fp_md {
    type: string
    sql: CASE
      WHEN ${TABLE}.price < ${TABLE}.regular_price THEN 'Markdown'
      ELSE 'Full Price'
      END;;
  }

  dimension: inventory_policy {
    type: string
    sql: ${TABLE}.inventory_policy ;;
  }
  measure: sum_of_quantity {
    type: sum
    sql:  ${TABLE}.quantity;;
  }
}
