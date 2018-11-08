

- dashboard: flightstats__safety__delays
  title: test - Safety & Delays
  layout: newspaper
  query_timezone: query_saved
  elements:
  - name: Airlines with the most Accidents
    title: Airlines with the most Accidents
    model: bernard_thesis
    explore: accidents
    type: looker_column
    fields:
    - accidents.count
    - carriers.name
    filters:
      carriers.name: "-NULL"
      aircraft_models.model: "-NULL"
    sorts:
    - accidents.count desc
    limit: 500
    query_timezone: America/Los_Angeles
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: true
    limit_displayed_rows: false
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_types: {}
    row: 36
    col: 16
    width: 8
    height: 6
  - name: Accident Locations
    title: Accident Locations
    model: bernard_thesis
    explore: airports
    type: looker_map
    fields:
    - accidents.geo_location
    - accidents.count
    filters:
      accidents.count: NOT NULL
      accidents.geo_location: "-NULL"
      accidents.country: United States
    sorts:
    - accidents.count desc
    limit: 500
    column_limit: 50
    map_plot_mode: points
    heatmap_gridlines: false
    heatmap_gridlines_empty: false
    heatmap_opacity: 0.5
    show_region_field: true
    draw_map_labels_above_data: true
    map_tile_provider: light
    map_position: custom
    map_scale_indicator: 'off'
    map_pannable: true
    map_zoomable: true
    map_marker_type: icon
    map_marker_icon_name: airplane
    map_marker_radius_mode: proportional_value
    map_marker_units: meters
    map_marker_proportional_scale_type: linear
    map_marker_color_mode: value
    show_view_names: true
    show_legend: true
    quantize_map_value_colors: false
    reverse_map_value_colors: false
    map: usa
    map_projection: ''
    map_latitude: 40.343927461258914
    map_longitude: -88.73245239257814
    map_zoom: 4
    series_types: {}
    row: 9
    col: 0
    width: 16
    height: 12
  - name: Average Delay time by State and Month
    title: Average Delay time by State and Month
    model: bernard_thesis
    explore: delays
    type: table
    fields:
    - delays.state
    - flights_by_day.average_delay
    - flights_by_day.dep_month_name
    pivots:
    - flights_by_day.dep_month_name
    filters:
      delays.major: Y
      flights_by_day.dep_month_name: "-NULL"
    sorts:
    - delays.state
    - flights_by_day.dep_month_name
    limit: 500
    column_limit: 50
    show_view_names: true
    show_row_numbers: true
    truncate_column_names: true
    hide_totals: false
    hide_row_totals: false
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: true
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    conditional_formatting:
    - type: high to low
      value:
      background_color:
      font_color:
      palette:
        name: Red to Yellow to Green
        colors:
        - "#F36254"
        - "#FCF758"
        - "#4FBC89"
      bold: false
      italic: false
      strikethrough: false
      fields:
    hidden_fields:
    - ontime.count
    - ontime.departure_delay
    row: 61
    col: 0
    width: 24
    height: 11
  - title: Average Delays by Airport and Month
    name: Average Delays by Airport and Month
    model: bernard_thesis
    explore: delays
    type: table
    fields:
    - delays.full_name
    - flights_by_day.dep_month_name
    - flights_by_day.average_delay
    pivots:
    - flights_by_day.dep_month_name
    filters:
      delays.major: Y
      flights_by_day.count_delayed_flights: ">0"
    sorts:
    - flights_by_day.dep_month_name 0
    - flights_by_day.average_delay desc 0
    limit: 500
    column_limit: 50
    show_view_names: false
    show_row_numbers: true
    truncate_column_names: true
    hide_totals: false
    hide_row_totals: false
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: true
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    conditional_formatting:
    - type: high to low
      value:
      background_color:
      font_color:
      palette:
        name: Red to Yellow to Green
        colors:
        - "#F36254"
        - "#FCF758"
        - "#4FBC89"
      bold: false
      italic: false
      strikethrough: false
      fields:
    hidden_fields:
    - ontime.count
    - ontime.departure_delay
    series_labels:
      delays.full_name: Airport Name
      ontime.dep_month_name: Month
      average: Average Delay
    row: 72
    col: 0
    width: 24
    height: 11
  - title: "% of flights delayed By Carrier"
    name: "% of flights delayed By Carrier"
    model: bernard_thesis
    explore: airports
    type: looker_line
    fields:
    - carriers.name
    - flights.count
    - flights_by_day.sum_arr_delay
    - flights_by_day.count_delayed_flights
    filters:
      airports.major: Y
      flights.taxi_in: "<15"
    sorts:
    - flights.count desc
    limit: 20
    dynamic_fields:
    - table_calculation: of_flights_delayed
      label: "% of flights delayed"
      expression: "${flights_by_day.count_delayed_flights}/${flights.count}"
      value_format:
      value_format_name: percent_0
      _kind_hint: measure
      _type_hint: number
    query_timezone: America/Los_Angeles
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    limit_displayed_rows: false
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    show_null_points: true
    point_style: circle_outline
    interpolation: linear
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    value_labels: legend
    label_type: labPer
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_types: {}
    hidden_fields:
    - flights_by_day.sum_arr_delay
    swap_axes: false
    y_axes:
    - label: ''
      orientation: left
      series:
      - id: flights.count
        name: Flights Count
        axisId: flights.count
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      tickDensityCustom: 5
      type: linear
    - label:
      orientation: right
      series:
      - id: of_flights_delayed
        name: "% of flights delayed"
        axisId: of_flights_delayed
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      tickDensityCustom: 5
      type: linear
    - label:
      orientation: right
      series:
      - id: flights_by_day.count_delayed_flights
        name: Flights By Day Count Delayed Flights
        axisId: flights_by_day.count_delayed_flights
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      tickDensityCustom: 5
      type: linear
    reference_lines:
    - reference_type: line
      line_value: mean
      range_start: max
      range_end: min
      margin_top: deviation
      margin_value: mean
      margin_bottom: deviation
      label_position: right
      color: "#000000"
      label: Average % Delayed
    row: 95
    col: 0
    width: 24
    height: 9
  - title: Worst time of year by airport
    name: Worst time of year by airport
    model: bernard_thesis
    explore: delays
    type: table
    fields:
    - delays.full_name
    - flights_by_day.dep_month_name
    - flights_by_day.average_delay
    pivots:
    - flights_by_day.dep_month_name
    filters:
      delays.major: Y
      flights_by_day.count_delayed_flights: ">0"
      delays.full_name: "-ADAK"
    sorts:
    - flights_by_day.dep_month_name 0
    - flights_by_day.average_delay desc 0
    limit: 500
    column_limit: 50
    show_view_names: false
    show_row_numbers: true
    truncate_column_names: true
    hide_totals: false
    hide_row_totals: false
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: true
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    conditional_formatting:
    - type: high to low
      value:
      background_color:
      font_color:
      palette:
        name: Red to Yellow to Green
        colors:
        - "#F36254"
        - "#FCF758"
        - "#4FBC89"
      bold: false
      italic: false
      strikethrough: false
      fields:
    hidden_fields:
    - ontime.count
    - ontime.departure_delay
    series_labels:
      delays.full_name: Airport Name
      ontime.dep_month_name: Month
      average: Average Delay
    row: 83
    col: 0
    width: 24
    height: 12
  - name: Accidents by Engine Type
    title: Accidents by Engine Type
    model: bernard_thesis
    explore: airports
    type: looker_donut_multiples
    fields:
    - accidents.engine_type
    - accidents.investigation_type
    - accidents.count
    pivots:
    - accidents.engine_type
    filters:
      accidents.broad_phase_of_flight: "-NULL"
      accidents.engine_type: "-NULL"
    sorts:
    - accidents.count desc 0
    - accidents.engine_type
    limit: 500
    column_limit: 50
    show_value_labels: false
    font_size: 12
    stacking: ''
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: true
    limit_displayed_rows: false
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    show_null_points: true
    point_style: circle
    series_types: {}
    row: 36
    col: 8
    width: 8
    height: 6
  - name: Accident Broad Phase of Flight
    title: Accident Broad Phase of Flight
    model: bernard_thesis
    explore: airports
    type: looker_donut_multiples
    fields:
    - accidents.broad_phase_of_flight
    - accidents.count
    - accidents.investigation_type
    pivots:
    - accidents.broad_phase_of_flight
    filters:
      accidents.broad_phase_of_flight: "-NULL"
    sorts:
    - accidents.count desc 0
    - accidents.broad_phase_of_flight
    limit: 500
    column_limit: 50
    show_value_labels: false
    font_size: 12
    stacking: ''
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: true
    limit_displayed_rows: false
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    row: 36
    col: 0
    width: 8
    height: 6
  - name: Accidents by Manufacturer
    title: Accidents by Manufacturer
    model: bernard_thesis
    explore: accidents
    type: looker_column
    fields:
    - aircraft_models.manufacturer
    - accidents.count
    - flights_by_day.count
    filters:
      aircraft_models.model: "-NULL"
      flights_by_day.count: ">0"
    sorts:
    - accidents.count desc
    limit: 500
    dynamic_fields:
    - table_calculation: of_accident_per_flights
      label: "% of accident per # flights"
      expression: "${accidents.count}/${flights_by_day.count}"
      value_format:
      value_format_name: percent_2
      _kind_hint: measure
      _type_hint: number
    query_timezone: America/Los_Angeles
    stacking: ''
    show_value_labels: true
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: true
    limit_displayed_rows: false
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    value_labels: legend
    label_type: labPer
    show_null_points: true
    point_style: circle
    font_size: '12'
    series_types:
      of_accident_per_flights: line
    hidden_fields:
    - flights_by_day.count
    hidden_points_if_no:
    - calculation_2
    y_axes:
    - label: ''
      orientation: left
      series:
      - id: accidents.count
        name: Accidents Count
        axisId: accidents.count
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      tickDensityCustom: 5
      type: linear
    - label:
      orientation: right
      series:
      - id: of_accident_per_flights
        name: "% of accident per # flights"
        axisId: of_accident_per_flights
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      tickDensityCustom: 5
      type: linear
    label_color:
    - Blue
    hidden_series:
    - of_accident_per_flights
    row: 29
    col: 16
    width: 8
    height: 7
  - name: Total fatalities with Drill
    title: Total fatalities with Drill
    model: bernard_thesis
    explore: accidents
    type: single_value
    fields:
    - accidents.total_fatalities
    limit: 500
    column_limit: 50
    custom_color_enabled: false
    custom_color: forestgreen
    show_single_value_title: true
    show_comparison: false
    comparison_type: progress_percentage
    comparison_reverse_colors: false
    show_comparison_label: false
    show_view_names: true
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    limit_displayed_rows: false
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    single_value_title: Total Fataities
    row: 3
    col: 8
    width: 8
    height: 6
  - name: Total Serious Injures with Drill
    title: Total Serious Injures with Drill
    model: bernard_thesis
    explore: accidents
    type: single_value
    fields:
    - accidents.total_serious_injuries
    limit: 500
    column_limit: 50
    custom_color_enabled: false
    custom_color: forestgreen
    show_single_value_title: true
    show_comparison: false
    comparison_type: progress_percentage
    comparison_reverse_colors: false
    show_comparison_label: false
    show_view_names: true
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    limit_displayed_rows: false
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    single_value_title: Total Serious Injuries
    row: 3
    col: 16
    width: 8
    height: 6
  - name: Total Uninjured with drill
    title: Total Uninjured with drill
    model: bernard_thesis
    explore: accidents
    type: single_value
    fields:
    - accidents.total_uninjured
    limit: 500
    column_limit: 50
    custom_color_enabled: false
    custom_color: forestgreen
    show_single_value_title: true
    show_comparison: false
    comparison_type: progress_percentage
    comparison_reverse_colors: false
    show_comparison_label: false
    show_view_names: true
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    limit_displayed_rows: false
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    single_value_title: Total Uninjured
    row: 15
    col: 16
    width: 8
    height: 6
  - name: Total Accidents
    title: Total Accidents
    model: bernard_thesis
    explore: accidents
    type: single_value
    fields:
    - accidents.count
    limit: 500
    column_limit: 50
    custom_color_enabled: false
    custom_color: forestgreen
    show_single_value_title: true
    show_comparison: false
    comparison_type: progress_percentage
    comparison_reverse_colors: false
    show_comparison_label: false
    show_view_names: true
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    limit_displayed_rows: false
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    single_value_title: Total Accidents
    listen:
      date: accidents.event_date
      Country: accidents.country
      Aircraft Type: accidents.aircraft_category
      Airport: accidents.airport_name
      Build: accidents.amateur_built
      Broad Phase of flight: accidents.broad_phase_of_flight
      Number of Minor Injuries: accidents.number_of_minor_injuries
      This filter needs a really lonh name to test i ;hkhifljloal;fga: accidents.number_of_serious_injuries
    row: 3
    col: 0
    width: 8
    height: 6
  - name: Total Minor Injures with Drill
    title: Total Minor Injures with Drill
    model: bernard_thesis
    explore: accidents
    type: single_value
    fields:
    - accidents.total_minor_injuries
    limit: 500
    column_limit: 50
    custom_color_enabled: false
    custom_color: forestgreen
    show_single_value_title: true
    show_comparison: false
    comparison_type: progress_percentage
    comparison_reverse_colors: false
    show_comparison_label: false
    show_view_names: true
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    limit_displayed_rows: false
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    single_value_title: Total minor Injuries
    row: 9
    col: 16
    width: 8
    height: 6
  - name: Americas Most Dangerous Airport
    title: Americas Most Dangerous Airport
    model: bernard_thesis
    explore: airports
    type: suburst_viz
    fields:
    - airports.state
    - airports.full_name
    - accidents.count
    sorts:
    - accidents.count desc
    limit: 15
    column_limit: 50
    row_total: right
    color_range:
    - "#dd3333"
    - "#80ce5d"
    - "#f78131"
    - "#369dc1"
    - "#c572d3"
    - "#36c1b3"
    - "#b57052"
    - "#ed69af"
    show_value_labels: false
    font_size: 12
    value_labels: legend
    label_type: labPer
    stacking: ''
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: true
    limit_displayed_rows: false
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    show_null_points: true
    point_style: circle
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_types: {}
    row: 29
    col: 0
    width: 8
    height: 7
  - name: Airport Information
    type: text
    title_text: Airport Information
    subtitle_text: Why
    body_text: "1.\t[ORLANDO INTL](https://www.faa.gov/about/office_org/field_offices/fsdo/orl/fsdo_aircraft/acc_inc_data/)\n\
      2.\t[CHICAGO O'HARE INTL](https://www.faa.gov/about/office_org/field_offices/fsdo/ord/fsdo_aircraft/acc_inc_data/)\n\
      3.\t[LOS ANGELES INTL](https://www.faa.gov/about/office_org/field_offices/fsdo/lax/fsdo_aircraft/acc_inc_data/)\n\
      4.\tDALLAS/FORT WORTH INTERNATIONAL\n5.\tDETROIT METROPOLITAN WAYNE COUNTY\n\
      6.\tBALTIMORE-WASHINGTON INTL\n7.\tNEWARK INTL\n8.\tPHILADELPHIA INTL\n9\tGENERAL\
      \ EDWARD LAWRENCE LOGAN INTL\n10.\tNEW ORLEANS INTL/MOISANT FLD/\n11.\tTAMPA\
      \ INTL\n12.\tTHE WILLIAM B HARTSFIELD ATLANTA INTL\n13.\tSAN FRANCISCO INTERNATIONAL\n\
      14.\tFORT LAUDERDALE/HOLLYWOOD INTL"
    row: 29
    col: 8
    width: 8
    height: 7
  - name: Accident Overview
    type: text
    title_text: Accident Overview
    subtitle_text: A look into American Air Accidents between 2000 and 2011
    row: 0
    col: 0
    width: 24
    height: 3
  - name: Is this data reliable?
    type: text
    title_text: Is this data reliable?
    subtitle_text: In the search for 9-11 and other notable crashes, I found the data
      to have some huge holes.....
    body_text: |-
      1. American Airlines Flight 11 and United Airlines Flight 175 - No Data
      2. NOV. 12, 2001: American Airlines Flight 587, 265 dead - No Data
      3. JUNE 1, 2009: [Air France Flight 447](https://en.wikipedia.org/wiki/Air_France_Flight_447), 228 dead - [Data!](https://dcl.dev.looker.com/explore/bernard_thesis/accidents?qid=BLKwJGnt9vFNolqAx3kU7f&toggle=fil)
    row: 42
    col: 0
    width: 24
    height: 4
  - name: The search for 9-11
    title: The search for 9-11
    model: bernard_thesis
    explore: accidents
    type: table
    fields:
    - accidents.total_fatalities
    - accidents.air_carrier
    - accidents.count
    - accidents.event_date
    - accidents.event_year
    - accidents.country
    - accidents.location
    filters:
      accidents.country: United States
      accidents.event_year: '2011'
      accidents.total_fatalities: ">0"
    sorts:
    - accidents.event_date desc
    limit: 500
    query_timezone: America/Los_Angeles
    row: 46
    col: 0
    width: 24
    height: 5
  - name: Delays
    type: text
    title_text: Delays
    body_text: |-
      1. What is the worst time to fly?
      2. What is the best/worst Airport to fly from?
      3. What airline has the best flight/delay ratio?
    row: 51
    col: 0
    width: 24
    height: 3
  - name: Overall  Accident Trend
    title: Overall  Accident Trend
    model: bernard_thesis
    explore: accidents
    type: looker_column
    fields:
    - accidents.count
    - accidents.event_year
    fill_fields:
    - accidents.event_year
    sorts:
    - accidents.event_year desc
    limit: 500
    query_timezone: America/Los_Angeles
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: true
    limit_displayed_rows: false
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    trend_lines:
    - color: "#000000"
      label_position: right
      period: 7
      regression_type: average
      series_index: 1
      show_label: true
    row: 21
    col: 0
    width: 16
    height: 8
  - name: "% of harmed flyers"
    title: "% of harmed flyers"
    model: bernard_thesis
    explore: accidents
    type: single_value
    fields:
    - accidents.total_fatalities
    - accidents.total_minor_injuries
    - accidents.total_serious_injuries
    - accidents.total_uninjured
    limit: 500
    column_limit: 50
    dynamic_fields:
    - table_calculation: fatalaties_and_injuries
      label: Fatalaties and injuries
      expression: "${accidents.total_fatalities} + ${accidents.total_minor_injuries}\
        \ +${accidents.total_serious_injuries}"
      value_format:
      value_format_name:
      _kind_hint: measure
      _type_hint: number
    - table_calculation: of_flyers_injuredfatal
      label: "% of flyers injured/fatal"
      expression: "${fatalaties_and_injuries}/${accidents.total_uninjured}"
      value_format:
      value_format_name: percent_0
      _kind_hint: measure
      _type_hint: number
    custom_color_enabled: false
    custom_color: forestgreen
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: true
    limit_displayed_rows: false
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    hidden_fields:
    - accidents.total_fatalities
    - accidents.total_minor_injuries
    - accidents.total_serious_injuries
    - accidents.total_uninjured
    - fatalaties_and_injuries
    series_types: {}
    single_value_title: of Flyers involved in airline incidents/accidents are harmed
    row: 21
    col: 16
    width: 8
    height: 8
  - name: Worst time of day to fly?
    title: Worst time of day to fly?
    model: bernard_thesis
    explore: airports
    type: looker_line
    fields:
    - flights.dep_hour_of_day
    - flights.dep_day_of_week
    - flights_by_day.average_delay
    pivots:
    - flights.dep_day_of_week
    fill_fields:
    - flights.dep_day_of_week
    filters:
      flights.dep_hour_of_day: NOT NULL
    sorts:
    - flights_by_day.average_delay desc 0
    - flights.dep_day_of_week
    limit: 500
    column_limit: 50
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: true
    limit_displayed_rows: false
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    show_null_points: true
    point_style: none
    interpolation: monotone
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    hidden_fields: []
    row: 54
    col: 0
    width: 24
    height: 7
  - name: Sign-ins is under construction
    type: text
    title_text: Sign-ins is under construction
    subtitle_text: ''
    body_text: |-
      <center>The good news is, we can pull this for you! Just reach out to support@wodify.com</center>

      <center><img src="https://wodify-website-files.s3.amazonaws.com/mediaroom/1_wodify/Wodify_Logo%402x.png" class="center" width="50%" height = "50%" /></center>

      <centre><img  src="https://storage.googleapis.com/matjaz-sandbox/screenshots/hub_dashboard_7day_4periods_sketch.PNG" class="center" width="100%" height = "50%"/></centre>
    row: 104
    col: 0
    width: 8
    height: 8
  filters:
  - name: date
    title: date
    type: date_filter
    default_value: 14 months
    allow_multiple_values: true
    required: false
  - name: Country
    title: Country
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    model: bernard_thesis
    explore: accidents
    listens_to_filters: []
    field: accidents.country
  - name: Aircraft Type
    title: Aircraft Type
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    model: bernard_thesis
    explore: accidents
    listens_to_filters: []
    field: accidents.aircraft_category
  - name: Airline
    title: Airline
    type: field_filter
    default_value: American Airlines
    allow_multiple_values: true
    required: false
    model: bernard_thesis
    explore: accidents
    listens_to_filters: []
    field: accidents.airline
  - name: Count
    title: Count
    type: number_filter
    default_value: ">0"
    allow_multiple_values: true
    required: false
  - name: Airport
    title: Airport
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    model: bernard_thesis
    explore: airports
    listens_to_filters: []
    field: accidents.airport_name
  - name: Build
    title: Build
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    model: bernard_thesis
    explore: accidents
    listens_to_filters: []
    field: accidents.amateur_built
  - name: Broad Phase of flight
    title: Broad Phase of flight
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    model: bernard_thesis
    explore: accidents
    listens_to_filters: []
    field: accidents.broad_phase_of_flight
  - name: Number of Minor Injuries
    title: Number of Minor Injuries
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    model: bernard_thesis
    explore: accidents
    listens_to_filters: []
    field: accidents.number_of_minor_injuries
  - name: This filter needs a really lonh name to test i ;hkhifljloal;fga
    title: This filter needs a really lonh name to test i ;hkhifljloal;fga
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    model: bernard_thesis
    explore: accidents
    listens_to_filters: []
    field: accidents.number_of_serious_injuries
