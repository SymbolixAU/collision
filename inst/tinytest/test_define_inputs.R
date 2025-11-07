## test class failure
##

set.seed(123)
# define_bird---------------
## Species--------------
expect_error(
  define_bird(
    species = 123,
    bird_length = 1,
    bird_speed = 20,
    prop_day = 1,
    prop_year = 1,
    avoidance_dynamic = 0.9,
    avoidance_static = 0.99
  ),
  'Species must be of type character'
)
## Bird length-------------------
expect_error(
  define_bird(
    species = "test",
    bird_length = "long",
    bird_speed = 20,
    prop_day = 1,
    prop_year = 1,
    avoidance_dynamic = 0.9,
    avoidance_static = 0.99
  ),
  'Class must be one of "RandInput", "numeric", "list"'
)

## Bird speed-------------------
expect_error(
  define_bird(
    species = "test",
    bird_length = 10,
    bird_speed = "wrongval",
    prop_day = 1,
    prop_year = 1,
    avoidance_dynamic = 0.9,
    avoidance_static = 0.99
  ),
  'Class must be one of "RandInput", "numeric", "list"'
)

## Prop Day-------------------
expect_error(
  define_bird(
    species = "test",
    bird_length = 10,
    bird_speed = 1,
    prop_day = 'wrongval',
    prop_year = 1,
    avoidance_dynamic = 0.9,
    avoidance_static = 0.99
  ),
  'Class must be one of "RandInput", "numeric", "list"'
)
## Prop Year-------------------
expect_error(
  define_bird(
    species = "test",
    bird_length = 10,
    bird_speed = 1,
    prop_day = 1,
    prop_year = "wrongval",
    avoidance_dynamic = 0.9,
    avoidance_static = 0.99
  ),
  'Class must be one of "RandInput", "numeric", "list"'
)
## avoidance dynamic-------------------
expect_error(
  define_bird(
    species = "test",
    bird_length = 10,
    bird_speed = 1,
    prop_day = 1,
    prop_year = 1,
    avoidance_dynamic = "0.9",
    avoidance_static = 0.99
  ),
  'Class must be one of "RandInput", "numeric", "list"'
)
## avoidance static-------------------
expect_error(
  define_bird(
    species = "test",
    bird_length = 10,
    bird_speed = 1,
    prop_day = 1,
    prop_year = 1,
    avoidance_dynamic = 0.9,
    avoidance_static = '0.99'
  ),
  'Class must be one of "RandInput", "numeric", "list"'
)

## Returns a birdInput----------
res <- define_bird(
  species = "test",
  bird_length = 10,
  bird_speed = 1,
  prop_day = 1,
  prop_year = 1,
  avoidance_dynamic = 0.9,
  avoidance_static = 0.99
)

expect_true(class(res) == "birdInput")

## Contains all values----------
expect_true(all(
  c(
    "species",
    "bird_length",
    "bird_speed",
    "prop_day",
    "prop_year",
    "avoidance_dynamic",
    "avoidance_static"
  ) %in%
    names(res)
))

## Check bird definition-----------
lst_chk <- define_bird(
  species = 'test',
  bird_length = set_random("runif", min = 1, max = 2.3), # (metres)
  bird_speed = 16.67, # Ave
  prop_day = 1,
  prop_year = 1,
  avoidance_dynamic = 0.9,
  avoidance_static = 0.99
)

lst_samp <- lapply(lst_chk, sample_input)

expect_identical(
  lst_chk,
  structure(
    list(
      species = 'test',
      bird_length = structure(
        list(distr = "runif", params = list(min = 1, max = 2.3)),
        class = "randInput"
      ),
      bird_speed = 16.67,
      prop_day = 1,
      prop_year = 1,
      avoidance_dynamic = 0.9,
      avoidance_static = 0.99
    ),
    class = "birdInput"
  )
)

expect_equal(lst_samp$bird_length, 1.373851, tolerance = 0.00001)

rm(lst_chk, lst_samp)

# Define Turbine----------------------
## model_id----------
expect_error(
  define_turbine(
    model_id = 123,
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
    rpm = 16.1,
    rotor_diam = NULL,
    tilt_deg = 6,
    prop_operational = set_random("runif", min = 0.96, max = 0.99)
  ),
  'model_id must be of type character'
)

## blade_length-------------
expect_error(
  define_turbine(
    model_id = "Vesta V90",
    blade_length = "44",
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
  ),
  'Class must be one of "RandInput", "numeric"'
)

## blade_thickness_narrow-------------
expect_error(
  define_turbine(
    model_id = "Vesta V90",
    blade_length = 44,
    blade_thickness_narrow = "0.07",
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
  ),
  'Class must be one of "RandInput", "numeric"'
)
## blade_thickness_wide-------------
expect_error(
  define_turbine(
    model_id = "Vesta V90",
    blade_length = 44,
    blade_thickness_narrow = 0.07,
    blade_thickness_wide = '2.6',
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
  ),
  'Class must be one of "RandInput", "numeric"'
)
## d_base-------------
expect_error(
  define_turbine(
    model_id = "Vesta V90",
    blade_length = 44,
    blade_thickness_narrow = 0.07,
    blade_thickness_wide = 2.6,
    d_base = '4.15',
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
  ),
  'Class must be one of "RandInput", "numeric"'
)
## d_rotormin-------------
expect_error(
  define_turbine(
    model_id = "Vesta V90",
    blade_length = 44,
    blade_thickness_narrow = 0.07,
    blade_thickness_wide = 2.6,
    d_base = 4.15,
    d_rotormin = '3.55',
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
  ),
  'Class must be one of "RandInput", "numeric"'
)
## d_top-------------
expect_error(
  define_turbine(
    model_id = "Vesta V90",
    blade_length = 44,
    blade_thickness_narrow = 0.07,
    blade_thickness_wide = 2.6,
    d_base = 4.15,
    d_rotormin = 3.55,
    d_top = "2.55",
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
  ),
  'Class must be one of "RandInput", "numeric"'
)
## hh-------------
expect_error(
  define_turbine(
    model_id = "Vesta V90",
    blade_length = 44,
    blade_thickness_narrow = 0.07,
    blade_thickness_wide = 2.6,
    d_base = 4.15,
    d_rotormin = 3.55,
    d_top = 2.55,
    hh = '65',
    max_chord = 3.51,
    min_chord = 0.39,
    max_nac_h = 4.05,
    max_nac_l = 13.25,
    max_width_nacelle = 3.6,
    rpm = 16.1,
    rotor_diam = NULL,
    tilt_deg = 6,
    prop_operational = set_random("runif", min = 0.96, max = 0.99)
  ),
  'Class must be one of "RandInput", "numeric"'
)
## max_chord-------------
expect_error(
  define_turbine(
    model_id = "Vesta V90",
    blade_length = 44,
    blade_thickness_narrow = 0.07,
    blade_thickness_wide = 2.6,
    d_base = 4.15,
    d_rotormin = 3.55,
    d_top = 2.55,
    hh = 65,
    max_chord = '3.51',
    min_chord = 0.39,
    max_nac_h = 4.05,
    max_nac_l = 13.25,
    max_width_nacelle = 3.6,
    rpm = 16.1,
    rotor_diam = NULL,
    tilt_deg = 6,
    prop_operational = set_random("runif", min = 0.96, max = 0.99)
  ),
  'Class must be one of "RandInput", "numeric"'
)
## min_chord-------------
expect_error(
  define_turbine(
    model_id = "Vesta V90",
    blade_length = 44,
    blade_thickness_narrow = 0.07,
    blade_thickness_wide = 2.6,
    d_base = 4.15,
    d_rotormin = 3.55,
    d_top = 2.55,
    hh = 65,
    max_chord = 3.51,
    min_chord = '0.39',
    max_nac_h = 4.05,
    max_nac_l = 13.25,
    max_width_nacelle = 3.6,
    rpm = 16.1,
    rotor_diam = NULL,
    tilt_deg = 6,
    prop_operational = set_random("runif", min = 0.96, max = 0.99)
  ),
  'Class must be one of "RandInput", "numeric"'
)
## max_nac_h-------------
expect_error(
  define_turbine(
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
    max_nac_h = '4.05',
    max_nac_l = 13.25,
    max_width_nacelle = 3.6,
    rpm = 16.1,
    rotor_diam = NULL,
    tilt_deg = 6,
    prop_operational = set_random("runif", min = 0.96, max = 0.99)
  ),
  'Class must be one of "RandInput", "numeric"'
)
## max_nac_l-------------
expect_error(
  define_turbine(
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
    max_nac_l = '13.25',
    max_width_nacelle = 3.6,
    rpm = 16.1,
    rotor_diam = NULL,
    tilt_deg = 6,
    prop_operational = set_random("runif", min = 0.96, max = 0.99)
  ),
  'Class must be one of "RandInput", "numeric"'
)
## rpm-------------
expect_error(
  define_turbine(
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
    rpm = '16.1',
    rotor_diam = NULL,
    tilt_deg = 6,
    prop_operational = set_random("runif", min = 0.96, max = 0.99)
  ),
  'Class must be one of "RandInput", "numeric"'
)
## rotor_diam-------------
expect_error(
  define_turbine(
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
    rpm = 16.1,
    rotor_diam = '100',
    tilt_deg = 6,
    prop_operational = set_random("runif", min = 0.96, max = 0.99)
  ),
  'Class must be one of "RandInput", "numeric"'
)
## tilt_deg-------------
expect_error(
  define_turbine(
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
    rpm = 16.1,
    rotor_diam = NULL,
    tilt_deg = '6',
    prop_operational = set_random("runif", min = 0.96, max = 0.99)
  ),
  'Class must be one of "RandInput", "numeric"'
)
## prop_operational-------------
expect_error(
  define_turbine(
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
    rpm = 16.1,
    rotor_diam = NULL,
    tilt_deg = 6,
    prop_operational = 'test'
  ),
  'Class must be one of "RandInput", "numeric"'
)

## Returns a turbineInput-----------
res <- define_turbine(
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
  rpm = 16.1,
  rotor_diam = NULL,
  tilt_deg = 6,
  prop_operational = set_random("runif", min = 0.96, max = 0.99)
)

expect_true(class(res) == "turbineInput")

## Contains all values-------------
expect_true(all(c("model_id", "blade_length", "blade_thickness_narrow", "blade_thickness_wide", 
                  "d_base", "d_rotormin", "d_top", "hh", "max_chord", "min_chord", 
                  "max_nac_h", "max_nac_l", "max_width_nacelle", "rotor_diam", 
                  "rpm", "tilt_deg", "prop_operational") %in% names(res)))

## test turbine definition-----------

lst_chk <- define_turbine(
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
  rpm = 16.1,
  rotor_diam = NULL,
  tilt_deg = 6,
  prop_operational = set_random("runif", min = 0.96, max = 0.99)
)


expect_identical(
  lst_chk,
  structure(
    list(
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
      rotor_diam = 91.6,
      rpm = 16.1,
      tilt_deg = 6,
      prop_operational = structure(
        list(
          distr = "runif",
          params = list(min = 0.96, max = 0.99)
        ),
        class = "randInput"
      )
    ),
    class = "turbineInput"
  )
)


lst_samp <- lapply(lst_chk, sample_input)
expect_equal(lst_samp$prop_operational, 0.9836492, tolerance = 0.00001)


## check internal data set has not got out of sync---------
v90_chk <- define_turbine(
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
  rpm = 16.1,
  rotor_diam = NULL,
  tilt_deg = 6,
  prop_operational = 0.98
)

expect_equal(v90_chk, v90_single)
