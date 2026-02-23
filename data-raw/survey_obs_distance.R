## basic distance model
library(Distance)
library(mc2d)

data(book.tee.data)

tee_data <- book.tee.data$book.tee.dataframe[
  book.tee.data$book.tee.dataframe$observer==1, ]

ds_example <- ds(tee_data, 4)

usethis::use_data(ds_example, overwrite = TRUE)


## Set up example (simple) survey data

set.seed(2026)

n_survey <- 100L
n_obs <- 120L

df_lineobs <- structure(
  list(
    distance = round(rweibull(n_obs, shape = 2, scale = 900)), 
    size = round(rpert(n_obs, min = 0.5, mode = 1, max = 3.5, shape = 6)), 
    type = rep("raptor", n_obs), 
    height = round(rweibull(n_obs, shape = 1.5, scale = 900)),
    survey_id = sort(sample(1:n_survey, n_obs, replace = TRUE)), 
    object = c(1:n_obs)), 
  row.names = c(NA, -n_obs), 
  class = c("data.frame")
)


df_line_survey <- structure(
  list(
    survey_id = 1:n_survey, 
    survey_duration = rep(45, n_survey),
    survey_type = rep("point", n_survey)), 
  row.names = c(NA, -n_survey), 
  class = c("data.frame")
)

ds_raptor <- ds(df_obs,
                dht_group = TRUE)

usethis::use_data(df_obs, overwrite = TRUE)
usethis::use_data(df_survey, overwrite = TRUE)
usethis::use_data(ds_raptor, overwrite = TRUE)
