#' Probability of collision given interaction from Band
#'
#' Uses Band 2012 option 1. Simple implementation for testing and comparison.
#'
#' Calculate probability of collision given interaction
#'
#' @param max_chord numeric; Maximum width of the turbine blade (metres).
#' Must be a static value
#' @param pitch_deg numeric; Pitch of the turbine blades (degrees).
#' Must be a static value
#' @param rotor_diam numeric; The length from turbine blade tip to blade 
#' tip (metres). Must be a static value
#' @param rpm Rotation speed (RPM).
#' @param bird_length numeric; Length of archetype bird (metres). Must be a
#'                   static value
#' @param bird_wing_span numeric; Wingspan of archetype bird (metres).
#'                  Must be a static value
#' @param bird_flapping numeric; 0 = bird_flapping, 1 = Soaring.
#'                 Must be a static value
#' @param bird_speed numeric; Average flight speed (m/sec).
#'                   Must be a static value
#'
#' @details
#' This function calculates the probability of collision of a single
#' flight with a single turbine, given that the flight has
#' interacted with the turbine (i.e. \eqn{P(C|I)}). \cr
#' Formerly called \code{fun_bandWTG}.
#'
#' Relies on the size and speed parameters for the bird and chosen
#' turbine model provided as a list.The list can be
#' produced using \code{make_lst_band()}.
#'
#' Uses Band Collision Risk Model (see Band 2007 / Band 2012) and is
#' a direct reproduction of the publicly available Excel spreadsheet models.
#'
#' @return numeric; Number between 0 and 1 representing the probability
#' of collision given interaction
#' @examples
#'
#'
#' p_collision <- p_collision_band(
#'   max_chord = 3.51,
#'   pitch_deg = 20, 
#'   rotor_diam = 91.6,
#'   rpm = 16.1,
#'   bird_length = 1.1,
#'   wing_span = 2.0,
#'   flapping = 0,
#'   bird_speed = 6
#' )
#'
#'  p_collision_band(
#'            bird_speed = 13.1,
#'            bird_length = 0.85,
#'            wing_span = 1.01,
#'            #prop_upwind = 0.5,
#'            #flap_glide = 1,
#'            rpm = 15,
#'            rotor_diam = 120*2,
#'            max_chord = 5,
#'            blade_pitch = 15
#'         #   n_blades = 3,
#'          #  chord_prof = chord_prof_5MW
#'            )
#'
#'
#'
#' @export
p_collision_band <- function(
    max_chord,
    pitch_deg,
    rotor_diam,
    rpm,
    bird_length,
    bird_wing_span,
    bird_flapping,
    bird_speed) {
  
  
  
  # fix devtools::check errors
  contributionUp_i <- NULL
  r_i <- NULL
  pCollisionUp_i <- NULL
  contributionDown_i <- NULL
  pCollisionDown_i <- NULL
  
  
  # argnames <- names(match.call()[-1])
  # for(nm in argnames) if (length(get(nm)) != 1) stop(nm, " does not have length 1")
  # 
  
  # type check
  
  K <- 1 # 1D model
  no_blades <- 3 # because it is
  rotation_period <- 60./rpm
  

  bird_aspect_ratio <- bird_length / bird_wing_span
  pitch_rad <- pitch_deg * pi / 180
  flappingLogical <- ifelse(bird_flapping, 2 / pi, 1) 
  
  bird_aspect_ratio <- bird_length / bird_wing_span
  pitch_rad <- pitch_deg * pi / 180
  flappingLogical <- ifelse(bird_flapping, 2 / pi, 1)
  
  df_collision <- data.frame(r_i = seq(0.025, 0.975, 0.05))
  
  df_collision$chord_i <- ifelse(df_collision$r_i < 0.085, 0.575,
                                 ifelse(df_collision$r_i < 0.219,
                                        0.305 + 3.172 * df_collision$r_i,
                                        1.209 - 0.954 * df_collision$r_i
                                 )
  )
  
  df_collision$a_i <- bird_speed * rotation_period /
    (df_collision$r_i * 2 * pi * (rotor_diam / 2))
  
  df_collision$colLenUp_i <- K * abs(
    max_chord * df_collision$chord_i * sin(pitch_rad) +
      (df_collision$a_i * max_chord * df_collision$chord_i * cos(pitch_rad))
  ) +
    ifelse(
      df_collision$a_i < bird_aspect_ratio,
      bird_length,
      flappingLogical * bird_wing_span * df_collision$a_i
    )
  
  df_collision$colLenDown_i <- K * abs(
    -max_chord * df_collision$chord_i * sin(pitch_rad) +
      (df_collision$a_i * max_chord * df_collision$chord_i * cos(pitch_rad))
  ) +
    ifelse(df_collision$a_i < bird_aspect_ratio,
           bird_length,
           flappingLogical * bird_wing_span * df_collision$a_i
    )
  
  df_collision$pCollisionUp_i <- ifelse(
    (no_blades / rotation_period) * df_collision$colLenUp_i / bird_speed > 1,
    1,
    (no_blades / rotation_period) * df_collision$colLenUp_i / bird_speed
  )
  
  df_collision$pCollisionDown_i <- ifelse(
    (no_blades / rotation_period) * df_collision$colLenDown_i / bird_speed > 1,
    1,
    (no_blades / rotation_period) * df_collision$colLenDown_i / bird_speed
  )
  
  i <- 1
  df_collision$contributionUp_i <- df_collision$r_i[i] *
    df_collision$r_i[i] *
    df_collision$pCollisionUp_i[i] * 2
  
  df_collision$contributionDown_i <- df_collision$r_i[i] *
    df_collision$r_i[i] *
    df_collision$pCollisionDown_i[i] * 2
  
  for (i in 2:nrow(df_collision)) {
    df_collision$contributionUp_i[i] <-
      (df_collision$r_i[i] - df_collision$r_i[i - 1]) *
      df_collision$r_i[i] *
      df_collision$pCollisionUp_i[i] * 2
    
    df_collision$contributionDown_i[i] <-
      (df_collision$r_i[i] - df_collision$r_i[i - 1]) *
      df_collision$r_i[i] *
      df_collision$pCollisionDown_i[i] * 2
  }
  
  return(
    sum(
      df_collision$contributionUp_i + df_collision$contributionDown_i
    ) / 2
  )
}