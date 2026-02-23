## basic distance model
library(Distance)
library(mc2d)

set.seed(2026)
nobs <- 100L
ntransects <- 12L

## grab basic structure from distance example

data(LTExercise)
df_lines <- LTExercise

## change headings to suit style
names(df_lines) <- tolower(gsub("\\.","_", names(df_lines)))

## effort in mins

df_effort_line <- data.frame(
  region_label = "made up",
  transect = 1:ntransects,
  effort_min = runif(ntransects, min = 25L, max = 40L) |> round()
)


df_obs_line <- data.frame(
  transect = sample(x = 1:ntransects, size = nobs, replace = TRUE),
  object = 1:nobs, 
  distance = round(rweibull(nobs, shape = 1L, scale = 180L))
)
#hist(df_obs$distance, breaks = 15)




usethis::use_data(df_obs_line, overwrite = TRUE)
usethis::use_data(df_effort_line, overwrite = TRUE)

