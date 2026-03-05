# make a list of bird parameters for input into CRM

Makes a list of avian biological parameters for the bird(s) being
modelled as a function directly in R. This function is designed for
R-based workflows. A function define_bird_csv can be used to bulk upload
parameters for multiple birds.

## Usage

``` r
define_bird(
  species,
  bird_length,
  bird_speed,
  prop_day,
  prop_year,
  avoidance_dynamic,
  avoidance_static
)
```

## Arguments

- species:

  char; species identifier

- bird_length:

  Length of archetype bird (metres), or distribution information using
  [set_random](https://symbolixau.github.io/collision/reference/set_random.md)

- bird_speed:

  numeric; Average flight speed (m/sec), or distribution information
  using
  [set_random](https://symbolixau.github.io/collision/reference/set_random.md)

- prop_day:

  proportion of the day the bird is active onsite

- prop_year:

  proportion of the year (relative to the time period of the survey) the
  bird is active onsite

- avoidance_dynamic:

  avoidance rate relative to the leading edge of the blade

- avoidance_static:

  avoidance rate relative to a static turbine

## Value

list where items define the value or stochastic distribution f or each
parameter

## Details

Each input to this function must be either

- an object of the `class` `randInput`. See
  [set_random](https://symbolixau.github.io/collision/reference/set_random.md)
  for more information on setting up stochastic inputs.

- a single number representing the average (preferably median) of the
  variable

## Examples

``` r
lst_bird <- define_bird(
  species = 'biggus raptorus',
  bird_length = set_random("rnorm", mean = 90, sd = 5), # (metres)
  bird_speed = set_random("rnorm", mean = 16.67, sd = 3), # m/s
  prop_day = 0.5,
  prop_year = set_random("runif", min = 0.5, max = 0.6),
  avoidance_dynamic = 0.95,
  avoidance_static = 0.999
)
```
