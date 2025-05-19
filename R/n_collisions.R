#' Calculate annual collision rate with static and dynamic avoidance
#'
#' @param avoidance_rate_static numeric; Number between 0 and 1 representing the
#' avoidance rate of static components (tower + static presented area)
#' @param avoidance_rate_dynamic numeric; Number between 0 and 1 representing the
#' avoidance rate of dynamic components (moving blade edge)
#' @param n_interaction_yr numeric; the number of flights per year that interacts
#' with a turbine. Calculated from [n_interaction()]
#' @param p_coll_static numeric; the probability of collision with static turbine components
#'  if an interaction occurs and avoidance is zero. Calculated from [prob_collision_static()]
#' @param p_coll_dynamic numeric; the probability of collision with dynamic blad edge turbine components
#'  if an interaction occurs and avoidance is zero. Calculated from [prob_collision_dynamic()]
#' @return numeric
#'
#' @examples
#' n_collision(
#'   avoidance_rate_static = 0.99,
#'   avoidance_rate_dynamic = c(0.90, 0.95),
#'   n_interaction_yr = 100,
#'   p_coll_static = 0.05,
#'   p_coll_dynamic = 0.03
#' )
#'
#' @export
n_collision <- function(
    avoidance_rate_static,
    avoidance_rate_dynamic,
    n_interaction_yr,
    p_coll_static,
    p_coll_dynamic) {
  stopifnot(inherits(avoidance_rate_static, "numeric"))
  stopifnot(inherits(avoidance_rate_dynamic, "numeric"))

  return(
    n_interaction_yr * (
      (1 - avoidance_rate_static) * p_coll_static +
        (1 - avoidance_rate_dynamic) * p_coll_dynamic
    )
  )
}