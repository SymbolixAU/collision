# extract data from distance model

Helper functions to extract data from a distance model object

## Usage

``` r
w_from_distmodel(ds_model)

edr_from_distmodel(ds_model)
```

## Arguments

- ds_model:

  an object of class `dsmodel` fit using
  [`Distance::ds`](https://rdrr.io/pkg/Distance/man/ds.html)

## References

Miller DL, Rexstad E, Thomas L, Marshall L, Laake JL (2019). "Distance
Sampling in R." Journal of Statistical Software, 89(1), 1–28. doi:
10.18637/jss.v089.i01.

## Examples

``` r
summary(ds_example) # example data
#> 
#> Summary for distance analysis 
#> Number of observations :  124 
#> Distance range         :  0  -  4 
#> 
#> Model       : Half-normal key function 
#> AIC         :  311.1385 
#> Optimisation:  mrds (nlminb) 
#> 
#> Detection function parameters
#> Scale coefficient(s):  
#>              estimate         se
#> (Intercept) 0.6632435 0.09981249
#> 
#>                        Estimate          SE         CV
#> Average p             0.5842744  0.04637627 0.07937412
#> N in covered region 212.2290462 20.85130344 0.09824906
w_from_distmodel(ds_example) # extract truncation parameter, w
#> [1] 4
edr_from_distmodel(ds_example) # extract effective detection radius
#> [1] 3.057514
```
