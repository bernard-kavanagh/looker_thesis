view: user_facts {
  derived_table: {
    sql: SELECT  user_id,
        SUM(sale_price) AS total_spent,
        COUNT(DISTINCT o.id) AS total_orders,
        status,
        city, state, country, zip
FROM order_items o
JOIN orders ON orders.id = o.order_id
JOIN users ON users.id = orders.user_id
GROUP BY 1
 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: total_spent {
    type: number
    sql: ${TABLE}.total_spent ;;
  }

  dimension: total_orders {
    type: number
    sql: ${TABLE}.total_orders ;;
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

  set: detail {
    fields: [
      user_id,
      total_spent,
      total_orders,
      status,
      city,
      state,
      country,
      zip
    ]
  }
}
