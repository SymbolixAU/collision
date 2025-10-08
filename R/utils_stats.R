
#' Given a mean and standard deviation, solves for log normal distribution 
#' parameters meanlog and sdlog. 
#'
#' @param mean  the mean
#' @param sd  the standard deviation
#' 
#' @return `list` object with the mean and standard deviation of the 
#' distribution on the log scale. These are the `rlnorm` parameters `meanlog`
#' and `sdlog` used in the [stats::rlnorm()] function
#'
#' @examples
#'
#' log_rate <- parameterise_lnorm(mean = 0.002, sd = 0.0001)
#'
#' flight_flux_min <- set_random("rlnorm", 
#'                             meanlog = log_rate$mean, 
#'                             sdlog = log_rate$sd)
#' sample_input(flight_flux_min)
#'
#' @seealso [stats::rlnorm()]
#'
#' @export
parameterise_lnorm <- function(mean, sd) {

  check_num_bounds(mean, min = 0)
  check_num_bounds(sd, min = 0)
  
  v <- sd^2
  meanlog <- log(mean) - log(v / mean^2 + 1) / 2
  sdlog <- sqrt(log(v / mean^2 + 1))
  
  # now return the randInput object
  result <- list(meanlog = meanlog, sdlog = sdlog)
  
  return(result)
}
