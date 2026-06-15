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

# --- population (finite-population correction) ---

# NULL population returns the standard result
expect_equal(
  n_collision(
    avoidance_rate_static = 0.99,
    avoidance_rate_dynamic = 0.90,
    n_flights = 100,
    p_coll_static = 0.05,
    p_coll_dynamic = 0.03,
    population = NULL
  ),
  0.35,
  tol = 1e-6
)

# finite population gives a corrected count
expect_equal(
  n_collision(
    avoidance_rate_static = 0.99,
    avoidance_rate_dynamic = 0.90,
    n_flights = 100,
    p_coll_static = 0.05,
    p_coll_dynamic = 0.03,
    population = 500
  ),
  500 * (1 - (1 - 0.0035)^0.2),
  tol = 1e-6
)

# vectorised avoidance_dynamic works with population
expect_equal(
  n_collision(
    avoidance_rate_static = 0.99,
    avoidance_rate_dynamic = c(0.90, 0.95),
    n_flights = 100,
    p_coll_static = 0.05,
    p_coll_dynamic = 0.03,
    population = 500
  ),
  c(500 * (1 - (1 - 0.0035)^0.2), 500 * (1 - (1 - 0.002)^0.2)),
  tol = 1e-6
)

# very large population converges to the infinite sink result
expect_equal(
  n_collision(
    avoidance_rate_static = 0.99,
    avoidance_rate_dynamic = 0.90,
    n_flights = 100,
    p_coll_static = 0.05,
    p_coll_dynamic = 0.03,
    population = 1e8
  ),
  0.35,
  tol = 1e-2
)

# negative population is rejected
expect_error(
  n_collision(
    avoidance_rate_static = 0.99,
    avoidance_rate_dynamic = 0.90,
    n_flights = 100,
    p_coll_static = 0.05,
    p_coll_dynamic = 0.03,
    population = -100
  ),
  "variable out of bounds"
)

# non-numeric population is rejected
expect_error(
  n_collision(
    avoidance_rate_static = 0.99,
    avoidance_rate_dynamic = 0.90,
    n_flights = 100,
    p_coll_static = 0.05,
    p_coll_dynamic = 0.03,
    population = "500"
  ),
  "Numeric input expected"
)
