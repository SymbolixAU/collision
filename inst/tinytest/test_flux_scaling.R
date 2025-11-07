# Setup------

# Turbine flux--------------------------
## Test if data inputs are checked appropriately----------------
# obs_flux

obs_flux <- 5
rotor_diameter <- 300
hub_height <- 1
### Invalid Inputs-----------------
expect_error(turbine_flights(NA, rotor_diameter, hub_height)
             , "Numeric input expected")

expect_error(turbine_flights(NULL, rotor_diameter, hub_height)
             , "Numeric input expected")

expect_error(turbine_flights('10', rotor_diameter, hub_height)
             , "Numeric input expected")

### Invalid input bounds--------------------
expect_error(turbine_flights(-100, rotor_diameter, hub_height)
             , "variable out of bounds")

# rotor_diameter
### Invalid Inputs-----------------
expect_error(turbine_flights(obs_flux, NA, hub_height)
, "Numeric input expected")

expect_error(turbine_flights(obs_flux, NULL, hub_height)
             , "Numeric input expected")

expect_error(turbine_flights(obs_flux, '10', hub_height)
             , "Numeric input expected")

### Invalid input bounds--------------------
expect_error(turbine_flights(obs_flux, -100, hub_height)
             , "variable out of bounds")

# hub_height
### Invalid Inputs-----------------
expect_error(turbine_flights(obs_flux, rotor_diameter, NA)
             , "Numeric input expected")

expect_error(turbine_flights(obs_flux, rotor_diameter, NULL)
             , "Numeric input expected")

expect_error(turbine_flights(obs_flux, rotor_diameter, '10')
             , "Numeric input expected")

### Invalid input bounds--------------------
expect_error(turbine_flights(obs_flux, rotor_diameter, -100)
             , "variable out of bounds")

## Zero obs_flux or diameter gives 0 turbine_flights----------
expect_equal(turbine_flights(0, rotor_diameter, hub_height), 0)
expect_equal(turbine_flights(obs_flux, 0, hub_height), 0)
expect_equal(turbine_flights(0, 0, hub_height), 0)

## Valid inputs give the correct result---------
expect_equal(turbine_flights(obs_flux, rotor_diameter, hub_height)
             , obs_flux * rotor_diameter * (hub_height + 0.5*rotor_diameter))

# flights per year--------------------------
## Test if data inputs are checked appropriately----------------
flights_per_time <- 1.2
prop_day <- 0.4
prop_year <- 0.8
### Invalid Inputs-----------------
expect_error(flights_per_year(flights_per_time = NA, prop_day = prop_day, prop_year = prop_year)
             , "Numeric input expected")

expect_error(flights_per_year(flights_per_time = NULL, prop_day = prop_day, prop_year = prop_year)
             , "Numeric input expected")

expect_error(flights_per_year(flights_per_time = '10', prop_day = prop_day, prop_year = prop_year)
             , "Numeric input expected")

### Invalid input bounds--------------------
expect_error(flights_per_year(flights_per_time = -100, prop_day = prop_day, prop_year = prop_year)
             , "variable out of bounds")

# prop_day
### Invalid Inputs-----------------
expect_error(flights_per_year(flights_per_time = flights_per_time, prop_day = NA, prop_year = prop_year)
             , "Numeric input expected")

expect_error(flights_per_year(flights_per_time = flights_per_time, prop_day = NULL, prop_year = prop_year)
             , "Numeric input expected")

expect_error(flights_per_year(flights_per_time = flights_per_time, prop_day = '10', prop_year = prop_year)
             , "Numeric input expected")

### Invalid input bounds--------------------
expect_error(flights_per_year(flights_per_time = flights_per_time, prop_day = -100, prop_year = prop_year)
             , "variable out of bounds")

# prop_year = prop_year
### Invalid Inputs-----------------
expect_error(flights_per_year(flights_per_time = flights_per_time, prop_day = prop_day, prop_year = NA)
             , "Numeric input expected")

expect_error(flights_per_year(flights_per_time = flights_per_time, prop_day = prop_day, prop_year = NULL)
             , "Numeric input expected")

expect_error(flights_per_year(flights_per_time = flights_per_time, prop_day = prop_day, prop_year = '10')
             , "Numeric input expected")

# Time_mins----------
expect_error(flights_per_year(flights_per_time = flights_per_time, prop_day = prop_day, prop_year = prop_year, time_units = "mints")
             , "In '1/mints', 'mints' is not recognized by udunits.")

### Invalid input bounds--------------------
expect_error(flights_per_year(flights_per_time = flights_per_time, prop_day = prop_day, prop_year = -100)
             , "variable out of bounds")
# Max value is 1
expect_error(flights_per_year(flights_per_time = flights_per_time, prop_day = prop_day, prop_year = 10)
             , "variable out of bounds")

## Zero flights_per_time or diameter gives 0 flights_per_year----------
expect_equal(flights_per_year(flights_per_time = 0, prop_day = prop_day, prop_year = prop_year), 0)
expect_equal(flights_per_year(flights_per_time = flights_per_time, prop_day = 0, prop_year = prop_year), 0)
expect_equal(flights_per_year(flights_per_time = flights_per_time, prop_day = prop_day, prop_year = 0), 0)

## Valid inputs give the correct result---------
expect_equal(flights_per_year(flights_per_time = flights_per_time, prop_day = prop_day, prop_year = prop_year)
             , flights_per_time * 365.25 * 24 * 60 * prop_day * prop_year)

