# One bird, one turbine example

``` r
library(collision)

# for Band Comparison
library(stochLAB)

library(knitr)
```

### The set up

One of the key differences in this package and previous Band-based
models is the geometric calculation for the core probability of a
collision, given a bird is passing through the turbine zone.

The turbine is split into it’s static and dynamic components as
described in Smales et al. ([2013](#ref-Smales2013)). The static
component includes:

- the turbine tower, defined by the hub height (`hh`), and three
  diameters of the tower: the base diameter (`d_base`), the top diameter
  (`d_top`) and the diameter at the minimum rotor swept height
  (`d_rotormin`)
- the generator nacelle, defined by it’s maximum width
  (`max_width_nacelle`), length (`max_nac_l`) and height (`max_nac_h`)
- the hemi-spherical hub with the diameter defined by the width of the
  nacelle (`max_width_nacelle`)
- the rotor blades, defined by the blade length (`blade_length`), the
  chord of the blade at the widest point (`max_chord`) and at at its tip
  (thinnest point; `min_chord`), the thickness of the blade at it’s
  widest and thinnest point (`blade_thickness_wide` and
  `blade_thickness_narrow`), and the blade tilt (`tilt_deg`)

While the dynamic component is “the area swept by the leading edges of
rotor blades during the time that a bird would take to pass through the
rotor-swept zone” ([Smales et al. 2013](#ref-Smales2013)) which is
defined by the turbine hub and rotor parameters as well as the length
and speed of the bird (`bird_length` and `bird_speed`).

### A worked example - deterministic

To calculate the probability of collision (of one bird with one turbine)
will consider a bird with no avoidance behaviour, and compare the
`collision` approach to the basic Band approach, where flights at rotor
swept height are assumed to be uniformly distributed.

We’ve coded an internal function `collision:::p_collision_band` for
testing purposes (note the three colons - this function is just for
testing) but for the purposes of this vignette we will also use the
[`stochLAB::get_avg_prob_collision()`](https://rdrr.io/pkg/stochLAB/man/get_avg_prob_collision.html)
package.

Step one is to set up a turbine - here’s an example based basically on a
Vestas 90, set up using the `define_turbine` function:

``` r

str(v90_single) 
#> List of 17
#>  $ model_id              : chr "Vesta V90"
#>  $ blade_length          : num 44
#>  $ blade_thickness_narrow: num 0.07
#>  $ blade_thickness_wide  : num 2.6
#>  $ d_base                : num 4.15
#>  $ d_rotormin            : num 3.55
#>  $ d_top                 : num 2.55
#>  $ hh                    : num 65
#>  $ max_chord             : num 3.51
#>  $ min_chord             : num 0.39
#>  $ max_nac_h             : num 4.05
#>  $ max_nac_l             : num 13.2
#>  $ max_width_nacelle     : num 3.6
#>  $ rotor_diam            : num 91.6
#>  $ rpm                   : num 16.1
#>  $ tilt_deg              : num 6
#>  $ prop_operational      : num 0.98
#>  - attr(*, "class")= chr "turbineInput"
```

Now we need a bird (see `define_bird`)

``` r

str(wte)
#> List of 7
#>  $ species          : chr "Wedge-tailed Eagle"
#>  $ bird_length      : num 0.945
#>  $ bird_speed       : num 17
#>  $ prop_day         : num 0.5
#>  $ prop_year        : num 1
#>  $ avoidance_dynamic: num 0.9
#>  $ avoidance_static : num 1
#>  - attr(*, "class")= chr "birdInput"
```

### One bird one turbine

Our approach considers both the static ($P(C)_{s}$) and dynamic
components ($P(C)_{dyn}$)

Without avoidance, and isolated from the overall collision rate
calculation, the total probability of collision, given interaction is
the

$$P\left( C|I \right) = P\left( C|I \right)_{static} + P\left( C|I \right)_{dynamic}$$

because the two options are mutually exclusive.

Let’s calculate the collision probability for a Wedge-tailed Eagle and
the V90.

``` r

p_coll_static <- prob_collision_static(
  d_base = v90_single$d_base,
  d_rotormin = v90_single$d_rotormin,
  d_top = v90_single$d_top,
  hh = v90_single$hh,
  blade_length = v90_single$blade_length,
  max_nac_h = v90_single$max_nac_h,
  max_nac_l = v90_single$max_nac_l,
  max_width_nacelle = v90_single$max_width_nacelle,
  rotor_diam = v90_single$rotor_diam,
  tilt_deg = v90_single$tilt_deg,
  max_chord = v90_single$max_chord,
  min_chord = v90_single$min_chord,
  blade_thickness_wide = v90_single$blade_thickness_wide,
  blade_thickness_narrow = v90_single$blade_thickness_narrow,
  prop_at_height = 0.75,
  prop_below_height = 0.2
)

p_coll_dyn <- prob_collision_dynamic(
  rpm = v90_single$rpm, #s_rot,
  blade_length = v90_single$blade_length,
  max_width_nacelle = v90_single$max_width_nacelle,
  rotor_diam = v90_single$rotor_diam,
  blade_thickness_wide = v90_single$blade_thickness_wide,
  blade_thickness_narrow = v90_single$blade_thickness_narrow,
  hh = v90_single$hh,
  bird_length = wte$bird_length,
  bird_speed = wte$bird_speed,
  prop_at_height = 0.75,
  prop_below_height = 0.2
)

p_coll_dyn + p_coll_static
#> [1] 0.07960969
```

#### Hang on - what’s that `edr`?

Note we set our effective detection radius (`edr`) to half the rotor
diameter. Normally this parameter is calculated via distance sampling
([Buckland et al. 2001](#ref-Buckland2001)). As the effective detection
increases, this probability of collision given interaction also
decreases.

But don’t stress!

As the effective detection radius increases, this also influences the
flight density calculation. We will come back to this in a different
vignette. For now, we want to compare with Band (as far as possible) so
let’s use a default that’s the flux window associated with the turbine
itself.

#### Back to Business - whats’ Band say?

``` r

stochLAB::get_avg_prob_collision(
  flight_speed = wte$bird_speed, #m/s
  body_lt = wte$bird_length,
  wing_span = 2.12,
  prop_upwind = 0.5,
  flap_glide = 1,
  rotor_speed = v90_single$rpm  ,
  rotor_radius = v90_single$rotor_diam / 2.0,
  blade_width = v90_single$blade_thickness_wide,
  blade_pitch =  30 * pi / 180, #In radian
  n_blades = 3,
  chord_prof = chord_prof_5MW
)
#> [1] 0.09436917


# using the 2007 smaller profile from the spreadsheet
collision:::p_collision_band(
  max_chord = v90_single$blade_thickness_wide,
  pitch_deg = 30, 
  rotor_diam = v90_single$rotor_diam,
  rpm = v90_single$rpm,
  bird_length = wte$bird_length,
  bird_wing_span = 2.12,
  bird_flapping = 0,
  bird_speed = wte$bird_speed
)
#> [1] 0.09426788
```

------------------------------------------------------------------------

## References

Buckland, S., D. Anderson, K. Burnham, Jeffrey Laake, David Borchers,
and Len Thomas. 2001. *Introduction to Distance Sampling: Estimating
Abundance of Biological Populations*. Vol. xv. Oxford University Press.
<https://doi.org/10.1093/oso/9780198506492.001.0001>.

Smales, Ian, Stuart Muir, Charles Meredith, and Robert Baird. 2013. “A
Description of the Biosis Model to Assess Risk of Bird Collisions with
Wind Turbines.” *Wildlife Society Bulletin* 37 (1): 59–65.
<https://doi.org/10.1002/wsb.257>.
