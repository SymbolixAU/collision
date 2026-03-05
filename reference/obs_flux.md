# Calculate observed flights / time / area from point transects

This function converts the uncorrected encounter rate, the effective
detection radius (see for example Buckland et al. (2001) ) and the mean
flight height into an estimate of flight flux per unit time per unit
area of vertical airspace (Smales et al. 2013) .

## Usage

``` r
obs_flux(encounter_rate, eff_detection_width, mean_flight_height)
```

## Arguments

- encounter_rate:

  numeric; number of flights observed per unit time of survey as output
  by
  [`encounter_rate()`](https://symbolixau.github.io/collision/reference/encounter_rate.md)
  or similar.

- eff_detection_width:

  numeric; Allows you to manually specify the effective detection width,
  which is usually 2 x effective detection radius. Must be in the same
  units as `mean_flight_height`.

- mean_flight_height:

  numeric; The mean of the distribution of the flight heights. Must be
  in the same units as `eff_detection_width`.

## Value

numeric; number of flights through a vertical plane of unit area per
unit time. Area units are defined by the units of the width and height,
and time interval is the same as referenced by `encounter_rate` input.

## Details

### Observed flux from point counts

Given an encounter rate
([`encounter_rate()`](https://symbolixau.github.io/collision/reference/encounter_rate.md)),
a distribution of flight heights and a related distance model (fit using
the `Distance` package (Miller et al. 2019) ) we calculate the flight
flux through a rectangle with a width of 2 x (effective detection
radius) and a height of the 2 x mean (expected value) of the height
distribution in one unit of observation time.

Note the function accepts only single valued inputs, so stochastic
inputs must be sampled from prior to calling this function. For more
information, see
[`vignette("simple-simulation-example", package = "collision")`](https://symbolixau.github.io/collision/articles/simple-simulation-example.md).

## References

Buckland S, Anderson D, Burnham K, Laake J, Borchers D, Thomas L (2001).
*Introduction to Distance Sampling: Estimating Abundance of Biological
Populations*, volume xv. Oxford University Press. ISBN
978-0-19-850649-2,
[doi:10.1093/oso/9780198506492.001.0001](https://doi.org/10.1093/oso/9780198506492.001.0001)
.  
  
Miller DL, Rexstad E, Thomas L, Marshall L, Laake JL (2019). “Distance
Sampling in R.” *Journal of Statistical Software*, **89**, 1–28. ISSN
1548-7660,
[doi:10.18637/jss.v089.i01](https://doi.org/10.18637/jss.v089.i01) .  
  
Smales I, Muir S, Meredith C, Baird R (2013). “A Description of the
Biosis Model to Assess Risk of Bird Collisions with Wind Turbines.”
*Wildlife Society Bulletin*, **37**(1), 59–65. ISSN 19385463,
[doi:10.1002/wsb.257](https://doi.org/10.1002/wsb.257) .

Buckland S, Anderson D, Burnham K, Laake J, Borchers D, Thomas L (2001).
*Introduction to Distance Sampling: Estimating Abundance of Biological
Populations*, volume xv. Oxford University Press. ISBN
978-0-19-850649-2,
[doi:10.1093/oso/9780198506492.001.0001](https://doi.org/10.1093/oso/9780198506492.001.0001)
.  
  
Miller DL, Rexstad E, Thomas L, Marshall L, Laake JL (2019). “Distance
Sampling in R.” *Journal of Statistical Software*, **89**, 1–28. ISSN
1548-7660,
[doi:10.18637/jss.v089.i01](https://doi.org/10.18637/jss.v089.i01) .  
  
Smales I, Muir S, Meredith C, Baird R (2013). “A Description of the
Biosis Model to Assess Risk of Bird Collisions with Wind Turbines.”
*Wildlife Society Bulletin*, **37**(1), 59–65. ISSN 19385463,
[doi:10.1002/wsb.257](https://doi.org/10.1002/wsb.257) .

## See also

[`encounter_rate()`](https://symbolixau.github.io/collision/reference/encounter_rate.md)

[`turbine_flights()`](https://symbolixau.github.io/collision/reference/turbine_flights.md)
and
[`flights_per_year()`](https://symbolixau.github.io/collision/reference/flights_per_year.md)
for methods to expand the observer flux into the flights through the
turbine plane

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
