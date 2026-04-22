# Tests for cluster_correction_a and cluster_correction_l

# Helper df
two_turbines <- data.frame(lon = c(0, 0.01), lat = c(51, 51))

# cluster_correction_a----------------------

## Returns a single numeric value -------------------------------------------
result_a <- cluster_correction_a(df_turbines = two_turbines, eff_detection_width = 500)
expect_true(is.numeric(result_a))
expect_equal(length(result_a), 1L)
expect_true(is.finite(result_a))

## Single turbine: correction factor should be ~1 ---------------------------
one_turbine <- data.frame(lon = 0, lat = 51)

expect_equal(
  cluster_correction_a(eff_detection_width = 500, one_turbine),
  1,
  tolerance = 0.05
)

## Very widely spaced turbines: factor close to 1 ---------------------------
far_turbines <- data.frame(lon = c(1, 10), lat = c(51, 51))
result_far <- cluster_correction_a(df_turbines = far_turbines, eff_detection_width = 500)
expect_equal(result_far, 1, tolerance = 0.05)

## Overlapping EDAs: factor lower than non-overlapping case -----------------
close_turbines <- data.frame(lon = c(0, 0.0001), lat = c(51, 51))
result_close <- cluster_correction_a(df_turbines = close_turbines, eff_detection_width = 5000)
expect_true(result_close < result_far)

## Result is positive and finite --------------------------------------------
expect_true(result_close > 0)
expect_true(result_far > 0)

## Accepts alternative column names -----------------------------------------
df_alt_names <- data.frame(longitude = c(0, 0.01), latitude = c(51, 51))
expect_equal(
  cluster_correction_a(500, df_turbines = df_alt_names),
  result_a,
  tolerance = 1e-6
)

df_xy <- data.frame(x = c(0, 0.01), y = c(51, 51))
expect_equal(cluster_correction_a(500, df_xy), result_a, tolerance = 1e-6)

## Case-insensitive column matching -----------------------------------------
df_upper <- data.frame(LON = c(0, 0.01), LAT = c(51, 51))
expect_equal(cluster_correction_a(500, df_upper), result_a, tolerance = 1e-6)

## Warns when multiple possible lon/lat columns detected --------------------
df_multi_lon <- data.frame(lon = c(0, 0.01), long = c(0, 0.01), lat = c(51, 51))
expect_error(
  cluster_correction_a(500, df_multi_lon),
  'df_turbines must contain one longitude column named lon, long, longitude, x, or easting'
)

df_multi_lat <- data.frame(
  lon = c(0, 0.01),
  lat = c(51, 51),
  latitude = c(51, 51)
)
expect_error(
  cluster_correction_a(500, df_multi_lat)
)

## Input validation: non-data.frame -----------------------------------------
expect_error(
  cluster_correction_a(500, list(lon = 0, lat = 51)),
  'df_turbines must be a data.frame'
)

## Input validation: zero rows ---------------------------------------------
expect_error(
  cluster_correction_a(500, data.frame(lon = numeric(0), lat = numeric(0))),
  'df_turbines must have at least one row'
)

## Input validation: missing lon column ------------------------------------
expect_error(
  cluster_correction_a(500, data.frame(longit = c(0, 1), lat = c(51, 51))),
  'df_turbines must contain one longitude column named lon, long, longitude, x, or easting'
)

## Input validation: missing lat column ------------------------------------
expect_error(
  cluster_correction_a(500, data.frame(lon = c(0, 1), lati = c(51, 51)))
)

## Input validation: NA coordinates ----------------------------------------
expect_error(
  cluster_correction_a(500, data.frame(lon = c(0, NA), lat = c(51, 51))),
  'missing values in coordinates not allowed'
)
expect_error(
  cluster_correction_a(500, data.frame(lon = c(0, 0.01), lat = c(51, NA))),
  'missing values in coordinates not allowed'
)

## Input validation: out-of-range coordinates ------------------------------
expect_error(
  cluster_correction_a(500, data.frame(lon = c(0, -10), lat = c(51, 51))),
)

## Input validation: eff_detection_width type/length -----------------------
expect_error(cluster_correction_a(df_turbines = two_turbines, eff_detection_width = '500'))
expect_error(
  cluster_correction_a(df_turbines = two_turbines, eff_detection_width = c(500, 600)),
  'eff_detection_width must be a single numeric value'
)

## Input validation: eff_detection_width bounds ----------------------------
expect_error(
  cluster_correction_a(df_turbines = two_turbines, eff_detection_width = 0),
  'variable out of bounds'
)
expect_error(
  cluster_correction_a(df_turbines = two_turbines, eff_detection_width = -100),
  'variable out of bounds'
)

## Input validation: NA eff_detection_width --------------------------------
expect_error(
  cluster_correction_a(df_turbines = two_turbines, eff_detection_width = NA),
  'Numeric input expected'
)

# cluster_correction_l----------------------------------------------------------

## Basic correctness: result equals eff_detection_width / avg_min_distance----
expect_equal(
  cluster_correction_l(avg_min_distance = 1000, eff_detection_width = 500),
  1
)
expect_equal(
  cluster_correction_l(avg_min_distance = 500, eff_detection_width = 500),
  1
)
expect_equal(
  cluster_correction_l(avg_min_distance = 200, eff_detection_width = 500),
  0.4
)

## Returns single numeric ---------------------------------------------------
res_l <- cluster_correction_l(500,1000)
expect_true(is.numeric(res_l))
expect_equal(length(res_l), 1L)

## Input validation: avg_min_distance type/length ---------------------------
expect_error(
  cluster_correction_l(avg_min_distance = '1000', eff_detection_width = 500),
  'Numeric input expected'
)
expect_error(
  cluster_correction_l(
    avg_min_distance = c(500, 1000),
    eff_detection_width = 500
  ),
  'avg_min_distance must be a single numeric value'
)

## Input validation: avg_min_distance bounds --------------------------------
expect_error(
  cluster_correction_l(avg_min_distance = 0, eff_detection_width = 500),
  'variable out of bounds'
)
expect_error(
  cluster_correction_l(avg_min_distance = -100, eff_detection_width = 500),
  'variable out of bounds'
)

## Input validation: NA avg_min_distance ------------------------------------
expect_error(
  cluster_correction_l(avg_min_distance = NA, eff_detection_width = 500),
  'Numeric input expected'
)

## Input validation: eff_detection_width type/length ------------------------
expect_error(
  cluster_correction_l(avg_min_distance = 1000, eff_detection_width = '500'),
  'Numeric input expected'
)
expect_error(
  cluster_correction_l(
    avg_min_distance = 1000,
    eff_detection_width = c(500, 600)
  ),
  'eff_detection_width must be a single numeric value'
)

## Input validation: eff_detection_width bounds -----------------------------
expect_error(
  cluster_correction_l(avg_min_distance = 1000, eff_detection_width = 0),
  'variable out of bounds'
)
expect_error(
  cluster_correction_l(avg_min_distance = 1000, eff_detection_width = -500),
  'variable out of bounds'
)

## Input validation: NA eff_detection_width ---------------------------------
expect_error(
  cluster_correction_l(avg_min_distance = 1000, eff_detection_width = NA),
  'Numeric input expected'
)

