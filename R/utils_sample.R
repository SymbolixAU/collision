#' Define how to sample a random input
#'
#' @description
#' Stochastic input definitions using the analysts choice of base
#' R sample distributions. Method to extend the \link{sample_input} function
#'
#' @param distr string. The name of the R function to return random deviates (e.g. \code{runif}, \code{rnorm}). See vignettes for examples of fitting to an empirical distribution.
#' @param ... Additional parameters passed to the function \code{distr}. Do *not* set \code{n} (number of samples) here. This is set in \link{sample_input} to separate the simulation settings and statistical distribution definition.
#'
#' @seealso  \link{sample_input} to sample a value according to the definition.
#'
#' @examples
#'
#' # sample from standard R functions
#' set_random("runif", min = 0, max = 10)
#' set_random("runif", n = 1, min = 0, max = 10) # n is ignored
#'
#' set_random("rbeta", shape1 = 1, shape2 = 3, ncp = 0)
#' set_random("rgamma", shape = 1, rate = 1, scale = 1)
#'
#' @export
set_random <- function(distr, ...) {
  
  # grab the args to pass to distr
  dist_params <- list(...)
  
  if ("n" %in% names(dist_params)) {
    warning("'n' will be ignored. Please set in inputs to `sample_input` instead.")
    dist_params[["n"]] <- NULL
  }
  
  # check args are valid
  if( !exists(distr) ) stop("Unknown distribution ", distr )
  if( !inherits(get(distr), "function") ) stop(
    "Invalid class - distr should be a function"
  )
  if(!all(names(dist_params) %in% methods::formalArgs(get(distr))) ){
    stop("You've named a parameter that doesn't exist in ", distr)
  }
  if(substr(distr, start=1, stop=1) != "r"){
    warning("I'm going to assume you know what you are doing, but ",
            "normally `distr` starts with an 'r' for random deviates")
  }
  
  # now return the randInput object
  x <- list(distr = distr, params = list(...))
  class(x) <- "randInput"
  x
}


#'
#' @rdname set_random
#'
#' @param x object to check
#'
#' @export
is.randInput <- function(x) inherits(x, "randInput")


#' Sample value from chosen distribution
#'
#' Returns sampled value for random or fixed inputs
#'
#' @param input an object of class \code{randInput} or \code{numeric}. See \link{set_random} for details
#' @param ... Additional parameters passed to methods.
#'
#' @examples
#'
#' var1 <- set_random("runif", min = 0, max = 10) # sample 1 (default)
#' is.randInput(var1) # should be true
#' sample_input(var1) # random
#' sample_input(var1, n=10) # samole 10 values
#'
#' sample_input(17)  # fixed input
#' sample_input(17, n=10)  # fixed input, replicated
#'
#' @export
sample_input <- function(input, ...) UseMethod("sample_input", input)

#' @rdname sample_input
#'
#' @param n integer. The number of samples to draw. Defaults to 1.
#'
#' @export
sample_input.randInput <- function(input, ..., n = 1) {
  
  res <- do.call(input$distr, append(input$params, list(n = n)))

  return(res)
}


#' @rdname sample_input
#'
#' @param n integer. The number of samples to draw. Defaults to 1.
#'
#' @export
sample_input.birdInput <- function(input, ..., n = 1) {

  for (col in names(input)){
    input[[col]] <- sample_input(input[[col]], ..., n = n)
  }
  
  return(input)
  
}

#' @rdname sample_input
#'
#' @param n integer. The number of samples to draw. Defaults to 1.
#'
#' @export
sample_input.turbineInput <- function(input, ..., n = 1) {

  for (col in names(input)){
    input[[col]] <- sample_input(input[[col]], ..., n = n)
  }
  
  return(input)
}


#' @rdname sample_input
#'
#' @export
sample_input.default <- function(input, ..., n = 1) {
  
  return(rep( input, n))
}

