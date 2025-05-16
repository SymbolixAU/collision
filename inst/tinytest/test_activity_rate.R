tol <- 0.0001


data(ds_raptor) # example raptor ds model
data(df_obs_survey)
data(ds_example)

## Test basic warnings ---------------------------------------------------------

obs <- c(0, 1, 1, 3, 4, 5)
survey <- c(60, 60, 60, NA)
expect_warning(
    activity_rate_distcorr(ds_example,
        obs_size = obs,
        survey_mins = survey
    ),
    "NA survey durations detected - NA surveys will be ignored"
)

obs <- c(0, 1, 1, 3, 4, NA)
survey <- c(60, 60, 60, 30)
expect_warning(
    activity_rate_distcorr(ds_example,
        obs_size = obs,
        survey_mins = survey
    ),
    "NA observations detected - NA observations will be ignored"
)

obs <- c(1, 2, 3, 4, 5)
expect_error(
    activity_rate_distcorr(
        ds_model = ds_raptor,
        obs_size = obs,
        survey_mins = survey,
        eda = 1000
    ),
    "Please specify one and only one of eda or ds_model"
)


expect_error(
    activity_rate_distcorr(
        obs_size = obs,
        survey_mins = survey
    ),
    "Please specify one of eda or ds_model"
)

## Wilson correction works -----------------------------------------------------

obs <- integer()
survey <- c(60, 60, 60, 45, 30)

expect_equal(
    activity_rate_distcorr(ds_raptor,
        obs_size = obs,
        survey_mins = survey,
        wilson_correction = TRUE
    )$mean,
    420.9407,
    tolerance = tol
)

#' # zero observations without wilson correction returns NaN
#' and warning

expect_warning(
    res <- activity_rate_distcorr(ds_raptor,
        obs_size = obs,
        survey_mins = survey,
        wilson_correction = FALSE
    ),
    "Zero or NA  events exist but Wilson Correction == FALSE. Activity rate will be uncorrected. Is this what you want?"
)

expect_equal(res$mean, NaN)

## test EDA can be input manually ----------------------------------------------

obs <- c(0, 1, 1, 3, 4)
survey <- c(60, 60, 60, 40, 30)
data(ds_raptor)

eda_from_ds <- eda_from_distmodel(ds_raptor)
my_eda <- 1e6 # less than eda_from_ds

ar_1 <- activity_rate_distcorr(
    ds_model = ds_raptor,
    obs_size = obs,
    survey_mins = survey
)
ar_2 <- activity_rate_distcorr(
    ds_model = NULL,
    obs_size = obs,
    survey_mins = survey,
    eda = my_eda
)
## we expect ar_2, calcualted with a smaller EDA, to be larger than ar_1
##
expect_equal(
    current = ar_2$mean / ar_1$mean,
    target = eda_from_ds / my_eda
)

expect_error(
    activity_rate_distcorr(
        ds_model = NULL,
        obs_size = obs,
        survey_mins = survey,
        eda = "1e6"
    ),
    pattern = "numeric"
)
expect_error(
    activity_rate_distcorr(
        ds_model = NULL,
        obs_size = obs,
        survey_mins = survey,
        eda = c(1e6, 2e6)
    ),
    pattern = "length"
)
