
## A simple example of calculating flux from a point count and
## using this to generate the number of flights through a turbine 
## in a year
## 
## # Step by step
## 

obs_size <- c(0,2,3,0)
survey_duration <- c(20, 20, 18, 20)
edr <- 800
# Optional survey weights to deal with stratification etc
survey_weight = c(1,1,1,1)
prop_below_turbine_max <- 1
rotor_diameter = 300


# flights through vertical plane of one metre wide in one minute
flights_per_m_per_min <- flight_flux_point(
  obs_size = obs_size,
  survey_duration = survey_duration,
  eff_detection_width = edr,
  survey_units = "min",  # default
  width_units = "m",     # default
  survey_weight = survey_weight,
  wilson_correction = TRUE
)

# scale to turbine width and height
flights_turbine_min <- turbine_flux(
  obs_flux = flights_per_m_per_min,
  rotor_diameter = rotor_diameter,
  prop_below_turbine_max = prop_below_turbine_max
)


# scale to annual flights through area of rotor_diamter x turbine height 
flights_turbine_year <- flux_per_year(
  flux_per_min = flights_turbine_min,
  prop_day = 0.5,  #diurnal species
  prop_year = 1    # present all year
)

## Alternate calc using a wrapper function
## to go from observations to turbine flights per year
## 
flights_turbine_year2 <- turbine_flux_year(
  survey_type= "point",
  obs_size = obs_size,
  survey_duration = survey_duration,
  eff_detection_width = edr,
  rotor_diameter = rotor_diameter,
  prop_below_turbine_max = prop_below_turbine_max,
  prop_day = 0.5,  #diurnal species
  prop_year = 1,   # present all year
  survey_units = "min",
  width_units = "m",
  survey_weight = survey_weight,
  wilson_correction = TRUE
)

#They are the same
flights_turbine_year
flights_turbine_year2
