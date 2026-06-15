#' Optional population correction
#' 
#' The default calculation predicts the number of flight movements that will
#' end in collision. This has an inherent assumption that the number of birds
#' generating the flights will be automatically replenished following for
#' collision. For small local populations this will be overly conservative.  
#' This function converts the number of movements ending in collision to
#' the number of birds, by accounting for the population at risk
#' 
#' 
#' 
#' @export
