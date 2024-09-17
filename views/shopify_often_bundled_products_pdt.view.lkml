view: shopify_often_bundled_product {
  derived_table:{
    sql: SELECT
        *
      FROM
        (
          SELECT
            li2.product_id AS id,
            li.glew_account_id,
            MAX(gm.customer_group) as customer_group,
            MAX(p.sku) AS sku,
            MAX(p.image) AS thumbnail,
            MAX(p.name) AS often_bundle_products,
            MAX("li"."product") as product_name,
            MAX(p.base_product_id) AS base_product_id,
            MAX(p.base_name) AS base_name,
            COUNT(DISTINCT li2.line_item_id) AS number_purchased,
            COUNT(DISTINCT li2.order_id) AS number_times_bundled,
            MAX(li.total_orders) AS total_orders,
            CASE
              WHEN MAX(li.total_orders) > 0 THEN COUNT(DISTINCT li2.order_id) :: float / MAX(li.total_orders) :: float
              ELSE 0
            END AS bundle_rate
          FROM
            (
              SELECT
                   "li".*,
                 (
                  DENSE_RANK() OVER (
                    ORDER BY
                      li.order_id
                  ) + DENSE_RANK() OVER (
                    ORDER BY
                      li.order_id DESC
                  ) - 1
                ) AS total_orders
              FROM
                "fact_shopify_order_items" AS "li"
                left join dim_glew_accounts as a on a.glew_account_id = li.glew_account_id
                LEFT JOIN "fact_shopify_products" AS "p" ON "p"."product_id" = "li"."product_id"
            AND "p"."glew_account_id" = "li"."glew_account_id"
              WHERE
               "li"."timestamp" BETWEEN {% date_start order_date %} AND  {% date_end order_date %}
                 AND  {% condition base_product %} p.base_name {% endcondition %}
                AND ("li"."status" NOT IN ('cancelled', 'canceled', 'failed','voided')
              )
            ) AS "li"
            LEFT JOIN "fact_shopify_order_items" AS "li2" ON "li2"."glew_account_id" = "li"."glew_account_id"
            AND "li2"."order_id" = "li"."order_id" AND "li2"."product_id" != "li"."product_id"
            LEFT JOIN "fact_shopify_products" AS "p" ON "p"."product_id" = "li2"."product_id"
            AND "p"."glew_account_id" = "li2"."glew_account_id"
            LEFT JOIN "dim_shopify_customer_group_map" as "gm" ON "gm"."email"="li2"."customer_email"
          GROUP BY
            1,
            2
          ORDER BY
            "number_purchased" DESC
        )
      WHERE
        "id" IS NOT NULL  ;;
  }
  view_label: "Shopify Bundled Products"
  # Define your dimensions and measures here, like this:


  filter: order_date{
    type: date
  }
  filter: base_product{
    type: string
  }

  dimension: order_start{
    type: date
    sql: {% date_start order_date %} ;;
    hidden:  yes
  }

  dimension: order_end{
    type: date
    sql: {% date_end order_date %} ;;
    hidden:  yes
  }

  dimension: glew_account_id {
    type: number
    sql: ${TABLE}.glew_account_id ;;
    description: "Glew account id of the store"
  }

  dimension: Product_ID {
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: often_bundle_products {
    type: string
    sql: ${TABLE}.often_bundle_products ;;
  }

  dimension: Product_Name {
    type: string
    sql: ${TABLE}.product_name ;;
    suggestable: yes
  }

  dimension: base_product_id {
    type: number
    sql: ${TABLE}.base_product_id ;;
  }

  dimension: image_url {
    type: string
    description: "The image of the product"
    sql: ${TABLE}.thumbnail ;;
  }

  dimension: image_display {
    sql: ${Product_ID} ;;
    description: "The image of the product"
    html: <img src= {{ image_url }} height=80 /> ;;
  }

  dimension: product_sku {
    description: "sku list"
    type: string
    sql: ${TABLE}.sku ;;
  }

  dimension: base_name {
    type: string
    sql: ${TABLE}.base_name ;;
  }

  dimension: customer_group {
    type: string
    sql: ${TABLE}.customer_group ;;
  }

  dimension: number_of_times_purchased {
    type: number
    sql: ${TABLE}.number_purchased ;;
    hidden:  yes
  }

  dimension: number_of_times_bundled {
    type: number
    sql: ${TABLE}.number_times_bundled ;;
  }

  dimension: number_of_orders {
    type: number
    sql: ${TABLE}.total_orders ;;
  }

  dimension: bundle_rate {
    type: number
    sql: ${TABLE}.bundle_rate ;;
  }
  set: detail {
    fields: [
      glew_account_id,
      Product_ID,
      Product_Name,
      base_name,
      base_product_id,
      product_sku,
      customer_group,
      number_of_times_purchased,
      number_of_times_bundled,
      number_of_orders,
      often_bundle_products,
      bundle_rate
    ]
  }
}
