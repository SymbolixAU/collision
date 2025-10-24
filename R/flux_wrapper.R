#' Estimate flights through turbine plane from observations
#' 
#' This is a wrapper to calculate the observed flight flux and scale
#' up to a turbine and a year.
#'
#' @details
#'
#' The steps to calculate the number of flights through a turbine 
#' plan includes three steps 
#'  
#' * Calculate the observed flights in a vertical square-metre area from the
#' count of observed flights and details of the surveys. See for example
#'  [obs_flux()]
#' * Scale the observed flight flux to an area equivalent to the 
#' rotor diameter by the maximum height of the turbine, e.g. [turbine_flux()]
#' * Scale the observed flight flux to the time period under study. There's a 
#'  helper function to scale to one year e.g [flux_per_year()]
#' 
#' ## Observed flux from point counts
#' 
#' Given a set of observations, survey durations and a related distance model
#' (fit using the `Distance` package \insertCite{Miller019a}{collision}) we 
#' calculate the flight flux through
#' a rectangle of width of 2*(effective detection radius) and height of the 
#' observer's effective detection height (see TODO for more info about effective
#'  detection height) in one minute of observation time. 
#'
#' The optional Wilson Correction can be used to
#' generate an flux in the case when no observations are made of the
#' species during the survey run.
#' 
#' Note the function accepts only single valued inputs, so stochastic inputs must
#' be sampled from prior to calling this function. See vignettes for more details
#' 
#' 
#' ## Scale to turbine
#' 
#' [turbine_flux()] converts the flight flux through one metre of vertical space 
#' into the number of flights through an arbitrary vertical plane of width equal 
#' to rotor diameter and height equal to the tip height of the turbine
#' 
#' The time interval is not adjusted (i.e. if you input flights / min, it will
#' output flights / min).
#'
#' ## Scale to year
#' 
#' After obtaining the observed flux through a vertical area in a minute, 
#' we need to scale up to the relevant risk timeframe, often a year.
#' 
#' This can be done manually by the analyst for any time period, but we have 
#' included a helper function for the case of scaling to one year ([flux_per_year()]).
#' Note this function assumes the flux is the 
#' average flight flux when active onsite.  If surveys are conducted year round
#' and the flux represents the annual average then `prop_year` should be 1. If 
#' surveys are conducted only while the bird is on site and the flux represents
#' the average over the period the birds are on site then `prop_year` should be
#' the proportion of the year that the bird is on site. 
#' For example, if a bird is onsite for three months of the year and the flux 
#' was measured in season only, the `prop_year = 3/12 = 0.25`.
#' 
#' Similarly care must be taken if the daily observation window does not overlap
#' completely with the birds activity. If the flight flux calculation 
#' includes times when the species is not active the `prop_day` should be 
#' adjusted to account for this, or the flux calculated only using
#' surveys during the activity period.
#' 
#' 
#' @param survey_type character; type of survey. Initially just point transects
#'   but methods for line transects and digital areal surveys are in development
#' @inheritParams obs_flux
#' @inheritParams turbine_flux
#' @inheritParams flux_per_year
#' 
#' @seealso [flux_per_year()], [turbine_flux()], [obs_flux()]
#' 
#' @references
#'   \insertAllCited{}
#' 
#' @example examples/flux_example.R
#' 
#' @export
turbine_flux_year <- function(
    survey_type = c("point"),
    encounter_rate,
    eff_detection_width,
    eff_detection_height,
    rotor_diameter,
    prop_below_turbine_max,
    prop_day,
    prop_year,
    encounter_per_units = "min",
    width_units = "m",
    height_units = "m",
    wilson_correction = TRUE
){
  
  if (is.null(survey_type) || is.na(survey_type)) stop("survey_type cannot be NA/NULL")

  switch (survey_type,
          "point" = {
            obs_flux <- flight_flux_point(
              encounter_rate = encounter_rate,
              eff_detection_width = eff_detection_width,
              eff_detection_height = eff_detection_height,
              encounter_per_units = encounter_per_units,
              width_units = width_units,
              height_units = height_units
            )
          },
          stop("Only point transects are currently implemented.
         Line transects and digital areal surveys TODO")
  )
  
  # SA: I think this can be removed now?
  # obs_flux <- flight_flux_point(
  #   obs_size = obs_size,
  #   survey_duration = survey_duration,
  #   eff_detection_width = eff_detection_width,
  #   survey_units = survey_units,
  #   width_units = width_units,
  #   survey_weight = survey_weight,
  #   wilson_correction = wilson_correction
  # )
  
  flux_min <- turbine_flux(
    obs_flux = obs_flux,
    rotor_diameter = rotor_diameter,
    prop_below_turbine_max = prop_below_turbine_max
  )
  
  flux_year <- flux_per_year(
    flux_per_min = flux_min,
    prop_day = prop_day,
    prop_year = prop_year
  )
  
  return(flux_year)
  
}

