view: dim_shopify_locations {
  sql_table_name: dim_shopify_locations ;;
  view_label: "Shopify Locations"

  dimension: primary_key {
    type: string
    sql: CONCAT(${glew_account_id},${location_id}) ;;
    primary_key: yes
    hidden: yes
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
    drill_fields: [state,city]
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

  dimension: state {
    type: string
    map_layer_name: us_states
    sql: ${TABLE}.state ;;
    drill_fields: [city]
  }

  dimension: zip {
    type: zipcode
    map_layer_name: us_zipcode_tabulation_areas
    sql: ${TABLE}.zip ;;
  }

  measure: number_of_locations {
    type: count_distinct
    sql: ${location_id} ;;
    description: "Distinct Count of Location ID"
  }
}
