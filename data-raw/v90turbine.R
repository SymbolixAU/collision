## code to prepare `turbine` dataset goes here

v90_single <- define_turbine(
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
  prop_operational = 0.98
)



usethis::use_data(v90_single, overwrite = TRUE)


