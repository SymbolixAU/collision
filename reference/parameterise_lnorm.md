# Given a mean and standard deviation, solves for log normal distribution parameters meanlog and sdlog.

Given a mean and standard deviation, solves for log normal distribution
parameters meanlog and sdlog.

## Usage

``` r
parameterise_lnorm(mean, sd)
```

## Arguments

- mean:

  the mean

- sd:

  the standard deviation

## Value

`list` object with the mean and standard deviation of the distribution
on the log scale. These are the `rlnorm` parameters `meanlog` and
`sdlog` used in the
[`stats::rlnorm()`](https://rdrr.io/r/stats/Lognormal.html) function

## See also

[`stats::rlnorm()`](https://rdrr.io/r/stats/Lognormal.html)

## Examples

``` r
log_rate <- parameterise_lnorm(mean = 0.002, sd = 0.0001)

flight_flux_min <- set_random("rlnorm", 
                            meanlog = log_rate$mean, 
                            sdlog = log_rate$sd)
sample_input(flight_flux_min)
#> [1] 0.001969485
```
