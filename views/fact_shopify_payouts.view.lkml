view: fact_shopify_payouts {
  sql_table_name: fact_shopify_payouts ;;
  view_label: "Shopify Payouts"

  dimension: primary_key {
    type: string
    sql: CONCAT(${glew_account_id},${payout_id}) ;;
    primary_key: yes
    hidden: yes
  }


  dimension: adjustments_fee_amount {
    type: number
    group_label: "Glew Custom Measure"
    sql: ${TABLE}.adjustments_fee_amount ;;
  }

  dimension: adjustments_gross_amount {
    type: number
    group_label: "Glew Custom Measure"
    sql: ${TABLE}.adjustments_gross_amount ;;
  }

  dimension: amount {
    type: number
    group_label: "Glew Custom Measure"
    sql: ${TABLE}.amount ;;
  }

  dimension: charges_fee_amount {
    type: number
    group_label: "Glew Custom Measure"
    sql: ${TABLE}.charges_fee_amount ;;
  }

  dimension: charges_gross_amount {
    type: number
    group_label: "Glew Custom Measure"
    sql: ${TABLE}.charges_gross_amount ;;
  }

  dimension: currency {
    type: string
    sql: ${TABLE}.currency ;;
  }

  dimension: glew_account_id {
    type: number
    sql: ${TABLE}.glew_account_id ;;
  }

  dimension: payout_id {
    type: number
    sql: ${TABLE}.payout_id ;;
  }

  dimension: refunds_fee_amount {
    type: number
    group_label: "Glew Custom Measure"
    sql: ${TABLE}.refunds_fee_amount ;;
  }

  dimension: refunds_gross_amount {
    type: number
    group_label: "Glew Custom Measure"
    sql: ${TABLE}.refunds_gross_amount ;;
  }

  dimension: reserved_funds_fee_amount {
    type: number
    group_label: "Glew Custom Measure"
    sql: ${TABLE}.reserved_funds_fee_amount ;;
  }

  dimension: reserved_funds_gross_amount {
    type: number
    group_label: "Glew Custom Measure"
    sql: ${TABLE}.reserved_funds_gross_amount ;;
  }

  dimension: retried_payouts_fee_amount {
    type: number
    group_label: "Glew Custom Measure"
    sql: ${TABLE}.retried_payouts_fee_amount ;;
  }

  dimension: retried_payouts_gross_amount {
    type: number
    group_label: "Glew Custom Measure"
    sql: ${TABLE}.retried_payouts_gross_amount ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension_group: timestamp {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.timestamp ;;
  }
  measure: sum_of_adjustments_fee_amount {
    type: sum
    sql: ${TABLE}.adjustments_fee_amount ;;
  }

  measure: sum_of_adjustments_gross_amount {
    type: sum
    sql: ${TABLE}.adjustments_gross_amount ;;
  }

  measure: sum_of_amount {
    type: sum
    sql: ${TABLE}.amount ;;
  }

  measure: sum_of_charges_fee_amount {
    type: sum
    sql: ${TABLE}.charges_fee_amount ;;
  }
  measure: sum_of_charges_gross_amount {
    type: sum
    sql: ${TABLE}.charges_gross_amount ;;
  }
  measure: sum_of_refunds_fee_amount {
    type: sum
    sql: ${TABLE}.refunds_fee_amount ;;
  }

  measure: sum_of_refunds_gross_amount {
    type: sum
    sql: ${TABLE}.refunds_gross_amount ;;
  }

  measure: sum_of_reserved_funds_fee_amount {
    type: sum
    sql: ${TABLE}.reserved_funds_fee_amount ;;
  }

  measure: sum_of_reserved_funds_gross_amount {
    type: sum
    sql: ${TABLE}.reserved_funds_gross_amount ;;
  }

  measure: sum_of_retried_payouts_fee_amount {
    type: sum
    sql: ${TABLE}.retried_payouts_fee_amount ;;
  }

  measure: sum_of_retried_payouts_gross_amount {
    type: sum
    sql: ${TABLE}.retried_payouts_gross_amount ;;
  }
}
