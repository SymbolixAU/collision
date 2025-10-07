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
# ## calculate ecdf
# ## Note - this is a simple example; it's up to the analyst how best to
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
# 
# 
# ---
#   
library(collision)
library(Distance)

df_obs_survey
names(df_obs_survey)[2] <- "size"

ds <- ds(
  data = df_obs_survey[df_obs_survey$size >0,],
  truncation = max(df_obs_survey$distance, na.rm=TRUE),
  transect = "point",
)

summary(ds)

119 / ds$ddf$fitted[1] 
summary(ds)

w_from_distmodel
edr_from_distmodel

ds$ddf$meta.data$int.range


# 
Distance::summarize_ds_models(ds)

df_obs_survey$Region.Label <- "region1"
df_obs_survey$Area <-  119*pi*2000**2
df_obs_survey$Sample.Label <- 1:nrow(df_obs_survey)
df_obs_survey$Effort <- 1


lst_obs <- Distance::unflatten(df_obs_survey)

dht(model = ds, region.table = lst_obs$region.table, 
    sample.table = lst_obs$sample.table,
    obs.table = lst_obs$obs.table)

bootds <- bootdht()



ds_example$ddf$model |> str()
str(ds$ddf)
  
  
ds |>str()
ds$ddf$ds$aux$point
ds$ddf$ds$aux$ddfobj$type
ds$ddf$ds$aux$ddfobj$scale$formula


ds_hr <- ds(
  data = df_obs_survey,
  truncation = max(df_obs_survey$distance, na.rm=TRUE),
  transect = "point",
  formula = ~1,
  key = "hr",
  dht_group = TRUE,
  nadj = 0
  )

edr_fun <- function(d = df_obs_survey$survey_id
                    ,  i = seq_len(nrow(df_obs_survey))
                    , dat = df_obs_survey){
  
  message(paste(i, collapse = ", "))
  df_boot_i <- dat[dat$survey_id %in% d[i],]
  
  ds_CI <- tryCatch(
    ds(data = df_boot_i,
       transect = "point",
       formula = ~ 1,
       key = "hn",
       dht_group = TRUE,
       nadj = 0)
    , error = function(e) {
      print(e)
      NULL
    }
  )
  
  if (is.null(ds_CI)) return(NA)
  edr_boot <- edr_from_distmodel(ds_CI)
  return(edr_boot)
}

ds_boot <- boot::boot(data = df_obs_survey$survey_id
                , statistic = edr_fun, 
                , sim = "ordinary"
                , stype = "i"
                , R = 150
                , parallel = "multicore"
                , ncpus = parallel::detectCores(logical = FALSE) - 1
)


edr_from_distmodel(ds_model = ds_hr)
ds_boot$t0
ds_boot$t |> mean()
ds_boot$t |> sd()

summary(ds_boot)


library(data.table)
library(ggplot2)
dt_boot_check <- data.table(
  iteration = seq_len(length(ds_boot$t[, 1]))
  , est = ds_boot$t[, 1]
)
for (i in seq_len(nrow(dt_boot_check))) {
  if (i == 1) next
  set(x = dt_boot_check
      , i = i
      , j = "cum_sd"
      , value = dt_boot_check[seq(1, i), sd(est, na.rm = TRUE)])
}


ggplot() +
  geom_line(data = dt_boot_check
            , aes(x = iteration, y = cum_sd)) +
  labs(title = "EDR")

dt_boot_check


