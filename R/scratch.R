# 
# # rotor_diam / 2 is better than using blade length because it 
# # includes the nacelle size 
# min_rsh <- v90_single$hh - v90_single$rotor_diam * 0.5
# max_rsh <- v90_single$hh + v90_single$rotor_diam * 0.5
# 
# ## Review the heights
# 
# ggplot(data = as.data.frame(df_obs_survey), aes(x = height)) +
#   stat_ecdf() +
#   geom_vline(xintercept = min_rsh, colour = "red") +
#   geom_vline(xintercept = max_rsh, colour = "red")
# 
# 
# # calculate ecdf
# # Note - this is a simple example; it's up to the analyst how best to 
# ## fit the height distribution
# 
# prop_between <- function(dat, i, lwr, upp){
#   
#   cdf_dat <- ecdf(dat[i])
#   p_low <- cdf_dat(lwr)
#   p_high <- cdf_dat(upp)
#   
#   return(p_high - p_low)
#   
# }
# 
# prop_between(df_obs_survey$height, 1:nrow(df_obs_survey),
#              lwr = 0, upp = round(min_rsh))
# 
# 
# b <- boot::boot(
#   data = df_obs_survey$height, 
#   statistic = prop_between, stype = "i", 
#   R = 1000,
#   lwr = 0, upp = round(min_rsh)
# )
# 
# boot::boot(
#   data = df_obs_survey$height, 
#   statistic = prop_between, stype = "i", 
#   R = 1000,
#   lwr = round(min_rsh), upp = round(max_rsh)
# )
# 
# set_random("rnorm", mean = summary(b)$original, sd = summary(b)$bootSE)
# 
# 
# 
# 
# prop_below_min <- cdf_height(round(min_rsh))
# 
# prop_at_height <- cdf_height(round(max_rsh)) - cdf_height(round(min_rsh))
# prop_below_height <- cdf_height(round(min_rsh))
# 
