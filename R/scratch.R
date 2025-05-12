# 
# 
# ## Quick comparison between our Band and stochLabs
# ## using the stochLAB function that is supposed to match Band
# 
# library(collision)  # needs issue2
# #install.packages("stochLAB")
# library(stochLAB)
# 
# ## Note our chord profile is different but not that much
# # plot(df_collision$r_i, y= df_collision$chord_i, type = "b")
# # 
# # points(x =stochLAB::band_spreadsheet_dt_2$chord_profile$pp_radius, 
# #        y = stochLAB::band_spreadsheet_dt_2$chord_profile$chord, 
# #        col = "red", pch = 17)
# # points(x =stochLAB::band_spreadsheet_dt$chord_profile$pp_radius, 
# #        y = stochLAB::band_spreadsheet_dt$chord_profile$chord, 
# #        col = "blue")
# # points(x =stochLAB::chord_prof_5MW$pp_radius, 
# #        y = stochLAB::chord_prof_5MW$chord, 
# #        col = "green")
# 
# 
# 
# 
# 
# collision::p_collision_band(
#           bird_speed = 13.1,
#           bird_length = 0.85,
#           bird_wing_span = 1.01,
#           #prop_upwind = 0.5,
#           bird_flapping = 0,
#           rpm = 15,
#           rotor_diam = 120*2,
#           max_chord = 5,
#           pitch_deg = 15 * 180 / pi
#        #   n_blades = 3,
#         #  chord_prof = chord_prof_5MW
#           )
# 
# # 15 rad * 180deg / pi rad
# 
# 
# stochLAB::get_avg_prob_collision(
#       flight_speed = 13.1,  #m/s
#       body_lt = 0.85,       # m
#       wing_span = 1.01,     # m
#       prop_upwind = 0.5,    #
#       flap_glide = 1,       
#       rotor_speed = 15,     #rpm
#       rotor_radius = 120,   #
#       blade_width = 5,      # m
#       blade_pitch = 15,  #In radians
#       n_blades = 3, 
#       chord_prof = chord_prof_5MW
#       )
# 
# 
# 
# 
# 
# stochLAB::get_avg_prob_collision(
#   flight_speed = 13,  #m/s
#   body_lt = 0.82,       # m
#   wing_span = 2.12,     # m
#   prop_upwind = 0.5,    #
#   flap_glide = 1,       
#   rotor_speed = 20.2  ,     #rpm
#   rotor_radius = 52/2,   #
#   blade_width = 2.431,      # m
#   blade_pitch = 15*pi/180,  #In radians
#   n_blades = 3, 
#   chord_prof = chord_prof_5MW
# )
# 
# 
# collision::p_collision_band(
#   bird_speed = 13,
#   bird_length = 0.82,
#   bird_wing_span = 2.12,
#   #prop_upwind = 0.5,
#   bird_flapping = 0,
#   rpm = 20.2,
#   rotor_diam = 52,
#   max_chord = 2.4,
#   pitch_deg = 15
#   #   n_blades = 3,
#   #  chord_prof = chord_prof_5MW
# )
# 
# 
# v90_single
# 
# collision::p_collision_band()
# 
# 
# 
