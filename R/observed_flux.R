#' Calculate observed flights / min / metre from point transects
#' 
#' This function converts observed flights (movements), survey duration and effective detection radius (see for example \insertCite{Buckland2001;textual}{collision} ) into an estimate of flight flux per minute per square metre of vertical airspace \insertCite{Smales2013}{collision}.
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
#' @param obs_size integer; vector of the number of individuals seen in each
#'    observation. For no observations send zero length vector.
#' @param survey_duration numeric; vector holding the duration of each survey.
#'    NAs ignored.
#' @param eff_detection_width numeric; Allows you to manually specify the effective detection width, 
#'    which is usually 2 x effective detection radius
#' @param survey_units character; units of `survey_duration`. Defaults to "m". 
#'    Will return a warning if not "m" or "metres"/"meters"
#' @param width_units character; units of `eff_detection_width`. Defaults to "min". 
#'    Will return a warning if not "min" or "minutes"
#' @param survey_weight numeric; optional vector of survey weights if needed
#'    to account for stratification etc. When NULL (the default) will 
#'    weight surveys equally.
#' @param wilson_correction boolean;  Apply wilson correction if there are
#'    no observations. Defaults to TRUE
#'   
#' @return numeric; number of flights through vertical plane with width 
#'   `eff_detection_width` in one minute
#'  
#' @example examples/flux_example.R
#'   
#' @importFrom Rdpack reprompt
#' @export
flight_flux_point <- function(
    obs_size,
    survey_duration,
    eff_detection_width,
    survey_units = "min",
    width_units = "m",
    survey_weight = NULL,
    wilson_correction = TRUE
) {
  
  if(!survey_units %in% c("min", "minutes")){
    warning("survey duration will be converted to mins and 
            output will be flights / metre / minute")
  }
  
  if(!width_units %in% c("m", "meters", "metres")){
    warning("width_units will be converted to metres and 
            output will be flights / metre / minute")
  }
  
  survey_duration <- units::set_units(
    survey_duration, survey_units, mode = "standard"
  )
  eff_detection_width <- units::set_units(
    eff_detection_width, width_units, mode = "standard"
  )
  
  if (sum(is.na(obs_size)) > 0) {
    warning("NA observations detected - NA observations will be ignored")
  }
  
  if (sum(is.na(survey_duration)) > 0) {
    warning("NA survey durations detected - NA surveys will be ignored")
  }
  
  if (!is.null(eff_detection_width)) {
    if (!is.numeric(eff_detection_width)) stop(
      "effective detection width must be numeric")
    if (length(eff_detection_width) != 1) stop("edr must be length 1")
  }
  
  stopifnot("obs_size, survey_mins must be equal" = 
              length(obs_size) == length(survey_duration))
  stopifnot("survey_weight must be NULL or same length as survey_mins" = 
              is.null(survey_weight) | length(survey_weight) == length(survey_duration))
  
  if(is.null(survey_weight)){survey_weight <- rep(1, length(survey_duration))}
  
  if (length(obs_size) == 0) { # Is wil corr needed?
    
    if (isTRUE(wilson_correction)) {
      
      message("zero observations recorded - applying Wilson Correction")
      n_events <- 2
      mean_event_size <- 1
      sd_event_size <- 0
      effort <- sum(survey_duration, na.rm = TRUE) + 4 * mean(survey_duration, na.rm = TRUE)
      
    } else {
      warning(
        "Zero or NA  events exist but Wilson Correction == FALSE. ",
        "Flight flux will be uncorrected. Is this what you want? "
      )
      n_events <- length(obs_size)
      effort <- sum(survey_duration, na.rm = TRUE)
    } # wilson correct check
  } else { # no zero obs
    
    n_events <- length(obs_size)
    effort <- sum(survey_duration, na.rm = TRUE)
    
  } # check for zero obs
  
  
  obs_flux <- sum(obs_size*survey_weight) * n_events / (eff_detection_width * effort)
  
  #convert to flights / m / min
  obs_flux <- units::set_units(obs_flux, "1/m/min")
  obs_flux <- units::drop_units(obs_flux)
  
  return(obs_flux)
  
}




