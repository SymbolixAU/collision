# Tests for cluster_correction_a and cluster_correction_l

# Helper df
two_turbines <- data.frame(lon = c(0, 0.01), lat = c(51, 51))

# cluster_correction_a----------------------

## Returns a single numeric value -------------------------------------------
result_a <- cluster_correction_a(two_turbines, eff_detection_width = 500)
expect_true(is.numeric(result_a))
expect_equal(length(result_a), 1L)
expect_true(is.finite(result_a))

## Single turbine: correction factor should be ~1 ---------------------------
one_turbine <- data.frame(lon = 0, lat = 51)
expect_equal(
  cluster_correction_a(one_turbine, eff_detection_width = 500),
  1,
  tolerance = 0.05
)

## Very widely spaced turbines: factor close to 1 ---------------------------
far_turbines <- data.frame(lon = c(0, 10), lat = c(51, 51))
result_far <- cluster_correction_a(far_turbines, eff_detection_width = 500)
expect_equal(result_far, 1, tolerance = 0.05)

## Overlapping EDAs: factor lower than non-overlapping case -----------------
close_turbines <- data.frame(lon = c(0, 0.0001), lat = c(51, 51))
result_close <- cluster_correction_a(close_turbines, eff_detection_width = 5000)
expect_true(result_close < result_far)

## Result is positive and finite --------------------------------------------
expect_true(result_close > 0)
expect_true(result_far > 0)

## Accepts alternative column names -----------------------------------------
df_alt_names <- data.frame(longitude = c(0, 0.01), latitude = c(51, 51))
expect_equal(
  cluster_correction_a(df_alt_names, 500),
  result_a,
  tolerance = 1e-6
)

df_xy <- data.frame(x = c(0, 0.01), y = c(51, 51))
expect_equal(cluster_correction_a(df_xy, 500), result_a, tolerance = 1e-6)

## Case-insensitive column matching -----------------------------------------
df_upper <- data.frame(LON = c(0, 0.01), LAT = c(51, 51))
expect_equal(cluster_correction_a(df_upper, 500), result_a, tolerance = 1e-6)

## Warns when multiple possible lon/lat columns detected --------------------
df_multi_lon <- data.frame(lon = c(0, 0.01), long = c(0, 0.01), lat = c(51, 51))
expect_warning(
  cluster_correction_a(df_multi_lon, 500),
  'multiple possible longitude columns detected'
)

df_multi_lat <- data.frame(
  lon = c(0, 0.01),
  lat = c(51, 51),
  latitude = c(51, 51)
)
expect_warning(
  cluster_correction_a(df_multi_lat, 500),
  'multiple possible latitude columns detected'
)

## Input validation: non-data.frame -----------------------------------------
expect_error(
  cluster_correction_a(list(lon = 0, lat = 51), 500),
  'df_turbines must be a data.frame'
)

## Input validation: zero rows ---------------------------------------------
expect_error(
  cluster_correction_a(data.frame(lon = numeric(0), lat = numeric(0)), 500),
  'df_turbines must have at least one row'
)

## Input validation: missing lon column ------------------------------------
expect_error(
  cluster_correction_a(data.frame(easting = c(0, 1), lat = c(51, 51)), 500),
  'df_turbines must contain a longitude column'
)

## Input validation: missing lat column ------------------------------------
expect_error(
  cluster_correction_a(data.frame(lon = c(0, 1), northing = c(51, 51)), 500),
  'df_turbines must contain a latitude column'
)

## Input validation: NA coordinates ----------------------------------------
expect_error(
  cluster_correction_a(data.frame(lon = c(0, NA), lat = c(51, 51)), 500),
  'NA values detected in longitude column'
)
expect_error(
  cluster_correction_a(data.frame(lon = c(0, 0.01), lat = c(51, NA)), 500),
  'NA values detected in latitude column'
)

## Input validation: out-of-range coordinates ------------------------------
expect_error(
  cluster_correction_a(data.frame(lon = c(0, 200), lat = c(51, 51)), 500),
  'longitude values appear out of WGS 84 range'
)
expect_error(
  cluster_correction_a(data.frame(lon = c(0, 0.01), lat = c(51, 100)), 500),
  'latitude values appear out of WGS 84 range'
)

## Input validation: eff_detection_width type/length -----------------------
expect_error(cluster_correction_a(two_turbines, eff_detection_width = '500'))
expect_error(
  cluster_correction_a(two_turbines, eff_detection_width = c(500, 600)),
  'eff_detection_width must be a single numeric value'
)

## Input validation: eff_detection_width bounds ----------------------------
expect_error(
  cluster_correction_a(two_turbines, eff_detection_width = 0),
  'eff_detection_width must be greater than 0'
)
expect_error(
  cluster_correction_a(two_turbines, eff_detection_width = -100),
  'eff_detection_width must be greater than 0'
)

## Input validation: NA eff_detection_width --------------------------------
expect_error(
  cluster_correction_a(two_turbines, eff_detection_width = NA),
  'eff_detection_width must be a single numeric value'
)

# cluster_correction_l----------------------------------------------------------

## Basic correctness: result equals eff_detection_width / avg_min_distance----
expect_equal(
  cluster_correction_l(avg_min_distance = 1000, eff_detection_width = 500),
  0.5
)
expect_equal(
  cluster_correction_l(avg_min_distance = 500, eff_detection_width = 500),
  1
)
expect_equal(
  cluster_correction_l(avg_min_distance = 200, eff_detection_width = 500),
  2.5
)

## Returns single numeric ---------------------------------------------------
res_l <- cluster_correction_l(1000, 500)
expect_true(is.numeric(res_l))
expect_equal(length(res_l), 1L)

## Input validation: avg_min_distance type/length ---------------------------
expect_error(
  cluster_correction_l(avg_min_distance = '1000', eff_detection_width = 500),
  'avg_min_distance must be a single numeric value'
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
  'avg_min_distance must be greater than 0'
)
expect_error(
  cluster_correction_l(avg_min_distance = -100, eff_detection_width = 500),
  'avg_min_distance must be greater than 0'
)

## Input validation: NA avg_min_distance ------------------------------------
expect_error(
  cluster_correction_l(avg_min_distance = NA, eff_detection_width = 500),
  'avg_min_distance must be a single numeric value'
)

## Input validation: eff_detection_width type/length ------------------------
expect_error(
  cluster_correction_l(avg_min_distance = 1000, eff_detection_width = '500'),
  'eff_detection_width must be a single numeric value'
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
  'eff_detection_width must be greater than 0'
)
expect_error(
  cluster_correction_l(avg_min_distance = 1000, eff_detection_width = -500),
  'eff_detection_width must be greater than 0'
)

## Input validation: NA eff_detection_width ---------------------------------
expect_error(
  cluster_correction_l(avg_min_distance = 1000, eff_detection_width = NA),
  'eff_detection_width must be a single numeric value'
)