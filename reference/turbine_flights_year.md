# Estimate flights through turbine plane from observations

This is a wrapper to calculate the observed flight flux and scale up to
a turbine and a year.

## Usage

``` r
turbine_flights_year(
  survey_type = c("point"),
  encounter_rate,
  time_units = "min",
  eff_detection_width,
  mean_flight_height,
  rotor_diameter,
  hub_height,
  prop_day,
  prop_year
)
```

## Arguments

- survey_type:

  character; type of survey. Currently just point transects but methods
  for line transects and digital areal surveys are in development.

- encounter_rate:

  numeric; number of flights observed per unit time of survey as output
  by
  [`encounter_rate()`](https://symbolixau.github.io/collision/reference/encounter_rate.md)
  or similar.

- time_units:

  Time units of `encounter_rate`. Defaults to "min" (i.e. flights per
  minute).

- eff_detection_width:

  numeric; Allows you to manually specify the effective detection width,
  which is usually 2 x effective detection radius. Must be in the same
  units as `mean_flight_height`.

- mean_flight_height:

  numeric; The mean of the distribution of the flight heights. Must be
  in the same units as `eff_detection_width`.

- rotor_diameter:

  numeric; rotor diameter. Must be in the equivalent units to the unit
  area of `obs_flux` (i.e., if the `obs_flux` is per m\\^2\\,
  `rotor_diameter` must be in m).

- hub_height:

  numeric; hub height. Must be in the equivalent units to the unit area
  of `obs_flux` (i.e., if the `obs_flux` is per m\\^2\\, `hub_height`
  must be in m).

- prop_day:

  numeric; number between 0 and 1 representing the proportion of a 24
  hour day the species is active onsite. Also refer to the details
  below.

- prop_year:

  numeric; number between 0 and 1 representing the proportion of a 12
  month year the species is active onsite. Also refer to the details
  below.

## Details

Calculating the number of flights through a turbine plane includes three
steps

- Calculate the observed flights in a vertical area from the count of
  observed flights and details of the surveys, e.g.
  [`obs_flux()`](https://symbolixau.github.io/collision/reference/obs_flux.md)

- Scale the observed flight flux to an area equivalent to the rotor
  diameter by the maximum height of the turbine, e.g.
  [`turbine_flights()`](https://symbolixau.github.io/collision/reference/turbine_flights.md)

- Scale the flights to the time period under study. There's a helper
  function to scale to one year,
  [`flights_per_year()`](https://symbolixau.github.io/collision/reference/flights_per_year.md)

### Observed flux from point counts

Given an encounter rate
([`encounter_rate()`](https://symbolixau.github.io/collision/reference/encounter_rate.md)),
a distribution of flight heights and a related distance model (fit using
the `Distance` package (Miller et al. 2019) ) we calculate the flight
flux through a rectangle with a width of 2\\\times\\(effective detection
radius) and a height of the 2\\\times\\mean (expected value) of the
height distribution in one unit of observation time.

Note the function accepts only single valued inputs, so stochastic
inputs must be sampled from prior to calling this function. For more
information, see
[`vignette("simple-simulation-example", package = "collision")`](https://symbolixau.github.io/collision/articles/simple-simulation-example.md).

### Scale to turbine

[`turbine_flights()`](https://symbolixau.github.io/collision/reference/turbine_flights.md)
converts the flight flux through one unit area of vertical space into
the number of flights through an arbitrary vertical plane of width equal
to rotor diameter and height equal to the tip height of the turbine.

The time interval is not adjusted (i.e. if you input flights / min, it
will output flights / min).

### Scale to year

After obtaining the observed flux through a vertical area in one unit
time, we need to scale up to the relevant risk timeframe, often a year.

This can be done manually by the analyst for any time period, but we
have included a helper function for the case of scaling to one year
([`flights_per_year()`](https://symbolixau.github.io/collision/reference/flights_per_year.md)).
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

## References

Miller DL, Rexstad E, Thomas L, Marshall L, Laake JL (2019). “Distance
Sampling in R.” *Journal of Statistical Software*, **89**, 1–28. ISSN
1548-7660,
[doi:10.18637/jss.v089.i01](https://doi.org/10.18637/jss.v089.i01) .

## See also

[`flights_per_year()`](https://symbolixau.github.io/collision/reference/flights_per_year.md),
[`turbine_flights()`](https://symbolixau.github.io/collision/reference/turbine_flights.md),
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
