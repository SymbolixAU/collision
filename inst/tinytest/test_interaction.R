# # Test the n_interaction against existing result


expect_equal(
  n_interaction(
    activity_rate = 0.003,
    prop_height = 0.5,
    bird_prop_year = 1,
    bird_prop_day = 1,
    bird_obs_scale_factor = 1,
    turb_prop_operational = 0.9,
    turb_blade_length = 130
  ) |> round(digits = 8),
  0.00007168
)


var <- 1


expect_error(
  n_interaction(
    activity_rate = -1,
    prop_height = 0.5,
    bird_prop_year = 1,
    bird_prop_day = 1,
    bird_obs_scale_factor = 1,
    turb_prop_operational = 0.9,
    turb_blade_length = 130
  )
)

expect_error(
  n_interaction(
    activity_rate = 0.21,
    prop_height = 1.1,
    bird_prop_year = 1,
    bird_prop_day = 1,
    bird_obs_scale_factor = 1,
    turb_prop_operational = 0.9,
    turb_blade_length = 130
  )
)


expect_error(
  n_interaction(
    activity_rate = 0.21,
    prop_height = 1,
    bird_prop_year = 1,
    bird_prop_day = 1,
    bird_obs_scale_factor = 1,
    turb_prop_operational = -1,
    turb_blade_length = 130
  )
)
