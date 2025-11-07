df_obs <- data.frame(
  size = c(0, 2, 3, 0), # four surveys
  survey_duration = c(20, 20, 18, 20),
  survey_weight = c(1, 1, 1, 1)
)

enc_rate <- encounter_rate(df_obs)

# Test basic input checks-------------
## encounter_rate----------
expect_error(
  obs_flux(
    encounter_rate = NA,
    eff_detection_width = 100,
    mean_flight_height = 100
  ),
  "Numeric input expected"
)

expect_error(
  obs_flux(
    encounter_rate = -0.1,
    eff_detection_width = 100,
    mean_flight_height = 100
  ),
  "variable out of bounds"
)

## eff_detection_width-----------
expect_error(
  obs_flux(
    encounter_rate = enc_rate,
    eff_detection_width = NA,
    mean_flight_height = 100
  ),
  "Effective detection width must be numeric and greater than 0"
)

expect_error(
  obs_flux(
    encounter_rate = enc_rate,
    eff_detection_width = '100',
    mean_flight_height = 100
  ),
  "Effective detection width must be numeric and greater than 0"
)

expect_error(
  obs_flux(
    encounter_rate = enc_rate,
    eff_detection_width = -100,
    mean_flight_height = 100
  ),
  "Effective detection width must be numeric and greater than 0"
)

expect_error(
  obs_flux(
    encounter_rate = enc_rate,
    eff_detection_width = 0,
    mean_flight_height = 100
  ),
  "Effective detection width must be numeric and greater than 0"
)

## mean_flight_height-----------
expect_error(
  obs_flux(
    encounter_rate = enc_rate,
    eff_detection_width = 100,
    mean_flight_height = NA
  ),
  "Mean flight height must be numeric and greater than 0"
)

expect_error(
  obs_flux(
    encounter_rate = enc_rate,
    eff_detection_width = 100,
    mean_flight_height = '100'
  ),
  "Mean flight height must be numeric and greater than 0"
)

expect_error(
  obs_flux(
    encounter_rate = enc_rate,
    eff_detection_width = 100,
    mean_flight_height = -100
  ),
  "Mean flight height must be numeric and greater than 0"
)

expect_error(
  obs_flux(
    encounter_rate = enc_rate,
    eff_detection_width = 100,
    mean_flight_height = 0
  ),
  "Mean flight height must be numeric and greater than 0"
)

# Correct inputs give correct outputs----------
expect_equal(
  obs_flux(
    encounter_rate = enc_rate,
    eff_detection_width = 800,
    mean_flight_height = 350
  ),
  enc_rate / (2 * 800 * 350)
)