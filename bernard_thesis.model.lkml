connection: "looker-dcl-dev"

# include all the views
include: "*.view"

# include all the dashboards


datagroup: bernard_thesis_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: bernard_thesis_default_datagroup

explore: accidents {
  sql_always_where: ${event_year} BETWEEN 2000 AND 2011 AND ${air_carrier} IS NOT NULL ;;
  join: aircraft {
    type: left_outer
    relationship: many_to_one
    sql_on: ${accidents.registration_number} = ${aircraft.tail_num} ;;
  }
  join: carriers {
    type: left_outer
    relationship: many_to_many
    sql_on: ${accidents.air_carrier} = ${carriers.name} ;;
  }
  join: aircraft_models {
    type: left_outer
    relationship: many_to_one
    sql_on: ${aircraft.aircraft_model_code} = ${aircraft_models.aircraft_model_code} ;;
  }
  join: flights_by_day {
    type: left_outer
    relationship: one_to_many
    sql_on: ${aircraft.tail_num} = ${flights_by_day.tail_num} ;;
  }
  join: flights {
    type: left_outer
    relationship: one_to_many
    sql_on: ${aircraft.tail_num} = ${flights.tail_num} ;;
}
  join: airports {
    type: left_outer
    relationship: one_to_many
    sql_on: ${airports.code} = ${flights.origin} ;;
}
  join: weather_flattened {
    type: full_outer
    relationship: one_to_many
    sql_on: ${accidents.event_date} = ${weather_flattened.weather_date} AND ${airports.state} = ${weather_flattened.state};;
  }
}
explore: aircraft {
  join: ontime {
    type: left_outer
    relationship: one_to_one
    sql_on: ${aircraft.tail_num} = ${ontime.tail_num} ;;
  }
  join: flights_incoming {
    from: flights
    type: left_outer
    relationship: many_to_one
    sql_on: ${aircraft.tail_num} = ${flights_incoming.tail_num} ;;
  }
  join: flights_outgoing {
    from: flights
    type: left_outer
    relationship: many_to_one
    sql_on: ${flights_outgoing.tail_num} = ${aircraft.tail_num} ;;
  }
  join: aircraft_models {
    type: left_outer
    relationship: one_to_many
    sql_on: ${aircraft.aircraft_model_code} = ${aircraft_models.aircraft_model_code} ;;
  }
  join: airports {}
}

explore: aircraft_models {}

explore: airports {
  always_join: [aircraft]
  join: flights {
    type: left_outer
    relationship: many_to_one
    sql_on: ${airports.code} = ${flights.origin} ;;
  }
  join: aircraft {
    type: left_outer
    relationship: one_to_many
    sql_on: ${aircraft.tail_num} = ${flights.tail_num} ;;
  }
  join: ontime {
    relationship: one_to_one
    type: left_outer
    sql_on: ${airports.code} = ${ontime.origin} ;;
  }
  join: flights_by_day {
    type: left_outer
    relationship: many_to_one
    sql_on: ${flights.id2} = ${flights_by_day.id2} ;;
  }
  join: carriers {
    type: left_outer
    relationship: one_to_many
    sql_on: ${carriers.code} = ${flights.carrier} ;;
  }
  join: accidents {
    type: left_outer
    relationship: one_to_one
    sql_on: ${accidents.registration_number} = ${aircraft.tail_num} ;;
  }
  join: aircraft_models {
    type: left_outer
    relationship: one_to_many
    sql_on: ${aircraft.aircraft_model_code} = ${aircraft_models.aircraft_model_code} ;;
  }

}

explore: delays {
  from: airports
  join: flights_by_day {
    type: left_outer
    relationship: one_to_one
    sql_on: ${delays.code} = ${flights_by_day.origin} ;;
  }
}

explore: carriers {}

explore: flights {
  join: flights_by_day {
    type: left_outer
    relationship: many_to_one
    sql_on: ${flights.id2} = ${flights_by_day.id2} ;;
  }
  join: airports {
    type: left_outer
    relationship: many_to_one
    sql_on: ${flights.origin} = ${airports.code} ;;
  }
}

explore: sessionsation {}

explore: peer_to_peer_sessionisation {
  label: "Industry Insights"
  join: flights_by_day {
    type: left_outer
    relationship: many_to_one
    sql_on: ${peer_to_peer_sessionisation.id2} = ${flights_by_day.id2} ;;
  }
}

explore: events_sessionised  {}

explore: flights_by_day {}

explore: ontime {}

explore: weather_flattened {
  label: "Weather"
  sql_always_where:
  ((((TIMESTAMP(concat(weather_flattened.year,'-',weather_flattened.mo,'-',weather_flattened.da)) ) >= (TIMESTAMP('2000-01-01 00:00:00'))
  AND (TIMESTAMP(concat(weather_flattened.year,'-',weather_flattened.mo,'-',weather_flattened.da)) ) < (TIMESTAMP('2012-01-01 00:00:00')))))
  ;;
}
explore: bus_max_load {}
