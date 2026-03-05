# Probability of collision with static turbine

Probability of collision calculated as the ratio of the sum of static
presented areas to the total airspace of rotor diameter and rotor swept
height.

## Usage

``` r
prob_collision_static(
  d_base,
  d_rotormin,
  d_top,
  hh,
  blade_length,
  max_nac_h,
  max_nac_l,
  max_width_nacelle,
  rotor_diam,
  tilt_deg,
  max_chord,
  min_chord,
  blade_thickness_wide,
  blade_thickness_narrow,
  prop_at_height,
  prop_below_height
)
```

## Arguments

- d_base:

  diameter of tower at base

- d_rotormin:

  diameter of tower at base of rotor

- d_top:

  diameter of tower at top

- hh:

  hub height

- blade_length:

  blade length

- max_nac_h:

  max nacelle height (side view)

- max_nac_l:

  max nacelle length (side view)

- max_width_nacelle:

  nacelle room width (back view)

- rotor_diam:

  rotor diameter (m)

- tilt_deg:

  Blade tilt in degrees

- max_chord:

  the chord of the blade at its widest point

- min_chord:

  the chord of the blade at its tip (thinnest point)

- blade_thickness_wide:

  the thickness of the blade (side on) at its widest point

- blade_thickness_narrow:

  the thickness of the blade (side on) at its thinnest point

- prop_at_height:

  proportion of flights at rotor swept height

- prop_below_height:

  proportion of flights below rotor swept height

## Value

numeric; probability of collision with static turbine. Range from 0 to 1

## Details

Presented areas are the sum of static components, where static
components are the tower below rotor height, tower above rotor height,
rotor and nacelle/nosecone

## Examples

``` r

# all in metres
prob_collision_static(
 d_base = 5.0,
 d_rotormin = 3.5,
 d_top = 3,
 hh = 10,
 blade_length = 60,
 max_nac_h = 4,
 max_nac_l = 13,
 max_width_nacelle = 4,
 rotor_diam = 124,
 tilt_deg = 6,
 max_chord = 3.5,
 min_chord = 0.4,
 blade_thickness_wide = 2.5,
 blade_thickness_narrow = 0.1,
 prop_at_height = 0.5,
 prop_below_height = 0.2
)
#> [1] 0.03803627


```
