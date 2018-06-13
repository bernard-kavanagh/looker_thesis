view: weather_flattened {
  derived_table: {
    persist_for: "24 hours"
    sql: SELECT DISTINCT( usaf ),
                s.wban,
                g.wban AS gwban,
                NAME,
                country,
                state,
                icao,
                lat,
                lon,
                elev,
                begin,
                s.END,
                g.stn AS stn,
                year,
                mo,
                da,
                wdsp,
                dewp,
                flag_prcp,
                mxpsd,
                gust,
                visib,
                rain_drizzle,
                fog,
                hail,
                snow_ice_pellets,
                thunder,
                tornado_funnel_cloud,
                slp,
                sndp,
                stp,
                temp
FROM            `fh-bigquery.weather_gsod.stations2`     AS s
INNER JOIN      `bigquery-public-data.noaa_gsod.gsod20*` AS g
ON              g.wban = s.wban
AND             g.stn = s.usaf
WHERE           country = 'US'
 ;;
  }
  dimension: station_id {
    type: string
    sql: CASE WHEN ${wban} = '99999' THEN ${station} ELSE ${wban} END;;
  }

  dimension: primary_key {
    hidden: yes
    primary_key: yes
    type: string
    sql: concat(cast(${station} as string), ${wban}, cast(${weather_date} as string)) ;;
  }

  dimension: station {
    hidden: yes
    type: string
    sql: ${TABLE}.stn ;;
  }

  dimension: wban {
    hidden: yes
    type: string
    sql: ${TABLE}.wban ;;
  }

  dimension: windspeed {
    group_label: "Weather Event"
#     hidden: yes
    type: string
    sql: ${TABLE}.wdsp ;;
  }

  dimension: year {
    hidden: yes
    type: string
    sql: REGEXP_EXTRACT(_TABLE_SUFFIX,r'\d\d\d\d') ;;
  }

  dimension_group: weather {
    type: time
    timeframes: [date, month, month_name, year]
    sql: TIMESTAMP(concat(${TABLE}.year,'-',${month},'-',${day})) ;;
    convert_tz: no
  }

  dimension: dew_point {
    group_label: "Weather Event"
    type: number
    sql: ${TABLE}.dewp ;;
  }

  dimension: flag_prcp {
    hidden: yes
    type: string
    sql: ${TABLE}.flag_prcp ;;
  }

  dimension: max_wind_speed {
    group_label: "Weather Event"
    type: string
    sql: ${TABLE}.mxpsd ;;
  }

  dimension: gust {
    group_label: "Weather Event"
    type: number
    sql: ${TABLE}.gust ;;
  }

  dimension: visibility {
    group_label: "Weather Event"
    type: number
    sql: ${TABLE}.visib ;;
  }

  dimension: rainfall {
    type: number
    sql: case when ${TABLE}.prcp = 99.99 then null else ${TABLE}.prcp end;;
  }

  dimension: has_rainfall {
    group_label: "Event Occurrence"
    type: yesno
    sql: ${rainfall} > 0.0 ;;
  }

  measure: total_rainfall {
    group_label: "Station"
    type: sum
    sql: ${rainfall} ;;
    value_format_name: decimal_2
  }

  measure: total_snow_inches {
    group_label: "Station"
    type: sum
    sql: ${snow};;
    value_format_name: decimal_2
  }

  measure: average_rainfall {
    type: average
    sql: ${rainfall} ;;
    value_format_name: decimal_2
  }


## Aggregated Station Counts by Year --
  measure: total_days_with_rainfall{
    type: count
    filters: {
      field: has_rainfall
      value: "yes"
    }
  }

  dimension: rain_drizzle {
    group_label: "Event Occurrence"
    type: yesno
    sql: ${TABLE}.rain_drizzle = '1' ;;
  }

  dimension: fog {
    group_label: "Event Occurrence"
    type: yesno
    sql: ${TABLE}.fog = '1';;
  }

  dimension: hail {
    group_label: "Event Occurrence"
    type: yesno
    sql: ${TABLE}.hail = '1' ;;
  }

  dimension: snow_ice_pellets {
    group_label: "Event Occurrence"
    type: yesno
    sql: ${TABLE}.snow_ice_pellets = '1' ;;
  }

  dimension: thunder {
    group_label: "Event Occurrence"
    type: yesno
    sql: ${TABLE}.thunder = '1';;
  }

  dimension: tornado_funnel_cloud {
    group_label: "Event Occurrence"
    type: yesno
    sql: ${TABLE}.tornado_funnel_cloud = '1' ;;
  }

  dimension: sea_level_pressure {
    group_label: "Weather Event"
    type: number
    sql: ${TABLE}.slp ;;
  }

  dimension: snow {
    label: "Snow (inches)"
    type: number
    sql: case when ${TABLE}.sndp = 999.9 then null else ${TABLE}.sndp end;;
  }

  dimension: mean_station_pressure {
    hidden: yes
    type: number
    sql: ${TABLE}.stp ;;
  }

  dimension: temperature {
    hidden: yes
    type: number
    sql: case when ${TABLE}.temp = 9999.9 then null else ${TABLE}.temp end ;;
  }

  measure: average_temperature {
    type: average
    sql: ${temperature} ;;
    value_format_name: decimal_2
  }


  measure: min_temperature {
    type: min
    sql: ${TABLE}.min ;;
    value_format_name: decimal_2
  }

  measure: max_temperature {
    type: max
    sql: ${TABLE}.max ;;
    value_format_name: decimal_2
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: usaf {
    hidden: yes
    type: string
    sql: ${TABLE}.usaf ;;
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

  ## Unused Fields

  dimension: month {
    hidden: yes
    type: string
    sql: ${TABLE}.mo ;;
  }

  dimension: day {
    hidden: yes
    type: string
    sql: ${TABLE}.da ;;
  }

  dimension: count_dewp {
    hidden: yes
    type: number
    sql: ${TABLE}.count_dewp ;;
  }

  dimension: count_slp {
    hidden: yes
    type: number
    sql: ${TABLE}.count_slp ;;
  }

  dimension: count_stp {
    hidden: yes
    type: number
    sql: ${TABLE}.count_stp ;;
  }

  dimension: count_temp {
    hidden: yes
    type: number
    sql: ${TABLE}.count_temp ;;
  }

  dimension: flag_max_temp {
    hidden: yes
    type: string
    sql: ${TABLE}.flag_max ;;
  }

  dimension: flag_min_temp {
    hidden: yes
    type: string
    sql: ${TABLE}.flag_min ;;
  }

  dimension: count_visib {
    hidden: yes
    type: number
    sql: ${TABLE}.count_visib ;;
  }

  dimension: count_wdsp {
    hidden: yes
    type: string
    sql: ${TABLE}.count_wdsp ;;
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
      year,
      windspeed,
      dew_point,
      flag_prcp,
      max_wind_speed,
      gust,
      visibility,
      rain_drizzle,
      fog,
      hail,
      snow_ice_pellets,
      thunder,
      tornado_funnel_cloud,
      sea_level_pressure,
      snow,
      mean_station_pressure,
      temperature
    ]
  }
}
