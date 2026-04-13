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

## See also

Other UAT functions:
[`CommentUAT()`](https://gilead-biostats.github.io/qcthat/reference/CommentUAT.md),
[`ExpectUserAccepts()`](https://gilead-biostats.github.io/qcthat/reference/ExpectUserAccepts.md),
[`TriggerUAT()`](https://gilead-biostats.github.io/qcthat/reference/TriggerUAT.md)

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
