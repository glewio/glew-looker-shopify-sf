view: fact_shopify_location_inventory {
  sql_table_name: fact_shopify_location_inventory ;;
  view_label: "Shopify Location Inventory"

######## COMPARISON DATE RANGE DIMENSIONS/FILTERS #######

   filter: current_date_range {
    type: date
    convert_tz: no
    view_label: "Shopify Location Inventory"
    label: "Current Date Range"
    description: "Select the current date range you are interested in."
  }
  filter: previous_date_range {
    type: date
    convert_tz: no
    view_label: "Shopify Location Inventory"
    label: "Comparison Date Range"
    description: "Select a custom previous period you would like to compare to. Must be used with Current Date Range filter."
  }

  dimension: day_in_period {
    description: "Gives the number of days since the start of each period. Use this to align the event dates onto the same axis, the axes will read 1,2,3, etc."
    type: number
    sql:
    {% if current_date_range._is_filtered %}
        CASE
        WHEN {% condition current_date_range %} ${inventory_date} {% endcondition %}
        THEN DATEDIFF(DAY, {% date_start current_date_range %}, ${inventory_date}) +1
        WHEN {% condition previous_date_range %} ${inventory_date} {% endcondition %}
        THEN DATEDIFF(DAY, {% date_start previous_date_range %}, ${inventory_date}) +1
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
    view_label: "Shopify Location Inventory"
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
    view_label: "Shopify Location Inventory"
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
    view_label: "Shopify Location Inventory"
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
    view_label: "Shopify Location Inventory"
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
    view_label: "Shopify Location Inventory"
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
            WHEN {% condition current_date_range %} ${inventory_date} {% endcondition %} THEN 'this'
            WHEN {% condition previous_date_range %} ${inventory_date} {% endcondition %} THEN 'last' END
        {% else %} NULL {% endif %} ;;
  }


  dimension: order_for_period {
    hidden: yes
    type: number
    sql:
        {% if current_date_range._is_filtered %}
            CASE
            WHEN {% condition current_date_range %} ${inventory_date} {% endcondition %}
            THEN 1
            WHEN ${inventory_date} between ${period_2_start_date} and ${period_2_end_date}
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
    view_label: "Shopify Location Inventory"
    label: "Period"
    description: "Pivot me! Returns the period the metric covers, i.e. either the 'This Period' or 'Previous Period'"
    type: string
    order_by_field: order_for_period
    sql:
        {% if current_date_range._is_filtered %}
            CASE
            WHEN {% condition current_date_range %} ${inventory_date} {% endcondition %}
            THEN 'This {% parameter compare_to %}'
            WHEN ${inventory_date} between ${period_2_start_date} and ${period_2_end_date}
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
    view_label: "Shopify Location Inventory"
    description: "Gives the number of days in the current period date range"
    type: number
    sql: DATEDIFF(d, {% date_start current_date_range %}, {% date_end current_date_range %}) ;;
  }




  measure: current_period_quantity {
    view_label: "Shopify Location Inventory"
    group_label: "Current Period Measures"
    type: sum
    sql: ${quantity};;
    filters: [period_filtered_measures: "this"]
  }

  measure: comparison_period_quantity {
    view_label: "Shopify Location Inventory"
    group_label: "Comparison Period Measures"
    type: sum
    sql: ${quantity};;
    filters: [period_filtered_measures: "last"]
  }

####### END COMPARISON DIMENSIONS/FILTERS #######

  dimension: primary_key {
    type: string
    sql:CONCAT(CONCAT(CONCAT(CAST(${inventory_item_id} as VARCHAR), CAST(${glew_account_id} as VARCHAR)),  CAST(${location_id} as VARCHAR)),CAST(${inventory_raw} as VARCHAR)) ;;
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
    sql: date_trunc('week', ${inventory_date} + interval {% parameter week_start %}) - interval {% parameter week_start %};;
  }
  dimension: alternate_day_start {
    sql: to_char(date_trunc('Day',${inventory_date} - interval {% parameter week_start %}), 'YYYY-MM-DD') ;;
  }

  dimension_group: inventory {
    type: time
    description: "The inventory date"
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
    sql: ${TABLE}.date ;;
    drill_fields: [inventory_year,inventory_quarter,inventory_month,inventory_week,inventory_date]
  }

  dimension: inventory_item_id {
    type: number
    description: "The ID of the inventory item"
    value_format: "0"
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: location_id {
    type: number
    description: "The ID of the inventory location"
    value_format: "0"
    sql: ${TABLE}.location_id ;;
  }

  dimension: glew_account_id {
    type: number
    description: "The ID of the Glew Store.  If you have multiple stores, this is the field you use to determine which store you're querying."
    value_format: "0"
    sql: ${TABLE}.glew_account_id ;;
  }

  dimension: quantity {
    type: number
    description: "The quantity of product available"
    group_label: "Glew Custom Measure"
    sql: ${TABLE}.quantity ;;
  }

  dimension: price {
    type: number
    description: "The price of the product"
    sql: ${TABLE}.price ;;
  }

  dimension: cost {
    type: number
    description: "The cost of the product"
    sql: ${TABLE}.cost ;;
  }
  dimension: committed {
    type: number
    group_label: "Glew Custom Measure"
    sql: ${TABLE}.committed ;;
  }
  dimension: on_hand {
    type: number
    group_label: "Glew Custom Measure"
    sql: ${TABLE}.on_hand ;;
  }
  dimension: incoming {
    type: number
    group_label: "Glew Custom Measure"
    sql: ${TABLE}.incoming ;;
  }
  dimension: reserved {
    type: number
    group_label: "Glew Custom Measure"
    sql: ${TABLE}.reserved ;;
  }

  dimension: product_id {
    type: number
    description: "The ID of the child product"
    value_format: "0"
    sql: ${TABLE}.product_id ;;
  }

  dimension: base_product_id {
    type: number
    description: "The ID of the parent product"
    value_format: "0"
    sql: ${TABLE}.base_product_id ;;
    drill_fields: [product_id]
  }

  measure: sum_of_quantity {
    type: sum
    sql: ${TABLE}.quantity ;;
    group_label: "Standard Measures"
  }
  measure: sum_of_on_hand {
    type: sum
    sql: ${TABLE}.on_hand ;;
    group_label: "Standard Measures"
  }
  measure: sum_of_reserved {
    type: sum
    sql: ${TABLE}.reserved ;;
    group_label: "Standard Measures"
  }
  measure: sum_of_incoming {
    type: sum
    sql: ${TABLE}.incoming ;;
    group_label: "Standard Measures"
  }
  measure: sum_of_committed {
    type: sum
    sql: ${TABLE}.committed ;;
    group_label: "Standard Measures"
  }
}
