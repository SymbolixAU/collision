tol <- 0.0001


data(ds_raptor) # example raptor ds model
data(df_obs_survey)
data(ds_example)

# flight_flux

## Test basic warnings ---------------------------------------------------------

obs <- c(0, 1, 1, 3, 4, 5)
survey <- c(60, 60, 60, NA)
expect_warning(
    flight_flux(ds_example,
        obs_size = obs,
        survey_mins = survey,
        prop_at_height = 0.7,
        prop_below_height = 0.3,
        rotor_diameter = 230
    ),
    "NA survey durations detected - NA surveys will be ignored"
)

obs <- c(0, 1, 1, 3, 4, NA)
survey <- c(60, 60, 60, 30)
expect_warning(
    flight_flux(ds_example,
        obs_size = obs,
        survey_mins = survey,
        prop_at_height = 0.7,
        prop_below_height = 0.3,
        rotor_diameter = 230
    ),
    "NA observations detected - NA observations will be ignored"
)

obs <- c(1, 2, 3, 4, 5)
expect_error(
    flight_flux(
        ds_model = ds_raptor,
        obs_size = obs,
        survey_mins = survey,
        edr = 1000,
        prop_at_height = 0.7,
        prop_below_height = 0.3,
        rotor_diameter = 230
    ),
    "Please specify one and only one of edr or ds_model"
)


expect_error(
    flight_flux(
        obs_size = obs,
        survey_mins = survey,
        prop_at_height = 0.7,
        prop_below_height = 0.3,
        rotor_diameter = 230
    ),
    "Please specify one of edr or ds_model"
)

expect_error(
    flight_flux(
        obs_size = obs,
        survey_mins = survey,
        prop_at_height = 0.7,
        prop_below_height = 0.3,
        rotor_diameter = 230,
        edr = "23"
    ),
    "edr must be numeric if not NULL"
)

expect_error(
    flight_flux(
        obs_size = obs,
        survey_mins = survey,
        prop_at_height = 0.7,
        prop_below_height = 0.3,
        rotor_diameter = 230,
        edr = c(1, 2)
    ),
    "edr must be length 1"
)

expect_error(
    flight_flux(
        obs_size = obs,
        survey_mins = survey,
        prop_at_height = "0.7",
        prop_below_height = 0.3,
        rotor_diameter = 230,
        edr = 1
    ),
    "prop_at_height must be numeric"
)

expect_error(
    flight_flux(
        obs_size = obs,
        survey_mins = survey,
        prop_at_height = c(0.7, 0.3),
        prop_below_height = 0.3,
        rotor_diameter = 230,
        edr = 1
    ),
    "prop_at_height must be length 1"
)

expect_error(
    flight_flux(
        obs_size = obs,
        survey_mins = survey,
        prop_at_height = -0.1,
        prop_below_height = 0.3,
        rotor_diameter = 230,
        edr = 1
    ),
    "prop_at_height must be in range \\[0, 1]"
)

expect_error(
    flight_flux(
        obs_size = obs,
        survey_mins = survey,
        prop_at_height = 0.7,
        prop_below_height = "0.3",
        rotor_diameter = 230,
        edr = 1
    ),
    "prop_below_height must be numeric"
)

expect_error(
    flight_flux(
        obs_size = obs,
        survey_mins = survey,
        prop_at_height = 0.7,
        prop_below_height = c(0.7, 0.3),
        rotor_diameter = 230,
        edr = 1
    ),
    "prop_below_height must be length 1"
)

expect_error(
    flight_flux(
        obs_size = obs,
        survey_mins = survey,
        prop_at_height = 0.1,
        prop_below_height = -0.3,
        rotor_diameter = 230,
        edr = 1
    ),
    "prop_below_height must be in range \\[0, 1]"
)

expect_error(
    flight_flux(
        obs_size = obs,
        survey_mins = survey,
        prop_at_height = 0.7,
        prop_below_height = 0.4,
        rotor_diameter = 230,
        edr = 1
    ),
    "prop_at_height \\+ prop_below_height must not be greater than 1"
)


expect_error(
    flight_flux(
        obs_size = obs,
        survey_mins = survey,
        prop_at_height = 0.7,
        prop_below_height = 0.3,
        rotor_diameter = "230",
        edr = 1
    ),
    "rotor_diameter must be numeric"
)

expect_error(
    flight_flux(
        obs_size = obs,
        survey_mins = survey,
        prop_at_height = 0.7,
        prop_below_height = 0.3,
        rotor_diameter = c(230, 150),
        edr = 1
    ),
    "rotor_diameter must be length 1"
)

expect_error(
    flight_flux(
        obs_size = obs,
        survey_mins = survey,
        prop_at_height = 0.7,
        prop_below_height = 0.3,
        rotor_diameter = -230,
        edr = 1
    ),
    "rotor_diameter must be greater than 0"
)

## Wilson correction works -----------------------------------------------------

obs <- integer()
survey <- c(60, 60, 60, 45, 30)

expect_equal(
    flight_flux(
        ds_model = ds_raptor,
        obs_size = obs,
        survey_mins = survey,
        wilson_correction = TRUE,
        prop_at_height = 0.7,
        prop_below_height = 0.3,
        rotor_diameter = 230
    )$mean,
    0.000380641,
    tolerance = tol
)

# zero observations without wilson correction returns NaN and warning

expect_warning(
    res <- flight_flux(
        ds_model = ds_raptor,
        obs_size = obs,
        survey_mins = survey,
        wilson_correction = FALSE,
        prop_at_height = 0.7,
        prop_below_height = 0.3,
        rotor_diameter = 230
    ),
    "Zero or NA  events exist but Wilson Correction == FALSE. Flight flux will be uncorrected. Is this what you want?"
)

expect_equal(res$mean, NaN)

## test EDA can be input manually ----------------------------------------------

obs <- c(0, 1, 1, 3, 4)
survey <- c(60, 60, 60, 40, 30)
data(ds_raptor)

edr_from_ds <- edr_from_distmodel(ds_raptor)
my_edr <- 1000 # less than eda_from_ds

ar_1 <- flight_flux(
    ds_model = ds_raptor,
    obs_size = obs,
    survey_mins = survey,
    prop_at_height = 0.7,
    prop_below_height = 0.3,
    rotor_diameter = 230
)
ar_2 <- flight_flux(
    ds_model = NULL,
    obs_size = obs,
    survey_mins = survey,
    edr = my_edr,
    prop_at_height = 0.7,
    prop_below_height = 0.3,
    rotor_diameter = 230
)
## we expect ar_2, calcualted with a smaller EDA, to be larger than ar_1
##
expect_equal(
    current = ar_2$mean / ar_1$mean,
    target = edr_from_ds / my_edr
)


# flux_per_year ----------------------------------------------------------------

expect_equal(
  flux_per_year(flux_per_min = 0.1, prop_day = 1, prop_year = 1), 
  52596, 
  tolerance = tol
)

## Test input handling

expect_error(
  flux_per_year(flux_per_min = list(), prop_day = 1, prop_year = 1),
  "flux_per_min must be numeric"
)

expect_error(
  flux_per_year(flux_per_min = -1, prop_day = 1, prop_year = 1),
  "variable out of bounds"
)


expect_error(
  flux_per_year(flux_per_min = 0.1, prop_day = "1", prop_year = 1),
  "Numeric input expected"
)

expect_error(
  flux_per_year(flux_per_min = 0.1, prop_day = -1, prop_year = 1),
  "variable out of bounds"
  )

expect_error(
  flux_per_year(flux_per_min = 0.1, prop_day = 1, prop_year = ""),
  "Numeric input expected"
)

expect_error(
  flux_per_year(flux_per_min = 0.1, prop_day = 1, prop_year = 1.2),
  "variable out of bounds"
)

