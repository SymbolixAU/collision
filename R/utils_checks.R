
#' check input class
#' @param x the input to check
check_input_class <- function(x) {
  
  if(!is.numeric(x) & !is.randInput(x) & !is.list(x) ){
    stop('Class must be one of "RandInput", "numeric", "list"')
  }
}




#' check input within bounds
#' @param x the input to check
#' @param min optional lower bound
#' @param max optional upper bound
check_num_bounds <- function(x, min = Inf, max = Inf) {
  if (!inherits(x, "numeric")) {
    stop("Numeric input expected")
  }
  if (any(x < min) | any(x > max)) {
    stop("variable out of bounds")
  }
}