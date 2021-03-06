view: peer_to_peer_sessionisation {
  derived_table: {
#     persist_for: "48 hours"
  sql: WITH lag AS
        (SELECT
                  logs.carrier AS air_carrier
                , logs.dep_time AS dep_time
                , logs.tail_num AS tail_num
                , logs.flight_id AS id2
                , -1.0*TIMESTAMP_DIFF(
                    LAG(logs.arr_time) OVER ( PARTITION BY logs.tail_num ORDER BY logs.arr_time)
                  , logs.dep_time, MINUTE) AS idle_time
              FROM
        (SELECT *,row_number() OVER (ORDER BY dep_time) AS flight_id
              FROM
        (SELECT
              distinct carrier,origin,destination,flight_num,flight_time,tail_num,dep_time,arr_time
              FROM `looker-dcl-dev.flightstats.flights_by_day`
             -- WHERE carrier  = "AA"
order by dep_time) foo
              )
               AS logs

              )
        SELECT
            lag.air_carrier AS carrier
          , lag.dep_time AS session_start
          , lag.idle_time AS idle_time
          , lag.tail_num AS tail_num
          , lag.id2 AS id2
          , ROW_NUMBER () OVER (ORDER BY lag.tail_num) AS unique_session_id
          , ROW_NUMBER () OVER (PARTITION BY COALESCE(lag.tail_num, CAST(lag.id2 AS STRING)) ORDER BY lag.dep_time) AS session_sequence
          , COALESCE(
                LEAD(lag.dep_time) OVER (PARTITION BY lag.tail_num, lag.id2 ORDER BY lag.dep_time)
              , '6000-01-01') AS next_session_start
        FROM `lag`
        WHERE
        (lag.idle_time > 120 OR lag.idle_time IS NULL)
        AND tail_num = "N178JB"
        ORDER BY session_start
 ;;
}

# {% condition  peer_to_peer_sessionisation.air_carrier %} carrier {% endcondition %}  {% condition tail_number %} tail_num {% endcondition %}
filter: tail_number {
  type: string
  full_suggestions: yes
}

filter: air_carrier {
  type: string
  full_suggestions: yes
}

dimension: comparison {
  type: string
  sql: {% if peer_to_peer_sessionisation.tail_num == peer_to_peer_sessionisation.tail_number.value %} CONCAT("(1)", " ", ${tail_num})
    {% elsif peer_to_peer_sessionisation.tcarrier_name == peer_to_peer_sessionisation.air_carrier.value %} CONCAT("(2) Rest of ", " ",${peer_to_peer_sessionisation.carrier_name})
    {% else %}  "(3) Rest Of Population"
    {% endif %};;
}

measure: total_idle_time {
  type: sum
  sql: ${idle_time} ;;
  drill_fields: [detail*]
}

measure: total_idle_time_this_tail_num {
  type: sum
  sql: ${idle_time};;
  drill_fields: [detail*]
}

measure: total_idle_time_this_airline {
  type: sum
  sql: ${idle_time};;
  drill_fields: [detail*]
}

measure: share_of_idle_time_airline {
  type: number
  description: "This planes idle time over all idle times for same airline"
  sql: ${total_idle_time_this_tail_num} / nullif(${total_idle_time_this_tail_num},0);;
  drill_fields: [detail*]
}

measure: share_of_wallet_within_company {
  description: "This item idle time over all idle time across website"
  type: number
  sql: 100.0 *  ${total_idle_time_this_tail_num}*1.0 / nullif(${total_idle_time},0);;
  drill_fields: [detail*]
}

measure: share_of_wallet_brand_within_company {
  description: "This brand's idle time over all idle time across website"
  type: number
  sql: 100.0 *  ${total_idle_time_this_airline}*1.0 / nullif(${total_idle_time},0);;
  drill_fields: [detail*]
}

measure: count {
  type: count
  drill_fields: [detail*]
}

dimension_group: session_start {
  type: time
  sql: ${TABLE}.session_start ;;
}

dimension: idle_time {
  type: number
  sql: ${TABLE}.idle_time ;;
}

dimension: tail_num {
  type: string
  sql: ${TABLE}.tail_num ;;
}

dimension: id2 {
  type: number
  sql: ${TABLE}.id2 ;;
}

dimension: session_sequence {
  type: number
  sql: ${TABLE}.session_sequence ;;
}

dimension: carrier_name {
  type: string
  sql: ${TABLE}.carrier ;;
}

dimension_group: next_session_start {
  type: time
  sql: ${TABLE}.next_session_start ;;
}

set: detail {
  fields: [
    session_start_time,
    idle_time,
    tail_num,
    id2,
    session_sequence,
    next_session_start_time
  ]
}
}
