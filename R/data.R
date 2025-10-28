#' Single turbine example data
#' 
#' An object of class `turbineInput` containing example turbine dimensions
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
#' An object of class `dsmodel` fit using `Distance::ds`
#' The example model is fit to the data `book.tee.data` from `mrds`
#'
#' #' @docType data
#'
#' @usage ds_example
#' 
"ds_example"

#' Example observations
#' 
#' Data set of observations (with corresponding survey_ids) that mimic point count 
#' observations of raptors. Used for examples and to construct `ds_raptor`
#' 
#' #' @docType data
#' 
#' @usage df_obs
#' 
"df_obs"

#' Example survey
#' 
#' Data set of survey metadata that mimic point count 
#' surveys for raptors. Used for examples.
#' 
#' #' @docType data
#' 
#' @usage df_survey
#' 
"df_survey"

#' Distance model example - raptor
#'
#' An object of class `dsmodel` fit using `Distance::ds`
#' The example model is fit to the data `df_obs_survey` from this package
#'
#' #' @docType data
#' 
#' @usage ds_raptor
#' 
#' 
"ds_raptor"
