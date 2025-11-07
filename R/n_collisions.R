#' Calculate collision rate with static and dynamic avoidance
#'
#' @param avoidance_rate_static numeric; Number between 0 and 1 representing the
#' avoidance rate of static components (tower + static presented area)
#' @param avoidance_rate_dynamic numeric; Number between 0 and 1 representing the
#' avoidance rate of dynamic components (moving blade edge)
#' @param n_flights numeric; Flights though the turbine per unit time. Calculated from 
#'                [turbine_flights_year()] or similar.
#' @param p_coll_static numeric; the probability of collision with static 
#'                      turbine components if an interaction occurs and 
#'                      avoidance is zero. Calculated from 
#'                      [prob_collision_static()]
#' @param p_coll_dynamic numeric; the probability of collision with dynamic 
#'                       blade edge turbine components if an interaction occurs 
#'                       and avoidance is zero. Calculated from 
#'                       [prob_collision_dynamic()]
#' 
#' @return numeric; number of collisions per unit time. Time interval 
#'    is the same as referenced by `n_flights` input.
#'
#' @examples
#' n_collision(
#'   avoidance_rate_static = 0.99,
#'   avoidance_rate_dynamic = c(0.90, 0.95),
#'   n_flights = 100,
#'   p_coll_static = 0.05,
#'   p_coll_dynamic = 0.03
#' )
#'
#' @export
n_collision <- function(
    avoidance_rate_static,
    avoidance_rate_dynamic,
    n_flights,
    p_coll_static,
    p_coll_dynamic) {

  check_num_bounds(avoidance_rate_static, min = 0, max = 1)
  check_num_bounds(avoidance_rate_dynamic, min = 0, max = 1)
  check_num_bounds(n_flights, min = 0)
  check_num_bounds(p_coll_static, min = 0, max = 1)
  check_num_bounds(p_coll_dynamic, min = 0, max = 1)


  return(
    n_flights *(
      (1 - avoidance_rate_static) * p_coll_static +
        (1 - avoidance_rate_dynamic) * p_coll_dynamic
    )
  )
}