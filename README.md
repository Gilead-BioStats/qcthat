# Overview ✅

`{qcthat}` is a quality control framework for R packages used in Clinical Trials. It has been adopted from the qualification framework used in [`{gsm}`](https://github.com/Gilead-BioStats/gsm).

The benefit of using `{qcthat}` is that you are given a basic scaffold to build out a qualification testing strategy for your R package. This includes:

  - A qualification testing folder that lives inside of your `/tests` folder; designed to use with [`{testthat}`](https://testthat.r-lib.org/).
  - A basic `.Rmd` report that displays the results of qualification tests.
  - A `.github/workflows` folder that includes a templated YAML file, which will automate the creation of a qualification report for every new release of your R package. This can be easily customized to fit your needs. 

Read more in the [`{qcthat}` structure vignette}](https://solid-adventure-3764638.pages.github.io/articles/qcthat_structure.html).

# Contributing 👩‍💻

Contributions are welcome! Creating a utility package that is generalizable and extensible to all sorts of repository structures is challenging, and your input is greatly appreciated.

Before submitting a pull request, make sure to file an [issue](https://github.com/Gilead-BioStats/qcthat/issues), which should generally fall under one of the following categories:

  - Bugfix: something is broken.
  - Feature: something is wanted or needed.
  - QC: documentation or metadata is incorrect or missing.
  
New code should generally follow the [tidyverse style guide](https://style.tidyverse.org/). 
