#' Calculate observed flights / time / area from point transects
#'
#' This function converts the uncorrected encounter rate, the effective detection radius
#' (see for example \insertCite{Buckland2001;textual}{collision}) and the effective detection height into an estimate of flight flux
#'  per unit time per unit area of vertical airspace \insertCite{Smales2013}{collision}.
#'
#' @details
#' ## Observed flux from point counts
#' 
#' Given an encounter rate ([encounter_rate()]), a distribution of flight heights 
#' and a related distance model (fit using the `Distance` package \insertCite{Miller019a}{collision}) 
#' we calculate the flight flux through a rectangle with a width of 2 x (effective detection radius) 
#' and a height equal to the effective detection height (typically set to the tip height of the proposed turbine) 
#' in one unit of observation time.
#'
#' 
#' Note the function accepts only single valued inputs, so stochastic inputs must
#' be sampled from prior to calling this function. For more information, 
#' see \code{vignette("simple-simulation-example", package = "collision")}.
#' 
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
#'    which is usually 2 x effective detection radius or 2 x effective strip (half) width. 
#'    Must be in the same units as `eff_detection_height`.
#' @param eff_detection_height numeric; The effective detection height. Because the 
#' density of flights typically decreases with increasing height, the assumption of uniform
#' density required for traditional distance correction doesn't hold. So the observer's
#' detection function is effectively convolved with the flight height distribution 
#' of the bird. Therefore, in most cases we recommend using the maximum tip height of the turbine
#' as the "effective detection height" and desktop truncating the observations to
#' that height. This is the simplest way to avoid artificially inflating or deflating 
#' the flux through the turbine. It is possible to use another method to estimate
#' an effective detection height but we leave this to the analyst's judgement. 
#' Must be in the same units as `eff_detection_width`.
#'
#' @return numeric; number of flights through a vertical plane of unit area per unit time.
#'    Area units are defined by the units of the width and height, and time interval
#'    is the same as referenced by the `encounter_rate` input.
#'
#'
#' @references
#'   \insertAllCited{}
#' 
#' @example examples/flux_example.R
#'
#' @export
obs_flux <- function(
  encounter_rate,
  eff_detection_width,
  eff_detection_height
) {
  # Check parameter values
  check_num_bounds(encounter_rate, min = 0, max = Inf)

  # eff_detection_width and eff_detection_height should be greater than 0
  stopifnot(
    "Effective detection width must be numeric and greater than 0" = !is.null(
      eff_detection_width
    ) &&
      !is.na(eff_detection_width) &&
      is.numeric(eff_detection_width) &&
      eff_detection_width > 0
  )
  stopifnot(
    "Effective detection height must be numeric and greater than 0" = !is.null(
      eff_detection_height
    ) &&
      !is.na(eff_detection_height) &&
      is.numeric(eff_detection_height) &&
      eff_detection_height > 0
  )

  observer_vertical_area <- eff_detection_height * eff_detection_width

  obs_flux <- encounter_rate / observer_vertical_area # flights/area/time

  return(obs_flux)
}
