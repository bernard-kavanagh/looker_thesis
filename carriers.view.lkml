view: carriers {
  sql_table_name: flightstats.carriers ;;

  dimension: code {
    primary_key: yes
    type: string
    sql: ${TABLE}.code ;;
  }

  dimension: code_html {
    type: string
    sql: ${TABLE}.code ;;
    html:  <div style="background-color: lightgreen">{{ value }}</div> ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: nickname {
    type: string
    sql: ${TABLE}.nickname ;;
  }

  measure: count {
    type: count
    drill_fields: [name, nickname]
  }
}
