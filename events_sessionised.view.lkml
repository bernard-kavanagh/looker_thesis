view: events_sessionised {
  derived_table: {
    sql: SELECT
      ROW_NUMBER() OVER (ORDER BY logs.created_at) AS event_id
    ,   logs.carrier
    , logs.origin
    , logs.destination
    , logs.flight_num
    , logs.flight_time
    , logs.tail_num
    , logs.dep_time
    , logs.arr_time
    , peer_to_peer_sessionisation.id2
    , ROW_NUMBER () OVER (PARTITION BY unique_session_id ORDER BY log.created_at) AS event_sequence_within_session
    , ROW_NUMBER () OVER (PARTITION BY unique_session_id ORDER BY log.created_at desc) AS inverse_event_sequence_within_session
FROM `looker-dcl-dev.flightstats.flights_by_day` AS logs
INNER JOIN ${peer_to_peer_sessionisation.SQL_TABLE_NAME} AS sessions
  ON logs.tail_num = peer_to_peer_sessionisation.tail_num
  AND logs.dep_time >= sessions.session_start
  AND logs.dep_time < sessions.next_session_start
WHERE

  logs.tail_num = " N178JB"
 ;;

 }

  filter: air_carrier {
    type: string
    full_suggestions: yes
  }

    measure: count {
      type: count
    }
    dimension: carrier {
      type: string
      sql: ${TABLE}.carrier ;;
    }
    dimension: origin {
      type: string
      sql: ${TABLE}.origin ;;
    }
    dimension: destination {
      type: string
      sql: ${TABLE}.destination ;;
    }
    dimension: flight_num {
      type: string
      sql: ${TABLE}.flight_num ;;
    }
    dimension: flight_time {
      type: string
      sql: ${TABLE}.flight_time ;;
    }
    dimension: tail_num {
      type: string
      sql: ${TABLE}.tail_num ;;
    }
    dimension: dep_time {
      type: date_time_of_day
      sql: ${TABLE}.dep_time ;;
    }
    dimension: arr_time {
      type: date_time_of_day
      sql: ${TABLE}.arr_time ;;
    }
    dimension: id2 {
      primary_key: yes
      type: number
      sql: ${TABLE}.id2 ;;
    }
    dimension: event_sequence_within_session {
      type: string
      sql: ${TABLE}.event_sequence_within_session ;;
    }
    dimension: inverse_event_sequence_within_session {
      type: string
      sql: ${TABLE}.inverse_event_sequence_within_session  ;;
    }
}
