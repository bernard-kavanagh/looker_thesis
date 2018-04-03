connection: "looker-dcl-dev"

# include all the views
include: "*.view"

# include all the dashboards
include: "*.dashboard"

datagroup: bernard_thesis_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: bernard_thesis_default_datagroup

explore: accidents {}

explore: aircraft {}

explore: aircraft_models {}

explore: airports {}

explore: carriers {}

explore: flights {}

explore: flights_by_day {}

explore: ontime {}
