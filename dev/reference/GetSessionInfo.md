# Get session info from available reporting functions

Retrieve session info using either
[`sessioninfo::session_info()`](https://sessioninfo.r-lib.org/reference/session_info.html)
(if the `sessioninfo` package is installed) or
[`utils::sessionInfo()`](https://rdrr.io/r/utils/sessionInfo.html). The
former provides more detailed information about the R session and
installed packages.

## Usage

``` r
GetSessionInfo()
```

## Value

The raw session info as returned by either
[`sessioninfo::session_info()`](https://sessioninfo.r-lib.org/reference/session_info.html)
(if the `sessioninfo` package is installed) or
[`sessionInfo()`](https://rdrr.io/r/utils/sessionInfo.html).

## Examples

``` r
GetSessionInfo()
#> ─ Session info ───────────────────────────────────────────────────────────────
#>  setting  value
#>  version  R version 4.6.0 (2026-04-24)
#>  os       Ubuntu 24.04.4 LTS
#>  system   x86_64, linux-gnu
#>  ui       X11
#>  language en-US
#>  collate  C
#>  ctype    C.UTF-8
#>  tz       UTC
#>  date     2026-05-22
#>  pandoc   3.8.3 @ /opt/hostedtoolcache/pandoc/3.8.3/x64/ (via rmarkdown)
#>  quarto   1.9.37 @ /usr/local/bin/quarto
#> 
#> ─ Packages ───────────────────────────────────────────────────────────────────
#>  package     * version    date (UTC) lib source
#>  askpass       1.2.1      2024-10-04 [1] RSPM
#>  astgrepr      0.1.1      2025-06-07 [1] RSPM
#>  backports     1.5.1      2026-04-03 [1] RSPM
#>  base        * 4.6.0      2026-04-24 [3] local
#>  base64enc     0.1-6      2026-02-02 [1] RSPM
#>  boot          1.3-32     2025-08-29 [3] CRAN (R 4.6.0)
#>  brio          1.1.5      2024-04-24 [1] RSPM
#>  bslib         0.11.0     2026-05-16 [1] RSPM
#>  cachem        1.1.0      2024-05-16 [1] RSPM
#>  callr         3.7.6      2024-03-25 [1] RSPM
#>  checkmate     2.3.4      2026-02-03 [1] RSPM
#>  class         7.3-23     2025-01-01 [3] CRAN (R 4.6.0)
#>  cli           3.6.6      2026-04-09 [1] RSPM
#>  clipr         0.8.0      2022-02-22 [1] RSPM
#>  cluster       2.1.8.2    2026-02-05 [3] CRAN (R 4.6.0)
#>  codetools     0.2-20     2024-03-31 [3] CRAN (R 4.6.0)
#>  compiler      4.6.0      2026-04-24 [3] local
#>  covr          3.6.5      2025-11-09 [1] RSPM
#>  crayon        1.5.3      2024-06-20 [1] RSPM
#>  credentials   2.0.3      2025-09-12 [1] RSPM
#>  curl          7.1.0      2026-04-22 [1] RSPM
#>  datasets    * 4.6.0      2026-04-24 [3] local
#>  desc          1.4.3      2023-12-10 [1] RSPM
#>  diffobj       0.3.6      2025-04-21 [1] RSPM
#>  digest        0.6.39     2025-11-19 [1] RSPM
#>  downlit       0.4.5      2025-11-14 [1] RSPM
#>  dplyr         1.2.1      2026-04-03 [1] RSPM
#>  emoji         16.0.0     2024-10-28 [1] RSPM
#>  evaluate      1.0.5      2025-08-27 [1] RSPM
#>  fansi         1.0.7      2025-11-19 [1] RSPM
#>  fastmap       1.2.0      2024-05-15 [1] RSPM
#>  fontawesome   0.5.3      2024-11-16 [1] RSPM
#>  foreign       0.8-91     2026-01-29 [3] CRAN (R 4.6.0)
#>  fs            2.1.0      2026-04-18 [1] RSPM
#>  generics      0.1.4      2025-05-09 [1] RSPM
#>  gert          2.3.1      2026-01-11 [1] RSPM
#>  gh            1.5.0.9000 2026-05-22 [1] Github (jharmon-gilead/gh@6400826)
#>  git2r         0.36.2     2025-03-29 [1] RSPM
#>  gitcreds      0.1.2      2022-09-08 [1] RSPM
#>  glue          1.8.1      2026-04-17 [1] RSPM
#>  graphics    * 4.6.0      2026-04-24 [3] local
#>  grDevices   * 4.6.0      2026-04-24 [3] local
#>  grid          4.6.0      2026-04-24 [3] local
#>  gsm.utils     0.3.1      2026-05-15 [1] Github (gilead-biostats/gsm.utils@4ddd5c0)
#>  here          1.0.2      2025-09-15 [1] RSPM
#>  highr         0.12       2026-03-06 [1] RSPM
#>  htmltools     0.5.9      2025-12-04 [1] RSPM
#>  httr          1.4.8      2026-02-13 [1] RSPM
#>  httr2         1.2.2      2025-12-08 [1] RSPM
#>  ini           0.3.1      2018-05-20 [1] RSPM
#>  jquerylib     0.1.4      2021-04-26 [1] RSPM
#>  jsonlite      2.0.0      2025-03-27 [1] RSPM
#>  KernSmooth    2.23-26    2025-01-01 [3] CRAN (R 4.6.0)
#>  knitr         1.51       2025-12-20 [1] RSPM
#>  later         1.4.8      2026-03-05 [1] RSPM
#>  lattice       0.22-9     2026-02-09 [3] CRAN (R 4.6.0)
#>  lifecycle     1.0.5      2026-01-08 [1] RSPM
#>  magrittr      2.0.5      2026-04-04 [1] RSPM
#>  MASS          7.3-65     2025-02-28 [3] CRAN (R 4.6.0)
#>  Matrix        1.7-5      2026-03-21 [3] CRAN (R 4.6.0)
#>  memoise       2.0.1      2021-11-26 [1] RSPM
#>  methods     * 4.6.0      2026-04-24 [3] local
#>  mgcv          1.9-4      2025-11-07 [3] CRAN (R 4.6.0)
#>  mime          0.13       2025-03-17 [1] RSPM
#>  nlme          3.1-169    2026-03-27 [3] CRAN (R 4.6.0)
#>  nnet          7.3-20     2025-01-01 [3] CRAN (R 4.6.0)
#>  openssl       2.4.1      2026-05-14 [1] RSPM
#>  pak           0.9.5      2026-04-27 [2] local
#>  parallel      4.6.0      2026-04-24 [3] local
#>  pillar        1.11.1     2025-09-17 [1] RSPM
#>  pkgbuild      1.4.8      2025-05-26 [1] RSPM
#>  pkgconfig     2.0.3      2019-09-22 [1] RSPM
#>  pkgdown       2.2.0      2025-11-06 [1] RSPM
#>  pkgload       1.5.2      2026-04-22 [1] RSPM
#>  praise        1.0.0      2015-08-11 [1] RSPM
#>  processx      3.9.0      2026-04-22 [1] RSPM
#>  ps            1.9.3      2026-04-20 [1] RSPM
#>  purrr         1.2.2      2026-04-10 [1] RSPM
#>  qcthat      * 1.1.2.9000 2026-05-22 [1] local
#>  quarto        1.5.1      2025-09-04 [1] RSPM
#>  R6            2.6.1      2025-02-15 [1] RSPM
#>  ragg          1.5.2      2026-03-23 [1] RSPM
#>  rappdirs      0.3.4      2026-01-17 [1] RSPM
#>  Rcpp          1.1.1-1.1  2026-04-24 [1] RSPM
#>  rex           1.2.2      2026-03-28 [1] RSPM
#>  rlang         1.2.0      2026-04-06 [1] RSPM
#>  rmarkdown     2.31       2026-03-26 [1] RSPM
#>  rpart         4.1.27     2026-03-27 [3] CRAN (R 4.6.0)
#>  rprojroot     2.1.1      2025-08-26 [1] RSPM
#>  rrapply       1.2.8      2025-11-25 [1] RSPM
#>  rstudioapi    0.18.0     2026-01-16 [1] RSPM
#>  rvest         1.0.5      2025-08-29 [1] RSPM
#>  sass          0.4.10     2025-04-11 [1] RSPM
#>  selectr       0.5-1      2025-12-17 [1] RSPM
#>  sessioninfo   1.2.3      2025-02-05 [1] RSPM
#>  spatial       7.3-18     2025-01-01 [3] CRAN (R 4.6.0)
#>  splines       4.6.0      2026-04-24 [3] local
#>  stats       * 4.6.0      2026-04-24 [3] local
#>  stats4        4.6.0      2026-04-24 [3] local
#>  stringi       1.8.7      2025-03-27 [1] RSPM
#>  stringr       1.6.0      2025-11-04 [1] RSPM
#>  survival      3.8-6      2026-01-16 [3] CRAN (R 4.6.0)
#>  sys           3.4.3      2024-10-04 [1] RSPM
#>  systemfonts   1.3.2      2026-03-05 [1] RSPM
#>  tcltk         4.6.0      2026-04-24 [3] local
#>  testthat      3.3.2      2026-01-11 [1] RSPM
#>  textshaping   1.0.5      2026-03-06 [1] RSPM
#>  tibble        3.3.1      2026-01-11 [1] RSPM
#>  tidyr         1.3.2      2025-12-19 [1] RSPM
#>  tidyselect    1.2.1      2024-03-11 [1] RSPM
#>  tinytex       0.59       2026-03-28 [1] RSPM
#>  tools         4.6.0      2026-04-24 [3] local
#>  usethis       3.2.1      2025-09-06 [1] RSPM
#>  utf8          1.2.6      2025-06-08 [1] RSPM
#>  utils       * 4.6.0      2026-04-24 [3] local
#>  vctrs         0.7.3      2026-04-11 [1] RSPM
#>  waldo         0.6.2      2025-07-11 [1] RSPM
#>  whisker       0.4.1      2022-12-05 [1] RSPM
#>  withr         3.0.2      2024-10-28 [1] RSPM
#>  xfun          0.57       2026-03-20 [1] RSPM
#>  xml2          1.5.2      2026-01-17 [1] RSPM
#>  yaml          2.3.12     2025-12-10 [1] RSPM
#>  zip           2.3.3      2025-05-13 [1] RSPM
#> 
#>  [1] /home/runner/work/_temp/Library
#>  [2] /opt/R/4.6.0/lib/R/site-library
#>  [3] /opt/R/4.6.0/lib/R/library
#>  * ── Packages attached to the search path.
#> 
#> ──────────────────────────────────────────────────────────────────────────────
```
