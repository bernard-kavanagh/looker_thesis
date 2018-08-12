view: bus_max_load {
  sql_table_name: `fh-bigquery.mta_nyc_si.201410_bus_max_load`
    ;;

  dimension: hh {
    type: number
    sql: ${TABLE}.hh ;;
  }

  dimension: load_per_bus {
    type: number
    sql: ${TABLE}.load_per_bus ;;
  }

  dimension: max_load {
    type: number
    sql: ${TABLE}.max_load ;;
  }

  dimension: route_id {
    type: string
    sql: ${TABLE}.route_id ;;
  }

  dimension: spa_dir {
    type: string
    sql: ${TABLE}.spa_dir ;;
  }

  dimension: stop_id {
    type: number
    sql: ${TABLE}.stop_id ;;
  }

  dimension: stop_name {
    type: string
    sql: ${TABLE}.stop_name ;;
  }

  dimension: trips {
    type: number
    sql: ${TABLE}.trips ;;
  }

  measure: count {
    type: count
    drill_fields: [stop_name]
  }
}
