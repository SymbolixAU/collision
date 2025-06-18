#' Rotate areas
#' 
#' Rotate shape through 180 degrees. Internal function
#' 
#' @param front area of front-view in metres squared
#' @param side area of side-view in metres squared
#' 
#' @return numeric
#' 
#' @examples
#' \dontrun{
#' rotate_areas(1,2)
#' }
#' 
rotate_areas <- function(front, side){
  
  if(any(front <= 0, side <= 0)) stop("Areas must be greater than zero")
  
  theta <- 0:179 * pi / 180 
  #units(theta) <- "radians"
  #stopifnot(units(front) == units(side))
  
  area_i <- 
    sapply(
      theta, FUN = function(x){
        abs(front * cos(x)) + abs(side * sin(x))
      })
  
  # Sum areas and put units back on
  #area <- units::keep_units(FUN = sum, x = area_i, unit = units(front))
  
  area <- sum(area_i)
  
  #return(area / 179)
  return(area / 180) # changed SCM 20241001
  
}


#' Presented area below
#' 
#' Presented area below the rotormin height. Internal function
#' 
#' @param d_base diameter of tower at base
#' @param d_rotormin diameter of tower at base of rotor
#' @param hh hub height
#' @param blade_length blade length
#' @noRd
pa_below <- function(d_base, d_rotormin, hh, blade_length){
  
  return(0.5 * (d_base + d_rotormin) * (hh - blade_length))
  
}

#' Presented area of tower above
#' 
#' presented area of tower above the rotor min. Internal function
#' 
#' @param d_top diameter of the tower at the top of the tower
#' @param d_rotormin diameter of tower at base of rotor
#' @param blade_length blade length
#' @noRd
pa_towerabove <- function(d_top, d_rotormin, blade_length){
  
  return(0.5 * (d_top + d_rotormin) * blade_length)
  
}


#' Presented area of the hub
#' 
#' Presented area of the nosecone
#' 
#' @param max_width_nacelle "Maximum W and Hub Dia (m)" diam of nosecone == nacelle room width (back view)
#' @noRd
pa_hub <- function(max_width_nacelle){
  
  return(0.125 * pi * max_width_nacelle**2)
  
}

#' Nacelle presented area
#' 
#' presented area of the nacelle. Internal function
#' 
#' @param max_nac_h  max nacelle length (side view) (m)
#' @param max_nac_l  max nacelle height (side view) (m)
#' @param max_width_nacelle  diameter of nosecone == nacelle room width (back view) (m)
#' @noRd
pa_nacelle <- function(max_nac_h, max_nac_l, max_width_nacelle){
  
  return( rotate_areas(
    front = max_nac_l * max_nac_h,
    side = max_width_nacelle * max_nac_h + pa_hub(max_width_nacelle)
    # front = max_width_nacelle* max_nac_h,
    # side = max_nac_l * max_nac_h + pa_hub(max_width_nacelle)
  ))
  
}

#' presented area rotor
#' 
#' Presented area of the rotor. Internal function
#' 
#' @param tilt_deg Blade tilt in degrees
#' @param max_chord the chord of the blade at its widest point
#' @param min_chord the chord of the blade at its tip (thinnest point)
#' @param blade_thickness_wide the thickness of the blade (side on) at its widest point
#' @param blade_thickness_narrow the thickness of the blade (side on) at its thinnest point
#' @param blade_length blade length
#' 
#' @details
#' the chord params define the blade normal to its direction of sweep (i.e. face on )  and thickness refers to the side on view 
#' @noRd
pa_rotor <- function(tilt_deg, max_chord, min_chord, 
                     blade_thickness_wide, blade_thickness_narrow, 
                     blade_length){
  
#  tilt_rad <- tilt_deg |> units::set_units("rad")
  tilt_rad <- tilt_deg * pi / 180
  
  pa_blade_normal <- abs( cos(tilt_rad) ) * blade_length *
    0.5 * (max_chord + min_chord)
  
  pa_blade_oblique <- blade_length * 
    0.5*(blade_thickness_wide + blade_thickness_narrow)
  
  return(rotate_areas(front = 3.*pa_blade_normal,
                      side = 2.*pa_blade_oblique))
  
}

#' effective blade thickness
#' 
#' Using the complete, two-planed rotor shape (flattened taper for convenience), 
#' integrated fully
#' 
#' @param max_width_nacelle (B19)  "Maximum W and Hub Dia (m)" diam of nosecone == nacelle room width (back view)
#' @param blade_length (B32) blade length
#' @param blade_thickness_wide (B35) the thickness of the blade (side on) at its widest point
#' @param blade_thickness_narrow (B36the thickness of the blade (side on) at its thinnest point
#' @param rotor_diam if unspecified, defaults to 2*blade_length + max_width_nacelle
#' @noRd
eff_blade_thickness <- function(max_width_nacelle, 
                                blade_length, 
                                blade_thickness_wide, 
                                blade_thickness_narrow,
                                rotor_diam = NULL
){
  
  if(is.null(rotor_diam)) rotor_diam <- 2 * blade_length + max_width_nacelle
  
  eff_swept_volume <- 2.* pi * (
    
    (1./6.)*(
      (blade_thickness_narrow - blade_thickness_wide) /
        (blade_length - 0.5*max_width_nacelle) *
        (
          2*(blade_length**3) + 0.25*(max_width_nacelle**3) -
            1.5*max_width_nacelle*(blade_length**2)
        )
      # (1./6.)*
      #   (blade_thickness_narrow - blade_thickness_wide) / 
      #   (blade_length) * 
      #   (
      #     2*(blade_length**3) + 0.25*(max_width_nacelle**3) - 
      #       1.5*max_width_nacelle*(blade_length**2)
      #   )
      
    ) + 
      0.5 * blade_thickness_wide * 
      ((blade_length**2) - 0.25 * (max_width_nacelle**2))
  )
  
  rsa <- 0.25 * pi * (rotor_diam**2)
  
  return(eff_swept_volume / rsa)
  
  
}

#' Bird transit time  in sec
#' 
#' @param max_width_nacelle (B19)  "Maximum W and Hub Dia (m)" diam of nosecone == nacelle room width (back view)
#' @param blade_length (B32) blade length
#' @param blade_thickness_wide (B35) the thickness of the blade (side on) at its widest point
#' @param blade_thickness_narrow (B36the thickness of the blade (side on) at its thinnest point
#' @param rotor_diam if unspecified, defaults to 2*blade_length + max_width_nacelle
#' @param bird_length Length of bird in m
#' @param bird_speed bird flight speed in m/s
#' @noRd
bird_transit_sec <- function(max_width_nacelle, 
                             blade_length, 
                             blade_thickness_wide, 
                             blade_thickness_narrow,
                             rotor_diam,
                             bird_length,
                             bird_speed
){
  
  if(is.null(rotor_diam)) rotor_diam <- 2 * blade_length + max_width_nacelle
  
  transit_length_m <- eff_blade_thickness(max_width_nacelle, 
                                          blade_length, 
                                          blade_thickness_wide, 
                                          blade_thickness_narrow,
                                          rotor_diam)
  
  return( (transit_length_m + 2.*bird_length) / bird_speed )
  
}




#' Swept Area
#' 
#' Effective presented area of moving edge of blade. Equivalent to the 
#' area swept by the leading edge of (three) blades in the time it takes a 
#' bird to transit the blade width
#' 
#' @param s_rot rotational speed (radians/second)
#' @param max_width_nacelle (B19)  "Maximum W and Hub Dia (m)" diam of nosecone == nacelle room width (back view)
#' @param blade_length (B32) blade length
#' @param blade_thickness_wide (B35) the thickness of the blade (side on) at its widest point
#' @param blade_thickness_narrow (B36the thickness of the blade (side on) at its thinnest point
#' @param bird_length Length of bird in m
#' @param bird_speed bird flight speed in m/s
#' @noRd
pa_dynamic <- function(s_rot, 
                       max_width_nacelle, 
                       blade_length, 
                       blade_thickness_wide, 
                       blade_thickness_narrow,
                       rotor_diam,
                       bird_length,
                       bird_speed){
  
  if(is.null(rotor_diam)) rotor_diam <- 2 * blade_length + max_width_nacelle
  
  n_blades <- 3.0
  
  transit_length_m <- eff_blade_thickness(max_width_nacelle, 
                                          blade_length, 
                                          blade_thickness_wide, 
                                          blade_thickness_narrow,
                                          rotor_diam) 
  
  
  bird_transit_sec <-  (transit_length_m + 2.*bird_length) / bird_speed 
  
  
  rotor_swept_areapsec <- 0.125 * n_blades * s_rot * rotor_diam**2
  
  swept_area_transit <- rotor_swept_areapsec * bird_transit_sec
  
  swept_area_transit <- min(swept_area_transit, 0.25*pi*rotor_diam^2)
  
  
  return(rotate_areas(swept_area_transit, 
                      side = transit_length_m*(blade_length*1.5))
  )
  
}

