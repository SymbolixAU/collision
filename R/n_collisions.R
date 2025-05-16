#' Calculate annual collision rate
#'
#' @param avoidance_rate numeric; Number between 0 and 1 representing the
#' avoidance rate
#' @param n_interaction_yr numeric; the number of flights per year that pass
#' through the turbine disk. Calculated from [n_interaction()]
#' @param p_collision numeric; the probability of collision if an interaction occurs and avoidance is zero. Calculated from [p_collision()]
#'
#' @return numeric
#'
#' @examples
#' n_collision(
#'   avoidance_rate = c(0.9, 0.99),
#'   n_interaction_yr = 100,
#'   p_collision = 0.01
#' )
#'
#' @export
n_collision <- function(
    avoidance_rate,
    n_interaction_yr,
    p_collision) {
  stopifnot(inherits(avoidance_rate, "numeric"))

  return(
    (1 - avoidance_rate) * n_interaction_yr * p_collision
  )
}