expect_equal(
  n_collision(
    avoidance_rate_static = 0.99,
    avoidance_rate_dynamic = c(0.90, 0.95),
    n_flights = 100,
    p_coll_static = 0.05,
    p_coll_dynamic = 0.03
  ),
  c(0.35, 0.20),
  tol = 1e-2
)

expect_error(
  n_collision(
    avoidance_rate_static = "0.99",
    avoidance_rate_dynamic = c(0.90, 0.95),
    n_flights = 100,
    p_coll_static = 0.05,
    p_coll_dynamic = 0.03
  ),
  "Numeric input expected"
)

expect_error(
  n_collision(
    avoidance_rate_static = -0.99,
    avoidance_rate_dynamic = c(0.90, 0.95),
    n_flights = 100,
    p_coll_static = 0.05,
    p_coll_dynamic = 0.03
  ),
  "variable out of bounds"
)

expect_error(
  n_collision(
    avoidance_rate_static = 0.99,
    avoidance_rate_dynamic = c("", 0.90, 0.95),
    n_flights = 100,
    p_coll_static = 0.05,
    p_coll_dynamic = 0.03
  ),
  "Numeric input expected"
)

expect_error(
  n_collision(
    avoidance_rate_static = 0.99,
    avoidance_rate_dynamic = c(-0.90, 0.95),
    n_flights = 100,
    p_coll_static = 0.05,
    p_coll_dynamic = 0.03
  ),
  "variable out of bounds"
)


expect_error(
  n_collision(
    avoidance_rate_static = 0.99,
    avoidance_rate_dynamic = c(0.90, 0.95),
    n_flights = "100",
    p_coll_static = 0.05,
    p_coll_dynamic = 0.03
  ),
  "Numeric input expected"
)

expect_error(
  n_collision(
    avoidance_rate_static = 0.99,
    avoidance_rate_dynamic = c(0.90, 0.95),
    n_flights = -100,
    p_coll_static = 0.05,
    p_coll_dynamic = 0.03
  ),
  "variable out of bounds"
)

expect_error(
  n_collision(
    avoidance_rate_static = 0.99,
    avoidance_rate_dynamic = c(0.90, 0.95),
    n_flights = 100,
    p_coll_static = "0.05",
    p_coll_dynamic = 0.03
  ),
  "Numeric input expected"
)

expect_error(
  n_collision(
    avoidance_rate_static = 0.99,
    avoidance_rate_dynamic = c(0.90, 0.95),
    n_flights = 100,
    p_coll_static = -0.01,
    p_coll_dynamic = 0.03
  ),
  "variable out of bounds"
)

expect_error(
  n_collision(
    avoidance_rate_static = 0.99,
    avoidance_rate_dynamic = c(0.90, 0.95),
    n_flights = 100,
    p_coll_static = 0.05,
    p_coll_dynamic = "0.03"
  ),
  "Numeric input expected"
)

expect_error(
  n_collision(
    avoidance_rate_static = 0.99,
    avoidance_rate_dynamic = c(0.90, 0.95),
    n_flights = 100,
    p_coll_static = 0.05,
    p_coll_dynamic = 12.03
  ),
  "variable out of bounds"
)

