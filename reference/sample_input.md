# Sample value from chosen distribution

Returns sampled value for random or fixed inputs

## Usage

``` r
sample_input(input, ...)

# S3 method for class 'randInput'
sample_input(input, ..., n = 1)

# S3 method for class 'birdInput'
sample_input(input, ..., n = 1)

# S3 method for class 'turbineInput'
sample_input(input, ..., n = 1)

# Default S3 method
sample_input(input, ..., n = 1)
```

## Arguments

- input:

  an object of class `randInput` or `numeric`. See
  [set_random](https://symbolixau.github.io/collision/reference/set_random.md)
  for details

- ...:

  Additional parameters passed to methods.

- n:

  integer. The number of samples to draw. Defaults to 1.

## Examples

``` r
var1 <- set_random("runif", min = 0, max = 10) # sample 1 (default)
is.randInput(var1) # should be true
#> [1] TRUE
sample_input(var1) # random
#> [1] 0.3123033
sample_input(var1, n=10) # samole 10 values
#>  [1] 2.255625 3.008308 6.364656 4.790245 4.321713 7.064338 9.485766 1.803388
#>  [9] 2.168999 6.801629

sample_input(17)  # fixed input
#> [1] 17
sample_input(17, n=10)  # fixed input, replicated
#>  [1] 17 17 17 17 17 17 17 17 17 17
```
