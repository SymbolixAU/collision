# Test rnorm_to_rlnorm

# 1. Basic Correctness Tests---------------
pars <- parameterise_lnorm(mean = 2, sd = 1)
expect_true(is.list(pars), info = "Returns a list")
expect_true(
  all(c("meanlog", "sdlog") %in% names(pars)),
  info = "Returns meanlog and sdlog"
)

# 2. Output Values work on standard inputs------------------
test_output <- parameterise_lnorm(mean = 2000, sd = 20)
expect_equal(2000, exp(test_output$meanlog + test_output$sdlog^2 / 2))
expect_equal(
  20^2,
  exp(2 * test_output$meanlog + test_output$sdlog^2) *
    (exp(test_output$sdlog^2) - 1)
)

# 3. Small values------------------
pars_small <- parameterise_lnorm(mean = 0.002, sd = 0.0001)
expect_true(is.finite(pars_small$meanlog))
expect_true(is.finite(pars_small$sdlog))

# 4. Zero variance case (sd = 0)----------
pars_zero <- parameterise_lnorm(mean = 5, sd = 0)
expect_equal(pars_zero$meanlog, log(5))
expect_equal(pars_zero$sdlog, 0)

# 5. Invalid inputs should error------------
expect_error(
  parameterise_lnorm(mean = -1, sd = 1),
  pattern = "variable out of bounds"
)
expect_error(
  parameterise_lnorm(mean = 1, sd = -0.1),
  pattern = "variable out of bounds"
)
expect_error(
  parameterise_lnorm(mean = "-1", sd = 2),
  "Numeric input expected"
)
expect_error(
  parameterise_lnorm(mean = 1, sd = "2"),
  "Numeric input expected"
)
expect_error(
  parameterise_lnorm(mean = NA, sd = 1),
  pattern = "Numeric input expected"
)
expect_error(
  parameterise_lnorm(mean = 1, sd = NA),
  pattern = "Numeric input expected"
)
expect_error(
  parameterise_lnorm(mean = NULL, sd = 1),
  pattern = "Numeric input expected"
)
expect_error(
  parameterise_lnorm(mean = 1, sd = NULL),
  pattern = "Numeric input expected"
)