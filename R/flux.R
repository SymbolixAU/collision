#' Distance corrected flight flux
#'
#' The flight flux is defined as the number of flights per minute through a 
#' cylinder of rotor diameter and maximum turbine height.  We consider that 
#' every flight through the cylinder intersects a rectangular plane of width of 
#' the rotor diameter and maximum turbine height. This works because in the 
#' probability of collision calculations [prob_collision_static()] and 
#' [prob_collision_dynamic()] project the volume of the turbine onto the same 
#' plane. 
#' 
#' # Details
#'
#' Given a set of observations, survey durations and a related distance model
#' (fit using the \code{Distance} package) we calculate the flight flux through 
#' a rectangle of width of 2*(effective detection radius) and (maximum) height 
#' of the turbine in one minute of observation time. We then calculate the 
#' adjusted flux through a rectangle of the width of the turbine rotor diameter.
#' 
#' The optional Wilson Correction can be used to
#' generate an flux in the case when no observations are made of the
#' species during the survey run.
#'
#' @param obs_size integer; vector of the number of individuals seen in each
#'                observation. For no observations send zero length vector.
#' @param survey_mins numeric; vector holding the duration of each survey.
#'                    NAs ignored. Must use units of minutes.
#' @param edr numeric; Allows you to manually specify the EDR, must be in 
#'            metres. If null \code{NULL} the function will extract it from the 
#'            distance model.
#' @param prop_at_height proportion of flights at height
#' @param prop_below_height proportion of flights below rotor height
#' @param rotor_diameter rotor diameter (m)
#' @param mean_event_size numeric; Allows the user to submit a custom variable
#'                    for the mean event size.  Defaults to the mean of obs_size.
#' @param sd_event_size numeric; Allows the user to submit a custom variable
#'                    for the sd event size.  Defaults to the sd of obs_size.
#' @param wilson_correction boolean;  Apply wilson correction if there are
#'                          no observations? Defaults to true
#' @param ds_model an object of class \code{dsmodel} fit using 
#'                 \code{Distance::ds}. Must use metres as measure of distance. 
#'                 Defaults to NULL
#'
#' @return list; the mean and sd of flux through turbine in flights / min
#'
#' @references
#' Wilson score interval example:
#' \url{https://en.wikipedia.org/wiki/Binomial_proportion_confidence_interval#Wilson_score_interval}
#'
#'
#' @examples
#'
#' obs <- c(0, 1, 1, 3, 4)
#' survey <- c(60, 60, 60, NA, 30)
#'
#' flight_flux(
#'     obs_size = obs,
#'     survey_mins = survey,
#'     edr = 300,
#'     prop_at_height = 0.3,
#'     prop_below_height = 0.7,
#'     rotor_diameter = 230 
#' )
#'
#' # zero observations using wilson correction
#'
#' obs <- integer()
#' survey <- c(60, 60, 60, 45, 30)
#' flight_flux(
#'     obs_size = obs,
#'     survey_mins = survey,
#'     wilson_correction = TRUE,
#'     edr = 300,
#'     prop_at_height = 0.3,
#'     prop_below_height = 0.7,
#'     rotor_diameter = 230 
#' )
#'
#' # zero observations without wilson correction returns NaN
#' # and warning
#'
#' flight_flux(
#'     ds_model = ds_example,
#'     obs_size = obs,
#'     survey_mins = survey,
#'     wilson_correction = FALSE,
#'     prop_at_height = 0.3,
#'     prop_below_height = 0.7,
#'     rotor_diameter = 230 
#' )
#'
#' @import Distance
#' @importFrom stats sd
#' @export
flight_flux <- function(
    obs_size, # vector
    survey_mins, # vector
    edr = NULL,
    prop_at_height,
    prop_below_height,
    rotor_diameter,
    mean_event_size = mean(obs_size, na.rm = TRUE),
    sd_event_size = sd(obs_size, na.rm = TRUE),
    wilson_correction = TRUE,
    ds_model = NULL
    ) {

    if (!is.null(ds_model) && !inherits(ds_model, "dsmodel")) {
        stop("Distance model must have class dsmodel")
    }

    if (sum(is.na(obs_size)) > 0) {
        warning("NA observations detected - NA observations will be ignored")
    }

    if (sum(is.na(survey_mins)) > 0) {
        warning("NA survey durations detected - NA surveys will be ignored")
    }

    if (!is.null(edr)) {
        if (!is.numeric(edr)) stop("edr must be numeric if not NULL")
        if (length(edr) != 1) stop("edr must be length 1")
    }

    if (is.null(edr) && is.null(ds_model)) {
        stop("Please specify one of edr or ds_model")
    }

    if (!is.null(edr) && !is.null(ds_model)) {
        stop("Please specify one and only one of edr or ds_model")
    }

    if (length(prop_at_height) != 1) stop("prop_at_height must be length 1")
    if (!is.numeric(prop_at_height)) stop("prop_at_height must be numeric")
    if (prop_at_height < 0 || prop_at_height > 1) {
        stop("prop_at_height must be in range [0, 1]")
    }

    if (length(prop_below_height) != 1) stop("prop_below_height must be length 1")
    if (!is.numeric(prop_below_height)) stop("prop_below_height must be numeric")
    if (prop_below_height < 0 || prop_below_height > 1) {
        stop("prop_below_height must be in range [0, 1]")
    }

    if (prop_at_height + prop_below_height > 1) {
        stop("prop_at_height + prop_below_height must not be greater than 1")
    }

    if (length(rotor_diameter) != 1) stop("rotor_diameter must be length 1")
    if (!is.numeric(rotor_diameter)) stop("rotor_diameter must be numeric")
    if (rotor_diameter < 0) {
        stop("rotor_diameter must be greater than 0")
    }


    if (length(obs_size) == 0) { # Is wil corr needed?

        if (isTRUE(wilson_correction)) {
            n_events <- 2
            mean_event_size <- 1
            sd_event_size <- 0
            effort <- sum(survey_mins, na.rm = TRUE) + 4 * mean(survey_mins, na.rm = TRUE)
        } else {
            warning(
                "Zero or NA  events exist but Wilson Correction == FALSE. ",
                "Flight flux will be uncorrected. Is this what you want? "
            )
            n_events <- length(obs_size)
            effort <- sum(survey_mins, na.rm = TRUE)
        } # wilson correct check
    } else { # no zero obs

        n_events <- length(obs_size)
        effort <- sum(survey_mins, na.rm = TRUE)
    } # check for zero obs

    if (is.null(edr)) edr <- edr_from_distmodel(ds_model)

    # Flights through plane of 2*edr*height
    n_obs <- (mean_event_size * n_events) * (prop_at_height + prop_below_height)
    sd_obs <- (sd_event_size * n_events)
    
    
    # Convert to flights through turbine plan
    flux <- n_obs * rotor_diameter / (2 * edr * effort)

    flux_sd <- sd_obs * rotor_diameter / (2 * edr * effort)

    result <- list(mean = flux, sd = flux_sd)

    return(result)
}



#' Flux though the turbine area per year
#' 
#' Converts flights per minute from [flight_flux()] into an annual rate
#' 
#' Note this calculation assumes the \code{flux_per_min} is representative of 
#' the annual average flight rate. If the observation period does not represent 
#' the flights during active hours of the day and annual activity, the inputs 
#' below may need adjusting, or the annual flux may need to be calculated using 
#' an alternative method.
#' 
#' @param flux_per_min flux through turbine in flights / min
#' @param prop_day proportion of 24 hour day the species is active onsite
#' @param prop_year proportion of year the species is present onsite
#' 
#' @return numeric; flux through turbine in flights / year
#' 
#' @export
flux_per_year <- function(
    flux_per_min,
    prop_day,
    prop_year
){ 

  if (any(!is.numeric(flux_per_min))) stop("flux_per_min must be numeric")
  
  check_num_bounds(flux_per_min, min = 0)
  check_num_bounds(prop_day, min = 0, max = 1)
  check_num_bounds(prop_year, min = 0, max = 1)
  

  flux_per_min * 365.25 * 24 * 60 * prop_day * prop_year

}