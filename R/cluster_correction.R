#' Correct for turbine clusters
#' 
#' TODO description
#' 
#' @details
#' If the turbine layout is more compact and/or your EDR is large, then the 
#' effective detection area contains more than one turbine. 
#' The observed flux needs to be weighted to account for the effective turbines 
#' in the observed area. This accounts for the fact that an observed flight can 
#' only interact with one turbine at any given time. TODO
#' 
#' @param df_turbines data.frame; a data.frame with one row per turbine, 
#'    containing the coordinates of each turbine in WGS 84
#' @param eff_detection_width numeric; the effective detection width,
#'    which is usually 2 x effective detection radius.
#'    
#' @return numeric; the cluster correction factor - the average number 
#'    of turbines per EDA (effective detection area).
#'    
#' @export
cluster_correction_a <- function(df_turbines, eff_detection_width){
  # df_turbines needs turbine ids and lat/lon
  # lat column can be "lat", "latitude" or "y" (any case)
  # lon column can be "lon", "long", "longitude" or "x" (any case)
  # currently have it requiring WGS 84 but might be better to add a CRS input?
  
  # TODO (low priority) I think this needs to be optimised better - it's kinda 
  # slow when doing it in a loop in the stochastic example 
  # to do it mathematically this is a good reference 
  # https://stackoverflow.com/questions/1667310/combined-area-of-overlapping-circles
  # but I don't want to spend my day on that rn
  
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
  return(eff_detection_width/avg_min_distance)
}
