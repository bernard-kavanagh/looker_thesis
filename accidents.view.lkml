view: accidents {
  sql_table_name: flightstats.accidents ;;

  parameter: airline {
    required_fields: [air_carrier]
    type: string
    full_suggestions: yes
    allowed_value: { value: "American Airlines"}
    allowed_value: { value: "United Airlines  "}
    allowed_value: { value: "Delta Air Lines  "}
    allowed_value: { value: "Southwest Airlines"}
    allowed_value: { value: "Continental Airlines"}
    allowed_value: { value: "Northwest Airlines"}
    allowed_value: { value: "US Airways "}
    allowed_value: { value: "Atlantic Southeast Airlines"}
    allowed_value: { value: "US Airways"}
    allowed_value: { value: "Alaska Airlines"}
    allowed_value: { value: "Jetblue Airways"}
  }

  parameter: State {
    required_fields: [State]
    type: string
    full_suggestions: yes
    suggest_persist_for: "0 seconds"
  }

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: accident_number {
    type: string
    sql: ${TABLE}.accident_number ;;
  }

  dimension: air_carrier {
    type: string
    sql: ${TABLE}.air_carrier ;;
  }

  dimension: aircraft_category {
    type: string
    sql: CASE WHEN ${TABLE}.aircraft_category IS NULL THEN 'Other' ELSE ${TABLE}.aircraft_category END ;;
  }

  dimension: aircraft_damage {
    type: string
    sql: ${TABLE}.aircraft_damage ;;
  }

  dimension: airport_code {
    type: string
    sql: ${TABLE}.airport_code ;;
  }

  dimension: airport_name {
    type: string
    sql: ${TABLE}.airport_name ;;
  }

  dimension: amateur_built {
    type: string
    sql: ${TABLE}.amateur_built ;;
  }

  dimension: broad_phase_of_flight {
    type: string
    sql: ${TABLE}.broad_phase_of_flight ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }

  dimension: engine_type {
    type: string
    sql: ${TABLE}.engine_type ;;
  }

  dimension_group: event {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.event_date ;;
  }

  dimension: event_id {
    type: string
    sql: ${TABLE}.event_id ;;
  }

  dimension: far_description {
    type: string
    sql: ${TABLE}.far_description ;;
  }

  dimension: injury_severity {
    type: string
    sql: ${TABLE}.injury_severity ;;
  }

  dimension: investigation_type {
    type: string
    sql: ${TABLE}.investigation_type ;;
  }

  dimension: latitude {
    hidden: yes
    type: string
    sql: ${TABLE}.latitude ;;
  }

  dimension: location {
    type: string
    sql: ${TABLE}.location ;;
  }

  dimension: longitude {
    hidden: yes
    type: string
    sql: ${TABLE}.longitude ;;
  }
  dimension: geo_location {
    type: location
    sql_latitude: ${latitude};;
    sql_longitude: ${longitude} ;;
  }

  dimension: make {
    type: string
    sql: ${TABLE}.make ;;
  }

  dimension: model {
    type: string
    sql: ${TABLE}.model ;;
  }

  dimension: number_of_engines {
    type: number
    sql: ${TABLE}.number_of_engines ;;
  }

  dimension: number_of_fatalities {
    type: string
    sql: ${TABLE}.number_of_fatalities ;;
  }

  dimension: number_of_minor_injuries {
    type: string
    sql:  ${TABLE}.number_of_minor_injuries ;;
  }

  dimension: number_of_serious_injuries {
    type: string
    sql: ${TABLE}.number_of_serious_injuries ;;
  }

  dimension: number_of_uninjured {
    type: string
    sql: ${TABLE}.number_of_uninjured ;;
  }

  dimension_group: publication {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.publication_date ;;
  }

  dimension: purpose_of_flight {
    type: string
    sql: CASE  WHEN ${TABLE}.purpose_of_flight IS NULL THEN 'Other'
      WHEN ${TABLE}.purpose_of_flight = 'Uknown' THEN 'Other' ELSE ${TABLE}.purpose_of_flight END;;
  }


  dimension: registration_number {
    type: string
    sql: ${TABLE}.registration_number ;;
  }

  dimension: report_status {
    type: string
    sql: ${TABLE}.report_status ;;
  }

  dimension: schedule {
    type: string
    sql: ${TABLE}.schedule ;;
  }

  dimension: weather_condition {
    type: string
    sql: ${TABLE}.weather_condition ;;
  }

  measure: count {
    type: count
    drill_fields: [count,event_year, location, airport_name]
  }

  measure: total_fatalities {
    type: sum_distinct
    sql: CAST(${number_of_fatalities} AS INT64) ;;
    drill_fields: [air_carrier, event_year, broad_phase_of_flight,geo_location, total_fatalities,total_minor_injuries,total_serious_injuries,total_uninjured]
  }
  measure: total_minor_injuries {
    type: sum
    sql: CAST(${number_of_minor_injuries} AS INT64) ;;
    drill_fields: [air_carrier, event_year, broad_phase_of_flight,geo_location, total_fatalities,total_minor_injuries,total_serious_injuries,total_uninjured]
  }
  measure: total_serious_injuries {
    type: sum
    sql:CAST(${number_of_serious_injuries} AS INT64);;
   drill_fields: [air_carrier, event_year, broad_phase_of_flight,geo_location, total_fatalities,total_minor_injuries,total_serious_injuries,total_uninjured]
  }
  measure: total_uninjured {
    type: sum
    sql:CAST(${number_of_uninjured} AS INT64);;
    drill_fields: [air_carrier, event_year, broad_phase_of_flight,geo_location, total_fatalities,total_minor_injuries,total_serious_injuries,total_uninjured]
  }

  set: detail {
    fields: [
      event_year,
      air_carrier ,
      aircraft_damage ,
      airport_code ,
      airport_name ,
      amateur_built ,
      broad_phase_of_flight ,
      country ,
      engine_type ,
      injury_severity ,
      investigation_type ,
      location ,
      make ,
      purpose_of_flight ,
      count
     ]
  }
}
