#' Correct for turbine clusters
#' 
#' The construction of the CRM requires that the flight flux through the observed 
#' window be scaled to the size of a turbine and then applied to each turbine. If 
#' If the (effective) detection range of the observer overlaps multiple turbines
#' the flux needs to be scaled appropriate over the turbines in the observation
#' range.
#' 
#' @details
#' If the turbine layout is more compact and/or your effective detection width is large, then the effective detection area contains more than one turbine. 
#' The observed flux needs to be weighted to account for the effective turbines 
#' in the observed area. This accounts for the fact that the observed flux is an instantaneous measure and cannot interact with multiple turbinesat once.
#' 
#' This correction is derived from different assumptions but fulfils a similar model correction as the \code{sqrt(n_turbines)} in 
#' 
#' @param df_turbines data.frame; a data.frame with one row per turbine, 
#'    containing the coordinates of each turbine in WGS 84
#' @param eff_detection_width numeric; the effective detection width,
#'    which is usually 2 x effective detection radius.
#'    
#' @return numeric; the cluster correction factor - the average number
#'    of turbines per EDA (effective detection area).
#'
#' @importFrom sf st_as_sf st_buffer st_make_valid st_union st_area
#' @importFrom units drop_units
#' @export
cluster_correction_a <- function(df_turbines, eff_detection_width){
  # df_turbines needs turbine ids and lat/lon
  # lat column can be "lat", "latitude" or "y" (any case)
  # lon column can be "lon", "long", "longitude" or "x" (any case)
  # currently have it requiring WGS 84 but might be better to add a CRS input?
  # 
  # 
  # 
  # 
  
  stopifnot(
    "df_turbines must be a data.frame" =
      is.data.frame(df_turbines)
  )
  stopifnot(
    "df_turbines must have at least one row" =
      nrow(df_turbines) >= 1
  )
  
  EDA <- pi*(eff_detection_width/2)^2
  n_turbines <- nrow(df_turbines)
  
  lon_col <- names(df_turbines)[tolower(names(df_turbines)) %in% c("lon",
                                                                   "longitude",
                                                                   "long",
                                                                   "x",
                                                                   "easting",
                                                                   "northing")]
  
  lat_col <- names(df_turbines)[tolower(names(df_turbines)) %in% c("lat",
                                                                   "latitude",
                                                                   "y",
                                                                   "easting",
                                                                   "northing")]
  
  stopifnot(
    "df_turbines must contain a longitude column named lon, long, longitude, or x" =
      length(lon_col) >= 1
  )
  stopifnot(
    "df_turbines must contain a latitude column named lat, latitude, or y" =
      length(lat_col) >= 1
  )
  
  if (length(lon_col) > 1) {
    warning(
      "multiple possible longitude columns detected: ",
      paste(lon_col, collapse = ", "),
      ". Using the first match: ", lon_col[1]
    )
    lon_col <- lon_col[1]
  }
  if (length(lat_col) > 1) {
    warning(
      "multiple possible latitude columns detected: ",
      paste(lat_col, collapse = ", "),
      ". Using the first match: ", lat_col[1]
    )
    lat_col <- lat_col[1]
  }
  
  stopifnot(
    "NA values detected in longitude column" =
      !any(is.na(df_turbines[[lon_col]]))
  )
  stopifnot(
    "NA values detected in latitude column" =
      !any(is.na(df_turbines[[lat_col]]))
  )
  
  stopifnot(
    "longitude values appear out of WGS 84 range (-180 to 180)" =
      all(df_turbines[[lon_col]] >= -180 & df_turbines[[lon_col]] <= 180)
  )
  stopifnot(
    "latitude values appear out of WGS 84 range (-90 to 90)" =
      all(df_turbines[[lat_col]] >= -90 & df_turbines[[lat_col]] <= 90)
  )
  
  stopifnot(
    "eff_detection_width must be a single numeric value" =
      is.numeric(eff_detection_width) && length(eff_detection_width) == 1
  )
  stopifnot(
    "eff_detection_width must be greater than 0" =
      eff_detection_width > 0
  )
  stopifnot(
    "NA detected in eff_detection_width" =
      !is.na(eff_detection_width)
  )
  
  sf_turb <- sf::st_as_sf(df_turbines, coords = c(lon_col, lat_col), crs = 4326)

  sf_turb_buffer <- sf::st_make_valid(
    sf::st_buffer(x = sf_turb,
                  dist = eff_detection_width/2))
  
  sf_turb_union <- sf::st_make_valid(sf::st_union(sf_turb_buffer))
  
  turb_area <- units::drop_units(sf::st_area(sf_turb_union))
  
  turbine_prob <- round(turb_area/(n_turbines*EDA), 16) # number of turbines that flux is effectively spread across
  # rounding because sf sometimes has float issues
  
  # may need to add a check to ensure it's always <= 1? I kind of can't think of 
  # a way that could happen but I think this function needs some testing to see
  # if you can break it in that way
  
  return(turbine_prob)
}


#' Correct for turbine distance (offshore)
#' 
#' TODO description
#' 
#' @details
#' TODO
#' 
#' @param avg_min_distance numeric; the average distance between each turbine and its nearest neighbour
#' @param eff_detection_width numeric; the effective detection width,
#'    which is usually 2 x effective detection radius.
#'    
#' @return numeric; the (linear) cluster correction factor - the average number 
#'    of turbines per ESW (effective strip width).
#'    
#' @export
cluster_correction_l <- function(avg_min_distance, eff_detection_width){
  # I think this is literally it?
  # TODO: I would like to have the option to input df_turbines here and have it calculate the avg min distance
  # but I think that requires better knowledge of R to do in a relatively speedy way
  # ES suggested spatialdatatable::dtHaversine?
  
  stopifnot(
    "avg_min_distance must be a single numeric value" =
      is.numeric(avg_min_distance) && length(avg_min_distance) == 1
  )
  stopifnot(
    "NA detected in avg_min_distance" =
      !is.na(avg_min_distance)
  )
  stopifnot(
    "avg_min_distance must be greater than 0" =
      avg_min_distance > 0
  )
  
  stopifnot(
    "eff_detection_width must be a single numeric value" =
      is.numeric(eff_detection_width) && length(eff_detection_width) == 1
  )
  stopifnot(
    "NA detected in eff_detection_width" =
      !is.na(eff_detection_width)
  )
  stopifnot(
    "eff_detection_width must be greater than 0" =
      eff_detection_width > 0
  )
  
  return(eff_detection_width/avg_min_distance)
}
