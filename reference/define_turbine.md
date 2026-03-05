# define_turbine

make a list of turbine parameters for input into the default CRM

## Usage

``` r
define_turbine(
  model_id,
  blade_length,
  blade_thickness_narrow,
  blade_thickness_wide,
  d_base,
  d_rotormin,
  d_top,
  hh,
  max_chord,
  min_chord,
  max_nac_h,
  max_nac_l,
  max_width_nacelle,
  rotor_diam = NULL,
  rpm,
  tilt_deg,
  prop_operational = 1
)
```

## Arguments

- model_id:

  character; Label for turbine model - allows the user to define
  multiple turbine types on a site

- blade_length:

  blade length (m)

- blade_thickness_narrow:

  the thickness of the blade (side on) at its thinnest point (m)

- blade_thickness_wide:

  the thickness of the blade (side on) at its widest point (m)

- d_base:

  diameter of tower at base (m)

- d_rotormin:

  diameter of tower at base of rotor (m)

- d_top:

  diameter of tower at top (m)

- hh:

  hub height (m)

- max_chord:

  the chord of the blade at its widest point (m)

- min_chord:

  the chord of the blade at its tip (thinnest point) (m)

- max_nac_h:

  max nacelle height (side view) (m)

- max_nac_l:

  max nacelle length (side view) (m)

- max_width_nacelle:

  diam of nosecone == nacelle room width (back view) (m)

- rotor_diam:

  if unspecified, defaults to 2\*blade_length + max_width_nacelle (m)

- rpm:

  rotational speed of turbine (rpm)

- tilt_deg:

  Blade tilt in degrees

- prop_operational:

  numeric; Proportion of a 24 hour day that turbines are operational. A
  single number or distribution information using
  [set_random](https://symbolixau.github.io/collision/reference/set_random.md).
  Default 1

## Value

list where items define the value or stochastic distribution for each
parameter

## Details

Makes a list of parameters for the a given turbine

## Details

Each input to this function must be either

- an object of the `class` `randInput`. See
  [set_random](https://symbolixau.github.io/collision/reference/set_random.md)
  for more information on setting up stochastic inputs.

- a single number representing the average (preferably median) of the
  variable

## Examples

``` r
lst_turbine <- define_turbine(
  model_id = "Vesta V90",
  blade_length = 44 ,
  blade_thickness_narrow = 0.07,
  blade_thickness_wide = 2.6,
  d_base = 4.15,
  d_rotormin = 3.55,
  d_top = 2.55,
  hh = 65,
  max_chord = 3.51,
  min_chord = 0.39,
  max_nac_h = 4.05,
  max_nac_l = 13.25,
  max_width_nacelle = 3.6,
  rpm = 16.1,
  rotor_diam = NULL,
  tilt_deg = 6,
  prop_operational = set_random("runif", min = 0.96, max = 0.99)
)
```
