
## A simple example of calculating flux from a point count and
## using this to generate the number of flights through a turbine 
## in a year
## 
## # Step by step
## 

df_obs <- data.frame(size = c(0, 2 , 3, 0), # four surveys
                     survey_duration = c(20, 20, 18, 20),
                     # Optional survey weights to deal with stratification etc
                     survey_weight = c(1,1,1,1))

prop_below_turbine_max <- 1
rotor_diameter <- 300
hub_height <- 200
edr <- 800
edh <- hub_height+0.5*rotor_diameter # can set to turbine height since all flights below turbine max

# flights observed per minute of survey
flights_per_min <- encounter_rate(
  df_obs <- df_obs,
  survey_units = "min", # Default
  wilson_correction = TRUE # Default
)

# flights through vertical plane of one metre squared in one minute
flights_per_m2_per_min <- obs_flux(
  encounter_rate = flights_per_min,
  eff_detection_width = edr,
  eff_detection_height = edh,
  width_units = "m", # Default
  height_units = "m" # Default
)

# scale to turbine width and height
flights_turbine_min <- turbine_flux(
  obs_flux = flights_per_m2_per_min,
  rotor_diameter = rotor_diameter,
  hub_height = hub_height,
  prop_below_turbine_max = prop_below_turbine_max
)

# scale to annual flights through area of rotor_diameter x turbine height 
flights_turbine_year <- flux_per_year(
  flux_per_min = flights_turbine_min,
  prop_day = 0.5,  #diurnal species
  prop_year = 1    # present all year
)

## Alternate calc using a wrapper function
## to go from observations to turbine flights per year
## 
flights_turbine_year2 <- turbine_flux_year(
  survey_type = "point", # only supported option currently
  encounter_rate = flights_per_min,
  eff_detection_width = edr,
  eff_detection_height = edh,
  rotor_diameter = rotor_diameter,
  hub_height = hub_height,
  prop_below_turbine_max = prop_below_turbine_max,
  prop_day = 0.5,  #diurnal species
  prop_year = 1,   # present all year
  width_units = "m", # Default
  height_units = "m" # Default
)

#They are the same
flights_turbine_year
flights_turbine_year2
