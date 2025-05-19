expect_equal(
  n_collision(
    avoidance_rate_static = 0.99,
    avoidance_rate_dynamic = c(0.90, 0.95),
    n_interaction_yr = 100,
    p_coll_static = 0.05,
    p_coll_dynamic = 0.03
  ),
  c(0.35, 0.20),
  tol = 1e-2
)