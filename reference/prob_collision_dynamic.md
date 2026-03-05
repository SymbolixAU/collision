# Probability of collision with leading edge of blade

Probability of collision with leading edge of blade

## Usage

``` r
prob_collision_dynamic(
  rpm,
  blade_length,
  max_width_nacelle,
  rotor_diam,
  blade_thickness_wide,
  blade_thickness_narrow,
  hh,
  bird_length,
  bird_speed,
  prop_at_height,
  prop_below_height
)
```

## Arguments

- rpm:

  rotor speed (RPM)

- blade_length:

  blade length

- max_width_nacelle:

  "Maximum W and Hub Dia (m)" diam of nosecone == nacelle room width
  (back view)

- rotor_diam:

  rotor diameter (m)

- blade_thickness_wide:

  the thickness of the blade (side on) at its widest point

- blade_thickness_narrow:

  the thickness of the blade (side on) at its thinnest point

- hh:

  hub height

- bird_length:

  Length of archetype bird (metres)

- bird_speed:

  numeric; Average flight speed (m/sec)

- prop_at_height:

  proportion of flights at rotor swept height

- prop_below_height:

  proportion of flights below rotor swept height

## Value

numeric; probability of collision with leading edge of blade. Range from
0 to 1

## Examples

``` r
# example code
prob_collision_dynamic(
 rpm = 15,
 blade_length = 60,
 max_width_nacelle = 4,
 rotor_diam = 124,
 blade_thickness_wide = 2.5,
 blade_thickness_narrow = 0.1,
 hh = 10,
 bird_length = 0.9,
 bird_speed = 12,
 prop_at_height = 0.5,
 prop_below_height = 0.2
)
#> [1] 0.1064567

```
