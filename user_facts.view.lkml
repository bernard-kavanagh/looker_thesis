view: user_facts {
  derived_table: {
    sql: SELECT
          user_id AS user_id
          , orders.id AS order_id
          , COUNT(DISTINCT orders.id) AS total_orders
          , COUNT(DISTINCT order_items.id) AS total_items_ordered
          , order_items.sale_price AS item_sale_price
          , SUM(order_items.sale_price) AS total_amount_spent
          , AVG(order_items.sale_price) AS average_amount_orders
          , AVG(order_items.id) AS average_items_ordered
          , orders.created_at AS order_created_date
          , order_items.id AS order_item_id
          , status
          , MAX(orders.created_at) as most_recent_purchase_at
          , MIN(orders.created_at) as first_purchase_at
      FROM demo_db.orders
      JOIN users ON demo_db.orders.user_id = users.id
      JOIN demo_db.order_items ON demo_db.order_items.order_id = demo_db.orders.id
      WHERE {% condition templated_example %} orders.created_at {% endcondition%}
      GROUP BY user_id

       ;;
  }

  filter: templated_example {
    type: date
  }

  measure: count {
    type: count
    label: "Count"
    drill_fields: [detail*]
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: address {
    type: string
    sql: ${TABLE}.address ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension: total_orders {
    type: number
    sql: ${TABLE}.total_orders ;;
  }

  dimension: total_items_ordered {
    type: number
    sql: ${TABLE}.total_items_ordered ;;
  }

  dimension: item_sale_price {
    type: number
    sql: ${TABLE}.item_sale_price ;;
  }

  dimension: total_amount_spent {
    type: number
    sql: ${TABLE}.total_amount_spent ;;
  }

  dimension: average_amount_orders {
    type: number
    sql: ${TABLE}.average_amount_orders ;;
  }

  dimension: average_items_ordered {
    type: number
    sql: ${TABLE}.average_items_ordered ;;
  }

  dimension_group: order_created_date {
    type: time
    sql: ${TABLE}.order_created_date ;;
  }

  dimension: order_item_id {
    type: number
    sql: ${TABLE}.order_item_id ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension_group: most_recent_purchase_at {
    type: time
    sql: ${TABLE}.most_recent_purchase_at ;;
  }

  dimension_group: first_purchase_at {
    type: time
    sql: ${TABLE}.first_purchase_at ;;
  }

  measure: average_spend {
    type: average
    sql: ${total_amount_spent} ;;
    value_format_name: usd
  }

  measure: amount_of_completed_orders {
    type: count_distinct
    sql: ${order_id} ;;
    filters: {
      field: status
      value: "complete"
    }
  }

  measure: amount_of_pending_orders {
    type: count_distinct
    sql:${order_id};;
    filters: {
      field: status
      value: "pending"
    }
  }

  measure: total_lifetime_orders {
    type: count_distinct
    sql: ${order_id} ;;
  }

  measure: address_count{
    type: count_distinct
    sql: ${address} ;;
  }

  set: detail {
    fields: [
      user_id,
      total_amount_spent,
      total_orders,
      status,
      address
    ]
  }
}
