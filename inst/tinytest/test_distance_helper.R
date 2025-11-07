data(ds_example)

# Returns numeric value------------
expect_equal(class(w_from_distmodel(ds_example)), "numeric")

# Returns expect value--------------
expect_equal(w_from_distmodel(ds_example), 4)
expect_equal(round(edr_from_distmodel(ds_example), 2), 3.06)

# Error when non-ds model is provides
bad_model <- lm(y ~ x, data = data.frame(x = 1:100, y = 1:100**2 + runif(100)))

expect_error(
    w_from_distmodel(bad_model), "`dsmodel` object required"
)
expect_error(
    edr_from_distmodel(bad_model), "`dsmodel` object required"
)
