
#' check input class
#' @param x the input to check
check_input_class <- function(x) {
  
  if(!is.numeric(x) & !is.randInput(x) & !is.list(x) ){
    stop('Class must be one of "RandInput", "numeric", "list"')
  }
}

