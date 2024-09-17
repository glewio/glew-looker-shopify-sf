view: fact_shopify_payout_transactions {
  sql_table_name: fact_shopify_payout_transactions ;;
  view_label: "Shopify Payout Transactions"

  dimension: primary_key {
    type: string
    sql: CONCAT(${glew_account_id},${payout_id},${transaction_id}) ;;
    primary_key: yes
    hidden: yes
  }


  dimension: amount {
    type: number
    group_label: "Glew Custom Measure"
    sql: ${TABLE}.amount ;;
  }

  dimension: currency {
    type: string
    sql: ${TABLE}.currency ;;
  }

  dimension: fee {
    type: number
    group_label: "Glew Custom Measure"
    sql: ${TABLE}.fee ;;
  }

  dimension: glew_account_id {
    type: number
    sql: ${TABLE}.glew_account_id ;;
  }

  dimension: net {
    type: number
    group_label: "Glew Custom Measure"
    sql: ${TABLE}.net ;;
  }

  dimension: payout_id {
    type: number
    sql: ${TABLE}.payout_id ;;
  }

  dimension: payout_status {
    type: string
    sql: ${TABLE}.payout_status ;;
  }

  dimension_group: processed_at {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.processed_at ;;
  }

  dimension: source_id {
    type: number
    sql: ${TABLE}.source_id ;;
  }

  dimension: source_order_id {
    type: number
    sql: ${TABLE}.source_order_id ;;
  }

  dimension: source_order_transaction_id {
    type: number
    sql: ${TABLE}.source_order_transaction_id ;;
  }

  dimension: source_type {
    type: string
    sql: ${TABLE}.source_type ;;
  }

  dimension: test {
    type: yesno
    sql: ${TABLE}.test ;;
  }

  dimension: transaction_id {
    type: number
    sql: ${TABLE}.transaction_id ;;
  }

  dimension: type {
    type: string
    sql: ${TABLE}.type ;;
  }
  measure: sum_of_amount {
    type: sum
    sql: ${TABLE}.amount ;;
  }
  measure: sum_of_fee {
    type: sum
    sql: ${TABLE}.fee ;;
  }
  measure: sum_of_net {
    type: sum
    sql: ${TABLE}.net ;;
  }
}
