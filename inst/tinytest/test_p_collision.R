stat_chk <- prob_collision_static(
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

dyn_chk <- prob_collision_dynamic(
  rpm = v90_single$rpm,
  blade_length = v90_single$blade_length,
  max_width_nacelle = v90_single$max_width_nacelle,
  rotor_diam = v90_single$rotor_diam,
  blade_thickness_wide = v90_single$blade_thickness_wide,
  blade_thickness_narrow = v90_single$blade_thickness_narrow,
  hh = v90_single$hh,
  bird_length = wte$bird_length,
  bird_speed = wte$bird_speed
)

expect_equal(stat_chk, 0.0323754, tolerance = 0.00001)
expect_equal(dyn_chk, 0.057672, tolerance = 0.00001)
