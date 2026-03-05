# Vertical flux plane area

The probability of collision given interaction requires the calculation
of a vertical flux window through which flights occur. The width is 2x
the effective detection radius and the height is the max. height of the
turbine

## Usage

``` r
vertical_flux_plane_area(hh, rotor_diam)
```

## Arguments

- hh:

  hub height (m)

- rotor_diam:

  rotor diameter (m)

## Value

area of plane of flight in m^2

## Examples

``` r
vertical_flux_plane_area(
  hh = 150,
  rotor_diam = 210
)
#> [1] 53550
```
