#' Convert observed flight flux to number of flights through turbine plane (i.e. interactions).
#' 
#' @details
#' ## Scale to turbine
#' 
#' [turbine_flights()] converts the flight flux through one unit area of vertical space 
#' into the number of flights through an arbitrary vertical plane of width equal 
#' to rotor diameter and height equal to the tip height of the turbine.
#' 
#' The time interval is not adjusted (i.e. if you input flights / min, it will
#' output flights / min).
#' 
#' @param obs_flux numeric; number of flights through one unit area of vertical space
#'    per unit time as output by [obs_flux()] or similar
#' @param rotor_diameter numeric; rotor diameter. Must be in the equivalent units to 
#'    the unit area of `obs_flux` (i.e., if the `obs_flux` is per m\eqn{^2}, `rotor_diameter` must be in m).
#' @param hub_height numeric; hub height. Must be in the equivalent units to 
#'    the unit area of `obs_flux` (i.e., if the `obs_flux` is per m\eqn{^2}, `hub_height` must be in m).
#'
#' @return numeric; number of flights through turbine plane per unit time. 
#'    The turbine plane is a rectangle defined by the rotor diameter and tip height of the turbine.
#'    Time interval is the same as referenced by `obs_flux` input.
#'
#' @seealso [obs_flux()]
#'
#' @example examples/flux_example.R
#'
#' @export
turbine_flights <- function(obs_flux, rotor_diameter, hub_height) {
  check_num_bounds(obs_flux, min = 0)
  check_num_bounds(rotor_diameter, min = 0)
  check_num_bounds(hub_height, min = 0)
  
  turbine_height <- hub_height + 0.5*rotor_diameter
  res <- obs_flux * rotor_diameter * turbine_height
  return(res)
}


#' Convert flights per minute to flights per year
#'
#' A small helper function to expand flights per minute to flights per year
#' accounting for the time active.
#'
#' @details
#' ## Scale to year
#' 
#' After obtaining the observed flux through a vertical area in one unit time, 
#' we need to scale up to the relevant risk timeframe, often a year.
#' 
#' This can be done manually by the analyst for any time period, but we have 
#' included a helper function for the case of scaling to one year.
#' Note this function assumes the flux is the 
#' average flight flux when active onsite.  If surveys are conducted year round
#' and the flux represents the annual average then `prop_year` should be 1. If 
#' surveys are conducted only while the bird is on site and the flux represents
#' the average over the period the birds are on site then `prop_year` should be
#' the proportion of the year that the bird is on site. 
#' For example, if a bird is onsite for three months of the year and the flux 
#' was measured in that season only, the `prop_year = 3/12 = 0.25`.
#' 
#' Similarly care must be taken if the daily observation window does not overlap
#' completely with the birds activity. If the flight flux calculation 
#' includes times when the species is not active the `prop_day` should be 
#' adjusted to account for this, or the flux calculated only using
#' surveys during the activity period.
#' 
#'
#' @param flights_per_time numeric; number of flights through a vertical area in one unit time.
#' @param time_units Time units of `flights_per_time`. Defaults to "min" (i.e. flights per minute).
#' @param prop_day numeric; number between 0 and 1 representing the proportion
#'   of a 24 hour day the species is active onsite. Also refer to the details above.
#' @param prop_year numeric; number between 0 and 1 representing the proportion
#'   of a 12 month year the species is active onsite. Also refer to the details above.
#'
#' @example examples/flux_example.R
#'
#'
#' @seealso [obs_flux()], [turbine_flights()]
#' @export
flights_per_year <- function(
  flights_per_time,
  time_units = "min",
  prop_day,
  prop_year
) {
  check_num_bounds(flights_per_time, min = 0)
  check_num_bounds(prop_day, min = 0, max = 1)
  check_num_bounds(prop_year, min = 0, max = 1)
  
  flights_per_min <- units::set_units(flights_per_time,
                                      paste0("1/", time_units), mode = "standard")
  flights_per_min <- units::drop_units(flights_per_min)

  flights_per_min * 365.25 * 24 * 60 * prop_day * prop_year
}