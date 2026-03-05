# Probability of collision given interaction from Band

Uses Band 2012 option 1. Simple implementation and internal function for
testing and verification only

## Usage

``` r
p_collision_band(
  max_chord,
  pitch_deg,
  rotor_diam,
  rpm,
  bird_length,
  bird_wing_span,
  bird_flapping,
  bird_speed
)
```

## Arguments

- max_chord:

  numeric; Maximum width of the turbine blade (metres). Must be a static
  value

- pitch_deg:

  numeric; Pitch of the turbine blades (degrees). Must be a static value

- rotor_diam:

  numeric; The length from turbine blade tip to blade tip (metres). Must
  be a static value

- rpm:

  Rotation speed (RPM).

- bird_length:

  numeric; Length of archetype bird (metres). Must be a static value

- bird_wing_span:

  numeric; Wingspan of archetype bird (metres). Must be a static value

- bird_flapping:

  numeric; 0 = bird_flapping, 1 = Soaring. Must be a static value

- bird_speed:

  numeric; Average flight speed (m/sec). Must be a static value

## Value

numeric; Number between 0 and 1 representing the probability of
collision given interaction

## Details

Calculate probability of collision given interaction

This function calculates the probability of collision of a single flight
with a single turbine, given that the flight has interacted with the
turbine (i.e. \\P(C\|I)\\).  
Formerly called `fun_bandWTG`.

Relies on the size and speed parameters for the bird and chosen turbine
model provided as a list.The list can be produced using
`make_lst_band()`.

Uses Band Collision Risk Model (see Band 2007 / Band 2012) and is a
direct reproduction of the publicly available Excel spreadsheet models.

## Examples

``` r
if (FALSE) { # \dontrun{
p_collision <- p_collision_band(
  max_chord = 3.51,
  pitch_deg = 20, 
  rotor_diam = 91.6,
  rpm = 16.1,
  bird_length = 1.1,
  wing_span = 2.0,
  flapping = 0,
  bird_speed = 6
)
} # }


```
