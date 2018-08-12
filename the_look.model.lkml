connection: "thelook"

include: "user_facts.view"
include: "orders.view"
# include all views in this project
  # include all dashboards in this project

explore: user_facts {
  join: orders {
    type: left_outer
    relationship: one_to_many
    sql_on: ${user_facts.order_id} = ${orders.id} ;;
  }
}
