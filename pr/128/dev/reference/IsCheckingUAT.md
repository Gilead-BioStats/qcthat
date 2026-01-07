# Detect whether the user is specifically checking UAT issues

Checks the value of an environment variable (default: `qcthat_UAT`) to
determine if the user is intentionally checking user-acceptance tests.

## Usage

``` r
IsCheckingUAT(strUATEnvVar = "qcthat_UAT")
```

## Arguments

- strUATEnvVar:

  (`length-1 character`) The name of the environment variable to check.

## Value

`TRUE` if the specified environment variable is set to `"TRUE"`
(case-insensitive), `FALSE` otherwise.

## Examples

``` r
CurrentValue <- Sys.getenv("qcthat_UAT")
Sys.setenv(qcthat_UAT = "")
IsCheckingUAT()
#> [1] FALSE
Sys.setenv(qcthat_UAT = "true")
IsCheckingUAT()
#> [1] TRUE
Sys.setenv(qcthat_UAT = CurrentValue)
```
