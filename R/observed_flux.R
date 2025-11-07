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
#' @export
obs_flux <- function(
  encounter_rate,
  eff_detection_width,
  mean_flight_height
) {
  # Check parameter values
  check_num_bounds(encounter_rate, min = 0, max = Inf)

  # eff_detection_width and mean_flight_height should be greater than 0
  stopifnot(
    "Effective detection width must be numeric and greater than 0" = !is.null(
      eff_detection_width
    ) &&
      !is.na(eff_detection_width) &&
      is.numeric(eff_detection_width) &&
      eff_detection_width > 0
  )
  stopifnot(
    "Mean flight height must be numeric and greater than 0" = !is.null(
      mean_flight_height
    ) &&
      !is.na(mean_flight_height) &&
      is.numeric(mean_flight_height) &&
      mean_flight_height > 0
  )

  observer_vertical_area <- 2.0 * mean_flight_height * eff_detection_width

  obs_flux <- encounter_rate / observer_vertical_area # flights/area/time

  return(obs_flux)
}