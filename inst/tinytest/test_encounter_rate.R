# Inputs-----
obs_size <- c(0, 2, 3, 0)
duration <- c(20, 20, 18, 20)
weight <- c(1, 2, 3, 1)
# Check if all columns are present in the dataframe------------
## Obs size----
expect_error(
  encounter_rate(data.frame(
    survey_duration = duration,
    survey_weight = weight
  )),
  "size and/or survey_duration columns do not exist in the data.frame"
)

## Survey Duration-----
expect_error(
  encounter_rate(data.frame(size = obs_size, survey_weight = weight)),
  "size and/or survey_duration columns do not exist in the data.frame"
)

# Invalid Inputs-------
## Obs size-----
expect_warning(
  encounter_rate(data.frame(
    size = c(0, NA, 3, 0),
    survey_duration = duration,
    survey_weight = weight
  )),
  "NA observations detected - NA observation size will be assumed to be 0"
)

## Survey Duration------
expect_error(
  encounter_rate(data.frame(
    size = obs_size,
    survey_duration = c(20, NA, 18, 20),
    survey_weight = weight
  )),
  "NA survey durations detected"
)

## Survey weights--------
expect_error(
  encounter_rate(data.frame(
    size = obs_size,
    survey_duration = duration,
    survey_weight = c(1, NA, 1, 1)
  )),
  "NA survey weights detected - survey weights must be NULL or all specified."
)

# Basic Valid Input Testing------
expect_equal(
  encounter_rate(data.frame(size = obs_size, survey_duration = duration)),
  sum(obs_size) / sum(duration)
)

# With weighting-------
expect_equal(
  encounter_rate(data.frame(
    size = obs_size,
    survey_duration = duration,
    survey_weight = weight
  )),
  sum(obs_size * weight) / sum(duration)
)

# All zero obs with Wilson correction---------
expect_equal(
  encounter_rate(data.frame(
    size = c(0, 0, 0, 0),
    survey_duration = duration,
    survey_weight = weight
  )),
  2 / (sum(duration) + 4 * mean(duration))
)

# All zero obs without Wilson correction---------
expect_equal(
  encounter_rate(
    data.frame(
      size = c(0, 0, 0, 0),
      survey_duration = duration,
      survey_weight = weight
    ),
    wilson_correction = FALSE
  ),
  0
)

expect_warning(
  encounter_rate(
    data.frame(
      size = c(0, 0, 0, 0),
      survey_duration = duration,
      survey_weight = weight
    ),
    wilson_correction = FALSE
  ),
  "Zero or NA events exist but Wilson Correction == FALSE. Flight flux will be uncorrected. Is this what you want?"
)

# Empty data frames-------
expect_error(encounter_rate(data.frame(
   size = numeric(0),
   survey_duration = numeric(0)
 )), "All surveys have a survey duration of 0")

# Few of the durations are 0-----------
expect_warning(encounter_rate(data.frame(
  size = obs_size,
  survey_duration = c(20, 20, 18, 0)
)), "some surveys have 0 duration")

