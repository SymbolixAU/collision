#' Vertical flux plane area 
#' 
#' The probability of collision given interaction requires the calculation of a
#' vertical flux window through which flights occur.  The width is 2x the 
#' effective detection radius and the height is the max. height of the turbine
#' 
#' @param edr effective detection radius (m)
#' @param hh hub height (m)
#' @param rotor_diam rotor diameter (m)
#'
#' @return area of plane of flight in m^2           
#' 
#' @examples 
#' 
#' vertical_flux_plane_area(
#'   edr = 500,
#'   hh = 150,
#'   rotor_diam = 210 
#' )
#'  
#' @export
vertical_flux_plane_area <- function( 
    edr,
    hh,
    rotor_diam
){

  2.0 * edr * (hh + 0.5*rotor_diam)
  
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
#' @param max_nac_h "Maximum L (m)"  max nacelle length (side view)
#' @param max_nac_l "Maximum H (m)"  max nacelle height (side view)
#' #' @param max_width_nacelle "Maximum W and Hub Dia (m)" diam of nosecone == nacelle room width (back view)
#' @param tilt_deg Blade tilt in degrees
#' @param max_chord the chord of the blade at its widest point
#' @param min_chord the chord of the blade at its tip (thinnest point)
#' @param blade_thickness_wide the thickness of the blade (side on) at its widest point
#' @param blade_thickness_narrow the thickness of the blade (side on) at its thinnest point
#' @param prop_at_height proportion of flights at height
#' @param prop_below_height proportion of flights below rotor height
#' @param edr effective detection radius (m)
#' 
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
    prop_below_height, 
    edr
){
  
  
  flux_plane_area <- vertical_flux_plane_area(edr = edr, hh = hh,
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
  
  
  return(presented_area/flux_plane_area)
}




#' Probability of collision with leading edge of blade
#' 
#' TODO
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
    edr
){
  
  # rotor_diam <- blade_to_diameter(blade_length=blade_length, 
  #                                     max_width_nacelle=max_width_nacelle)
  
  
  
  flux_plane_area <- vertical_flux_plane_area(edr = edr, hh = hh,
                                              rotor_diam = rotor_diam)
  
  presented_area <- pa_dynamic(
    s_rot = rpm_to_radpersec(rpm),
    max_width_nacelle = max_width_nacelle,
    blade_length = blade_length,
    blade_thickness_wide = blade_thickness_wide ,
    blade_thickness_narrow = blade_thickness_narrow ,
    rotor_diam = rotor_diam,
    bird_length = bird_length ,
    bird_speed = bird_speed
  )
  
  return(presented_area/flux_plane_area)
}


