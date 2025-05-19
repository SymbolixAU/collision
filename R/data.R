#' Single turbine example data
#' 
#' A example of class `turbineInput` containing example turbine dimensions
#' based off a Vestas V90 example. This version has all fixed (i.e. no stochastic)
#' input values and is useful for vignettes and tests
#' 
#' @format
#' A object of class 'list' and custom class 'turbineInput':
#'
#' @details Created with [define_turbine()]
#' 
"v90_single"


#' Wedge-tailed Eagle data
#' 
#' A non-stochastic example of bird data for vignettes and testing
#' Based off the Australian / Tasmanian Wedge-tailed Eagle
#' 
#' @format A object of class 'list' and custom class 'birdInput'
#' 
#' @details
#' Created with [define_bird()]
#' 
"wte"

#' 
#' An object of class \code{dsmodel} fit using \code{Distance::ds}
#' The example model is fit to the data \code{book.tee.data} from \code{mrds}
#'
#' #' @docType data
#'
#' @usage ds_example
#' 
"ds_example"

#' Example survey and observation
#' 
#' Combined data set of survey and observations that mimic point count 
#' observations of raptors. Used for examples and to construct \code{ds_raptor}
#' 
#' #' @docType data
#' 
#' @usage df_obs_survey
#' 
"df_obs_survey"

#' Distance model example - raptor
#'
#' An object of class \code{dsmodel} fit using \code{Distance::ds}
#' The example model is fit to the data \code{df_obs_survey} from this package
#'
#' #' @docType data
#' 
#' @usage ds_raptor
#' 
#' 
"ds_raptor"

#' Example activity rate
#' 
#' Example output from \code{collision::activity_rate_distcorr} using the example survey, observation and raptor data. Used for examples vignetts
#' 
#' #' @docType data
#' 
#' @usage activity_rate_raptor
#' 
"activity_rate_raptor"