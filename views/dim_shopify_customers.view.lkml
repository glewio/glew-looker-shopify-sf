view: dim_shopify_customers {
  sql_table_name: dim_shopify_customers ;;
  view_label: "Shopify Customers"

######## COMPARISON DATE RANGE DIMENSIONS/FILTERS #######
  filter: current_date_range {
    type: date
    convert_tz: no
    view_label: "Shopify Customers"
    label: "Current Created Date Range"
    description: "Select the current date range you are interested in."
  }
  filter: previous_date_range {
    type: date
    convert_tz: no
    view_label: "Shopify Customers"
    label: "Comparison Created Date Range"
    description: "Select a custom previous period you would like to compare to. Must be used with Current Date Range filter."
  }

  dimension: day_in_period {
    description: "Gives the number of days since the start of each period. Use this to align the event dates onto the same axis, the axes will read 1,2,3, etc."
    type: number
    sql:
    {% if current_date_range._is_filtered %}
        CASE
        WHEN {% condition current_date_range %} ${created_at_date} {% endcondition %}
        THEN DATEDIFF(DAY, {% date_start current_date_range %}, ${created_at_date}) +1
        WHEN {% condition previous_date_range %} ${created_at_date} {% endcondition %}
        THEN DATEDIFF(DAY, {% date_start previous_date_range %}, ${created_at_date}) +1
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
    view_label: "Shopify Customers"
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
    view_label: "Shopify Customers"
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
    view_label: "Shopify Customers"
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
    view_label: "Shopify Customers"
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
    view_label: "Shopify Customers"
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
            WHEN {% condition current_date_range %} ${created_at_date} {% endcondition %} THEN 'this'
            WHEN {% condition previous_date_range %} ${created_at_date} {% endcondition %} THEN 'last' END
        {% else %} NULL {% endif %} ;;
  }


  dimension: order_for_period {
    hidden: yes
    type: number
    sql:
        {% if current_date_range._is_filtered %}
            CASE
            WHEN {% condition current_date_range %} ${created_at_date} {% endcondition %}
            THEN 1
            WHEN ${created_at_date} between ${period_2_start_date} and ${period_2_end_date}
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
    view_label: "Shopify Customers"
    label: "Period"
    description: "Pivot me! Returns the period the metric covers, i.e. either the 'This Period' or 'Previous Period'"
    type: string
    order_by_field: order_for_period
    sql:
        {% if current_date_range._is_filtered %}
            CASE
            WHEN {% condition current_date_range %} ${created_at_date} {% endcondition %}
            THEN 'This {% parameter compare_to %}'
            WHEN ${created_at_date} between ${period_2_start_date} and ${period_2_end_date}
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
    view_label: "Shopify Customers"
    description: "Gives the number of days in the current period date range"
    type: number
    sql: DATEDIFF(d, {% date_start current_date_range %}, {% date_end current_date_range %}) ;;
  }


  measure: current_period_number_of_customers {
    view_label: "Shopify Customers"
    group_label: "Current Period Measures"
    type: count_distinct
    sql: ${customer_id};;
    filters: [period_filtered_measures: "this"]
  }

  measure: comparison_period_number_of_customers {
    view_label: "Shopify Customers"
    group_label: "Comparison Period Measures"
    type: count_distinct
    sql: ${customer_id};;
    filters: [period_filtered_measures: "last"]
  }

####### END COMPARISON DIMENSIONS/FILTERS #######


  dimension: primary_key {
    type: string
    sql: CONCAT(${glew_account_id},${email}) ;;
    primary_key: yes
    hidden: yes
  }

  dimension: accepts_marketing {
    type: yesno
    description: "A yes/no field that says whether or not the customer accepts marketing"
    sql: ${TABLE}.accepts_marketing ;;
  }

  dimension: campaign {
    type: string
    description: "Campaign from GA ecommerce associated with the customer's order"
    sql: ${TABLE}.campaign ;;
  }

  dimension: channel {
    type: string
    description: "Channel from GA ecommerce associated with the customer's order"
    sql: ${TABLE}.channel ;;
  }

  dimension: city {
    type: string
    description: "The city of the customer's address"
    sql: ${TABLE}.city ;;
  }

  dimension: country_code {
    type: string
    description: "The country code of the customer's address"
    map_layer_name: countries
    sql: ${TABLE}.country_code ;;
    drill_fields: [state,city]
  }

  dimension_group: created_at {
    type: time
    description: "The date in which the customer's account was created"
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
    sql: ${TABLE}.created_at ;;
    drill_fields: [created_year, created_quarter, created_month, created_week, created_date]
  }

  dimension: customer_id {
    type: number
    description: "The ID of the customer"
    value_format: "0"
    sql: ${TABLE}.customer_id ;;
  }

  dimension: device {
    type: string
    description: "Device from GA ecommerce associated with the customer's order"
    sql: ${TABLE}.device ;;
  }

  dimension: email {
    type: string
    description: "The customer's email address"
    sql: ${TABLE}.email ;;
  }

  dimension: first_name {
    type: string
    description: "The customer's first name"
    sql: ${TABLE}.first_name ;;
  }

  dimension_group: first_order {
    type: time
    description: "The date of the customer's first order"
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
    sql: ${TABLE}.first_order_date ;;
    drill_fields: [first_order_year, first_order_quarter, first_order_month, first_order_week, first_order_date]
  }

  dimension: glew_account_id {
    type: number
    description: "The ID of the Glew Store.  If you have multiple stores, this is the field you use to determine which store you're querying."
    value_format: "0"
    sql: ${TABLE}.glew_account_id ;;
  }

  dimension: is_favorited {
    type: yesno
    description: "A yes/no field that says whether or not the customer is favorited in the Shopify system"
    sql: ${TABLE}.is_favorited ;;
  }

  dimension: last_name {
    type: string
    description: "The customer's last name"
    sql: ${TABLE}.last_name ;;
  }

  dimension_group: last_order {
    type: time
    description: "The date of the customer's most recent order"
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
    sql: ${TABLE}.last_order_date ;;
    drill_fields: [last_order_year, last_order_quarter, last_order_month, last_order_week, last_order_date]
  }

  dimension: metro {
    type: string
    description: "Metro from GA ecommerce associated with the customer's order"
    sql: ${TABLE}.metro ;;
  }

  dimension: smile_points {
    type: number
    description: "The number of smile points this customer has"
    sql: ${TABLE}.smile_points ;;
  }

  dimension: smile_state {
    type: string
    description: "The state associated with the customer in smile"
    sql: ${TABLE}.smile_state ;;
  }

  dimension: smile_tier {
    type: string
    description: "The tier associated with the customer in smile"
    sql: ${TABLE}.smile_tier ;;
  }

  dimension: source {
    type: string
    description: "Source from GA ecommerce associated with the customer's order"
    sql: ${TABLE}.source ;;
  }

  dimension: state {
    type: string
    description: "The state of the customer's address"
    map_layer_name: us_states
    sql: ${TABLE}.state ;;
    drill_fields: [city]
  }

  dimension: status {
    type: string
    description: "The customer's status in Shopify"
    sql: ${TABLE}.status ;;
  }
  dimension: company {
    type: string
    sql: ${TABLE}.company ;;
  }

  dimension: zip {
    type: zipcode
    description: "The zip code of the customer's address"
    map_layer_name: us_zipcode_tabulation_areas
    sql: ${TABLE}.zip ;;
  }

  measure: number_of_customers {
    type: count_distinct
    sql: ${email} ;;
    description: "Distinct Count of Email"
  }
}
