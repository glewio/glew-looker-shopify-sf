view: fact_shopify_tender_transactions {
  sql_table_name: fact_shopify_tender_transactions ;;
  view_label: "Shopify Tender Transactions"

  dimension: primary_key {
    type: string
    sql:CONCAT(CAST(${tender_transaction_id} as VARCHAR), CAST(${glew_account_id} as VARCHAR));;
    primary_key: yes
    hidden: yes
  }


  dimension: tender_transaction_id {
    type: number
    value_format: "0"
    sql: ${TABLE}.tender_transaction_id ;;
  }

  dimension: glew_account_id {
    type: number
    value_format: "0"
    sql: ${TABLE}.glew_account_id ;;
  }

  dimension: order_id {
    type: number
    value_format: "0"
    sql: ${TABLE}.order_id ;;
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

  dimension: user_id {
    type: number
    value_format: "0"
    sql: ${TABLE}.user_id ;;
  }

  dimension: remote_reference {
    type: string
    sql: ${TABLE}.remote_reference ;;
  }

  dimension: credit_card_company {
    type: string
    sql: ${TABLE}.credit_card_company ;;
  }

  dimension: payment_method {
    type: string
    sql: ${TABLE}.payment_method ;;
  }

  dimension: test {
    type: yesno
    sql: ${TABLE}.test ;;
  }

  dimension_group: processed_at {
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
    sql: ${TABLE}.processed_at ;;
    drill_fields: [processed_at_year, processed_at_quarter, processed_at_month, processed_at_week, processed_at_date]
  }

  measure: number_of_tender_transactions {
    type: count_distinct
    sql: ${tender_transaction_id} ;;
    description: "Distinct Count of Tender Transaction ID"
  }
  measure: sum_of_amount {
    type: sum
    sql: ${TABLE}.amount ;;
  }
}
