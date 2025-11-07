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
#' 
#' 
obs_flux <- function(
    encounter_rate, 
    eff_detection_width,
    mean_flight_height
) {
  
  # Check parameter values
  check_num_bounds(encounter_rate, min = 0, max = Inf)
  check_num_bounds(eff_detection_width, min = 0, max = Inf)
  check_num_bounds(mean_flight_height, min = 0, max = Inf)
  
  # Check if vector
  if (is.vector(encounter_rate))
  
  if (is.null(width_units) || is.na(width_units)){
    warning("width_units is assumed to be meters")
    width_units <- "m"
  }

  if(!width_units %in% c("m", "meters", "metres")){
    warning("width_units will be converted to metres and
            output will be flights / metre^2 / minute")
  }

  observer_vertical_area <- 2.0*mean_flight_height*eff_detection_width 
  
  obs_flux <- encounter_rate/observer_vertical_area # flights/area/time
  
  return(obs_flux)
  
}

