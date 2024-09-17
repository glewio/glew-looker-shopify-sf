view: fact_shopify_order_transactions {
  sql_table_name: fact_shopify_order_transactions ;;
view_label: "Shopify Order Transactions"

######## COMPARISON DATE RANGE DIMENSIONS/FILTERS #######

   filter: current_date_range {
    type: date
    convert_tz: no
    view_label: "Shopify Order Transactions"
    label: "Current Transaction Date Range"
    description: "Select the current date range you are interested in."
  }
  filter: previous_date_range {
    type: date
    convert_tz: no
    view_label: "Shopify Order Transactions"
    label: "Comparison Transaction Date Range"
    description: "Select a custom previous period you would like to compare to. Must be used with Current Date Range filter."
  }

  dimension: day_in_period {
    description: "Gives the number of days since the start of each period. Use this to align the event dates onto the same axis, the axes will read 1,2,3, etc."
    type: number
    sql:
    {% if current_date_range._is_filtered %}
        CASE
        WHEN {% condition current_date_range %} ${transaction_date} {% endcondition %}
        THEN DATEDIFF(DAY, {% date_start current_date_range %}, ${transaction_date}) +1
        WHEN {% condition previous_date_range %} ${transaction_date} {% endcondition %}
        THEN DATEDIFF(DAY, {% date_start previous_date_range %}, ${transaction_date}) +1
        END
    {% else %} NULL
    {% endif %}
    ;;
  }

  dimension_group: date_in_period {
    description: "Use this as your grouping dimension when comparing periods. Aligns the previous periods onto the current period"
    label: "Current Period"
    type: time
    convert_tz: no
    sql: DATEADD(DAY, ${day_in_period} - 1, ${period_1_start_date})  ;;
    view_label: "Shopify Order Transactions"
    timeframes: [raw,
      time,
      date,
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
  }
  dimension_group: period_1_start {
    view_label: "Shopify Order Transactions"
    description: "Calculates the start of the previous period"
    type: time
    convert_tz: no
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
    sql: {% date_start current_date_range %}  ;;
    hidden:  yes
  }
  dimension_group: period_1_end {
    view_label: "Shopify Order Transactions"
    description: "Calculates the end of the previous period"
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
    sql: {% date_end current_date_range %} ;;
    hidden:  yes
  }
  dimension_group: period_2_start {
    view_label: "Shopify Order Transactions"
    description: "Calculates the start of the previous period"
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
    sql: {% date_start previous_date_range %}  ;;
    hidden:  yes
  }
  dimension_group: period_2_end {
    view_label: "Shopify Order Transactions"
    description: "Calculates the end of the previous period"
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
    sql: {% date_end previous_date_range %} ;;
    hidden:  yes
  }
  dimension: period_filtered_measures {
    hidden: yes
    description: "We just use this for the filtered measures"
    type: string
    sql:
        {% if current_date_range._is_filtered %}
            CASE
            WHEN {% condition current_date_range %} ${transaction_date} {% endcondition %} THEN 'this'
            WHEN {% condition previous_date_range %} ${transaction_date} {% endcondition %} THEN 'last' END
        {% else %} NULL {% endif %} ;;
  }


  dimension: order_for_period {
    hidden: yes
    type: number
    sql:
        {% if current_date_range._is_filtered %}
            CASE
            WHEN {% condition current_date_range %} ${transaction_date} {% endcondition %}
            THEN 1
            WHEN ${transaction_date} between ${period_2_start_date} and ${period_2_end_date}
            THEN 2
            END
        {% else %}
            NULL
        {% endif %}
        ;;
  }




  dimension_group: created {hidden: yes}
  dimension: ytd_only {hidden:yes}
  dimension: mtd_only {hidden:yes}
  dimension: wtd_only {hidden:yes}
  dimension: period {
    view_label: "Shopify Order Transactions"
    label: "Period"
    description: "Pivot me! Returns the period the metric covers, i.e. either the 'This Period' or 'Previous Period'"
    type: string
    order_by_field: order_for_period
    sql:
        {% if current_date_range._is_filtered %}
            CASE
            WHEN {% condition current_date_range %} ${transaction_date} {% endcondition %}
            THEN 'This {% parameter compare_to %}'
            WHEN ${transaction_date} between ${period_2_start_date} and ${period_2_end_date}
            THEN 'Last {% parameter compare_to %}'
            END
        {% else %}
            NULL
        {% endif %}
        ;;
  }
  parameter: compare_to {label: "Compare To:"
    hidden:yes}
  # dimension_group: date_in_period {hidden:yes}
  dimension: days_in_period {
    hidden:  yes
    view_label: "Shopify Order Transactions"
    description: "Gives the number of days in the current period date range"
    type: number
    sql: DATEDIFF(d, {% date_start current_date_range %}, {% date_end current_date_range %}) ;;
  }

  measure: current_period_amount {
    view_label: "Shopify Order Transactions"
    group_label: "Current Period Measures"
    type: sum
    sql: ${amount};;
    filters: [period_filtered_measures: "this"]
  }

  measure: comparison_period_amount {
    view_label: "Shopify Order Transactions"
    group_label: "Comparison Period Measures"
    type: sum
    sql: ${amount};;
    filters: [period_filtered_measures: "last"]
  }
  measure: current_period_number_of_order_transactions {
   view_label: "Shopify Order Transactions"
    group_label: "Current Period Measures"
    type: count_distinct
    sql: ${transaction_id};;
    filters: [period_filtered_measures: "this"]
  }

  measure: comparison_period_number_of_order_transactions {
    view_label: "Shopify Order Transactions"
    group_label: "Comparison Period Measures"
    type: count_distinct
    sql: ${transaction_id};;
    filters: [period_filtered_measures: "last"]
  }

####### END COMPARISON DIMENSIONS/FILTERS #######

  dimension: primary_key {
    type: string
    sql: CONCAT(${glew_account_id},${transaction_id},${order_id}) ;;
    primary_key: yes
    hidden: yes
  }

  parameter: week_start {
    type: string
    allowed_value: {
      label: "Monday"
      value: "0 day"
    }
    allowed_value: {
      label: "Tuesday"
      value: "6 day"
    }
    allowed_value: {
      label: "Wednesday"
      value: "5 day"
    }
    allowed_value: {
      label: "Thursday"
      value: "4 day"
    }
    allowed_value: {
      label: "Friday"
      value: "3 day"
    }
    allowed_value: {
      label: "Saturday"
      value: "2 day"
    }
    allowed_value: {
      label: "Sunday"
      value: "1 day"
    }
  }

  dimension: alternate_week_start {
    sql: date_trunc('week', ${transaction_date} + interval {% parameter week_start %}) - interval {% parameter week_start %};;
  }
  dimension: alternate_day_start {
    sql: to_char(date_trunc('Day',${transaction_date} - interval {% parameter week_start %}), 'YYYY-MM-DD') ;;
  }

  dimension: amount {
    type: number
    sql: ${TABLE}.amount ;;
  }

  dimension: authorization_code {
    type: string
    sql: ${TABLE}.authorization_code ;;
  }

  dimension: card_type {
    type: string
    sql: ${TABLE}.card_type ;;
  }

  dimension: currency {
    type: string
    sql: ${TABLE}.currency ;;
  }

  dimension: customer_email {
    type: string
    sql: ${TABLE}.customer_email ;;
  }

  dimension: customer_id {
    type: number
    value_format: "0"
    sql: ${TABLE}.customer_id ;;
  }

  dimension: device_id {
    type: number
    value_format: "0"
    sql: ${TABLE}.device_id ;;
  }

  dimension: error_code {
    type: string
    sql: ${TABLE}.error_code ;;
  }

  dimension: gateway {
    type: string
    sql: ${TABLE}.gateway ;;
  }

  dimension: gift_card_id {
    type: number
    value_format: "0"
    sql: ${TABLE}.gift_card_id ;;
  }

  dimension: glew_account_id {
    type: number
    value_format: "0"
    sql: ${TABLE}.glew_account_id ;;
  }

  dimension: is_test {
    type: yesno
    sql: ${TABLE}.is_test ;;
  }

  dimension: kind {
    type: string
    sql: ${TABLE}.kind ;;
  }

  dimension: location_id {
    type: number
    value_format: "0"
    sql: ${TABLE}.location_id ;;
  }

  dimension: message {
    type: string
    sql: ${TABLE}.message ;;
  }

  dimension: order_id {
    type: number
    value_format: "0"
    sql: ${TABLE}.order_id ;;
  }

  dimension: order_number {
    type: string
    sql: ${TABLE}.order_number ;;
  }

  dimension: parent_id {
    type: number
    value_format: "0"
    sql: ${TABLE}.parent_id ;;
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

  dimension: source {
    type: string
    sql: ${TABLE}.source ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension_group: transaction {
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
    sql: ${TABLE}.timestamp ;;
    drill_fields: [transaction_year, transaction_quarter, transaction_month, transaction_week, transaction_date]
  }

  dimension: transaction_id {
    type: number
    value_format: "0"
    sql: ${TABLE}.transaction_id ;;
  }

  dimension: user_id {
    type: number
    value_format: "0"
    sql: ${TABLE}.user_id ;;
  }
  measure: number_of_order_transactions{
    type: count_distinct
    sql: ${transaction_id} ;;
    description: "Distinct Count of Transaction ID"
    group_label: "Standard Measures"
  }
  measure: sum_of_amount {
    type: sum
    sql: ${TABLE}.amount ;;
    group_label: "Standard Measures"
  }
}
