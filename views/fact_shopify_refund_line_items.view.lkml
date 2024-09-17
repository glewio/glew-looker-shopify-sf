view: fact_shopify_refund_line_items {
  sql_table_name: fact_shopify_refund_line_items ;;
  view_label: "Shopify Refund Line Items"

######## COMPARISON DATE RANGE DIMENSIONS/FILTERS #######

   filter: current_date_range {
    type: date
    convert_tz: no
    view_label: "Shopify Refund Line Items"
    label: "Current Refund Date Range"
    description: "Select the current date range you are interested in."
  }
  filter: previous_date_range {
    type: date
    convert_tz: no
    view_label: "Shopify Refund Line Items"
    label: "Comparison Refund Date Range"
    description: "Select a custom previous period you would like to compare to. Must be used with Current Date Range filter."
  }

  dimension: day_in_period {
    description: "Gives the number of days since the start of each period. Use this to align the event dates onto the same axis, the axes will read 1,2,3, etc."
    type: number
    sql:
    {% if current_date_range._is_filtered %}
        CASE
        WHEN {% condition current_date_range %} ${refund_date} {% endcondition %}
        THEN DATEDIFF(DAY, {% date_start current_date_range %}, ${refund_date}) +1
        WHEN {% condition previous_date_range %} ${refund_date} {% endcondition %}
        THEN DATEDIFF(DAY, {% date_start previous_date_range %}, ${refund_date}) +1
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
    view_label: "Shopify Refund Line Items"
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
    view_label: "Shopify Refund Line Items"
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
    view_label: "Shopify Refund Line Items"
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
    view_label: "Shopify Refund Line Items"
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
    view_label: "Shopify Refund Line Items"
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
            WHEN {% condition current_date_range %} ${refund_date} {% endcondition %} THEN 'this'
            WHEN {% condition previous_date_range %} ${refund_date} {% endcondition %} THEN 'last' END
        {% else %} NULL {% endif %} ;;
  }


  dimension: order_for_period {
    hidden: yes
    type: number
    sql:
        {% if current_date_range._is_filtered %}
            CASE
            WHEN {% condition current_date_range %} ${refund_date} {% endcondition %}
            THEN 1
            WHEN ${refund_date} between ${period_2_start_date} and ${period_2_end_date}
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
    view_label: "Shopify Refund Line Items"
    label: "Period"
    description: "Pivot me! Returns the period the metric covers, i.e. either the 'This Period' or 'Previous Period'"
    type: string
    order_by_field: order_for_period
    sql:
        {% if current_date_range._is_filtered %}
            CASE
            WHEN {% condition current_date_range %} ${refund_date} {% endcondition %}
            THEN 'This {% parameter compare_to %}'
            WHEN ${refund_date} between ${period_2_start_date} and ${period_2_end_date}
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
    view_label: "Shopify Refund Line Items"
    description: "Gives the number of days in the current period date range"
    type: number
    sql: DATEDIFF(d, {% date_start current_date_range %}, {% date_end current_date_range %}) ;;
  }
  measure: current_period_quantity {
    view_label: "Shopify Refund Line Items"
    group_label: "Current Period Measures"
    type: sum
    sql: ${quantity};;
    filters: [period_filtered_measures: "this"]
  }

  measure: comparison_period_quantity {
    view_label: "Shopify Refund Line Items"
    group_label: "Comparison Period Measures"
    type: sum
    sql: ${quantity};;
    filters: [period_filtered_measures: "last"]
  }
  measure: current_period_revenue {
    view_label: "Shopify Refund Line Items"
    group_label: "Current Period Measures"
    type: sum
    sql: ${revenue};;
    filters: [period_filtered_measures: "this"]
  }

  measure: comparison_period_revenue {
    view_label: "Shopify Refund Line Items"
    group_label: "Comparison Period Measures"
    type: sum
    sql: ${revenue};;
    filters: [period_filtered_measures: "last"]
  }
  measure: current_period_amount {
    view_label: "Shopify Refund Line Items"
    group_label: "Current Period Measures"
    type: sum
    sql: ${amount};;
    filters: [period_filtered_measures: "this"]
  }

  measure: comparison_period_amount {
    view_label: "Shopify Refund Line Items"
    group_label: "Comparison Period Measures"
    type: sum
    sql: ${amount};;
    filters: [period_filtered_measures: "last"]
  }
  measure: current_period_cost {
    view_label: "Shopify Refund Line Items"
    group_label: "Current Period Measures"
    type: sum
    sql: ${cost};;
    filters: [period_filtered_measures: "this"]
  }

  measure: comparison_period_cost {
    view_label: "Shopify Refund Line Items"
    group_label: "Comparison Period Measures"
    type: sum
    sql: ${cost};;
    filters: [period_filtered_measures: "last"]
  }
  measure: current_period_total_tax {
    view_label: "Shopify Refund Line Items"
    group_label: "Current Period Measures"
    type: sum
    sql: ${total_tax};;
    filters: [period_filtered_measures: "this"]
  }

  measure: comparison_period_total_tax {
    view_label: "Shopify Refund Line Items"
    group_label: "Comparison Period Measures"
    type: sum
    sql: ${total_tax};;
    filters: [period_filtered_measures: "last"]
  }
  measure: current_period_number_of_refund_line_items {
    view_label: "Shopify Refund Line Items"
    group_label: "Current Period Measures"
    type: count_distinct
    sql: ${line_item_id};;
    filters: [period_filtered_measures: "this"]
  }

  measure: comparison_period_number_of_refund_line_items {
    view_label: "Shopify Refund Line Items"
    group_label: "Comparison Period Measures"
    type: count_distinct
    sql: ${line_item_id};;
    filters: [period_filtered_measures: "last"]
  }

####### END COMPARISON DIMENSIONS/FILTERS #######

  dimension: primary_key {
    type: string
    sql: CONCAT(${glew_account_id},${line_item_id}) ;;
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
    sql: date_trunc('week', ${refund_date} + interval {% parameter week_start %}) - interval {% parameter week_start %};;
  }
  dimension: alternate_day_start {
    sql: to_char(date_trunc('Day',${refund_date} - interval {% parameter week_start %}), 'YYYY-MM-DD') ;;
  }

  dimension: refund_line_item_id {
    type: number
    description: "The ID of the refund line item"
    value_format: "0"
    sql: ${TABLE}.refund_line_item_id ;;
  }
  dimension: glew_account_id {
    type: number
    description: "The ID of the Glew Store.  If you have multiple stores, this is the field you use to determine which store you're querying."
    value_format: "0"
    sql: ${TABLE}.glew_account_id ;;
  }
  dimension_group: refund {
    type: time
    description: "The date of the refund"
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
    drill_fields: [refund_year, refund_quarter, refund_month, refund_week, refund_date]
  }
  dimension: refund_id {
    type: number
    description: "The ID of the refund"
    value_format: "0"
    sql: ${TABLE}.refund_id ;;
    drill_fields: [refund_line_item_id]
  }
  dimension: line_item_id {
    type: number
    description: "The ID of the line item"
    value_format: "0"
    sql: ${TABLE}.line_item_id ;;
  }
  dimension: order_id {
    type: number
    description: "The ID of the order"
    value_format: "0"
    sql: ${TABLE}.order_id ;;
    drill_fields: [line_item_id]
  }
  dimension: product_id {
    type: number
    description: "The ID of the child product"
    value_format: "0"
    sql: ${TABLE}.product_id ;;
  }
  dimension: customer_email {
    type: string
    description: "The customer's email address"
    sql: ${TABLE}.customer_email ;;
  }
  dimension: revenue {
    type: number
    description: "The gross revenue of the order"
    group_label: "Glew Custom Measure"
    sql: ${TABLE}.revenue ;;
  }
  dimension: cost {
    type: number
    description: "The total cost on the order"
    group_label: "Glew Custom Measure"
    sql: ${TABLE}.cost ;;
  }
  dimension: amount {
    type: number
    description: "The amount of the refund"
    group_label: "Glew Custom Measure"
    sql: ${TABLE}.amount ;;
  }
  dimension: quantity {
    type: number
    description: "The quantity of product on the refund"
    group_label: "Glew Custom Measure"
    sql: ${TABLE}.quantity ;;
  }
  dimension: product {
    type: string
    description: "The name of the child product"
    sql: ${TABLE}.product ;;
  }
  dimension: status {
    type: string
    description: "The status of the refund"
    sql: ${TABLE}.status ;;
  }
  dimension: day_of_week {
    type: string
    description: "The day of the week the refund was placed"
    sql: ${TABLE}.day_of_week ;;
  }
  dimension: device {
    type: string
    description: "Device from GA ecommerce associated with 1st order of the customer"
    sql: ${TABLE}.device ;;
  }
  dimension: channel {
    type: string
    description: "Channel from GA ecommerce associated with 1st order of the customer"
    sql: ${TABLE}.channel ;;
  }
  dimension: source {
    type: string
    description: "Source from GA ecommerce associated with 1st order of the customer"
    sql: ${TABLE}.source ;;
  }
  dimension: metro {
    type: string
    description: "Metro from GA ecommerce associated with 1st order of the customer"
    sql: ${TABLE}.metro ;;
  }
  dimension: campaign {
    type: string
    description: "Campagin from GA ecommerce associated with 1st order of the customer"
    sql: ${TABLE}.campaign ;;
  }
  dimension: current_device {
    type: string
    description: "Device from GA associated with the last click of the customer"
    sql: ${TABLE}.current_device ;;
  }
  dimension: current_channel {
    type: string
    description: "Channel from GA associated with the last click of the customer"
    sql: ${TABLE}.current_channel ;;
  }
  dimension: current_source {
    type: string
    description: "Source from GA associated with the last click of the customer"
    sql: ${TABLE}.current_source ;;
  }
  dimension: current_metro {
    type: string
    description: "Metro from GA associated with the last click of the customer"
    sql: ${TABLE}.current_metro ;;
  }
  dimension: current_campaign {
    type: string
    description: "Campaign from GA associated with the last click of the customer"
    sql: ${TABLE}.current_campaign ;;
  }
  dimension: base_product_id {
    type: number
    description: "The ID of the parent product"
    value_format: "0"
    sql: ${TABLE}.base_product_id ;;
    drill_fields: [product_id]
  }
  dimension: transaction_id {
    type: string
    description: "Order ID or number as mapped in GA"
    sql: ${TABLE}.transaction_id ;;
  }
  dimension: manufacturer {
    type: string
    description: "The manufacturer/vendor of the product"
    sql: ${TABLE}.manufacturer ;;
  }
  dimension: is_gift_card {
    type: string
    description: "Whether or not the order was paid for by a giftcard"
    sql: ${TABLE}.is_gift_card ;;
  }
  dimension: order_source {
    type: string
    description: "Orders submitted from the stores website will include a www value.  Orders submitted with the API will be set to External"
    sql: ${TABLE}.order_source ;;
  }
  dimension: first_name {
    type: string
    description: "The customer's first name"
    sql: ${TABLE}.first_name ;;
  }
  dimension: last_name {
    type: string
    description: "The customer's last name"
    sql: ${TABLE}.last_name ;;
  }
  dimension: city {
    type: string
    description: "The city of the customer's order address"
    sql: ${TABLE}.city ;;
  }
  dimension: state {
    type: string
    description: "The state of the customer's order address"
    map_layer_name: us_states
    sql: ${TABLE}.state ;;
    drill_fields: [city]
  }
  dimension: country_code {
    type: string
    description: "The country code of the customer's order address"
    map_layer_name: countries
    sql: ${TABLE}.country_code ;;
    drill_fields: [state,city]
  }
  dimension: zip {
    type: zipcode
    description: "The zip code of the customer's order address"
    map_layer_name: us_zipcode_tabulation_areas
    sql: ${TABLE}.zip ;;
  }
  dimension: fulfillment_status {
    type: string
    description: "The status of the order fulfillment"
    sql: ${TABLE}.fulfillment_status ;;
  }
  dimension: location_id {
    type: number
    description: "The ID of the product's inventory location"
    value_format: "0"
    sql: ${TABLE}.location_id ;;
  }
  dimension: location {
    type: string
    description: "The name of the product's inventory location"
    sql: ${TABLE}.location ;;
  }
  dimension: restock_type {
    type: string
    description: "Method by which the refunded items will be restocked back into the store's inventory"
    sql: ${TABLE}.restock_type ;;
  }
  dimension: total_tax {
    type: number
    description: "The total tax on the product of the refund"
    group_label: "Glew Custom Measure"
    sql: ${TABLE}.total_tax ;;
  }

  measure: number_of_refund_items {
    type: count_distinct
    sql: ${line_item_id} ;;
    description: "Distinct Count of Line Item ID"
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
  measure: sum_of_amount {
    type: sum
    sql: ${TABLE}.amount ;;
    group_label: "Standard Measures"
  }
  measure: sum_of_quantity {
    type: sum
    sql: ${TABLE}.quantity ;;
    group_label: "Standard Measures"
  }
  measure: sum_of_total_tax {
    type: sum
    sql: ${TABLE}.total_tax ;;
    group_label: "Standard Measures"
  }
}
