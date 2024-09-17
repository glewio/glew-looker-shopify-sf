view: fact_shopify_products {
  sql_table_name: fact_shopify_products ;;
  view_label: "Shopify Products"

  dimension: primary_key {
    type: string
    sql: CONCAT(${glew_account_id},${product_id}) ;;
    primary_key: yes
    hidden: yes
  }

  dimension: product_id {
    type: number
    description: "The ID of the child product"
    value_format: "0"
    sql: ${TABLE}.product_id ;;
  }
  dimension: glew_account_id {
    type: number
    description: "The ID of the Glew Store.  If you have multiple stores, this is the field you use to determine which store you're querying."
    value_format: "0"
    sql: ${TABLE}.glew_account_id ;;
  }
  dimension: name {
    type: string
    description: "The name of the child product"
    sql: ${TABLE}.name ;;
  }
  dimension: description {
    type: string
    description: "The description of the child product"
    sql: ${TABLE}.description ;;
  }
  dimension: price {
    type: number
    description: "The price of the product"
    sql: ${TABLE}.price ;;
  }
  dimension: cost {
    type: number
    description: "The cost of the product"
    sql: ${TABLE}.cost ;;
  }
  dimension: category {
    type: string
    description: "The product category"
    sql: ${TABLE}.category ;;
  }
  dimension: sku {
    type: string
    description: "The SKU of the child product"
    sql: ${TABLE}.sku ;;
  }
  dimension: image_url {
    type: string
    description: "The URL to the picture of the image"
    sql: ${TABLE}.image ;;
  }
  dimension: image_display {
    sql: ${image_url} ;;
    description: "The image of the product"
    html: <img src= {{ image_url }} height=80 /> ;;
  }
  dimension: image_display_big_number {
    sql: ${image_url} ;;
    description: "The image of the product for big number visualizations"
    html: <img src= {{ image_url }} height=300 /> ;;
  }
  dimension: url {
    type: string
    description: "The custom URL for the product on the storefront."
    sql: ${TABLE}.url ;;
  }
  dimension: quantity_left {
    type: number
    description: "The quantity of product left in inventory "
    group_label: "Glew Custom Measure"
    sql: ${TABLE}.quantity_left ;;
  }
  dimension: glew_cogs {
    type: number
    description: "From Glew, the cost of that product"
    sql: ${TABLE}.glew_cogs ;;
  }
  dimension_group: glew_cogs_updated {
    type: time
    description: "From Glew, shows the latest date the cogs has been updated for that product"
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
    sql: ${TABLE}.glew_cogs_updated ;;
    drill_fields: [glew_cogs_updated_year, glew_cogs_updated_quarter, glew_cogs_updated_month, glew_cogs_updated_week, glew_cogs_updated_date]

  }
  dimension: base_product_id {
    type: number
    description: "The ID of the parent product"
    value_format: "0"
    sql: ${TABLE}.base_product_id ;;
    drill_fields: [product_id]
  }
  dimension: manufacturer {
    type: string
    description: "The manufacturer/vendor of the product"
    sql: ${TABLE}.manufacturer ;;
  }
  dimension: base_sku {
    type: string
    description: "The SKU of the parent product"
    sql: ${TABLE}.base_sku ;;
    drill_fields: [sku]
  }
  dimension: base_name {
    type: string
    description: "The name of the parent product"
    sql: ${TABLE}.base_name ;;
    drill_fields: [name]
  }
  dimension: status {
    type: string
    description: "If a product is live, archived, etc."
    sql: ${TABLE}.status ;;
  }
  dimension: type {
    type: string
    description: "The product type"
    sql: ${TABLE}.type ;;
  }
  dimension: regular_price {
    type: number
    sql: ${TABLE}.regular_price ;;
  }
  dimension: barcode {
    type: string
    description: "The barcode of the product"
    sql: ${TABLE}.barcode ;;
  }
  dimension: fulfillment_service {
    type: string
    sql: ${TABLE}.fulfillment_service ;;
  }
  dimension: inventory_management {
    type: string
    sql: ${TABLE}.inventory_management ;;
  }
  dimension: inventory_policy {
    type: string
    sql: ${TABLE}.inventory_policy ;;
  }
  dimension: inventory_item_id {
    type: number
    description: "The ID of the inventory item"
    value_format: "0"
    sql: ${TABLE}.inventory_item_id ;;
  }
  dimension: option1 {
    type: string
    description: "1 of 3 product custom fields that can be set up in Shopify. This can be size, color, etc."
    sql: ${TABLE}.option1 ;;
  }
  dimension: option2 {
    type: string
    description: "1 of 3 product custom fields that can be set up in Shopify. This can be size, color, etc."
    sql: ${TABLE}.option2 ;;
  }
  dimension: option3 {
    type: string
    description: "1 of 3 product custom fields that can be set up in Shopify. This can be size, color, etc."
    sql: ${TABLE}.option3 ;;
  }

  measure: number_of_products {
    type: count_distinct
    sql: ${product_id} ;;
    description: "Distinct Count of Product ID"
    }

  measure: sum_of_quantity_left {
    type: sum
    sql: ${TABLE}.quantity_left ;;
  }
}
