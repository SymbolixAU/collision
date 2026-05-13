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
#> [1] 6.007609
sample_input(var1, n=10) # samole 10 values
#>  [1] 1.57208442 0.07399441 4.66393497 4.97777389 2.89767245 7.32881987
#>  [7] 7.72521511 8.74600661 1.74940627 0.34241333

sample_input(17)  # fixed input
#> [1] 17
sample_input(17, n=10)  # fixed input, replicated
#>  [1] 17 17 17 17 17 17 17 17 17 17
```
