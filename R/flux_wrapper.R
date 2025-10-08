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
#' * Calculate the observed flights in a vertical column one metre wide from the
#' count of observed flights and details of the surveys. See for example
#'  [flight_flux_point()]
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
#' a rectangle of width of 2*(effective detection radius) and (maximum) height
#'  in one minute of observation time. 
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
#' [turbine_flux()] converts the flight flux through one metre of vertical space into the
#' number of flights through an arbitrary vertical plane of 
#' width equal to rotor diameter and height equal to the tip height of the turbine
#' 
#' The time interval is not adjusted (i.e. if you input flights / min, it will
#' output flights / min).
#'
#' ## Scale to year
#' 
#' After obtaining the observed flux through a vertical column in a minute, 
#' we need to scale up to the relevant risk timeframe, often a year.
#' 
#' This can be done manually by the analyst for any time period, but we have 
#' included a helper function for the case of scaling to one year ([flux_per_year()]).
#' Note this function assumes the flux is the 
#' average flight flux when active onsite.  If surveys are conducted year round
#' and the fluc represents the annual average then `prop_year` should be 1. 
#' If a bird is onsite for three months of the year and the flux was measured in 
#' season only, the `prop_year = 3/12 = 0.25`.
#' 
#' Similarly care must be taken if the daily observation window does not overlap
#' completely with the birds activity. If the flight flux calculation 
#' includes times when the species is not active the `prop_day` should be 
#' adjusted to account for this, or the flux calculated only using
#' observations during the activity period.
#' 
#' 
#' @param survey_type character; type of survey. Initially just point transects
#'   but methods for line transects and digital areal surveys are in development
#' @inheritParams flight_flux_point
#' @inheritParams turbine_flux
#' @inheritParams flux_per_year
#' 
#' @seealso [flux_per_year()], [turbine_flux()], [flight_flux_point()]
#' 
#' @references
#'   \insertAllCited{}
#' 
#' @example examples/flux_example.R
#' 
#' @export
turbine_flux_year <- function(
    survey_type = c("point"),
    obs_size,
    survey_duration,
    eff_detection_width,
    rotor_diameter,
    prop_below_turbine_max,
    prop_day,
    prop_year,
    survey_units = "min",
    width_units = "m",
    survey_weight = NULL,
    wilson_correction = TRUE
){
  
  switch (survey_type,
          "point" = {
            obs_flux <- flight_flux_point(
              obs_size,
              survey_duration,
              eff_detection_width,
              survey_units = survey_units,
              width_units = width_units,
              survey_weight = survey_weight,
              wilson_correction = wilson_correction
            )
          },
          stop("Only point transects are currently implemented.
         Line transects and digital areal surveys TODO")
  )
  
  obs_flux <- flight_flux_point(
    obs_size = obs_size,
    survey_duration = survey_duration,
    eff_detection_width = eff_detection_width,
    survey_units = survey_units,
    width_units = width_units,
    survey_weight = survey_weight,
    wilson_correction = wilson_correction
  )
  
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

