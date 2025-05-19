#' Distance corrected activity rate
#'
#' The activity rate is defined as the number of flights per
#' square kilometer per year, assuming constant presence (we deal with that
#' at a later step).
#'
#' Given a set of observations, survey durations and a related distance model
#' (fit using the \code{Distance} package), returns the activity rate in
#' individuals / year / km^2.  The optional Wilson Correction can be used to
#' generate an activity rate in the case when no observations are made of the
#' species during the survey run.
#'
#' @param ds_model an object of class \code{dsmodel} fit using
#'                  \code{Distance::ds}. Must use metres as measure of distance
#' @param obs_size integer; vector of the number of individuals seen in each
#'                observation. For no observations send zero length vector.
#' @param survey_mins numeric; vector holding the duration of each survey.
#'                    NAs ignored. Must use units of minutes.
#' @param mean_event_size numeric; Allows the user to submit a custom variable
#'                    for the mean event size.  Defaults to the mean of obs_size.
#' @param sd_event_size numeric; Allows the user to submit a custom variable
#'                    for the sd event size.  Defaults to the sd of obs_size.
#' @param wilson_correction boolean;  Apply wilson correction if there are
#'                          no observations? Defaults to true
#' @param eda optional numeric; Allows you to manually specify the EDA, must be in square metres. Defaults to \code{NULL} (extracting it from the distance model).
#'
#' @return list; the mean and sd of activity rate
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
#' activity_rate_distcorr(ds_example,
#'     obs_size = obs,
#'     survey_mins = survey
#' )
#'
#' # zero observations using wilson correction
#'
#' obs <- integer()
#' survey <- c(60, 60, 60, 45, 30)
#' activity_rate_distcorr(ds_example,
#'     obs_size = obs,
#'     survey_mins = survey,
#'     wilson_correction = TRUE
#' )
#'
#' # zero observations without wilson correction returns NaN
#' # and warning
#'
#' activity_rate_distcorr(ds_example,
#'     obs_size = obs,
#'     survey_mins = survey,
#'     wilson_correction = FALSE
#' )
#'
#' @import Distance
#' @importFrom stats sd
#' @export
activity_rate_distcorr <- function(
    ds_model = NULL,
    obs_size, # vector
    survey_mins, # vector
    mean_event_size = mean(obs_size, na.rm = TRUE),
    sd_event_size = sd(obs_size, na.rm = TRUE),
    wilson_correction = TRUE,
    eda = NULL) {

    if (!is.null(ds_model) & !inherits(ds_model, "dsmodel")) {
        stop("Distance model must have class dsmodel")
    }

    if (sum(is.na(obs_size)) > 0) {
        warning("NA observations detected - NA observations will be ignored")
    }

    if (sum(is.na(survey_mins)) > 0) {
        warning("NA survey durations detected - NA surveys will be ignored")
    }

    if (!is.null(eda)) {
        if (!is.numeric(eda)) stop("eda must be numeric if not NULL")
        if (length(eda) != 1) stop("eda must be length 1")
    }

    if (is.null(eda) & is.null(ds_model)) {
        stop("Please specify one of eda or ds_model")
    }

    if (!is.null(eda) & !is.null(ds_model)) {
        stop("Please specify one and only one of eda or ds_model")
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
                "Activity rate will be uncorrected. Is this what you want? "
            )
            n_events <- length(obs_size)
            effort <- sum(survey_mins, na.rm = TRUE)
        } # wilson correct check
    } else { # no zero obs

        n_events <- length(obs_size)
        effort <- sum(survey_mins, na.rm = TRUE)
    } # check for zero obs

    if (is.null(eda)) eda <- eda_from_distmodel(ds_model)

    # calculate activity rate in obs / m^2 / mins
    act_rate <- (mean_event_size * n_events) /
        (eda * effort)

    act_rate_sd <- (sd_event_size * n_events) /
        (eda * effort)

    # convert to obs / km2 / year
    act_rate <- act_rate * (1e6) * (60 * 24 * 365.25)
    act_rate_sd <- act_rate_sd * (1e6) * (60 * 24 * 365.25)

    result <- list(mean = act_rate, sd = act_rate_sd)

    return(result)
}
