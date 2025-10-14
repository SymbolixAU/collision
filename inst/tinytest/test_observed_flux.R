obs_size <- c(1, 1, 2, 1, 3)
survey_duration <- c(60, 60, 20, 10, 60)
eff_detection_width <- 100
survey_units = "min"
width_units = "m"
survey_weight = NULL
wilson_correction = TRUE

# Test basic warnings-------------
# obs_size
expect_warning(
  flight_flux_point(
    obs_size = c(1, 1, 2, NA, 3),
    survey_duration,
    eff_detection_width,
    survey_units,
    width_units,
    survey_weight,
    wilson_correction
  ),
  "NA observations detected - NA observations will be ignored"
)

# NULL obs_size and duration - this fails, we need to add a handler for this
expect_warning(
  flight_flux_point(
    obs_size = NULL,
    survey_duration = NULL,
    eff_detection_width,
    survey_units,
    width_units,
    survey_weight,
    wilson_correction
  ),
  "obs_size and survey_duration cannot be NULL"
)

# survey_duration
expect_warning(
  flight_flux_point(
    obs_size,
    survey_duration = c(60, NA, 20, 10, 60),
    eff_detection_width,
    survey_units,
    width_units,
    survey_weight,
    wilson_correction
  ),
  "NA survey durations detected - NA surveys will be ignored"
)

expect_error(
  flight_flux_point(
    obs_size,
    survey_duration = c(60, 10, 20, 10),
    eff_detection_width,
    survey_units,
    width_units,
    survey_weight,
    wilson_correction
  ),
  "obs_size, survey_mins must be equal"
)

# eff_detection_width
expect_error(
  flight_flux_point(
    obs_size,
    survey_duration,
    eff_detection_width = c(1, 2),
    survey_units,
    width_units,
    survey_weight,
    wilson_correction
  ),
  'effective detection width must be length 1'
)

expect_error(
  flight_flux_point(
    obs_size,
    survey_duration,
    eff_detection_width = NA,
    survey_units,
    width_units,
    survey_weight,
    wilson_correction
  ),
  'effective detection width must be numeric'
)

# Effective detection width is NULL - this fails, needs to be handled
expect_error(
  flight_flux_point(
    obs_size,
    survey_duration,
    eff_detection_width = NULL,
    survey_units,
    width_units,
    survey_weight,
    wilson_correction
  ),
  'effective detection width cannot be NULL'
)

# survey_units
expect_warning(
  flight_flux_point(
    obs_size,
    survey_duration,
    eff_detection_width,
    survey_units = "hours",
    width_units,
    survey_weight,
    wilson_correction
  ),
  'survey duration will be converted to mins and 
            output will be flights / metre / minute'
)
# Survey units = NA / NULL is handled appropriately. This fails atm
expect_error(
  flight_flux_point(
    obs_size,
    survey_duration,
    eff_detection_width,
    survey_units = NA,
    width_units,
    survey_weight,
    wilson_correction
  ),
  'survey_units cannot be NA/NULL'
)

# width units
expect_warning(
  flight_flux_point(
    obs_size,
    survey_duration,
    eff_detection_width,
    survey_units,
    width_units = "km",
    survey_weight,
    wilson_correction
  ),
  'width_units will be converted to metres and 
            output will be flights / metre / minute'
)

# Width units = NA / NULL is handled appropriately. This fails atm
expect_error(
  flight_flux_point(
    obs_size,
    survey_duration,
    eff_detection_width,
    survey_units,
    width_units = NA,
    survey_weight,
    wilson_correction
  ),
  'width_units cannot be NA/NULL'
)

# survey_weights
expect_error(
  flight_flux_point(
    obs_size,
    survey_duration,
    eff_detection_width,
    survey_units,
    width_units,
    survey_weight = NA,
    wilson_correction
  ),
  "survey_weight must be NULL or same length as survey_mins"
)

# survey weights has a NA in the vector - this fails atm
expect_error(
  flight_flux_point(
    obs_size,
    survey_duration,
    eff_detection_width,
    survey_units,
    width_units,
    survey_weight = c(1, 1, 2, 3, NA),
    wilson_correction
  ),
  "survey_weight vector cannot have NA"
)

# Obs size is empty and wilson correction is FALSE
# This also throws a error which needs to be checked
expect_warning(
  flight_flux_point(
    obs_size = c(),
    survey_duration = c(),
    eff_detection_width,
    survey_units,
    width_units,
    survey_weight,
    wilson_correction = FALSE
  ),
  "Zero or NA  events exist but Wilson Correction == FALSE. Flight flux will be uncorrected. Is this what you want?"
)

# Apply wilson correction when TRUE
# This also throws a error which needs to be checked
expect_message(
  flight_flux_point(
    obs_size = c(),
    survey_duration = c(),
    eff_detection_width,
    survey_units,
    width_units,
    survey_weight,
    wilson_correction = TRUE
  ),
  "zero observations recorded - applying Wilson Correction"
)

# Correct inputs give correct outputs
expect_equal(
  flight_flux_point(
    obs_size,
    survey_duration,
    eff_detection_width,
    survey_units,
    width_units,
    survey_weight,
    wilson_correction = FALSE
  ),
  sum(obs_size * 1) *
    length(obs_size) /
    (eff_detection_width * sum(survey_duration))
)

# Weighted vs un-weighted
expect_true(flight_flux_point(
  obs_size,
  survey_duration,
  eff_detection_width,
  survey_units,
  width_units,
  survey_weight,
  wilson_correction = FALSE
) <
flight_flux_point(
  obs_size,
  survey_duration,
  eff_detection_width,
  survey_units,
  width_units,
  survey_weight = c(1, 2, 2, 2, 1),
  wilson_correction = FALSE
))
