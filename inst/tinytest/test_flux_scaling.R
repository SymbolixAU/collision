# Setup------

# Turbine flux--------------------------
## Test if data inputs are checked appropriately----------------
# obs_flux

obs_flux <- 5
rotor_diameter <- 300
prop_below_turbine_max <- 1
### Invalid Inputs-----------------
expect_error(turbine_flux(NA, rotor_diameter, prop_below_turbine_max)
             , "Numeric input expected")

expect_error(turbine_flux(NULL, rotor_diameter, prop_below_turbine_max)
             , "Numeric input expected")

expect_error(turbine_flux('10', rotor_diameter, prop_below_turbine_max)
             , "Numeric input expected")

### Invalid input bounds--------------------
expect_error(turbine_flux(-100, rotor_diameter, prop_below_turbine_max)
             , "variable out of bounds")

# rotor_diameter
### Invalid Inputs-----------------
expect_error(turbine_flux(obs_flux, NA, prop_below_turbine_max)
, "Numeric input expected")

expect_error(turbine_flux(obs_flux, NULL, prop_below_turbine_max)
             , "Numeric input expected")

expect_error(turbine_flux(obs_flux, '10', prop_below_turbine_max)
             , "Numeric input expected")

### Invalid input bounds--------------------
expect_error(turbine_flux(obs_flux, -100, prop_below_turbine_max)
             , "variable out of bounds")

# prop_below_turbine_max
### Invalid Inputs-----------------
expect_error(turbine_flux(obs_flux, rotor_diameter, NA)
             , "Numeric input expected")

expect_error(turbine_flux(obs_flux, rotor_diameter, NULL)
             , "Numeric input expected")

expect_error(turbine_flux(obs_flux, rotor_diameter, '10')
             , "Numeric input expected")

### Invalid input bounds--------------------
expect_error(turbine_flux(obs_flux, rotor_diameter, -100)
             , "variable out of bounds")
# Max value is 1
expect_error(turbine_flux(obs_flux, rotor_diameter, 10)
             , "variable out of bounds")

## Zero obs_flux or diameter gives 0 turbine_flux----------
expect_equal(turbine_flux(0, rotor_diameter, prop_below_turbine_max), 0)
expect_equal(turbine_flux(obs_flux, 0, prop_below_turbine_max), 0)
expect_equal(turbine_flux(0, 0, prop_below_turbine_max), 0)

## Valid inputs give the correct result---------
expect_equal(turbine_flux(obs_flux, rotor_diameter, prop_below_turbine_max)
             , obs_flux * rotor_diameter * prop_below_turbine_max)

# flux per year--------------------------
## Test if data inputs are checked appropriately----------------
flux_per_min <- 1.2
prop_day <- 0.4
prop_year <- 0.8
### Invalid Inputs-----------------
expect_error(flux_per_year(NA, prop_day, prop_year)
             , "Numeric input expected")

expect_error(flux_per_year(NULL, prop_day, prop_year)
             , "Numeric input expected")

expect_error(flux_per_year('10', prop_day, prop_year)
             , "Numeric input expected")

### Invalid input bounds--------------------
expect_error(flux_per_year(-100, prop_day, prop_year)
             , "variable out of bounds")

# prop_day
### Invalid Inputs-----------------
expect_error(flux_per_year(flux_per_min, NA, prop_year)
             , "Numeric input expected")

expect_error(flux_per_year(flux_per_min, NULL, prop_year)
             , "Numeric input expected")

expect_error(flux_per_year(flux_per_min, '10', prop_year)
             , "Numeric input expected")

### Invalid input bounds--------------------
expect_error(flux_per_year(flux_per_min, -100, prop_year)
             , "variable out of bounds")

# prop_year
### Invalid Inputs-----------------
expect_error(flux_per_year(flux_per_min, prop_day, NA)
             , "Numeric input expected")

expect_error(flux_per_year(flux_per_min, prop_day, NULL)
             , "Numeric input expected")

expect_error(flux_per_year(flux_per_min, prop_day, '10')
             , "Numeric input expected")

### Invalid input bounds--------------------
expect_error(flux_per_year(flux_per_min, prop_day, -100)
             , "variable out of bounds")
# Max value is 1
expect_error(flux_per_year(flux_per_min, prop_day, 10)
             , "variable out of bounds")

## Zero flux_per_min or diameter gives 0 flux_per_year----------
expect_equal(flux_per_year(0, prop_day, prop_year), 0)
expect_equal(flux_per_year(flux_per_min, 0, prop_year), 0)
expect_equal(flux_per_year(flux_per_min, prop_day, 0), 0)

## Valid inputs give the correct result---------
expect_equal(flux_per_year(flux_per_min, prop_day, prop_year)
             , flux_per_min * 365.25 * 24 * 60 * prop_day * prop_year)
