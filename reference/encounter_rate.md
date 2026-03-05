# Calculate uncorrected observed flights / minute of survey from point transects

This function converts observed flights (movements) and survey duration
into the "encounter rate" per minute of survey. This value is
uncorrected for the observer's effective detection radius.

## Usage

``` r
encounter_rate(df_obs_summary, wilson_correction = TRUE)
```

## Arguments

- df_obs_summary:

  data.frame; a data.frame with one row per survey containing at least
  columns `size` and `survey_duration` where `size` is the total number
  of individuals observed in each survey and `survey_duration` is the
  duration of each survey. It can also optionally include a column
  `survey_weight` if needed to account for stratification etc. The sum
  of the survey weights must equal the total number of surveys (to avoid
  artificially inflating or deflating the survey effort). When NULL (the
  default) will weight surveys equally.

- wilson_correction:

  boolean; Apply wilson correction (Wilson 1927) if there are no
  observations. Defaults to TRUE.

## Value

numeric; number of flights observed in one unit time of survey. If the
Wilson correction was used it will return the (approximate) mid-point of
the 95% confidence interval (see
<https://en.wikipedia.org/wiki/Binomial_proportion_confidence_interval#Wilson_score_interval>).

## References

Wilson EB (1927). “Probable Inference, the Law of Succession, and
Statistical Inference.” *Journal of the American Statistical
Association*, **22**(158), 209–212.
[doi:10.1080/01621459.1927.10502953](https://doi.org/10.1080/01621459.1927.10502953)
, <https://www.jstor.org/stable/2276774>.

## See also

[`turbine_flights()`](https://symbolixau.github.io/collision/reference/turbine_flights.md)
and
[`flights_per_year()`](https://symbolixau.github.io/collision/reference/flights_per_year.md)
for methods to expand the observer flux into flights through the turbine
plane

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
