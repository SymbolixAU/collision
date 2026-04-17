library(sf)

df_turbines <- data.frame(
  turbine_id = c("T1", "T2", "T3"),
  lat = c(-35.036287, -35.03900, -35.03200),
  lon = c(145.947140, 145.94500, 145.94200)
)

crs = 4326
eff_detection_width <- 500
n_turbines <- nrow(df_turbines)

area_separate <- nrow(df_turbines)* pi*(eff_detection_width/2)^2


sf_turbines <- sf::st_as_sf(df_turbines, coords = c("lon", "lat"), crs = crs)

sf::st_is_longlat(sf_turbines)
projcrs <- lonlat_to_utm(sf::st_coordinates(sf_turbines))

sf_turbines <- st_transform(sf_turbines, crs = projcrs)

sf_turb_buffer <- sf::st_make_valid(
  sf::st_buffer(x = sf_turbines,
                dist = eff_detection_width/2,
                nQuadSegs = 360))

plot(sf_turb_buffer)

sf_turb_union <- sf::st_make_valid(sf::st_union(sf_turb_buffer))
plot(sf_turb_union)

turb_area <- units::drop_units(sf::st_area(sf_turb_union))

turb_area

# == version 2
sf_turb_intersect <- sf::st_make_valid(sf::st_intersection(sf_turb_buffer))
plot(sf_turb_intersect)

intersect_area <- units::drop_units(sf::st_area(sf_turb_intersect[sf_turb_intersect$n.overlaps > 1,]))

turb_area2 <- area_separate - intersect_area
turb_area2



sf::st_distance(sf_turbines)

str(sf_turbines)





#' lon lat to UTM
#' 
#' Equation from 
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


