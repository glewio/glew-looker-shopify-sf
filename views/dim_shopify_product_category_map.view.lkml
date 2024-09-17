view: dim_shopify_product_category_map {
  sql_table_name: dim_shopify_product_category_map ;;
  view_label: "Shopify Product Category Map"

  dimension: primary_key {
    type: string
    sql:CONCAT(CONCAT(CAST(${product_id} as VARCHAR), CAST(${glew_account_id} as VARCHAR)),  CAST(${category} as VARCHAR)) ;;
    primary_key: yes
    hidden: yes
  }

  dimension: base_product_id {
    type: number
    value_format: "0"
    sql: ${TABLE}.base_product_id ;;
    drill_fields: [product_id]
  }

  dimension: category {
    type: string
    case_sensitive: no
    sql: ${TABLE}.category ;;
  }

  dimension: glew_account_id {
    type: number
    value_format: "0"
    sql: ${TABLE}.glew_account_id ;;
  }

  dimension: product_id {
    type: number
    value_format: "0"
    sql: ${TABLE}.product_id ;;
  }

  measure: number_of_product_categories {
    type: count_distinct
    sql: ${category} ;;
    description: "Distinct Count of Category"
  }
}
