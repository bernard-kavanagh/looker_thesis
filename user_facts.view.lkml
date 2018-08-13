view: user_facts {
  derived_table: {
    sql: SELECT  user_id,
        o.order_id AS order_id,
        o.id AS order_item_id,
        SUM(o.sale_price) AS total_spend,
        COUNT(DISTINCT o.order_id) AS total_orders,
        COUNT(o.id) AS number_of_order_items,
        status,
        city, state, country, zip
FROM order_items o
LEFT JOIN orders ON orders.id = o.order_id
JOIN users ON users.id = orders.user_id
GROUP BY 1
 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: has_user_moved {
    type: yesno
    sql: ${address}  ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension: order_item_id {
    type: number
    sql: ${TABLE}.order_item_id ;;
  }

  dimension: number_of_order_items {
    type:  number
    sql: ${TABLE}.number_of_order_items ;;
  }

  dimension: total_spend {
    type: number
    sql: ${TABLE}.total_spend ;;
  }

  dimension: total_orders {
    type: number
    sql: ${TABLE}.total_orders ;;
  }

  dimension: number_of_items {
    type: number
    sql: ${TABLE}.number_of_items ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: city {
    group_label: "Address Components"
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: state {
    group_label: "Address Components"
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: country {
    group_label: "Address Components"
    type: string
    sql: ${TABLE}.country ;;
  }

  dimension: zip {
    group_label: "Address Components"
    type: number
    sql: ${TABLE}.zip ;;
  }

  dimension: address {
    type: string
    sql: CONCAT(${city},","," ",${state},","," ",${country},","," ", ${zip}) ;;
  }

  measure: average_spend {
    type: average
    sql: ${total_spend} ;;
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
  measure: total_lifetime_revenue {
    type: sum
    sql: ${total_spend} ;;
    value_format_name: "usd_0"
  }

  measure: average_number_of_order_items{
    type: average
    sql: ${number_of_order_items} ;;
  }

  measure: address_count{
    type: count_distinct
    sql: ${address} ;;
  }

  set: detail {
    fields: [
      user_id,
      total_spend,
      total_orders,
      status,
      city,
      state,
      country,
      zip
    ]
  }
}
