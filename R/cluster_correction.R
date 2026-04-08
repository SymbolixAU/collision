#' Correct for turbine clusters
#' 
#' TODO description
#' 
#' @details
#' TODO
#' 
#' @param df_turbines data.frame; a data.frame with one row per turbine, 
#'    containing the coordinates of each turbine in WGS 84
#' @param eff_detection_width numeric; the effective detection width,
#'    which is usually 2 x effective detection radius.
#'    
#' @return numeric; the cluster correction factor, which is the average number 
#'    of turbines per EDA (effective detection area)
#'    
#' @export
cluster_correction_a <- function(df_turbines, eff_detection_width){
  # df_turbines needs turbine ids and lat/lon
  # lat column can be "lat", "latitude" or "y"
  # lon column can be "lon", "long", "longitude" or "x"
  # currently have it requiring WGS 84 but might be better to add a CRS input?
  
  EDA <- pi*(eff_detection_width/2)^2
  n_turbines <- nrow(df_turbines)
  
  lon_col <- names(df_turbines)[tolower(names(df_turbines)) %in% c("lon",
                                                                   "longitude",
                                                                   "long",
                                                                   "x")]
  
  lat_col <- names(df_turbines)[tolower(names(df_turbines)) %in% c("lat",
                                                                   "latitude",
                                                                   "y")]
  
  sf_turb <- sf::st_as_sf(df_turbines, coords = c(lon_col, lat_col), crs = 4326)

  
  sf_turb_buffer <- sf::st_make_valid(
    sf::st_buffer(x = sf_turb,
                  dist = eff_detection_width/2))
  
  sf_turb_union <- sf::st_union(sf_turb_buffer)
  
  turb_area <- units::drop_units(sf::st_area(sf_turb_union))
  
  eff_turbines <- round(n_turbines*EDA/turb_area, 16) # number of turbines that flux is effectively spread across
  
  # might need to add a check to make sure it's >=1?
  
  return(eff_turbines)
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
#' @return numeric; the cluster correction factor, which is the average number 
#'    of turbines per ESW (effective strip width)
#'    
#' @export
cluster_correction_l <- function(avg_min_distance, eff_detection_width){
  # I think this is literally it?
  return(eff_detection_width/avg_min_distance)
}
