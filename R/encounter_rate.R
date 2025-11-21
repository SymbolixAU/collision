#' Calculate uncorrected observed flights / minute of survey from point transects
#'
#' This function converts observed flights (movements) and survey duration into the "encounter rate" per minute of survey. This value is uncorrected for the observer's effective detection radius.
#'
#'
#' @seealso [turbine_flights()] and [flights_per_year()] for methods to expand the
#' observer flux into flights through the turbine plane
#'
#' @references
#'   \insertAllCited{}
#'   
#' @param df_obs_summary data.frame; a data.frame with one row per survey containing at least columns `size` and 
#'    `survey_duration` where `size` is the total number of individuals observed in each survey and 
#'    `survey_duration` is the duration of each survey. It can also optionally include a column `survey_weight` if needed
#'    to account for stratification etc. The sum of the survey weights must equal the total number of surveys
#'    (to avoid artificially inflating or deflating the survey effort). When NULL (the default) will 
#'    weight surveys equally.
#' @param wilson_correction boolean;  Apply wilson correction \insertCite{Wilson1927}{collision} if there are
#'    no observations. Defaults to TRUE.
#'   
#' @return numeric; number of flights observed in one unit time of survey. 
#'    If the Wilson correction was used it will return the (approximate) mid-point of the 95% confidence interval 
#'    (see \url{https://en.wikipedia.org/wiki/Binomial_proportion_confidence_interval#Wilson_score_interval}).
#'  
#' @example examples/flux_example.R
#'
#' @importFrom Rdpack reprompt
#' @export
#'
encounter_rate <- function(
  df_obs_summary,
  #survey_units = "min",
  wilson_correction = TRUE
) {
  # Check if columns exist
  stopifnot(
    "size and/or survey_duration columns do not exist in the data.frame" = all(
      c("size", "survey_duration") %in% names(df_obs_summary)
    )
  )

  obs_size <- df_obs_summary$size
  survey_duration <- df_obs_summary$survey_duration
  
  if ("survey_weight" %in% names(df_obs_summary)) {
    survey_weight <- df_obs_summary$survey_weight
  } else {
    survey_weight <- rep(1, length(survey_duration))
  }

  stopifnot("NA survey durations detected" = !any(is.na(survey_duration)))
  if(all(survey_duration == 0)){
    stop("All surveys have a survey duration of 0")
  }
  if(any(survey_duration == 0)){
    warning("some surveys have 0 duration")
  }

  stopifnot(
    "NA survey weights detected - survey weights must be NULL or all specified." = !any(is.na(
      survey_weight
    ))
  )

  if (any(is.na(obs_size))) {
    warning(
      "NA observations detected - NA observation size will be assumed to be 0"
    )
    obs_size[is.na(obs_size)] <- 0
  }

  stopifnot(
    "obs_size, survey_duration must be equal length" = length(obs_size) ==
      length(survey_duration)
  )
  stopifnot(
    "survey_weight must be NULL or same length as survey_duration" = length(
      survey_weight
    ) ==
      length(survey_duration)
  )

  if (sum(obs_size) == 0) {
    # Is wil corr needed?

    if (isTRUE(wilson_correction)) {
      message("zero observations recorded - applying Wilson Correction")
      n_events <- 2
      mean_event_size <- 1
      # sd_event_size <- 0

      total <- n_events * mean_event_size
      effort <- sum(survey_duration) + 4 * mean(survey_duration)
    } else {
      warning(
        "Zero or NA events exist but Wilson Correction == FALSE. ",
        "Flight flux will be uncorrected. Is this what you want? "
      )
      total <- sum(obs_size * survey_weight)
      effort <- sum(survey_duration)
    } # wilson correct check
  } else {
    # no zero obs

    total <- sum(obs_size * survey_weight)
    effort <- sum(survey_duration)
  } # check for zero obs

  encounter_rate <- total / effort

  # encounter_rate <- units::set_units(encounter_rate, "1/min")
  # encounter_rate <- units::drop_units(encounter_rate)

  return(encounter_rate)
}