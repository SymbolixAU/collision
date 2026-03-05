# Define how to sample a random input

Stochastic input definitions using the analysts choice of base R sample
distributions. Method to extend the
[sample_input](https://symbolixau.github.io/collision/reference/sample_input.md)
function

## Usage

``` r
set_random(distr, ...)

is.randInput(x)
```

## Arguments

- distr:

  string. The name of the R function to return random deviates (e.g.
  `runif`, `rnorm`). See vignettes for examples of fitting to an
  empirical distribution.

- ...:

  Additional parameters passed to the function `distr`. Do *not* set `n`
  (number of samples) here. This is set in
  [sample_input](https://symbolixau.github.io/collision/reference/sample_input.md)
  to separate the simulation settings and statistical distribution
  definition.

- x:

  object to check

## See also

[sample_input](https://symbolixau.github.io/collision/reference/sample_input.md)
to sample a value according to the definition.

## Examples

``` r
# sample from standard R functions
set_random("runif", min = 0, max = 10)
#> $distr
#> [1] "runif"
#> 
#> $params
#> $params$min
#> [1] 0
#> 
#> $params$max
#> [1] 10
#> 
#> 
#> attr(,"class")
#> [1] "randInput"
set_random("runif", n = 1, min = 0, max = 10) # n is ignored
#> Warning: 'n' will be ignored. Please set in inputs to `sample_input` instead.
#> $distr
#> [1] "runif"
#> 
#> $params
#> $params$n
#> [1] 1
#> 
#> $params$min
#> [1] 0
#> 
#> $params$max
#> [1] 10
#> 
#> 
#> attr(,"class")
#> [1] "randInput"

set_random("rbeta", shape1 = 1, shape2 = 3, ncp = 0)
#> $distr
#> [1] "rbeta"
#> 
#> $params
#> $params$shape1
#> [1] 1
#> 
#> $params$shape2
#> [1] 3
#> 
#> $params$ncp
#> [1] 0
#> 
#> 
#> attr(,"class")
#> [1] "randInput"
set_random("rgamma", shape = 1, rate = 1, scale = 1)
#> $distr
#> [1] "rgamma"
#> 
#> $params
#> $params$shape
#> [1] 1
#> 
#> $params$rate
#> [1] 1
#> 
#> $params$scale
#> [1] 1
#> 
#> 
#> attr(,"class")
#> [1] "randInput"
```
