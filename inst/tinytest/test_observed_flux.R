df_obs <- data.frame(size = c(0, 2 , 3, 0), # four surveys
                      survey_duration = c(20, 20, 18, 20),
                      survey_weight = c(1,1,1,1))

enc_rate <- encounter_rate(df_obs)

# Test basic input checks-------------
## encounter_rate----------
expect_error(
  obs_flux(
    encounter_rate = NA,
    eff_detection_width = 800,
    eff_detection_height = 350,
    width_units = "m",
    height_units = "m"
  ),
  "Numeric input expected"
)

expect_error(
  obs_flux(
    encounter_rate = -0.1,
    eff_detection_width = 800,
    eff_detection_height = 350,
    width_units = "m",
    height_units = "m"
  ),
  "variable out of bounds"
)

## eff_detection_width-----------
expect_error(
  obs_flux(
    encounter_rate = enc_rate,
    eff_detection_width = '800',
    eff_detection_height = 350,
    width_units = "m",
    height_units = "m"
  ),
  "Numeric input expected"
)

expect_error(
  obs_flux(
    encounter_rate = enc_rate,
    eff_detection_width = -800,
    eff_detection_height = 350,
    width_units = "m",
    height_units = "m"
  ),
  "variable out of bounds"
)

## eff_detection_height-----------
expect_error(
  obs_flux(
    encounter_rate = enc_rate,
    eff_detection_width = 800,
    eff_detection_height = '350',
    width_units = "m",
    height_units = "m"
  ),
  "Numeric input expected"
)

expect_error(
  obs_flux(
    encounter_rate = enc_rate,
    eff_detection_width = 800,
    eff_detection_height = -350,
    width_units = "m",
    height_units = "m"
  ),
  "variable out of bounds"
)

## width_units-----------
expect_error(
  obs_flux(
    encounter_rate = enc_rate,
    eff_detection_width = 800,
    eff_detection_height = 350,
    width_units = "abc",
    height_units = "m"
  ),
  "‘abc’ is not recognized by udunits"
)

expect_warning(
  obs_flux(
    encounter_rate = enc_rate,
    eff_detection_width = 800,
    eff_detection_height = 350,
    width_units = "km",
    height_units = "m"
  ),
  "width_units will be converted to metres and"
)

expect_warning(
  obs_flux(
    encounter_rate = enc_rate,
    eff_detection_width = 800,
    eff_detection_height = 350,
    width_units = NULL,
    height_units = "m"
  ),
  "width_units is assumed to be meters"
)

## height_units--------------
expect_error(
  obs_flux(
    encounter_rate = enc_rate,
    eff_detection_width = 800,
    eff_detection_height = 350,
    width_units = "m",
    height_units = "abc"
  ),
  "‘abc’ is not recognized by udunits"
)

expect_warning(
  obs_flux(
    encounter_rate = enc_rate,
    eff_detection_width = 800,
    eff_detection_height = 350,
    width_units = "m",
    height_units = "km"
  ),
  "height_units will be converted to metres and"
)

expect_warning(
  obs_flux(
    encounter_rate = enc_rate,
    eff_detection_width = 800,
    eff_detection_height = 350,
    width_units = "m",
    height_units = NULL
  ),
  "height_units is assumed to be meters"
)

# Correct inputs give correct outputs----------
expect_equal(
  obs_flux(
    encounter_rate = enc_rate,
    eff_detection_width = 800,
    eff_detection_height = 350,
    width_units = "m",
    height_units = "m"
  ),
  enc_rate / (800 * 350)
)

# Units conversion works properly------------
