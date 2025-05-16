data(ds_example)

expect_equal(w_from_distmodel(ds_example), 4)
expect_equal(round(edr_from_distmodel(ds_example), 2), 3.06)
expect_equal(round(eda_from_distmodel(ds_example), 3), 29.369)


bad_model <- lm(y ~ x, data = data.frame(x = 1:100, y = 1:100**2 + runif(100)))

expect_error(
    w_from_distmodel(bad_model), "`dsmodel` object required"
)
expect_error(
    edr_from_distmodel(bad_model), "`dsmodel` object required"
)
expect_error(
    eda_from_distmodel(bad_model), "`dsmodel` object required"
)
