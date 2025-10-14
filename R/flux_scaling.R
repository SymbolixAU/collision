#' Convert observed flight flux to number flights through turbine plane
#'
#' @inherit turbine_flux_year details
#'
#' @inherit turbine_flux_year references
#'
#'
#'
#' @param obs_flux numeric; number of flights through one metre of vertical space
#'    as output by [flight_flux_point()] or similar
#' @param rotor_diameter numeric; rotor diameter (m)
#' @param prop_below_turbine_max numeric; proportion of the flight height
#'    distribution below max top height. Between 0 and 1.
#'
#' @return numeric; number of flights through turbine plane.
#'    Time interval is the same as refernced by `obs_flux` input
#'
#' @seealso [flight_flux_point()]
#'
#' @example examples/flux_example.R
#'
#' @export
turbine_flux <- function(obs_flux, rotor_diameter, prop_below_turbine_max) {
  check_num_bounds(obs_flux, min = 0)
  check_num_bounds(rotor_diameter, min = 0)
  check_num_bounds(prop_below_turbine_max, min = 0, max = 1)

  res <- obs_flux * rotor_diameter * prop_below_turbine_max
  return(res)
}


#' Convert flights per minute to flights per year
#'
#' A small helper function to expand flights per minute to flights per year
#' accounting for the time active.
#'
#' @inherit turbine_flux_year details
#'
#' @inherit turbine_flux_year references
#'
#' @param flux_per_min numeric; number of flights through a vertical area in one minute.
#' @param prop_day numeric; number between 0 and 1 representing the proportion
#'   of a 24 hour day the species is active onsite. Also refer to the details above.
#' @param prop_year numeric; number between 0 and 1 representing the proportion
#'   of a 12 month year the species is active onsite. Also refer to the details above.
#'
#' @example examples/flux_example.R
#'
#'
#' @seealso [flight_flux_point()]
#' @export
flux_per_year <- function(
  flux_per_min,
  prop_day,
  prop_year
) {
  check_num_bounds(flux_per_min, min = 0)
  check_num_bounds(prop_day, min = 0, max = 1)
  check_num_bounds(prop_year, min = 0, max = 1)

  flux_per_min * 365.25 * 24 * 60 * prop_day * prop_year
}