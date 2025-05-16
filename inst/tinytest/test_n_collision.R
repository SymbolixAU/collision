expect_equal(
  n_collision(
    avoidance_rate = c(0.9, 0.99),
    n_interaction_yr = 100,
    p_collision = 0.01
  ),
  c(0.1, 0.01),
  tol = 1e-2
)