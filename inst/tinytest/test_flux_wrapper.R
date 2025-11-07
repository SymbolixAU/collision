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
  "variable out of bounds"
)
## Obs Size--------
## This fails atm
expect_error(
  turbine_flights_year(
    survey_type,
    obs_size = NULL,
    survey_duration = NULL,
    eff_detection_width,
    rotor_diameter,
    prop_below_turbine_max,
    prop_day,
    prop_year,
    survey_units = "min",
    width_units = "m",
    survey_weight = NULL,
    wilson_correction = TRUE
  ),
  "obs_size cannot be NA/NULL"
)

expect_error(
  turbine_flights_year(
    survey_type,
    obs_size = c(1, 2, NA),
    survey_duration,
    eff_detection_width,
    rotor_diameter,
    prop_below_turbine_max,
    prop_day,
    prop_year,
    survey_units = "min",
    width_units = "m",
    survey_weight = NULL,
    wilson_correction = TRUE
  ),
  "obs_size, survey_mins must be equal"
)

expect_warning(
  turbine_flights_year(
    survey_type,
    obs_size = c(1, 2, NA),
    survey_duration,
    eff_detection_width,
    rotor_diameter,
    prop_below_turbine_max,
    prop_day,
    prop_year,
    survey_units = "min",
    width_units = "m",
    survey_weight = NULL,
    wilson_correction = TRUE
  ),
  "NA observations detected - NA observations will be ignored"
)

## Survey Duration--------
## This fails atm
expect_error(
  turbine_flights_year(
    survey_type,
    obs_size = c(),
    survey_duration = NULL,
    eff_detection_width,
    rotor_diameter,
    prop_below_turbine_max,
    prop_day,
    prop_year,
    survey_units = "min",
    width_units = "m",
    survey_weight = NULL,
    wilson_correction = TRUE
  ),
  "survey_duration cannot be NA/NULL"
)

expect_error(
  turbine_flights_year(
    survey_type,
    obs_size,
    survey_duration = c(1, 2, NA),
    eff_detection_width,
    rotor_diameter,
    prop_below_turbine_max,
    prop_day,
    prop_year,
    survey_units = "min",
    width_units = "m",
    survey_weight = NULL,
    wilson_correction = TRUE
  ),
  "obs_size, survey_mins must be equal"
)

expect_warning(
  turbine_flights_year(
    survey_type,
    obs_size,
    survey_duration,
    eff_detection_width,
    rotor_diameter,
    prop_below_turbine_max,
    prop_day,
    prop_year,
    survey_units = "min",
    width_units = "m",
    survey_weight = NULL,
    wilson_correction = TRUE
  ),
  "NA survey durations detected - NA surveys will be ignored"
)

## eff_detection_width-------------
expect_error(
  turbine_flights_year(
    survey_type,
    obs_size,
    survey_duration,
    eff_detection_width = NA,
    rotor_diameter,
    prop_below_turbine_max,
    prop_day,
    prop_year,
    survey_units = "min",
    width_units = "m",
    survey_weight = NULL,
    wilson_correction = TRUE
  ),
  "effective detection width must be numeric"
)

expect_error(
  turbine_flights_year(
    survey_type,
    obs_size,
    survey_duration,
    eff_detection_width = -100,
    rotor_diameter,
    prop_below_turbine_max,
    prop_day,
    prop_year,
    survey_units = "min",
    width_units = "m",
    survey_weight = NULL,
    wilson_correction = TRUE
  ),
  "variable out of bounds"
)


# Rotor diameter------------------
expect_error(
  turbine_flights_year(
    survey_type,
    obs_size,
    survey_duration,
    eff_detection_width,
    rotor_diameter = "100",
    prop_below_turbine_max,
    prop_day,
    prop_year,
    survey_units = "min",
    width_units = "m",
    survey_weight = NULL,
    wilson_correction = TRUE
  ),
  "Numeric input expected"
)

expect_error(
  turbine_flights_year(
    survey_type,
    obs_size,
    survey_duration,
    eff_detection_width,
    rotor_diameter = -100,
    prop_below_turbine_max,
    prop_day,
    prop_year,
    survey_units = "min",
    width_units = "m",
    survey_weight = NULL,
    wilson_correction = TRUE
  ),
  "variable out of bounds"
)

## prop_below_turbine_max--------
expect_error(
  turbine_flights_year(
    survey_type,
    obs_size,
    survey_duration,
    eff_detection_width,
    rotor_diameter,
    prop_below_turbine_max = NA,
    prop_day,
    prop_year,
    survey_units = "min",
    width_units = "m",
    survey_weight = NULL,
    wilson_correction = TRUE
  ),
  "Numeric input expected"
)

expect_error(
  turbine_flights_year(
    survey_type,
    obs_size,
    survey_duration,
    eff_detection_width,
    rotor_diameter,
    prop_below_turbine_max = -10,
    prop_day,
    prop_year,
    survey_units = "min",
    width_units = "m",
    survey_weight = NULL,
    wilson_correction = TRUE
  ),
  "variable out of bounds"
)

## prop_day----------
expect_error(
  turbine_flights_year(
    survey_type,
    obs_size,
    survey_duration,
    eff_detection_width,
    rotor_diameter,
    prop_below_turbine_max,
    prop_day = 10,
    prop_year,
    survey_units = "min",
    width_units = "m",
    survey_weight = NULL,
    wilson_correction = TRUE
  ),
  "variable out of bounds"
)

# prop_year---------
expect_error(
  turbine_flights_year(
    survey_type,
    obs_size,
    survey_duration,
    eff_detection_width,
    rotor_diameter,
    prop_below_turbine_max,
    prop_day,
    prop_year = 10,
    survey_units = "min",
    width_units = "m",
    survey_weight = NULL,
    wilson_correction = TRUE
  ),
  "variable out of bounds"
)

# survey_units-----------
expect_warning(
  turbine_flights_year(
    survey_type,
    obs_size,
    survey_duration,
    eff_detection_width,
    rotor_diameter,
    prop_below_turbine_max,
    prop_day,
    prop_year,
    survey_units = "hours",
    width_units = "m",
    survey_weight = NULL,
    wilson_correction = TRUE
  ),
  "survey duration will be converted to mins and 
            output will be flights / metre / minute"
)

# Survey Units cannot be NA-----
# This fails atm
expect_warning(
  turbine_flights_year(
    survey_type,
    obs_size,
    survey_duration,
    eff_detection_width,
    rotor_diameter,
    prop_below_turbine_max,
    prop_day,
    prop_year,
    survey_units = NA,
    width_units = "m",
    survey_weight = NULL,
    wilson_correction = TRUE
  ),
  "survey duration cannot be NULL/NA"
)

## width_units---------
expect_warning(
  turbine_flights_year(
    survey_type,
    obs_size,
    survey_duration,
    eff_detection_width,
    rotor_diameter,
    prop_below_turbine_max,
    prop_day,
    prop_year,
    survey_units,
    width_units = "cm",
    survey_weight = NULL,
    wilson_correction = TRUE
  ),
  "width_units will be converted to metres and 
            output will be flights / metre / minute"
)

# This fails, we need to add a handler for this
expect_warning(
  turbine_flights_year(
    survey_type,
    obs_size,
    survey_duration,
    eff_detection_width,
    rotor_diameter,
    prop_below_turbine_max,
    prop_day,
    prop_year,
    survey_units,
    width_units = NULL,
    survey_weight = NULL,
    wilson_correction = TRUE
  ),
  "width units cannot be NULL/NA"
)

## Survey weight----------
expect_error(
  turbine_flights_year(
    survey_type,
    obs_size,
    survey_duration,
    eff_detection_width,
    rotor_diameter,
    prop_below_turbine_max,
    prop_day,
    prop_year,
    survey_units,
    width_units,
    survey_weight = 1,
    wilson_correction = TRUE
  ),
  "survey_weight must be NULL or same length as survey_mins"
)

## Wilson Correction----------
## This fails
expect_error(
  turbine_flights_year(
    survey_type,
    obs_size,
    survey_duration,
    eff_detection_width,
    rotor_diameter,
    prop_below_turbine_max,
    prop_day,
    prop_year,
    survey_units,
    width_units,
    survey_weight,
    wilson_correction = "YES"
  ),
  "Wilson correction should be a boolean value"
)
