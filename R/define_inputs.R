#' make a list of bird parameters for input into CRM
#'
#' Makes a list of avian biological parameters for the bird(s) being modelled
#' as a function directly in R. This function is designed for R-based workflows.
#' A function define_bird_csv can be used to bulk upload parameters for
#' multiple birds.
#'
#' # Details
#'
#' Each input to this function must be either
#'
#'  - an object of the \code{class} \code{randInput}.
#'    See \link{set_random} for more information on setting
#'    up stochastic inputs.
#'  - a single number representing the average (preferably median) of the
#'    variable
#
#' @returns list where items define the value or stochastic distribution f
#'    or each parameter
#'
#' @param species char; species identifier
#' @param bird_length Length of archetype bird (metres), or distribution
#'    information using \link{set_random}
#' @param bird_speed numeric; Average flight speed (m/sec), or
#'                   distribution information using \link{set_random}
#' 
#' @examples
#' lst_bird <- define_bird(
#'   species = 'biggus raptorus',
#'   bird_length = set_random("rnorm", mean = 90, sd = 5), # (metres)
#'   bird_speed = set_random("rnorm", mean = 16.67, sd = 3) # m/s
#' )
#' 
#' @export
define_bird <- function(
    species,
    bird_length,
    bird_speed
) {
  
  sapply( 
    list(bird_length,
         bird_speed), 
    check_input_class 
  )
  
  l <- list(
    species = species,
    bird_length = bird_length,
    bird_speed = bird_speed
  )
  
  class(l) <- "birdInput"
  return(l)
}



#' define_turbine
#' 
#' make a list of turbine parameters for input into the default CRM
#'
#' Makes a list of parameters for the a given turbine
#'
#' # Details
#'
#' Each input to this function must be either
#'
#'  - an object of the \code{class} \code{randInput}.
#' See \link{set_random} for more information on setting
#' up stochastic inputs.
#'  - a single number representing the average (preferably median) of the
#' variable
#'
#'
#' @returns list where items define the value or stochastic distribution for
#' each parameter
#'
#' @param model_id character; Label for turbine model - allows the user to 
#'define multiple turbine types on a site
#' @param blade_length blade length (m)
#' @param blade_thickness_narrow the thickness of the blade (side on) at its thinnest point (m)
#' @param blade_thickness_wide the thickness of the blade (side on) at its widest point (m)
#' @param d_base diameter of tower at base (m)
#' @param d_rotormin diameter of tower at base of rotor (m)
#' @param d_top diameter of tower at top (m)
#' @param hh hub height (m)
#' @param max_chord the chord of the blade at its widest point (m)
#' @param min_chord the chord of the blade at its tip (thinnest point) (m)
#' @param max_nac_h max nacelle length (side view) (m)
#' @param max_nac_l  max nacelle height (side view) (m)
#' @param max_width_nacelle diam of nosecone == nacelle room width (back view) (m)
#' @param rotor_diam if unspecified, defaults to 2*blade_length + max_width_nacelle (m)
#' @param rpm rotational speed of turbine  (rpm)
#' @param tilt_deg Blade tilt in degrees
#' @param prop_operational numeric; Proportion of a 24 hour day that turbines
#' are operational. A single number or distribution information using 
#' \link{set_random}. Default 1
#'
#' @examples
#' 
#' lst_turbine <- define_turbine(
#'   model_id = "Vesta V90",
#'   blade_length = 44 ,
#'   blade_thickness_narrow = 0.07,
#'   blade_thickness_wide = 2.6,
#'   d_base = 4.15,
#'   d_rotormin = 3.55,
#'   d_top = 2.55,
#'   hh = 65,
#'   max_chord = 3.51,
#'   min_chord = 0.39,
#'   max_nac_h = 4.05,
#'   max_nac_l = 13.25,
#'   max_width_nacelle = 3.6,
#'   rpm = 16.1,
#'   rotor_diam = NULL,
#'   tilt_deg = 6,
#'   prop_operational = set_random("runif", min = 0.96, max = 0.99)
#' )
#' 
#' @export
define_turbine <- function(
    model_id,
    blade_length,
    blade_thickness_narrow,
    blade_thickness_wide,
    d_base,
    d_rotormin,
    d_top,
    hh,
    max_chord,
    min_chord,
    max_nac_h,
    max_nac_l,
    max_width_nacelle,
    rotor_diam = NULL,
    rpm, #s_rot,
    tilt_deg,
    prop_operational = 1) {
  
 
  # check class - leave value checks to sampling functions
  sapply( 
    list( blade_length,
          blade_thickness_narrow,
          blade_thickness_wide,
          d_base,
          d_rotormin,
          d_top,
          hh,
          max_chord,
          min_chord,
          max_nac_h,
          max_nac_l,
          max_width_nacelle,
          rpm, #s_rot,
          tilt_deg,
          prop_operational), 
    check_input_class 
  )
  
  if(is.null(rotor_diam)) rotor_diam <- 2 * blade_length + max_width_nacelle
  check_input_class(rotor_diam)
  
  
  l <- list(
    model_id = model_id,
    blade_length = blade_length,
    blade_thickness_narrow = blade_thickness_narrow,
    blade_thickness_wide = blade_thickness_wide,
    d_base = d_base,
    d_rotormin = d_rotormin,
    d_top = d_top,
    hh = hh,
    max_chord = max_chord,
    min_chord = min_chord,
    max_nac_h = max_nac_h ,
    max_nac_l = max_nac_l,
    max_width_nacelle = max_width_nacelle,
    rotor_diam = rotor_diam,
    rpm = rpm,
    tilt_deg = tilt_deg,
    prop_operational = prop_operational
  )

  
  class(l) <- "turbineInput"
  return(l)
}
