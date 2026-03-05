# Calculate collision rate with static and dynamic avoidance

Calculate collision rate with static and dynamic avoidance

## Usage

``` r
n_collision(
  avoidance_rate_static,
  avoidance_rate_dynamic,
  n_flights,
  p_coll_static,
  p_coll_dynamic
)
```

## Arguments

- avoidance_rate_static:

  numeric; Number between 0 and 1 representing the avoidance rate of
  static components (tower + static presented area)

- avoidance_rate_dynamic:

  numeric; Number between 0 and 1 representing the avoidance rate of
  dynamic components (moving blade edge)

- n_flights:

  numeric; Flights though the turbine per unit time. Calculated from
  [`turbine_flights_year()`](https://symbolixau.github.io/collision/reference/turbine_flights_year.md)
  or similar.

- p_coll_static:

  numeric; the probability of collision with static turbine components
  if an interaction occurs and avoidance is zero. Calculated from
  [`prob_collision_static()`](https://symbolixau.github.io/collision/reference/prob_collision_static.md)

- p_coll_dynamic:

  numeric; the probability of collision with dynamic blade edge turbine
  components if an interaction occurs and avoidance is zero. Calculated
  from
  [`prob_collision_dynamic()`](https://symbolixau.github.io/collision/reference/prob_collision_dynamic.md)

## Value

numeric; number of collisions per unit time. Time interval is the same
as referenced by `n_flights` input.

## Examples

``` r
n_collision(
  avoidance_rate_static = 0.99,
  avoidance_rate_dynamic = c(0.90, 0.95),
  n_flights = 100,
  p_coll_static = 0.05,
  p_coll_dynamic = 0.03
)
#> [1] 0.35 0.20
```
