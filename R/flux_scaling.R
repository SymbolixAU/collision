#' Convert observed flight flux to number of flights through turbine plane 
#' 
#' @inherit turbine_flights_year details
#'
#' @inherit turbine_flights_year references
#'
#'
#'
#' @param obs_flux numeric; number of flights through one unit area of vertical space
#'    per unit time as output by [obs_flux()] or similar
#' @param rotor_diameter numeric; rotor diameter. Must be in the equivalent units to 
#'    the unit area of `obs_flux` (i.e., if the `obs_flux` is per \eqn{m^2}, `rotor_diameter` must be in m).
#' @param hub_height numeric; hub height. Must be in the equivalent units to 
#'    the unit area of `obs_flux` (i.e., if the `obs_flux` is per \eqn{m^2}, `hub_height` must be in m).
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
#' @inherit turbine_flights_year details
#'
#' @inherit turbine_flights_year references
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