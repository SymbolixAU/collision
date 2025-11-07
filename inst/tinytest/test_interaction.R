# Test flat --------------------------------------------------------------------
expect_equal(
  prob_interaction_flat(100), 0.1
)

## Test input handling

expect_error(
  prob_interaction_flat(""),
  "num_turbines must be integer"
)


expect_error(
  prob_interaction_flat(1.1),
  "num_turbines must be integer"
)

expect_error(
  prob_interaction_flat(0),
  "num_turbines must be greater than 0"
)
