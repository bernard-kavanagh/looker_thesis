view: station_locations {
  derived_table: {
    sql: SELECT DISTINCT( usaf ),
               s.wban,
               g.wban AS gwban,
               name,
               country,
               state,
               icao,
               lat,
               lon,
               elev,
               begin,
               s.end,
               g.stn  AS stn
FROM   `fh-bigquery.weather_gsod.stations2` AS s
       INNER JOIN `bigquery-public-data.noaa_gsod.gsod*` AS g
               ON g.wban = s.wban
                  AND g.stn = s.usaf
WHERE  country = 'US'
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: usaf {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}.usaf ;;
  }

  dimension: wban {
    hidden: yes
    type: string
    sql: ${TABLE}.wban ;;
  }

  dimension: gwban {
    hidden: yes
    type: string
    sql: ${TABLE}.gwban ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: country {
    type: string
    sql: ${TABLE}.country ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: icao {
    type: string
    sql: ${TABLE}.icao ;;
  }

  dimension: lat {
    hidden: yes
    type: string
    sql: ${TABLE}.lat ;;
  }

  dimension: lon {
    hidden: yes
    type: string
    sql: ${TABLE}.lon ;;
  }

  dimension: geolocation {
    type: location
    sql_latitude: ${lat} ;;
    sql_longitude: ${lon} ;;
  }

  dimension: elev {
    type: string
    sql: ${TABLE}.elev ;;
  }

  dimension: begin {
    type: string
    sql: ${TABLE}.begin ;;
  }

  dimension: end {
    type: string
    sql: ${TABLE}.`end` ;;
  }

  dimension: station {
    type: string
    sql: ${TABLE}.stn ;;
  }

  dimension: station_id {
    type: string
    sql: CASE WHEN ${wban} = '99999' THEN ${station} ELSE ${wban} END;;
  }

  set: detail {
    fields: [
      usaf,
      wban,
      gwban,
      name,
      country,
      state,
      icao,
      lat,
      lon,
      elev,
      begin,
      end,
      station,
      station_id
    ]
  }
}
