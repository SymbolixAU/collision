# Convert observed flight flux to number of flights through turbine plane (i.e. interactions).

Convert observed flight flux to number of flights through turbine plane
(i.e. interactions).

## Usage

``` r
turbine_flights(obs_flux, rotor_diameter, hub_height)
```

## Arguments

- obs_flux:

  numeric; number of flights through one unit area of vertical space per
  unit time as output by
  [`obs_flux()`](https://symbolixau.github.io/collision/reference/obs_flux.md)
  or similar

- rotor_diameter:

  numeric; rotor diameter. Must be in the equivalent units to the unit
  area of `obs_flux` (i.e., if the `obs_flux` is per m\\^2\\,
  `rotor_diameter` must be in m).

- hub_height:

  numeric; hub height. Must be in the equivalent units to the unit area
  of `obs_flux` (i.e., if the `obs_flux` is per m\\^2\\, `hub_height`
  must be in m).

## Value

numeric; number of flights through turbine plane per unit time. The
turbine plane is a rectangle defined by the rotor diameter and tip
height of the turbine. Time interval is the same as referenced by
`obs_flux` input.

## Details

### Scale to turbine

`turbine_flights()` converts the flight flux through one unit area of
vertical space into the number of flights through an arbitrary vertical
plane of width equal to rotor diameter and height equal to the tip
height of the turbine.

The time interval is not adjusted (i.e. if you input flights / min, it
will output flights / min).

## See also

[`obs_flux()`](https://symbolixau.github.io/collision/reference/obs_flux.md)

## Examples

``` r
## A simple example of calculating flux from a point count and
## using this to generate the number of flights through a turbine 
## in a year
## 
## # Step by step
## 

df_obs <- data.frame(size = c(0, 2 , 3, 0), # four surveys
                     survey_duration = c(20, 20, 18, 20), # minutes
                     # Optional survey weights to deal with stratification etc
                     survey_weight = c(1,1,1,1))

rotor_diameter <- 300
hub_height <- 200
edr <- 800 # derive from distance model
mean_h <- 60 # derive from height distribution

# flights observed per minute of survey
flights_per_min <- encounter_rate(
  df_obs_summary = df_obs,
  wilson_correction = TRUE # Default
)

# observed flights through vertical plane of one metre squared in one minute
flights_per_m2_per_min <- obs_flux(
  encounter_rate = flights_per_min,
  eff_detection_width = 2*edr,
  mean_flight_height = mean_h
)

# scale to turbine width and height
flights_turbine_min <- turbine_flights(
  obs_flux = flights_per_m2_per_min,
  rotor_diameter = rotor_diameter,
  hub_height = hub_height
)

# scale to annual flights through area of rotor_diameter x turbine height 
flights_turbine_year <- flights_per_year(
  flights_per_time = flights_turbine_min,
  time_units = "min", # Default
  prop_day = 0.5,  #diurnal species
  prop_year = 1    # present all year
)

## Alternate calc using a wrapper function
## to go from observations to turbine flights per year
## 
flights_turbine_year2 <- turbine_flights_year(
  survey_type = "point", # only supported option currently
  encounter_rate = flights_per_min,
  time_units = "min",
  eff_detection_width = 2*edr,
  mean_flight_height = mean_h,
  rotor_diameter = rotor_diameter,
  hub_height = hub_height,
  prop_day = 0.5,  #diurnal species
  prop_year = 1   # present all year
)

#They are the same
flights_turbine_year
#> [1] 9219.05
flights_turbine_year2
#> [1] 9219.05
```
