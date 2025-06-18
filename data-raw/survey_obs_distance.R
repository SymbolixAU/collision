## basic distance model
library(Distance)

data(book.tee.data)

tee_data <- book.tee.data$book.tee.dataframe[
  book.tee.data$book.tee.dataframe$observer==1, ]

ds_example <- ds(tee_data, 4)

usethis::use_data(ds_example, overwrite = TRUE)


## Set up example (simple) survey data

df_obs_survey <- structure(
  list(
    distance = c(300L, 2000L, 400L, NA, 100L, 40L, 
    300L, 125L, 800L, 300L, 400L, 1200L, 100L, 700L, 150L, 25L, 680L, 
    400L, 500L, 800L, 850L, 500L, 100L, 653L, 300L, 500L, 400L, 250L, 
    800L, 360L, 800L, 600L, 700L, 500L, 400L, 1000L, 850L, 25L, 300L, 
    800L, 20L, 300L, 700L, 500L, 800L, 450L, 125L, 1500L, 1000L, 
    80L, 150L, 800L, 300L, 1000L, 300L, 545L, 300L, 300L, 800L, 254L, 
    100L, 760L, 730L, 600L, 400L, 2000L, 710L, 600L, 600L, 800L, 
    500L, 576L, 400L, 100L, 40L, 40L, 1500L, 500L, 1000L, 1200L, 
    30L, 820L, 400L, 300L, 800L, 250L, 800L, 670L, 400L, 850L, 500L, 
    80L, 200L, 500L, 300L, 40L, 200L, 2000L, 500L, 110L, 1000L, 1200L, 
    250L, 1250L, 400L, 600L, 500L, 545L, 475L, 500L, 1500L, 300L, 
    660L, 300L, 300L, 1000L, 40L, 200L, 300L, 150L), 
    n_individuals = c(1L, 
    1L, 1L, 0L, 2L, 1L, 2L, 1L, 1L, 1L, 1L, 2L, 2L, 1L, 3L, 2L, 1L, 
    1L, 1L, 2L, 1L, 1L, 1L, 2L, 2L, 1L, 1L, 2L, 2L, 2L, 1L, 2L, 2L, 
    1L, 1L, 1L, 1L, 2L, 2L, 1L, 1L, 1L, 1L, 1L, 2L, 1L, 1L, 1L, 1L, 
    1L, 3L, 1L, 2L, 1L, 1L, 1L, 2L, 1L, 1L, 1L, 2L, 1L, 4L, 1L, 1L, 
    1L, 3L, 2L, 2L, 2L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 2L, 2L, 
    1L, 1L, 1L, 3L, 2L, 1L, 2L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 
    1L, 1L, 2L, 1L, 2L, 2L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 2L, 1L, 
    1L, 2L, 1L, 1L, 2L, 1L, 1L), 
    type = c("raptor", "raptor", "raptor", 
    "", "raptor", "raptor", "raptor", "raptor", "raptor", "raptor", 
    "raptor", "raptor", "raptor", "raptor", "raptor", "raptor", "raptor", 
    "raptor", "raptor", "raptor", "raptor", "raptor", "raptor", "raptor", 
    "raptor", "raptor", "raptor", "raptor", "raptor", "raptor", "raptor", 
    "raptor", "raptor", "raptor", "raptor", "raptor", "raptor", "raptor", 
    "raptor", "raptor", "raptor", "raptor", "raptor", "raptor", "raptor", 
    "raptor", "raptor", "raptor", "raptor", "raptor", "raptor", "raptor", 
    "raptor", "raptor", "raptor", "raptor", "raptor", "raptor", "raptor", 
    "raptor", "raptor", "raptor", "raptor", "raptor", "raptor", "raptor", 
    "raptor", "raptor", "raptor", "raptor", "raptor", "raptor", "raptor", 
    "raptor", "raptor", "raptor", "raptor", "raptor", "raptor", "raptor", 
    "raptor", "raptor", "raptor", "raptor", "raptor", "raptor", "raptor", 
    "raptor", "raptor", "raptor", "raptor", "raptor", "raptor", "raptor", 
    "raptor", "raptor", "raptor", "raptor", "raptor", "raptor", "raptor", 
    "raptor", "raptor", "raptor", "raptor", "raptor", "raptor", "raptor", 
    "raptor", "raptor", "raptor", "raptor", "raptor", "raptor", "raptor", 
    "raptor", "raptor", "raptor", "raptor", "raptor"), 
    height = c(239, 117, 233, 153, 276, 128, 136, 138, 132, 278, 154, 
               365, 117, 195, 331, 288, 253, 377, 110, 249, 127, 140,
               155, 63, 266, 241, 231, 137, 171, 118, 79, 69, 97, 59, 117,
               226, 290, 138, 144, 180, 112, 82, 101, 161, 145, 203, 203,
               217, 35, 57, 119, 209, 99, 206, 68, 79, 5, 15, 215, 93, 165,
               393, 192, 198, 10, 50, 184, 207, 261, 179, 255, 188, 324, 331,
               141, 137, 276, 112, 392, 135, 163, 212, 141, 303, 12, 38,
               423, 72, 83, 199, 120, 347, 25, 73, 252, 158, 112, 332,
               234, 174, 162, 178, 236, 215, 274, 224, 416, 31, 262, 95,
               228, 127, 99, 133, 332, 46, 330, 227, 169, 496
    ),
    survey_id = c(1L, 2L, 2L, 3L, 4L, 6L, 6L, 7L, 8L, 8L, 10L, 10L, 17L, 18L, 
    20L, 20L, 21L, 22L, 23L, 23L, 23L, 24L, 25L, 28L, 28L, 29L, 30L, 
    31L, 32L, 33L, 33L, 33L, 34L, 34L, 34L, 36L, 36L, 37L, 38L, 38L, 
    38L, 39L, 40L, 40L, 40L, 41L, 43L, 45L, 46L, 46L, 47L, 48L, 49L, 
    49L, 50L, 51L, 53L, 53L, 54L, 55L, 56L, 56L, 57L, 57L, 57L, 58L, 
    58L, 59L, 59L, 59L, 60L, 61L, 61L, 62L, 62L, 63L, 63L, 64L, 64L, 
    65L, 66L, 67L, 69L, 70L, 71L, 71L, 72L, 72L, 72L, 74L, 75L, 75L, 
    75L, 78L, 78L, 79L, 80L, 80L, 81L, 81L, 84L, 84L, 86L, 87L, 87L, 
    87L, 88L, 90L, 90L, 90L, 90L, 92L, 93L, 94L, 95L, 96L, 97L, 99L, 
    99L, 100L), 
    survey_mins = rep(45, 120),
    survey_type = c("point", "point", "point", "point", "point", 
    "point", "point", "point", "point", "point", "point", "point", 
    "point", "point", "point", "point", "point", "point", "point", 
    "point", "point", "point", "point", "point", "point", "point", 
    "point", "point", "point", "point", "point", "point", "point", 
    "point", "point", "point", "point", "point", "point", "point", 
    "point", "point", "point", "point", "point", "point", "point", 
    "point", "point", "point", "point", "point", "point", "point", 
    "point", "point", "point", "point", "point", "point", "point", 
    "point", "point", "point", "point", "point", "point", "point", 
    "point", "point", "point", "point", "point", "point", "point", 
    "point", "point", "point", "point", "point", "point", "point", 
    "point", "point", "point", "point", "point", "point", "point", 
    "point", "point", "point", "point", "point", "point", "point", 
    "point", "point", "point", "point", "point", "point", "point", 
    "point", "point", "point", "point", "point", "point", "point", 
    "point", "point", "point", "point", "point", "point", "point", 
    "point", "point", "point"), 
    detected = c(1, 1, 1, 0, 1, 1, 
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), 
    object = c(1:3, NA, 4:119)), 
  row.names = c(NA, -120L), 
  class = c("data.frame")
)

ds_raptor <- ds(df_obs_survey)

usethis::use_data(df_obs_survey, overwrite = TRUE)
usethis::use_data(ds_raptor, overwrite = TRUE)
