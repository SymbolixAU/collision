## code to prepare `wte` dataset goes here

wte <- define_bird(
  species = "Wedge-tailed Eagle",
  bird_length = 0.945,
  bird_speed = 17,
  prop_day = 0.5, 
  prop_year = 1,
  avoidance_dynamic = 0.90,
  avoidance_static = 0.9999
)


usethis::use_data(wte, overwrite = TRUE)
