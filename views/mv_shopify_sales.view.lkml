view: mv_shopify_sales {
  sql_table_name: mv_shopify_sales ;;
  view_label: "Sales Over Time"

######## COMPARISON DATE RANGE DIMENSIONS/FILTERS #######


  filter: current_date_range {
    type: date
    convert_tz: no
    view_label: "Sales Over Time"
    label: "Current Order Date Range"
    description: "Select the current date range you are interested in."
  }
  filter: previous_date_range {
    type: date
    convert_tz: no
    view_label: "Sales Over Time"
    label: "Comparison Order Date Range"
    description: "Select a custom previous period you would like to compare to. Must be used with Current Date Range filter."
  }

  dimension: day_in_period {
    description: "Gives the number of days since the start of each period. Use this to align the event dates onto the same axis, the axes will read 1,2,3, etc."
    type: number
    sql:
    {% if current_date_range._is_filtered %}
        CASE
        WHEN {% condition current_date_range %} ${timestamp_date} {% endcondition %}
        THEN DATEDIFF(DAY, {% date_start current_date_range %}, ${timestamp_date}) +1
        WHEN {% condition previous_date_range %} ${timestamp_date} {% endcondition %}
        THEN DATEDIFF(DAY, {% date_start previous_date_range %}, ${timestamp_date}) +1
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
    view_label: "Sales Over Time"
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
    view_label: "Sales Over Time"
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
    view_label: "Sales Over Time"
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
    view_label: "Sales Over Time"
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
    view_label: "Sales Over Time"
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
            WHEN {% condition current_date_range %} ${timestamp_date} {% endcondition %} THEN 'this'
            WHEN {% condition previous_date_range %} ${timestamp_date} {% endcondition %} THEN 'last' END
        {% else %} NULL {% endif %} ;;
  }


  dimension: order_for_period {
    hidden: yes
    type: number
    sql:
        {% if current_date_range._is_filtered %}
            CASE
            WHEN {% condition current_date_range %} ${timestamp_date} {% endcondition %}
            THEN 1
            WHEN ${timestamp_date} between ${period_2_start_date} and ${period_2_end_date}
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
    view_label: "Sales Over Time"
    label: "Period"
    description: "Pivot me! Returns the period the metric covers, i.e. either the 'This Period' or 'Previous Period'"
    type: string
    order_by_field: order_for_period
    sql:
        {% if current_date_range._is_filtered %}
            CASE
            WHEN {% condition current_date_range %} ${timestamp_date} {% endcondition %}
            THEN 'This {% parameter compare_to %}'
            WHEN ${timestamp_date} between ${period_2_start_date} and ${period_2_end_date}
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
    view_label: "Sales Over Time"
    description: "Gives the number of days in the current period date range"
    type: number
    sql: DATEDIFF(d, {% date_start current_date_range %}, {% date_end current_date_range %}) ;;
  }




  measure: current_period_gross_sales {
    view_label: "Sales Over Time"
    group_label: "Current Period Measures"
    type: sum
    sql: ${gross_sales};;
    filters: [period_filtered_measures: "this"]
  }
  measure: comparison_period_gross_sales {
    view_label: "Sales Over Time"
    group_label: "Comparison Period Measures"
    type: sum
    sql: ${gross_sales};;
    filters: [period_filtered_measures: "last"]
  }
  measure: current_period_discounts {
    view_label: "Sales Over Time"
    group_label: "Current Period Measures"
    type: sum
    sql: ${discounts};;
    filters: [period_filtered_measures: "this"]
  }
  measure: comparison_period_discounts {
    view_label: "Sales Over Time"
    group_label: "Comparison Period Measures"
    type: sum
    sql: ${discounts};;
    filters: [period_filtered_measures: "last"]
  }
  measure: current_period_returns {
    view_label: "Sales Over Time"
    group_label: "Current Period Measures"
    type: sum
    sql: ${returns};;
    filters: [period_filtered_measures: "this"]
  }
  measure: comparison_period_returns {
    view_label: "Sales Over Time"
    group_label: "Comparison Period Measures"
    type: sum
    sql: ${returns};;
    filters: [period_filtered_measures: "last"]
  }
  measure: current_period_gift_card_revenue {
    view_label: "Sales Over Time"
    group_label: "Current Period Measures"
    type: sum
    sql: ${gift_card_revenue};;
    filters: [period_filtered_measures: "this"]
  }
  measure: comparison_period_gift_card_revenue {
    view_label: "Sales Over Time"
    group_label: "Comparison Period Measures"
    type: sum
    sql: ${gift_card_revenue};;
    filters: [period_filtered_measures: "last"]
  }
  measure: current_period_net_sales {
    view_label: "Sales Over Time"
    group_label: "Current Period Measures"
    type: sum
    sql: ${net_sales};;
    filters: [period_filtered_measures: "this"]
  }
  measure: comparison_period_net_sales {
    view_label: "Sales Over Time"
    group_label: "Comparison Period Measures"
    type: sum
    sql: ${net_sales};;
    filters: [period_filtered_measures: "last"]
  }
  measure: current_period_total_cost {
    view_label: "Sales Over Time"
    group_label: "Current Period Measures"
    type: sum
    sql: ${total_cost};;
    filters: [period_filtered_measures: "this"]
  }
  measure: comparison_period_total_cost {
    view_label: "Sales Over Time"
    group_label: "Comparison Period Measures"
    type: sum
    sql: ${total_cost};;
    filters: [period_filtered_measures: "last"]
  }
  measure: current_period_gross_profit {
    view_label: "Sales Over Time"
    group_label: "Current Period Measures"
    type: sum
    sql: ${gross_profit};;
    filters: [period_filtered_measures: "this"]
  }
  measure: comparison_period_gross_profit {
    view_label: "Sales Over Time"
    group_label: "Comparison Period Measures"
    type: sum
    sql: ${gross_profit};;
    filters: [period_filtered_measures: "last"]
  }
  measure: current_period_taxes {
    view_label: "Sales Over Time"
    group_label: "Current Period Measures"
    type: sum
    sql: ${taxes};;
    filters: [period_filtered_measures: "this"]
  }
  measure: comparison_period_taxes {
    view_label: "Sales Over Time"
    group_label: "Comparison Period Measures"
    type: sum
    sql: ${taxes};;
    filters: [period_filtered_measures: "last"]
  }
  measure: current_period_shipping {
    view_label: "Sales Over Time"
    group_label: "Current Period Measures"
    type: sum
    sql: ${shipping};;
    filters: [period_filtered_measures: "this"]
  }
  measure: comparison_period_shipping {
    view_label: "Sales Over Time"
    group_label: "Comparison Period Measures"
    type: sum
    sql: ${shipping};;
    filters: [period_filtered_measures: "last"]
  }
  measure: current_period_total_sales {
    view_label: "Sales Over Time"
    group_label: "Current Period Measures"
    type: sum
    sql: ${total_sales};;
    filters: [period_filtered_measures: "this"]
  }
  measure: comparison_period_total_sales {
    view_label: "Sales Over Time"
    group_label: "Comparison Period Measures"
    type: sum
    sql: ${total_sales};;
    filters: [period_filtered_measures: "last"]
  }
  measure: current_period_orders {
    view_label: "Sales Over Time"
    group_label: "Current Period Measures"
    type: sum
    sql: ${orders};;
    filters: [period_filtered_measures: "this"]
  }
  measure: comparison_period_orders {
    view_label: "Sales Over Time"
    group_label: "Comparison Period Measures"
    type: sum
    sql: ${orders};;
    filters: [period_filtered_measures: "last"]
  }
  measure: current_period_ordered_item_quantity {
    view_label: "Sales Over Time"
    group_label: "Current Period Measures"
    type: sum
    sql: ${ordered_item_quantity};;
    filters: [period_filtered_measures: "this"]
  }
  measure: comparison_period_ordered_item_quantity {
    view_label: "Sales Over Time"
    group_label: "Comparison Period Measures"
    type: sum
    sql: ${ordered_item_quantity};;
    filters: [period_filtered_measures: "last"]
  }
  measure: current_period_returned_item_quantity {
    view_label: "Sales Over Time"
    group_label: "Current Period Measures"
    type: sum
    sql: ${returned_item_quantity};;
    filters: [period_filtered_measures: "this"]
  }
  measure: comparison_period_returned_item_quantity {
    view_label: "Sales Over Time"
    group_label: "Comparison Period Measures"
    type: sum
    sql: ${returned_item_quantity};;
    filters: [period_filtered_measures: "last"]
  }
  measure: current_period_net_quantity {
    view_label: "Sales Over Time"
    group_label: "Current Period Measures"
    type: sum
    sql: ${net_quantity};;
    filters: [period_filtered_measures: "this"]
  }
  measure: comparison_period_net_quantity {
    view_label: "Sales Over Time"
    group_label: "Comparison Period Measures"
    type: sum
    sql: ${net_quantity};;
    filters: [period_filtered_measures: "last"]
  }


####### END COMPARISON DIMENSIONS/FILTERS #######

  dimension: primary_key {
    type: string
    sql: CONCAT(CONCAT(CONCAT(CONCAT(CAST(${order_id} as VARCHAR), CAST(${glew_account_id} as VARCHAR)),  CAST(${line_item_id} as VARCHAR)), CAST(${product_id} as VARCHAR)), CAST(${timestamp_raw} as VARCHAR)) ;;
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
    sql: date_trunc('week', ${timestamp_date} + interval {% parameter week_start %}) - interval {% parameter week_start %};;
  }
  dimension: alternate_day_start {
    sql: to_char(date_trunc('Day',${timestamp_date} - interval {% parameter week_start %}), 'YYYY-MM-DD') ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
  }
  dimension: line_item_id {
    type: number
    sql: ${TABLE}.line_item_id ;;
  }
  dimension: product_id {
    type: number
    sql: ${TABLE}.product_id ;;
  }
  dimension: base_product_id {
    type: number
    sql: ${TABLE}.base_product_id ;;
  }

  dimension: glew_account_id {
    type: number
    sql: ${TABLE}.glew_account_id ;;
  }

  dimension_group: timestamp {
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
  }

  dimension: gross_sales {
    type: number
    group_label: "Glew Custom Measure"
    sql: ${TABLE}.gross_sales ;;
  }

  dimension: discounts {
    type: number
    group_label: "Glew Custom Measure"
    sql: ${TABLE}.discounts ;;
  }

  dimension: returns {
    type: number
    group_label: "Glew Custom Measure"
    sql: ${TABLE}.returns ;;
  }

  dimension: gift_card_revenue {
    type: number
    group_label: "Glew Custom Measure"
    sql: ${TABLE}.gift_card_revenue ;;
  }

  dimension: net_sales {
    type: number
    group_label: "Glew Custom Measure"
    sql: ${TABLE}.net_sales ;;
  }

  dimension: total_cost {
    type: number
    group_label: "Glew Custom Measure"
    sql: ${TABLE}.total_cost ;;
  }

  dimension: gross_profit {
    type: number
    group_label: "Glew Custom Measure"
    sql: ${TABLE}.gross_profit ;;
  }

  dimension: taxes {
    type: number
    group_label: "Glew Custom Measure"
    sql: ${TABLE}.taxes ;;
  }

  dimension: shipping {
    type: number
    group_label: "Glew Custom Measure"
    sql: ${TABLE}.shipping ;;
  }

  dimension: total_sales {
    type: number
    group_label: "Glew Custom Measure"
    sql: ${TABLE}.total_sales ;;
  }

  dimension: orders {
    type: number
    group_label: "Glew Custom Measure"
    sql: ${TABLE}.orders ;;
  }

  dimension: ordered_item_quantity {
    type: number
    group_label: "Glew Custom Measure"
    sql: ${TABLE}.ordered_item_quantity ;;
  }

  dimension: returned_item_quantity {
    type: number
    group_label: "Glew Custom Measure"
    sql: ${TABLE}.returned_item_quantity ;;
  }

  dimension: net_quantity {
    type: number
    group_label: "Glew Custom Measure"
    sql: ${TABLE}.net_quantity ;;
  }
  measure: sum_of_gross_sales {
    type: sum
    group_label: "Standard Measures"
    value_format: "0.00"
    sql: ${TABLE}.gross_sales ;;
  }
  measure: sum_of_discounts {
    type: sum
    group_label: "Standard Measures"
    value_format: "0.00"
    sql: ${TABLE}.discounts ;;
  }
  measure: sum_of_returns {
    type: sum
    group_label: "Standard Measures"
    value_format: "0.00"
    sql: ${TABLE}.returns ;;
  }
  measure: sum_of_gift_card_revenue {
    type: sum
    group_label: "Standard Measures"
    sql: ${TABLE}.gift_card_revenue ;;
    value_format: "0.00"
  }
  measure: sum_of_net_sales {
    type: sum
    group_label: "Standard Measures"
    value_format: "0.00"
    sql: ${TABLE}.net_sales ;;
  }
  measure: sum_of_total_cost {
    type: sum
    group_label: "Standard Measures"
    value_format: "0.00"
    sql: ${TABLE}.total_cost ;;
  }
  measure: sum_of_gross_profit {
    type: sum
    group_label: "Standard Measures"
    value_format: "0.00"
    sql: ${TABLE}.gross_profit ;;
  }
  measure: sum_of_taxes {
    type: sum
    group_label: "Standard Measures"
    value_format: "0.00"
    sql: ${TABLE}.taxes ;;
  }
  measure: sum_of_shipping {
    type: sum
    group_label: "Standard Measures"
    value_format: "0.00"
    sql: ${TABLE}.shipping ;;
  }
  measure: sum_of_total_sales {
    type: sum
    group_label: "Standard Measures"
    value_format: "0.00"
    sql: ${TABLE}.total_sales ;;
  }
  measure: sum_of_orders {
    type: sum
    group_label: "Standard Measures"
    sql: ${TABLE}.orders ;;
  }
  measure: sum_of_ordered_item_quantity {
    type: sum
    group_label: "Standard Measures"
    sql: ${TABLE}.ordered_item_quantity ;;
  }
  measure: sum_of_returned_item_quantity {
    type: sum
    group_label: "Standard Measures"
    sql: ${TABLE}.returned_item_quantity ;;
  }
  measure: sum_of_net_quantity {
    type: sum
    group_label: "Standard Measures"
    sql: ${TABLE}.net_quantity ;;
  }
}
