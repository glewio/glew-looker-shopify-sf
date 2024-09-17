view: dim_shopify_shop {
  sql_table_name: dim_shopify_shop ;;
  view_label: "Shopify Shop"

  dimension: primary_key {
    type: string
    sql: CONCAT(${glew_account_id},${store_id}) ;;
    primary_key: yes
    hidden: yes
  }

  dimension: address1 {
    type: string
    sql: ${TABLE}.address1 ;;
  }
  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }
  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }
  dimension: domain {
    type: string
    sql: ${TABLE}.domain ;;
  }
  dimension: glew_account_id {
    type: number
    sql: ${TABLE}.glew_account_id ;;
  }
  dimension: myshopify_domain {
    type: string
    sql: ${TABLE}.myshopify_domain ;;
  }
  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }
  dimension: phone {
    type: string
    sql: ${TABLE}.phone ;;
  }
  dimension: plan_display_name {
    type: string
    sql: ${TABLE}.plan_display_name ;;
  }
  dimension: plan_name {
    type: string
    sql: ${TABLE}.plan_name ;;
  }
  dimension: province {
    type: string
    sql: ${TABLE}.province ;;
  }
  dimension: store_id {
    type: number
    sql: ${TABLE}.store_id ;;
  }
  dimension: zip {
    type: zipcode
    sql: ${TABLE}.zip ;;
  }
}
