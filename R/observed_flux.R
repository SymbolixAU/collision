#' Calculate observed flights / min / square metre from point transects
#' 
#' This function converts the uncorrected encounter rate, the effective detection radius (see for example \insertCite{Buckland2001;textual}{collision} ) and the effective detection height into an estimate of flight flux per minute per square metre of vertical airspace \insertCite{Smales2013}{collision}.
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
#' @param encounter_rate numeric; number of flights observed in a minute of survey
#'    as output by [encounter_rate()] or similar. Must be in units of flights / minute.
#' @param eff_detection_width numeric; Allows you to manually specify the effective detection width, 
#'    which is usually 2 x effective detection radius
#' @param eff_detection_height numeric; Allows you to manually specify the effective detection height of the observer
#' @param width_units character; units of `eff_detection_width`. Defaults to "m". 
#'    Will return a warning if not "m" or "metres/meters"
#' @param height_units character; units of `eff_detection_height`. Defaults to "m". 
#'    Will return a warning if not "m" or "metres/meters"
#'   
#' @return numeric; number of flights through vertical plane with width 
#'   `eff_detection_width` and height `eff_detection_height` in one minute.
#'  
#' @example examples/flux_example.R
#'   
#' @importFrom Rdpack reprompt
#' @export
#' 
#' 
obs_flux <- function(
    encounter_rate, # numeric per min
    eff_detection_width, # numeric
    eff_detection_height,
    width_units = "m",
    height_units = "m"
) {
  
  # Check parameter values
  check_num_bounds(encounter_rate, min = 0, max = Inf)
  check_num_bounds(eff_detection_width, min = 0, max = Inf)
  check_num_bounds(eff_detection_height, min = 0, max = Inf)
  
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
  
  eff_detection_width <- units::set_units(
    eff_detection_width, width_units, mode = "standard"
  )
  
  if (is.null(height_units) || is.na(height_units)){
    warning("height_units is assumed to be meters")
    height_units <- "m"
  }
  
  if(!height_units %in% c("m", "meters", "metres")){
    warning("height_units will be converted to metres and
            output will be flights / metre^2 / minute")
  }
  
  eff_detection_height <- units::set_units(
    eff_detection_height, height_units, mode = "standard"
  )
  
  # Maybe we need to add the encounter rate units? For now I have just specified that they have to be per minute in the @params bit
  encounter_rate <- units::set_units(
    encounter_rate, "1/min", mode = "standard"
  )
  
  observer_vertical_area <- eff_detection_height*eff_detection_width
  
  obs_flux <- encounter_rate/observer_vertical_area # flights/m^2/min
  
  obs_flux <- units::set_units(obs_flux, "1/m^2/min")
  obs_flux <- units::drop_units(obs_flux)
  
  return(obs_flux)
  
}




