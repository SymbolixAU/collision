#' Vertical flux plane area
#'
#' The probability of collision given interaction requires the calculation of a
#' vertical flux window through which flights occur.  The width is 2x the
#' effective detection radius and the height is the max. height of the turbine
#'
#' @param hh hub height (m)
#' @param rotor_diam rotor diameter (m)
#'
#' @return area of plane of flight in m^2
#'
#' @examples
#'
#' vertical_flux_plane_area(
#'   hh = 150,
#'   rotor_diam = 210
#' )
#'
#' @export
vertical_flux_plane_area <- function(
  hh,
  rotor_diam
) {
  check_num_bounds(hh, min = 0)
  check_num_bounds(rotor_diam, min = 0)
  rotor_diam * (hh + 0.5 * rotor_diam)
}


#' Probability of collision with static turbine
#'
#' Probability of collision calculated as the ratio of the sum of static presented
#' areas to the total airspace of rotor diameter and rotor swept height.
#'
#' @details
#' Presented areas are the sum of static  components, where
#'  static components are the tower below rotor height, tower above rotor height,
#'  rotor and nacelle/nosecone
#'
#' @param d_base diameter of tower at base
#' @param d_rotormin diameter of tower at base of rotor
#' @param d_top diameter of tower at top
#' @param hh hub height
#' @param blade_length blade length
#' @param max_nac_h  max nacelle length (side view)
#' @param max_nac_l  max nacelle height (side view)
#' @param max_width_nacelle nacelle room width (back view)
#' @param rotor_diam rotor diameter (m)
#' @param tilt_deg Blade tilt in degrees
#' @param max_chord the chord of the blade at its widest point
#' @param min_chord the chord of the blade at its tip (thinnest point)
#' @param blade_thickness_wide the thickness of the blade (side on) at its widest point
#' @param blade_thickness_narrow the thickness of the blade (side on) at its thinnest point
#' @param prop_at_height proportion of flights at rotor swept height
#' @param prop_below_height proportion of flights below rotor swept height
#'
#' @return numeric; probability of collision with static turbine.
#'         Range from 0 to 1
#'
#' @examples
#'
#'
#' # all in metres
#' prob_collision_static(
#'  d_base = 5.0,
#'  d_rotormin = 3.5,
#'  d_top = 3,
#'  hh = 10,
#'  blade_length = 60,
#'  max_nac_h = 4,
#'  max_nac_l = 13,
#'  max_width_nacelle = 4,
#'  rotor_diam = 124,
#'  tilt_deg = 6,
#'  max_chord = 3.5,
#'  min_chord = 0.4,
#'  blade_thickness_wide = 2.5,
#'  blade_thickness_narrow = 0.1,
#'  prop_at_height = 0.5,
#'  prop_below_height = 0.2
#' )
#'
#'
#'
#' @export
#'
prob_collision_static <- function(
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
) {
  stopifnot(
    "prop_at_height and prop_below_height should be numeric" = is.numeric(
      prop_at_height
    ) &&
      is.numeric(prop_below_height)
  )

  check_num_bounds(x = prop_at_height + prop_below_height, min = 0, max = 1)
  turbine_plane_area <- vertical_flux_plane_area(hh = hh,
                                              rotor_diam = rotor_diam)
  
  presented_area <- prop_at_height*(
    
    pa_towerabove(d_top, d_rotormin, blade_length) +
      pa_nacelle(max_nac_h, max_nac_l,max_width_nacelle) +
      pa_rotor(tilt_deg, max_chord, min_chord,
               blade_thickness_wide, blade_thickness_narrow,
               blade_length)
  ) +
    prop_below_height * (
      pa_below( d_base, d_rotormin, hh-0.5*max_nac_h, blade_length)
    )
  
  presented_area <- presented_area/(prop_at_height+prop_below_height)
  
  return(presented_area/turbine_plane_area)

}


#' Probability of collision with leading edge of blade
#'
#' @param rpm rotor speed (RPM)
#' @param blade_length blade length
#' @param max_width_nacelle "Maximum W and Hub Dia (m)" diam of nosecone == nacelle room width (back view)
#' @param rotor_diam rotor diameter (m)
#' @param blade_thickness_wide the thickness of the blade (side on) at its widest point
#' @param blade_thickness_narrow the thickness of the blade (side on) at its thinnest point
#' @param hh hub height
#' @param bird_length Length of archetype bird (metres)
#' @param bird_speed numeric; Average flight speed (m/sec)
#' @param prop_at_height proportion of flights at rotor swept height
#' @param prop_below_height proportion of flights below rotor swept height
#'
#' @return numeric; probability of collision with leading edge of blade.
#'         Range from 0 to 1
#'
#' @examples
#' # example code
#' prob_collision_dynamic(
#'  rpm = 15,
#'  blade_length = 60,
#'  max_width_nacelle = 4,
#'  rotor_diam = 124,
#'  blade_thickness_wide = 2.5,
#'  blade_thickness_narrow = 0.1,
#'  hh = 10,
#'  bird_length = 0.9,
#'  bird_speed = 12,
#'  prop_at_height = 0.5,
#'  prop_below_height = 0.2
#' )
#'
#'
#' @export
prob_collision_dynamic <- function(
  rpm, #s_rot,
  blade_length,
  max_width_nacelle,
  rotor_diam,
  blade_thickness_wide,
  blade_thickness_narrow,
  hh,
  bird_length,
  bird_speed,
  prop_at_height,
  prop_below_height
) {
  
  stopifnot(
    "prop_at_height and prop_below_height should be numeric" = is.numeric(
      prop_at_height
    ) &&
      is.numeric(prop_below_height)
  )
  

  check_num_bounds(x = prop_at_height + prop_below_height, min = 0, max = 1)

  turbine_plane_area <- vertical_flux_plane_area(hh = hh,
                                              rotor_diam = rotor_diam)

  presented_area <- pa_dynamic(
    s_rot = rpm_to_radpersec(rpm),
    max_width_nacelle = max_width_nacelle,
    blade_length = blade_length,
    blade_thickness_wide = blade_thickness_wide,
    blade_thickness_narrow = blade_thickness_narrow,
    rotor_diam = rotor_diam,
    bird_length = bird_length,
    bird_speed = bird_speed
  )
  
  presented_area <- presented_area * prop_at_height /
    (prop_at_height+prop_below_height)
  
  return(presented_area/turbine_plane_area)
}