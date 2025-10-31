#' Probability of interaction - flat utilisation
#' 
#' TODO expand If the flight rate is not spatially variable, we can approximate 
#' a flight by a random walk and calculate the average number of turbines 
#' encountered by any flight is the square root of the total number of 
#' turbines (See Smales et al 2013). It follows that the probability of 
#' interation with a given turbine location is 1 / sqrt(number of turbines).
#' 
#' If calculating the flights per turbine (rather than at the farm level) the 
#' probability of interacting is actually contained within the [obs_flux()] and [turbine_flights()] calculations.
#' 
#' @param num_turbines the total number of turbines on the site (or sub site) 
#'                     you are modelling
#' 
#' @return numeric
#' 
#' @examples
#' 
#' prob_interaction_flat(num_turbines = 100)
#' 
#' @export
prob_interaction_flat <- function(num_turbines){
  if (any(!is.numeric(num_turbines)) || 
    all.equal(num_turbines, as.integer(num_turbines)) != TRUE) {
    stop("num_turbines must be integer")
  }
  if (any(num_turbines <= 0)) {
    stop("num_turbines must be greater than 0")
  }

  1.0/sqrt(num_turbines)
}