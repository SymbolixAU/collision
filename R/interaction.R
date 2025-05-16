#' Calculate number of annual interactions between a bird and one turbine
#'
#' @param activity_rate numeric; the number of flights per kilometer
#'  per year at the location of the turbine. Must be a static value
#' @param prop_height numeric; the proportion of flights at the rotor swept height
#' @param bird_prop_year numeric; proportion of the year the species is active on-site
#' @param bird_prop_day numeric; proportion of a 24 hour day the bird is active (flying)
#' @param bird_obs_scale_factor numeric; proportion of surveyed time that the species is active. See details.
#' @param turb_prop_operational numeric; proportion of year the turbine is operational.
#' @param turb_blade_length numeric; the turbine blade length in metres.
#'
#' Activity rate must be in flights/kilometre^2/yr.
#'
#' See examples for detailed usage and correct use of scale factors.
#'
#' Note on how scale factors work. A general survey of (say birds), has \code{x}
#' out of 24 hours of bird activity. There are also \code{y} hours of survey, of
#' which \code{z} hours overlap with the bird activity hours.
#'
#' For the \code{y} hours of survey, an activity rate \code{n} is calculated, in
#' flights/area/time (let's say time is in hours). But really, although \code{y}
#' hours were surveyed, only \code{z} out of \code{y} hours actually have bird
#' activity.
#' So, in those \code{z} hours, the activity rate (during active period) is
#' \code{n*(y/z)=n/obs_scale_factor}. Then this is scaled by the proportion of
#' the day which is the active period, \code{x/24=prop_day}.
#'
#'
#'
#' @return numeric; number of interactions with a turbine,
#'                  given a flight exists at a known rate
#'
#' @examples
#'
#' # for one turbine
#' # see README and  [n_collision] for more complex examples
#' # and example of use in simulation
#'
#' n_interaction(
#'   activity_rate = 0.003,
#'   prop_height = 0.5,
#'   bird_prop_year = 1,
#'   bird_prop_day = 1,
#'   bird_obs_scale_factor = 1,
#'   turb_prop_operational = 0.9,
#'   turb_blade_length = 130
#' )
#'
#' @export
#'
n_interaction <- function(
    activity_rate,
    prop_height,
    bird_prop_year,
    bird_prop_day,
    bird_obs_scale_factor,
    turb_prop_operational,
    turb_blade_length) {
  check_num_bounds(activity_rate, min = 0)
  check_num_bounds(prop_height, min = 0, max = 1)
  check_num_bounds(bird_prop_year, min = 0, max = 1)
  check_num_bounds(bird_prop_day, min = 0, max = 1)
  check_num_bounds(bird_obs_scale_factor, min = 0, max = 1)
  check_num_bounds(turb_prop_operational, min = 0, max = 1)
  check_num_bounds(turb_blade_length, min = 0)


  return(
    (pi * (turb_blade_length / 1e3) **2) *
      activity_rate *
      prop_height *
      bird_prop_year *
      turb_prop_operational *
      (bird_prop_day / bird_obs_scale_factor)
  )
}


check_num_bounds <- function(var, min = Inf, max = Inf) {
  if (!inherits(var, "numeric")) {
    stop("Numeric input expected")
  }
  if (any(var < min) | any(var > max)) {
    stop("variable out of bounds")
  }
}
