view: fact_shopify_orders_test {
  sql_table_name: fact_shopify_orders ;;
  view_label: "Shopify Orders - Timeframe Testing"

  filter: current_date_range {
    type: date
    view_label: "Shopify Orders - Timeframe Testing"
    label: "Current Order Date Range"
    description: "Select the current date range you are interested in."
    sql: ${order_raw} IS NOT NULL ;;
  }

  # parameter: compare_to {
  #   view_label: "Timeframe Testing"
  #   description: "Select the templated previous period you would like to compare to. Must be used with Current Date Range filter"
  #   label: "Compare To:"
  #   type: unquoted
  #   allowed_value: {
  #     label: "Previous Period"
  #     value: "Period"
  #   }
  #   allowed_value: {
  #     label: "Previous Week"
  #     value: "Week"
  #   }
  #   allowed_value: {
  #     label: "Previous Month"
  #     value: "Month"
  #   }
  #   allowed_value: {
  #     label: "Previous Quarter"
  #     value: "Quarter"
  #   }
  #   allowed_value: {
  #     label: "Previous Year"
  #     value: "Year"
  #   }
  #   default_value: "Period"
  # }

## ------------------ HIDDEN HELPER DIMENSIONS  ------------------ ##


  dimension: days_in_period {
    hidden:  yes
    view_label: "Shopify Orders - Timeframe Testing"
    description: "Gives the number of days in the current period date range"
    type: number
    sql: DATEDIFF(DAY, DATE({% date_start current_date_range %}), DATE({% date_end current_date_range %})) ;;
  }

  # dimension: period_2_start {
  #   hidden:  yes
  #   view_label: "Timeframe Testing"
  #   description: "Calculates the start of the previous period"
  #   type: date
  #   sql:
  #       {% if compare_to._parameter_value == "Period" %}
  #       DATEADD(DAY, -${days_in_period}, DATE({% date_start current_date_range %}))
  #       {% else %}
  #       DATEADD({% parameter compare_to %}, -1, DATE({% date_start current_date_range %}))
  #       {% endif %};;
  # }

  # dimension: period_2_end {
  #   hidden:  yes
  #   view_label: "Timeframe Testing"
  #   description: "Calculates the end of the previous period"
  #   type: date
  #   sql:
  #       {% if compare_to._parameter_value == "Period" %}
  #       DATEADD(DAY, -1, DATE({% date_start current_date_range %}))
  #       {% else %}
  #       DATEADD({% parameter compare_to %}, -1, DATEADD(DAY, -1, DATE({% date_end current_date_range %})))
  #       {% endif %};;
  # }

  dimension: day_in_period {
    hidden: yes
    description: "Gives the number of days since the start of each period. Use this to align the event dates onto the same axis, the axes will read 1,2,3, etc."
    type: number
    sql:
    {% if current_date_range._is_filtered %}
        CASE
        WHEN {% condition current_date_range %} ${order_raw} {% endcondition %}
        THEN DATEDIFF(DAY, DATE({% date_start current_date_range %}), ${order_raw}) + 1
        WHEN ${order_raw} between ${period_2_start} and ${period_2_end}
        THEN DATEDIFF(DAY, ${period_2_start}, ${order_raw}) + 1
        END
    {% else %} NULL
    {% endif %}
    ;;
  }

  dimension: order_for_period {
    hidden: yes
    type: number
    sql:
        {% if current_date_range._is_filtered %}
            CASE
            WHEN {% condition current_date_range %} ${order_raw} {% endcondition %}
            THEN 1
            WHEN ${order_raw} between ${period_2_start} and ${period_2_end}
            THEN 2
            END
        {% else %}
            NULL
        {% endif %}
        ;;
  }

## ------- HIDING FIELDS  FROM ORIGINAL VIEW FILE  -------- ##


  dimension_group: created {hidden: yes}
  dimension: ytd_only {hidden:yes}
  dimension: mtd_only {hidden:yes}
  dimension: wtd_only {hidden:yes}

## ------------------ DIMENSIONS TO PLOT ------------------ ##


  dimension_group: date_in_period {
    description: "Use this as your grouping dimension when comparing periods. Aligns the previous periods onto the current period"
    label: "Current Period"
    type: time
    sql: DATEADD(DAY, ${day_in_period} - 1, DATE({% date_start current_date_range %})) ;;
    view_label: "Shopify Orders - Timeframe Testing"
    timeframes: [
      date,
      hour_of_day,
      day_of_week,
      day_of_week_index,
      day_of_month,
      day_of_year,
      week_of_year,
      month,
      month_name,
      month_num,
      year]
  }


  dimension: period {
    view_label: "Shopify Orders - Timeframe Testing"
    label: "Period"
    description: "Pivot me! Returns the period the metric covers, i.e. either the 'This Period' or 'Previous Period'"
    type: string
    order_by_field: order_for_period
    sql:
        {% if current_date_range._is_filtered %}
            CASE
            WHEN {% condition current_date_range %} ${order_raw} {% endcondition %}
            THEN 'This {% parameter compare_to %}'
            WHEN ${order_raw} between ${period_2_start} and ${period_2_end}
            THEN 'Last {% parameter compare_to %}'
            END
        {% else %}
            NULL
        {% endif %}
        ;;
  }

## ---------------------- TO CREATE FILTERED MEASURES ---------------------------- ##


  dimension: period_filtered_measures {
    hidden: yes
    description: "We just use this for the filtered measures"
    type: string
    sql:
        {% if current_date_range._is_filtered %}
            CASE
            WHEN {% condition current_date_range %} ${order_raw} {% endcondition %} THEN 'this'
            WHEN ${order_raw} between ${period_2_start} and ${period_2_end} THEN 'last' END
        {% else %} NULL {% endif %} ;;
  }

# Filtered measures

  measure: current_period_revenue {
    view_label: "Shopify Orders - Timeframe Testing"
    group_label: "Current Period Measures"
    type: sum
    sql: ${revenue};;
    filters: [period_filtered_measures: "this"]
  }

  measure: comparison_period_revenue {
    view_label: "Shopify Orders - Timeframe Testing"
    group_label: "Comparison Period Measures"
    type: sum
    sql: ${revenue};;
    filters: [period_filtered_measures: "last"]
  }
  measure: current_period_quantity {
    view_label: "Shopify Orders - Timeframe Testing"
    group_label: "Current Period Measures"
    type: sum
    sql: ${TABLE}.quantity ;;
    filters: [period_filtered_measures: "this"]
  }
  measure: current_period_cost {
    view_label: "Shopify Orders - Timeframe Testing"
    group_label: "Current Period Measures"
    type: sum
    sql: ${TABLE}.cost ;;
    filters: [period_filtered_measures: "this"]
  }
  measure: current_period_shipping {
    view_label: "Shopify Orders - Timeframe Testing"
    group_label: "Current Period Measures"
    type: sum
    sql: ${TABLE}.shipping ;;
    filters: [period_filtered_measures: "this"]
  }
  measure: current_period_tax {
    view_label: "Shopify Orders - Timeframe Testing"
    group_label: "Current Period Measures"
    type: sum
    sql: ${TABLE}.tax ;;
    filters: [period_filtered_measures: "this"]
  }
  measure: current_period_discount {
    view_label: "Shopify Orders - Timeframe Testing"
    group_label: "Current Period Measures"
    type: sum
    sql: ${TABLE}.discount ;;
    filters: [period_filtered_measures: "this"]
  }
  measure: current_period_gift_card_revenue {
    view_label: "Shopify Orders - Timeframe Testing"
    group_label: "Current Period Measures"
    type: sum
    sql: ${TABLE}.gift_card_revenue ;;
    filters: [period_filtered_measures: "this"]
  }
  measure: current_period_amount_refunded {
    view_label: "Shopify Orders - Timeframe Testing"
    group_label: "Current Period Measures"
    type: sum
    sql: ${TABLE}.amount_refunded ;;
    filters: [period_filtered_measures: "this"]
  }
  measure: current_period_current_tax {
    view_label: "Shopify Orders - Timeframe Testing"
    group_label: "Current Period Measures"
    type: sum
    sql: ${TABLE}.current_tax ;;
    filters: [period_filtered_measures: "this"]
  }
  measure: current_period_subtotal {
    view_label: "Shopify Orders - Timeframe Testing"
    group_label: "Current Period Measures"
    type: sum
    sql: ${TABLE}.subtotal ;;
    filters: [period_filtered_measures: "this"]
  }
  measure: current_period_current_subtotal {
    view_label: "Shopify Orders - Timeframe Testing"
    group_label: "Current Period Measures"
    type: sum
    sql: ${TABLE}.current_subtotal ;;
    filters: [period_filtered_measures: "this"]
  }
  measure: current_period_current_discount {
    view_label: "Shopify Orders - Timeframe Testing"
    group_label: "Current Period Measures"
    type: sum
    sql: ${TABLE}.current_discount ;;
    filters: [period_filtered_measures: "this"]
  }
  measure: comparison_period_quantity {
    view_label: "Shopify Orders - Timeframe Testing"
    group_label: "Comparison Period Measures"
    type: sum
    sql: ${TABLE}.quantity ;;
    filters: [period_filtered_measures: "last"]
  }
  measure: comparison_period_cost {
    view_label: "Shopify Orders - Timeframe Testing"
    group_label: "Comparison Period Measures"
    type: sum
    sql: ${TABLE}.cost ;;
    filters: [period_filtered_measures: "last"]
  }
  measure: comparison_period_shipping {
    view_label: "Shopify Orders - Timeframe Testing"
    group_label: "Comparison Period Measures"
    type: sum
    sql: ${TABLE}.shipping ;;
    filters: [period_filtered_measures: "last"]
  }
  measure: comparison_period_tax {
    view_label: "Shopify Orders - Timeframe Testing"
    group_label: "Comparison Period Measures"
    type: sum
    sql: ${TABLE}.tax ;;
    filters: [period_filtered_measures: "last"]
  }
  measure: comparison_period_discount {
    view_label: "Shopify Orders - Timeframe Testing"
    group_label: "Comparison Period Measures"
    type: sum
    sql: ${TABLE}.discount ;;
    filters: [period_filtered_measures: "last"]
  }
  measure: comparison_period_gift_card_revenue {
    view_label: "Shopify Orders - Timeframe Testing"
    group_label: "Comparison Period Measures"
    type: sum
    sql: ${TABLE}.gift_card_revenue ;;
    filters: [period_filtered_measures: "last"]
  }
  measure: comparison_period_amount_refunded {
    view_label: "Shopify Orders - Timeframe Testing"
    group_label: "Comparison Period Measures"
    type: sum
    sql: ${TABLE}.amount_refunded ;;
    filters: [period_filtered_measures: "last"]
  }
  measure: comparison_period_current_tax {
    view_label: "Shopify Orders - Timeframe Testing"
    group_label: "Comparison Period Measures"
    type: sum
    sql: ${TABLE}.current_tax ;;
    filters: [period_filtered_measures: "last"]
  }
  measure: comparison_period_subtotal {
    view_label: "Shopify Orders - Timeframe Testing"
    group_label: "Comparison Period Measures"
    type: sum
    sql: ${TABLE}.subtotal ;;
    filters: [period_filtered_measures: "last"]
  }
  measure: comparison_period_current_subtotal {
    view_label: "Shopify Orders - Timeframe Testing"
    group_label: "Comparison Period Measures"
    type: sum
    sql: ${TABLE}.current_subtotal ;;
    filters: [period_filtered_measures: "last"]
  }
  measure: comparison_period_current_discount {
    view_label: "Shopify Orders - Timeframe Testing"
    group_label: "Comparison Period Measures"
    type: sum
    sql: ${TABLE}.current_discount ;;
    filters: [period_filtered_measures: "last"]
  }

# custom date range

  filter: previous_date_range {
    type: date
    view_label: "Shopify Orders - Timeframe Testing"
    label: "Comparison Date Range"
    description: "Select a custom previous period you would like to compare to. Must be used with Current Date Range filter."
  }

  parameter: compare_to {label: "Compare To:"
    hidden:yes}
  # dimension_group: date_in_period {hidden:yes}

  dimension: period_2_start {
    view_label: "Shopify Orders - Timeframe Testing"
    description: "Calculates the start of the previous period"
    type: date
    sql:
        {% if compare_to._in_query %}
            {% if compare_to._parameter_value == "Period" %}
            DATEADD(DAY, -${days_in_period}, DATE({% date_start current_date_range %}))
            {% else %}
            DATEADD({% parameter compare_to %}, -1, DATE({% date_start current_date_range %}))
            {% endif %}
        {% else %}
            {% date_start previous_date_range %}
        {% endif %};;
    hidden:  yes
  }

  dimension: period_2_end {
    hidden:  yes
    view_label: "Shopify Orders - Timeframe Testing"
    description: "Calculates the end of the previous period"
    type: date
    sql:
        {% if compare_to._in_query %}
            {% if compare_to._parameter_value == "Period" %}
            DATEADD(DAY, -1, DATE({% date_start current_date_range %}))
            {% else %}
            DATEADD({% parameter compare_to %}, -1, DATEADD(DAY, -1, DATE({% date_end current_date_range %})))
            {% endif %}
        {% else %}
            {% date_end previous_date_range %}
        {% endif %};;
  }



  dimension: primary_key {
    type: string
    sql: CONCAT(${glew_account_id},${order_id}) ;;
    primary_key: yes
    hidden: yes
  }
  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
  }
  dimension: glew_account_id {
    type: number
    sql: ${TABLE}.glew_account_id ;;
  }
  dimension_group: order {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.timestamp ;;
    drill_fields: [order_year, order_quarter, order_month, order_week, order_date]
  }
  dimension: customer_email {
    type: string
    sql: ${TABLE}.customer_email ;;
  }
  dimension: quantity {
    type: number
    group_label: "Glew Custom Measure"
    sql: ${TABLE}.quantity ;;
  }
  dimension: revenue {
    type: number
    group_label: "Glew Custom Measure"
    sql: ${TABLE}.revenue ;;
  }
  dimension: cost {
    type: number
    group_label: "Glew Custom Measure"
    sql: ${TABLE}.cost ;;
  }
  dimension: shipping {
    type: number
    group_label: "Glew Custom Measure"
    sql: ${TABLE}.shipping ;;
  }
  dimension: tax {
    type: number
    group_label: "Glew Custom Measure"
    sql: ${TABLE}.tax ;;
  }
  dimension: discount {
    type: number
    group_label: "Glew Custom Measure"
    sql: ${TABLE}.discount ;;
  }
  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }
  dimension: day_of_week {
    type: string
    sql: ${TABLE}.day_of_week ;;
  }
  dimension: device {
    type: string
    sql: ${TABLE}.device ;;
  }
  dimension: channel {
    type: string
    sql: ${TABLE}.channel ;;
  }
  dimension: medium {
    type: string
    sql: ${TABLE}.medium ;;
  }
  dimension: source {
    type: string
    sql: ${TABLE}.source ;;
  }
  dimension: metro {
    type: string
    sql: ${TABLE}.metro ;;
  }
  dimension: campaign {
    type: string
    sql: ${TABLE}.campaign ;;
  }
  dimension: current_device {
    type: string
    sql: ${TABLE}.current_device ;;
  }
  dimension: current_channel {
    type: string
    sql: ${TABLE}.current_channel ;;
  }
  dimension: current_source {
    type: string
    sql: ${TABLE}.current_source ;;
  }
  dimension: current_metro {
    type: string
    sql: ${TABLE}.current_metro ;;
  }
  dimension: current_campaign {
    type: string
    sql: ${TABLE}.current_campaign ;;
  }
  dimension: amount_refunded {
    type: number
    group_label: "Glew Custom Measure"
    sql: ${TABLE}.amount_refunded ;;
  }
  dimension: transaction_id {
    type: string
    sql: ${TABLE}.transaction_id ;;
  }
  dimension: gift_card_revenue {
    type: number
    group_label: "Glew Custom Measure"
    sql: ${TABLE}.gift_card_revenue ;;
  }
  dimension: is_gift_card {
    type: string
    sql: ${TABLE}.is_gift_card ;;
  }
  dimension: order_source {
    type: string
    sql: ${TABLE}.order_source ;;
  }
  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }
  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }
  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }
  dimension: state {
    type: string
    map_layer_name: us_states
    sql: ${TABLE}.state ;;
    drill_fields: [city]
  }
  dimension: country_code {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country_code ;;
    drill_fields: [state,city]
  }
  dimension: zip {
    type: zipcode
    map_layer_name: us_zipcode_tabulation_areas
    sql: ${TABLE}.zip ;;
  }
  dimension: line_item_count {
    type: number
    group_label: "Glew Custom Measure"
    sql: ${TABLE}.line_item_count ;;
  }
  dimension: highest_priced_product {
    type: number
    sql: ${TABLE}.highest_priced_product ;;
  }
  dimension: lowest_priced_product {
    type: number
    sql: ${TABLE}.lowest_priced_product ;;
  }
  dimension: currency {
    type: string
    sql: ${TABLE}.currency ;;
  }
  dimension: fulfillment_status {
    type: string
    sql: ${TABLE}.fulfillment_status ;;
  }
  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }
  dimension: user {
    type: string
    sql: ${TABLE}.user ;;
  }
  dimension: location_id {
    type: number
    sql: ${TABLE}.location_id ;;
  }
  dimension: pos_id {
    type: number
    sql: ${TABLE}.pos_id ;;
  }
  dimension: processing_method {
    type: string
    sql: ${TABLE}.processiong_method ;;
  }
  dimension: source_identifier {
    type: string
    sql: ${TABLE}.source_identifier ;;
  }
  dimension: gateway {
    type: string
    sql: ${TABLE}.gateway ;;
  }
  dimension: location {
    type: string
    sql: ${TABLE}.location ;;
  }
  dimension: pos {
    type: string
    sql: ${TABLE}.pos ;;
  }
  dimension: app_id {
    type: number
    sql: ${TABLE}.app_id ;;
  }
  dimension_group: cancelled_at {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.cancelled_at ;;
    drill_fields: [cancelled_at_year, cancelled_at_quarter, cancelled_at_month, cancelled_at_week, cancelled_at_date]
  }
  dimension_group: closed_at {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.closed_at ;;
    drill_fields: [closed_at_year, closed_at_quarter, closed_at_month, closed_at_week, closed_at_date]
  }
  dimension: cancel_reason {
    type: string
    sql: ${TABLE}.cancel_reason ;;
  }
  dimension: sales_channel_id {
    type: number
    sql: ${TABLE}.sales_channel_id ;;
  }
  dimension: sales_channel {
    type: string
    sql: ${TABLE}.sales_channel ;;
  }
  dimension: customer_id {
    type: number
    sql: ${TABLE}.customer_id ;;
  }
  dimension: current_tax {
    type: number
    group_label: "Glew Custom Measure"
    sql: ${TABLE}.current_tax ;;
  }
  dimension: subtotal {
    type: number
    group_label: "Glew Custom Measure"
    sql: ${TABLE}.subtotal ;;
  }
  dimension: current_subtotal {
    type: number
    group_label: "Glew Custom Measure"
    sql: ${TABLE}.current_subtotal ;;
  }
  dimension: current_discount {
    type: number
    group_label: "Glew Custom Measure"
    sql: ${TABLE}.current_discount ;;
  }
  measure: number_of_orders {
    type: count
    group_label: "Standard Measures"
  }
  measure: sum_of_quantity {
    type: sum
    sql: ${TABLE}.quantity ;;
    group_label: "Standard Measures"
  }
  measure: sum_of_revenue {
    type: sum
    sql: ${TABLE}.revenue ;;
    group_label: "Standard Measures"
  }
  measure: sum_of_cost {
    type: sum
    sql: ${TABLE}.cost ;;
    group_label: "Standard Measures"
  }
  measure: sum_of_shipping {
    type: sum
    sql: ${TABLE}.shipping ;;
    group_label: "Standard Measures"
  }
  measure: sum_of_tax {
    type: sum
    sql: ${TABLE}.tax ;;
    group_label: "Standard Measures"
  }
  measure: sum_of_discount {
    type: sum
    sql: ${TABLE}.discount ;;
    group_label: "Standard Measures"
  }
  measure: sum_of_gift_card_revenue {
    type: sum
    sql: ${TABLE}.gift_card_revenue ;;
    group_label: "Standard Measures"
  }
  measure: sum_of_amount_refunded {
    type: sum
    sql: ${TABLE}.amount_refunded ;;
    group_label: "Standard Measures"
  }
  measure: sum_of_current_tax {
    type: sum
    sql: ${TABLE}.current_tax ;;
    group_label: "Standard Measures"
  }
  measure: sum_of_subtotal {
    type: sum
    sql: ${TABLE}.subtotal ;;
    group_label: "Standard Measures"
  }
  measure: sum_of_current_subtotal {
    type: sum
    sql: ${TABLE}.current_subtotal ;;
    group_label: "Standard Measures"
  }
  measure: sum_of_current_discount {
    type: sum
    sql: ${TABLE}.current_discount ;;
    group_label: "Standard Measures"
  }
}
