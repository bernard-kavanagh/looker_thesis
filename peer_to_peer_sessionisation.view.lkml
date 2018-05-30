view: peer_to_peer_sessionisation {
  derived_table: {
    sql: WITH lag AS
        (SELECT
                  logs.dep_time AS dep_time
                , logs.tail_num AS tail_num
                , logs.flight_id AS id2
                , -1.0*TIMESTAMP_DIFF(
                    LAG(logs.dep_time) OVER ( PARTITION BY logs.tail_num ORDER BY logs.dep_time)
                  , logs.dep_time, MINUTE) AS idle_time
              FROM
              (
              select *,row_number() over (order by dep_time) as flight_id
from
(SELECT

distinct carrier,origin,destination,flight_num,flight_time,tail_num,dep_time,arr_time


FROM `looker-dcl-dev.flightstats.flights_by_day`
where tail_num = 'N361SW'
order by dep_time) foo

              )
               as logs
              -- WHERE ((logs.dep_time) >= CAST(date_add(DATE_TRUNC(CURRENT_DATE(), DAY), INTERVAL -59 DAY) AS TIMESTAMP)
              --       AND (logs.dep_time) < CAST(date_add( date_add(DATE_TRUNC(CURRENT_DATE(), DAY), INTERVAL -59 DAY ), INTERVAL 60 DAY ) AS TIMESTAMP)
              --       ) -- optional limit of events table to only past 60 days
              )
        SELECT
          lag.dep_time AS session_start
          , lag.idle_time AS idle_time
          , lag.tail_num AS tail_num
          , lag.id2 AS id2
          --, ROW_NUMBER () OVER (ORDER BY lag.tail_num) AS unique_session_id
          , ROW_NUMBER () OVER (PARTITION BY COALESCE(lag.tail_num, CAST(lag.id2 AS STRING)) ORDER BY lag.dep_time) AS session_sequence
          , COALESCE(
                LEAD(lag.dep_time) OVER (PARTITION BY lag.tail_num, lag.id2 ORDER BY lag.dep_time)
              , '6000-01-01') AS next_session_start
        FROM `lag`
        WHERE
        (lag.idle_time > 120 OR lag.idle_time IS NULL)
        -- AND
        -- tail_num = 'N361SW'
        ORDER BY session_start
 ;;
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
