#' Calculate uncorrected observed flights / minute of survey from point transects
#' 
#' This function converts observed flights (movements), survey duration into the "encounter rate" per minute of survey. This value is uncorrected for the observer's effective detection area \insertCite{Buckland1993}{collision}.
#' 
#' @inherit turbine_flux_year details
#' 
#' @inherit turbine_flux_year references
#' 
#' @seealso [turbine_flux()] and [flux_per_year()] for methods to expand the 
#' observer flux into the flux through the turbine plane
#' 
#' @references
#'   \insertAllCited{}
#'   
#' @param df_obs data.frame; a data.frame containing at least columns `size` and 
#'    `survey_duration`. It can also optionally include a column `survey_weight` if needed
#'    to account for stratification etc. When NULL (the default) will 
#'    weight surveys equally.
#' @param survey_units character; units of `survey_duration`. Defaults to "min". 
#'    Will return a warning if not "min" or "minutes".
#' @param wilson_correction boolean;  Apply wilson correction if there are
#'    no observations. Defaults to TRUE (TODO add citation or explanation of wilson correction).
#'   
#' @return numeric; number of flights observed in one minute of survey.
#'  
#' @example examples/flux_example.R
#'   
#' @importFrom Rdpack reprompt
#' @export
#' 
encounter_rate <- function(
    df_obs,
    survey_units = "min",
    wilson_correction = TRUE
) {
  
  obs_size <- df_obs$size
  survey_duration <- df_obs$survey_duration
  survey_weight <- df_obs$survey_weight
  
  # maybe these checks should happen on the data.frame?
  
  stopifnot("NA survey durations detected" = 
              sum(is.na(survey_duration)) == 0)
  
  stopifnot("NA survey weights detected - survey weights must be NULL or all specified." = 
              sum(is.na(survey_weight)) == 0)
  
  if (sum(is.na(obs_size)) > 0) {
      warning("NA observations detected - NA observation size will be assumed to be 0")
    obs_size[is.na(obs_size)] <- 0
    }
  
  if(!survey_units %in% c("min", "minutes")){
    warning("survey duration will be converted to mins and 
            output will be flights / minute")
  }
  
  if (!is.null(survey_duration)){
    survey_duration <- units::set_units(
      survey_duration, survey_units, mode = "standard"
    )
  } # TODO: does this check make sense? Surely if survey duration is NULL it just should crash?
  
  stopifnot("obs_size, survey_mins must be equal" = 
              length(obs_size) == length(survey_duration))
  stopifnot("survey_weight must be NULL or same length as survey_mins" = 
              is.null(survey_weight) | length(survey_weight) == length(survey_duration))
  
  if(is.null(survey_weight)){survey_weight <- rep(1, length(survey_duration))}
  
  if (sum(obs_size) == 0) { # Is wil corr needed?
    
    if (isTRUE(wilson_correction)) {
      
      message("zero observations recorded - applying Wilson Correction")
      n_events <- 2
      mean_event_size <- 1
      sd_event_size <- 0
      
      total <- n_events*mean_event_size
      effort <- sum(survey_duration) + 4 * mean(survey_duration)
      
    } else {
      warning(
        "Zero or NA events exist but Wilson Correction == FALSE. ",
        "Flight flux will be uncorrected. Is this what you want? "
      )
      total <- sum(obs_size*survey_weight)
      effort <- sum(survey_duration)
    } # wilson correct check
  } else { # no zero obs
    
    total <- sum(obs_size*survey_weight)
    effort <- sum(survey_duration, na.rm = TRUE)
    
  } # check for zero obs
  
  encounter_rate <- total/effort
  
  encounter_rate <- units::set_units(encounter_rate, "1/min")
  encounter_rate <- units::drop_units(encounter_rate)
  
  return(encounter_rate)
  
}
