
# Test set random --------------------------------------------------------------

## Test structure of inputs
res <- set_random("runif", min = 0, max = 10) 
expect_inherits(res, "randInput")
expect_true(is.randInput(res))

expect_equal(res$distr, "runif")
expect_equal(res$params$min, 0)
expect_equal(res$params$max, 10)

## Test checks
expect_error(
  set_random(distr = "rando", min = 0, max = 1, badparam = 100),
  "Unknown distribution rando"
)

expect_error(
  set_random(distr = "runif", min = 0, max = 1, badparam = 100),
  "You've named a parameter that doesn't exist in runif"
)

expect_warning( 
    set_random(distr = "punif", min = 0, max = 1)
    )


# Test sample ------------------------------------------------------------------

## default  ----
expect_equal( sample_input(10), sample_input(10))
expect_equal(sample_input(1, n = 10), rep(1, 10))

## RandomInput ----
### Test one sample
var1 <- set_random("rbeta", shape1 = 1, shape2 = 3, ncp = 0)
set.seed(123)
expect_equal(round(sample_input(var1), 3), 0.037)

### Test multiple samples
expect_equal(length(sample_input(var1, n = 10)), 10)


## BirdInput ----
wte <- define_bird(
  species = "Wedge-tailed Eagle",
  bird_length = set_random("rnorm", mean = 0.945, sd = 0.2),
  bird_speed = set_random("runif", min = 7, max = 17),
  prop_day = set_random("runif", min = 0.45, max = 0.55),
  prop_year = 1,
  avoidance_dynamic = set_random("runif", min = 0.9, max = 0.93),
  avoidance_static = 0.9999
)

expect_equal(round(mean(sample_input(wte, n = 50)$bird_length), 2), 0.95)

## TurbineInput ----
v90_single <- define_turbine(
  model_id = "Vesta V90",
  blade_length = 44,
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
  rpm = set_random("runif", min = 12.1, max = 18.1),
  rotor_diam = NULL,
  tilt_deg = 6,
  prop_operational = 0.98
)

expect_equal(round(mean(sample_input(v90_single, n = 50)$rpm), 2), 15.04)
