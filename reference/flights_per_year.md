# Convert flights per minute to flights per year

A small helper function to expand flights per minute to flights per year
accounting for the time active.

## Usage

``` r
flights_per_year(flights_per_time, time_units = "min", prop_day, prop_year)
```

## Arguments

- flights_per_time:

  numeric; number of flights through a vertical area in one unit time.

- time_units:

  Time units of `flights_per_time`. Defaults to "min" (i.e. flights per
  minute).

- prop_day:

  numeric; number between 0 and 1 representing the proportion of a 24
  hour day the species is active onsite. Also refer to the details
  above.

- prop_year:

  numeric; number between 0 and 1 representing the proportion of a 12
  month year the species is active onsite. Also refer to the details
  above.

## Details

### Scale to year

After obtaining the observed flux through a vertical area in one unit
time, we need to scale up to the relevant risk timeframe, often a year.

This can be done manually by the analyst for any time period, but we
have included a helper function for the case of scaling to one year.
Note this function assumes the flux is the average flight flux when
active onsite. If surveys are conducted year round and the flux
represents the annual average then `prop_year` should be 1. If surveys
are conducted only while the bird is on site and the flux represents the
average over the period the birds are on site then `prop_year` should be
the proportion of the year that the bird is on site. For example, if a
bird is onsite for three months of the year and the flux was measured in
that season only, the `prop_year = 3/12 = 0.25`.

Similarly care must be taken if the daily observation window does not
overlap completely with the birds activity. If the flight flux
calculation includes times when the species is not active the `prop_day`
should be adjusted to account for this, or the flux calculated only
using surveys during the activity period.

## See also

[`obs_flux()`](https://symbolixau.github.io/collision/reference/obs_flux.md),
[`turbine_flights()`](https://symbolixau.github.io/collision/reference/turbine_flights.md)

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
