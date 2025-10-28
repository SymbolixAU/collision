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
#' @param wilson_correction boolean; Apply wilson correction if there are
#'    no observations. Defaults to TRUE
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
  if(!width_units %in% c("m", "meters", "metres")){
    warning("width_units will be converted to metres and
            output will be flights / metre^2 / minute")
  }
  
  eff_detection_width <- units::set_units(
    eff_detection_width, width_units, mode = "standard"
  )
  
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




