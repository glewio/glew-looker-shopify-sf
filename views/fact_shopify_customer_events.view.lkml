view: fact_shopify_customer_events {
  sql_table_name: fact_shopify_customer_events ;;
  view_label: "Shopify Customer Events"

  dimension: primary_key {
    type: string
    sql: CONCAT(${glew_account_id},${id},${customer_email},${event_type}) ;;
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
    sql: date_trunc('week', ${event_date} + interval {% parameter week_start %}) - interval {% parameter week_start %};;
  }
  dimension: alternate_day_start {
    sql: to_char(date_trunc('Day',${event_date} - interval {% parameter week_start %}), 'YYYY-MM-DD') ;;
  }

  dimension: accepts_marketing {
    type: yesno
    sql: ${TABLE}.accepts_marketing ;;
  }

  dimension: amount_refunded {
    type: number
    group_label: "Glew Custom Measure"
    sql: ${TABLE}.amount_refunded ;;
  }

  dimension: campaign {
    type: string
    sql: ${TABLE}.campaign ;;
  }

  dimension: channel {
    type: string
    sql: ${TABLE}.channel ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: company {
    type: string
    sql: ${TABLE}.company ;;
  }

  dimension: company_id {
    type: string
    sql: ${TABLE}.company_id ;;
  }

  dimension: cost {
    type: number
    group_label: "Glew Custom Measure"
    sql: ${TABLE}.cost ;;
  }

  dimension: country_code {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country_code ;;
    drill_fields: [state,city]
  }

  dimension: current_campaign {
    type: string
    sql: ${TABLE}.current_campaign ;;
  }

  dimension: current_channel {
    type: string
    sql: ${TABLE}.current_channel ;;
  }

  dimension: current_device {
    type: string
    sql: ${TABLE}.current_device ;;
  }

  dimension: current_metro {
    type: string
    sql: ${TABLE}.current_metro ;;
  }

  dimension: current_source {
    type: string
    sql: ${TABLE}.current_source ;;
  }

  dimension: customer_email {
    type: string
    sql: ${TABLE}.customer_email ;;
  }

  dimension: customer_id {
    type: string
    sql: ${TABLE}.customer_id ;;
  }

  dimension: day_of_week {
    type: string
    sql: ${TABLE}.day_of_week ;;
  }

  dimension: device {
    type: string
    sql: ${TABLE}.device ;;
  }

  dimension: discount {
    type: number
    group_label: "Glew Custom Measure"
    sql: ${TABLE}.discount ;;
  }

  dimension: event_type {
    type: string
    sql: ${TABLE}.event_type ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: gift_card_revenue {
    type: number
    group_label: "Glew Custom Measure"
    sql: ${TABLE}.gift_card_revenue ;;
  }

  dimension: glew_account_id {
    type: number
    value_format: "0"
    sql: ${TABLE}.glew_account_id ;;
  }

  dimension: highest_priced_product {
    type: number
    sql: ${TABLE}.highest_priced_product ;;
  }

  dimension: id {
    type: string
    sql: ${TABLE}.id ;;
  }

  dimension: is_favorited {
    type: yesno
    sql: ${TABLE}.is_favorited ;;
  }

  dimension: is_gift_card {
    type: yesno
    sql: ${TABLE}.is_gift_card ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: line_item_count {
    type: number
    group_label: "Glew Custom Measure"
    sql: ${TABLE}.line_item_count ;;
  }

  dimension: lowest_priced_product {
    type: number
    sql: ${TABLE}.lowest_priced_product ;;
  }

  dimension: loyalty_lion_customer_id {
    type: number
    value_format: "0"
    sql: ${TABLE}.loyalty_lion_customer_id ;;
  }

  dimension: loyalty_lion_enrolled {
    type: yesno
    sql: ${TABLE}.loyalty_lion_enrolled ;;
  }

  dimension_group: loyalty_lion_enrollment {
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
    sql: ${TABLE}.loyalty_lion_enrollment_date ;;
    drill_fields: [loyalty_lion_enrollment_year,loyalty_lion_enrollment_quarter,loyalty_lion_enrollment_month,loyalty_lion_enrollment_week,loyalty_lion_enrollment_date]
  }

  dimension: loyalty_lion_insights_segment {
    type: string
    sql: ${TABLE}.loyalty_lion_insights_segment ;;
  }

  dimension: loyalty_lion_points_approved {
    type: number
    group_label: "Glew Custom Measure"
    sql: ${TABLE}.loyalty_lion_points_approved ;;
  }

  dimension: loyalty_lion_points_pending {
    type: number
    group_label: "Glew Custom Measure"
    sql: ${TABLE}.loyalty_lion_points_pending ;;
  }

  dimension: loyalty_lion_points_spent {
    type: number
    group_label: "Glew Custom Measure"
    sql: ${TABLE}.loyalty_lion_points_spent ;;
  }

  dimension: loyalty_lion_rewards_claimed {
    type: number
    group_label: "Glew Custom Measure"
    sql: ${TABLE}.loyalty_lion_rewards_claimed ;;
  }

  dimension: loyalty_lion_tier {
    type: string
    sql: ${TABLE}.loyalty_lion_tier ;;
  }

  dimension: metro {
    type: string
    sql: ${TABLE}.metro ;;
  }

  dimension: order_source {
    type: string
    sql: ${TABLE}.order_source ;;
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

  dimension: shipping {
    type: number
    group_label: "Glew Custom Measure"
    sql: ${TABLE}.shipping ;;
  }

  dimension: smile_points {
    type: number
    group_label: "Glew Custom Measure"
    sql: ${TABLE}.smile_points ;;
  }

  dimension: smile_state {
    type: string
    sql: ${TABLE}.smile_state ;;
  }

  dimension: smile_tier {
    type: string
    sql: ${TABLE}.smile_tier ;;
  }

  dimension: source {
    type: string
    sql: ${TABLE}.source ;;
  }

  dimension: state {
    type: string
    map_layer_name: us_states
    sql: ${TABLE}.state ;;
    drill_fields: [city]
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: tax {
    type: number
    group_label: "Glew Custom Measure"
    sql: ${TABLE}.tax ;;
  }

  dimension_group: event {
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
    drill_fields: [event_year,event_quarter,event_month,event_week,event_date]
  }

  dimension: transaction_id {
    type: string
    sql: ${TABLE}.transaction_id ;;
  }

  dimension: yotpo_score {
    type: number
    sql: ${TABLE}.yotpo_score ;;
  }

  dimension: zip {
    type: zipcode
    map_layer_name: us_zipcode_tabulation_areas
    sql: ${TABLE}.zip ;;
  }
  measure: sum_of_amount_refunded {
    type: sum
    sql: ${TABLE}.amount_refunded ;;
  }
  measure: sum_of_cost {
    type: sum
    sql: ${TABLE}.cost ;;
  }
  measure: sum_of_discount {
    type: sum
    sql: ${TABLE}.discount ;;
  }
  measure: sum_of_gift_card_revenue {
    type: sum
    sql: ${TABLE}.gift_card_revenue ;;
  }
  measure: sum_of_line_item_count {
    type: sum
    sql: ${TABLE}.line_item_count ;;
  }
  measure: sum_of_loyalty_lion_points_approved {
    type: sum
    sql: ${TABLE}.loyalty_lion_points_approved ;;
  }

  measure: sum_of_loyalty_lion_points_pending {
    type: sum
    sql: ${TABLE}.loyalty_lion_points_pending ;;
  }

  measure: sum_of_loyalty_lion_points_spent {
    type: sum
    sql: ${TABLE}.loyalty_lion_points_spent ;;
  }

  measure: sum_of_loyalty_lion_rewards_claimed {
    type: sum
    sql: ${TABLE}.loyalty_lion_rewards_claimed ;;
  }
  measure: sum_of_smile_points {
    type: sum
    sql: ${TABLE}.smile_points ;;
  }
  measure: sum_of_quantity {
    type: sum
    sql: ${TABLE}.quantity ;;
  }

  measure: sum_of_revenue {
    type: sum
    sql: ${TABLE}.revenue ;;
  }

  measure: sum_of_shipping {
    type: sum
    sql: ${TABLE}.shipping ;;
  }
  measure: sum_of_tax {
    type: sum
    sql: ${TABLE}.tax ;;
  }
}
