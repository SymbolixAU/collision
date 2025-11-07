#' Calculate observed flights / time / area from point transects
#' 
#' This function converts the uncorrected encounter rate, the effective detection radius 
#' (see for example \insertCite{Buckland2001;textual}{collision}) and the mean flight height into an estimate of flight flux
#'  per unit time per unit area of vertical airspace \insertCite{Smales2013}{collision}.
#' 
#' @inherit turbine_flights_year details
#' 
#' @inherit turbine_flights_year references
#' 
#' @seealso [encounter_rate()]
#' 
#' @seealso [turbine_flights()] and [flights_per_year()] for methods to expand the 
#' observer flux into the flights through the turbine plane
#' 
#' @references
#'   \insertAllCited{}
#'   
#' @param encounter_rate numeric; number of flights observed per unit time of survey
#'    as output by [encounter_rate()] or similar.
#' @param eff_detection_width numeric; Allows you to manually specify the effective detection width, 
#'    which is usually 2 x effective detection radius. Must be in the same units as `mean_flight_height`.
#' @param mean_flight_height numeric; The mean of the distribution of the flight heights.
#'    Must be in the same units as `eff_detection_width`.
#'   
#' @return numeric; number of flights through a vertical plane of unit area per unit time.
#'    Area units are defined by the units of the width and height, and time interval 
#'    is the same as referenced by `encounter_rate` input.
#'  
#' @example examples/flux_example.R
#' @export
#' 
obs_flux <- function(
    encounter_rate, 
    eff_detection_width,
    mean_flight_height
) {
  # TODO: fix all the checks
  # Leaving the old checks here in case there's useful code but feel free to delete
  # if(!survey_units %in% c("min", "minutes")){
  #   warning("survey duration will be converted to mins and 
  #           output will be flights / metre / minute")
  # }
  # 
  # 
  # if (!is.null(survey_duration)){
  #   survey_duration <- units::set_units(
  #     survey_duration, survey_units, mode = "standard"
  #   )
  # }
  # 
  # 
  # if (!is.null(eff_detection_width)) {
  #   if (!is.numeric(eff_detection_width)) stop(
  #     "effective detection width must be numeric")
  #   if (length(eff_detection_width) != 1) stop("effective detection width must be length 1")
  # }
  # 
  # 
  # if (sum(is.na(obs_size)) > 0) {
  #   warning("NA observations detected - NA observations will be ignored")
  # }
  # 
  # if (sum(is.na(survey_duration)) > 0) {
  #   warning("NA survey durations detected - NA surveys will be ignored")
  # }
  # 
  # stopifnot("obs_size, survey_mins must be equal" = 
  #             length(obs_size) == length(survey_duration))
  # stopifnot("survey_weight must be NULL or same length as survey_mins" = 
  #             is.null(survey_weight) | length(survey_weight) == length(survey_duration))
  # 
  # if(is.null(survey_weight)){survey_weight <- rep(1, length(survey_duration))}
  
  observer_vertical_area <- mean_flight_height*eff_detection_width 
  
  obs_flux <- encounter_rate/observer_vertical_area # flights/area/time
  
  return(obs_flux)
  
}

