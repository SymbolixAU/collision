# vertical_flux_plane_area------------
## Function returns correct values for given inputs--------
expect_equal(vertical_flux_plane_area(hh = 150, rotor_diam = 210)
             , 210 * (150 + 0.5 * 210))

## Throws error when hh and/or rotor_diam are NA/not numeric-----
expect_error(vertical_flux_plane_area(hh = NA, rotor_diam = 210)
             , "Numeric input expected")
expect_error(vertical_flux_plane_area(hh = 150, rotor_diam = "10")
             , "Numeric input expected")

## Throws error when hh and/or rotor_diam is a negative value-------
expect_error(vertical_flux_plane_area(hh = -210, rotor_diam = 210)
             , "variable out of bounds")
expect_error(vertical_flux_plane_area(hh = 150, rotor_diam = -150)
             , "variable out of bounds")

# prob_collision_static--------------
## Function returns correct values for given inputs-----------
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

expect_equal(stat_chk, 0.0340794, tolerance = 0.00001)

## Throws error when prop_at_height and/or prop_below_height are NA/not numeric-----
expect_error(
  prob_collision_static(
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
    prop_at_height = "0.75",
    prop_below_height = 0.2
  ),
  "prop_at_height and prop_below_height should be numeric"
)

expect_error(
  prob_collision_static(
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
    prop_below_height = "0.2"
  ),
  "prop_at_height and prop_below_height should be numeric"
)

## Prop at height and prop below height should add up to a value between 0 and 1-----
expect_error(
  prob_collision_static(
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
    prop_at_height = 1.75,
    prop_below_height = 0.2
  ),
  "variable out of bounds"
)

# I am not going to check for the rest of the parameters because they are all passed
# into functions which are tested separately

# prob_collision_dynamic

## Function returns correct values for given inputs-----------

dyn_chk <- prob_collision_dynamic(
  rpm = v90_single$rpm,
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

expect_equal(dyn_chk, 0.045530, tolerance = 0.00001)

## Throws error when prop_at_height and/or prop_below_height are NA/not numeric-----
expect_error(
  prob_collision_dynamic(
    rpm = v90_single$rpm,
    blade_length = v90_single$blade_length,
    max_width_nacelle = v90_single$max_width_nacelle,
    rotor_diam = v90_single$rotor_diam,
    blade_thickness_wide = v90_single$blade_thickness_wide,
    blade_thickness_narrow = v90_single$blade_thickness_narrow,
    hh = v90_single$hh,
    bird_length = wte$bird_length,
    bird_speed = wte$bird_speed,
    prop_at_height = '0.75',
    prop_below_height = 0.2
  ),
  "prop_at_height and prop_below_height should be numeric"
)

expect_error(
  prob_collision_dynamic(
    rpm = v90_single$rpm,
    blade_length = v90_single$blade_length,
    max_width_nacelle = v90_single$max_width_nacelle,
    rotor_diam = v90_single$rotor_diam,
    blade_thickness_wide = v90_single$blade_thickness_wide,
    blade_thickness_narrow = v90_single$blade_thickness_narrow,
    hh = v90_single$hh,
    bird_length = wte$bird_length,
    bird_speed = wte$bird_speed,
    prop_at_height = 0.75,
    prop_below_height = '0.2'
  ),
  "prop_at_height and prop_below_height should be numeric"
)

## Prop at height and prop below height should add up to a value between 0 and 1-----
expect_error(
  prob_collision_dynamic(
    rpm = v90_single$rpm,
    blade_length = v90_single$blade_length,
    max_width_nacelle = v90_single$max_width_nacelle,
    rotor_diam = v90_single$rotor_diam,
    blade_thickness_wide = v90_single$blade_thickness_wide,
    blade_thickness_narrow = v90_single$blade_thickness_narrow,
    hh = v90_single$hh,
    bird_length = wte$bird_length,
    bird_speed = wte$bird_speed,
    prop_at_height = 1.75,
    prop_below_height = 0.2
  ),
  "variable out of bounds"
)

# I am not going to check for the rest of the parameters because they are all passed
# into functions which are tested separately