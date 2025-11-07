survey_type <- "point"

encounter_rate <- encounter_rate(data.frame(
  size = c(0, 2, 3, 0),
  survey_duration = c(20, 20, 18, 20),
  survey_weight = c(1, 2, 3, 1)
))
time_units = "min"
eff_detection_width <- 100
mean_flight_height <- 100
rotor_diameter <- 300
hub_height <- 100
prop_day <- 0.8
prop_year <- 0.5

# Test parameter validation----------------------
## Survey Type------
expect_error(
  turbine_flights_year(
    survey_type = "",
    encounter_rate,
    time_units,
    eff_detection_width,
    mean_flight_height,
    rotor_diameter,
    hub_height,
    prop_day,
    prop_year
  ),
  "Only point transects are currently implemented.
         Line transects and digital areal surveys are in development."
)

expect_error(
  turbine_flights_year(
    survey_type = NULL,
    encounter_rate,
    time_units,
    eff_detection_width,
    mean_flight_height,
    rotor_diameter,
    hub_height,
    prop_day,
    prop_year
  ),
  "survey_type cannot be NA/NULL"
)

expect_error(
  turbine_flights_year(
    survey_type = NA,
    encounter_rate,
    time_units,
    eff_detection_width,
    mean_flight_height,
    rotor_diameter,
    hub_height,
    prop_day,
    prop_year
  ),
  "survey_type cannot be NA/NULL"
)

## Encounter rate---------------
expect_error(
  turbine_flights_year(
    survey_type,
    encounter_rate = "",
    time_units,
    eff_detection_width,
    mean_flight_height,
    rotor_diameter,
    hub_height,
    prop_day,
    prop_year
  ),
  "Numeric input expected"
)

expect_error(
  turbine_flights_year(
    survey_type,
    encounter_rate = NULL,
    time_units,
    eff_detection_width,
    mean_flight_height,
    rotor_diameter,
    hub_height,
    prop_day,
    prop_year
  ),
  "Numeric input expected"
)

expect_error(
  turbine_flights_year(
    survey_type,
    encounter_rate = NA,
    time_units,
    eff_detection_width,
    mean_flight_height,
    rotor_diameter,
    hub_height,
    prop_day,
    prop_year
  ),
  "Numeric input expected"
)

expect_error(
  turbine_flights_year(
    survey_type,
    encounter_rate = -100,
    time_units,
    eff_detection_width,
    mean_flight_height,
    rotor_diameter,
    hub_height,
    prop_day,
    prop_year
  ),
  "variable out of bounds"
)
## Time Units-------------
expect_error(
  turbine_flights_year(
    survey_type,
    encounter_rate,
    time_units = "mins",
    eff_detection_width,
    mean_flight_height,
    rotor_diameter,
    hub_height,
    prop_day,
    prop_year
  ),
  "In '1/mins', 'mins' is not recognized by udunits."
)

# Correct inputs give correct outputs------------
expect_equal(turbine_flights_year(
  survey_type,
  encounter_rate,
  time_units = "min",
  eff_detection_width,
  mean_flight_height,
  rotor_diameter,
  hub_height,
  prop_day,
  prop_year
), 131490)
