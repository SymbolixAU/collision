## distance_helpers
## functions to help manipulate the outputs of the R package
## Distance for use in flight flux and CRM calculations

#' extract data from distance model
#'
#' Helper functions to extract data from a distance model object
#'
#'
#' @param ds_model an object of class `dsmodel` fit using `Distance::ds`
#'
#' @examples
#'
#' summary(ds_example) # example data
#' w_from_distmodel(ds_example) # extract truncation parameter, w
#' edr_from_distmodel(ds_example) # extract effective detection radius
#'
#' @references
#' Miller DL, Rexstad E, Thomas L, Marshall L, Laake JL (2019).
#' "Distance Sampling in R." Journal of Statistical Software,
#' 89(1), 1–28. doi: 10.18637/jss.v089.i01.
#'
#' @import Distance
#' @name data_from_distmodel
NULL

#' @rdname data_from_distmodel
#' @export
w_from_distmodel <- function(ds_model) {
  if (!inherits(ds_model, "dsmodel")) stop("`dsmodel` object required")
  ds_model$ddf$meta.data$int.range[2]
}

#' @rdname data_from_distmodel
#' @export
edr_from_distmodel <- function(ds_model) {
  if (!inherits(ds_model, "dsmodel")) stop("`dsmodel` object required")
  sqrt(unique(ds_model$ddf$fitted)) * w_from_distmodel(ds_model)
}
