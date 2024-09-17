view: dim_shopify_gift_cards {
  sql_table_name: dim_shopify_gift_cards ;;
  view_label: "Shopify Gift Cards"


  dimension: primary_key {
    type: string
    sql: CONCAT(${glew_account_id},${gift_card_id}) ;;
    primary_key: yes
    hidden: yes
  }

  dimension: api_client_id {
    type: number
    sql: ${TABLE}.api_client_id ;;
  }
  dimension: balance {
    type: number
    sql: ${TABLE}.balance ;;
  }
  dimension_group: created {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.created_at ;;
  }
  dimension: currency {
    type: string
    sql: ${TABLE}.currency ;;
  }
  dimension: customer_id {
    type: number
    sql: ${TABLE}.customer_id ;;
  }
  dimension_group: disabled {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.disabled_at ;;
  }
  dimension_group: expires {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.expires_on ;;
  }
  dimension: gift_card_id {
    type: number
    sql: ${TABLE}.gift_card_id ;;
  }
  dimension: glew_account_id {
    type: number
    sql: ${TABLE}.glew_account_id ;;
  }
  dimension: initial_value {
    type: number
    sql: ${TABLE}.initial_value ;;
  }
  dimension: last_characters {
    type: string
    sql: ${TABLE}.last_characters ;;
  }
  dimension: line_item_id {
    type: number
    sql: ${TABLE}.line_item_id ;;
  }
  dimension: note {
    type: string
    sql: ${TABLE}.note ;;
  }
  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
  }
  dimension: template_suffix {
    type: string
    sql: ${TABLE}.template_suffix ;;
  }
  dimension_group: updated {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.updated_at ;;
  }
  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }
}
