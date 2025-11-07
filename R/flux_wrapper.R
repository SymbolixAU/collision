#' Estimate flights through turbine plane from observations
#' 
#' This is a wrapper to calculate the observed flight flux and scale
#' up to a turbine and a year.
#'
#' @details
#'
#' Calculating the number of flights through a turbine 
#' plane includes three steps 
#'  
#' * Calculate the observed flights in a vertical area from the
#' count of observed flights and details of the surveys. See for example
#'  [obs_flux()]
#' * Scale the observed flight flux to an area equivalent to the 
#' rotor diameter by the maximum height of the turbine, e.g. [turbine_flights()]
#' * Scale the flights to the time period under study. There's a 
#'  helper function to scale to one year from minutes e.g [flights_per_year()]
#' 
#' ## Observed flux from point counts
#' 
#' Given a set of observations, survey durations, a distribution of flight heights 
#' and a related distance model (fit using the `Distance` package \insertCite{Miller019a}{collision}) 
#' we calculate the flight flux through a rectangle with a width of 2*(effective detection radius) 
#' and a height of the mean (expected value) of the height distribution (because \eqn{E[X] = \int_{-\infty}^{\infty}xf(x)dx} 
#' approximates the area in which we expect one flight if we make a simplifying assumption
#' of uniform vertical density) in one unit of observation time. 
#'
#' 
#' Note the function accepts only single valued inputs, so stochastic inputs must
#' be sampled from prior to calling this function. See vignettes for more details
#' 
#' 
#' ## Scale to turbine
#' 
#' [turbine_flights()] converts the flight flux through one unit area of vertical space 
#' into the number of flights through an arbitrary vertical plane of width equal 
#' to rotor diameter and height equal to the tip height of the turbine.
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
#' included a helper function for the case of scaling to one year ([flights_per_year()]).
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
#' @param survey_type character; type of survey. Currently just point transects
#'   but methods for line transects and digital areal surveys are in development.
#' @inheritParams obs_flux
#' @inheritParams turbine_flights
#' @param time_units Time units of `encounter_rate`. Defaults to "min" (i.e. flights per minute).
#' @param prop_day numeric; number between 0 and 1 representing the proportion
#'   of a 24 hour day the species is active onsite. Also refer to the details below.
#' @param prop_year numeric; number between 0 and 1 representing the proportion
#'   of a 12 month year the species is active onsite. Also refer to the details below.
#' 
#' @seealso [flights_per_year()], [turbine_flights()], [obs_flux()]
#' 
#' @references
#'   \insertAllCited{}
#' 
#' @example examples/flux_example.R
#' 
#' @export
turbine_flights_year <- function(
    survey_type = c("point"),
    encounter_rate,
    time_units = "min",
    eff_detection_width,
    mean_flight_height,
    rotor_diameter,
    hub_height,
    prop_day,
    prop_year
){
  # Check if NA/NULL (only checking survey_type, others are checked in their respective functions)
  if (is.null(survey_type) || is.na(survey_type)) stop("survey_type cannot be NA/NULL")
  
  switch (survey_type,
          "point" = {
            obs_flux <- obs_flux(
              encounter_rate = encounter_rate,
              eff_detection_width = eff_detection_width,
              mean_flight_height = mean_flight_height
            )
          },
          stop("Only point transects are currently implemented.
         Line transects and digital areal surveys are in development.")
  )

  flights_min <- turbine_flights(
    obs_flux = obs_flux,
    rotor_diameter = rotor_diameter,
    hub_height = hub_height
  )
  
  flights_year <- flights_per_year(
    flights_per_time = flights_min,
    time_units = time_units,
    prop_day = prop_day,
    prop_year = prop_year
  )
  
  return(flights_year)
  
}

