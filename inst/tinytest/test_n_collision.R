expect_equal(
  n_collision(
    avoidance_rate_static = 0.99,
    avoidance_rate_dynamic = c(0.90, 0.95),
    flux_yr = 100,
    p_interaction = 0.1,
    p_coll_static = 0.05,
    p_coll_dynamic = 0.03
  ),
  c(0.035, 0.020),
  tol = 1e-2
)

expect_error(
  n_collision(
    avoidance_rate_static = "0.99",
    avoidance_rate_dynamic = c(0.90, 0.95),
    flux_yr = 100,
    p_interaction = 0.1,
    p_coll_static = 0.05,
    p_coll_dynamic = 0.03
  ),
  "avoidance_rate_static must be numeric"
)

expect_error(
  n_collision(
    avoidance_rate_static = -0.99,
    avoidance_rate_dynamic = c(0.90, 0.95),
    flux_yr = 100,
    p_interaction = 0.1,
    p_coll_static = 0.05,
    p_coll_dynamic = 0.03
  ),
  "avoidance_rate_static must be in range \\[0, 1]"
)

expect_error(
  n_collision(
    avoidance_rate_static = 0.99,
    avoidance_rate_dynamic = c("", 0.90, 0.95),
    flux_yr = 100,
    p_interaction = 0.1,
    p_coll_static = 0.05,
    p_coll_dynamic = 0.03
  ),
  "avoidance_rate_dynamic must be numeric"
)

expect_error(
  n_collision(
    avoidance_rate_static = 0.99,
    avoidance_rate_dynamic = c(-0.90, 0.95),
    flux_yr = 100,
    p_interaction = 0.1,
    p_coll_static = 0.05,
    p_coll_dynamic = 0.03
  ),
  "avoidance_rate_dynamic must be in range \\[0, 1]"
)


expect_error(
  n_collision(
    avoidance_rate_static = 0.99,
    avoidance_rate_dynamic = c(0.90, 0.95),
    flux_yr = "100",
    p_interaction = 0.1,
    p_coll_static = 0.05,
    p_coll_dynamic = 0.03
  ),
  "flux_yr must be numeric"
)

expect_error(
  n_collision(
    avoidance_rate_static = 0.99,
    avoidance_rate_dynamic = c(0.90, 0.95),
    flux_yr = -100,
    p_interaction = 0.1,
    p_coll_static = 0.05,
    p_coll_dynamic = 0.03
  ),
  "flux_yr must not be negative"
)

expect_error(
  n_collision(
    avoidance_rate_static = 0.99,
    avoidance_rate_dynamic = c(0.90, 0.95),
    flux_yr = 100,
    p_interaction = "0.1",
    p_coll_static = 0.05,
    p_coll_dynamic = 0.03
  ),
  "p_interaction must be numeric"
)

expect_error(
  n_collision(
    avoidance_rate_static = 0.99,
    avoidance_rate_dynamic = c(0.90, 0.95),
    flux_yr = 100,
    p_interaction = 1.1,
    p_coll_static = 0.05,
    p_coll_dynamic = 0.03
  ),
  "p_interaction must be in range \\[0, 1]"
)

expect_error(
  n_collision(
    avoidance_rate_static = 0.99,
    avoidance_rate_dynamic = c(0.90, 0.95),
    flux_yr = 100,
    p_interaction = 0.1,
    p_coll_static = "0.05",
    p_coll_dynamic = 0.03
  ),
  "p_coll_static must be numeric"
)

expect_error(
  n_collision(
    avoidance_rate_static = 0.99,
    avoidance_rate_dynamic = c(0.90, 0.95),
    flux_yr = 100,
    p_interaction = 0.1,
    p_coll_static = -0.01,
    p_coll_dynamic = 0.03
  ),
  "p_coll_static must be in range \\[0, 1]"
)

expect_error(
  n_collision(
    avoidance_rate_static = 0.99,
    avoidance_rate_dynamic = c(0.90, 0.95),
    flux_yr = 100,
    p_interaction = 0.1,
    p_coll_static = 0.05,
    p_coll_dynamic = "0.03"
  ),
  "p_coll_dynamic must be numeric"
)

expect_error(
  n_collision(
    avoidance_rate_static = 0.99,
    avoidance_rate_dynamic = c(0.90, 0.95),
    flux_yr = 100,
    p_interaction = 0.1,
    p_coll_static = 0.05,
    p_coll_dynamic = 12.03
  ),
  "p_coll_dynamic must be in range \\[0, 1]"
)
