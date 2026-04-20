#' lon lat to UTM
#' 
#' Equation from https://r.geocompx.org/reproj-geo-data#which-crs
#' 
#' 
lonlat_to_utm = function(lonlat) {
  
  utm = (floor((lonlat[1] + 180) / 6) %% 60) + 1
  if (lonlat[2] > 0) {
    utm + 32600
  } else{
    utm + 32700
  }
  
}