#' rpm to rad_per_sec
#' 
#' Convert rotational speed in rpm to radians per second.
#' 
#'  ROT rpm x (1/60sec) x (2pi rad) = ROT' rad / sec
#'  
#'  @examples
#'  
#'  rpm_to_radpersec(1) # 0.1047
#'  
#'  @noRd
rpm_to_radpersec <- function(rpm){ rpm * 2. * pi / 60.}
