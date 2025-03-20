## test class failure
## 

set.seed(123)

expect_error(
  define_bird(bird_length = "long", 
              bird_speed=20),
  'Class must be one of "RandInput", "numeric"'
)
expect_error(
  define_turbine(model_id = "Vesta V90",
                 blade_length = "44" ,
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
                 prop_operational = set_random("runif", min = 0.96, max = 0.99)),
  'Class must be one of "RandInput", "numeric"'
)


lst_chk <- define_bird(
  species = 'test',
  bird_length = set_random("runif", min = 1, max = 2.3), # (metres)
  bird_speed = 16.67 # Ave
)

lst_samp <- lapply(lst_chk, sample_input)

expect_identical(
  lst_chk,
  structure(
    list(
      species = 'test',
      bird_length = structure(
        list(distr = "runif", 
             params = list(min = 1, max = 2.3)
        ), class = "randInput"
      ), 
      bird_speed = 16.67
    ), class = "birdInput")
)

expect_equal(lst_samp$bird_length, 1.373851, tolerance = 0.00001)

rm(lst_chk, lst_samp)


## test turbine definition

lst_chk <- define_turbine(
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


expect_identical(
  lst_chk,
  structure(
    list(model_id = "Vesta V90", 
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
             params = list(min = 0.96, max = 0.99)), class = "randInput")), 
    class = "turbineInput"
    )
)


lst_samp <- lapply(lst_chk, sample_input)
expect_equal(lst_samp$prop_operational, 0.9836492, tolerance = 0.00001)

