view: shopify_order_number {
  view_label: "Shopify Order Timeline"
  derived_table: {
    sql:
      SELECT
        o.glew_account_id,
        o.order_id,
        o.timestamp,
        o.customer_id,
        oc.coupon_code,
        dense_rank() over (partition BY o.customer_id ORDER BY o.timestamp ASC) AS order_number,
        case
          when order_number = 1 then true
          else false
          end as first_order
      FROM
        fact_shopify_orders as o
        LEFT JOIN fact_shopify_order_coupons oc on oc.glew_account_id = o.glew_account_id and oc.order_id = o.order_id
      WHERE
        o.status NOT IN ('cancelled','canceled','failed','voided')
       ;;
  }
  dimension: glew_account_id {
    type: string
    sql: ${TABLE}.glew_account_id ;;
  }
  dimension: order_id {
    type: string
    primary_key: yes
    sql: ${TABLE}.order_id ;;
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
    drill_fields: [timestamp_year, timestamp_quarter, timestamp_month, timestamp_week, timestamp_date]
 }
  dimension: customer_id {
    type: string
    sql: ${TABLE}.customer_id ;;
  }
  dimension: coupon_code {
    type: string
    sql: ${TABLE}.coupon_code ;;
  }
  dimension: order_number {
    type: number
    sql: ${TABLE}.order_number ;;
  }
  dimension: first_order {
    type: yesno
    sql: ${TABLE}.first_order ;;
  }
}
