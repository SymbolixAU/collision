# Test rnorm_to_rlnorm


test_output <- parameterise_lnorm(mean = 2000, sd = 20)

expect_equal(2000, exp(test_output$meanlog + test_output$sdlog^2/2))

expect_equal(20^2, exp(2*test_output$meanlog + test_output$sdlog^2) * (exp(test_output$sdlog^2)-1))

## Test checks

expect_error(
    parameterise_lnorm(mean = -1, sd = 2),
    "variable out of bounds"
)

expect_error(
    parameterise_lnorm(mean = "-1", sd = 2),
    "Numeric input expected"
)

expect_error(
    parameterise_lnorm(mean = 2, sd = -2),
    "variable out of bounds"
)

expect_error(
    parameterise_lnorm(mean = 1, sd = "2"),
    "Numeric input expected"
)